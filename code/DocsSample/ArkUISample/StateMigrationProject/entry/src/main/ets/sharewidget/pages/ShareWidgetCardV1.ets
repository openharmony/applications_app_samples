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
// [Start CardMigrationShareV1]
let storage = new LocalStorage();

// V1卡片入口组件需通过@Entry传入LocalStorage实例
@Entry(storage)
@Component
struct ShareWidgetCardV1 {
  // 通过@LocalStorageProp的入参key值匹配updateForm数据
  @LocalStorageProp('title') title: string = 'Default title';
  @LocalStorageProp('detail') detail: string = 'Default detail';

  build() {
    Column() {
      Column() {
        Text(this.title)
          .fontSize(14)
          .margin({ top: '8%', left: '10%' })
        Text(this.detail)
          .fontSize(12)
          .margin({ top: '5%', left: '10%' })
        ChildComp1()
      }
      .width('100%')
      .height('50%')
      .alignItems(HorizontalAlign.Start)

      Button('update')
        .margin({ top: '15%' })
        .onClick(() => {
          postCardAction(this, {
            'action': 'message',
            'params': { 'msgTest': 'messageEvent' }
          });
        })
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct ChildComp1 {
  // 子组件同样通过@LocalStorageProp读取LocalStorage中的共享数据
  @LocalStorageProp('detail') detail: string = 'Default detail';

  build() {
    Text(this.detail)
      .fontSize(12)
      .margin({ top: '3%', left: '10%' })
  }
}
// [End CardMigrationShareV1]