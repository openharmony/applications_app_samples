'use static';
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
  Text,
  TextAttribute,
  Column,
  Component,
  Button,
  ButtonAttribute,
  ClickEvent,
  Row,
  TextAlign,
  Visibility,
  List,
  ListItem,
  ForEach,
  TextOverflow,
  Image,
  HorizontalAlign,
  Progress,
  ProgressType,
  FlexAlign,
  SafeAreaType,
  JSON,
  $r,
  Margin,
  TextDecorationType
} from '@ohos.arkui.component';
import {
  State,
  Link,
  MutableState,
  stateOf,
  observableProxy,
  Prop,
  Watch
} from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import { downloadFilesData } from '../model/dataType';

@Component
export struct HistoryItem {
  // 文件数据
  @Prop fileDataInfo: downloadFilesData;

  build() {
    Row() {
      Row() {
        Image($r('app.media.multiple_files_download_file'))
          .height(50)
          .width(50)
          .borderRadius(8)
          .id('fileImage')
      }.width('17%')

      Column() {
        Row() {
          Column() {
            Text(this.fileDataInfo.url.split('/').pop() || '文件')
              .height(22)
              .width('100%')
              .fontSize(14)
              .fontColor('#000000')
              .textAlign(TextAlign.Start)
              .maxLines(1) // 限制为单行
              .id('fileName')

            Row() {
              Text($r('app.string.text_download'))
                .fontSize(12)
                .fontColor('#66182431')
                .id('downloadVal')
            }.width('100%')
            .height(23)
          }
          .width('75%')

          Button($r('app.string.multiple_files_download_history_text_downloaded'))
            .fontSize(12)
            .height(30)
            .width('25%')
            .borderRadius(8)
            .backgroundColor($r('app.color.operate_rdb_in_taskpool_button_background_color_green'))
        }
      }
      .width('83%')
      .height(50)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height(80)
  }
}