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

@Component
export struct ImageDrag {
  @State visible: boolean = true

  // 自定义拖拽过程中显示的内容
  @Builder pixelMapBuilder() {
    Image($r('app.media.icon'))
      .width(48)
      .aspectRatio(1)
  }

  build() {
    Column() {
      Image($r('app.media.icon'))
        .id('image')
        .width(48)
        .aspectRatio(1)
        .visibility(this.visible ? Visibility.Visible : Visibility.Hidden)
        .draggable(true)
        .onDragStart(() => {
          this.visible = false
          return this.pixelMapBuilder
        })
        .onDragEnd(() => {
          this.visible = true
        })
    }
    .width(400)
    .height(80)
    .backgroundColor(0xF9CF93)
    .justifyContent(FlexAlign.Center)
  }
}