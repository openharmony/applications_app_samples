/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { NodeContent } from '@kit.ArkUI';
import render from 'libentry.so';

@Entry
@Component
struct NativeCustomPage {
  @State flag: boolean = false;
  @State text: string = 'HideNativeUI';
  @State nodeContent: NodeContent = new NodeContent();

  onPageShow() {
    this.createNativeNodes();
  }

  onPageHide() {
    this.DestroyNativeRoot();
  }

  private createNativeNodes() {
    render.CreateNativeRoot(this.nodeContent);
  }

  private DestroyNativeRoot() {
    render.DestroyNativeRoot();
  }

  build() {
    Column() {
      Row({ space: 16 }) {
        Button(this.text)
          .onClick(() => {
            this.flag = !this.flag
            if (this.flag) {
              this.text = 'ShowNativeUI'
              this.DestroyNativeRoot()
            } else {
              this.text = 'HideNativeUI'
              this.createNativeNodes()
            }
          })
      }

      if (!this.flag) {
        Column() {
          ContentSlot(this.nodeContent);
        }
        .margin({ top: 50 })
        .flexGrow(1)
        .padding(16)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff')
  }
}