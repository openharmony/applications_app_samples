/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { BusinessError } from '@ohos.base';

@Entry
@Component
struct Index {
  @State message: string = 'EmbeddedUIExtAbility User';
  private want: Want = {
    bundleName: 'com.samples.embeddeduiextensionability',
    abilityName: 'EmbeddedUIExtAbility',
  };

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(30)
          .size({width: '100%', height: '50'})
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)

        EmbeddedComponent(this.want, EmbeddedType.EMBEDDED_UI_EXTENSION)
          .offset({x: 0, y: 30})
          .size({ width: 300, height: 200})
          .border({ width: 5, color: 0x317AF7, radius: 10, style: BorderStyle.Dotted})
          .onTerminated((info: TerminationInfo)=>{
            this.message = 'Terminarion: code = ' + info.code + ', want = ' + JSON.stringify(info.want);
          })
          .onError((error: BusinessError)=>{
            this.message = 'Error: code = ' + error.code;
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}