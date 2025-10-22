/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

@Entry
@Component
struct RelativeContainerComponentSize {
  build() {
    Row() {
      RelativeContainer() {
        Row() {
          Text('row1')
        }
        .justifyContent(FlexAlign.Center)
        .width(100)
        .height(100)
        .backgroundColor('#a3cf62')
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .id('row1')

        Row() {
          Text('row2')
        }
        .justifyContent(FlexAlign.Center)
        .width(100)
        .backgroundColor('#00ae9d')
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End },
          bottom: { anchor: 'row1', align: VerticalAlign.Center },
        })
        .id('row2')

        Row() {
          Text('row3')
        }
        .justifyContent(FlexAlign.Center)
        .height(100)
        .backgroundColor('#0a59f7')
        .alignRules({
          top: { anchor: 'row1', align: VerticalAlign.Bottom },
          left: { anchor: 'row1', align: HorizontalAlign.End },
          right: { anchor: 'row2', align: HorizontalAlign.Start }
        })
        .id('row3')

        Row() {
          Text('row4')
        }.justifyContent(FlexAlign.Center)
        .backgroundColor('#2ca9e0')
        .alignRules({
          top: { anchor: 'row3', align: VerticalAlign.Bottom },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          right: { anchor: 'row1', align: HorizontalAlign.End }
        })
        .id('row4')

        Row() {
          Text('row5')
        }.justifyContent(FlexAlign.Center)
        .backgroundColor('#30c9f7')
        .alignRules({
          top: { anchor: 'row3', align: VerticalAlign.Bottom },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          left: { anchor: 'row2', align: HorizontalAlign.Start },
          right: { anchor: 'row2', align: HorizontalAlign.End }
        })
        .id('row5')

        Row() {
          Text('row6')
        }
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#ff33ffb5')
        .alignRules({
          top: { anchor: 'row3', align: VerticalAlign.Bottom },
          bottom: { anchor: 'row4', align: VerticalAlign.Bottom },
          left: { anchor: 'row3', align: HorizontalAlign.Start },
          right: { anchor: 'row3', align: HorizontalAlign.End }
        })
        .id('row6')
        .backgroundImagePosition(Alignment.Bottom)
        .backgroundImageSize(ImageSize.Cover)
      }
      .width(300).height(300)
      .margin({ left: 50 })
      .border({ width: 2, color: '#6699FF' })
    }
    .height('100%')
  }
}