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
// [Start Page_StartModel]
// 在启动指定实例模式的UIAbility时，给每一个UIAbility实例配置一个独立的Key标识
// 例如在文档使用场景中，可以用文档路径作为Key标识
import { common, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = '[SpecifiedPage]';
const DOMAIN_NUMBER: number = 0xFF00;

function getInstance(): string {
  return 'KEY';
}

@Entry
@Component
struct SpecifiedPage {
  private KEY_NEW = 'KEY';

  build() {
    Row() {
      Column() {
        // [StartExclude Page_StartModel]
        Text('EntryAbility')
          .id('HelloWorld')
          // 请将$r('app.float.page_text_font_size')替换为实际资源文件，在本示例中该资源文件的value值为"50fp"
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
        // [EndExclude Page_StartModel]
        // 请将$r('app.string.new_doc')替换为实际资源文件，在本示例中该资源文件的value值为"新建一个文档"
        Button($r('app.string.new_doc'))
        // [StartExclude Page_StartModel]
          .margin({top: 8})
          .width('60%')
          // [EndExclude Page_StartModel]
          .onClick(() => {
            let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
            // context为调用方UIAbility的UIAbilityContext;
            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.uiabilitylaunchtype',
              abilityName: 'SpecifiedFirstAbility',
              moduleName: 'entry', // moduleName非必选
              parameters: {
                // 自定义信息
                instanceKey: this.KEY_NEW
              }
            };
            context.startAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting SpecifiedAbility.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start SpecifiedAbility. Code is ${err.code}, message is ${err.message}`);
            });
            this.KEY_NEW = this.KEY_NEW + 'a';
          })

        // 请将$r('app.string.open_old_doc')替换为实际资源文件，在本示例中该资源文件的value值为"打开已保存文档"
        Button($r('app.string.open_old_doc'))
        // [StartExclude Page_StartModel]
          .margin({top: 8})
          .width('60%')
          // [EndExclude Page_StartModel]
          .onClick(() => {
            let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
            // context为调用方UIAbility的UIAbilityContext;
            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.samples.uiabilitylaunchtype',
              abilityName: 'SpecifiedSecondAbility',
              moduleName: 'entry', // moduleName非必选
              parameters: {
                // 自定义信息
                instanceKey: getInstance()
              }
            };
            context.startAbility(want).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in starting SpecifiedAbility.');
            }).catch((err: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `Failed to start SpecifiedAbility. Code is ${err.code}, message is ${err.message}`);
            });
            this.KEY_NEW = this.KEY_NEW + 'a';
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End Page_StartModel]