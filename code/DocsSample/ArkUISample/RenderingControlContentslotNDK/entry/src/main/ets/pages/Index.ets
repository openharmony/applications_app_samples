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

// [Start contentslot_two]
// [Start contentslot_one]
import nativeNode from 'libentry.so'; // 开发者自己实现的so
import { NodeContent } from '@kit.ArkUI';

@Entry
@Component
struct Parent {
  // [StartExclude contentslot_two]
  private nodeContent: Content = new NodeContent();
  // [EndExclude contentslot_two]
  // [StartExclude contentslot_one]
  private nodeContent_1: Content = new NodeContent();
  private nodeContent_2: Content = new NodeContent();
  // [EndExclude contentslot_one]

  aboutToAppear() {
    // [StartExclude contentslot_two]
    // 通过C-API创建节点，并添加到管理器nodeContent上
    nativeNode.createNativeNode(this.nodeContent);
    // [EndExclude contentslot_two]
    // [StartExclude contentslot_one]
    // 通过C-API创建节点，并添加到管理器nodeContent_1和nodeContent_2上
    nativeNode.createNativeNode(this.nodeContent_1);
    nativeNode.createNativeNode(this.nodeContent_2);
    // [EndExclude contentslot_one]
  }

  build() {
    Column() {
      // [StartExclude contentslot_two]
      // 显示nodeContent管理器里存放的Native侧的组件
      ContentSlot(this.nodeContent);
      // [EndExclude contentslot_two]
      // [StartExclude contentslot_one]
      ContentSlot(this.nodeContent_1);// nodeContent_1将被挂载到下一个Contentslot节点，此处无法显示
      ContentSlot(this.nodeContent_1); // 正常显示
      ContentSlot(this.nodeContent_2); // 正常显示
      // [EndExclude contentslot_one]
    }
  }
}
// [End contentslot_one]
// [End contentslot_two]