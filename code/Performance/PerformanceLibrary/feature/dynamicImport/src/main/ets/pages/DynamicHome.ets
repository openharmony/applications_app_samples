/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import logger from '../utils/Logger';

@Component
export struct DynamicHome {
  @Provide('pathInfos') pageInfos: NavPathStack = new NavPathStack();
  @State active: boolean = false;
  @BuilderParam PageOneLoader: () => void;

  @Builder
  PageMap(name: string) {
    if (name === 'pageOne') {
      this.PageOneLoader();
    }
  }

  build() {
    Navigation(this.pageInfos) {
      Column() {
        Button($r('app.string.home_button_back'), { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            router.back();
          })
        Button($r('app.string.home_button_page_one'), { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.onEntryClick();
          })
      }
    }.title($r('app.string.home_title')).navDestination(this.PageMap)
  }

  async loadPageOne(key: String): Promise<void> {
    if (key === "pageOne") {
      let PageObj: Record<string, () => void> = await import("../model/PageOneLoader");
      this.PageOneLoader = PageObj.PageOneLoader;
    }
  }

  // 触发动态加载
  private onEntryClick(): void {
    try {
      this.loadPageOne('pageOne');
      this.pageInfos.clear();
      this.pageInfos.pushPathByName('pageOne', '');
      logger.info("DynamicImport Success");
    } catch (error) {
      logger.info("DynamicImport Fail");
    }
  }
}