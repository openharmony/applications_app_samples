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

import Want from '@ohos.app.ability.Want';
import { TemplateBuilder } from '../pages/picker';

@Entry
@Component
struct Index {
  @StorageLink('messages') messages: string = 'No shared information on the current page';
  @StorageLink('sharedFlag') sharedFlag: boolean = false;
  private context = getContext(this) as any;
  private shareDialog: CustomDialogController;

  build() {
    Row() {
      Column() {
        if (!this.sharedFlag) {
          Text(this.messages)
            .id('messages')
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
        } else {
          TemplateBuilder({
            shareDialog: this.shareDialog,
            context: this.context,
            want: {
              bundleName: 'com.samples.template',
              abilityName: 'UIExtAbility',
              parameters: {
                'shareMessages': this.messages
              }
            }
          })
            .id('templateBuilder')
            .width('70%')
            .height('70%')
        }
      }
      .width('100%')
    }
    .height('100%')
    .backgroundColor('#e0ffff')
  }
}
