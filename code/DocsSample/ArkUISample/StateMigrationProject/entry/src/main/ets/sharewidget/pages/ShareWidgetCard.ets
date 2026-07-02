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
// [Start CardMigrationShareV2]
// V2迁移后入口组件使用@ComponentV2，无需再传入LocalStorage实例
@Entry
@ComponentV2
struct ShareWidgetCard {
  // 仅组件内部使用的变量迁移为@Local
  @Local title: string = 'Default title';
  // 需跨组件共享的变量迁移为@Provider，系统按变量名匹配updateForm数据
  @Provider() detail: string = 'Default detail';

  build() {
    Column() {
      Column() {
        Text(this.title)
          .fontSize(14)
          .margin({ top: '8%', left: '10%' })
        Text(this.detail)
          .fontSize(12)
          .margin({ top: '5%', left: '10%' })
        ChildComp()
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

@ComponentV2
struct ChildComp {
  // 子组件通过@Consumer同步@Provider提供的数据
  @Consumer() detail: string = 'Default detail for Consumer';

  build() {
    Text(this.detail)
      .fontSize(12)
      .margin({ top: '3%', left: '10%' })
  }
}
// [End CardMigrationShareV2]