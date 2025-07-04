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

import nativeNode from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

@Entry
@Component
export struct ListenTextBoxEvents {
  // 初始化NodeContent对象。
  private rootSlot = new NodeContent();

  aboutToAppear(): void {
    // 通过C-API创建节点，并添加到管理器nodeContent上
    nativeNode.createTextAreaNode(this.rootSlot);
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          // 将NodeContent和ContentSlot占位组件绑定。
          ContentSlot(this.rootSlot)
        }.layoutWeight(1)
      }
      .width('100%')
      .height('100%')
    }.title($r('app.string.ListenTextBoxEvents_NDK_title'))
  }
}