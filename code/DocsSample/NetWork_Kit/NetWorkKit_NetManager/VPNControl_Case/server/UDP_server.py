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

# 配置服务器地址和端口
SERVER_IP = "192.168.xxx.xxx"  # 监听所有IP
SERVER_PORT = 8888     # UDP端口

# 创建UDP Socket
server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  # 使用 UDP 协议
server_socket.bind((SERVER_IP, SERVER_PORT))

print(f"VPN Server is running on {SERVER_IP}:{SERVER_PORT}")

while True:
    # 接收UDP数据包
    data, client_address = server_socket.recvfrom(1024)  # 接收 UDP 数据
    print(f"Connection established with {client_address}")

    # 直接打印原始字节数据
    print(f"Received: {data}")

    # 如果你需要解码为字符串并且确定数据是有效的文本
    try:
        print(f"Decoded data: {data.decode('utf-8')}")
    except UnicodeDecodeError:
        print("Received non-text data, cannot decode as UTF-8.")

    # 回传数据（可自定义处理）
    server_socket.sendto(data, client_address)  # 使用 sendto 发送数据