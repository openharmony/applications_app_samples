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
import { fpChangeLpx, vpChangeLpx } from './models/IssueDetailInfo';
import { KeyCode } from '@kit.InputKit';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct UseIntroduction {
  build() {
    Column() {
      Text($r('app.string.instructions'))
        .fontSize(fpChangeLpx(64))
        .fontColor($r('app.color.default_white'))
        .fontWeight(FontWeight.Bold);

      Text($r('app.string.instructions_text'))
        .fontSize(fpChangeLpx(36))
        .fontColor($r('app.color.default_white'))
        .width('100%')
        .opacity(0.86)
        .margin({ top: vpChangeLpx(71), bottom: vpChangeLpx(105) })
        .textIndent(vpChangeLpx(72))
        .fontWeight(FontWeight.Bold);

      Column() {
        Row() {
          Row() {
            Text($r('app.string.preset_conditions'))
              .fontSize(fpChangeLpx(36))
              .fontColor($r('app.color.default_white'))
              .opacity(0.86);
          }
          .width(vpChangeLpx(287))
          .height(vpChangeLpx(157))
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .border({
            width: {
              top: vpChangeLpx(0),
              bottom: vpChangeLpx(0),
              left: vpChangeLpx(0),
              right: vpChangeLpx(2)
            },
            color: $r('app.color.default_white'),
          });

          Row() {
            Column() {
              Text($r('app.string.instructions_warning'))
                .fontSize(fpChangeLpx(36))
                .fontColor($r('app.color.default_white'))
                .opacity(0.86);
            }
            .width(vpChangeLpx(541))
            .alignItems(HorizontalAlign.Start);
          }
          .width(vpChangeLpx(611))
          .height(vpChangeLpx(157))
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .border({
            width: {
              top: vpChangeLpx(0),
              bottom: vpChangeLpx(0),
              left: vpChangeLpx(0),
              right: vpChangeLpx(2)
            },
            color: $r('app.color.default_white'),
          });
        }
        .width(vpChangeLpx(898))
        .height(vpChangeLpx(157))
        .border({
          width: {
            top: vpChangeLpx(0),
            bottom: vpChangeLpx(2),
            left: vpChangeLpx(0),
            right: vpChangeLpx(0)
          },
          color: $r('app.color.default_white'),
        });

        Row() {
          Row() {
            Text($r('app.string.instructions_step'))
              .fontSize(fpChangeLpx(36))
              .fontColor($r('app.color.default_white'))
              .opacity(0.86);
          }
          .width(vpChangeLpx(287))
          .height(vpChangeLpx(211))
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .border({
            width: {
              top: vpChangeLpx(0),
              bottom: vpChangeLpx(0),
              left: vpChangeLpx(0),
              right: vpChangeLpx(2)
            },
            color: $r('app.color.default_white'),
          });

          Column() {
            Column() {
              Text($r('app.string.instructions_step_one'))
                .fontSize(fpChangeLpx(36))
                .fontColor($r('app.color.default_white'))
                .opacity(0.86);
              Text($r('app.string.instructions_step_two'))
                .fontSize(fpChangeLpx(36))
                .fontColor($r('app.color.default_white'))
                .margin({ top: vpChangeLpx(10), bottom: vpChangeLpx(10) })
                .opacity(0.86);
              Text($r('app.string.instructions_step_three'))
                .fontSize(fpChangeLpx(36))
                .fontColor($r('app.color.default_white'))
                .opacity(0.86);
            }
            .width(vpChangeLpx(541))
            .alignItems(HorizontalAlign.Start);
          }
          .width(vpChangeLpx(611))
          .height(vpChangeLpx(211))
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center);
        }
        .width(vpChangeLpx(898))
        .height(vpChangeLpx(211));
      }
      .width(vpChangeLpx(898))
      .height(vpChangeLpx(368))
      .border({
        width: vpChangeLpx(2),
        color: $r('app.color.default_white'),
      });
    }
    .onKeyEvent((event: KeyEvent) => {
      if (event.keyCode === KeyCode.KEYCODE_ESCAPE) {
        router.back();
      }
    })
    .width('100%')
    .height('100%')
    .padding({
      top: vpChangeLpx(108),
      bottom: vpChangeLpx(263),
      left: vpChangeLpx(396),
      right: vpChangeLpx(396)
    })
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.global_default_background'));
  }
}