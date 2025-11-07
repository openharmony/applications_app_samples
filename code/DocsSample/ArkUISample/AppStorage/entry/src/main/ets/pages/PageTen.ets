/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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
// [Start appstorage_page_ten]
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0001;
const TAG: string = '[Sample_appstorage]';
AppStorage.setOrCreate('propA', false);

@Entry
@Component
struct PageStorageProp {
  @StorageProp('propA') @Watch('onChange') propA: boolean = false;

  onChange() {
    hilog.info(DOMAIN, TAG, `propA change`);
  }

  aboutToAppear(): void {
    this.propA = true;
  }

  build() {
    Column() {
      Text(`${this.propA}`)
      Button('change')
        .onClick(() => {
          AppStorage.setOrCreate('propA', false);
          hilog.info(DOMAIN, TAG, `propA: ${this.propA}`);
        })
    }
  }
}
// [End appstorage_page_ten]