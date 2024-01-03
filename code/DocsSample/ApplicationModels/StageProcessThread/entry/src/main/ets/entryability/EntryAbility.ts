/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import type AbilityConstant from '@ohos.app.ability.AbilityConstant';
import type common from '@ohos.app.ability.common';
import UIAbility from '@ohos.app.ability.UIAbility';
import type Want from '@ohos.app.ability.Want';
import type { BusinessError } from '@ohos.base';
import image from '@ohos.multimedia.image';
import type resourceManager from '@ohos.resourceManager';
import type window from '@ohos.window';
import Logger from '../utils/Logger';

const TAG: string = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    let context: common.UIAbilityContext = this.context; // UIAbilityContext
    // 设置任务快照的名称
    context.setMissionLabel('test').then(() => {
      Logger.info(TAG, 'Succeeded in seting mission label.');
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to set mission label. Code is ${err.code}, message is ${err.message}`);
    });

    // 获取resourceManager资源管理
    const resourceMgr: resourceManager.ResourceManager = this.context.resourceManager;
    resourceMgr.getRawFileContent('test.jpg').then((data) => {
      Logger.info(TAG, 'data.length = ' + data.byteLength);
      // 获取图片的ArrayBuffer
      const imageSource: image.ImageSource = image.createImageSource(data.buffer);
      imageSource.createPixelMap().then((pixelMap) => {
        // 设置任务快照的图标
        context.setMissionIcon(pixelMap, (err) => {
          if (err.code) {
            Logger.error(TAG, `Failed to set mission icon. Code is ${err.code}, message is ${err.message}`);
          } else {
            Logger.info(TAG, 'Success to set mission icon.');
          }
        })
        pixelMap.release();
      }).catch((error: BusinessError) => {
        Logger.error(TAG, 'setMissionIcon failed: ' + JSON.stringify(error));
      });
    }).catch((error: BusinessError) => {
      Logger.error(TAG, 'getRawFileContent failed: ' + JSON.stringify(error));
    });
    Logger.info(TAG, 'Ability onCreate');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to load the content. Cause:', JSON.stringify(err) ?? '');
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content. Data:', JSON.stringify(data) ?? '');
    });
  }
}
