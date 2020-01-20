#!/bin/bash 

redis-server --requirepass redispassword --port 6300 2>&1 >> redis-server-6300.log & 
redis-server --requirepass redispassword --port 6301 2>&1 >> redis-server-6301.log & 
redis-server --requirepass redispassword --port 6302 2>&1 >> redis-server-6302.log & 

sleep 2
echo "config set masterauth redispassword" | redis-cli -a redispassword -p 6300

echo "slaveof  127.0.0.1 6300" | redis-cli -a redispassword -p 6301
echo "config set masterauth redispassword" | redis-cli -a redispassword -p 6301

echo "slaveof  127.0.0.1 6300" | redis-cli -a redispassword -p 6302
echo "config set masterauth redispassword" | redis-cli -a redispassword -p 6302

# 启动哨兵
redis-sentinel sentinel1.conf \
&& redis-sentinel sentinel2.conf \
&& redis-sentinel sentinel3.conf \ 

# echo monitor | redis-cli -a redispassword -p 6300 |  grep -v "PING\|hello\|INFO"
# echo monitor | redis-cli -a redispassword -p 6301 |  grep -v "PING\|hello\|INFO"
# echo monitor | redis-cli -a redispassword -p 6302 |  grep -v "PING\|hello\|INFO"
