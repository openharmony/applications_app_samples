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

import curves from '@ohos.curves';

@Extend(Column)
function maskStyle() {
  .width('100%')
  .height('100%')
  .backgroundColor('rgba(0,0,0,0.5)')
  .animation({
    duration: 350,
    curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
    delay: 0,
    iterations: 1,
    playMode: PlayMode.Alternate,
  })
}

/**
 * 扫码结果蒙层
 */
@Component
export struct MaskLayer {
  build() {
    Column() {
    }
    .maskStyle()
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}