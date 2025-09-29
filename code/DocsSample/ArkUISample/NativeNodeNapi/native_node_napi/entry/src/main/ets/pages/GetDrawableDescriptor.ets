/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import Napi from 'libentry.so';
import { DrawableDescriptor } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State sr1:Resource = $r('app.string.GetDrawableDescriptor_result0');
  @State sr2:Resource = $r('app.string.GetDrawableDescriptor_result0');
  build() {
    Row() {
      Column() {
        Text($r('app.string.GetDrawableDescriptor_label'))
          .fontSize(20)
          .margin(20)

        Text($r('app.string.GetDrawableDescriptor_label2'))
          .fontSize(20)
          .margin(20)

        Button($r('app.string.GetDrawableDescriptor_button1'))
          .onClick(() => {
            let resManager = this.getUIContext().getHostContext()?.resourceManager
            let imageRes: DrawableDescriptor = (resManager?.getDrawableDescriptor($r('app.media.foreground').id, 120)) as DrawableDescriptor;

            let res1 = Napi.processDrawable(imageRes);
            if (res1 === 0) {
              this.sr1 = $r('app.string.GetDrawableDescriptor_result1');
            } else {
              this.sr1 = $r('app.string.GetDrawableDescriptor_result2');
            }
          })
          .margin({top:40,bottom:20})

        Text(this.sr1)
          .fontSize(16)
          .margin(20)

        Button($r('app.string.GetDrawableDescriptor_button2'))
          .onClick(() => {
            let resManager = this.getUIContext().getHostContext()?.resourceManager
            let imageRes: DrawableDescriptor = (resManager?.getDrawableDescriptor($r('app.media.foreground').id)) as DrawableDescriptor;
            let res2 = Napi.processDrawable2(imageRes);
            if (res2 === 0) {
              this.sr2 = $r('app.string.GetDrawableDescriptor_result3');
            } else {
              this.sr2 = $r('app.string.GetDrawableDescriptor_result4');
            }
          })
          Text(this.sr2)
            .fontSize(16)
            .margin(20)
      }
      .width('100%')
    }
    .height('100%')
  }
}