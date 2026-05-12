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

const TAG: string = 'CacheDownloadRetry';

@Entry
@Component
struct CacheDownloadRetry {
  @State downloadUrl: string = DEFAULT_TEST_URL;
  @State maxRetryCount: number = 1;
  @State downloadStatus: string = 'Ready';
  @State errorMessage: string = '';

  // 存储回调函数引用，用于页面退出时注销
  private successCallback: () => void = () => {};
  private errorCallback: (error: cacheDownload.DownloadError) => void = () => {};

  aboutToAppear(): void {
    // 页面加载时注册回调监听
    this.registerCallbacks();
  }

  aboutToDisappear(): void {
    // 页面退出时注销回调监听
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

          // RetryOptions 参数配置区域
          Column({ space: 8 }) {
            Text($r('app.string.retry_config'))
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
            
            Row({ space: 12 }) {
              Text($r('app.string.max_retry_count'))
                .fontSize(14)
                .width(120)
              Slider({
                value: this.maxRetryCount,
                min: 0,
                max: 10,
                step: 1
              })
                .width(150)
                .blockColor($r('app.color.slider_block'))
                .trackColor($r('app.color.slider_track'))
                .onChange((value: number) => {
                  this.maxRetryCount = Math.round(value);
                })
              Text(`${this.maxRetryCount}`)
                .fontSize(14)
                .width(40)
                .textAlign(TextAlign.Center)
            }
            .width('100%')
            
            Text($r('app.string.max_retry_hint'))
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
            .id('retry_start_download')
            .width('100%')
            .height(45)
            .type(ButtonType.Capsule)
            .backgroundColor($r('app.color.button_primary'))
            .onClick(() => {
              this.startCacheDownloadWithRetry();
            })

          Button($r('app.string.cancel_download'))
            .id('retry_cancel_download')
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
    .title($r('app.string.cache_download_retry'))
  }

  // [Start cache_download_register_callbacks]
  // 注册回调监听（页面生命周期内只注册一次）
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

    // 使用当前URL注册回调（初始URL）
    cacheDownload.onDownloadSuccess(this.downloadUrl, this.successCallback);
    cacheDownload.onDownloadError(this.downloadUrl, this.errorCallback);
  }
  // [End cache_download_register_callbacks]

  // [Start cache_download_unregister_callbacks]
  // 注销回调监听
  private unregisterCallbacks(): void {
    cacheDownload.offDownloadSuccess(this.downloadUrl, this.successCallback);
    cacheDownload.offDownloadError(this.downloadUrl, this.errorCallback);
  }
  // [End cache_download_unregister_callbacks]

  // [Start cache_download_with_retry]
  startCacheDownloadWithRetry(): void {
    this.downloadStatus = 'Downloading';
    this.errorMessage = '';
    logger.info(TAG, `Starting cache download with retry, url: ${this.downloadUrl}, maxRetryCount: ${this.maxRetryCount}`);

    // 如果URL发生变化，需要重新注册回调
    this.unregisterCallbacks();
    this.registerCallbacks();

    try {
      // 配置 RetryOptions - API 26 新增参数
      let retryOptions: cacheDownload.RetryOptions = {
        maxRetryCount: this.maxRetryCount  // 最大重试次数，范围0-10，默认值1
      };

      // 配置 CacheDownloadOptions，包含 retry 参数
      let options: cacheDownload.CacheDownloadOptions = {
        retry: retryOptions
      };

      // 启动缓存下载任务
      cacheDownload.download(this.downloadUrl, options);
      logger.info(TAG, 'Cache download task started');
    } catch (err) {
      let error = err as BusinessError;
      logger.error(TAG, `Failed to start cache download, code: ${error.code}, message: ${error.message}`);
      this.downloadStatus = 'Failed';
      this.errorMessage = `BusinessError: ${error.code}, ${error.message}`;
    }
  }
  // [End cache_download_with_retry]

  // [Start cache_download_cancel]
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
  // [End cache_download_cancel]

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