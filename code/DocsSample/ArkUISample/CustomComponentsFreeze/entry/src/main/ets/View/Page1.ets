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
// [Start arkts_custom_components_freeze1]
import { hilog } from '@kit.PerformanceAnalysisKit';
@Entry
@Component({ freezeWhenInactive: true })
struct Page1 {
  @StorageLink('PropA') @Watch('first') storageLink: number = 47;

  first() {
    hilog.info(0x0000, 'FreezeChild', 'FreezeChild message callback func %{public}d, index: %{public}d', this.storageLink);
  }

  build() {
    Column() {
      Text(`From first Page ${this.storageLink}`).fontSize(50)
        .id('firstPageText1')
      Button('first page storageLink + 1').fontSize(30)
        .onClick(() => {
          this.storageLink += 1;
        })
      Button('go to next page').fontSize(30)
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'View/Page2' });
        })
    }
  }
}
// [End arkts_custom_components_freeze1]