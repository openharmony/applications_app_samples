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

import { window } from '@kit.ArkUI';
import { Comment } from '../components/Comment';

/**
 * 底部弹框沉浸式适配
 * 1、设置弹框尾部元素对导航条避让
 */
@CustomDialog
export struct ImmersiveDialog {
  customController: CustomDialogController;
  @State bottomHeight: number = 0;

  aboutToAppear(): void {
    window.getLastWindow(getContext(), (err, data) => {
      const avoidAreaBottom = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      this.bottomHeight = avoidAreaBottom.bottomRect.height;
    })
  }

  build() {
    Comment({ close: () => {
      this.customController.close();
    }})
      .height('60%')
      .backgroundColor(Color.White)
  }
}