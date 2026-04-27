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
// [Start SmsService_SendSMS]
// 示例代码
import { sms } from '@kit.TelephonyKit';
import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
// [StartExclude SmsService_SendSMS]
@Entry
@Component
struct Index {

  build() {
    Column() {
      Button('发送短信')
        .onClick(() => {
// [EndExclude SmsService_SendSMS]
          let sendCallback: AsyncCallback<sms.ISendShortMessageCallback> = (err: BusinessError, data: sms.ISendShortMessageCallback) => {
              console.log(`sendCallback: err->${JSON.stringify(err)}, data->${JSON.stringify(data)}`); 
          }
          let deliveryCallback: AsyncCallback<sms.IDeliveryShortMessageCallback> = (err: BusinessError, data: sms.IDeliveryShortMessageCallback) => {
              console.log(`deliveryCallback: err->${JSON.stringify(err)}, data->${JSON.stringify(data)}`); 
          }
          let slotId: number = 0;
          let content: string = '短信内容';
          let destinationHost: string = '+861xxxxxxxxxx';
          let serviceCenter: string = '+861xxxxxxxxxx';
          let destinationPort: number = 1000;
          let options: sms.SendMessageOptions = {slotId, content, destinationHost, serviceCenter, destinationPort, sendCallback, deliveryCallback};
          sms.sendShortMessage(options, (err: BusinessError) => {
              console.error(`callback: err->${JSON.stringify(err)}`);
          });
// [End SmsService_SendSMS]
        })
    }
  }
}