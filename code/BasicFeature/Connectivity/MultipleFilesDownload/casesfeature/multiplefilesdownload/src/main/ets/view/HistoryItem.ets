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

import { getFileNameFromUrl, formatTime } from '../utils/formatTime';
import { downloadFilesData } from '../model/dataType';
import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { logger } from '../utils/Logger';
import { promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

const TAG: string = 'HistoryFiles';
const context = getContext(this) as common.UIAbilityContext; // 获取当前页面的上下文

@Component
export default struct HistoryItem {
  // 下载历史的数据
  @ObjectLink fileInfo: downloadFilesData;
  // 文件名称
  @State fileName: string = '';
  // 待下载任务数量
  @Link downloadCount: number;
  // 下载历史列表
  @Link historyArray: downloadFilesData[];
  // 下载列表
  @Link downloadFileArray: downloadFilesData[];

  aboutToAppear(): void {
    // 从下载链接获取文件名
    this.fileName = getFileNameFromUrl(this.fileInfo.url);
  }

  build() {
    Row() {
      RelativeContainer() {
        Image($r('app.media.multiple_files_download_file'))
          .height($r('app.integer.multiple_files_download_image_size_fifty'))
          .width($r('app.integer.multiple_files_download_image_size_fifty'))
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })
          .id('fileImage')

        // 文件名文本
        Text(this.fileName)
          .fontSize($r('app.integer.multiple_files_download_text_font_size_fourteen'))
          .margin({
            top: $r('app.integer.multiple_files_download_margin_top_seven'),
            left: $r('app.integer.multiple_files_download_padding_twenty')
          })
          .alignRules({
            left: { anchor: 'fileImage', align: HorizontalAlign.End }
          })
          .decoration({
            type: this.fileInfo.fileStatus === 1 ? TextDecorationType.None : TextDecorationType.LineThrough
          })
          .id('fileName')

        // 已下载文本
        Text(this.fileInfo.fileStatus === 1 ? $r('app.string.multiple_files_download_history_text_downloaded') : '')
          .fontSize($r('app.integer.multiple_files_download_text_font_size_twelve'))
          .fontColor($r('app.color.multiple_files_download_text_font_color'))
          .margin({
            top: $r('app.integer.multiple_files_download_margin_top_seven'),
            left: $r('app.integer.multiple_files_download_padding_twenty')
          })
          .alignRules({
            top: { anchor: 'fileName', align: VerticalAlign.Bottom },
            left: { anchor: 'fileImage', align: HorizontalAlign.End }
          })
          .id(this.fileName + 'state')

        // 下载完成时间
        Text(this.fileInfo.fileStatus === 1 ? formatTime(this.fileInfo.downloadTime, 'YYYY/MM/DD HH:mm') : '')
          .fontSize($r('app.integer.multiple_files_download_text_font_size_twelve'))
          .fontColor($r('app.color.multiple_files_download_text_font_color'))
          .margin({
            top: $r('app.integer.multiple_files_download_margin_top_seven'),
            left: $r('app.integer.multiple_files_download_margin_left_sixty')
          })
          .alignRules({
            top: { anchor: 'fileName', align: VerticalAlign.Bottom },
            left: { anchor: 'fileImage', align: HorizontalAlign.End }
          })
          .id('downloadTime')

        // 删除按钮
        Button($r('app.string.multiple_files_download_history_button_del'),
          { type: ButtonType.Normal, stateEffect: true })
          .fontSize($r('app.integer.multiple_files_download_text_font_size_twelve'))
          .padding({
            top: $r('app.integer.multiple_files_download_padding_zero'),
            left: $r('app.integer.multiple_files_download_padding_five'),
            bottom: $r('app.integer.multiple_files_download_padding_zero'),
            right: $r('app.integer.multiple_files_download_padding_five')
          })
          .height($r('app.integer.multiple_files_download_height_twenty_six'))
          .borderRadius($r('app.integer.multiple_files_download_borderRadius_eight'))
          .enabled(this.fileInfo.fileStatus === 1 ? true : false)
          .opacity(this.fileInfo.fileStatus === 1 ? 1 : 0.7)
          .backgroundColor($r('app.color.multiple_files_download_del_bgc'))
          .alignRules({
            bottom: { anchor: 'fileImage', align: VerticalAlign.Bottom },
            right: { anchor: '__container__', align: HorizontalAlign.End }
          })
          .margin({ bottom: 10 })
          .onClick(() => {
            let filePath = getContext(this).cacheDir + '/' + this.fileName;

            // TODO：知识点：删除该条数据应用文件路径
            fs.unlink(filePath).then(() => {
              // 文件状态变为已删除
              this.fileInfo.fileStatus = 3;
              promptAction.showToast({
                message: $r('app.string.multiple_files_download_history_toast_text_del'),
                duration: 2000,
                bottom: '50%',
              })
            }).catch((error: BusinessError) => {
              logger.error('remove file failed with error:' + error);
            });

            emitter.emit({ eventId: 0, priority: 0 }, {
              data: {
                isDel: true
              }
            })
          })
          .id(this.fileName + 'delete')
      }
    }
    .width($r('app.string.multiple_files_download_list_width'))
    .height($r('app.string.multiple_files_download_relative_container_height'))
    .id(this.fileName)
    .onClick(() => {
      // 获取应用文件路径
      const cacheDir = context.cacheDir;
      const filePath: string = `${cacheDir}/${this.fileName}`;

      // TODO：知识点：使用fs.access判断目录是否已经存在。
      fs.access(filePath).then((res: boolean) => {
        if (!res) {
          // 文件已删除，弹窗提示是否重新下载
          AlertDialog.show({
            message: `${this.fileName}文件不存在,是否重新下载？`,
            alignment: DialogAlignment.Center, // 弹窗在竖直方向上的对齐方式。
            autoCancel: false, // 点击遮罩层时，是否关闭弹窗。默认值：true
            primaryButton: {
              value: $r('app.string.multiple_files_download_history_button_text_cancel'),
              fontColor: $r('app.color.multiple_files_download_text_color'),
              action: () => {
                logger.info('已取消');
              }
            },
            secondaryButton: {
              value: $r('app.string.multiple_files_download_history_button_text_confirm'),
              fontColor: $r('app.color.multiple_files_download_del_bgc'),
              action: () => {
                // 更改该条数据下载状态
                this.fileInfo.fileStatus = 0;
                // 该条数据加入下载列表数组中
                this.downloadFileArray.push(this.fileInfo);
                // 下载历史列表删除该条数据
                this.historyArray = this.historyArray.filter((item: downloadFilesData) => {
                  return item.id !== this.fileInfo.id;
                });
                // 更新待下载任务数量
                this.downloadCount = this.downloadFileArray.length;
              }
            },
            cornerRadius: $r('app.integer.multiple_files_download_borderRadius_twelve'), // 弹窗边框弧度
            width: $r('app.string.multiple_files_download_list_height'), // 弹窗宽度
            cancel: () => {
              logger.info('点击关闭按钮');
            }
          });
        } else {
          // 文件已下载到本地，弹窗提示文件已存在
          promptAction.showToast({
            message: $r('app.string.multiple_files_download_history_toast_text_exist'),
            duration: 1000,
            bottom: '50%',
          })
        }
      }).catch((err: BusinessError) => {
        logger.error(TAG, `access failed with error message: ${err.message}, error code: ${err.code}`);
      });
    })
  }
}
