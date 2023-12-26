/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import socket from '@ohos.net.socket';
import Socket from '../model/Socket';
import Logger from '../utils/Logger';

const TAG = 'Socket TlsSocket';

/**
 * 证书文件可能过期，需要自行生成
 */
const key =
  '-----BEGIN RSA PRIVATE KEY-----\r\n' +
  'MIIEowIBAAKCAQEAoDQ2S1RvsS5d9EZhVfWziC4+kWV2jqcJ3jnU9KSHx8y4sbis\r\n' +
  '4EegBWFjHIXoHSV6JWBSet63LfYohZoamJkYncZ+W4aHcFVUDub/Oae7Zjsvpzlb\r\n' +
  'isD9wD7x4xp0PEqOe2WYfGmMeF7Itp/4BYT8hysRRrU0kzNQiNZY2De9n27M6i0R\r\n' +
  'if323rd7WKyGT/JO1Ap5r+I4D7YzoKSkhBfWCCvgzM8Tf7SeKqyFCXVtX6FlFnyO\r\n' +
  'H1falcfTzgMf0uKXlrjyh00IXTLbgCVTAQl0/B1E9h1PKlzmTqPLNk0Lg+xQd8JG\r\n' +
  'MjN6YTs59XMTEPtb/SCS63UIaGKCHEvL/tRGqwIDAQABAoIBAEjnec3OHwYCk78W\r\n' +
  'SDVWGt1eLhr8kXdZjKQUrVSniyLhhytZX1KxRaEtMG1KgtbAt1VLAD3qHHJOEyK5\r\n' +
  'fmDzSsCCE/6Sug/kxNwDQyJ5sk5ToNv4vi/mo5NZEbrHzx2g0DZXhY0Ye1RLzgtN\r\n' +
  'wRDB9CmO7829qK9UKtIauVOsCh8DFOnkk5RSqrkHjfQMJhkJnFqLnHss4PxDlrB0\r\n' +
  'dTGmMTl9D41rVI4NXEvso3Io/aZt9OEvh3vCfZyvDWFdnoNCaGIjJn2hSE+WqvYP\r\n' +
  '7aPF+pYA3u4mv0rvrXWrXb09zaD/WPpv4bsa5UnfXcM6q1vEi6iG9NThHnN1GW3h\r\n' +
  'dwZLqAECgYEAzDj7fAaJ9SNWxTvJF+y5yZMxw5ij4J4Z/jheHA6xA7llRjqKf/F1\r\n' +
  'l4on67YStA34G33lUfI29N6DUK1qPeXy6duredKug5H49sZ1nFYBjRj3A7OzyXs9\r\n' +
  'Jz+1sWPFiOg/SieothzJPYfhOCnmT+2g4wqJnx2RZziCWvs8xfy3cqkCgYEAyNI2\r\n' +
  'ACZInaYSF++d/OaoIYJtHU+/MtVHcfBrkOvT2BQlkJfOLFVfEwuQ09esegK6oemV\r\n' +
  'POdGT3lbOV9ncQZ5MUMxp6s2o7AKshNGeuTRzu0Tq/ryeJ9Wv0l/g3/jtW8RDyfr\r\n' +
  'uXc6two0T4G59Xx8vlQ3HMRcmMUh9wjuS29pVzMCgYB1YcdCyWtgSFimcy+pnbpH\r\n' +
  '31/6IfEHuTgNhA6rp9Ic5uIMFLfoxDunx5QcioGDlofmHV3C1Sq7Ym4t4A8x1srh\r\n' +
  'mg6crfj6zNtB1F5jZpfrps7MBO0wwLIsrhTcChHPGFbQY604R6FvyXstUf/8LwSL\r\n' +
  'm1Hw8AjUQInEi6Wp0xEKSQKBgHKUxizlqw8QH0i69kjDDnE4KqvLwYrud/pBtA4X\r\n' +
  'EGM8c4aBpyhSeZGzSqokZ4uiHPye+wCp8MsNsggVMD8j82gxL5a8MMvKeP/L0a3y\r\n' +
  '+ub3C/9XiptaRrOT6waLpM/zlCcynuPObJjdYKVwnjq8EazC/kMSosajy9JYrSYr\r\n' +
  'Zk5TAoGBAL2gxQyU2swvRemOA5PnLviqf++TUZdbCKlW7x1Xoj1xJVFH9Ql0ocGD\r\n' +
  'cgEiYCSS4eaEbUnsMtAStUwXBH9DPVQRUOpxCvAuMFnP5OeUEAZ6rKrp5E3iuDz2\r\n' +
  'dbxwe2wphU8yH+wC1xWd4uFKK2MRUH+3XAR02MmzGaXTarDHO1fN\r\n' +
  '-----END RSA PRIVATE KEY-----\r\n';

