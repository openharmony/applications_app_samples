/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start ndknodequeryoperate6_start]

import testNapi from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

@Component
struct ImageContent {
  private nodeContent: NodeContent = new NodeContent();

  aboutToAppear() {
    // 通过C-API创建节点，并添加到管理器nodeContent上
    testNapi.createNativeNode(this.nodeContent);
  }
  build() {
    Column() {
      // 显示nodeContent管理器里存放的Native侧的组件
      ContentSlot(this.nodeContent)
    }
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State showParent: boolean = true;
  build() {
    Row() {
      Column() {
        // $r('app.string.Switch')需要替换为开发者所需的资源文件。
        Button($r('app.string.Switch')).onClick(()=>{
          this.showParent = !this.showParent;
        }).margin(20)
        if(this.showParent) {
          ImageContent()
        } else {
          ImageContent()
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End ndknodequeryoperate6_start]