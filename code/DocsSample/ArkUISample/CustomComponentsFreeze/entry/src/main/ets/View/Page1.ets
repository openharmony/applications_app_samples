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
const DOMAIN = 0x0001;
const TAG = 'FreezeChild';
const STORAGE_LINK_INITIAL_VALUE = 47;

@Entry
@Component({ freezeWhenInactive: true })
struct PageOne {
  @StorageLink('PropA') @Watch('first') storageLink: number = STORAGE_LINK_INITIAL_VALUE;

  first() {
    hilog.info(DOMAIN, TAG, 'first page ' + `${this.storageLink}`);
  }

  build() {
    Column() {
      Text(`From first Page ${this.storageLink}`).fontSize(50)
      Button('first page storageLink + 1').fontSize(30)
        .onClick(() => {
          this.storageLink += 1;
        })
      Button('go to next page').fontSize(30)
        .onClick(() => {
          // 此处传入的url，需要开发者自行替换。
          this.getUIContext().getRouter().pushUrl({ url: 'View/PageTwo' });
        })
    }
  }
}
// [End arkts_custom_components_freeze1]