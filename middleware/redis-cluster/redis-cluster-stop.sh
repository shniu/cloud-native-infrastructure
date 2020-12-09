#!/bin/bash

redis-cli -h 127.0.0.1 -p 7000 shutdown save
redis-cli -h 127.0.0.1 -p 7001 shutdown save

redis-cli -h 127.0.0.1 -p 7002 shutdown save
redis-cli -h 127.0.0.1 -p 7003 shutdown save

redis-cli -h 127.0.0.1 -p 7004 shutdown save
redis-cli -h 127.0.0.1 -p 7005 shutdown save