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

import router from '@ohos.router'

interface listItem {
  router?: string;
  name: string;
  description?: string;
}

let demandList: listItem[] = [
  {
    name: '设置局部字体缩放',
    router: 'pages/developmentDemo/FontScale',
  },
  {
    name: '设置局部布局方向',
    router: 'pages/developmentDemo/LayoutDirection',
  },
  {
    name: '设置自定义环境变量',
    router: 'pages/developmentDemo/CustomEnv',
  },
  {
    name: '嵌套作用域',
    router: 'pages/specifications/NestedScopes',
  }
]

@Entry
@Component
struct MainPage {
  @State bgColor: ResourceColor = '#39b5fa';

  build() {
    Column() {
      Text($r('app.string.build_layout'))
        .height('5%')
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(this.bgColor)
        .fontColor(Color.White)

      Column() {
        List({ space: 20, initialIndex: 0 }) {
          ForEach(demandList, (listitem: listItem, index: number) => {
            ListItem() {
              Column() {
                Text(listitem.name)
                  .fontSize(15)
                  .fontColor(this.bgColor)
                  .maxLines(1)
              }
              .onClick(() => {
                if (!!listitem.router) {
                  this.getUIContext().getRouter().pushUrl({ url: listitem.router })
                }
              })
            }
          })
        }
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .friction(0.6)
        .divider({
          strokeWidth: 2,
          color: 0xFFFFFF,
          startMargin: 20,
          endMargin: 20
        })
        .edgeEffect(EdgeEffect.Spring)
        .contentEndOffset(50)
        .width('90%')
      }
      .width('100%')
      // .height('100%')
      .backgroundColor('#fff4f3f3')
      .padding({ top: 5 })
    }
  }
}