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

interface listItem {
  router?: string;
  name: string;
}

let demandList: listItem[] = [
  {
    name: "ButtonAlignTop",
    router: "pages/ButtonAlignTop",
  },
  {
    name: "ButtonAlignBottom",
    router: "pages/ButtonAlignBottom",
  },
  {
    name: "ButtonBcgColor",
    router: "pages/ButtonBcgColor",
  },
  {
    name: "ButtonBrightness",
    router: "pages/ButtonBrightness",
  },
  {
    name: "ButtonFontColor",
    router: "pages/ButtonFontColor",
  },
  {
    name: "ButtonShadow",
    router: "pages/ButtonShadow",
  },
];

@Entry
@Component
struct Index {
  @State bgColor: ResourceColor = '#39b5fa';
  
  build() {
    Column() {
      Text($r('app.string.ListShow'))
        .height('5.00%')
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontSize(10)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(this.bgColor)
        .fontColor(Color.White)
      Column() {
        List({ space: 5, initialIndex: 0 }) {
          ForEach(demandList, (listitem: listItem, index: number) => {
            ListItem() {
              Column({ space: 10 }) {
                Text(listitem.name)
                  .fontSize(10)
                  .maxLines(1)
              }
              .padding('1%')
              .width('100%')
              .borderRadius(10)
              .backgroundColor(this.bgColor)
              .borderColor(this.bgColor)
              .borderWidth(1)
              .onClick(() => {
                if (!!listitem.router) {
                  this.getUIContext().getRouter().pushUrl({ url: listitem.router });
                }
              })
            }
          })
        }
        .listDirection(Axis.Vertical) // 排列方向
        .alignListItem(ListItemAlign.Center)
        .scrollBar(BarState.Off)
        .margin(1)
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
        .width('90%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fff4f3f3')
      .padding({ top: 5 })
    }
  }
}