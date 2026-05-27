/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start startOptions_bgColor_and_windowParam]
import { AbilityConstant, StartOptions, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';

const DOMAIN = 0x0000;
const TAG: string = '[StartAbility]';
const DOMAIN_NUMBER: number = 0xFF00;

export default class SetBackgroundColorAbility extends UIAbility {
  // [StartExclude startOptions_bgColor_and_windowParam]
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }
  // [EndExclude startOptions_bgColor_and_windowParam]

  async onForeground(): Promise<void> {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');

    let want: Want = {
      deviceId: '', // deviceId为空表示本设备
      bundleName: 'com.example.startoptions',
      abilityName: 'EntryAbility',
      parameters: {
        // 自定义信息
        info: '从EntryAbility启动'
      }
    };

    // 创建PixelMap对象
    let color = new ArrayBuffer(512 * 512 * 4);
    let bufferArr = new Uint8Array(color);
    for (let i = 0; i < bufferArr.length; i += 4) {
      bufferArr[i] = 255;
      bufferArr[i+1] = 0;
      bufferArr[i+2] = 122;
      bufferArr[i+3] = 255;
    }

    let windowParam: window.WindowCreateParams = {};

    let options: StartOptions = {
      startWindowIcon: await image.createPixelMap(color, {
        editable: true,
        pixelFormat: image.PixelMapFormat.RGBA_8888,
        size: { height: 512, width: 512 }

      }),
      startWindowBackgroundColor: '#E510FFFF', // ARGB格式
      minWindowWidth: 320,
      minWindowHeight: 240,
      maxWindowWidth: 2560,
      maxWindowHeight: 2560,
      windowCreateParams: windowParam
    };

    this.context.startAbility(want, options).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting ability.');
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability. Code is ${err.code}, message is ${err.message}`);
    });

  }

  // [StartExclude startOptions_bgColor_and_windowParam]
  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
  // [EndExclude startOptions_bgColor_and_windowParam]
}
// [End startOptions_bgColor_and_windowParam]
