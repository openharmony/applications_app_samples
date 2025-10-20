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

// [Start web_full_screen]
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct ShortWebPage {
  controller: webview.WebviewController = new webview.WebviewController();
  CONSTANT_HEIGHT = 100;
  @State marginTop: number = this.CONSTANT_HEIGHT;
  @State isVisible: boolean = true; // 自定义标志位isVisible，来控制是否需要显示组件

  build() {
    Column() {
      Text('TextTextTextText')
        .width('100%')
        .height(this.CONSTANT_HEIGHT)
        .backgroundColor('#e1dede') // 当isVisible标志位为true的时候，组件状态为可见，否则组件状态为不可见，不参与布局、不进行占位
        .visibility(this.isVisible ? Visibility.Visible :
          Visibility.None)
      Web({
        src: $rawfile('FullScreen.html'), // 示例网址
        controller: this.controller
      })
        .onFullScreenEnter((event) => {
          console.info("onFullScreenEnter...");
          // 当全屏的时候，isVisible标志位为false，组件状态为不可见，不参与布局、不进行占位
          this.isVisible = false;
        })
        .onFullScreenExit(() => {
          console.info("onFullScreenExit...");
          // 当退出全屏的时候，isVisible标志位为true，组件状态为可见
          this.isVisible = true;
        })
        .width('100%')
        .height('100%')
        .zIndex(10)
        .zoomAccess(true)
    }.width('100%').height('100%')
  }
}
// [End web_full_screen]
