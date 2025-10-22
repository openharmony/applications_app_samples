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

import { router } from '@kit.ArkUI';
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  build() {
    Column({space:10}){
      Button('ShowFrameNodeTree')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/framenode/FrameNodeTree'
          })
        })
      Button('ShowFrameNodeMoveTo')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/framenode/FrameNodeMoveTo'
          })
        })
      Button('ShowFrameNodeCommon')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/framenode/FrameNodeCommon'
          })
        })
      Button('ShowFrameNodeDraw')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/framenode/FrameNodeDraw'
          })
        })
      Button('ShowFrameNodePosition')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/framenode/FrameNodePosition'
          })
        })
      Button('ShowFrameNodeTypeNode')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/framenode/FrameNodeTypeNode'
          })
        })
      Button('ShowFrameNodeDisposed')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/framenode/FrameNodeDisposed'
          })
        })
      Button('ShowFrameNodeIsDisposed')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/framenode/FrameNodeIsDisposed'
          })
        })
      Button('ShowFrameNodeLazyForEach')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/framenode/FrameNodeLazyForEach'
          })
        })
      Button('ShowFrameNodeLazyForEachSelect')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/framenode/FrameNodeLazyForEachSelect'
          })
        })
      Button('ShowFrameNodeCanvas')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/framenode/FrameNodeCanvas'
          })
        })
    }
    .height('100%')
    .width('100%')
  }
}