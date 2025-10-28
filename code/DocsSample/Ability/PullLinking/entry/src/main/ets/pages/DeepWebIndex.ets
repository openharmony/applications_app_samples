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
// [Start quick_start0]
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
// [StartExclude  quick_start0]
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN_NUMBER = 0xF811;
const TAG  = '[Sample_PullLinking]';
// [EndExclude  quick_start0]
@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Web({ src: $rawfile('index.html'), controller: this.controller })
        .onLoadIntercept((event) => {
          const url: string = event.data.getRequestUrl();
          if (url === 'link://www.example.com') {
            (this.getUIContext().getHostContext() as common.UIAbilityContext).openLink(url)
              .then(() => {
                hilog.info(DOMAIN_NUMBER, TAG, 'openLink success.');
              }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG,`openLink failed, err: ${JSON.stringify(err)}.`);
            });
            return true;
          }
          // 返回true表示阻止此次加载，否则允许此次加载
          return false;
        })
    }
  }
}
// [End quick_start0]