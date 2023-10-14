/*
* Copyright (c) 2023 Huawei Device Co., Ltd.
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

#include <iostream>
#include <thread>
#include <cstring>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <thread>

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include "../common.h"

#define PORT 8888
#define BUFFER_SIZE 2048

extern void WriteToTunfd(void* buffer, int32_t len);
extern int ReadFromTunfd(void* buffer, int32_t len);

struct ClientInfo {
    int sockfd = 0;
};

static bool threadRunF;
struct sockaddr_in client_address;

void handle_connection(ClientInfo clientInfo) {
    int addrlen = sizeof(struct sockaddr_in);
    uint8_t buffer[BUFFER_SIZE] = {0};
    while (threadRunF) {
        int length = recvfrom(clientInfo.sockfd, buffer, sizeof(buffer), 0, (struct sockaddr *)&client_address, (socklen_t*)&addrlen);
        if (length <= 0) {
            logger_error("Failed to recvfrom data");
            continue;
        }

        logger_info("from [%s:%d] data: %s, len: %d", inet_ntoa(client_address.sin_addr), ntohs(client_address.sin_port), buffer, length);
        WriteToTunfd(buffer, length);
    }
}

void HandleTunReceived(ClientInfo clientInfo) {
    char buffer[BUFFER_SIZE] = {0};
    int addrlen = sizeof(struct sockaddr_in);
    while (threadRunF) {
        int ret = ReadFromTunfd(buffer, sizeof(buffer));
        if (ret <= 0) {
            continue;
        }

        ret = sendto(clientInfo.sockfd, buffer, ret, 0, (struct sockaddr *)&client_address, addrlen);
        if (ret <= 0) {
            logger_error("!!! send to client failed, ret: %d, error: %s", ret, strerror(errno));
            std::cout << "client info " << inet_ntoa(client_address.sin_addr) << ":" << 
                    ntohs(client_address.sin_port) << " clent fd: " << clientInfo.sockfd << "\n";
            continue;
        }
    }
}

void StartTcpServer() {
    int server_sockfd = 0;
    struct sockaddr_in server_address;

    if ((server_sockfd = socket(AF_INET, SOCK_DGRAM, 0)) <= 0) {
        logger_error("Failed to create socket");
        return ;
    }    

    int on = 1;
    setsockopt(server_sockfd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));
    setsockopt(server_sockfd, SOL_SOCKET, SO_REUSEPORT, &on, sizeof(on));

    server_address.sin_family = AF_INET;
    server_address.sin_addr.s_addr = INADDR_ANY;
    server_address.sin_port = htons(PORT);

    if (bind(server_sockfd, (struct sockaddr *)&server_address, sizeof(server_address)) < 0) {
        logger_error("Failed to bind socket");
        return ;
    }

    logger_info("Server started listening on port: %d", PORT);

    ClientInfo clientInfo;
    clientInfo.sockfd = server_sockfd;         

    threadRunF = true;
    std::thread(handle_connection, clientInfo).detach();
    std::thread(HandleTunReceived, clientInfo).detach();
    return ;
}
