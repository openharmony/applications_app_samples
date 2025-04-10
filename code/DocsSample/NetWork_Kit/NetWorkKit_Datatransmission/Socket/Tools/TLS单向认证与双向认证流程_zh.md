# TLS单向认证与双向认证流程：

说明：此流程用于Socket连接示例项目中的TLS相关操作，需在具备Linux的设备上完成证书配置。配置完成后，证书需根据需求部署到两台能够连接同一热点的设备上，其中一台作为服务端，另一台作为客户端。



## 一.单向认证流程：适用于（单向TLS Socket加密数据传输、TCP升级为单向TLS Socket加密数据传输）

#### 1.生成所需要的证书配置文件（文件名：server_cert.cnf）

输入以下命令：

```
vi server_cert.cnf
```

填入以下内容：

```
[ req ]
default_bits       = 2048
default_keyfile    = server.key
distinguished_name = req_distinguished_name
x509_extensions    = v3_req
prompt             = no

[ req_distinguished_name ]
C  = XX
ST = XX
L  = XX
O  = XX
OU = XX
CN = 192.168.xxx.xxx
emailAddress = xxxx@example.com

[ v3_req ]
subjectAltName = @alt_names

[ alt_names ]
IP.1 = 192.168.xxx.xxx


##需要修改把两个ip地址均修改为服务端ip地址
```



#### 2.进行服务端与客户端的证书配置（依次执行以下命令）

```
#客户端
#生成ca私钥
openssl genrsa -out ca_key.pem 2048

#生成自签名 CA 证书
openssl req -x509 -new -nodes -key ca_key.pem -sha256 -days 365 -out ca_cert.pem -subj "/C=CN/ST=State/L=City/O=MyCA/CN=root"


#服务端
#生成服务器私钥
openssl genrsa -out server_key.pem 2048

#根据配置文件server_cert.cnf生成CSR文件
openssl req -new -key server_key.pem -out server_csr.pem -config server_cert.cnf

#使用 CA 签发服务器证书
openssl x509 -req -in server_csr.pem -CA ca_cert.pem -CAkey ca_key.pem -CAcreateserial -out server_cert.pem -days 365 -extensions v3_req -extfile server_cert.cnf
```



#### 3.需要使用的文件

```
服务端：
server_cert.pem

server_key.pem

客户端：
ca_cert.pem
```

#### 4.分配服务端和客户端所需要的文件（需要另外一台有python环境的设备作为服务端）

服务端：

```
服务端在此可以选择使用python脚本启动，脚本文件需要与以下文件处于同一路径下：

server_cert.pem

server_key.pem

Server.py（脚本文件）
```



脚本文件如下(需要修改IP地址为服务端实际IP地址)：

```
import socket
import ssl

# 服务端的 IP 和端口
server_ip = "192.168.xxx.xxx"  # 绑定到服务端的实际 IP
server_port = 5555             # 使用的端口号

# 服务端证书和私钥文件路径
cert_file = "server_cert.pem"  # 替换为实际服务端证书路径
key_file = "server_key.pem"    # 替换为实际服务端私钥路径

# 创建套接字
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# 设置 TLS/SSL 上下文
context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
context.load_cert_chain(certfile=cert_file, keyfile=key_file)  # 加载服务端证书和私钥

# 绑定服务端地址和端口
server_socket.bind((server_ip, server_port))
server_socket.listen(5)  # 设置等待连接队列的最大长度
print(f"服务端已启动，监听 {server_ip}:{server_port} ...")

try:
    while True:
        # 等待客户端连接
        client_socket, client_address = server_socket.accept()
        print(f"客户端 {client_address} 已连接")

        # 将普通套接字包装为 TLS 套接字
        tls_client_socket = context.wrap_socket(client_socket, server_side=True)

        try:
            # 接收消息
            message = tls_client_socket.recv(1024).decode('utf-8')
            print(f"收到消息: {message}")

            # 发送响应
            response = f"服务端已收到: {message}"
            tls_client_socket.sendall(response.encode('utf-8'))
            print("响应已发送")

        except Exception as e:
            print(f"通信错误: {e}")

        finally:
            tls_client_socket.close()
            print(f"客户端 {client_address} 已断开连接")

except KeyboardInterrupt:
    print("\n服务端已停止")
finally:
    server_socket.close()

```



