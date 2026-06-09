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
// [Start window_animation_config]
// [Start window_animation_play]
import { window } from '@kit.ArkUI';

export class AnimationConfig {
  private animationForShownCallFunc_: ((context : window.TransitionContext) => void) | undefined = undefined;
  private animationForHiddenCallFunc_: ((context : window.TransitionContext) => void) | undefined = undefined;

  ShowWindowWithCustomAnimation(windowClass: window.Window, callback: (context : window.TransitionContext) => void) {
    // [StartExclude window_animation_play]
    if (!windowClass) {
      console.error('windowClass is undefined');
      return false;
    }
    this.animationForShownCallFunc_ = callback;
    // 1.获取窗口属性转换控制器。
    let controller: window.TransitionController = windowClass.getTransitionController();
    // [EndExclude window_animation_play]
    // 窗口显示时的自定义动画配置。
    controller.animationForShown = (context : window.TransitionContext)=> {
      this.animationForShownCallFunc_(context);
    };
    // [StartExclude window_animation_config]
    // 4.显示窗口并播放动画
    windowClass.showWithAnimation(()=>{
      console.info('Show with animation success');
    });
    // [EndExclude window_animation_config]
  }

  // [StartExclude window_animation_config]
  // [StartExclude window_animation_play]
  HideWindowWithCustomAnimation(windowClass: window.Window, callback: (context : window.TransitionContext) => void) {
    if (!windowClass) {
      console.error('windowClass is undefined');
      return false;
    }
    this.animationForHiddenCallFunc_ = callback;
    // 1.获取窗口属性转换控制器。
    let controller: window.TransitionController = windowClass.getTransitionController();
    // 窗口隐藏时的自定义动画配置。
    controller.animationForHidden = (context : window.TransitionContext)=> {
      this.animationForHiddenCallFunc_(context);
    };
    // 4.隐藏窗口并播放动画
    windowClass.hideWithAnimation(()=>{
      console.info('hide with animation success');
    });
  }
  // [EndExclude window_animation_config]
  // [EndExclude window_animation_play]
}
// [End window_animation_config]
// [End window_animation_play]
