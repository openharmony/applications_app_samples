/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import fs from '@ohos.file.fs'
import request from '@ohos.request'
import common from '@ohos.app.ability.common'
import Logger from '../util/Logger'
import { UploadFile } from '../feature/UploadFile'
import emitter from '@ohos.events.emitter'
import CostTimeCompute from '../feature/CostTimeCompute'
import { getConfig, ConfigType } from '../util/ConfigUtil'

const TAG: string = '[UploadController]'

//控制下载任务
//展示下载进度，展示下载控制器
@Preview
@Component
export default struct UploadController {
  @State imageUrl: string = "";
  @State isDownloading: boolean = false;
  @State isError: boolean = false;
  @State errorMessage: string = "";
  @State @Watch('onCompleteChanged') isCompleted: boolean = false;
  @State progress: number = 0;
  @State total: number = 1;
  @Link isCompletedArr: Array<boolean>
  uploadUrl: string = ""
  innerEvent = {
    eventId: 1
  };
  uploadTask: request.UploadTask;

  //  剩余时间计算
  @State costTimeStr: string = "1s";
  @State lastTimeStr: string = "";
  costTimeCompute: CostTimeCompute = null;

  onCompleteChanged(isCompleted: boolean) {
    if (isCompleted) {
      Logger.info(TAG, "上传任务，onCompleteChanged（）；imageUrl=" + this.imageUrl)
      if (this.isCompletedArr == null) {
        this.isCompletedArr = [];
      }
      let i = this.isCompletedArr.push(true)
    }
  }

  async aboutToAppear() {
    this.uploadUrl = await getConfig(getContext(this), ConfigType.uploadUrl)
    Logger.info(TAG, 'register publish event!')
    emitter.on(this.innerEvent, (eventData) => {
      Logger.info(TAG, `receive publish event!=${JSON.stringify(eventData)}`)
      this.startUpload(this.imageUrl);
    });
    //定义计算器
    this.costTimeCompute = new CostTimeCompute(
      (str) => {
        this.lastTimeStr = str;
      },
      () => {
        return this.progress;
      },
      () => {
        return this.total;
      },
      (str) => {
        this.costTimeStr = str;
      }
      , true
    );
  }

  aboutToDisappear() {
    emitter.off(this.innerEvent.eventId);
    if (this.isDownloading) {
      this.cancelUpload();
    }
  }

  async startUpload(url: string): Promise<void> {
    if (this.isDownloading || this.isCompleted) {
      return;
    }
    this.isError = false;
    this.isDownloading = true;
    this.copyImage(url)
    this.costTimeCompute.startCostTime();
  }

  async cancelUpload() {
    if (this.uploadTask == null || !this.isDownloading) {
      return;
    }
    this.removeListener();
    await this.uploadTask.delete();
    this.uploadTask = null;

    this.isDownloading = false;
    this.progress = 0;
    this.total = 1;
    this.costTimeCompute.cancelCostTime();
  }

  async restartUpload() {
    await this.cancelUpload();
    this.startUpload(this.imageUrl);
  }

  async copyImage(url: string): Promise<void> {
    Logger.info(TAG, `copyImage url = ${url}`)
    // 将选中图片存入沙箱路径
    let id = url.slice(url.lastIndexOf('/')+1);
    Logger.info(TAG, `this.id = ${id}`)
    let mContext: common.Context = getContext(this) as common.Context
    let media = mediaLibrary.getMediaLibrary(mContext)
    Logger.info(TAG, `this.media = ${JSON.stringify(media)}`)

    let file = fs.openSync(url, fs.OpenMode.READ_WRITE);
    let fd = file.fd;
    Logger.info(TAG, 'file fd: ' + file);

    // upload可访问的沙箱路径：data/app/el2/100/base/com.example.myapplication/haps/entry/cache/
    let imagePath = `${mContext.filesDir.split('files')[0]}cache/${new Date().getTime().toString()}.jpg`
    Logger.info(TAG, `this.imagePath = ${JSON.stringify(imagePath)}`)
    try {
      fs.copyFileSync(fd, imagePath)
      await this.isUploadImage(imagePath)
    } catch (err) {
      Logger.info(TAG, `this.err = ${err}`)
    }
  }

  async isUploadImage(imagePath: string): Promise<void> {
    // 转成可上传的图片格式进行上传
    let file = new UploadFile()
    file.uri = `internal://cache/${imagePath.split('cache/')[1]}`
    Logger.info(TAG, `file.uri = ${file.uri}`)
    file.filename = imagePath.split('cache/')[1]
    Logger.info(TAG, `file.filename = ${file.filename}`)
    file.name = imagePath.split('cache/')[1].split('.')[0]
    Logger.info(TAG, `file.name = ${file.name}`)
    file.type = imagePath.split('.')[1]
    Logger.info(TAG, `file.type = ${file.type}`)
    Logger.debug("upload path=" + this.uploadUrl);
    let uploadConfig = {
      url: this.uploadUrl,
      header: { key1: 'value1', key2: 'value2' },
      method: 'POST',
      files: [{ filename: file.filename, name: file.name, uri: file.uri, type: file.type }],
      data: [{ name: 'name123', value: '123' }],
    }
    Logger.info(TAG, `uploadConfig = ${JSON.stringify(uploadConfig)}`)
    let uploadContext: common.BaseContext = getContext(this) as common.BaseContext
    this.uploadTask = await request.uploadFile(uploadContext, uploadConfig)
    this.addListener();
  }

