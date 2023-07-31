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

import router from '@ohos.router';

const TAG = '[Sample_Index_process]';

@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        Button() {
          Text($r('app.string.modify_publish_data'))
            .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
            .fontSize($r('sys.float.ohos_id_text_size_button1'))
            .fontWeight(FontWeight.Bold)
        }
        .height(40)
        .width(220)
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_component_activated'))
        .type(ButtonType.Capsule)
        .margin({ top: 20 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/PushIndex' });
        })

        Button() {
          Text($r('app.string.subscription_conditions'))
            .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
            .fontSize($r('sys.float.ohos_id_text_size_button1'))
            .fontWeight(FontWeight.Bold)
        }
        .height(40)
        .width(220)
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_component_activated'))
        .type(ButtonType.Capsule)
        .margin({ top: 20 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/ModifyConditionIndex' });
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}