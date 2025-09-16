/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import {
  memo,
  __memo_context_type,
  __memo_id_type
} from '@ohos.arkui.stateManagement';
import {
  Entry,
  Row,
  Text,
  TextAttribute,
  Column,
  Component,
  Button,
  ButtonAttribute,
  ClickEvent,
  TextArea,
  Scroll
} from '@ohos.arkui.component';
import {
  State,
  MutableState,
  stateOf,
  observableProxy
} from '@ohos.arkui.stateManagement';
import { Context, UIContext } from '@ohos.arkui.UIContext';
import { DecompressFileViewComponent } from './DecompressFile/DecompressFileViewComponent';
import { CompressFileViewComponent } from './CompressFile/CompressFile';
import { BigFileCopyViewComponent } from './BigFileCopy/BigFileCopyView';

@Entry
@Component
struct MyStateSample {
  build() {
    Scroll() {
      Column() {
        Button('BigFileCopyView')
          .onClick((e: ClickEvent) => {
            this.getUIContext().getRouter().pushUrl({ url: "pages/BigFileCopy/BigFileCopyView" })
          }).fontSize(20).margin(15).width("100%")
        Button('CompressFileView')
          .onClick((e: ClickEvent) => {
            this.getUIContext().getRouter().pushUrl({ url: "pages/CompressFile/CompressFile" })
          }).fontSize(20).margin(15).width("100%")
        Button('DecompressFileView')
          .onClick((e: ClickEvent) => {
            this.getUIContext().getRouter().pushUrl({ url: "pages/DecompressFile/DecompressFileViewComponent" })
          }).fontSize(18).margin(15).width("100%")
      }
      .padding(15)
      .width("100%")
    }
  }
}
