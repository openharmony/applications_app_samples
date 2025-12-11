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

import { memo, __memo_context_type, __memo_id_type } from '@ohos.arkui.stateManagement';
import {
  Text,
  TextAttribute,
  Column,
  Component,
  Button,
  ButtonAttribute,
  ClickEvent,
  Row,
  List,
  ListItem,
  HorizontalAlign,
  LazyForEach,
  ForEach,
  Flex,
  FlexAlign,
  Image,
  $r,
  GradientDirection,
  FontWeight,
  TextAlign,
  Divider,
  Entry
} from '@ohos.arkui.component';
import { State, MutableState, stateOf, observableProxy, Link, PropRef } from '@ohos.arkui.stateManagement';
import { BusinessError } from '@ohos.base';
import hilog from '@ohos.hilog';
import zlib from '@ohos.zlib';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { UIContext, PromptAction } from '@ohos.arkui.UIContext';

const LAYOUT_WEIGHT = 1;
const CACHED_COUNT = 5; // LazyForEach预加载的Item数量
const LINEAR_GRADIENT_START = 0;
const LINEAR_GRADIENT_END = 1;

/**
 * 功能描述: 本示例介绍使用@ohos.zlib 提供的zlib.decompressfile接口对沙箱目录中的压缩文件进行解压操作，解压成功后将解压路径返回主线程，获取解压文件列表
 *
 * 推荐场景: 解压文件
 *
 * 实现步骤：
 * 1. 将项目目录rawfile下的压缩文件写入到应用的沙箱目录，用于后续介绍解压操作
 * 2. 解压文件
 * 4. 根据解压后的文件所属沙箱目录，获取解压后的文件列表
 */
@Entry
@Component
export struct DecompressFileViewComponent {
  @State pathDir: string = '';
  // 解压后的文件所处的应用沙箱目录
  @State outFileDir: string = '';
  // rawfile压缩文件的应用沙箱路径
  private rawfilePath: string = '';
  // 待解压的文件名
  private rawfileZipName: string = 'decompress_file_test.zip';
  @State fileList: Array<string> = new Array<string>();
  context: common.Context = this.getUIContext().getHostContext() as common.Context;
  uiContext: UIContext | undefined = undefined;

  aboutToAppear(): void {
    this.uiContext = this.getUIContext();
    this.initZip(this.rawfileZipName)
  }

  /**
   * 对文件进行解压缩
   * @returns
   */
  doDecompress(): void {
    const pathDir: string = this.context.filesDir;
    // 沙箱目录和去掉文件名后缀的压缩文件名称拼接成解压输出目录
    const outFileDir: string = `${pathDir}/${this.rawfileZipName.split('.')[0]}`;
    let fileDirInfo: boolean =  fs.accessSync(outFileDir)
      if (!fileDirInfo) {
        fs.mkdirSync(outFileDir);
      }
      // 如果待解压的文件或文件夹在解压后的路径下已经存在，则会直接覆盖同名文件或同名文件夹中的同名文件。
      zlib.decompressFile(`${pathDir}/${this.rawfileZipName}`, outFileDir,
        (err: BusinessError<void> | null) => {
          if (!err || err.code == 0) {
            // 根据解压后的文件所属沙箱目录，获取解压后的文件列表
            let result: Array<string> = fs.listFileSync(outFileDir+'/'+this.rawfileZipName);
            let isSuccess = fs.accessSync(`${outFileDir}`);
            //该压缩文件中存在三个文件
            if (isSuccess && result.length == 3) {
              let promptAction: PromptAction = this.uiContext!.getPromptAction();
              promptAction.showToast({
                message: '解压缩成功',
                duration: 2000
              });
            }
          } else {
            hilog.error(0x0000, 'testTag',
              `decompressFile failed. code is ${err.code}, message is ${err.message}`);
          }
        })
  }

  // 将项目目录rawfile下的压缩文件写入到应用的沙箱目录，用于后续介绍解压操作。
  initZip(rawfileZipName: string) {
    // 使用getRowFileContent接口以字节数组的形式获取到rawfile中的文件内容。
    this.context.resourceManager.getRawFileContent(rawfileZipName,
      (error: BusinessError<void> | null, value: Uint8Array | undefined) => {
        if (value) {
          const rawFile: Uint8Array = value;
          // 获取应用沙箱目录
          this.pathDir = this.context.filesDir;
          // 设置rawfile压缩文件的应用沙箱路径
          this.rawfilePath = `${this.pathDir}/${rawfileZipName}`;
          // 在指定路径以同步方法打开或创建文件
          const file = fs.openSync(this.rawfilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
          // 使用fs.write接口将字节数组形式的rawfile的文件内容写入到指定沙箱路径filePath中
          fs.writeSync(file.fd, rawFile.buffer)
          fs.closeSync(file);
        } else {
          hilog.info(0x0000, 'testTag',
            `error message value: ${value}`);
        }
      });
  }

  build() {
    Column() {
      Row() {
        Text('← 返回').fontSize(20)
          .onClick((e: ClickEvent) => {
            this.getUIContext().getRouter().back();
          }).width('100%')
      }.height('5%')

      Row() {
        Column() {
          Text('文件解压')
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bolder)
            .fontSize(26)
            .margin(12)
          Text('使用@ohos.zlib解压文件')
            .fontColor('#FFFFFF')
            .margin(12)
        }
        .width(200)
        .alignItems(HorizontalAlign.Start)

        Image($r('app.media.zlib'))
          .width(40)
          .height(48)
      }
      .width('100%')
      .height(140)
      .padding(20)
      .backgroundColor('#94c4f5')
      .justifyContent(FlexAlign.SpaceBetween)
      .borderRadius(12)
      .linearGradient({
        direction: GradientDirection.Top,
        repeating: true,
        colors: [['#800f55ab', LINEAR_GRADIENT_START],
          ['#B354A1FF', LINEAR_GRADIENT_END]]
      })
      // 压缩文件组件
      Row() {
        Image($r('app.media.zlib'))
          .width(20)
          .height(24)
          .margin(5)
        Text(this.rawfileZipName)
          .fontSize(14)
          .layoutWeight(LAYOUT_WEIGHT)
        Button('解压')
          .fontWeight(FontWeight.Bold)
          .width(60)
          .height(28)
          .borderRadius(12)
          .onClick((): void => {
            this.doDecompress();
          })
      }
      .padding(12)
      .backgroundColor('#FFFFFF')
      Divider()
    }
    .height('100%')
    .padding(12)
    .backgroundColor('#F1F3F5')
  }
}

@Component
struct FileList {
  @State item: string = '';

  build() {
    Row() {
      Image($r('app.media.txt'))
        .width(20)
        .height(20)
        .margin(12)
      Text(this.item).fontSize(14)
    }
  }
}