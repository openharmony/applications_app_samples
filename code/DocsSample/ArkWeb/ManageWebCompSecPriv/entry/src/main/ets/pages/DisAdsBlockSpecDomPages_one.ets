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
// [Start turn_off_ad_filtering_for_specific_domain_pages]
import { webview } from '@kit.ArkWeb';

// [StartExclude turn_off_ad_filtering_for_specific_domain_pages]
function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}
// [EndExclude turn_off_ad_filtering_for_specific_domain_pages]
@Entry
@Component
struct WebComponent {
  mainUrl: string = resourceToString($r('app.string.web_path'));
  textInputController: TextInputController = new TextInputController();
  controller: webview.WebviewController = new webview.WebviewController();

  @State inputText: string = resourceToString($r('app.string.web_path'));

  build() {
    Column() {
      Row() {
        Flex() {
          TextInput({ text: this.inputText, placeholder: this.mainUrl, controller: this.textInputController})
            .id('input_url')
            .height(40)
            .margin(5)
            .borderColor(Color.Blue)
            .onChange((value: string) => {
              this.inputText = value;
            })

          Button({type: ButtonType.Capsule}) { Text('Go') }
          .onClick(() => {
            this.controller.loadUrl(this.inputText);
          })

          Button({type: ButtonType.Capsule}) { Text('addAdsBlockDisallowedList') }
          .onClick(() => {
            let arrDomainSuffixes: string[] = [];
            arrDomainSuffixes.push('example.com');
            arrDomainSuffixes.push('abcdefg.cn');
            webview.AdsBlockManager.addAdsBlockDisallowedList(arrDomainSuffixes);
          })
        }
      }
      Web({ src: this.mainUrl, controller: this.controller })
        .onControllerAttached(()=>{
          this.controller.enableAdsBlock(true);
        })
    }
  }
}
// [End turn_off_ad_filtering_for_specific_domain_pages]