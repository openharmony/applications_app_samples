#!/bin/bash

# 在iptables防火墙的FORWARD链中添加规则，允许网络数据包的转发
iptables -I FORWARD -j ACCEPT

# 启用IP转发
echo 1 > /proc/sys/net/ipv4/ip_forward

# 命令用于配置iptables防火墙的网络地址转换（NAT）规则
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth1 -j MASQUERADE

# 创建服务器
sudo ./server

