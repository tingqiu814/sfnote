#!/bin/bash 

. ~/common.conf.sh

echo $lmysql

echo "create database mysql45"

sql='create table t (
id int(8) ,
name varchar(16)
) engine=InnoDB default charset=utf8;
' 
echo $sql | $lmysql

for i in {1..10000}; do 
	echo 'insert into t values ('$i', "name'$i'");' | $lmysql
done
