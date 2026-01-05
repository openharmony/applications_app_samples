/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

interface listItem {
  router?: string;
  name: string;
  description?: string;
}

let demandList: listItem[] = [
  {
    name: 'Top Level Collections Array',
    description: 'This is top level collections.Array scene',
    router: 'pages/TopLevelCollectionsArray',
  },
  {
    name: 'Top Level Array ClassA',
    description: 'This is top level array<ClassA> scene',
    router: 'pages/TopLevelArrayClassA',
  },
  {
    name: 'Top Level Date',
    description: 'This is top level date scene',
    router: 'pages/TopLevelDate',
  },
  {
    name: 'Non Top Level Number of class',
    description: 'This is non top level Number of class scene',
    router: 'pages/NonTopLevelNumberOfClass',
  },
  {
    name: 'Circular Reference of Object',
    description: 'This is circular reference of object scene',
    router: 'pages/CircularReferenceOfObject',
  },
  {
    name: 'Top Level Array<ClassA> APIS',
    description: 'This is top level array<ClassA> APIs scene',
    router: 'pages/TopLevelArrayClassAAPIs',
  },
];

@Entry
@Component
struct Index {
  @State bgColor: ResourceColor = '#39b5fa';

  build() {
    Column() {
      Text(`PersistenceV2 test case`)
        .height('8.00%')
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(this.bgColor)
        .fontColor(Color.White)

      Column() {
        List({ space: 20, initialIndex: 0 }) {
          ForEach(demandList, (listitem: listItem, index: number) => {
            ListItem() {
              Column({ space: 10 }) {
                Text(listitem.name)
                  .fontSize(20)
                  .fontColor(this.bgColor)
                  .maxLines(1)

                Text(listitem.description)
                  .width('100%')
              }
              .margin({ bottom: index >= demandList.length - 1 ? 100 : 0 })
              .padding({
                top: '3%',
                right: '10.00%',
                bottom: '5%',
                left: '10.00%'
              })
              .width('100%')
              .constraintSize({ minHeight: 100 })
              .borderRadius(10)
              .backgroundColor(0xFFFFFF)
              .onClick(() => {
                if (!!listitem.router) {
                  this.getUIContext().getRouter().pushUrl({ url: listitem.router });
                }
              })
            }
          })
        }
        .listDirection(Axis.Vertical) // 排列方向
        .scrollBar(BarState.Off)
        .friction(0.6)
        .divider({
          strokeWidth: 2,
          color: 0xFFFFFF,
          startMargin: 20,
          endMargin: 20
        }) // 每行之间的分界线
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