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

// [Start dynamic_webview_component_loading]
import { webview } from '@kit.ArkWeb';
import { NodeController } from '@kit.ArkUI';
import { createNode } from "./DynamicComponent";
import { injectWebview } from "./InjectWebview";
import { businessWebview } from "./BusinessWebview";

function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct Index {
  @State injectNode: NodeController | undefined = undefined;
  injectController: webview.WebviewController = new webview.WebviewController();

  @State businessNode: NodeController | undefined = undefined;
  businessController: webview.WebviewController = new webview.WebviewController();

  aboutToAppear(): void {
    // 初始化用于注入本地资源的Web组件, 提供一个空的html页面作为url即可
    this.injectNode = createNode(injectWebview,
      { url: resourceToString($r('app.string.web_path_two')), controller: this.injectController});
  }

  build() {
    Column() {
      // 在适当的时机加载业务用Web组件，本例以Button点击触发为例
      Button("加载页面")
        .onClick(() => {
          this.businessNode = createNode(businessWebview, {
            url: resourceToString($r('app.string.web_path_three')),
            controller: this.businessController
          });
        })
      // 用于业务的Web组件
      NodeContainer(this.businessNode);
    }
  }
}
// [End dynamic_webview_component_loading]