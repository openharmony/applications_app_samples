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
import { ArgumentsControlPanel } from './GridContainerControlPanel';

@Extend(Column) function backgroundStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(16)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.SpaceAround)
}

@Extend(Text) function elementStyle(color: Resource) {
  .height(50)
  .backgroundColor(color)
  .textAlign(TextAlign.Center)
}

@Entry
@Component
struct GridContainerSample {
  @State sizeType: SizeType = SizeType.Auto;
  @State gutter: number = 10;
  @State gridMargin: number = 10;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.gridcontainer_title') })
      Scroll() {
        Column() {
          Column() {
            GridContainer({ columns: 12, sizeType: this.sizeType, gutter: this.gutter, margin: this.gridMargin }) {
              Row() {
                Text('1')
                  .useSizeType({
                    xs: { span: 6, offset: 0 },
                    sm: { span: 2, offset: 0 },
                    md: { span: 2, offset: 0 },
                    lg: { span: 2, offset: 0 }
                  })
                  .elementStyle($r('app.color.background_pink'))
                Text('2')
                  .useSizeType({
                    xs: { span: 2, offset: 6 },
                    sm: { span: 6, offset: 2 },
                    md: { span: 2, offset: 2 },
                    lg: { span: 2, offset: 2 }
                  })
                  .elementStyle($r('app.color.background_orange'))
                Text('3')
                  .useSizeType({
                    xs: { span: 2, offset: 8 },
                    sm: { span: 2, offset: 8 },
                    md: { span: 6, offset: 4 },
                    lg: { span: 2, offset: 4 }
                  })
                  .elementStyle($r('app.color.background_pink'))
                Text('4')
                  .useSizeType({
                    xs: { span: 2, offset: 10 },
                    sm: { span: 2, offset: 10 },
                    md: { span: 2, offset: 10 },
                    lg: { span: 6, offset: 6 }
                  })
                  .elementStyle($r('app.color.background_orange'))
              }
            }
            .width('90%')
          }
          .backgroundStyle()

          IntroductionTitle({ introduction: $r('app.string.gridcontainer_introdional_arguments') })
          Column() {
            ArgumentsControlPanel(
              {
                sizeType: $sizeType,
                gutter: $gutter,
                gridMargin: $gridMargin
              }
            )
          }
          .backgroundStyle()
        }
        .width('100%')
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .margin({ bottom: 80 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}