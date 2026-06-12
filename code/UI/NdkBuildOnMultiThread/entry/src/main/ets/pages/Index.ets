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

@Entry
@Component
struct Index {
  private pathStack: NavPathStack = new NavPathStack();

  private createPageParams(isOnUIThread: boolean): PageParams {
    const params = new PageParams();
    params.isOnUIThread = isOnUIThread;
    return params;
  }

  build() {
    Navigation(this.pathStack) {
      Column() {
        Button("CreatePageOnMultiThread")
          .onClick(() => {
            this.pathStack.pushPathByName('Page', this.createPageParams(false));
          })
        Button("CreatePageOnUIThread")
          .onClick(() => {
            this.pathStack.pushPathByName('Page', this.createPageParams(true));
          })
      }.width('100%').height('100%')
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}

class PageParams {
  isOnUIThread: boolean = false;
}

