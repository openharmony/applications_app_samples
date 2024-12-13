/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { webview } from '@kit.ArkWeb';

/**
 * Web沉浸式适配
 * 1、设置Web绘制延伸至状态栏和导航条
 * 2、设置网页元素避让导航条
 */
@Component
export struct WebImmersive {
  controller: webview.WebviewController = new webview.WebviewController();
  @Consume navPathStack: NavPathStack;

  build() {
    Column() {
      Web({ src: $rawfile('web_immersive.html'), controller: this.controller })
        .width('100%')
        .layoutWeight(1)// 设置Web绘制延伸到状态栏和导航条
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .width('100%')
    .height('100%')
  }
}