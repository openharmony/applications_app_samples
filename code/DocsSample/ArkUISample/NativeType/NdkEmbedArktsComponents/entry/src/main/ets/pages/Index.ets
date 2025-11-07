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
// [Start page_index]
//  Index.ets
import nativeNode from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';
import { createMixedRefresh, updateMixedRefresh } from './MixedModule';

@Entry
@Component
struct Index {
  private rootSlot = new NodeContent();
  @State @Watch('changeNativeFlag') showNative: boolean = false;

  aboutToAppear(): void {
    // 设置uiContext;
    AppStorage.setOrCreate<UIContext>('context', this.getUIContext());
    // 设置混合模式下的builder函数。
    nativeNode.registerCreateMixedRefreshNode(createMixedRefresh);
    nativeNode.registerUpdateMixedRefreshNode(updateMixedRefresh);
  }

  changeNativeFlag(): void {
    if (this.showNative) {
      // 创建NativeModule组件挂载
      nativeNode.createNativeRoot(this.rootSlot);
    } else {
      // 销毁NativeModule组件
      nativeNode.destroyNativeRoot();
    }
  }

  build() {
    Column() {
      Button(this.showNative ? 'HideNativeUI' : 'ShowNativeUI').onClick(() => {
        this.showNative = !this.showNative;
      });
      Row() {
        // ArkTS插入Native组件。
        ContentSlot(this.rootSlot);
      }.layoutWeight(1)
      .id('row_');
    }
    .width('100%')
    .height('100%');
  }
}

// [End page_index]