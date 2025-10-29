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

// [Start navigation_implement_page1]
// navigation/Page1.ets
import { PipManager } from './PipManager';
import { Logger } from '../util/LogUtil';

const TAG = 'Page1';

@Entry
@Component
export struct Page1 {
  build() {
    NavDestination() {
      Column() {
        Text('This is Page1')
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
    .title('page1')
    .onShown(() => {
      Logger.info(TAG, 'onShown')
      PipManager.getInstance().init(this.getUIContext().getHostContext() as Context);
      PipManager.getInstance().setAutoStart(true);
    })
    .onHidden(() => {
      Logger.info(TAG, 'onHidden')
      PipManager.getInstance().setAutoStart(false);
      PipManager.getInstance().removeNode();
    })
  }
}
// [End navigation_implement_page1]