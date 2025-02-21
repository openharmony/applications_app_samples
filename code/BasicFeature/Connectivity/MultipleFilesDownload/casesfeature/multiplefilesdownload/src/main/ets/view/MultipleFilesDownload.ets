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

import { FileDownloadItem } from './FileDownloadItem';
import request from '@ohos.request'; // 导入上传下载模块。需要配置ohos.permission.INTERNET权限
import {
  ItemRestriction,
  SegmentButton,
  SegmentButtonOptions,
  SegmentButtonTextItem
} from '@ohos.arkui.advanced.SegmentButton'; // 分段按钮,仅用于ux展示
import { downloadFilesData } from '../model/dataType';
import HistoryItem from './HistoryItem';
import { Context } from '@kit.AbilityKit';
import { JSON, util } from '@kit.ArkTS';

const NO_TASK: number = 0; // 0个下载任务

/**
 * 功能描述: 多文件下载监听在应用开发中是一个非常常见的需求。本示例将介绍如何使用request上传下载模块实现多文件下载监听，如监听每个文件下载任务的进度，任务暂停，下载完成等下载情况。
 *         每个应用最多支持创建10个未完成的任务，相关规格说明请参考request.agent.create。
 *
 * 推荐场景: 多文件下载
 *
 * 核心组件:
 * 1. FileDownloadItem
 *
 * 实现步骤：
 * 1.配置下载参数。一个下载任务需要配置对应一套下载参数request.agent.Config。本例中使用downloadConfig方法简单配置了下载文件的url，实际业务
 * 中请按实际情况按需配置。
 * 2.创建多个文件下载监听实例。单个文件下载监听只需要配置下载参数，创建下载任务，注册下载任务相关监听，启动下载任务即可实现。而要实现多文件下载监听，
 * 需要每个下载任务注册独立的下载监听回调。本例通过封装自定义组件FileDownloadItem，在每个FileDownloadItem中创建各自的下载任务和监听回调，从
 * 而实现多文件下载监听。
 * 3.创建下载任务，并注册下载任务相关监听。本例在每个FileDownloadItem中使用request.agent.create创建下载任务。然后在下载任务创建成功后，注
 * 册各自下载任务相关监听。本例中注册了下载任务完成回调，下载任务失败回调，下载进度更新回调，暂停任务回调，重新启动任务回调。
 * 4.启动下载任务。本例在每个FileDownloadItem中使用task.start方法启动各自的下载任务。
 * 5.本例中下载任务用到的其他操作：使用request.agent.show，根据任务id可查询任务的详细信息。使用task.pause可以暂停正在等待WAITING/正在运行
 * RUNNING/正在重试RETRYING的后台下载任务。使用task.resume可以重新启动任务，可恢复暂停的后台任务。
 */

@Component
export struct MultipleFilesDownloadComponent {
  // 是否全部开始下载
  @State isStartAllDownload: boolean = false;
  // 待下载任务数量
  @State downloadCount: number = 0;
  // 下载失败任务数量。当所有任务下载失败时，"全部暂停"状态重置为"全部开始"。
  @State downloadFailCount: number = 0;
  // 分段按钮，仅用于ux展示
  @State tabOptions: SegmentButtonOptions = SegmentButtonOptions.tab({
    buttons: [{ text: $r('app.string.multiple_files_download_file_upload') },
      { text: $r('app.string.multiple_files_download_list') },
      { text: $r('app.string.multiple_files_download_album_backup') }] as ItemRestriction<SegmentButtonTextItem>,
    backgroundBlurStyle: BlurStyle.BACKGROUND_THICK,
    selectedFontColor: Color.White,
    selectedBackgroundColor: $r('app.color.multiple_files_download_selected_background_color'),
    backgroundColor: $r('app.color.multiple_files_download_background_color')
  })
  // 监听SegmentButton组件selectedIndexes值变化，[1]表示设置默认选中项编号为'下载列表'项
  @State @Watch('onSelectedChange') tabSelectedIndexes: number[] = [1];
  // 下载列表内容透明度。用于控制是否显示下载列表相应内容
  @State downloadPageOpacity: number = 1;
  // 下载列表内容使能控制。避免隐藏后还能点击
  @State isDownloadPageEnabled: boolean = true;
  // 历史列表的显隐控制。
  @State historyPageVisibility: Visibility = Visibility.None;
  // 历史列表内容使其能控制。避免隐藏后还能点击
  @State isHistoryPageEnabled: boolean = false;
  // 点击历史列表tab时，控制下载列表相应的内容的显隐
  @State downloadPageVisibility: Visibility = Visibility.Visible;
  // 下载列表数据
  @State downloadFileArray: downloadFilesData[] = [];
  // 下载历史列表数据
  @State historyList: downloadFilesData[] = [];

