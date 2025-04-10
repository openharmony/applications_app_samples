/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
import socket

# 定义服务器地址和端口
server_ip = "192.168.xxx.xxx"     # 服务器 IP 地址
server_port = 5555                      # 服务器端口

# 创建一个 UDP 套接字
udp_client = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# 绑定本地端口（如果需要接收响应的话）
udp_client.bind(('192.168.xxx.xxx', 5555))  # 监听本地 5555 端口

# 要发送的消息
message = "Hello from client!"

# 发送消息到服务器
udp_client.sendto(message.encode(), (server_ip, server_port))
print(f"Sent message: {message} to {server_ip}:{server_port}")

# 接收服务器的响应
data, server = udp_client.recvfrom(1024)  # 接收最大 1024 字节的数据
print(f"Received response from server: {data.decode()}")

# 关闭客户端套接字
udp_client.close()