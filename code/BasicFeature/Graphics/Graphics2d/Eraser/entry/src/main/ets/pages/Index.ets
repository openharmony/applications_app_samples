/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { EraserMainPage } from 'erasercomponent';

@Entry
@Component
struct Index {
  build() {
    RelativeContainer() {
      /**
       * 功能描述：本示例通过@ohos.graphics.drawing库和blendMode颜色混合实现了橡皮擦功能，能够根据手指移动轨迹擦除之前绘制的内容，并且可以进行图案的撤销和恢复。
       * 参数介绍：无
       */
      EraserMainPage()
    }
    .height('100%')
    .width('100%')
  }
}