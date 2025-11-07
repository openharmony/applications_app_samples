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

// [Start router_implement_index_page]
// pages/RouterImplementPage.ets
import { PipManager } from '../route/PipManager';
import { PiPWindow, router, Router } from '@kit.ArkUI'; // 引入PiPWindow模块
import { Logger } from '../util/LogUtil';

const TAG = 'RouterImplementPage'
@Entry
@Component
struct RouterImplementPage {
  private page1: string = 'route/Page1';
  private pageRouter: Router | null = null;

  // 画中画生命周期事件监听，用于页面及节点操作
  private callback: Function = (state: PiPWindow.PiPState) => {
    Logger.info(TAG, `pipStateChange: state ${state}`);
    if (state === PiPWindow.PiPState.ABOUT_TO_START) {
      // 返回到上级页面（可选）
      this.pageRouter?.back();
    } else if (state === PiPWindow.PiPState.ABOUT_TO_STOP) {
      // 重新将typeNode节点添加到布局中，例如还原场景
      PipManager.getInstance().addNode();
    } else if (state === PiPWindow.PiPState.ABOUT_TO_RESTORE) {
      // 如果在ABOUT_TO_START时返回了上级界面，需要还原时push到原界面
      this.jumpNext();
    }
  };

  aboutToAppear(): void {
    this.pageRouter = this.getUIContext().getRouter();
    PipManager.getInstance().registerLifecycleCallback(this.callback);
  }

  aboutToDisappear(): void {
    PipManager.getInstance().unregisterPipStateChangeListener();
    PipManager.getInstance().unRegisterLifecycleCallback(this.callback);
  }

  jumpNext(): void {
    let topPage = this.pageRouter?.getState();
    if (topPage !== undefined && (this.page1.toString() === topPage.path + topPage.name)) {
      Logger.info(TAG, `page1 aready at top`)
      return;
    }
    this.pageRouter?.pushUrl({
      url: this.page1 // 目标url
    }, router.RouterMode.Standard, (err) => {
      if (err) {
        Logger.error(TAG, `Invoke pushUrl failed, code is ${err.code}: ${err.message}`);
        return;
      }
      Logger.info(TAG, 'Invoke pushUrl succeeded.');
    });
  }

  build() {
    Row() {
      Column() {
        Text('Main Page')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button('Jump Next')
          .onClick(() => {
            this.jumpNext();
          })
          .margin({ top: 16, bottom: 16 })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End router_implement_index_page]