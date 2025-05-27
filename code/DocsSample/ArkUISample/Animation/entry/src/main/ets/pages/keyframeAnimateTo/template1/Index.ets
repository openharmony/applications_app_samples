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
import { UIContext } from '@kit.ArkUI';

@Entry
@Component
struct KeyframeDemo {
  @State myScale: number = 1.0;
  uiContext: UIContext | undefined = undefined;

  aboutToAppear() {
    this.uiContext = this.getUIContext?.();
  }

  build() {
    Column() {
      Circle()
        .width(100)
        .height(100)
        .fill("#46B1E3")
        .margin(100)
        .scale({ x: this.myScale, y: this.myScale })
        .onClick(() => {
          if (!this.uiContext) {
            console.info("no uiContext, keyframe failed");
            return;
          }
          this.myScale = 1;
          // 设置关键帧动画整体播放3次
          this.uiContext.keyframeAnimateTo({
            iterations: 3,
            expectedFrameRateRange: {
              min: 10,
              max: 120,
              expected: 60,
            }
          }, [
            {
              // 第一段关键帧动画时长为800ms，scale属性做从1到1.5的动画
              duration: 800,
              event: () => {
                this.myScale = 1.5;
              }
            },
            {
              // 第二段关键帧动画时长为500ms，scale属性做从1.5到1的动画
              duration: 500,
              event: () => {
                this.myScale = 1;
              }
            }
          ]);
        })
    }.width('100%').margin({ top: 5 })
  }
}