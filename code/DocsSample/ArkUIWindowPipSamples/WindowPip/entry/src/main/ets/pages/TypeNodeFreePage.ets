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

// [Start typenode_free_implement_index_page]
// 该页面用于展示应用布局文件，创建的typeNode节点不会添加到该布局中
import { PipManager } from '../nodefree/PipManager';
import { Logger } from '../util/LogUtil';

const TAG = 'TypeNodeFreePage'
@Entry
@Component
struct TypeNodeFreePage {
  build() {
    Column() {
      Text('This is MainPage')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      Text('This is not typeNode')
        .size({ width: '100%', height: '800px' })
        .fontSize(30)
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#4d5b5858')

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

  aboutToDisappear(): void {
    PipManager.getInstance().unregisterPipStateChangeListener(); // 解注册画中画生命周期及状态回调
  }

  onPageShow(): void {
    Logger.info(TAG, 'onPageShow')
    PipManager.getInstance().init(this.getUIContext().getHostContext() as Context); // 创建画中画控制器
    PipManager.getInstance().setAutoStart(true); // 设置应用退后台时自动启动画中画
  }

  onPageHide(): void {
    Logger.info(TAG, 'onPageHide')
    PipManager.getInstance().setAutoStart(false);
  }
}
// [End typenode_free_implement_index_page]