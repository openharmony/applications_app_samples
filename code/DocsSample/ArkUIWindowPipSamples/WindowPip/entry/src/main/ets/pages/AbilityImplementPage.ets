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

// [Start ability_implement_index_page]
// pages/AbilityImplementPage.ets
import { PipManager } from '../ability/PipManager';
import { PiPWindow } from '@kit.ArkUI'; // 引入PiPWindow模块
import { Logger } from '../util/LogUtil';

const TAG = 'AbilityImplementPage'
@Entry
@Component
struct AbilityImplementPage {
  private callback: Function = (state: PiPWindow.PiPState) => {
    if (state === PiPWindow.PiPState.ABOUT_TO_STOP) {
      // 画中画关闭或还原时触发ABOUT_TO_STOP生命周期，此时需要重新添加节点
      PipManager.getInstance().addNode();
    }
  };

  build() {
    Column() {
      Text('This is MainPage')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      // 将typeNode添加到页面布局中
      NodeContainer(PipManager.getInstance().getNodeController())
        .size({ width: '100%', height: '800px' })

      Row({ space: 20 }) {
        Button('startPip') // 启动画中画
          .onClick(() => {
            PipManager.getInstance().startPip();
          })

        Button('stopPip') // 停止画中画
          .onClick(() => {
            PipManager.getInstance().stopPip();
          })

        Button('updateSize') // 更新视频尺寸
          .onClick(() => {
            // 此处设置的宽高应为媒体内容宽高，需要通过媒体相关接口或回调获取
            // 例如使用AVPlayer播放视频时，可通过videoSizeChange回调获取媒体源更新后的尺寸
            PipManager.getInstance().updateContentSize(900, 1600);
          })
      }
      .backgroundColor('#4da99797')
      .size({ width: '100%', height: 60 })
      .justifyContent(FlexAlign.SpaceAround)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    PipManager.getInstance().registerLifecycleCallback(this.callback);
  }

  aboutToDisappear(): void {
    PipManager.getInstance().unregisterPipStateChangeListener();
    PipManager.getInstance().unRegisterLifecycleCallback(this.callback);
  }

  onPageShow(): void {
    Logger.info(TAG, 'onPageShow')
    PipManager.getInstance().init(this.getUIContext().getHostContext() as Context);
    PipManager.getInstance().setAutoStart(true);
  }

  onPageHide(): void {
    Logger.info(TAG, 'onPageHide')
    PipManager.getInstance().setAutoStart(false);
  }
}
// [End ability_implement_index_page]