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

// [Start set_web_darkmode_auto]
import { webview } from '@kit.ArkWeb';
import { ConfigurationConstant } from '@kit.AbilityKit';

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  @State bgColor: Color = Color.White;
  @StorageProp('currentColorMode') @Watch('onCurrentColorModeChange')
  currentColorMode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;

  build() {
    Column() {
      Web({ src: $rawfile('darkModePage.html'), controller: this.controller })
        .darkMode(WebDarkMode.Auto)
        .backgroundColor(this.bgColor)
    }
  }
  
  onCurrentColorModeChange(): void {
    // 根据系统设置切换背景色。
    if (this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.bgColor = Color.Black;
    } else {
      this.bgColor = Color.White;
    }
  }
}
// [End set_web_darkmode_auto]