/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http:*www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
 */
// 模拟流媒体服务，两个client互相发送音频数据

const net = require('net');

const HOST = '127.0.0.1';
const PORT = 8979;

const server = net.createServer();
server.listen(PORT, HOST);
console.log('服务端已启动');
const clients = {}; //保存客户端的连接

// 重要：双方建立链接时，会自动获得一个socket对象（std，socket描述符）
server.on('connection', (socket) => {
  onAccept(socket)
});

function onAccept(client) {
  // 远程客户端地址
  console.log(`connected:${client.remoteAddress}:${client.remotePort}`);
  delete clients[client.remoteAddress+client.remotePort];
  clients[client.remoteAddress+client.remotePort] = client;
  console.log(`当前客户端连接数:${Object.keys(clients).length}`);
  // 收到客户端数据时
  client.on('data', (data) => {
    broadcast(data, client)
  });
  // 客户端主动断连，触发end事件
  client.on('end', () => {
    console.log(`客户端${client.remoteAddress}:${client.remotePort}已断连`);
  });
  client.on('close', (hadError) => {
    console.log(`客户端${client.remoteAddress}:${client.remotePort}已关闭`);
    delete clients[client.remoteAddress+client.remotePort];
    console.log(`当前客户端连接数:${Object.keys(clients).length}`);
  });

  client.on('error', (err) => {
    console.log(`客户端错误 ${JSON.stringify(err)}`);
  });
}

/**
 * 广播消息
 */
function broadcast(msg, self) {
  Object.keys(clients).forEach((ip) => {
    if (clients[ip].remoteAddress + clients[ip].remotePort != self.remoteAddress + self.remotePort) {
      clients[ip].write(msg);
    }
  });
}