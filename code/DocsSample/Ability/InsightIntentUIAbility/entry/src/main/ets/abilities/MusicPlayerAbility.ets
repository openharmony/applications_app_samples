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
import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0001;

export default class MusicPlayerAbility extends UIAbility {
  private windowStage: window.WindowStage | null = null;

  // 接收执行器传递的窗口舞台（用于前台模式加载页面）
  attachWindowStage(stage: window.WindowStage) {
    this.windowStage = stage;
  }

  // UIAbility创建时触发（后台/前台模式均会进入）
  onCreate(want: Want) {
    hilog.info(DOMAIN, 'testTag', `[MusicPlayerAbility] onCreate：${JSON.stringify(want)}`);
  }

  // 前台模式：窗口舞台创建时加载播放页面
  onWindowStageCreate(windowStage: window.WindowStage) {
    this.windowStage = windowStage;
    hilog.info(DOMAIN, 'testTag', `[MusicPlayerAbility]`);

    // 加载播放页面（路径对应pages目录下的PlayerPage）
    windowStage.loadContent('pages/PlayerPage', async (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag',
          `[MusicPlayerAbility] ${err.message}`);
      } else {
        hilog.info(DOMAIN, 'testTag',
          `[MusicPlayerAbility] `);
      }
    });
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'testTag', `[MusicPlayerAbility]`);
  }

  // 后台模式：UIAbility退到后台时触发
  onBackground() {
    hilog.info(DOMAIN, 'testTag', `[MusicPlayerAbility]`);
  }
}