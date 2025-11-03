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

// [Start app_select_list_rule_file_for_ad_filter]
import { webview } from '@kit.ArkWeb';	
import { picker, fileUri } from '@kit.CoreFileKit';	

// 演示点击按钮，通过filepicker打开一个easylist规则文件并设置到Web组件中	
@Entry	
@Component	
struct WebComponent {	
  main_url: string = 'https://www.example.com';	
  controller: webview.WebviewController = new webview.WebviewController();	

  @State input_text: string = 'https://www.example.com';	

  build() {	
    Column() {	
      Row() {	
        Flex() {	
          Button({type: ButtonType.Capsule}) {	
            Text('setAdsBlockRules')
          }	
          .onClick(() => {	
            try {	
              let documentSelectionOptions: ESObject = new picker.DocumentSelectOptions();	
              let documentPicker: ESObject = new picker.DocumentViewPicker();	
              documentPicker.select(documentSelectionOptions).then((documentSelectResult: ESObject) => {	
                if (documentSelectResult && documentSelectResult.length > 0) {	
                  let fileRealPath = new fileUri.FileUri(documentSelectResult[0]);	
                  console.info('DocumentViewPicker.select successfully, uri: ' + fileRealPath);	
                  webview.AdsBlockManager.setAdsBlockRules(fileRealPath.path, true);	
                }	
              })	
            } catch (err) {	
              console.error('DocumentViewPicker.select failed with err:' + err);	
            }	
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
// [End app_select_list_rule_file_for_ad_filter]