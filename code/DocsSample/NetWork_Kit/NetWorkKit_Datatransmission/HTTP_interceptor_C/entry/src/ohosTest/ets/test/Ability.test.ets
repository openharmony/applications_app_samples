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

import { describe, expect, it, Size, Level, TestType, beforeAll, afterAll } from '@ohos/hypium';
import { http } from '@kit.NetworkKit';
import testNetManager from 'libentry.so';
import { socket } from '@kit.NetworkKit';

const ExpectFail = () => {
  try {
    expect().assertFail();
  } catch (err) {
    console.info(`exportFail failed err: ${JSON.stringify(err)}`);
  }
};

const ExpectTrue = (n: boolean) => {
  try {
    expect(n).assertTrue();
  } catch (err) {
    console.info(`exportTrue failed err: ${JSON.stringify(err)}`);
  }
};


const HTTP_URL_BAIDU: string = "http://www.baidu.com";
const HTTP_URL: string = "http://localhost:9999";
const HTTP_URL_ERROR: string = "https://aaaa.com";

// 通用request的head
const HEADER = { "aaaaa": "" } as Record<string, string>;

// 常量定义
const DOMAIN: number = 0x0000; // 日志域值
const TAG: string = 'netstack'; // 日志标签

const createServer = async (caseName: string, done: Function) => {
  console.info(`${TAG} ${caseName}---Start`);
  let tcpSocketServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
  let listenAddr: socket.NetAddress = {
    address: "0.0.0.0",
    port: 9999,
    family: 1
  }
  await tcpSocketServer.listen(listenAddr).then(async ()=> {
    let listenAddr: socket.NetAddress =  await tcpSocketServer.getLocalAddress();
    console.info(`${TAG} ${caseName} tcpSocketServer listen address: `+JSON.stringify(listenAddr.address) +' port: '+JSON.stringify(listenAddr.port));
  }).catch((err: BusinessError) => {
    console.error(`${caseName} get err is `+JSON.stringify(err));
    ExpectFail();
    done();
  })
  tcpSocketServer.off('connect');
  tcpSocketServer.on('connect', async (clientSocket: socket.TCPSocketConnection)=>{
    console.info(`${TAG} ${caseName}-----tcpSocketServer on connect`);
    let clientAddr: socket.NetAddress = await clientSocket.getRemoteAddress();;
    console.info(`${TAG} ${caseName}----------`+JSON.stringify(clientAddr));
    clientSocket.on('message', async (msgInfo: socket.SocketMessageInfo) => {
      let tcpSendOption: socket.TCPSendOptions = {
        data: "HTTP/1.1 200 OK\r\n" +
          "Server: Tengine\r\n" +
          "Date: Sun, 06 May 2018 08:22:10 GMT\r\n" +
          //"Content-Type: text/event-stream\n" +
          "Content-Length: 9\r\n" +
          "X-Powered-By: ring/1.0.0\r\n" +
          //"vary: Accept-Encoding\n" +
          "gsid: 010185222147152559493030300162313551811\r\n" +
          "sc: 0.013\r\n" +
          "Access-Control-Allow-Origin: *\r\n" +
          "Access-Control-Allow-Methods: *\r\n" +
          "cache-control: no-cache\r\n" +
          "zzzzzzz\r\n" +
          "Access-Control-Allow-Headers: DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,key,x-biz,x-info,platinfo,encr,enginever,gzipped,poiid\r\n" +
          "\r\n"+
          "data:body"
      }
      clientSocket.send(tcpSendOption);
    });
  });
}

