/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
    name: 'V1State',
    description: 'This is V1\'s @State decorator object call canBeObserved scene',
    router: 'pages/V1State',
  },
  {
    name: 'V1Prop',
    description: 'This is V1\'s @Prop decorator object call canBeObserved scene',
    router: 'pages/V1Prop',
  },
  {
    name: 'V1Link',
    description: 'This is V1\'s @Link decorator object call canBeObserved scene',
    router: 'pages/V1Link',
  },
  {
    name: 'V1Track',
    description: 'This is V1\'s @Track decorator object call canBeObserved scene',
    router: 'pages/V1Track',
  },
  {
    name: 'V1ObjectLink',
    description: 'This is V1\'s @ObjectLink decorator object call canBeObserved scene',
    router: 'pages/V1ObjectLink',
  },
  {
    name: 'V1StorageLink',
    description: 'This is V1\'s @StorageLink decorator object call canBeObserved scene',
    router: 'pages/V1StorageLink',
  },
  {
    name: 'V1StorageProp',
    description: 'This is V1\'s @StorageProp decorator object call canBeObserved scene',
    router: 'pages/V1StorageProp',
  },
  {
    name: 'V1LocalStorageLink',
    description: 'This is V1\'s @LocalStorageLink decorator object call canBeObserved scene',
    router: 'pages/V1LocalStorageLink',
  },
  {
    name: 'V1LocalStorageProp',
    description: 'This is V1\'s @LocalStorageProp decorator object call canBeObserved scene',
    router: 'pages/V1LocalStorageProp',
  },
  {
    name: 'V1ProvideAndConsume',
    description: 'This is V1\'s @Provide and @Consume decorator object call canBeObserved scene',
    router: 'pages/V1ProvideAndConsume',
  },
  {
    name: 'V1BuiltIn',
    description: 'This is V1\'s built-in object call canBeObserved scene',
    router: 'pages/V1BuiltIn',
  },
  {
    name: 'V1MakeV1Observed',
    description: 'This is V1\'s makeV1Observed object call canBeObserved scene',
    router: 'pages/V1MakeV1Observed',
  },
  {
    name: 'V2Local',
    description: 'This is V2\'s @Local decorator object call canBeObserved scene',
    router: 'pages/V2Local',
  },
  {
    name: 'V2Param',
    description: 'This is V2\'s @Param decorator object call canBeObserved scene',
    router: 'pages/V2Param',
  },
  {
    name: 'V2Computed',
    description: 'This is V2\'s @Computed decorator object call canBeObserved scene',
    router: 'pages/V2Computed',
  },
  {
    name: 'V2Monitor',
    description: 'This is V2\'s @Monitor decorator object call canBeObserved scene',
    router: 'pages/V2Monitor',
  },
  {
    name: 'V2ProviderAndConsumer',
    description: 'This is V2\'s @Provider and @Consumer decorator object call canBeObserved scene',
    router: 'pages/V2ProviderAndConsumer',
  },
  {
    name: 'V2MakeObserved',
    description: 'This is V2\'s makeObserved object call canBeObserved scene',
    router: 'pages/V2MakeObserved',
  },
  {
    name: 'V2BuiltIn',
    description: 'This is V2\'s built-in object call canBeObserved scene',
    router: 'pages/V2BuiltIn',
  },
  {
    name: 'V1AndV2Compatibility',
    description: 'This is v1 enableV2Compatibility object to v2 call canBeObserved scene',
    router: 'pages/V1AndV2Compatibility',
  },
  {
    name: 'CaseABCallError',
    description: 'Case study of frequently asked questions',
    router: 'pages/CaseABCallError',
  },
  {
    name: 'CaseABCallRight',
    description: 'Case study of frequently asked questions',
    router: 'pages/CaseABCallRight',
  },
  {
    name: 'CaseArrayForEachError',
    description: 'Case study of frequently asked questions',
    router: 'pages/CaseArrayForEachError',
  },
  {
    name: 'CaseArrayForEachRight',
    description: 'Case study of frequently asked questions',
    router: 'pages/CaseArrayForEachRight',
  },
  {
    name: 'CaseArrayObservedError',
    description: 'Case study of frequently asked questions',
    router: 'pages/CaseArrayObservedError',
  },
  {
    name: 'CaseArrayObservedRight',
    description: 'Case study of frequently asked questions',
    router: 'pages/CaseArrayObservedRight',
  },
  {
    name: 'CaseControlCounterError',
    description: 'Case study of frequently asked questions',
    router: 'pages/CaseControlCounterError',
  },
  {
    name: 'CaseControlCounterRight',
    description: 'Case study of frequently asked questions',
    router: 'pages/CaseControlCounterRight',
  },
];

@Entry
@Component
struct Index {
  @State bgColor: ResourceColor = '#39b5fa';

  build() {
    Column() {
      Text($r('app.string.can_be_observed'))
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