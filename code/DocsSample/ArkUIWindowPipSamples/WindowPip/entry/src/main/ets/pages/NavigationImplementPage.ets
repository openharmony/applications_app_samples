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

// [Start navigation_implement_index_page]
// pages/NavigationImplementPage.ets
import { PipManager } from '../navigation/PipManager';
import { Page1 } from '../navigation/Page1';
import { PiPWindow } from '@kit.ArkUI';
import { Logger } from '../util/LogUtil';

const TAG = 'NavigationImplementPage';

@Entry
@Component
struct NavigationImplementPage {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  // 画中画生命周期事件监听，用于页面及节点操作
  private callback: Function = (state: PiPWindow.PiPState) => {
    Logger.info(TAG, `pipStateChange: state ${state}`);
    if (state === PiPWindow.PiPState.ABOUT_TO_START) {
      // 返回到上级页面（可选）
      this.pageInfos.pop();
    } else if (state === PiPWindow.PiPState.ABOUT_TO_STOP) {
      // 重新将typeNode节点添加到布局中，例如还原场景
      PipManager.getInstance().addNode();
    } else if (state === PiPWindow.PiPState.ABOUT_TO_RESTORE) {
      // 如果在ABOUT_TO_START时返回了上级界面，需要还原时push到原界面
      this.jumpNext();
    }
  };

  jumpNext() {
    if (this.pageInfos.getAllPathName()[0] === 'Page1') {
      Logger.info(TAG, 'Page1 already at top');
      return;
    }
    this.pageInfos.pushPath({ name: 'Page1' });
  }

  aboutToAppear(): void {
    PipManager.getInstance().registerLifecycleCallback(this.callback);
  }

  aboutToDisappear(): void {
    PipManager.getInstance().unregisterPipStateChangeListener();
    PipManager.getInstance().unRegisterLifecycleCallback(this.callback);
  }

  @Builder
  PageMap(name: string) {
    if (name === 'Page1') {
      Page1();
    }
  }

  build() {
    Navigation(this.pageInfos) {
      Column() {
        Text('This is Main Page')
        Column()
          .height('200px')
        Row({ space: 12 }) {
          Button('Jump Page1')
            .width('80%')
            .height(40)
            .margin(20)
            .onClick(() => {
              this.jumpNext();
            })
        }
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#DCDCDC')
    }
    .title('MainTitle')
    .navDestination(this.PageMap)
  }
}
// [End navigation_implement_index_page]