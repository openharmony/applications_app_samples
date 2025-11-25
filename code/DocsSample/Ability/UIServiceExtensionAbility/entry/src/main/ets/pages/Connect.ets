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

// [Start connect_service_ext_start]
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Connect {
  comProxy: common.UIServiceProxy | null = null;
  connectCallback: common.UIServiceExtensionConnectCallback = {
    onData: (data: Record<string, Object>) => {
      console.info(`data received, data: ${JSON.stringify(data)}.`);
    },
    onDisconnect: () => {
      console.info(`onDisconnect.`);
    }
  }

  build() {
    Column() {
      Row() {
        // 创建连接按钮
        Button('connect ability')
          .enabled(true)
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let startWant: Want = {
              bundleName: 'com.acts.uiserviceextensionability', // 仅作为示例代码，需要替换为实际的UIServiceExtensionAbility组件的包名。
              abilityName: 'UiServiceExtAbility', // 仅作为示例代码，需要替换为实际的UIServiceExtensionAbility组件名称。
            };
            try {
              // 连接UIServiceExtensionAbility组件
              context.connectUIServiceExtensionAbility(startWant, this.connectCallback)
                .then((proxy: common.UIServiceProxy) => {
                  this.comProxy = proxy;
                  let formData: Record<string, string> = {
                    'test': 'test'
                  };
                  try {
                    this.comProxy.sendData(formData);
                  } catch (err) {
                    let code = (err as BusinessError).code;
                    let msg = (err as BusinessError).message;
                    console.error(`sendData failed, err code:${code}, err msg:${msg}.`);
                  }
                })
                .catch((err: BusinessError) => {
                  console.error(`connectUIServiceExtensionAbility failed, err code: ${err.code}, err msg: ${err.message}.`);
                });
            } catch (err) {
              let code = (err as BusinessError).code;
              let msg = (err as BusinessError).message;
              console.error(`connectUIServiceExtensionAbility failed, err code:${code}, err msg:${msg}.`);
            }
          })
      }
    }
  }
}
// [End connect_service_ext_start]