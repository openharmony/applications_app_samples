/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {ShareExtensionAbility, Want } from '@kit.AbilityKit';

import Logger from '../utils/Logger';

import { BusinessError } from '@kit.BasicServicesKit';
import { floatWindowManager } from '../utils/FloatWindowManager';
import { commonEventManager } from '@kit.BasicServicesKit';


const TAG = 'FloatWindowAbility';

export default class FloatWindowAbility extends ShareExtensionAbility {

  onCreate(launchParam: object): void {
    Logger.info(TAG, 'FloatWindowAbility onCreate');
  }

  onRequest(want: Want, startId: number): void {
    Logger.info(TAG, 'FloatWindowAbility onRequest');
  }

  onDestroy(): void {
    Logger.info(TAG, 'FloatWindowAbility onDestroy');
    try {
          // 公共事件相关信息，以发布有序公共事件为例，每次悬浮窗销毁，都通知systemUI，让其不相识增加的控制栏
          let options: commonEventManager.CommonEventPublishData = {
            parameters: { isFloatWindowDestroy: false }
          }
          commonEventManager.publish('isFloatWindowDestroy', options, (err: BusinessError) => {
            if (err) {
              console.error('update12-->',
                `Failed to publish common event. Code is ${err.code}, message is ${err.message}`);
              return;
            }
            console.log('update12-->', `Succeeded in publishing common event.`);
          });
        } catch (error) {
          console.error('update12-->', `Failed to publish common event：` + JSON.stringify(error));
        }
    floatWindowManager.destroy().catch(() => {
        Logger.error(TAG, `销毁悬浮窗失败`);
      });
  }
}