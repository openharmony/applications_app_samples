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

import { ComponentContent } from '@kit.ArkUI';

class Params {
}

@Builder
function loadingBuilder(params: Params) {
  Column() {
    LoadingProgress()
      .color(Color.Blue)
  }
}

@Component
export struct AccessibilityFocusDrawLevel {
  private contentNode = new ComponentContent(this.getUIContext(), wrapBuilder(loadingBuilder), new Params);

  build() {
    NavDestination() {
      Row() {
        List() {
          ListItem() {
            Column() {
              Stack() {
                Column() {
                  Text($r('app.string.UniversalAttributesAccessibility_text5'))
                  Text($r('app.string.UniversalAttributesAccessibility_text5'))
                    .accessibilityFocusDrawLevel(FocusDrawLevel.TOP)
                }

                Column() {
                  Text($r('app.string.UniversalAttributesAccessibility_text6'))
                    .backgroundColor(Color.Gray)
                  Text($r('app.string.UniversalAttributesAccessibility_text6'))
                    .backgroundColor(Color.Gray)
                }
              }

              Column() {
                Text($r('app.string.UniversalAttributesAccessibility_text9'))
                  .fontSize(50)
                  .fontWeight(FontWeight.Bold)
                Column() {
                  UIExtensionComponent({
                    bundleName: 'com.example.provide',
                    abilityName: 'EmptyUIExtensionAbility',
                    parameters: {
                      'ability.want.params.uiExtensionType': 'sys/commonUI'
                    }
                  },
                    {
                      placeholder: this.contentNode,
                      dpiFollowStrategy: DpiFollowStrategy.FOLLOW_UI_EXTENSION_ABILITY_DPI
                    })
                    .onReceive((err) => {
                      console.error('onReceive' + JSON.stringify(err));
                    })
                    .onError((err) => {
                      console.error('onError code :' + err.code + ', name: ' + err.name + ', msg: ' + err.message);
                      console.error('onError' + JSON.stringify(err));
                    })
                    .accessibilityUseSamePage(AccessibilitySamePageMode.FULL_SILENT)
                    .width('50%')
                    .height('50%')
                    .backgroundColor(Color.Pink)
                }
              }
              .width('100%')
              .height('100%')
              .accessibilityText($r('app.string.UniversalAttributesAccessibility_text7'))
              .accessibilityDescription($r('app.string.UniversalAttributesAccessibility_text8'))

              Column() {
                Text($r('app.string.UniversalAttributesAccessibility_text10'))
                  .fontSize(50)
                  .fontWeight(FontWeight.Bold)
              }
            }
          }
        }.accessibilityScrollTriggerable(false)
      }
      .height('100%')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.UniversalAttributesAccessibility_title3'))
  }
}