export default function abilityTest() {
  describe('abilityTest', () => {
    beforeAll(async (done: Function) => {
      await createServer(TAG, done);
      console.info(`test1 ${TAG} test Start`);
      done()
    })

    /**
     * @tc.name   testNetworkMgrHttpRequestInterceptorAddReadOnlyInterceptor0600
     * @tc.number SUB_NetworkMgr_HttpRequestInterceptor_AddReadOnlyInterceptor_0600
     * @tc.desc   test Response to code modification in read-only interceptors
     * @tc.type   FUNCTION
     * @tc.size   MEDIUMTEST
     * @tc.level  LEVEL2
     */
    it('testNetworkMgrHttpRequestInterceptorAddReadOnlyInterceptor0600', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL2,
      async (done: Function) => {
        const caseName: string = "testNetworkMgrHttpRequestInterceptorAddReadOnlyInterceptor0600";
        console.info(`${TAG} ${caseName} test Start`);
        try {
          let addReadOnlyResult: number = testNetManager.AddResponseInterceptor();
          ExpectTrue(addReadOnlyResult == 0);
          console.info(`${TAG} ${caseName} AddResponseInterceptor success, addReadOnlyResult:${addReadOnlyResult}`);
          let httpRequest: http.HttpRequest = http.createHttp();
          let options: http.HttpRequestOptions = {
            method: http.RequestMethod.POST,
          };
          httpRequest.request(HTTP_URL, options, (err: BusinessError, res: http.HttpResponse) => {
            if (err) {
              console.info(`${TAG} ${caseName} request fail, error code: ${err.code}, msg: ${err.message}`);
              testNetManager.RemoveAllInterceptors();
              httpRequest.destroy();
              ExpectFail();
              done();
            } else {
              console.info(`${TAG} ${caseName} res:${JSON.stringify(res)}`);
              ExpectTrue(res.responseCode == 200);
              let res1: number = testNetManager.RemoveAllInterceptors();
              ExpectTrue(res1 == 0);
              console.info(`${TAG} ${caseName} res1:${res1}`);
              httpRequest.destroy();
              done();
            }
          });
        } catch (error) {
          const err: BusinessError = error as BusinessError;
          console.info(`${TAG} ${caseName} catch ERROR-->:${JSON.stringify(err)}`);
          testNetManager.RemoveAllInterceptors();
          ExpectFail();
          done();
        }
        console.info(`${TAG} ${caseName} test End`);
      });

    /**
     * @tc.name   testNetworkMgrHttpRequestInterceptorAddReadOnlyInterceptor0700
     * @tc.number SUB_NetworkMgr_HttpRequestInterceptor_AddReadOnlyInterceptor_0700
     * @tc.desc   test Response to header modification in read-only interceptors
     * @tc.type   FUNCTION
     * @tc.size   MEDIUMTEST
     * @tc.level  LEVEL2
     */
    it('testNetworkMgrHttpRequestInterceptorAddReadOnlyInterceptor0700', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL2,
      async (done: Function) => {
        const caseName: string = "testNetworkMgrHttpRequestInterceptorAddReadOnlyInterceptor0700";
        console.info(`${TAG} ${caseName} test Start`);
        try {
          let addReadOnlyResult: number = testNetManager.AddResponseInterceptor();
          ExpectTrue(addReadOnlyResult == 0);
          console.info(`${TAG} ${caseName}AddReadOnlyResponseInterceptor success, addReadOnlyResult:${addReadOnlyResult}`);
          let httpRequest: http.HttpRequest = http.createHttp();
          let options: http.HttpRequestOptions = {
            method: http.RequestMethod.POST
          };
          httpRequest.request(HTTP_URL, options, (err: BusinessError, res: http.HttpResponse) => {
            if (err) {
              console.info(`${TAG} ${caseName} request fail, error code: ${err.code}, msg: ${err.message}`);
              httpRequest.destroy();
              testNetManager.RemoveInterceptor();
              ExpectFail();
              done();
            } else {
              console.info(`${TAG} ${caseName} res:${JSON.stringify(res)}`);
              ExpectTrue(res.responseCode == 200);
              let res1: number = testNetManager.RemoveInterceptor();
              ExpectTrue(res1 == 0);
              console.info(`${TAG} ${caseName} res1:${res1}`);
              httpRequest.destroy();
              done();
            }
          });
        } catch (error) {
          const err: BusinessError = error as BusinessError;
          console.info(`${TAG} ${caseName} catch ERROR-->:${JSON.stringify(err)}`);
          testNetManager.RemoveInterceptor();
          ExpectFail();
          done();
        }
        console.info(`${TAG} ${caseName} test End`);
      });

    /**
     * @tc.name   testNetworkMgrHttpRequestInterceptorStartAllInterceptor0700
     * @tc.number SUB_NetworkMgr_HttpRequestInterceptor_StartAllInterceptor_0700
     * @tc.desc   test Will multiple group interceptors start one by one and affect each other
     * @tc.type   FUNCTION
     * @tc.size   MEDIUMTEST
     * @tc.level  LEVEL2
     */
    it('testNetworkMgrHttpRequestInterceptorStartAllInterceptor0700', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL2,
      async (done: Function) => {
        const caseName: string = "testNetworkMgrHttpRequestInterceptorStartAllInterceptor0700";
        console.info(`${TAG} ${caseName} test Start`);
        try {

          let result: number = testNetManager.AddResponseInterceptor();
          ExpectTrue(result == 0);
          console.info(`${TAG} ${caseName} AddResponseInterceptor success, result:${result}`);
          let startResult: number = testNetManager.StartInterceptors();
          ExpectTrue(startResult == 0);
          console.info(`${TAG} ${caseName} StartInterceptors success, startResult:${startResult}`);
          let httpRequest: http.HttpRequest = http.createHttp();
          let options: http.HttpRequestOptions = {
            method: http.RequestMethod.POST
          };
          httpRequest.request(HTTP_URL_ERROR, options, (err: BusinessError, res: http.HttpResponse) => {
            if (err) {
              console.info(`${TAG} ${caseName} request fail, error code: ${err.code}, msg: ${err.message}`);
              testNetManager.RemoveAllInterceptors();
              httpRequest.destroy();
              ExpectFail();
              done();
            } else {
              console.info(`${TAG} ${caseName} res:${JSON.stringify(res)}`);
              ExpectTrue(res.responseCode == 200);
              testNetManager.RemoveAllInterceptors();
              httpRequest.destroy();
              done();
            }
          });
        } catch (error) {
          const err: BusinessError = error as BusinessError;
          console.info(`${TAG} ${caseName} catch ERROR-->:${JSON.stringify(err)}`);
          testNetManager.RemoveAllInterceptors();
          ExpectFail();
          done();
        }
        console.info(`${TAG} ${caseName} test End`);
      });

    /**
     * @tc.name   testNetworkMgrHttpRequestInterceptorStopAllInterceptor0800
     * @tc.number SUB_NetworkMgr_HttpRequestInterceptor_StopAllInterceptor_0800
     * @tc.desc   test stop group interceptor, same type interceptor
     * @tc.type   FUNCTION
     * @tc.size   MEDIUMTEST
     * @tc.level  LEVEL2
     */
    it('testNetworkMgrHttpRequestInterceptorStopAllInterceptor0800', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL2,
      async (done: Function) => {
        const caseName: string = "testNetworkMgrHttpRequestInterceptorStopAllInterceptor0800";
        console.info(`${TAG} ${caseName} test Start`);
        try {
          let result: number = testNetManager.AddResponseInterceptor();
          ExpectTrue(result == 0);
          console.info(`${TAG} ${caseName} AddResponseInterceptor success, result:${result}`);
          let stopResult: number = testNetManager.StopInterceptors();
          ExpectTrue(stopResult === 0);
          console.info(`${TAG} ${caseName} StopInterceptors success, stopResult:${stopResult}`);
          let httpRequest: http.HttpRequest = http.createHttp();
          let options: http.HttpRequestOptions = {
            method: http.RequestMethod.POST
          };
          httpRequest.request(HTTP_URL, options, (err: BusinessError, res: http.HttpResponse) => {
            if (err) {
              console.info(`${TAG} ${caseName} request fail, error code: ${err.code}, msg: ${err.message}`);
              testNetManager.RemoveAllInterceptors();
              httpRequest.destroy();
              ExpectFail();
              done();
            } else {
              console.info(`${TAG} ${caseName} res-first:${res.responseCode}`);
              ExpectTrue(res.responseCode == 200);
              testNetManager.RemoveAllInterceptors();
              httpRequest.destroy();
              done();
            }
          });
        } catch (error) {
          const err: BusinessError = error as BusinessError;
          console.info(`${TAG} ${caseName} catch ERROR-->:${JSON.stringify(err)}`);
          testNetManager.RemoveAllInterceptors();
          ExpectFail();
          done();
        }
        console.info(`${TAG} ${caseName} test End`);
      });
  });
}