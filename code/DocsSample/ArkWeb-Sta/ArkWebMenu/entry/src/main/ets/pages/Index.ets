'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { BusinessError, AsyncCallback } from '@ohos.base'
import { Entry, Column, Component, Button, ClickEvent, Length } from '@ohos.arkui.component'
import { UIContext } from '@ohos.arkui.UIContext'

@Entry
@Component
struct Index {
  build() {
    Column() {
      Button('textMenuItem')
        .onClick((e: ClickEvent) => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebTextMenuItem',
          }, (error: BusinessError<void> | null) => {
            if (error) {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            }
          })
        })
      Button('contextMenu')
        .onClick((e: ClickEvent) => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebContextMenu',
          }, (error: BusinessError<void> | null) => {
            if (error) {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            }
          })
        })
      Button('bindSelectionMenu')
        .onClick((e: ClickEvent) => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebBindSelectionMenu',
          }, (error: BusinessError<void> | null) => {
            if (error) {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            }
          })
        })
      Button('previewBuilder')
        .onClick((e: ClickEvent) => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebPreviewBuilder',
          }, (error: BusinessError<void> | null) => {
            if (error) {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            }
          })
        })
      Button('saveImage')
        .onClick((e: ClickEvent) => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebSaveImage',
          }, (error: BusinessError<void> | null) => {
            if (error) {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            }
          })
        })
      Button('editMenuOptions')
        .onClick((e: ClickEvent) => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebEditMenuOptions',
          }, (error: BusinessError<void> | null) => {
            if (error) {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            }
          })
        })
      Button('disableLongPress')
        .onClick((e: ClickEvent) => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebDisableLongPress',
          }, (error: BusinessError<void> | null) => {
            if (error) {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            }
          })
        })
      Button('bindSelectionMenuText')
        .onClick((e: ClickEvent) => {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/WebBindSelectionMenuText',
          }, (error: BusinessError<void> | null) => {
            if (error) {
              console.error(`pushUrl failed, code is ${error.code}, message is ${error.message}`);
            }
          })
        })
    }.height('100%')
    .width('100%')
  }
}