  // 当选择"下载列表"时,显示下载列表相应内容，选择其他选项时，不显示内容，仅用于ux展示
  onSelectedChange(): void {
    // 显示下载列表内容
    if (this.tabSelectedIndexes[0] === 1) {
      this.downloadPageOpacity = 1;
      this.isDownloadPageEnabled = true;
      this.downloadPageVisibility = Visibility.Visible;
      this.historyPageVisibility = Visibility.None;
    } else if (this.tabSelectedIndexes[0] === 2) {
      // 不显示下载列表相应内容,并不占位
      this.isDownloadPageEnabled = false;
      this.downloadPageVisibility = Visibility.None;
      // 显示历史列表相应内容
      this.historyPageVisibility = Visibility.Visible;
      this.isHistoryPageEnabled = true;
    } else {
      this.downloadPageOpacity = 0;
      this.isDownloadPageEnabled = false;
      this.historyPageVisibility = Visibility.None;
      this.isHistoryPageEnabled = false;
    }
    // 点击分段按钮时，若下载数量为0，重置是否全部开始下载按钮
    if (this.downloadCount === 0) {
      this.isStartAllDownload = false;
    }
  }

  // 下载信息初始化
  aboutToAppear(): void {
    // 初始化下载列表
    this.loadInitializationDataSource();

    // 下载数量，用于显示页面上下载队列数量
    this.downloadCount = this.downloadFileArray.length;
  }

  // 读取historyDownloadResourceData.json中的数据源
  loadInitializationDataSource() {
    const context: Context = getContext(this);
    // 读取historyDownloadResourceData.json中的数据
    let jsonData: Uint8Array = context.resourceManager.getRawFileContentSync('historyDownloadResourceData.json');
    // 将数据解码，转成字符串
    let stringData: string = util.TextDecoder.create('utf-8').decodeToString(jsonData);
    let data: [] = JSON.parse(stringData) as [];

    for (let i = 0; i < data.length; i++) {
      const downloadItemData = data[i] as downloadFilesData;
      let downloadData: downloadFilesData = new downloadFilesData(downloadItemData.url, downloadItemData.fileStatus,
        downloadItemData.downloadTime);
      // 将数据存入下载列表
      this.downloadFileArray.push(downloadData);
    }
  }

