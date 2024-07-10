/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  async aboutToAppear() {
    console.log('about to appear');
  }

  build() {
    Row({ space: 10}) {
      Column({ space: 50}) {
        Button() {
          Text($r('app.string.default_avcastpicker'))
            .fontSize(22)
            .fontColor(Color.White)
            .alignRules({
              center: {anchor: '__container__', align: VerticalAlign.Center},
              middle: {anchor: '__container__', align: HorizontalAlign.Center}
            })
        }
        .size({ width: '50%', height: 60})
        .onClick(async() => {
          await router.pushUrl({ url:'pages/DefaultPicker' });
        })

        Button() {
          Text($r('app.string.custom_avcastpicker'))
            .fontSize(22)
            .fontColor(Color.White)
            .alignRules({
              center: {anchor: '__container__', align: VerticalAlign.Center},
              middle: {anchor: '__container__', align: HorizontalAlign.Center}
            })
        }
        .size({ width: '50%', height: 60})
        .onClick(async() => {
          await router.pushUrl({ url:'pages/CustomPicker' });
        })
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .size({ width: '100%', height: '100%'})
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .size({ width: '100%', height: '100%'})
  }
}