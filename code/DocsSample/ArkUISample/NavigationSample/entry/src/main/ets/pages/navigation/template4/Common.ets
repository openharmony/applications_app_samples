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

// [Start CrossPackageCommon]
@Component
export struct ControlPanel {
  private stack: NavPathStack | undefined = undefined;

  aboutToAppear(): void {
    let info = this.queryNavigationInfo();
    this.stack = info?.pathStack;
  }

  build() {
    Column({ space: 20 }) {
      Button('push HapPageA').onClick(() => {
        this.stack?.pushPath({ name: 'HapPageA' });
      })
      Button('push HapPageB').onClick(() => {
        this.stack?.pushPath({ name: 'HapPageB' });
      })
      Button('push HarPageA').onClick(() => {
        this.stack?.pushPath({ name: 'HarPageA' });
      })
      Button('push HarPageB').onClick(() => {
        this.stack?.pushPath({ name: 'HarPageB' });
      })
      Button('push HspPageA').onClick(() => {
        this.stack?.pushPath({ name: 'HspPageA' });
      })
      Button('push HspPageB').onClick(() => {
        this.stack?.pushPath({ name: 'HspPageB' });
      })
    }
  }
}
// [End CrossPackageCommon]
