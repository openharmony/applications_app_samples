#!/usr/bin/env python
# # -*- coding: utf-8 -*-
# Copyright (c) 2023 Huawei Device Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import socket
import ssl
import threading


# 处理客户端消息的线程函数
def handle_client(conn):
    # 使用SSL包装socket对象
    conn = context.wrap_socket(conn, server_side=True)

    # 将新客户端连接加入列表
    clients.append(conn)

    # 循环接收和发送消息
    while True:
        # 接收客户端数据
        data = conn.recv(1024)
        print('data recv ', data.decode())

        # 发送消息给所有客户端
        for client in clients:
            if client != conn:
                client.send(data)


# 处理客户端连接的线程函数
def accept_clients():
    while True:
        # 接受客户端连接请求
        conn, addr = server_socket.accept()
        print('accept ', addr)

        # 创建新线程处理客户端消息
        client_thread = threading.Thread(target=handle_client, args=(conn,))
        client_thread.start()


if __name__ == '__main__':
    # 创建socket对象
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # 绑定IP地址和端口号，此处IP地址与运行服务端的本机一致，端口号与客户端端口一致
    server_socket.bind(('192.168.18.57', 9090))

    # 监听客户端连接
    server_socket.listen(5)

    # 加载SSL证书
    context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
    context.set_ciphers('ALL:@SECLEVEL=0')
    context.load_cert_chain(certfile="server/server.crt", keyfile="server/server.key")
    context.load_verify_locations(cafile="ca/ca.crt")

    # 存储所有客户端连接的列表
    clients = []

    # 启动处理客户端连接的线程
    accept_thread = threading.Thread(target=accept_clients)
    accept_thread.start()
