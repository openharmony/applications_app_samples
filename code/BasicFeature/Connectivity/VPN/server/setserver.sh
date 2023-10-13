#!/bin/bash
# ----------------------------------------------------------------------------
# Copyright (c) 2023 Huawei Device Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------

# 在iptables防火墙的FORWARD链中添加规则，允许网络数据包的转发
iptables -I FORWARD -j ACCEPT

# 启用IP转发
echo 1 > /proc/sys/net/ipv4/ip_forward

# 创建服务器
sudo ./server

