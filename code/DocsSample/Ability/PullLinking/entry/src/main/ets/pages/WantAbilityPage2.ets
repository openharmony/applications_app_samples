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
import { common, OpenLinkOptions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[UIAbilityComponentsOpenLink]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct Index {
  build() {
    Button('start link', { type: ButtonType.Capsule, stateEffect: true })
      .width('87%')
      .height('5%')
      .margin({ bottom: '12vp' })
      .onClick(() => {
        let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
        // 通过startAbility接口显式启动其他UIAbility，推荐使用openLink接口。
        // let want: Want = {
        //   bundleName: "com.test.example",
        //   moduleName: "entry",
        //   abilityName: "EntryAbility"
        // };
        // try {
        //   context.startAbilityForResult(want)
        //     .then((data) => {
        //       hilog.info(DOMAIN_NUMBER, TAG, 'startAbility success. data: ' + JSON.stringify(data));
        //     }).catch((err: BusinessError) => {
        //       hilog.error(DOMAIN_NUMBER, TAG, `startAbility failed. Code is ${err.code}, message is ${err.message}`);
        //     })
        // } catch (paramError) {
        //   hilog.error(DOMAIN_NUMBER, TAG, `Failed to startAbility. Code is ${paramError.code}, \
        //   message is ${paramError.message}`);
        // }
        let link: string = 'https://www.example.com';
        let openLinkOptions: OpenLinkOptions = {
          // 匹配的abilities选项是否需要通过App Linking域名校验，匹配到唯一配置过的应用ability
          appLinkingOnly: true,
          // 同want中的parameter，用于传递的参数
          parameters: {demo_key: 'demo_value'}
        };

        try {
          context.openLink(link, openLinkOptions, (err, data) => {
            // AbilityResult回调函数，仅在被启动的UIAbility终止时触发
            hilog.info(DOMAIN_NUMBER, TAG, 'open link success. Callback result: ' + JSON.stringify(data));
          }).then(() => {
            hilog.info(DOMAIN_NUMBER, TAG, 'open link success.');
          }).catch((err: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, TAG, `open link failed. Code is ${err.code}, message is ${err.message}`);
          })
        } catch (paramError) {
          hilog.error(DOMAIN_NUMBER, TAG, `Failed to start link. Code is ${paramError.code}, message is ${paramError.message}`);
        }
      })
  }
}
// [End quick_start0]