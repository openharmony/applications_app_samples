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
// [Start window_animation_show]
import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { AnimationConfig } from './AnimationConfig';

@Entry
@Component
// [Start window_animation_complete_transition]
struct WindowAnimationDemo {
  // [StartExclude window_animation_show]
  // [StartExclude window_animation_complete_transition]
  private systemWinClass?: window.Window;
  async createSystemWindow() {
    let context = getContext(this) as common.UIAbilityContext;
    let config: window.Configuration = {
      name: 'dynamicWindow',
      windowType: window.WindowType.TYPE_FLOAT,
      ctx: context
    };
    try {
      // 创建系统窗口
      let windowObj: window.Window = await window.createWindow(config);
      this.systemWinClass = windowObj;
      await windowObj.setUIContent('pages/WindowContent');
      await windowObj.moveWindowTo(0, 200);
      await windowObj.resize(400, 200);
      windowObj.opacity(0.0);
      this.showWindow();
    } catch (err) {
      console.error('创建窗口失败: ' + JSON.stringify(err));
    }
  }
  // [EndExclude window_animation_show]
  // [EndExclude window_animation_complete_transition]
  showWindow() {
    // [StartExclude window_animation_complete_transition]
    let systemTypeWindow = window.findWindow('dynamicWindow'); // 此处需要获取一个系统类型窗口。
    let animationConfig = new AnimationConfig();
    // [EndExclude window_animation_complete_transition]
    try {
      // 设置窗口显示过程动画效果
      animationConfig?.ShowWindowWithCustomAnimation(systemTypeWindow, (context : window.TransitionContext)=>{
        let toWindow = context.toWindow;
        let sysWindowUIContext = systemTypeWindow.getUIContext();
        // 2.配置具体的属性动画
        sysWindowUIContext.animateTo({
          // [StartExclude window_animation_show]
          // [StartExclude window_animation_complete_transition]
          duration: 1000, // 动画时长
          tempo: 0.5, // 播放速率
          curve: Curve.Linear, // 动画曲线
          delay: 0, // 动画延迟
          iterations: 1, // 播放次数
          playMode: PlayMode.Normal, // 动画模式
          // [EndExclude window_animation_complete_transition]
          onFinish: () => {
            console.info('onFinish in animation');
            // 3.设置属性转换的最终完成状态
            context.completeTransition(true);
          }
          // [EndExclude window_animation_show]
        }, () => {
          // [StartExclude window_animation_complete_transition]
          let translateObj : window.TranslateOptions = {
            x : 400.0,
            y : 400.0,
            z : 0.0
          };
          toWindow?.translate(translateObj); // 设置平移参数
          let rotateObj: window.RotateOptions = {
            x: 1.0,
            y: 1.0,
            z: 360.0,
            pivotX: 0.5,
            pivotY: 0.5
          };
          toWindow?.rotate(rotateObj); // 设置旋转参数
          let scaleObj: window.ScaleOptions = {
            x: 2.0,
            y: 2.0,
            pivotX: 0.5,
            pivotY: 0.5
          };
          toWindow?.scale(scaleObj); // 设置缩放参数
          toWindow?.opacity(1); // 设置透明度参数
          console.info('animation end');
          // [EndExclude window_animation_complete_transition]
        });
        console.info('complete transition end');
      });
    } catch (error) {
      console.error(`ShowWindowWithCustomAnimation error code: ${error.code}, message: ${error.message}` );
    }
  }
  // [StartExclude window_animation_show]
  // [StartExclude window_animation_complete_transition]
  hideWindow() {
    let animationConfig = new AnimationConfig();
    let systemTypeWindow = window.findWindow('dynamicWindow'); // 此处需要获取一个系统类型窗口。
    try {
      // 设置窗口隐藏过程动画效果
      animationConfig?.HideWindowWithCustomAnimation(systemTypeWindow, (context : window.TransitionContext)=>{
        let toWindow = context.toWindow;
        let sysWindowUIContext = systemTypeWindow.getUIContext();
        sysWindowUIContext?.animateTo({
          duration: 1000, // 动画时长
          tempo: 0.5, // 播放速率
          curve: Curve.EaseInOut, // 动画曲线
          delay: 0, // 动画延迟
          iterations: 1, // 播放次数
          playMode: PlayMode.Normal, // 动画模式
          onFinish: () => {
            console.info('onFinish in animation');
            context.completeTransition(true);
            this.systemWinClass?.destroyWindow();
          }
        }, () => {
          let translateObj : window.TranslateOptions = {
            x : 0.0,
            y : 200.0,
            z : 0.0
          };
          toWindow?.translate(translateObj); // 设置动画过程中的属性转换
          let rotateObj: window.RotateOptions = {
            x: 1.0,
            y: 1.0,
            z: -360.0,
            pivotX: 0.5,
            pivotY: 0.5
          };
          toWindow?.rotate(rotateObj);
          let scaleObj: window.ScaleOptions = {
            x: 1.0,
            y: 1.0,
            pivotX: 0.5,
            pivotY: 0.5
          };
          toWindow?.scale(scaleObj);
          toWindow?.opacity(0);
          console.info('animation end');
        });
      });
    } catch (error) {
      console.error(`HideWindowWithCustomAnimation error code: ${error.code}, message: ${error.message}` );
    }
  }
  build() {
    Column() {
      Button('show window')
        .onClick(() => this.createSystemWindow());
      Button('hide window')
        .margin({top: 20})
        .onClick(() => this.hideWindow());
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center);
  }
  // [EndExclude window_animation_show]
  // [EndExclude window_animation_complete_transition]
}
// [End window_animation_show]
// [End window_animation_complete_transition]
