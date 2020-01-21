update user set plugin="mysql_native_password" , authentication_string=password("123456") where User="root";

csv导入
load data infile 'xxx.csv' into table tp_heavy_trunk_branck_load_rate_daily FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';
如果报错
ERROR 1290 (HY000): The MySQL server is running with the --secure-file-priv option so it cannot execute this statement
是因为文件目录不在可信范围， 查看可用目录
SHOW VARIABLES LIKE "secure_file_priv";
+------------------+-----------------------+
| Variable_name    | Value                 |
+------------------+-----------------------+
| secure_file_priv | /var/lib/mysql-files/ |
+------------------+-----------------------+
将文件移动到该目录下，再导入。

后遇到csv的字段多于表字段，导入失败报
ERROR 1262 (01000): Row 1 was truncated; it contained more data than there were input columns 
改sql_mode就行
show variables like '%sql_mode%';
+---------------+-------------------------------------------------------------------------------------------------------------------------------------------+                                               
| Variable_name | Value                                                                                                                                     |                                               
+---------------+-------------------------------------------------------------------------------------------------------------------------------------------+                                               
| sql_mode      | ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION |                                               
+---------------+-------------------------------------------------------------------------------------------------------------------------------------------+  

去掉STRICT_TRANS_TABLES
set sql_mode="ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
再次导入成功

常用参数（跟 LOAD DATA INFILE 语法一样）：
FIELDS TERMINATED BY ','：指定字段分隔符
OPTIONALLY ENCLOSED BY '"'：认为双引号中的是一个独立的字段。Excel 转 CSV 时，有特殊字符（逗号、顿号等）的字段，会自动用双引号引起来
LINES TERMINATED BY '\n'：指定行分隔符，注意，在 Windows 平台上创建的文件，分隔符是 '\r\n'


乱码问题
SHOW VARIABLES LIKE 'character%';

SET character_set_client = utf8;
SET character_set_connection = utf8;
SET character_set_database = utf8;
SET character_set_results = utf8;
SET character_set_server = utf8;
SET character_set_system = utf8;

mysql 删除数据但是空间没减少,可以重建表（alter table a engine="innodb"）
delete语句删除数据在该行标记"可复用"
在delete语句时可能造成数据页中存在空洞
这种空洞在insert时也有可能出现（在插入时页分裂时会造成空洞）
所以重建表实际上是建立个临时表，将数据写入再替换，5.6之后可以支持online操作，就是加了个对原表修改的redolog。

统计mysql库中所有表的数据条数：
select table_name,table_rows from information_schema.tables where TABLE_SCHEMA = "databasename" order by table_rows asc;

导出csv
select * from tablename into outfile '/var/lib/mysql-files/out.csv' fields terminated by ',' optionally enclosed by '"' lines terminated by '\n';
以','分割
双引号转义

查看general_log 配置
show global variables like '%general%';
开启general_log
mysql>set global general_log_file='/tmp/general.lg';    #设置路径
mysql>set global general_log=on;    # 开启general log模式

mysql授权
grant all privileges on *.* to 'root'@'192.168.237.128' identified by '123456'；
GRANT ALL PRIVILEGES ON . TO 'root'@'%' WITH GRANT OPTION;
刷新权限
flush privileges;

cenos7 安装mysql57
下载到mysql80的yum源
yum localinstall https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm -y
sudo yum-config-manager --disable mysql80-community
sudo yum-config-manager --enable mysql57-community

# 确认版本
sudo yum repolist enabled | grep "mysql.*-community.*"
安装
sudo yum install mysql-community-server -y

卸载
rpm -qa | grep mysql | xargs yum remove -y
rm -rf /var/lib/mysql
rm -rf /usr/share/mysql
rm -rf /etc/my.cnf
rm -rf /var/log/mysqld.log

启动mysql
systemctl start mysqld

查询默认密码
sudo grep 'temporary password' /var/log/mysqld.log

