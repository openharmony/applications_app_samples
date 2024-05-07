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
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import NativeWindowContext from "../interface/NativeWindowContext";
const TAG = '[Sample_NativeWindowAPI]';

@Entry
@Component
struct Index {
  @State msg: string = 'OnFrameAvailable count:'
  @State frameAvailableCount: number = 0;
  @State producerCacheBufferCount: number = 0;
  @State cacheBufferCount: number = 3;
  @State bufferQueueSize: number = 3;
  @State attachedBufferCount: number = 0;
  @State frameFlushedCount: number = 0;
  private nativeWindowContext: NativeWindowContext | undefined = undefined;

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Row() {
          Button('Change Color')
            .fontSize('14fp')
            .fontWeight(500)
            .margin({ bottom: 24 })
            .onClick(() => {
              if (this.nativeWindowContext) {
                this.nativeWindowContext.DrawColor();
              }
            })
            .width('40%')
            Button('Change ScalingMode')
            .fontSize('14fp')
            .fontWeight(500)
            .margin({ bottom: 24 })
            .onClick(() => {
              if (this.nativeWindowContext) {
                this.nativeWindowContext.ChangeScalingMode();
              }
            })
            .width('50%')
        }
      Column() {
        Row() {
          XComponent({ id: 'xcomponentId', type: 'texture', libraryname: 'nativerender' })
            .margin({ bottom: 26 })
            .onLoad((nativeWindowContext) => {
              this.nativeWindowContext = nativeWindowContext as NativeWindowContext;
            })
        }
      }
      .width('512px')
      .height('50%')
      Button(`produce buffer count=${this.frameFlushedCount}`)
        .fontSize('14fp')
        .fontWeight(500)
        .margin({ bottom: 24 })
        .onClick(() => {
          if (this.nativeWindowContext) {
            console.log(TAG, "Produce Buffer");
            this.nativeWindowContext.ProduceBuffer();
            this.frameFlushedCount++;
            setTimeout("GetCount", 1000);
          }
        })
        .height(40)
      Button(`update available buffer count=${this.frameAvailableCount}`)
        .fontSize('14fp')
        .fontWeight(500)
        .margin({ bottom: 24 })
        .onClick(() => {
          if (this.nativeWindowContext) {
            console.log(TAG, "GetAvailableCount");
            this.frameAvailableCount = this.nativeWindowContext.GetAvailableCount();
          }
        })
        .height(40)
      Button() {
        Column() {
          Row() {
            Text(`update bufferqueuesize =${this.bufferQueueSize}`)
              .fontSize('14fp')
              .fontWeight(500)
              .fontColor(Color.White)
              .margin({ bottom: 8 })
          }
          Row() {
            Text(`attachedbuffer =${this.attachedBufferCount},cachebuffer=${this.cacheBufferCount}`)
              .fontSize('14fp')
              .fontWeight(500)
              .fontColor(Color.White)
          }
        }
        .margin({ left: 12, right: 12, top: 8, bottom: 8 })
      }
      .margin({ bottom: 24 })
      .onClick(() => {
        if (this.nativeWindowContext) {
          this.bufferQueueSize = this.nativeWindowContext.GetBufferQueueSize();
          this.attachedBufferCount = this.nativeWindowContext.GetAttachBufferCount();
          this.cacheBufferCount = this.nativeWindowContext.GetCacheBufferCount();
        }
      })
      .height(60)
      Button(`attach buffer`)
        .fontSize('14fp')
        .fontWeight(500)
        .margin({ bottom: 24 })
        .onClick(() => {
          if (this.nativeWindowContext) {
            this.nativeWindowContext.AttachBuffer();
          }
        })
        .height(40)
      Button(`dettach buffer`)
        .fontSize('14fp')
        .fontWeight(500)
        .margin({ bottom: 24 })
        .onClick(() => {
          if (this.nativeWindowContext) {
            this.nativeWindowContext.DettachBuffer();
          }
        })
        .height(40)
    }
    .width('100%')
    .height('100%')
  }
}
