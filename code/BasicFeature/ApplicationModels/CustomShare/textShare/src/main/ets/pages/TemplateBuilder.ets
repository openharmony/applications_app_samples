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

import Logger from '../model/Logger';
import prompt from '@ohos.promptAction';
import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';

const TAG: string = '[Sample_TemplateBuilder]';

@Entry
@Component
export struct TemplateBuilder {
  private shareDialog?: CustomDialogController;
  private context = getContext(this) as common.UIAbilityContext;
  private want?: Want;

  build() {
    Column() {
      Row() {
        UIExtensionComponent(this.want)
          .size({ width: '100%', height: '70%' })
      }
      .margin({
        top: 24,
        left: 24,
        right: 24
      })

      Row({ space: 16 }) {
        Button() {
          Text($r('app.string.Return_application'))
            .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
            .fontSize($r('sys.float.ohos_id_text_size_button3'))
            .constraintSize({ maxWidth: 160 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .id('return')
        .height(40)
        .layoutWeight(1)
        .type(ButtonType.Capsule)
        .borderRadius($r('sys.float.ohos_id_corner_radius_small_button'))
        .backgroundColor($r('sys.color.ohos_id_color_component_activated'))
        .onClick(() => {
          AppStorage.SetOrCreate('sharedFlag', false);
          this.context.terminateSelf((err, data) => {
            Logger.info(`${TAG}`, `terminateSelf, err: ${JSON.stringify(err)}`, `data: ${JSON.stringify(data)}`);
            if (err.code) {
              prompt.showToast({ message: $r('app.string.terminateSelf_fail'), duration: 3000 });
            }
          });
        })

        Button() {
          Text($r('app.string.Stay_application'))
            .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
            .fontSize($r('sys.float.ohos_id_text_size_button3'))
            .constraintSize({ maxWidth: 160 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .id('stay')
        .height(40)
        .layoutWeight(1)
        .type(ButtonType.Capsule)
        .borderRadius($r('sys.float.ohos_id_corner_radius_small_button'))
        .backgroundColor($r('sys.color.ohos_id_color_component_activated'))
        .onClick(() => {
          AppStorage.SetOrCreate('sharedFlag', false);
        })
      }
      .margin({
        top: 8,
        bottom: $r('app.float.margin_sixteen'),
        left: 16,
        right: 16
      })
    }
    .width("100%")
    .backgroundColor('#ffffff')
    .borderRadius($r('sys.float.ohos_id_corner_radius_dialog'))
  }
}