设置密码等初始化动作
sudo mysql_secure_installation
设置密码后要确认密码，一个密码会让输入4次。。。

存储过程：
drop procedure if exists batchInsert;
delimiter //
create procedure batchInsert()
begin
    declare num int; 
    set num=1;
    while num<=100000 do
        insert into t values(num,num);
        set num=num+1;
    end while;
end
// 
delimiter ; #恢复;表示结束

call batchInsert();


一个正常查询慢的情况有以下几种：
select * from t where id=1;
查询长时间不返回
1. 等待MDL锁
复现方式：

| SessionA  | SessionB |
|---|---|
| lock table t write;| |
| | select * from t where id=1; | 

show processlist; 
会显示select语句正在等待锁：
Waiting for table metadata lock
解决方式： 
kill掉

1. 等flush
复现：
| SessionA  | SessionB   |SessionC   |
| ------------ | ------------ | ------------ |
|  select sleep(1) from t; |   |   |
|   |  flush tables t; |   |
|   | | select * from t  where id=1 |
show processlist; 
Waiting for table flush
解决方式：
kill 掉

1. 等行锁
复现：
| SessionA  | SessionB |
| --- | --- |
| begin; <br> update t set c=c+1 where id=1;| |
| | select * from t where id=1 lock in share mode; |
show processlist; 
Waiting for table flush
mysql>  select * from sys.innodb_lock_waits where locked_table='`mysql45_19`.`t`'\G
*************************** 1. row ***************************
                wait_started: 2020-01-21 19:00:03
                    wait_age: 00:00:03
               wait_age_secs: 3
                locked_table: `mysql45_19`.`t`
                locked_index: PRIMARY
                 locked_type: RECORD
              waiting_trx_id: 421618058206832
         waiting_trx_started: 2020-01-21 19:00:03
             waiting_trx_age: 00:00:03
     waiting_trx_rows_locked: 1
   waiting_trx_rows_modified: 0
                 waiting_pid: 48
               waiting_query: select * from t where id=1 lock in share mode
             waiting_lock_id: 421618058206832:23:4:2
           waiting_lock_mode: S
             blocking_trx_id: 31373
                blocking_pid: 54
              blocking_query: NULL
            blocking_lock_id: 31373:23:4:2
          blocking_lock_mode: X
        blocking_trx_started: 2020-01-21 18:57:32
            blocking_trx_age: 00:02:34
    blocking_trx_rows_locked: 1
  blocking_trx_rows_modified: 1
     sql_kill_blocking_query: KILL QUERY 54
sql_kill_blocking_connection: KILL 54
1 row in set, 3 warnings (0.00 sec)

解决方式：
54号线程是罪魁祸首，kill掉

第二类： 查询慢
select * from t where c=50000 limit 1;
由于c字段没有索引，所以只能走逐渐顺序扫描， 因此扫描5w行
explain 之后会看到rows字段是扫描行数为50000
开启慢查询：
show variables like "%slow%";
set GLOBAL slow_query_log=ON;

set long_query_time=0; 将慢查询日志时间阈值设置为0。
慢查询日志中：
# Time: 2020-01-21T11:17:58.500542Z
# User@Host: root[root] @ localhost []  Id:    55
# Query_time: 0.021095  Lock_time: 0.000110 Rows_sent: 1  Rows_examined: 100000
SET timestamp=1579605478;
select * from t where c=50000;

看到Rows_examined: 10w行。
虽然不慢，是因为数据量不够。所以坏查询不一定是慢查询；

下面看一个只扫描一行，但执行很慢的语句；

select * from t where id=1; 
select * from t where id=1 lock in share mode;
第一条比第二条慢；
复现方式：
| SessionA  | SessionB |
| --- | --- |
| start transaction with consistent snapshot;| |
| | update t set c=c+1 where id=1; // 执行100万次 |
| select * from t where id=1; | |
| select * from t where id=1 lock in share mode; |  |








