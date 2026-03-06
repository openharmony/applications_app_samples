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
    name: '通过状态变量切换布局算法',
    router: 'pages/responsivelayout/ChangeLayoutAlgorithm',
  },
  {
    name: '通过条件运算符切换布局算法',
    router: 'pages/responsivelayout/ChangeLayoutWithConditionVariable',
  },
  {
    name: '通过修改算法属性触发重新布局',
    router: 'pages/responsivelayout/ChangeAlgorithmProperties',
  },
  {
    name: '响应式布局算法切换',
    router: 'pages/responsivelayout/ChangeLayoutWithMediaQuery',
  },
  {
    name: '布局切换保持子组件状态',
    router: 'pages/responsivelayout/ReserveChildState',
  }
]

@Entry
@Component
struct MainPage {
  @State bgColor: ResourceColor = '#39b5fa';

  build() {
    Column() {
      // 请将$r('app.string.build_layout')替换为实际资源文件，在本示例中该资源文件的value值为"构建布局"
      Text($r('app.string.responsive_layout'))
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