  build() {
    Column() {
      Text($r('app.string.multiple_files_download_transfer_list'))
        .fontSize($r('app.integer.multiple_files_download_text_font_size_twenty_five'))
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)
      SegmentButton({ options: this.tabOptions, selectedIndexes: $tabSelectedIndexes })
        .margin({
          top: $r('app.integer.multiple_files_download_margin_top_twenty'),
          bottom: $r('app.integer.multiple_files_download_margin_bottom_twelve')
        })

      Row() {
        Row() {
          Text($r('app.string.multiple_files_download_queue'))
            .fontSize($r('app.integer.multiple_files_download_text_font_size_twenty'))
          Text(this.downloadCount.toString()).fontSize($r('app.integer.multiple_files_download_text_font_size_twenty'))
        }.width($r('app.string.multiple_files_download_row_width'))

        Row() {
          // this.downloadCount > 0用于当存在未完成的下载任务时才可以暂停下载
          Text(this.isStartAllDownload && this.downloadCount > NO_TASK ? '全部暂停' : '全部开始')
            .fontSize($r('app.integer.multiple_files_download_text_font_size_twenty'))
            .fontColor($r('app.color.multiple_files_download_text_color'))
            .textAlign(TextAlign.End)
            .width($r('app.string.multiple_files_download_row_text_width'))
            .id('download')
            .onClick(() => {
              if (this.downloadCount === NO_TASK) {
                AlertDialog.show({
                  message: $r('app.string.multiple_files_download_completed'),
                  alignment: DialogAlignment.Center
                });
                return;
              }
              this.isStartAllDownload = !this.isStartAllDownload;
            })
        }.width($r('app.string.multiple_files_download_row_width'))
      }
      .opacity(this.downloadPageOpacity)
      .visibility(this.downloadPageVisibility)
      .enabled(this.isDownloadPageEnabled)
      .width($r('app.string.multiple_files_download_outer_row_width'))

      List() {
        /**
         * 本例只展示下载列表。由于每个应用request.agent.create最多支持创建10个未完成的任务，数量较小，所以这里使用ForEach展示下载列表。
         * 如果需要显示大量历史下载完成任务信息，建议使用LazyForEach提升性能。create相关限制说明请参考:https://docs.openharmony.cn
         * /pages/v5.0/en/application-dev/reference/apis-basic-services-kit/js-apis-request.md。
         */
        ForEach(this.downloadFileArray, (item: downloadFilesData) => {
          ListItem() {
            // TODO 知识点：创建多个文件下载监听实例。单个文件下载监听只需要配置下载参数，创建下载任务，注册下载任务相关监听，启动下载任务即可实现。
            //  而要实现多文件下载监听，需要每个下载任务注册独立的下载监听回调。本例通过封装自定义组件FileDownloadItem，
            //  在每个FileDownloadItem中创建各自的下载任务和监听回调，从而实现多文件下载监听。
            FileDownloadItem({
              fileDataInfo: item, // 文件下载配置
              isStartAllDownload: this.isStartAllDownload, // 是否全部开始下载
              downloadCount: this.downloadCount, // 待下载任务数量
              downloadFailCount: this.downloadFailCount, // 下载失败任务数量
              historyArray: this.historyList,
              downloadFileArray: this.downloadFileArray // 下载文件数据源
            })
          }
          .margin({ bottom: $r('app.integer.multiple_files_download_margin_bottom_eighteen') })
        }, (item: request.agent.Config) => JSON.stringify(item))
      }
      .opacity(this.downloadPageOpacity)
      .visibility(this.downloadPageVisibility)
      .enabled(this.isDownloadPageEnabled)
      .width($r('app.string.multiple_files_download_list_width'))
      .height($r('app.string.multiple_files_download_list_height'))
      .margin({ top: $r('app.integer.multiple_files_download_margin_top_thirty') })

      // 下载历史列表
      Column() {
        List() {
          ForEach(this.historyList, (item: downloadFilesData) => {
            ListItem() {
              HistoryItem({
                fileInfo: item,
                downloadCount: this.downloadCount, // 待下载任务数量
                historyArray: this.historyList,
                downloadFileArray: this.downloadFileArray // 下载文件数据源
              })
            }
          })
        }
      }
      .visibility(this.historyPageVisibility)
      .enabled(this.isHistoryPageEnabled)
      .width($r('app.string.multiple_files_download_outer_row_width'))
      .height($r('app.string.multiple_files_download_list_height'))
      .margin({ top: $r('app.integer.multiple_files_download_margin_top_thirty') })

    }.padding($r('app.integer.multiple_files_download_padding_fifteen'))
    .focusable(false) // 避免SegmentButton组件在Navigator路由页面中获焦显示多余的选中框
  }
}