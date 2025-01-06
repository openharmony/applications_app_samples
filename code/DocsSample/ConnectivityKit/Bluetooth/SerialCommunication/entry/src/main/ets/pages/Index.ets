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

import { socket } from '@kit.ConnectivityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ToastReport } from '../common/ToastReport';
import util from '@ohos.util';

const TAG: string = 'SerialCommunication';
let encoder = new util.TextEncoder();

@Entry
@Component
struct serialCommunication {
  @State serverNumber: number = 0;
  @State clientNumber: number = 1;
  @State deviceId: string = '';
  @State uuid: string = '00001101-0000-1000-8000-00805f9b34fb';
  @State dataValue: string = '';
  private toastReport: ToastReport = new ToastReport();

  build() {
    Column({ space: 12 }) {
      Text('serial communication')
        .fontSize(45)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Top },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })

      Text($r('app.string.deviceId_style'))
      Row() {
        Text('deviceId: ')

        TextInput().onChange((value: string) => {
          this.deviceId = value;
        }).height('40vp').width('70%')
      }.width('80%')

      Text($r('app.string.uuid_style'))
      Row() {
        Text('uuid: ')

        TextInput().onChange((value: string) => {
          this.uuid = value;
        }).height('40vp').width('70%')
      }.width('80%')

      Row() {
        Text('dataValue: ')

        TextInput().onChange((value: string) => {
          this.dataValue = value;
        }).height('40vp').width('70%')
      }.width('80%')

      Button('listenSocket')
        .width('50%')
        .id('listenSocket')
        .backgroundColor('#8CE072')
        .onClick(() => {
          let serverNumber = -1;
          let sppOption: socket.SppOptions = {
            uuid: this.uuid,
            secure: true,
            type: 0
          };
          try {
            socket.sppListen('server1', sppOption, (code: BusinessError | null, serverSocketID: number) => {
              if (code != null) {
                console.error(TAG, 'sppListen error, code is ' + (code as BusinessError).code);
                this.toastReport.showResult('sppListen error, code is ' + (code as BusinessError).code);
                return;
              } else {
                serverNumber = serverSocketID;
                this.serverNumber = serverNumber;
                console.info(TAG, 'sppListen success, serverNumber = ' + serverNumber);
                this.toastReport.showResult('sppListen success, serverNumber = ' + serverNumber)
              }
            });
          } catch (err) {
            console.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);
            this.toastReport.showResult('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);
          }
        })

      Button('ServerConnect')
        .width('50%')
        .id('ServerConnect')
        .backgroundColor('#8CE072')
        .onClick(() => {
          let clientNumber = -1;
          try {

            socket.sppAccept(this.serverNumber, (code: BusinessError | null, clientSocketID: number) => {
              if (code != null) {
                console.error(TAG, 'sppAccept error, code is ' + (code as BusinessError).code);
                this.toastReport.showResult('sppAccept error, code is ' + (code as BusinessError).code);
                return;
              } else {
                clientNumber = clientSocketID;
                this.clientNumber = clientNumber
                console.info(TAG, 'accept the client success');
                this.toastReport.showResult('accept the client success');
              }
            })
            console.info(TAG, 'waiting for client connection');
            this.toastReport.showResult('waiting for client connection');
          } catch (err) {
            console.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);
            this.toastReport.showResult('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);

          }
        })

      Button('connectDevice')
        .width('50%')
        .backgroundColor('#8CE072')
        .onClick(() => {
          try {
            socket.sppConnect(this.deviceId, {
              uuid: this.uuid,
              secure: true,
              type: 0
            }, (code: BusinessError | null, socketID: number) => {
              if (code != null) {
                console.error(TAG, 'sppConnect error, code = ' + (code as BusinessError).code);
                this.toastReport.showResult('sppConnect error, code = ' + (code as BusinessError).code);
                return;
              }
              console.info(TAG, 'sppConnect success, socketId = ' + socketID);
              this.toastReport.showResult('sppConnect success, socketId = ' + socketID);
            })
          } catch (err) {
            console.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);
            this.toastReport.showResult('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);

          }
        })

      Button('writeData')
        .width('50%')
        .id('writeData')
        .backgroundColor('#8CE072')
        .onClick(() => {
          let array = new Uint8Array(this.dataValue.length);
          encoder.encodeIntoUint8Array(this.dataValue, array);

          try {
            socket.sppWrite(this.clientNumber, array.buffer);
            console.info(TAG, 'sppWrite success');
            this.toastReport.showResult('sppWrite success');
          } catch (err) {
            console.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);
            this.toastReport.showResult('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);
          }
        })

      Button('subscribeEvent')
        .width('50%')
        .id('subscribeEvent')
        .backgroundColor('#8CE072')
        .onClick(() => {
          try {
            socket.on('sppRead', this.clientNumber, (dataBuffer: ArrayBuffer) => {
              const data = new Uint8Array(dataBuffer);
              if (data != null) {
                console.info(TAG, 'sppRead success, data = ' + JSON.stringify(data));
                this.toastReport.showResult('sppRead success, data = ' + JSON.stringify(data));
              } else {
                console.error(TAG, 'sppRead error, data is null');
                this.toastReport.showResult('sppRead error, data is null');
              }
            })
          } catch (err) {
            console.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);
            this.toastReport.showResult('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);
          }
        })

      Button('unsubscribeEvent')
        .width('50%')
        .id('unsubscribeEvent')
        .backgroundColor('#8CE072')
        .onClick(() => {
          try {
            socket.off('sppRead', this.clientNumber, (dataBuffer: ArrayBuffer) => {
              const data = new Uint8Array(dataBuffer);
              if (data != null) {
                console.info(TAG, 'offSppRead success, data = ' + JSON.stringify(data));
                this.toastReport.showResult('offSppRead success, data = ' + JSON.stringify(data));
              } else {
                console.error(TAG, 'offSppRead error, data is null');
                this.toastReport.showResult('offSppRead error, data is null');
              }
            })
          } catch (err) {
            console.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);
            this.toastReport.showResult('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);
          }
        })

      Button('closeServer')
        .width('50%')
        .id('closeServer')
        .backgroundColor('#8CE072')
        .onClick(() => {
          try {
            socket.sppCloseServerSocket(this.serverNumber);
            console.info(TAG, 'sppCloseServerSocket success');
            this.toastReport.showResult('sppCloseServerSocket success');
          } catch (err) {
            console.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);
            this.toastReport.showResult('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
            (err as BusinessError).message);
          }
        })

      Button('closeClient')
        .width('50%')
        .id('closeClient')
        .backgroundColor('#8CE072')
        .onClick(() => {
          socket.sppCloseClientSocket(this.clientNumber);
          console.info(TAG, 'sppCloseClientSocket success');
          this.toastReport.showResult('sppCloseClientSocket success');
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#E6F7FF')
  }
}