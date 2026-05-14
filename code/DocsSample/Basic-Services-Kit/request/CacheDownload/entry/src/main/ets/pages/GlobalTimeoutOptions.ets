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

const TAG: string = 'GlobalTimeoutOptions';

@Entry
@Component
struct GlobalTimeoutOptions {
  @State globalNetworkCheckTimeout: number = 20;
  @State globalHttpTotalTimeout: number = 60;
  @State downloadUrl: string = DEFAULT_TEST_URL;
  @State globalConfigStatus: string = 'Not Set';
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
          // 全局配置区域
          Column({ space: 12 }) {
            Text($r('app.string.global_timeout_config'))
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
            
            // networkCheckTimeout 配置
            Row({ space: 12 }) {
              Text($r('app.string.global_network_check_timeout'))
                .fontSize(14)
                .width(120)
              Slider({
                value: this.globalNetworkCheckTimeout,
                min: 0,
                max: 20,
                step: 1
              })
                .width(150)
                .blockColor($r('app.color.slider_block'))
                .trackColor($r('app.color.slider_track'))
                .onChange((value: number) => {
                  this.globalNetworkCheckTimeout = Math.round(value);
                })
              Text(`${this.globalNetworkCheckTimeout}s`)
                .fontSize(14)
                .width(50)
                .textAlign(TextAlign.Center)
            }
            .width('100%')

            // httpTotalTimeout 配置
            Row({ space: 12 }) {
              Text($r('app.string.global_http_total_timeout'))
                .fontSize(14)
                .width(120)
              Slider({
                value: this.globalHttpTotalTimeout,
                min: 1,
                max: 120,
                step: 1
              })
                .width(150)
                .blockColor($r('app.color.slider_block'))
                .trackColor($r('app.color.slider_track'))
                .onChange((value: number) => {
                  this.globalHttpTotalTimeout = Math.round(value);
                })
              Text(`${this.globalHttpTotalTimeout}s`)
                .fontSize(14)
                .width(50)
                .textAlign(TextAlign.Center)
            }
            .width('100%')
            
            Row({ space: 4 }) {
              Text($r('app.string.current_global_status'))
                .fontSize(14)
              Text(':')
                .fontSize(14)
              Text(this.globalConfigStatus)
                .fontSize(14)
                .fontColor($r('app.color.text_normal'))
            }
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(12)

          // 设置全局配置按钮
          Button($r('app.string.set_global_timeout'))
            .id('set_global_timeout')
            .width('100%')
            .height(45)
            .type(ButtonType.Capsule)
            .backgroundColor($r('app.color.button_primary'))
            .onClick(() => {
              this.setGlobalTimeoutOptions();
            })

          // 单任务下载测试区域
          Column({ space: 8 }) {
            Text($r('app.string.test_download'))
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
            
            Text($r('app.string.test_download_hint'))
              .fontSize(12)
              .fontColor($r('app.color.text_hint'))
            
            TextInput({ text: this.downloadUrl })
              .width('100%')
              .height(40)
              .onChange((value: string) => {
                this.downloadUrl = value;
              })
            
            Row({ space: 4 }) {
              Text($r('app.string.download_status'))
                .fontSize(14)
              Text(':')
                .fontSize(14)
              Text(this.downloadStatus)
                .fontSize(14)
                .fontColor(this.downloadStatus === 'Success' ? Color.Green : 
                           this.downloadStatus === 'Failed' ? Color.Red : $r('app.color.text_normal'))
            }
            
            if (this.errorMessage !== '') {
              Text(this.errorMessage)
                .fontSize(12)
                .fontColor(Color.Red)
            }
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(12)

          // 测试下载按钮
          Row({ space: 12 }) {
            Button($r('app.string.start_test_download'))
              .id('global_timeout_start_test_download')
              .width('45%')
              .height(45)
              .type(ButtonType.Capsule)
              .backgroundColor($r('app.color.button_test'))
              .onClick(() => {
                this.startTestDownload();
              })

            Button($r('app.string.cancel_download'))
              .id('global_timeout_cancel_download')
              .width('45%')
              .height(45)
              .type(ButtonType.Capsule)
              .backgroundColor($r('app.color.button_secondary'))
              .onClick(() => {
                this.cancelTestDownload();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
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
    .title($r('app.string.global_timeout_options_title'))
  }

  private registerCallbacks(): void {
    this.successCallback = () => {
      logger.info(TAG, 'Test download succeeded');
      this.downloadStatus = 'Success';
      this.showToast($r('app.string.download_success'));
    };

    this.errorCallback = (error: cacheDownload.DownloadError) => {
      logger.error(TAG, `Test download failed, errorCode: ${error.errorCode}, message: ${error.message}`);
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

  // [Start set_global_timeout_options]
  setGlobalTimeoutOptions(): void {
    logger.info(TAG, `Setting global timeout options`);
    logger.info(TAG, `networkCheckTimeout: ${this.globalNetworkCheckTimeout}s, httpTotalTimeout: ${this.globalHttpTotalTimeout}s`);

    try {
      let globalTimeoutOptions: cacheDownload.TimeoutOptions = {
        networkCheckTimeout: this.globalNetworkCheckTimeout,
        httpTotalTimeout: this.globalHttpTotalTimeout
      };

      // 调用 setGlobalTimeoutOptions 设置全局超时配置
      // 该配置适用于所有未指定任务级 timeout 的缓存下载任务
      cacheDownload.setGlobalTimeoutOptions(globalTimeoutOptions);
      
      this.globalConfigStatus = `networkCheckTimeout=${this.globalNetworkCheckTimeout}s, httpTotalTimeout=${this.globalHttpTotalTimeout}s`;
      logger.info(TAG, 'Global timeout options set successfully');
      this.showToast($r('app.string.global_config_success'));
    } catch (err) {
      let error = err as BusinessError;
      logger.error(TAG, `Failed to set global timeout options, code: ${error.code}, message: ${error.message}`);
      this.globalConfigStatus = 'Failed';
      this.showToast($r('app.string.global_config_failed'));
    }
  }
  // [End set_global_timeout_options]

  startTestDownload(): void {
    this.downloadStatus = 'Downloading';
    this.errorMessage = '';
    logger.info(TAG, `Starting test download with global timeout config, url: ${this.downloadUrl}`);

    // 如果URL发生变化，需要重新注册回调
    this.unregisterCallbacks();
    this.registerCallbacks();

    try {
      let options: cacheDownload.CacheDownloadOptions = {};

      cacheDownload.download(this.downloadUrl, options);
      logger.info(TAG, 'Test download task started with global timeout config');
    } catch (err) {
      let error = err as BusinessError;
      logger.error(TAG, `Failed to start test download, code: ${error.code}, message: ${error.message}`);
      this.downloadStatus = 'Failed';
      this.errorMessage = `BusinessError: ${error.code}, ${error.message}`;
    }
  }

  cancelTestDownload(): void {
    try {
      cacheDownload.cancel(this.downloadUrl);
      logger.info(TAG, 'Test download cancelled');
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