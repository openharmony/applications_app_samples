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
import hilog from '@ohos.hilog';
import commonEventManager from '@ohos.commonEventManager';

const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    let context: common.UIAbilityContext = this.context; // UIAbilityContext
    // 设置任务快照的名称
    context.setMissionLabel('test').then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in seting mission label.');
    }).catch((err: BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, `Failed to set mission label. Code is ${err.code}, message is ${err.message}`);
    });

    // 获取resourceManager资源管理
    const resourceMgr: resourceManager.ResourceManager = this.context.resourceManager;
    resourceMgr.getRawFileContent('test.jpg').then((data) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'data.length = ' + data.byteLength);
      // 获取图片的ArrayBuffer
      const imageSource: image.ImageSource = image.createImageSource(data.buffer);
      imageSource.createPixelMap().then((pixelMap) => {
        // 设置任务快照的图标
        context.setMissionIcon(pixelMap, (err) => {
          if (err.code) {
            hilog.error(DOMAIN_NUMBER, TAG, `Failed to set mission icon. Code is ${err.code}, message is ${err.message}`);
          } else {
            hilog.info(DOMAIN_NUMBER, TAG, 'Success to set mission icon.');
          }
        })
        pixelMap.release();
      }).catch((error: BusinessError) => {
        hilog.error(DOMAIN_NUMBER, TAG, 'setMissionIcon failed: ' + JSON.stringify(error));
      });
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, 'getRawFileContent failed: ' + JSON.stringify(error));
    });
    hilog.info(DOMAIN_NUMBER, TAG, 'Ability onCreate');
  }

  // onDestroy():void {
  //   commonEventManager.removeStickyCommonEvent('usual.event.SCREEN_OFF', (err: Base.BusinessError) => {
  //     // sticky_event粘性公共事件名
  //     if (err) {
  //       hilog.error(DOMAIN_NUMBER, TAG, `Failed to remove sticky common event. Code is ${err.code}, message is ${err.message}`);
  //       return;
  //     }
  //     hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in removeing sticky event.`);
  //   });
  // }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN_NUMBER, TAG, 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(DOMAIN_NUMBER, TAG, 'Failed to load the content. Cause:', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in loading the content. Data:', JSON.stringify(data) ?? '');
    });
  }
}
