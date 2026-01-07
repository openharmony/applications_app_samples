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

// [Start ReloadByUIAbilityCard]
// entry/src/main/ets/reloadbyuiability/pages/ReloadByUIAbilityCard.ets
let storageReloadForm = new LocalStorage();

@Entry(storageReloadForm)
@Component
struct ReloadByUIAbilityCard {
  // 创建两个待刷新的Text，Text初始内容分别为'Title default'、'Description default'。资源文件定义请参见下方步骤5
  @LocalStorageProp('title') title: ResourceStr = $r('app.string.default_title');
  @LocalStorageProp('detail') detail: ResourceStr = $r('app.string.DescriptionDefault');

  build() {
    Column() {
      Column() {
        Text(this.title)
          .fontSize(14)
          .margin({ top: '8%', left: '10%' })
        Text(this.detail)
          .fontSize(12)
          .margin({ top: '5%', left: '10%' })
      }.width('100%').height('50%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
// [End ReloadByUIAbilityCard]