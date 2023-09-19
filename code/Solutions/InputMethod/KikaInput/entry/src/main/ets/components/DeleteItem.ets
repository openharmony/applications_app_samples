/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF InputStyle KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { InputHandler } from '../model/KeyboardController';
import { KeyStyle, StyleConfiguration } from '../common/StyleConfiguration';

@Styles function pressedStyles() {
  .backgroundColor($r('app.color.key_item_gray_pressed'))
}

@Styles function normalStyles() {
  .backgroundColor($r('app.color.key_item_gray'))
}

// 删除组件
@Component
export struct DeleteItem {
  @StorageLink('inputStyle') inputStyle: KeyStyle = StyleConfiguration.getSavedInputStyle();

  build() {
    Stack() {
      Image($rawfile('delete.svg'))
        .width(this.inputStyle.featurePicSize)
        .height(this.inputStyle.featurePicSize)
    }
    .backgroundColor($r('app.color.key_item_gray'))
    .borderRadius(4)
    .onClick(() => {
      InputHandler.getInstance().deleteForward(1);
    })
    .width(this.inputStyle.switchButtonWidth)
    .height('100%')
    .shadow({ radius: 1, color: $r('app.color.shadow'), offsetY: 3 })
    .stateStyles({
      normal: normalStyles, pressed: pressedStyles
    })
  }
}