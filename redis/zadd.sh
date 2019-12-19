#!/bin/bash

cli="redis-cli -h 127.0.0.1 -p 6379 "
$cli zadd power_rank 4000 liubei
$cli zadd power_rank 5000 guanyu
$cli zadd power_rank 4500 zhangfei
$cli zadd power_rank 8000 lvbu
$cli zadd power_rank 7000 zhaozinong
$cli zadd power_rank 2000 huaxiong

$cli zrevrange power_rank 0 4 withscores
