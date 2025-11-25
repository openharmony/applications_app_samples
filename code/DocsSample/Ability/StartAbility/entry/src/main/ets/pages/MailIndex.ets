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

// [Start mail_index_import]
import { common, wantConstant } from '@kit.AbilityKit';
// [End mail_index_import]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'MailIndex';
const DOMAIN = 0x0000;
// [Start mail_index_component]

@Entry
@Component
struct MailIndex {
  @State hideAbility: string = 'hideAbility'

  build() {
    Row() {
      Column() {
        Text(this.hideAbility)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let wantParam: Record<string, Object> = {
              'sceneType': 1,
              'email': [encodeURI('xxx@example.com'), encodeURI('xxx@example.com')], // 收件人邮箱地址，多值以逗号分隔，对数组内容使用encodeURI()方法进行url编码
              'cc': [encodeURI('xxx@example.com'), encodeURI('xxx@example.com')], // 抄收人邮箱地址，多值以逗号分隔，对数组内容使用encodeURI()方法进行url编码
              'bcc': [encodeURI('xxx@example.com'), encodeURI('xxx@example.com')], // 密送人邮箱地址，多值以逗号分隔，对数组内容使用encodeURI()方法进行url编码
              'subject': encodeURI('邮件主题'), // 邮件主题，对内容使用encodeURI()方法进行url编码
              'body': encodeURI('邮件正文'), // 邮件正文，对内容使用encodeURI()方法进行url编码
              'ability.params.stream': [encodeURI('附件uri1'), encodeURI('附件uri2')], // 附件uri，多值以逗号分隔，对数组内容使用encodeURI()方法进行url编码
              'ability.want.params.uriPermissionFlag': wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION
            };
            let abilityStartCallback: common.AbilityStartCallback = {
              onError: (code: number, name: string, message: string) => {
                hilog.error(DOMAIN, TAG, `onError code ${code} name: ${name} message: ${message}`);
              },
              onResult: (result) => {
                hilog.info(DOMAIN, TAG, `onResult result: ${JSON.stringify(result)}`);
              }
            }

            context.startAbilityByType('mail', wantParam, abilityStartCallback,
              (err) => {
                if (err) {
                  hilog.error(DOMAIN, TAG, `startAbilityByType fail, err: ${JSON.stringify(err)}`);
                } else {
                  hilog.info(DOMAIN, TAG, `success`);
                }
              });
          });
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End mail_index_component]