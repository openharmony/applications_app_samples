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
// [Start animator_template4_import_start]
import { AnimatorOptions, AnimatorResult } from '@kit.ArkUI';
// [End animator_template4_import_start]
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
  // 请将$r('app.string.create')替换为实际资源文件，在本示例中该资源文件的value值为"创建"
  @State animatorStatus: Resource = $r('app.string.create');
  begin: number = 0;
  end: number = 300;
  topWidth: number = 150;
  bottomHeight: number = 100;
  g: number = 0.18;
  animatorOption: AnimatorOptions = {
    duration: 4000,
    delay: 0,
    easing: 'linear',
    iterations: 1,
    fill: 'forwards',
    direction: 'normal',
    begin: this.begin,
    end: this.end
  };
  @State translateX: number = 0;
  @State translateY: number = 0;

  // [Start animator_template4_show_start]
  onPageShow(): void {
    //创建animatorResult对象
    this.animatorOptions = this.getUIContext().createAnimator(this.animatorOption);
    this.animatorOptions.onFrame = (progress: number) => {
      this.translateX = progress;
      if (progress > this.topWidth && this.translateY < this.bottomHeight) {
        this.translateY = Math.pow(progress - this.topWidth, 2) * this.g;
      }
    }
    //动画取消时执行方法
    this.animatorOptions.onCancel = () => {
      // 请将$r('app.string.cancel')替换为实际资源文件，在本示例中该资源文件的value值为"取消"
      this.animatorStatus = $r('app.string.cancel');
    }
    //动画完成时执行方法
    this.animatorOptions.onFinish = () => {
      // 请将$r('app.string.complete')替换为实际资源文件，在本示例中该资源文件的value值为"完成"
      this.animatorStatus = $r('app.string.complete');
    }
    //动画重复播放时执行方法
    this.animatorOptions.onRepeat = () => {
      // 'repeat'资源文件中的value值为'动画重复播放'
      hilog.info(DOMAIN, TAG, this.manager.getStringByNameSync('repeat'));
    }
  }
  // [End animator_template4_show_start]

  // [Start animator_template4_hide_start]
  onPageHide(): void {
    this.animatorOptions = undefined;
  }
  // [End animator_template4_hide_start]

  build() {
    Column() {
      Column({ space: 30 }) {
        // [Start animator_template4_buttons_start]
        // 请将$r('app.string.play')替换为实际资源文件，在本示例中该资源文件的value值为"播放"
        Button($r('app.string.play')).onClick(() => {
          this.animatorOptions?.play();
          // 请将$r('app.string.playing')替换为实际资源文件，在本示例中该资源文件的value值为"播放中"
          this.animatorStatus = $r('app.string.playing');
        }).width(80).height(35)
        // 请将$r('app.string.reset')替换为实际资源文件，在本示例中该资源文件的value值为"重置"
        Button($r('app.string.reset')).onClick(() => {
          this.translateX = 0;
          this.translateY = 0;
        }).width(80).height(35)
        // 请将$r('app.string.pause')替换为实际资源文件，在本示例中该资源文件的value值为"暂停"
        Button($r('app.string.pause')).onClick(() => {
          this.animatorOptions?.pause();
          // 请将$r('app.string.pause')替换为实际资源文件，在本示例中该资源文件的value值为"暂停"
          this.animatorStatus = $r('app.string.pause');
        }).width(80).height(35)
        // [End animator_template4_buttons_start]
      }.width('100%').height('25%')

      Stack() {
        // [Start animator_template4_button_start]
        Button()
          .width(60)
          .height(60)
          .translate({ x: this.translateX, y: this.translateY })
        // [End animator_template4_button_start]
      }
      .width('100%')
      .height('45%')
      .align(Alignment.Start)
      // 'animatorStatus'资源文件中的value值为'当前动画状态为:'
      Text(this.manager.getStringByNameSync('animatorStatus') + this.animatorStatus)
    }.width('100%').height('100%')
  }
}