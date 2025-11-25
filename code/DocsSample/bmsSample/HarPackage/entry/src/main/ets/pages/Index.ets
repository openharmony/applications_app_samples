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

// [Start har_package_010]
// entry/src/main/ets/pages/Index.ets
import { Log, func } from 'library';
// [StartExclude har_package_010]
// [Start har_package_011]
// entry/src/main/ets/pages/Index.ets
import { nativeAdd } from 'library';
// [StartExclude har_package_011]
// [Start har_package_012]
// entry/src/main/ets/pages/Index.ets
// [EndExclude har_package_010]
// [EndExclude har_package_011]
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Text(this.message)
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Bold)
        .fontSize(32)

      // [StartExclude har_package_011]
      // [StartExclude har_package_012]
      //引用HAR的ets类和方法
      Button($r('app.string.button'))
        .id('button')
        .height(48)
        .width('624px')
        .margin({ top: '4%' })
        .type(ButtonType.Capsule)
        .onClick(() => {
          // 引用HAR的类和方法
          Log.info('har msg');
          this.message = 'func return: ' + func();
        })
      // [EndExclude har_package_011]
      // [StartExclude har_package_010]
      //引用HAR的native方法
      Button($r('app.string.native_add'))
        .id('nativeAdd')
        .height(48)
        .width('624px')
        .margin({ top: '4%', bottom: '6%' })
        .type(ButtonType.Capsule)
        .onClick(() => {
          this.message = 'result: ' + nativeAdd(1, 2);
        })
      // [EndExclude har_package_010]
      // [EndExclude har_package_012]

      // [StartExclude har_package_010]
      // [StartExclude har_package_011]
      // 引用HAR的字符串资源
      Text($r('app.string.hello_har'))
        .id('stringHar')
        .fontFamily('HarmonyHeiTi')
        .fontColor($r('app.color.text_color'))
        .fontSize(24)
        .fontWeight(500)
        .margin({ top: '40%' })

      List() {
        ListItem() {
          // 引用HAR的图片资源
          Image($r('app.media.icon_har'))
            .id('iconHar')
            .borderRadius('48px')
        }
        .margin({ top: '5%' })
        .width('312px')
      }
      .alignListItem(ListItemAlign.Center)
      // [EndExclude har_package_010]
      // [EndExclude har_package_011]
    }
    .width('100%')
    .backgroundColor($r('app.color.page_background'))
    .height('100%')
  }
}
// [End har_package_012]
// [End har_package_011]
// [End har_package_010]
