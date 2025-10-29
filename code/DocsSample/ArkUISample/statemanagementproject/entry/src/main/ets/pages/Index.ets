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
import router from '@ohos.router'
interface listItem {
  router?: string;
  name: string;
  description?: string;
}

let demandList: listItem[] = [
  {
    name: 'StateArray',
    router: 'pages/statemanagementguide/StateArray',
  },
  {
    name: 'StateArrayNo',
    router: 'pages/statemanagementguide/StateArrayNo',
  },
  {
    name: 'StateArrayNo2',
    router: 'pages/statemanagementguide/StateArrayNo2',
  },
  {
    name: 'StateArrayLazy',
    router: 'pages/statemanagementguide/StateArrayLazy',
  },
  {
    name: 'StateArrayForeach',
    router: 'pages/statemanagementguide/StateArrayForeach',
  },
  {
    name: 'StateArrayForeach2',
    router: 'pages/statemanagementguide/StateArrayForeach2',
  },
  {
    name: 'StateArrayBig',
    router: 'pages/statemanagementguide/StateArrayBig',
  },
  {
    name: 'StateArrayForeach2',
    router: 'pages/statemanagementguide/StateArrayForeach2',
  },
  {
    name: 'StateArrayInit',
    router: 'pages/statemanagementguide/StateArrayInit',
  },
  {
    name: 'StateArrayLazy2',
    router: 'pages/statemanagementguide/StateArrayLazy2',
  },
  {
    name: 'StateArrayLoadDate',
    router: 'pages/statemanagementguide/StateArrayLoadDate',
  },
  {
    name: 'StateArrayObserved',
    router: 'pages/statemanagementguide/StateArrayObserved',
  }, {
  name: 'StateArrayPrecise',
  router: 'pages/statemanagementguide/StateArrayPrecise',
},
  {
    name: 'StateArrayTrack',
    router: 'pages/statemanagementguide/StateArrayTrack',
  }, {
  name: 'StateArrayUpdate',
  router: 'pages/statemanagementguide/StateArrayUpdate',
},


]

@Entry
@Component
struct Index {
  @State bgColor: ResourceColor = '#39b5fa';

  build() {
    Column() {
      Text($r('app.string.state_layout'))
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
      //  .height('100%')
      .backgroundColor('#fff4f3f3')
      .padding({ top: 5 })
    }
  }
}