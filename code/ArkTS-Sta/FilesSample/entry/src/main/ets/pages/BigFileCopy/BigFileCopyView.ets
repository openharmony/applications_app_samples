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
  Stack,
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
  $r,
  HorizontalAlign,
  Progress,
  ProgressType,
  FlexAlign,
  SafeAreaType
} from '@ohos.arkui.component';
import { State, Link, MutableState, stateOf, observableProxy, PropRef } from '@ohos.arkui.stateManagement';

import { BigFileCopyConstants } from './BigFileCopyConstants';
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import hilog from '@ohos.hilog';
import resourceManager from '@ohos.resourceManager';

const IMAGE_ID: string = 'bigFileImage';

/**
 * 功能描述：文件拷贝是应用开发中的一个常见场景，本例将展示如何使用buffer来将大文件的rawfile复制到应用沙箱。
 *
 * 推荐场景：需要数据备份的软件，如网盘，文件管理器等
 *
 * 核心组件：
 * 1.BigFileCopyView
 *
 * 实现步骤：
 * 1. 根据rawfile获得其所在hap包的RawFileDescriptor
 * 2. 根据RawFileDescriptor中的fd、偏移、文件长度，使用buffer进行内容读取
 * 3. 调用图库对复制的文件进行预览，以验证复制过程的正确性
 */
@Entry
@Component
export struct BigFileCopyViewComponent {
  @State progress: number = BigFileCopyConstants.PROGRESS_MIN;
  fileName: string = BigFileCopyConstants.TEST_FILE_NAME;
  targetFilePath: string = '';
  @State isCopyFinished: boolean = false;
  @State isEnableSmooth: boolean = true;
  @State isPreview: boolean = false;
  context: common.Context = this.getUIContext().getHostContext() as common.Context;

  copyFile2Sandbox() {
    this.isCopyFinished = false;
    // 知识点：这里获取到的fd并不是目标文件的fd，而是文件所属hap包的fd
    const data: resourceManager.RawFileDescriptor = this.context.resourceManager.getRawFdSync(this.fileName);
    const targetPath: string = this.context.filesDir + '/' + this.fileName;
    const destFile: fs.File = fs.openSync(targetPath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    let buffSize: long = BigFileCopyConstants.BUFF_SIZE as long;
    const buffer: ArrayBuffer = new ArrayBuffer(Math.min(buffSize, data.length));
    let off: long = 0; // 记录读取位置的偏移（相较于文件起始偏移）
    let len: long = 0; // 本次读取内容的实际长度
    let readLen: long = 0; // 记录已读文件长度
    len = fs.readSync(data.fd, buffer, { offset: data.offset + off, length: buffSize })
    // 知识点：因为获取的是所属hap包的fd，这里需要通过目标文件的大小和偏移进行复制
    while (len) {
      len = fs.readSync(data.fd, buffer, { offset: data.offset + off, length: buffSize })
      readLen += len;
      fs.writeSync(destFile.fd, buffer, { offset: off, length: len });
      this.progress = Math.floor((readLen / data.length) * 100); // 小数转换成百分比
      off = off + len;
      if ((data.length - readLen) < buffSize) {
        buffSize = data.length - readLen;
      }
    }
    this.targetFilePath = targetPath;
    fs.close(destFile.fd);
    this.isCopyFinished = true;
  }

  setIsPreview(status: boolean): void {
    this.isPreview = status;
  }

  build() {
    Column() {
      Row() {
        Text('← 返回').fontSize(20)
          .onClick((e: ClickEvent) => {
            this.getUIContext().getRouter().back();
          }).width('100%')
      }.height('5%')
      Column() {
        Stack() {
          if (!this.isPreview) {
            Progress({
              value: this.progress,
              total: BigFileCopyConstants.PROGRESS_MAX,
              type: ProgressType.Eclipse
            })
              .size({ width: BigFileCopyConstants.COMPONENT_SIZE, height: BigFileCopyConstants.COMPONENT_SIZE })
          } else {
            Image(BigFileCopyConstants.SANDBOX_PREFIX + this.targetFilePath)
              .width(BigFileCopyConstants.COMPONENT_SIZE)
              .height(BigFileCopyConstants.COMPONENT_SIZE)
              .borderRadius(10)
              .id(IMAGE_ID)
          }
        }

        Text(`当前复制进度：${this.progress}%`)
          .margin(30)
        Button('Start Copy')
          .enabled(!this.isCopyFinished)
          .onClick((): void => {
            this.copyFile2Sandbox();
          })
        Button('Reset')
          .margin(10)
          .enabled(this.isCopyFinished)
          .onClick((): void => {
            this.progress = BigFileCopyConstants.PROGRESS_MIN;
            this.isCopyFinished = false;
            this.setIsPreview(false);
          })
        Button('Preview')
          .enabled(this.isCopyFinished)
          .onClick((): void => {
            this.setIsPreview(true);
          })
      }
    }.width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }
}