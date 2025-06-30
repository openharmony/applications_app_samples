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
import { memo, __memo_context_type, __memo_id_type } from '@ohos.arkui.stateManagement' // should be insert by ui-plugins
import { RowAttribute, Padding, Axis, Resource, ListItem, ForEach, List, ResourceStr, CustomDialogController, Image, $r, ImageAttribute, Text, Row, TextAttribute, Column, Component, Button, ButtonAttribute, ClickEvent, UserView, Image, FlexAlign, HorizontalAlign, FlexDirection, Flex, ItemAlign } from '@ohos.arkui.component'  // TextAttribute should be insert by ui-plugins
import { Link, StorageLink, State, StateDecoratedVariable, MutableState, stateOf, observableProxy } from '@ohos.arkui.stateManagement' // should be insert by ui-plugins Extend,
import hilog from '@ohos.hilog'

@Component
export struct ImageListView {
  @State selectedImages: Array<ResourceStr> = new Array<ResourceStr>();
  build() {
    Column() {
      Row() {
        ForEach(this.selectedImages, (image: ResourceStr, index: Double) => {
          Image(image)
            .height(100)
            .width(100)
            .borderRadius(5)
        })
      }
      .width('100%')
      .height(110)
      .justifyContent(FlexAlign.Start)
    }
  }
}