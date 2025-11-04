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

// [Start download_delegate]
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  delegate: webview.WebDownloadDelegate = new webview.WebDownloadDelegate();
  @State myText: string = 'download';

  build() {
    Column() {
      Text(this.myText)
      Button('setDownloadDelegate')
        .onClick(() => {
          try {
            this.delegate.onBeforeDownload((webDownloadItem: webview.WebDownloadItem) => {
              console.info('will start a download.');
              // 传入一个下载路径，并开始下载。
              // 如果传入一个不存在的路径，则会下载到默认/data/storage/el2/base/cache/web/目录。
              webDownloadItem.start('/data/storage/el2/base/cache/web/' + webDownloadItem.getSuggestedFileName());
            })
            this.delegate.onDownloadUpdated((webDownloadItem: webview.WebDownloadItem) => {
              // 下载任务的唯一标识。
              console.info('download update guid: ' + webDownloadItem.getGuid());
              // 下载的进度。
              console.info('download update percent complete: ' + webDownloadItem.getPercentComplete());
              // 当前的下载速度。
              console.info('download update speed: ' + webDownloadItem.getCurrentSpeed());
            })
            this.delegate.onDownloadFailed((webDownloadItem: webview.WebDownloadItem) => {
              console.error('download failed guid: ' + webDownloadItem.getGuid());
              // 下载任务失败的错误码。
              console.error('download failed last error code: ' + webDownloadItem.getLastErrorCode());
            })
            this.delegate.onDownloadFinish((webDownloadItem: webview.WebDownloadItem) => {
              console.info('download finish guid: ' + webDownloadItem.getGuid());
              this.myText = 'download finish';
            })
            this.controller.setDownloadDelegate(this.delegate);
          } catch (error) {
            console.error(
              `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })
      Web({ src: $rawfile('index.html'), controller: this.controller })
    }
  }
}
// [End download_delegate]
