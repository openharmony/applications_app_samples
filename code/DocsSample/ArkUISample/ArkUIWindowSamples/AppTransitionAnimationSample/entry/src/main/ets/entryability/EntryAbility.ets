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
// [Start window_destroy_transition_animation]
import { UIAbility } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    try {
      // 获取主窗口
      const windowClass = await windowStage.getMainWindow();

      // 配置窗口销毁动画
      this.setupWindowDestroyAnimation(windowClass);

      // 加载页面
      windowStage.loadContent('pages/Index', (err) => {
        if (err.code) {
          hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
          return;
        }
        hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
      });
    } catch (err) {
      console.error(`Failed to obtain the main window. Cause code: ${err.code}, message: ${err.message}`);
    }
  }

  private setupWindowDestroyAnimation(windowClass: window.Window): void {
    try {
      // 检查是否已存在销毁动画配置
      const existingAnimation = windowClass.getWindowTransitionAnimation(
        window.WindowTransitionType.DESTROY
      );

      if (existingAnimation) {
        return;
      }

      // 配置动画
      const animationConfig: window.WindowAnimationConfig = {
        duration: 1000,
        curve: window.WindowAnimationCurve.LINEAR,
      };

      const transitionAnimation: window.TransitionAnimation = {
        opacity: 0.0,
        config: animationConfig
      };

      // 设置动画
      windowClass.setWindowTransitionAnimation(
        window.WindowTransitionType.DESTROY,
        transitionAnimation
      ).then(() => {
        console.info('Succeeded in setting window transition animation');
      }).catch((err: BusinessError) => {
        console.error(`Failed to set window transition animation. Cause: ${err.message}`);
      });
    } catch (exception) {
      console.error(`Failed to setup window animation. Cause: ${exception.message}`);
    }
  }
}
// [End window_destroy_transition_animation]
