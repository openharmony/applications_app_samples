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

def tcp_server():
    # 创建一个 TCP 套接字
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # 绑定地址和端口
    host = "192.168.xxx.xxx"  # 本地主机地址
    port = 5555        # 监听端口
    server_socket.bind((host, port))

    # 开始监听
    server_socket.listen(5)
    print(f"Server listening on {host}:{port}")

    try:
        while True:
            # 接受客户端连接
            client_socket, client_address = server_socket.accept()
            print(f"Connection from {client_address}")

            # 接收客户端发送的数据
            data = client_socket.recv(1024)  # 缓冲区大小为 1024 字节
            print(f"Received data: {data.decode()}")

            # 向客户端发送响应
            client_socket.send("Hello from server!".encode())

            # 关闭客户端连接
            #client_socket.close()
    except KeyboardInterrupt:
        print("Server is shutting down.")
    finally:
        server_socket.close()

if __name__ == "__main__":
    tcp_server()