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

def tcp_client():
    # 创建一个 TCP 套接字
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # 服务器地址和端口
    server_ip = '192.168.xxx.xxx'  # 服务端 IP
    server_port = 5555            # 服务端端口

    try:
        # 连接到服务端
        client_socket.connect((server_ip, server_port))
        print(f"Connected to server {server_ip}:{server_port}")

        while True:
            # 发送消息到服务端
            message = input("Enter message to send to server: ")
            client_socket.sendall(message.encode())
            print(f"Sent message: {message}")

            # 接收来自服务端的响应
            response = client_socket.recv(1024).decode()
            print(f"Received from server: {response}")

            if message.lower() == "exit":
                print("Exiting communication.")
                break

    except Exception as e:
        print(f"Error: {e}")
    finally:
        # 关闭连接
        client_socket.close()
        print("Connection closed.")

if __name__ == "__main__":
    tcp_client()