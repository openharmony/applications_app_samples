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
// [Start animator_import_start]
import { AnimatorOptions, AnimatorResult } from '@kit.ArkUI';
// [End animator_import_start]
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;
const TAG: string = '[AnimatorTest]';

@Entry
@Component
struct AnimatorPage {
  build() {
    Column({ space: 20 }) {
      Button('animation')
        .width('80%')
        .height(50)
        .backgroundColor('#007DFF')
        .fontColor(Color.White)
        .onClick(() => {
          // [Start animator_options_start]
          // 创建动画的初始参数
          let options: AnimatorOptions = {
            duration: 1500,
            easing: 'friction',
            delay: 0,
            fill: 'forwards',
            direction: 'normal',
            iterations: 2,
            // 动画onFrame 插值首帧值
            begin: 200.0,
            // 动画onFrame 插值尾帧值
            end: 400.0
          };
          let result: AnimatorResult | undefined = this.getUIContext().createAnimator(options);
          // 设置接收到帧时回调，动画播放过程中每帧会调用onFrame回调
          result.onFrame = (value: number) => {
            hilog.info(DOMAIN, TAG, 'current value is :' + value);

          }
          // [End animator_options_start]

          // [Start animator_play_start]
          // 播放动画
          result.play();
          // [End animator_play_start]

          // [Start animator_result_start]
          // 释放动画对象
          result = undefined;
          // [End animator_result_start]
        })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#F1F3F5')
    .alignItems(HorizontalAlign.Center)
  }
}