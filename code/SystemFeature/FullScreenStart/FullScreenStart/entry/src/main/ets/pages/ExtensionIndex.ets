/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { common } from '@kit.AbilityKit';
import AtomicServiceOptions from '@ohos.app.ability.AtomicServiceOptions';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  // Developers need to create an AtomicService within AppGallery Connect and replace this appId.
  private appId: string = '5765880207854787517';
  private options: AtomicServiceOptions = {
    displayId: 0
  };
  private extensionContext = getContext(this) as common.UIExtensionContext;

  build() {
    Row() {
      Column() {
        Button($r('app.string.UIExtensionStart'))
          .onClick((event: ClickEvent) => {
            try {
              this.extensionContext.openAtomicService(this.appId, this.options)
                .then((result: common.AbilityResult) => {
                  hilog.info(0x0000, 'testTag', 'UIExtensionContext.openAtomicService succeed');
                })
                .catch((err: BusinessError) => {
                  hilog.error(0x0000, 'testTag',
                    `UIExtensionContext.openAtomicService failed, code is ${err.code}, message is ${err.message}`);
                });
            } catch (err) {
              let code = (err as BusinessError).code;
              let message = (err as BusinessError).message;
              hilog.error(0x0000, 'testTag',
                `UIExtensionContext.openAtomicService failed, code is ${code}, message is ${message}`);
            }
          })
          .id('UIExtensionStart')
          .width('93.4%').height('100%')
      }
      .width('100%').height('100%')
    }
  }
}
