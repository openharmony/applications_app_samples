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

#include <stdio.h>
#include <string.h>
#include <linux/if_tun.h>
#include <sys/types.h>
#include <net/if.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <errno.h>

#include "../common.h"

extern void StartUdpServer();
 
static int tun_fd;
 
int CreateTunDevice(const char* tunName)
{
    int fd = open("/dev/net/tun", O_RDWR);
    if (fd <= 0) {
        logger_error("open failed: %s", strerror(errno));
        return 0;
    }
 
    struct ifreq ifr;
    memset(&ifr, 0, sizeof(ifr));
    strncpy(ifr.ifr_name, tunName, IFNAMSIZ);
   
    ifr.ifr_flags |= IFF_TUN | IFF_NO_PI;
    ioctl(fd, TUNSETIFF, (void *)&ifr);

    logger_info("tun device name: %s", ifr.ifr_name);
    return fd;
}

void WriteToTunfd(void* buffer, int32_t len)
{
    int ret = write(tun_fd, buffer, len);
    if (ret <= 0) {
        logger_info("error WriteToTunfd, ret: %d, errno: %s, len: %d", ret, strerror(errno), len);
    } else {
        logger_info("success WriteToTunfd, ret: %d", ret);
    }
}

int ReadFromTunfd(void* buffer, int32_t len)
{
    return read(tun_fd, buffer, len);
}

int main(int argc, char *argv[])
{
    tun_fd = CreateTunDevice("tun-vpn");
    if (tun_fd <= 0) {
        logger_error("tun_create");
        return 1;
    }
    logger_info("TUN name is tun-vpn");

    system("ifconfig tun-vpn 10.0.0.10/24 up");

    StartUdpServer();

    while (1) {
        sleep(100);
    }

    return 0;
}



