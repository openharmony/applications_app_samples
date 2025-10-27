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
import render, { DestroyNativeRoot } from 'libentry.so';
@Entry
@Component

struct NativeCustomPage {
  @State flag:boolean=true;
  @State text:string='ShowNativeUI';
  private nodeContent: NodeContent = new NodeContent();
  private isNodeCreated: boolean = true;
  onPageShow() {
    this.createNativeNodes();
  }
  onPageHide() {
    this.DestroyNativeRoot();
  }
  private createNativeNodes() {
    if (render?.CreateNativeRoot && this.isNodeCreated) {
      render.CreateNativeRoot(this.nodeContent);
      this.isNodeCreated = true;
    }
  }
  private DestroyNativeRoot() {
    if (render?.DestroyNativeRoot && !this.isNodeCreated) {
      render.DestroyNativeRoot();
      this.isNodeCreated = false;
    }
  }
  build() {
    Column() {
      Row({ space: 16 }) {
        Button('HideNativeUI')
          .onClick(()=>{
            this.flag=false;
            DestroyNativeRoot();
          })
      }
       if(this.flag){
         Column() {
           ContentSlot(this.nodeContent);
         }
         .margin({top:50})
         .flexGrow(1)
         .padding(16)
       }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff')
  }
}