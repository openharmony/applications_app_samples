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
import http from '@ohos.net.http';
import Logger from '../../util/Logger'
import DownloadController from '../../componets/DownloadController'
import NavigationBar from '../../componets/NavigationBar'
import emitter from '@ohos.events.emitter'
import common from '@ohos.app.ability.common'
import { ConfigType, getConfig } from '../../util/ConfigUtil'


class DownloadFile {
  fileName: string;
  fileUrl: string;
}

@Entry
@Component
struct Download {
  queryFileUrl: string = ""
  //  文件列表
  @State fileList: Array<DownloadFile> = [];

  async aboutToAppear() {
    this.queryFileUrl = await getConfig(getContext(this), ConfigType.downloadListUrl)
    this.getFileList();
  }

  startDownload() {
    let innerEvent = {
      eventId: 2,
      priority: emitter.EventPriority.HIGH
    };
    emitter.emit(innerEvent);
  }

  getFileList() {
    let httpRequest = http.createHttp();
    Logger.info("request url = " + this.queryFileUrl)
    httpRequest.request(
      this.queryFileUrl,
      {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'text/plain'
        },
        connectTimeout: 10000,
        readTimeout: 10000,
      }, (err, data) => {
      Logger.info(`error = ${JSON.stringify(err)}`)
      if (!err) {
        Logger.info(`data = ${JSON.stringify(data)}`)
        let result: string = data.result.toString()
        Logger.info(`Result = ${result}`)

        let tempFiles = result.split('\r\n')
        for (let i = 0; i < tempFiles.length; i++) {
          let splitFiles = tempFiles[i].split('//')[1].split('/')
          Logger.info(`splitFiles = ${JSON.stringify(splitFiles)}`)

          let downloadFile: DownloadFile = {
            fileName: splitFiles[splitFiles.length-1],
            fileUrl: tempFiles[i],
          }
          this.fileList.push(downloadFile)
        }
        Logger.info(`files = ${JSON.stringify(this.fileList)}`)
      } else {
        Logger.info(`error: ${JSON.stringify(err)}`)
        httpRequest.destroy()
        AlertDialog.show({
          message: $r('app.string.get_download_list_failed'),
          primaryButton: {
            value: $r('app.string.confirm'),
            action: () => {
            }
          }
        })
      }
    })
  }

  getString(id) {
    let context: common.Context = getContext(this) as common.Context;
    return context.resourceManager.getStringSync(id)
  }

  //  1、展示所有已经upload的资源
  //  2、展示所有已经下载好的资源
  //  3、点击单项item，开始下载任务，可暂停，可继续
  build() {
    Column() {
      NavigationBar({
        title: this.getString($r('app.string.download_title')),
        buttonTip: this.getString($r('app.string.download_button_tip')),
        clickCallback: () => {
          this.startDownload()
        },
        buttonEnable: true
      }
      ).margin({ top: $r('app.float.download_navigation_bar_margin') })
      List({ space: 15 }) {
        ForEach(this.fileList, (file) => {
          ListItem() {
            DownloadController({ fileName: file.fileName, downloadUrl: file.fileUrl })
              .width('100%')
              .padding({
                left: $r('app.float.download_controller_padding'),
                right: $r('app.float.download_controller_padding')
              })
              .backgroundColor($r("app.color.background_fff"))
              .border({ radius: $r('app.float.ohos_id_corner_radius_menu') })
              .height($r('app.float.download_item_height'))
          }
        })
      }
      .cachedCount(this.fileList.length)
      .layoutWeight(1)
      .divider({ strokeWidth: $r('app.float.download_divider_width'), color: $r('app.color.download_background') })
      .padding($r('app.float.ohos_id_max_padding_start'))
    }.backgroundColor($r('app.color.download_background'))

  }
}