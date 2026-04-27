/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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
// [Start ndk_layout_index]
import nativeNode from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  private rootSlot:NodeContent = new NodeContent();
  @State @Watch('changeNativeFlag') showNative: boolean = false;

  changeNativeFlag(): void {
    if (this.showNative) {
      nativeNode.createNativeRoot(this.rootSlot)
    } else {
      nativeNode.destroyNativeRoot()
    }
  }

  build() {
    Column() {
      Button(this.showNative ? '隐藏Native布局' : '显示Native布局')
        .onClick(() => {
          this.showNative = !this.showNative
        })
        .id('btn')
        .margin({ top: 12, left: 16, right: 16, bottom: 12 })

      ContentSlot(this.rootSlot)
    }
    .width('100%')
    .height('100%')
  }
}
// [End ndk_layout_index]
