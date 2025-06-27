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

import { memo, __memo_context_type, __memo_id_type } from '@ohos.arkui.stateManagement'; // should be insert by ui-plugins
import { Margin, Column, Component, Entry, UserView } from '@ohos.arkui.component';  // TextAttribute should be insert by ui-plugins
import { Text,  List, ListItem, TextAttribute, Column, Component, Button, ButtonAttribute, ClickEvent, UserView, $r,FlexAlign,
  Image, Margin, Blank, Row, Builder, Alignment, ForEach, Padding, Color, Divider, Tabs, TabContent, BuilderParam, JSON,
  LazyForEach, ListItemGroup, Entry, Canvas, CanvasRenderingContext2D, RenderingContextSettings
} from '@ohos.arkui.component';  // TextAttribute should be insert by ui-plugins
import hilog from '@ohos.hilog';
import camera from '@ohos.multimedia.camera';
import { UIContext } from '@ohos.arkui.UIContext'

@Entry
@Component
struct MyStateSample {
  build() {
    Column(undefined) {
      Button($r('app.string.background_blur_discover'))
        .onClick((e: ClickEvent) => {
          this.getUIContext().getRouter().pushUrl({url: 'pages/collapsemenu/CollapseMenuSection'})
        })
        .width('80%')
      Button($r('app.string.background_blur_hot'))
        .onClick((e: ClickEvent) => {
          this.getUIContext().getRouter().pushUrl({url: 'pages/functionalScenes/FunctionalScenes'})
        })
        .width('80%')
        .margin({top: 20} as Margin)
      Button($r('app.string.custom_tab_bar'))
        .onClick((e: ClickEvent) => {
          this.getUIContext().getRouter().pushUrl({url: 'pages/tabBar/TabBar'})
        })
        .width('80%')
        .margin({top: 20} as Margin)
      Button($r('app.string.custom_tab_Content'))
        .onClick((e: ClickEvent) => {
          this.getUIContext().getRouter().pushUrl({url: 'pages/tabContentOverFlow/TabContentOverFlow'})
        })
        .width('80%')
        .margin({top: 20} as Margin)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }
}

export class ComExampleTrivialApplication extends UserView {
  getBuilder() {
    let wrapper = @memo () => {
      MyStateSample(undefined)
    }
    return wrapper
  }
}