客户端：

```
程序启动端作为客户端，在使用前需要传入以下文件：

ca_cert.pem
```



#### 5.程序运行流程

令服务端设备与客户端设备连接同一热点，服务端先启动python脚本，客户端运行程序，输入服务端地址（上文python中的实际IP）与服务端端口（5555），点击选择按钮，此时会打开文件资源管理器，选择传入的ca_cert.pem，后点击加载和连接，即可连接成功，后续可以发送消息



## 二.双向认证流程：适用于（双向TLS Socket加密数据传输、TCP升级为双向TLS Socket加密数据传输）

#### 1.生成所需要的证书配置文件（文件名：server_cert.cnf、client_cert.cnf）

输入以下命令：

```
vi server_cert.cnf
```

填入以下内容：

```
[ req ]
default_bits       = 2048
default_keyfile    = server.key
distinguished_name = req_distinguished_name
x509_extensions    = v3_req
prompt             = no

[ req_distinguished_name ]
C  = XX
ST = XX
L  = XX
O  = XX
OU = XX
CN = 192.168.xxx.xxx
emailAddress = xxxx@example.com

[ v3_req ]
subjectAltName = @alt_names

[ alt_names ]
IP.1 = 192.168.xxx.xxx


##需要修改两个ip地址为服务端ip地址
```

输入以下命令：

```
vi client_cert.cnf
```

填入以下内容：

```
[ req ]
default_bits       = 2048
default_keyfile    = client.key
distinguished_name = req_distinguished_name
x509_extensions    = v3_req
prompt             = no

[ req_distinguished_name ]
C  = XX
ST = XX
L  = XX
O  = XX
OU = XX
CN = client
emailAddress = xxxx@example.com

[ v3_req ]
```



#### 2.进行服务端与客户端的证书配置（依次执行以下命令）

```
#生成服务端私钥：
openssl genrsa -out server_key.pem 2048

#生成客户端私钥：
openssl genrsa -out client_key.pem 2048

#生成服务端 CSR：
openssl req -new -key server_key.pem -out server_csr.pem -config server_cert.cnf

#生成客户端 CSR：
openssl req -new -key client_key.pem -out client_csr.pem -config client_cert.cnf

#生成 CA 私钥：
openssl genrsa -out ca_key.pem 2048

#生成 CA 自签名证书：
openssl req -x509 -new -nodes -key ca_key.pem -sha256 -days 365 -out ca_cert.pem -subj "/C=CN/ST=State/L=City/O=MyCA/CN=root"

#签署服务端CSR
openssl x509 -req -in server_csr.pem -CA ca_cert.pem -CAkey ca_key.pem -CAcreateserial -out server_cert.pem -days 365 -sha256

#签署客户端CSR
openssl x509 -req -in client_csr.pem -CA ca_cert.pem -CAkey ca_key.pem -CAcreateserial -out client_cert.pem -days 365 -sha256
```



#### 3.需要使用的文件

```
服务端：
server_key.pem
server_cert.pem
ca_cert.pem

客户端：
client_key.pem
client_cert.pem
ca_cert.pem
```



#### 4.分配服务端和客户端所需要的文件（需要另外一台有python环境的设备作为服务端）

服务端：

```
服务端在此可以选择使用python脚本启动，脚本文件需要与以下文件处于同一路径下：

server_cert.pem

server_key.pem

ca_cert.pem

Server.py（脚本文件）
```

脚本文件如下(需要修改IP地址为服务端实际IP地址)：

