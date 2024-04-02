/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import common from '@ohos.app.ability.common';
import EnvironmentCallback from '@ohos.app.ability.EnvironmentCallback';
import hilog from '@ohos.hilog';
import Want from '@ohos.app.ability.Want';
import { Configuration } from '@ohos.app.ability.Configuration';

const TAG: string = '[Page_UIAbilityComponentsBasicUsage]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct Page_UIAbilityComponentsBasicUsage {
  private context = getContext(this) as common.UIAbilityContext;
  private callbackId: number = 0; // 注册订阅系统环境变化的ID

  startAbilityTest(): void {
    let context = getContext(this) as common.UIAbilityContext;
    let want: Want = {
      // Want参数信息
    };
    context.startAbility(want);
  }

  subscribeConfigurationUpdate(): void {
    let systemLanguage: string | undefined = this.context.config.language; // 获取系统当前语言
    // 1.获取ApplicationContext
    let applicationContext = this.context.getApplicationContext();
    // 2.通过applicationContext订阅环境变量变化
    let environmentCallback: EnvironmentCallback = {
      onConfigurationUpdated(newConfig: Configuration): void {
        hilog.info(DOMAIN_NUMBER, TAG, `onConfigurationUpdated systemLanguage is ${systemLanguage}, newConfig: ${JSON.stringify(newConfig)}`);
        if (this.systemLanguage !== newConfig.language) {
          hilog.info(DOMAIN_NUMBER, TAG, `systemLanguage from ${systemLanguage} changed to ${newConfig.language}`);
          systemLanguage = newConfig.language; // 将变化之后的系统语言保存，作为下一次变化前的系统语言
        }
      },
      onMemoryLevel(level): void {
        hilog.info(DOMAIN_NUMBER, TAG, `onMemoryLevel level: ${level}`);
      }
    }
    this.callbackId = applicationContext.on('environment', environmentCallback);
  }

  // 页面展示
  build() {
    Column() {
      Row() {
        Text($r('app.string.UIAbilityComponentsBasicUsage'))
          .fontSize(24)
          .fontWeight(700)
          .textAlign(TextAlign.Start)
          .margin({ top: 12, bottom: 11, right: 24, left: 24 })
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)

      Image($r('app.media.pic_empty'))
        .width(120)
        .height(120)
        .margin({ top: 224 })

      Text($r('app.string.NoContentAvailable'))
        .fontSize(14)
        .margin({ top: 8, bottom: 317, right: 152, left: 152 })
        .fontColor($r('app.color.text_color'))
        .opacity(0.4)
        .fontWeight(400)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.backGrounding'))
  }
}