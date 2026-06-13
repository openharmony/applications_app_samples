/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
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

// [Start FontScale]
// xxx.ets
import { WithEnv } from '@kit.ArkUI';
@Entry
@Component
struct FontScaleExample {
  @State fontScale: number = 1.0;

  build() {
    Column({ space: 12 }) {
      Row({ space: 8 }) {
        Button('缩小 0.5x')
          .onClick(() => {
            this.fontScale = 0.5;
          })
        Button('正常 1.0x')
          .onClick(() => {
            this.fontScale = 1.0;
          })
        Button('放大 1.5x')
          .onClick(() => {
            this.fontScale = 1.5;
          })
      }

      WithEnv() {
        Column({ space: 8 }) {
          Text('当前字体缩放作用域内的文本')
            .fontSize(16)
          Text('该文本同样受 WithEnv 字体缩放影响')
            .fontSize(14)
            .fontColor('#99182431')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
      .env(WritableEnvKey.FONT_SCALE, this.fontScale)
    }
    .padding(12)
    .width('100%')
  }
}
// [End FontScale]