```
import socket
import ssl

# 服务端的 IP 和端口
server_ip = "192.168.xxx.xxx"  # 服务端实际绑定的 IP
server_port = 5555            # 服务端监听的端口

# 服务端证书、私钥和 CA 证书路径
server_cert = "server_cert.pem"  # 服务端证书路径
server_key = "server_key.pem"    # 服务端私钥路径
ca_cert = "ca_cert.pem"          # 用于验证客户端证书的 CA 证书

# 创建普通 TCP 套接字
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# 设置 TLS/SSL 上下文
context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
context.load_cert_chain(certfile=server_cert, keyfile=server_key)  # 加载服务端证书和私钥
context.load_verify_locations(cafile=ca_cert)  # 加载 CA 证书
context.verify_mode = ssl.CERT_REQUIRED  # 强制要求客户端提供证书

# 绑定服务端地址和端口
server_socket.bind((server_ip, server_port))
server_socket.listen(5)  # 设置等待连接队列的最大长度
print(f"服务端已启动，监听 {server_ip}:{server_port} ...")

try:
    while True:
        try:
            # 等待客户端连接
            client_socket, client_address = server_socket.accept()
            print(f"客户端 {client_address} 已连接")

            # 将普通套接字包装为 TLS 套接字
            tls_client_socket = context.wrap_socket(client_socket, server_side=True)

            try:
                # 接收消息
                message = tls_client_socket.recv(1024).decode('utf-8')
                print(f"收到消息: {message}")

                # 发送响应
                response = f"服务端已收到: {message}"
                tls_client_socket.sendall(response.encode('utf-8'))
                print("响应已发送")

            except Exception as e:
                print(f"通信错误: {e}")

            finally:
                tls_client_socket.close()
                print(f"客户端 {client_address} 已断开连接")

        except ssl.SSLError as e:
            print(f"SSL 错误: {e}")
        except Exception as e:
            print(f"未知错误: {e}")

except KeyboardInterrupt:
    print("\n服务端已停止")
finally:
    server_socket.close()
```



客户端：

```
程序启动端作为客户端，在使用前需要传入以下文件：

ca_cert.pem

client_key.pem

client_cert.pem
```



#### 5.程序运行流程

令服务端设备与客户端设备连接同一热点，服务端先启动python脚本，客户端运行程序，输入服务端地址（上文python中的实际IP）与服务端端口（5555），点击选择按钮，选择传入的ca_cert.pem，后点击加载；点击选择按钮，选择传入的client_cert.pem，后点击加载；点击选择按钮，选择传入的client_key.pem，后点击加载，再点击连接功能，即可连接成功，后续可发送消息



## 三.双向认证流程：适用于（TLS Socket Server加密数据传输）

介绍：在此将程序运行端作为服务端，流程类似(二.双向认证流程)

#### 1.生成所需要的证书配置文件（文件名：server_cert.cnf、client_cert.cnf）

输入以下命令：

```
vi server_cert.cnf
```

填入以下内容：

```
[ req ]
default_bits       = 2048
default_keyfile    = server.key
distinguished_name = req_distinguished_name
x509_extensions    = v3_req
prompt             = no

[ req_distinguished_name ]
C  = XX
ST = XX
L  = XX
O  = XX
OU = XX
CN = 192.168.xxx.xxx
emailAddress = xxxx@example.com

[ v3_req ]
subjectAltName = @alt_names

[ alt_names ]
IP.1 = 192.168.xxx.xxx


##需要修改两个ip地址为程序启动端IP地址
```

输入以下命令：

```
vi client_cert.cnf
```

填入以下内容：

```
[ req ]
default_bits       = 2048
default_keyfile    = client.key
distinguished_name = req_distinguished_name
x509_extensions    = v3_req
prompt             = no

[ req_distinguished_name ]
C  = XX
ST = XX
L  = XX
O  = XX
OU = XX
CN = client
emailAddress = xxxx@example.com

[ v3_req ]
```



