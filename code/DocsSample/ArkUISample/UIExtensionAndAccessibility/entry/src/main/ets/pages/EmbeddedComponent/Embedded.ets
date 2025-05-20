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

import { Want } from '@kit.AbilityKit'

@Component
export struct Embedded {
  @State message: string = 'Message: '
  private want: Want = {
    bundleName: 'com.samples.uiextensionandaccessibility',
    abilityName: 'ExampleEmbeddedAbility',
  }

  build() {
    NavDestination() {
      Row() {
        Column() {
          Text(this.message).fontSize(30)
          EmbeddedComponent(this.want, EmbeddedType.EMBEDDED_UI_EXTENSION)
            .width('100%')
            .height('90%')
            .onTerminated((info) => {
              // 点击extension页面内的terminateSelfWithResult按钮后触发onTerminated回调，文本框显示如下信息
              this.message = 'Termination: code = ' + info.code + ', want = ' + JSON.stringify(info.want);
            })
            .onError((error) => {
              // 失败或异常触发onError回调，文本框显示如下报错内容
              this.message = 'Error: code = ' + error.code;
            })
        }
        .width('100%')
      }
      .height('100%')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Embedded_Component_title'))
  }
}