const cert =
  '-----BEGIN CERTIFICATE-----\r\n' +
  'MIIC+DCCAeACFE+6YAe2yhFoBO5u1tsROSqQcaqYMA0GCSqGSIb3DQEBBQUAMDMx\r\n' +
  'MTAvBgNVBAoMKHd3dy50ZXN0LmNvbSBEb2RneSBDZXJ0aWZpY2F0ZSBBdXRob3Jp\r\n' +
  'dHkwHhcNMjMwNDE0MDM1NzQzWhcNMzYxMjIxMDM1NzQzWjA+MSgwJgYDVQQKDB93\r\n' +
  'd3cudGVzdC5jb20gRGV2aWNlIENlcnRpZmljYXRlMRIwEAYDVQQDDAkxMjcuMC4w\r\n' +
  'LjEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCgNDZLVG+xLl30RmFV\r\n' +
  '9bOILj6RZXaOpwneOdT0pIfHzLixuKzgR6AFYWMchegdJXolYFJ63rct9iiFmhqY\r\n' +
  'mRidxn5bhodwVVQO5v85p7tmOy+nOVuKwP3APvHjGnQ8So57ZZh8aYx4Xsi2n/gF\r\n' +
  'hPyHKxFGtTSTM1CI1ljYN72fbszqLRGJ/fbet3tYrIZP8k7UCnmv4jgPtjOgpKSE\r\n' +
  'F9YIK+DMzxN/tJ4qrIUJdW1foWUWfI4fV9qVx9POAx/S4peWuPKHTQhdMtuAJVMB\r\n' +
  'CXT8HUT2HU8qXOZOo8s2TQuD7FB3wkYyM3phOzn1cxMQ+1v9IJLrdQhoYoIcS8v+\r\n' +
  '1EarAgMBAAEwDQYJKoZIhvcNAQEFBQADggEBAAcEuP2YbnjMb69hPtvKlrDxW71K\r\n' +
  'O9PJnDc40eZ6ZFnepTgCmyZrBepgCVylBwCh2OMze9ovwrw8gnNI5MVHijb1EFh6\r\n' +
  'j2JPTQ+giG9SVxrpyrbNyRydKeBUz8RqhXHRlS6RfDReL4sG2KDkYO3XHaaU2Bu0\r\n' +
  'ErKqDXbBcFkCuUanM2JWL9F5i0brqdGQ8+dmCac8Tz2ABkRF+ZlpqDg1IO3OHryD\r\n' +
  'hIOxG8Ehshk0rpYBQv1McR4ezancG/eswxrFKu0L3SxFeFA7gz+Rv7Fdeb67Uupr\r\n' +
  'VY4NzyUuHYBoJMjJMsUH7sNdKUNQz66G89jG6K/kPOaCpVzmK6miJiX2oPg=\r\n' +
  '-----END CERTIFICATE-----\r\n';

const ca =
  '-----BEGIN CERTIFICATE-----\r\n' +
  'MIIC7TCCAdUCFC8NFFp/DPsC5oZ52erAUBE3SVxBMA0GCSqGSIb3DQEBBQUAMDMx\r\n' +
  'MTAvBgNVBAoMKHd3dy50ZXN0LmNvbSBEb2RneSBDZXJ0aWZpY2F0ZSBBdXRob3Jp\r\n' +
  'dHkwHhcNMjMwNDE0MDM1NzQzWhcNMzYxMjIxMDM1NzQzWjAzMTEwLwYDVQQKDCh3\r\n' +
  'd3cudGVzdC5jb20gRG9kZ3kgQ2VydGlmaWNhdGUgQXV0aG9yaXR5MIIBIjANBgkq\r\n' +
  'hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv8IEpaZ6WaHbuNHzQ5gr5XH0ozRxrnF3\r\n' +
  '2uKxtu/YkfEBQriM8ZlT2lTBjEy748lxPx3SS8OkPu8opE1E16UlSSGtI0gQAPUI\r\n' +
  '3Jkdx0z3xj9iKSp14J+3ZZ61i+K3fDBkdZSEk+0KjinzjERvsgkkzDk4ZQCORwcV\r\n' +
  'jsUi+M3dqQm8ARELQgTRkTBfof+F2vOR0Ufc5m14z50TvhnMRUw+fEcDe5cnKok0\r\n' +
  'C1QUgwC9m6Q9fzS1JMdPYMdFZQJ12ACr1B7g5m/i6xCxuqBxmtP/2DiqhsSIMQy4\r\n' +
  'XDU4CyPneoWQMz4nObJymxDvoAe86foFfPWzM6sAEZeGxJUooI19dQIDAQABMA0G\r\n' +
  'CSqGSIb3DQEBBQUAA4IBAQAQ1vZ9QWS/YS5cVuv5wvXxHu2M2LKWOzDvb7FTn46q\r\n' +
  'irTOCVx0H1su6wktGMuFsgYNkKdd2xTiJeggDqHGMNkTul9XbY5VM0sWJaXoYrPQ\r\n' +
  '55BylXSl4miGIkVWTYHZNgeSBzE1vIRWuvXgo0DGWJ8a1NpUxYG0DCkGY1UPipo9\r\n' +
  'YTjnK8Rtx6fsyg3Wn3G5HG+8xMkOGsamCYTee8ASxHbdziS8U4VLAAhZgvyPI1ZK\r\n' +
  'uhLreTaRrguLyz4qpX/JrLhkrOkwZN+ueHToQGIOV1pleEXRNO0y9JZ4tZCkKbsH\r\n' +
  'G4o77ax02PiiQ0R5Np1ju5t+s63NXV/bURIjhRafb2B5\r\n' +
  '-----END CERTIFICATE-----\r\n';