  addListener() {
    if (this.uploadTask == null) {
      return;
    }
    this.uploadTask.on('complete', async (taskStates) => {
      await this.uploadTask.delete()
      Logger.info(TAG, `uploadSuccess`)
      this.isDownloading = false;
      this.isCompleted = true;
      this.costTimeCompute.cancelCostTime();
    })
    this.uploadTask.on('progress', (uploadSize: number, uploadTotal: number) => {
      this.progress = uploadSize;
      this.total = uploadTotal;
    })
    this.uploadTask.on('fail', (err: Array<request.TaskState>) => {
      this.isDownloading = false;
      this.isError = true;
      this.costTimeCompute.cancelCostTime();
      this.progress = 0;
      try {
        this.errorMessage = err.pop().message;
      } catch (err) {
        Logger.error('获取err message报错:' + err)
      }
    })
  }

  removeListener() {
    if (this.uploadTask == null) {
      return;
    }
    this.uploadTask.off("complete");
    this.uploadTask.off("progress");
    this.uploadTask.off("fail");
  }

  getTimeLastTip() {
    let context: common.Context = getContext(this) as common.Context;
    let lastTime = context.resourceManager.getStringSync($r('app.string.tip_last_time2'));
    let computingStr = context.resourceManager.getStringSync($r('app.string.tip_computing2'));
    return lastTime + ((this.lastTimeStr != null && this.lastTimeStr.length > 0) ? this.lastTimeStr : computingStr);
  }

  getCostTimeStr() {
    let context: common.Context = getContext(this) as common.Context;
    let costTimeTip = context.resourceManager.getStringSync($r("app.string.tip_cost_time"));
    return costTimeTip + this.costTimeStr
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      RelativeContainer() {
        //背景图
        Stack() {
          if (!this.isCompleted) {
            //蒙层和按钮
            Stack({ alignContent: Alignment.Center }) {
              if (this.isError) {
                //失败状态
                RelativeContainer() {
                  Image($r('app.media.ic_public_reset'))
                    .fillColor($r('app.color.progress_color'))
                    .width('45%')
                    .height('45%')
                    .alignRules({
                      center: { anchor: "__container__", align: VerticalAlign.Center },
                      middle: { anchor: "__container__", align: HorizontalAlign.Center }
                    })
                    .id('restart')
                    .onClick(() => {
                      this.restartUpload();
                    })

                  Text($r('app.string.upload_error_message'))
                    .fontSize($r('app.float.upload_controller_font_size'))
                    .fontColor($r('app.color.upload_error_color'))
                    .margin({ top: $r('app.float.upload_time_margin_top') })
                    .alignRules({
                      top: { anchor: "restart", align: VerticalAlign.Bottom },
                      middle: { anchor: "__container__", align: HorizontalAlign.Center }
                    })
                    .id('error')
                }.width('100%')
                .height('100%')
              } else if (this.isDownloading) {
                //下载中状态
                RelativeContainer() {
                  Progress({ value: this.progress, total: this.total, type: ProgressType.Ring })
                    .width('45%')
                    .height('45%')
                    .style({
                      strokeWidth: $r('app.float.progress_stroke_width')
                    })
                    .backgroundColor($r('app.color.progress_background'))
                    .color($r('app.color.progress_color'))
                    .alignRules({
                      center: { anchor: "__container__", align: VerticalAlign.Center },
                      middle: { anchor: "__container__", align: HorizontalAlign.Center }
                    })
                    .id('progress')

                  Text(this.getTimeLastTip())
                    .fontSize($r('app.float.upload_controller_font_size'))
                    .fontColor($r('app.color.color_cover'))
                    .margin({ top: $r('app.float.upload_time_margin_top') })
                    .alignRules({
                      top: { anchor: "progress", align: VerticalAlign.Bottom },
                      middle: { anchor: "__container__", align: HorizontalAlign.Center }
                    })
                    .id('time')
                }.width('100%')
                .height('100%')
              } else {
                //准备状态
                Image($r('app.media.ic_public_upload'))
                  .width('50%')
                  .aspectRatio(1)
                  .fillColor($r('app.color.color_cover'))
                  .onClick(() => {
                    this.startUpload(this.imageUrl)
                  })
              }
            }
            .backgroundColor($r('app.color.color_blend'))
            .width('100%')
            .height('100%')
          }
        }
        .alignRules({
          center: { anchor: "__container__", align: VerticalAlign.Center },
          middle: { anchor: "__container__", align: HorizontalAlign.Center }
        })
        .backgroundImage(this.imageUrl, ImageRepeat.NoRepeat)
        .backgroundImageSize({ width: '100%', height: '100%' })
        .width('100%')
        .aspectRatio(1)
        .margin($r('app.float.add_picture_margin_background'))
        .id('background')

        //删除按钮
        if (this.isDownloading) {
          Stack({ alignContent: Alignment.TopEnd }) {
            Image($r('app.media.ic_public_list_deleted'))
              .height($r('app.float.add_picture_cancel_ic_width'))
              .width($r('app.float.add_picture_cancel_ic_width'))
          }
          .width($r('app.float.add_picture_cancel_click_area'))
          .height($r('app.float.add_picture_cancel_click_area'))
          .id('ic_deleted')
          .alignRules({
            top: { anchor: "__container__", align: VerticalAlign.Top },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .onClick(() => {
            this.cancelUpload();
          })
        }
      }
      .height('100%')
      .width('100%')
    }
    .width('100%')
    .aspectRatio(1)
  }
}