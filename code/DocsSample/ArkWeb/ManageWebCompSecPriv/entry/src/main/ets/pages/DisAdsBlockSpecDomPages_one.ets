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

// 演示通过一个按钮的点击向Web组件设置广告过滤的域名策略	
@Entry	
@Component	
struct WebComponent {	
  main_url: string = 'https://www.example.com';	
  text_input_controller: TextInputController = new TextInputController();	
  controller: webview.WebviewController = new webview.WebviewController();	

  @State input_text: string = 'https://www.example.com';	

  build() {	
    Column() {	
      Row() {	
        Flex() {	
          TextInput({ text: this.input_text, placeholder: this.main_url, controller: this.text_input_controller})	
            .id('input_url')	
            .height(40)	
            .margin(5)	
            .borderColor(Color.Blue)	
            .onChange((value: string) => {	
              this.input_text = value;	
            })	

          Button({type: ButtonType.Capsule}) { Text('Go') }	
          .onClick(() => {	
            this.controller.loadUrl(this.input_text);	
          })	

          Button({type: ButtonType.Capsule}) { Text('addAdsBlockDisallowedList') }	
          .onClick(() => {	
            let arrDomainSuffixes = new Array<string>();	
            arrDomainSuffixes.push('example.com');	
            arrDomainSuffixes.push('abcdefg.cn');	
            webview.AdsBlockManager.addAdsBlockDisallowedList(arrDomainSuffixes);	
          })	
        }	
      }	
      Web({ src: this.main_url, controller: this.controller })	
        .onControllerAttached(()=>{	
          this.controller.enableAdsBlock(true);	
        })	
    }	
  }	
}
// [End turn_off_ad_filtering_for_specific_domain_pages]