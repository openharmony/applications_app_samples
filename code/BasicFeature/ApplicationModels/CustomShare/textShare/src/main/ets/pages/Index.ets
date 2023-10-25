/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { TemplateBuilder } from './TemplateBuilder';
import common from '@ohos.app.ability.common';

@Entry
@Component
struct Index {
  @StorageLink('messages') messages: string = 'No shared information on the current page';
  @StorageLink('sharedFlag') sharedFlag: boolean = false;
  private context = getContext(this) as common.UIAbilityContext;
  private shareDialog?: CustomDialogController;

  build() {
    Column() {
      if (!this.sharedFlag) {
        Row() {
          Text(this.messages)
            .id('messages')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
        }
        .width('70%')
        .justifyContent(FlexAlign.Center)
      } else {
        Row() {
          TemplateBuilder({
            shareDialog: this.shareDialog,
            context: this.context,
            want: {
              bundleName: 'ohos.samples.customshare',
              abilityName: 'ShareExtAbility',
              moduleName: 'textShare',
              parameters: {
                'ability.want.params.uiExtensionType': 'share',
                'shareMessages': this.messages
              }
            }
          })
            .id('templateBuilder')
            .width('75%')
            .height('70%')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('sys.color.ohos_id_color_mask_thin'))
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
