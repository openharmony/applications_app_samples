/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import { ArgumentsControlPanel, ZIndexControlPanel } from './StackControlPanel'

@Extend(Column) function backgroundStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(16)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.SpaceAround)
}

@Extend(Text) function textStyle(width: number, height: number, backgroundColor: ResourceColor) {
  .height(height)
  .width(width)
  .backgroundColor(backgroundColor)
  .textAlign(TextAlign.End)
  .align(Alignment.BottomEnd)
}

@Entry
@Component
struct StackSample {
  @State alignContent: Alignment = Alignment.TopStart;
  @State zindex: number = 1

  build() {
    Column() {
      TitleBar({ title: $r('app.string.stack_title') })
      Scroll() {
        Column() {
          Column() {
            Stack() {
              Text('Sub three')
                .textStyle(150, 150, $r('app.color.background_orange'))
                .zIndex(this.zindex)
              Text('Sub two')
                .textStyle(100, 100, $r('app.color.background_light_gray'))
                .zIndex(2)
              Text('Sub one')
                .textStyle(50, 50, $r('app.color.background_pink'))
                .zIndex(3)
            }
            .height('100%')
            .width('100%')
            .alignContent(this.alignContent)
          }
          .backgroundStyle()
          .height(400)

          Column() {
            IntroductionTitle({ introduction: $r('app.string.stack_introduction') })
            Column() {
              ArgumentsControlPanel({ alignContent: $alignContent })
            }
            .backgroundStyle()
          }

          Column() {
            IntroductionTitle({ introduction: $r('app.string.stack_introduction_zindex') })
            Column() {
              ZIndexControlPanel({
                zindex: $zindex
              })
            }
            .backgroundStyle()
          }
        }
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}