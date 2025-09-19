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
  Row,
  TextAlign,
  List,
  ListItem,
  ForEach,
  Image,
  $r,
  HorizontalAlign,
  FlexAlign,
  GradientDirection,
  ClickEvent
} from '@ohos.arkui.component';
import {
  State,
  Link,
  MutableState,
  stateOf,
  observableProxy,
  PropRef
} from '@ohos.arkui.stateManagement';
import zlib from '@ohos.zlib';
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import { CompressFileComponent } from './CompressFileComponent';
import hilog from '@ohos.hilog';

const TAG: string = 'compressFileComponent';
const LINEAR_GRADIENT_START: double = 0;
const LINEAR_GRADIENT_END: double = 1;

/**
 * 功能描述：本示例主要介绍使用@ohos.zlib模块提供的zlib.compressFile接口对沙箱目录中的文件进行压缩操作。
 *
 * 推荐场景：文件管理中压缩文件时使用
 *
 * 核心组件：
 * 1.CompressFileComponent: 在子线程中压缩文件
 *
 * 实现步骤：
 * 1. 目录名称配置：指定压缩成功后压缩包路径
 * @example
 * @State compressZipDir: string = 'bundlefile/compress_file.zip';
 * 2. 目录名称配置：指定待压缩文件在rawfile下和应用沙箱目录下
 * @example
 * @State beCompressFileDir: string = 'compressfile';
 * 3. 数据存放配置：压缩后的压缩包存放变量
 * @example
 * @State compressBundleName: string = '';
 * 4.构建压缩组件
 * @example
 * CompressFileComponent({
 compressBundleName: this.compressBundleName,
 beCompressFileDir: this.beCompressFileDir,
 compressZipPath: this.compressZipDir,
 })
 */
@Entry
@Component
export struct CompressFileViewComponent {
  // rawfile下所有待压缩文件
  @State beCompressFiles: Array<string> = new Array<string>();
  // 压缩成功后压缩包名字
  @State compressBundleName: string = '';
  // 压缩成功后压缩包文件路径
  @State compressZipDir: string = 'bundleFile/compress_file.zip';
  // 待压缩文件所在目录名
  @State beCompressFileDir: string = 'compressfile';
  context: common.Context = this.getUIContext().getHostContext() as common.Context;

  aboutToAppear(): void {
    this.beCompressFiles = this.context.resourceManager.getRawFileListSync(this.beCompressFileDir);
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
        Row() {
          Column() {
            Text('文件压缩')
              .margin(10)
              .fontSize(28)
              .fontColor('#FFFFFF')
            Text('使用@ohos.zlib压缩文件')
              .margin(10)
              .fontColor('#FFFFFF')
          }
          .width(220)
          .alignItems(HorizontalAlign.Start)

          Image($r('app.media.zlib'))
            .margin(10)
            .width(40)
            .height(48)
        }
        .width('90%')
        .height('15%')
        .backgroundColor('#94c4f5')
        .borderRadius(12)
        .justifyContent(FlexAlign.SpaceBetween)
        .linearGradient({
          direction: GradientDirection.Top,
          repeating: true,
          colors: [['#800f55ab', LINEAR_GRADIENT_START],
            ['#B354A1FF', LINEAR_GRADIENT_END]]
        })

        Row() {
          Text('待压缩文件')
            .fontSize(18)
            .fontColor('#FFFFFF')
          /**
           * 构建压缩组件
           * compressBundleName: 压缩成功后压缩包的名字
           * beCompressFileDir: 待压缩文件所在目录名
           * compressZipPath: 压缩成功后压缩包路径
           */
          CompressFileComponent({
            compressBundleName: this.compressBundleName,
            beCompressFileDir: this.beCompressFileDir,
            compressZipPath: this.compressZipDir,
          })
        }
        .borderRadius(12)
        .width('90%')
        .backgroundColor('#94c4f5')
        .padding(10)
        .margin(5)
        .justifyContent(FlexAlign.SpaceBetween)

        CompressFileList({ fileNames: this.beCompressFiles, iconName: 'app.media.txt' })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }
}

@Component
struct CompressFileList {
  // 文件列表
  @PropRef fileNames: Array<string> = new Array<string>();
  // 文件图标
  @PropRef iconName: string = '';

  build() {
    Column() {
      List() {
        ForEach(this.fileNames, (item: string, index: number) => {
          ListItem() {
            Row() {
              Image($r(this.iconName))
                .width(20)
                .height(24)
                .margin(5)
              Text(item)
                .fontSize(14)
            }
            .height(50)
          }
        }, (item: string, index: number) => item)
      }
      .width('90%')
      .height(150)
    }
    .width('100%')
  }
}