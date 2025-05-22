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

// [Start recovery_download_task]
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { DownloadUtil, fileName, filePath } from './downloadUtil'; // downloadUtil.ets 见下文

function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  delegate: webview.WebDownloadDelegate = new webview.WebDownloadDelegate();
  download: webview.WebDownloadItem = new webview.WebDownloadItem();
  // 用于记录失败的下载任务。
  failedData: Uint8Array = new Uint8Array();

  build() {
    Column() {
      Button('setDownloadDelegate')
        .onClick(() => {
          try {
            this.delegate.onBeforeDownload((webDownloadItem: webview.WebDownloadItem) => {
              console.log('will start a download.');
              // 传入一个下载路径，并开始下载。
              webDownloadItem.start('/data/storage/el2/base/cache/web/' + webDownloadItem.getSuggestedFileName());
            })
            this.delegate.onDownloadUpdated((webDownloadItem: webview.WebDownloadItem) => {
              console.log('download update percent complete: ' + webDownloadItem.getPercentComplete());
              this.download = webDownloadItem;
            })
            this.delegate.onDownloadFailed((webDownloadItem: webview.WebDownloadItem) => {
              console.log('download failed guid: ' + webDownloadItem.getGuid());
              // 序列化失败的下载任务到一个字节数组。
              this.failedData = webDownloadItem.serialize();
            })
            this.delegate.onDownloadFinish((webDownloadItem: webview.WebDownloadItem) => {
              console.log('download finish guid: ' + webDownloadItem.getGuid());
            })
            this.controller.setDownloadDelegate(this.delegate);
            webview.WebDownloadManager.setDownloadDelegate(this.delegate);
          } catch (error) {
            console.error(
              `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })
      Button('startDownload')
        .onClick(() => {
          try {
            // 这里指定下载地址为 https://www.example.com/，Web组件会发起一个下载任务将该页面下载下来。
            // 开发者需要替换为自己想要下载的内容的地址。
            this.controller.startDownload(resourceToString($r('app.string.web_path')));
          } catch (error) {
            console.error(
              `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })
      // 将当前的下载任务信息序列化保存，用于后续恢复下载任务。
      // 当前用例仅展示下载一个任务的场景，多任务场景请按需扩展。
      Button('record')
        .onClick(() => {
          try {
            // 保存当前下载数据到持久化文档中。
            DownloadUtil.saveDownloadInfo(DownloadUtil.uint8ArrayToStr(this.download.serialize()));
          } catch (error) {
            console.error(
              `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })
      // 从序列化的下载任务信息中，恢复下载任务。
      // 按钮触发时必须保证WebDownloadManager.setDownloadDelegate设置完成。
      Button('recovery')
        .onClick(() => {
          try {
            // 当前默认持久化文件存在，用户根据实际情况增加判断。
            let webDownloadItem =
              webview.WebDownloadItem.deserialize(
                DownloadUtil.strToUint8Array(DownloadUtil.readFileSync(filePath, fileName)));
            webview.WebDownloadManager.resumeDownload(webDownloadItem);
          } catch (error) {
            console.error(
              `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })

      Web({ src: 'www.example.com', controller: this.controller })
    }
  }
}
// [End recovery_download_task]