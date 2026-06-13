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

// [Start LayoutDirection]
// xxx.ets
import { WithEnv } from '@kit.ArkUI';

@Entry
@Component
struct DirectionExample {
  @State direction1: Direction = Direction.Ltr;
  @State direction2: Direction = Direction.Rtl;

  build() {
    Scroll() {
      Column({ space: 16 }) {
        // 初始Ltr布局方向
        WithEnv() {
          Column({ space: 8 }) {
            Row({ space: 8 }) {
              Text('1')
                .fontSize(14)
                .fontColor('#FFFFFF')
                .backgroundColor('#007DFF')
                .borderRadius(6)
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              Text('2')
                .fontSize(14)
                .fontColor('#007DFF')
                .backgroundColor('#F0FAFF')
                .borderRadius(6)
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              Text('3')
                .fontSize(14)
                .fontColor('#FFFFFF')
                .backgroundColor('#2787D9')
                .borderRadius(6)
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            }
          }
          .width('100%')
          .padding(16)
          .borderRadius(12)
          .backgroundColor('#F1F3F5')
        }
        .env(WritableEnvKey.DIRECTION, this.direction1)

        // 初始Rtl布局方向
        WithEnv() {
          Column({ space: 8 }) {
            Row({ space: 8 }) {
              Text('1')
                .fontSize(14)
                .fontColor('#FFFFFF')
                .backgroundColor('#007DFF')
                .borderRadius(6)
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              Text('2')
                .fontSize(14)
                .fontColor('#007DFF')
                .backgroundColor('#F0FAFF')
                .borderRadius(6)
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              Text('3')
                .fontSize(14)
                .fontColor('#FFFFFF')
                .backgroundColor('#2787D9')
                .borderRadius(6)
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            }
          }
          .width('100%')
          .padding(16)
          .borderRadius(12)
          .backgroundColor('#F1F3F5')
        }
        .env(WritableEnvKey.DIRECTION, this.direction2)
        // 设置direction属性
        WithEnv() {
          Column({ space: 8 }) {
            Text('单独设置direction属性')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#182431')

            Row({ space: 8 }) {
              Text('1')
                .fontSize(14)
                .fontColor('#FFFFFF')
                .backgroundColor('#007DFF')
                .borderRadius(6)
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              Text('2')
                .fontSize(14)
                .fontColor('#007DFF')
                .backgroundColor('#F0FAFF')
                .borderRadius(6)
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              Text('3')
                .fontSize(14)
                .fontColor('#FFFFFF')
                .backgroundColor('#2787D9')
                .borderRadius(6)
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            }
            .direction(Direction.Ltr)
          }
          .width('100%')
          .padding(16)
          .borderRadius(12)
          .backgroundColor('#F1F3F5')
        }
        .env(WritableEnvKey.DIRECTION, this.direction1)

        Button('切换布局方向')
          .onClick(() => {
            if (this.direction1 === Direction.Ltr) {
              this.direction1 = Direction.Rtl;
            } else {
              this.direction1 = Direction.Ltr;
            }
            if (this.direction2 === Direction.Ltr) {
              this.direction2 = Direction.Rtl;
            } else {
              this.direction2 = Direction.Ltr;
            }
          })
      }
      .width('100%')
      .padding(16)
    }
    .width('100%')
    .height('100%')
  }
}
// [End LayoutDirection]