#### 2.进行服务端与客户端的证书配置（依次执行以下命令）

```
#生成服务端私钥：
openssl genrsa -out server_key.pem 2048

#生成客户端私钥：
openssl genrsa -out client_key.pem 2048

#生成服务端 CSR：
openssl req -new -key server_key.pem -out server_csr.pem -config server_cert.cnf

#生成客户端 CSR：
openssl req -new -key client_key.pem -out client_csr.pem -config client_cert.cnf

#生成 CA 私钥：
openssl genrsa -out ca_key.pem 2048

#生成 CA 自签名证书：
openssl req -x509 -new -nodes -key ca_key.pem -sha256 -days 365 -out ca_cert.pem -subj "/C=CN/ST=State/L=City/O=MyCA/CN=root"

#签署服务端CSR
openssl x509 -req -in server_csr.pem -CA ca_cert.pem -CAkey ca_key.pem -CAcreateserial -out server_cert.pem -days 365 -sha256

#签署客户端CSR
openssl x509 -req -in client_csr.pem -CA ca_cert.pem -CAkey ca_key.pem -CAcreateserial -out client_cert.pem -days 365 -sha256
```



#### 3.需要使用的文件

```
服务端：
server_key.pem
server_cert.pem
ca_cert.pem

客户端：
client_key.pem
client_cert.pem
ca_cert.pem
```



#### 4.分配服务端和客户端所需要的文件（需要另外一台有python环境的设备作为服务端）

服务端：

```
程序启动端作为服务端，在使用前需要传入以下文件：

server_cert.pem

server_key.pem

ca_cert.pem
```



客户端：

```
程序启动端作为客户端，在使用前需要传入以下文件：

ca_cert.pem

client_key.pem

client_cert.pem

Client.py
```





脚本文件如下(需要修改IP地址为程序启动端实际IP地址)：

```
import socket
import ssl

# 服务端的 IP 和端口
server_ip = "192.168.xxx.xxx"  # 服务端的 IP 地址
server_port = 5555            # 服务端的端口号

# 客户端证书、私钥和 CA 证书路径
client_cert = "client_cert.pem"  # 客户端证书路径
client_key = "client_key.pem"    # 客户端私钥路径
ca_cert = "ca_cert.pem"          # 用于验证服务端证书的 CA 证书

# 创建普通 TCP 套接字
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# 设置 TLS/SSL 上下文
context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
context.load_cert_chain(certfile=client_cert, keyfile=client_key)  # 加载客户端证书和私钥
context.load_verify_locations(cafile=ca_cert)  # 加载 CA 证书

# 将普通套接字包装为 TLS 套接字
wrapped_socket = context.wrap_socket(sock, server_hostname=server_ip)

try:
    # 连接服务端
    wrapped_socket.connect((server_ip, server_port))
    print(f"已连接到服务端 {server_ip}:{server_port}")

    # 发送消息
    message = "Hello, server! 这是客户端的消息。"
    wrapped_socket.sendall(message.encode('utf-8'))
    print("消息已发送")

    # 接收服务端的响应
    response = wrapped_socket.recv(1024)
    print(f"收到服务端响应: {response.decode('utf-8')}")

except ssl.SSLError as e:
    print(f"SSL 错误: {e}")
except ConnectionError as e:
    print(f"连接错误: {e}")
except Exception as e:
    print(f"未知错误: {e}")

finally:
    #wrapped_socket.close()
    print("连接已关闭")
```



#### 5.程序运行流程

令服务端设备与客户端设备连接同一热点，服务端启动该程序，输入服务端地址（上文python中的实际IP）与服务端端口（5555），程序启动段依次传入server_key.pem、server_cert.pem、ca_cert.pem，后启动上述脚本文件（作为客户端），后点击连接功能，即可连接成功