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
import common from '@ohos.app.ability.common'
import request from '@ohos.request';
import fs from '@ohos.file.fs';
import emitter from '@ohos.events.emitter'
import CostTimeCompute from '../feature/CostTimeCompute'
import Logger from '../util/Logger'

@Preview
@Component
export default struct DownloadController {
  @StorageProp('currentBreakpoint') curBp: string = 'sm'
  fileName: string = ""
  downloadUrl: string = "";
  downloadTask: request.DownloadTask = null;
  downloadPath: string = null;
  @State isDownloading: boolean = false;
  @State isCompleted: boolean = false;
  @State isPausing: boolean = false;
  @State progress: number = 0;
  @State total: number = 1;
  @State speed: string = "0B/s";
  //  剩余时间计算
  @State lastTimeStr: string = "";
  @State isError: boolean = false;
  costTimeCompute: CostTimeCompute = null;

  aboutToAppear() {
    Logger.debug("register fileName = " + this.fileName);
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
      null,
      false,
      (str) => {
        this.speed = str;
      }
    );
    this.getDownloadPath();
    fs.access(this.downloadPath)
      .then(isExist => {
        if (isExist) {
          this.isCompleted = true;
        }
        //下载监听，在文件检测之后，再注册
        this.addEventListener();
      }).catch(err => {
      Logger.error(err)
    })
  }

  addEventListener() {
    emitter.on({ eventId: 2 }, () => {
      this.startDownload();
    })
  }

  aboutToDisappear() {
    this.costTimeCompute.cancelCostTime();
    this.cancel();
  }

  getDownloadPath() {
    if (this.downloadPath == null) {
      let context: common.Context = getContext(this) as common.Context;
      this.downloadPath = context.cacheDir + "/" + this.fileName;
      Logger.debug("download file path =" + this.downloadPath)
    }
  }

  restart() {
    this.cancel(true);
  }

  async startDownload() {
    if (this.isDownloading || this.isCompleted) {
      return;
    }
    this.isError = false;
    let context: common.Context = getContext(this) as common.Context;
    this.getDownloadPath();
    try {
      this.downloadTask = await request.downloadFile(context, { url: this.downloadUrl, filePath: this.downloadPath })
      this.isDownloading = true;
      this.addListener();

      this.costTimeCompute.startCostTime();
    } catch (err) {
      Logger.debug("start download failed,err = " + err)
      this.onFail();
    }
  }

  pauseOrPlay() {
    if (this.downloadTask == null || !this.isDownloading) {
      return;
    }
    if (this.isPausing) {
      this.downloadTask.restore(() => {
        this.isPausing = false;
      });
      this.costTimeCompute.startCostTime();
    } else {
      this.downloadTask.suspend(() => {
        this.isPausing = true;
      })
      this.costTimeCompute.pauseCostTime();
    }
  }

  cancel(restart: boolean = false) {
    if (this.downloadTask == null || this.isCompleted) {
      return;
    }
    this.isPausing = false;
    this.isError = false;
    this.downloadTask.delete(() => {
      this.costTimeCompute.cancelCostTime();
      let isExist = fs.accessSync(this.downloadPath);
      if (isExist) {
        fs.unlink(this.downloadPath).then(() => {
          this.reset(restart);
        })
      } else {
        this.reset(restart);
      }
    })
  }

  reset(restart: boolean) {
    this.isDownloading = false;
    this.progress = 0;
    this.total = 1;
    if (restart) {
      setTimeout(() => this.startDownload(), 600);
    }
  }

  addListener() {
    if (this.downloadTask == null) {
      return;
    }
    this.downloadTask.on("progress", (receivedSize, totalSize) => {
      this.progress = receivedSize;
      this.total = totalSize;
    })
    this.downloadTask.on('complete', () => {
      this.isDownloading = false;
      this.isCompleted = true;
      this.costTimeCompute.cancelCostTime();
    })
    this.downloadTask.on('fail', err => {
      Logger.error("下载失败:" + err)
      this.onFail();
    })
  }

  private onFail() {
    this.cancel();
    this.isError = true;
  }

  getTimeLastTip() {
    let context: common.Context = getContext(this) as common.Context;
    let lastTime = context.resourceManager.getStringSync($r('app.string.tip_last_time'));
    let computingStr = context.resourceManager.getStringSync($r('app.string.tip_computing'));
    return lastTime + ((this.lastTimeStr != null && this.lastTimeStr.length > 0) ? this.lastTimeStr : computingStr);
  }

  getProgressPercent(): string {
    switch (this.curBp) {
      case 'lg':
        return "80%";
      case 'md':
      case 'xs':
      case 'sm':
      default:
        return "65%"
    }
  }

  build() {
    if (this.isDownloading || this.isError || this.isCompleted) {
      Row() {
        Column({ space: 10 }) {
          Text(this.fileName)
            .fontSize($r('app.float.download_file_name_font_size'))
          if (!this.isCompleted) {
            Progress({ value: this.progress, total: this.total, type: ProgressType.Capsule })
              .height($r('app.float.download_progress_height'))
              .width('100%')
              .align(Alignment.Center)
          }
          if (this.isPausing) {
            Text($r("app.string.tip_paused"))
              .fontSize($r('app.float.download_tip_font_size'))
              .fontColor($r('app.color.download_font_color'))
          } else {
            if (this.isError || this.isCompleted) {
              Text(this.isCompleted ? $r('app.string.download_success') : $r('app.string.download_fail'))
                .fontColor(this.isCompleted ? $r('app.color.download_font_color') : $r('app.color.upload_error_color'))
                .fontSize($r('app.float.download_tip_font_size'))
            } else {
              Row() {
                Text(this.speed)
                  .fontColor($r('app.color.download_font_color'))
                  .fontSize($r('app.float.download_tip_font_size'))
                Blank()
                Text(this.getTimeLastTip())
                  .fontColor($r('app.color.download_font_color'))
                  .fontSize($r('app.float.download_tip_font_size'))
              }.width('100%')
            }
          }
        }
        .width(this.getProgressPercent())
        .alignItems(HorizontalAlign.Start)

        Blank()
        if (!this.isCompleted) {
          Row({ space: 15 }) {
            if (this.isError) {
              Image($r("app.media.ic_public_reset"))
                .width($r('app.float.download_icon_size'))
                .aspectRatio(1)
                .onClick(() => {
                  this.restart();
                })
            } else {
              Image(this.isPausing ? $r("app.media.ic_public_play_norm") : $r("app.media.ic_public_pause_norm"))
                .width($r('app.float.download_icon_size'))
                .aspectRatio(1)
                .onClick(() => {
                  this.pauseOrPlay();
                })
            }
            Image($r("app.media.ic_public_close"))
              .width($r('app.float.download_icon_size'))
              .aspectRatio(1)
              .onClick(() => {
                this.cancel();
              })
          }
        }
      }.width("100%")
      .height('100%')
      .alignItems(VerticalAlign.Center)
    } else {
      Row() {
        Text(this.fileName)
          .fontSize($r('app.float.download_file_name_font_size'))
        Blank()
        Image($r("app.media.ic_public_download"))
          .onClick(() => {
            this.startDownload()
          })
          .width($r('app.float.download_icon_size'))
          .aspectRatio(1)
      }
      .width('100%')
      .height('100%')
      .alignItems(VerticalAlign.Center)
    }
  }
}