/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { cacheDownload, BusinessError } from '@kit.BasicServicesKit';
import { logger } from '../utils/Logger';
import { TOAST_BOTTOM, DEFAULT_TEST_URL } from '../utils/Constants';

const TAG: string = 'CacheDownloadTimeout';

@Entry
@Component
struct CacheDownloadTimeout {
  @State downloadUrl: string = DEFAULT_TEST_URL;
  @State networkCheckTimeout: number = 20;
  @State httpTotalTimeout: number = 60;
  @State downloadStatus: string = 'Ready';
  @State errorMessage: string = '';

  private successCallback: () => void = () => {};
  private errorCallback: (error: cacheDownload.DownloadError) => void = () => {};

  aboutToAppear(): void {
    this.registerCallbacks();
  }

  aboutToDisappear(): void {
    this.unregisterCallbacks();
  }

  build() {
    Navigation() {
      Scroll() {
        Column({ space: 16 }) {
          // URL 输入区域
          Column({ space: 8 }) {
            Text($r('app.string.download_url'))
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
            TextInput({ text: this.downloadUrl })
              .width('100%')
              .height(40)
              .onChange((value: string) => {
                this.downloadUrl = value;
              })
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(12)

          // TimeoutOptions 参数配置区域
          Column({ space: 12 }) {
            Text($r('app.string.timeout_config'))
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
            
            // networkCheckTimeout 配置
            Row({ space: 12 }) {
              Text($r('app.string.network_check_timeout'))
                .fontSize(14)
                .width(120)
              Slider({
                value: this.networkCheckTimeout,
                min: 0,
                max: 20,
                step: 1
              })
                .width(150)
                .blockColor($r('app.color.slider_block'))
                .trackColor($r('app.color.slider_track'))
                .onChange((value: number) => {
                  this.networkCheckTimeout = Math.round(value);
                })
              Text(`${this.networkCheckTimeout}s`)
                .fontSize(14)
                .width(50)
                .textAlign(TextAlign.Center)
            }
            .width('100%')
            
            Text($r('app.string.network_check_timeout_hint'))
              .fontSize(12)
              .fontColor($r('app.color.text_hint'))
              .width('100%')

            // httpTotalTimeout 配置
            Row({ space: 12 }) {
              Text($r('app.string.http_total_timeout'))
                .fontSize(14)
                .width(120)
              Slider({
                value: this.httpTotalTimeout,
                min: 1,
                max: 120,
                step: 1
              })
                .width(150)
                .blockColor($r('app.color.slider_block'))
                .trackColor($r('app.color.slider_track'))
                .onChange((value: number) => {
                  this.httpTotalTimeout = Math.round(value);
                })
              Text(`${this.httpTotalTimeout}s`)
                .fontSize(14)
                .width(50)
                .textAlign(TextAlign.Center)
            }
            .width('100%')
            
            Text($r('app.string.http_total_timeout_hint'))
              .fontSize(12)
              .fontColor($r('app.color.text_hint'))
              .width('100%')
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(12)

          // 下载状态显示
          Column({ space: 8 }) {
            Text($r('app.string.download_status'))
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
            Text(this.downloadStatus)
              .fontSize(14)
              .fontColor(this.downloadStatus === 'Success' ? Color.Green : 
                         this.downloadStatus === 'Failed' ? Color.Red : $r('app.color.text_normal'))
            if (this.errorMessage !== '') {
              Text(this.errorMessage)
                .fontSize(12)
                .fontColor(Color.Red)
                .maxLines(3)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(12)

          // 操作按钮
          Button($r('app.string.start_download'))
            .id('timeout_start_download')
            .width('100%')
            .height(45)
            .type(ButtonType.Capsule)
            .backgroundColor($r('app.color.button_primary'))
            .onClick(() => {
              this.startCacheDownloadWithTimeout();
            })

          Button($r('app.string.cancel_download'))
            .id('timeout_cancel_download')
            .width('100%')
            .height(45)
            .type(ButtonType.Capsule)
            .backgroundColor($r('app.color.button_secondary'))
            .onClick(() => {
              this.cancelCacheDownload();
            })
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 12 })
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Auto)
    }
    .width('100%')
    .height('100%')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.page_background'))
    .title($r('app.string.cache_download_timeout'))
  }

  private registerCallbacks(): void {
    this.successCallback = () => {
      logger.info(TAG, 'Cache download succeeded');
      this.downloadStatus = 'Success';
      this.showToast($r('app.string.download_success'));
    };

    this.errorCallback = (error: cacheDownload.DownloadError) => {
      logger.error(TAG, `Cache download failed, errorCode: ${error.errorCode}, message: ${error.message}`);
      this.downloadStatus = 'Failed';
      this.errorMessage = `Error: ${error.errorCode}, ${error.message}`;
      this.showToast($r('app.string.download_failed'));
    };

    cacheDownload.onDownloadSuccess(this.downloadUrl, this.successCallback);
    cacheDownload.onDownloadError(this.downloadUrl, this.errorCallback);
  }

  private unregisterCallbacks(): void {
    cacheDownload.offDownloadSuccess(this.downloadUrl, this.successCallback);
    cacheDownload.offDownloadError(this.downloadUrl, this.errorCallback);
  }

  // [Start cache_download_with_timeout]
  startCacheDownloadWithTimeout(): void {
    this.downloadStatus = 'Downloading';
    this.errorMessage = '';
    logger.info(TAG, `Starting cache download with timeout, url: ${this.downloadUrl}`);
    logger.info(TAG, `networkCheckTimeout: ${this.networkCheckTimeout}s, httpTotalTimeout: ${this.httpTotalTimeout}s`);

    // 如果URL发生变化，需要重新注册回调
    this.unregisterCallbacks();
    this.registerCallbacks();

    try {
      let timeoutOptions: cacheDownload.TimeoutOptions = {
        networkCheckTimeout: this.networkCheckTimeout,
        httpTotalTimeout: this.httpTotalTimeout
      };

      let options: cacheDownload.CacheDownloadOptions = {
        timeout: timeoutOptions
      };

      cacheDownload.download(this.downloadUrl, options);
      logger.info(TAG, 'Cache download task started');
    } catch (err) {
      let error = err as BusinessError;
      logger.error(TAG, `Failed to start cache download, code: ${error.code}, message: ${error.message}`);
      this.downloadStatus = 'Failed';
      this.errorMessage = `BusinessError: ${error.code}, ${error.message}`;
    }
  }
  // [End cache_download_with_timeout]

  cancelCacheDownload(): void {
    try {
      cacheDownload.cancel(this.downloadUrl);
      logger.info(TAG, 'Cache download task cancelled');
      this.downloadStatus = 'Cancelled';
      this.showToast($r('app.string.download_cancelled'));
    } catch (err) {
      let error = err as BusinessError;
      logger.error(TAG, `Failed to cancel, code: ${error.code}, message: ${error.message}`);
    }
  }

  showToast(message: Resource | string): void {
    try {
      this.getUIContext().getPromptAction().showToast({
        message: message,
        bottom: TOAST_BOTTOM
      });
    } catch (error) {
      logger.error(TAG, `Failed to show toast: ${JSON.stringify(error)}`);
    }
  }
}