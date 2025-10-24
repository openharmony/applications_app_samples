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
// [Start DistinguishTwoGesture]
import { webview } from '@kit.ArkWeb';
import hilog from '@ohos.hilog';
const TAG = '[Sample_WebGestureInteraction]';
const DOMAIN = 0xF811;
const BUNDLE = 'WebGestureInteraction_';
@Entry
@Component
struct Index {
  @State scaleValue: number = 1;
  @State pinchValue: number = 1;
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Web({ src: 'www.example.com', controller: this.controller })
      // 在组件上绑定缩放比例，可以通过修改缩放比例来实现组件的缩小或者放大
        .scale({ x: this.scaleValue, y: this.scaleValue, z: 1 })
        .zoomAccess(true)
        .gesture(
          // 在组件上绑定三指触发的捏合手势
          PinchGesture({ fingers: 3 })
            .onActionStart((event: GestureEvent|undefined) => {
              hilog.info(DOMAIN, TAG, BUNDLE, 'Pinch start');
            })
            // 当捏合手势触发时，可以通过回调函数获取缩放比例，从而修改组件的缩放比例
            .onActionUpdate((event: GestureEvent|undefined) => {
              if(event){
                this.scaleValue = this.pinchValue * event.scale;
                hilog.info(DOMAIN, TAG, BUNDLE, `Pinch update: ${this.scaleValue}`);
              }
            })
            .onActionEnd(() => {
              this.pinchValue = this.scaleValue;
              hilog.info(DOMAIN, TAG, BUNDLE, 'Pinch end');
            })
        )
    }
  }
}
// [End DistinguishTwoGesture]