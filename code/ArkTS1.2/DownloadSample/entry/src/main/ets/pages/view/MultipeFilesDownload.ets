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
import { BusinessError } from '@ohos.base'
import request from '@ohos.request'; // 导入上传下载模块。需要配置ohos.permission.INTERNET权限
import { downloadFilesData } from '../model/dataType';
import { FileDownloadItem } from './FileDownloadItem';
import { HistoryItem } from './HistoryItem';

const NO_TASK: number = 0; // 0个下载任务
const INIT_PROGRESS: number = 0; // 进度条初始值
const BYTE_CONVERSION: number = 1024; // 字节转换

@Entry
@Component
export struct MultipleFilesDownloadComponent {
  @State message: string = '待下载';
  // 是否全部开始下载
  @State isStartAllDownload: boolean = false;
  // 待下载任务数量
  @State downloadCount: number = 0;
  // 下载失败任务数量。当所有任务下载失败时，'全部暂停'状态重置为'全部开始'。
  @State downloadFailCount: number = 0;
  // 下载列表内容使能控制。避免隐藏后还能点击
  @State isDownloadPageEnabled: boolean = true;
  // 点击历史列表tab时，控制下载列表相应的内容的显隐
  @State downloadPageVisibility: Visibility = Visibility.Visible;
  // 历史列表内容使其能控制。避免隐藏后还能点击
  @State isHistoryPageEnabled: boolean = false;
  // 历史列表的显隐控制。
  @State historyPageVisibility: Visibility = Visibility.None;
  // 下载列表数据
  @State downloadFileArray: downloadFilesData[] = [
    {
      'id': '1',
      'url': 'https://gitee.com/harmonyos-cases/cases/raw/master/plugin/case_plugin-1.0.10-Alpha.zip',
      'fileStatus': 0,
      'downloadTime': 1728529510880
    }
    ,
    {
      'id': '2',
      'url': 'https://gitee.com/harmonyos-cases/cases/blob/master/CommonAppDevelopment/product/entry/src/main/resources/base/media/after_cache.png',
      'fileStatus': 0,
      'downloadTime': 1728529510880
    }
    ,
    {
      'id': '3',
      'url': 'https://gitee.com/harmonyos-cases/cases/blob/master/CommonAppDevelopment/product/entry/src/main/resources/base/media/icon_main_color.png',
      'fileStatus': 0,
      'downloadTime': 1728529510880
    }
  ] as downloadFilesData[];
  // 下载历史列表数据
  @State historyArray: downloadFilesData[] = [] as downloadFilesData[];

  // 下载信息初始化
  aboutToAppear(): void {
    // 下载数量，用于显示页面上下载队列数量
    this.downloadCount = this.downloadFileArray.length;
  }

  build() {
    Column() {
      Text($r('app.string.router_back'))
        .fontSize(20)
        .width('100%')
        .onClick((): void => {
          this.getUIContext().getRouter().back();
        })

      Text($r('app.string.multiple_files_download_transfer_list'))
        .fontSize(25)
        .textAlign(TextAlign.Center)
      Row() {
        Text($r('app.string.multiple_files_download_list'))
          .fontSize(16)
          .fontColor(this.isDownloadPageEnabled ? '#FFFFFF' : '#808080')
          .textAlign(TextAlign.Center)
          .backgroundColor(this.isDownloadPageEnabled ? '#007DFF' : '#E8E8E8')
          .width('49%')
          .height(35)
          .borderRadius(50)
          .margin(3)
          .onClick((e: ClickEvent) => {
            this.isDownloadPageEnabled = true;
            this.downloadPageVisibility = Visibility.Visible;
            this.historyPageVisibility = Visibility.None;
            this.isHistoryPageEnabled = false;
          })

        Text($r('app.string.multiple_files_download_album_backup'))
          .fontSize(16)
          .fontColor(this.isDownloadPageEnabled ? '#808080' : '#FFFFFF')
          .textAlign(TextAlign.Center)
          .backgroundColor(this.isDownloadPageEnabled ? '#E8E8E8' : '#007DFF')
          .width('49%')
          .height(35)
          .borderRadius(50)
          .margin(3)
          .onClick((e: ClickEvent) => {
            this.isDownloadPageEnabled = false;
            this.downloadPageVisibility = Visibility.None;
            this.historyPageVisibility = Visibility.Visible;
            this.isHistoryPageEnabled = true;
          })
      }
      .width('100%')
      .backgroundColor('#E8E8E8')
      .borderRadius(50)
      .margin(20)

      Row() {
        Row() {
          Text($r('app.string.multiple_files_download_queue')).fontSize(20)
          Text(String(this.downloadCount)).fontSize(20)
        }.width('50%')

        Row() {
          // 已开始下载且有任务时为全部暂停，否则为全部开始
          Text('开始下载')
            .fontSize(20)
            .fontColor(this.isStartAllDownload && this.downloadCount > NO_TASK ? '#999' : '#418AF3')
            .textAlign(TextAlign.End)
            .width('100%')
            .id('download')
            .onClick((): void => {
              if (this.downloadCount === NO_TASK) {
                return;
              }
              this.isStartAllDownload = !this.isStartAllDownload;
            })
        }.width('50%')
      }
      .visibility(this.downloadPageVisibility)
      .enabled(this.isDownloadPageEnabled)
      .width('100%')

      // 下载列表
      List() {
        ForEach(this.downloadFileArray, (item: downloadFilesData) => {
          ListItem() {
            FileDownloadItem({
              fileDataInfo: item, // 文件下载数据
              isStartAllDownload: this.isStartAllDownload, // 是否全部开始下载
              downloadCount: this.downloadCount, // 待下载任务数量
              downloadFailCount: this.downloadFailCount, // 下载失败任务数量
              historyArray: this.historyArray,   // 历史列表数据
              downloadFileArray: this.downloadFileArray // 下载文件数据源
            })
          }
        }, (item: downloadFilesData) => item.id)
      }
      .visibility(this.downloadPageVisibility)
      .enabled(this.isDownloadPageEnabled)
      .width('100%')
      .height('80%')

      // 下载历史列表
      List() {
        ForEach(this.historyArray, (item: downloadFilesData) => {
          ListItem() {
            HistoryItem({ fileDataInfo: item })
          }
        }, (item: downloadFilesData) => item.id)
      }
      .visibility(this.historyPageVisibility)
      .enabled(this.isHistoryPageEnabled)
      .width('100%')
      .height('80%')

    }.padding(15)
    .width('100%')
    .height('100%')
  }
}