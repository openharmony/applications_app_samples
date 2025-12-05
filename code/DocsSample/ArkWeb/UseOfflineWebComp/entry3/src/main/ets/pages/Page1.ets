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

// [Start use_offline_web_component_page_1]
// Page1.ets
// 使用NodeController的Page页
import { getNWeb, getFreeWebNode, MyNodeController } from './Common'

@Component
export struct Page1 {
  private testUrl = this.getUIContext().getHostContext()?.resourceManager.getStringSync($r('app.string.test_url1'));
  @State private node1: MyNodeController | undefined = getNWeb(this.testUrl);
  @State private node2: MyNodeController | undefined = getFreeWebNode();

  aboutToAppear(): void {
    this.node2?.loadUrl(this.testUrl)
  }

  build() {
    NavDestination() {
      Row() {
        Column() {
          // NodeContainer用于与NodeController节点绑定，rebuild会触发makeNode
          // Page页通过NodeContainer接口绑定NodeController，实现动态组件页面显示
          if (this.node1) {
            NodeContainer(this.node1)
              .height('50%')
              .width('100%')
          } else {
            Text('webNode NodeContainer 1')
              .height('50%')
              .width('100%')
          }
          if (this.node2) {
            NodeContainer(this.node2)
              .height('50%')
              .width('100%')
          } else {
            Text('webNode NodeContainer 2')
              .height('50%')
              .width('100%')
          }
        }
        .width('100%')
        .height('100%')
      }
      .height('100%')
    }
    // node2加载空页面
    .onWillHide(() => {
      this.node2?.loadUrl('about:blank');
    })
  }
}

// [End use_offline_web_component_page_1]
