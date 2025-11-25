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

// [Start multiple_finger_information]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_MultipleFingerInformation]';
const DOMAIN = 0xF811;
const BUNDLE = 'MyApp_MultipleFingerInformation';

@Entry
@ComponentV2
struct MultipleFingerInformation {
  private currentFingerCount: number = 0;
  private allFingerIds: number[] = [];

  build() {
    RelativeContainer() {
      Column()
        .backgroundColor(Color.Green)
        .height('100%')
        .width('100%')
        .onTouch((event: TouchEvent) => {
          if (event.source !== SourceType.TouchScreen) {
            return;
          }
          // clear数组
          this.allFingerIds.splice(0, this.allFingerIds.length);
          // 从event中获取所有触点信息
          let allFingers = event.touches;
          if (allFingers.length > 0 && this.currentFingerCount === 0) {
            // 第1根手指按下
            hilog.info(DOMAIN, TAG, BUNDLE + 'fingers start to press down');
            this.currentFingerCount = allFingers.length;
          }
          if (allFingers.length !== 0) {
            for (const finger of allFingers) {
              this.allFingerIds.push(finger.id);
            }
            hilog.info(DOMAIN, TAG, BUNDLE + 'current all fingers : ' + this.allFingerIds.toString());
          }
          if (event.type === TouchType.Up && event.touches.length === 1) {
            // 所有手指都已抬起
            hilog.info(DOMAIN, TAG, BUNDLE + 'all fingers already up');
            this.currentFingerCount = 0;
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End multiple_finger_information]