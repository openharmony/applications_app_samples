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
import router from '@ohos.router';
import mechanicManager from '@ohos.distributedHardware.mechanicManager';
import prompt from '@system.prompt';
import { logger } from '../utils/Logger';
import { BusinessError } from '@kit.BasicServicesKit';

let savedMechanicIds: number[] = [];
// [Start handle_device_attached_detached]
function handleDeviceAttached(mechInfo: mechanicManager.MechInfo) {
  console.info(`New device is connected: ${mechInfo.mechName} (ID: ${mechInfo.mechId})`);
  savedMechanicIds.push(mechInfo.mechId);
  // To do sth.
}

function handleDeviceDetached(mechInfo: mechanicManager.MechInfo) {
  console.info(`Device disconnected: ${mechInfo.mechName} (ID: ${mechInfo.mechId})`);
  savedMechanicIds.filter(id => id !== mechInfo.mechId);
  // To do sth.
}
// [End handle_device_attached_detached]

@Entry
@Component
struct AttachStateChangeCallbackRegister {
  @State message: string = '';
  callback1 = (result: mechanicManager.AttachStateChangeInfo) => {
    logger.info('callback1 result: ' + JSON.stringify(result));
    prompt.showToast({
      message: `callback1 监听连接状态：result.state = ${JSON.stringify(result.state)}`,
      duration: 2000
    });
  };

  @Styles
  fancy() {
    .height('100px')
    .width('400px')
    .margin({
      top: 5
    })
  }

  build() {
    Column() {
      Text(this.message)
        .width('100%')
        .height('30%')
        .padding(10)
        .textAlign(TextAlign.Center)
        .fontSize(20);

      Column() {
        Button() {
          Text('注册 - 1')
            .fontSize(20)
            .fontColor(Color.White)
        }.onClick(() => {
          // [Start on_attachStateChange]
          const attachStateChangeCallback = (info: mechanicManager.AttachStateChangeInfo) => {
            if (info.state === mechanicManager.AttachState.ATTACHED) {
              console.info('Device attached:', info.mechInfo);
              // 执行设备连接的相关操作
              handleDeviceAttached(info.mechInfo);
            } else if (info.state === mechanicManager.AttachState.DETACHED) {
              console.info('Device detached:', info.mechInfo);
              // 执行设备断开的相关操作
              handleDeviceDetached(info.mechInfo);
            }
          };

          // 注册监听
          mechanicManager.on('attachStateChange', attachStateChangeCallback);
          // [End on_attachStateChange]
        }).fancy();

        Column() {
          Button() {
            Text('去注册 - 1')
              .fontSize(20)
              .fontColor(Color.White)
          }.onClick(() => {
            const attachStateChangeCallback = (info: mechanicManager.AttachStateChangeInfo) => {
              if (info.state === mechanicManager.AttachState.ATTACHED) {
                console.info('Device attached:', info.mechInfo);
                // 执行设备连接的相关操作
                handleDeviceAttached(info.mechInfo);
              } else if (info.state === mechanicManager.AttachState.DETACHED) {
                console.info('Device detached:', info.mechInfo);
                // 执行设备断开的相关操作
                handleDeviceDetached(info.mechInfo);
              }
            };
            // [Start off_attachStateChange]
            // 取消连接状态的监听
            mechanicManager.off('attachStateChange', attachStateChangeCallback);
            // [End off_attachStateChange]
          }).fancy();

          Button() {
            Text('去注册 - all')
              .fontSize(20)
              .fontColor(Color.White)
          }.onClick(() => {
            try {
              logger.info('去注册注册 - all');
              mechanicManager.off("attachStateChange");
              this.message = '去注册 - all: 成功';
              logger.info('去注册 - all: 成功');
            } catch (error) {
              let code: number = (error as BusinessError).code;
              let message: string = (error as BusinessError).message;
              this.message = '去注册 - all: 失败, code: ' + code + ' message: ' + message;
              logger.error('去注册 - all: 失败, code: ' + code + ' message: ' + message);
            }
          }).fancy();
        }.width('45%');
      }.height('800px')

        Column() {
          Button() {
            Text('返回')
              .fontSize(20)
              .fontColor(Color.White)
          }.onClick(() => {
            router.back();
          }).fancy();

        }.width('50%');

    }
  }
}