export default class TlsSocket implements Socket {
  private tlsSocket?: socket.TLSSocket;

  /**
   * 创建Socket
   * @param localIp
   * @param port
   */
  async createSocket(localIp: string, port: number): Promise<boolean> {
    Logger.info(`${TAG} tls bind localIp: ${localIp}`);
    try {
      if (this.tlsSocket) {
        await this.closeSocket();
      }

      this.tlsSocket = socket.constructTLSSocketInstance();

      await this.tlsSocket.bind({
        address: localIp,
        port: port,
        family: 1,
      });
      Logger.info(`${TAG} tls bind sucess`);
      return true;
    } catch (e) {
      Logger.error(`${TAG} tls bind error ${JSON.stringify(e)}}`);
    }
    return false;
  }

  /**
   * 连接Socket
   * @param address
   * @param port
   */
  async connectSocket(address: string, port: number): Promise<boolean> {
    Logger.info(`${TAG} tls connectSocket address: ${address}`);
    try {
      if (!this.tlsSocket) {
        return false;
      }

      if (await this.isConnected()) {
        Logger.info(`${TAG} tls connectSocket sucess`);
        return true;
      }

      let options: socket.TLSConnectOptions = {
        address: {
          address: address,
          port: port,
          family: 1,
        },
        secureOptions: {
          key: key,
          cert: cert,
          ca: [ca],
          protocols: [socket.Protocol.TLSv12],
          cipherSuite: 'ALL:@SECLEVEL=0',
        },
      };

      await this.tlsSocket.connect(options);

      await this.tlsSocket.setExtraOptions({});
      Logger.info(`${TAG} tls connectSocket sucess`);
      return true;
    } catch (e) {
      Logger.error(`${TAG} tls connectSocket error ${JSON.stringify(e)}}`);
    }
    return false;
  }

  /**
   * 关闭Socket
   */
  async closeSocket(): Promise<void> {
    if (!this.tlsSocket) {
      return;
    }
    await this.tlsSocket.close();
    this.tlsSocket.off('connect');
    this.tlsSocket.off('message');
    this.tlsSocket = undefined;
  }

  /**
   * 发送数据
   * @param data
   */
  async sendData(data: string): Promise<void> {
    if (!this.tlsSocket) {
      return;
    }
    Logger.info(`${TAG} tls sendData data ${JSON.stringify(data)}`);
    try {
      await this.tlsSocket.send(data);
    } catch (e) {
      Logger.error(`${TAG} tls sendData error ${JSON.stringify(e)}}`);
    }
  }

  /**
   * 判断是否连接
   */
  async isConnected(): Promise<boolean> {
    if (!this.tlsSocket) {
      return false;
    }

    try {
      let state = await this.tlsSocket.getState();
      if (state.isConnected) {
        return true;
      }
    } catch (e) {
      Logger.error(`${TAG} tls getState error ${JSON.stringify(e)}}`);
    }
    return false;
  }

  /**
   * 订阅消息
   * @param callback
   */
  setOnMessageReceivedListener(callback: (buffer: ArrayBuffer) => void): void {
    if (!this.tlsSocket) {
      return;
    }

    this.tlsSocket.on('message', (data) => {
      Logger.info(`${TAG} TLS data: ` + JSON.stringify(data));
      let buffer = data.message;
      callback(buffer);
    });
  }

  /**
   * TLS 关闭事件订阅
   * @param callback
   */
  setOnCloseListener(callback: () => void): void {
    Logger.info(`${TAG} TLS setOnCloseListener into`);
    this.tlsSocket?.on('close', () => {
      Logger.info(`${TAG} TLS setOnCloseListener onClose：`);
      callback();
      this.closeSocket();
    });

    this.tlsSocket?.on('error', (data) => {
      Logger.info(
        `${TAG} TLS setOnCloseListener onClose：` + JSON.stringify(data)
      );
      callback();
      this.closeSocket();
    });
  }
}
