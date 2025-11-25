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
// [Start animator_template3_start]
import { AnimatorOptions, AnimatorResult } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;
const TAG: string = '[AnimatorTest]';

@Entry
@Component
struct Index {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private manager = this.context.resourceManager;
  @State animatorOptions: AnimatorResult | undefined = undefined;
  // 'create'资源文件中的value值为'创建'
  @State animatorStatus: string = 'create';
  begin: number = 0;
  end: number = 300;
  topWidth: number = 150;
  bottomHeight: number = 100;
  // 自由落体运动的加速度系数
  g: number = 0.18;
  animatorOption: AnimatorOptions = {
    duration: 4000,
    delay: 0,
    easing: 'linear',
    iterations: 1,
    fill: "forwards",
    direction: 'normal',
    begin: this.begin,
    end: this.end
  };
  @State translateX: number = 0;
  @State translateY: number = 0;

  onPageShow(): void {
    this.animatorOptions = this.getUIContext().createAnimator(this.animatorOption);
    this.animatorOptions.onFrame = (progress: number) => {
      this.translateX = progress;
      if (progress > this.topWidth && this.translateY < this.bottomHeight) {
        this.translateY = Math.pow(progress - this.topWidth, 2) * this.g;
      }
    }
    this.animatorOptions.onCancel = () => {
      // 'cancel'资源文件中的value值为'取消'
      this.animatorStatus = 'cancel';
    }
    this.animatorOptions.onFinish = () => {
      // 'complete'资源文件中的value值为'完成'
      this.animatorStatus = 'complete';
    }
    this.animatorOptions.onRepeat = () => {
      // 'repeat'资源文件中的value值为'动画重复播放'
      hilog.info(DOMAIN, TAG, this.manager.getStringByNameSync('repeat'));
    }
  }

  onPageHide(): void {
    this.animatorOptions = undefined;
  }

  build() {
    Column() {
      Column({ space: 30 }) {
        // $r('app.string.play')资源文件中的value值为'播放'
        Button($r('app.string.play')).onClick(() => {
          this.animatorOptions?.play();
          // 'playing'资源文件中的value值为'播放中'
          this.animatorStatus = 'playing';
        }).width(80).height(35)
        // $r('app.string.reset')资源文件中的value值为'重置'
        Button($r('app.string.reset')).onClick(() => {
          this.translateX = 0;
          this.translateY = 0;
        }).width(80).height(35)
        // $r('app.string.pause')资源文件中的value值为'暂停'
        Button($r('app.string.pause')).onClick(() => {
          this.animatorOptions?.pause();
          // 'pause'资源文件中的value值为'暂停'
          this.animatorStatus = 'pause';
        }).width(80).height(35)
      }.width('100%').height('25%')

      Stack() {
        Button()
          .width(60)
          .height(60)
          .translate({ x: this.translateX, y: this.translateY })
      }
      .width('100%')
      .height('45%')
      .align(Alignment.Start)
      // 'animatorStatus'资源文件中的value值为'当前动画状态为:'
      Text(this.manager.getStringByNameSync('animatorStatus') + this.manager.getStringByNameSync(this.animatorStatus))
    }.width('100%').height('100%')
  }
}
// [End animator_template3_start]