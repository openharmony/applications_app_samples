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

const TAG: string = '[picker]';

@Entry
@Component
export struct TemplateBuilder {
  private shareDialog: CustomDialogController;
  private context = getContext(this) as any;
  private want: Want;

  build() {
    Column() {
        Column({space: 50}) {
            UIExtensionComponent(this.want)
              .size({width:'100%', height:'100'})
              .width('80%')
              .height('60%')
              .margin({top: 50})

          Row() {
            Button() {
              Text($r('app.string.Return_application'))
                .fontSize($r('app.float.fontSize_twenty'))
                .fontWeight(300)
                .constraintSize({maxWidth: 160})
                .maxLines(1)
                .textOverflow({overflow: TextOverflow.Ellipsis})
            }
            .id('return')
            .width('45%')
            .height('6%')
            .margin({ bottom: $r('app.float.fontSize_eighteen') })
            .onClick(() => {
              AppStorage.SetOrCreate('sharedFlag', false);
              this.context.terminateSelf((err, data) =>{
                Logger.info(`${TAG}`, `terminateSelf, err: ${JSON.stringify(err)}`, `data: ${JSON.stringify(data)}`);
                if (err.code) {
                  prompt.showToast({ message: $r('app.string.terminateSelf_fail'), duration: 3000 });
                }
              });
            })

            Button() {
              Text($r('app.string.Stay_application'))
                .fontSize($r('app.float.fontSize_twenty'))
                .fontWeight(300)
                .constraintSize({maxWidth: 160})
                .maxLines(1)
                .textOverflow({overflow: TextOverflow.Ellipsis})
            }
            .id('stay')
            .width('45%')
            .height('6%')
            .margin({ bottom: $r('app.float.fontSize_eighteen') })
            .onClick(() => {
              AppStorage.SetOrCreate('sharedFlag', false);
            })
          }
        }
    }
    .width("100%")
    .backgroundColor('#ffffff')
    .borderRadius(10)
  }
}