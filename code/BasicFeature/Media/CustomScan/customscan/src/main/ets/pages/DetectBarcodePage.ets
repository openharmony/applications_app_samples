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

import { url } from '@kit.ArkTS';
import { webview } from '@kit.ArkWeb';
import { logger } from '../common/util/Logger';
import CommonConstants from '../common/constants/CommonConstants';
import CustomScanViewModel from '../viewmodel/CustomScanViewModel';

@Component
export struct DetectBarcodePage {
  @Consume('subPageStack') subPageStack: NavPathStack;
  @Consume('customScanVM') customScanVM: CustomScanViewModel;
  @State detectResult: string = '';
  @State urlForShow: string = '';
  private webController = new webview.WebviewController();

  aboutToAppear(): void {
    const detectResult: string = this.subPageStack.getParamByIndex(this.subPageStack.size() - 1) as string;
    if (!detectResult) {
      this.detectResult = CommonConstants.DETECT_NO_RESULT;
      return;
    }

    // 解析是否url，是url直接加载网页，非url展示识别文本
    try {
      const urlObj = url.URL.parseURL(detectResult);
      this.urlForShow = urlObj.toString();
    } catch (e) {
      logger.info('[customscan]', `detectResult is not url, is: ${detectResult}`);
      this.detectResult = detectResult;
    }
  }

  aboutToDisappear(): void {
    this.customScanVM.initCustomScan();
  }

  build() {
    if (this.urlForShow) {
      Web({ src: this.urlForShow, controller: this.webController })
        .width('100%')
        .height('100%')
        .mixedMode(MixedMode.All)
        .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.BOTTOM])
        .onLoadIntercept((event) => {
          const requestUrl = event.data.getRequestUrl();
          if (!requestUrl.startsWith('http')) {
            return true;
          }

          return false;
        })
        .onErrorReceive((event) => {
          if (event) {
            logger.error('[customscan]', `errorInfo: ${event.error.getErrorInfo()} errorCode: ${event.error.getErrorCode()}`)
          }
        })
    } else {
      Text(this.detectResult)
        .height('100%')
        .alignSelf(ItemAlign.Center)
    }
  }
}
