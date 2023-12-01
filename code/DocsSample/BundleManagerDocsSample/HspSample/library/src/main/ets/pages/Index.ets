/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

@Entry
@Component
struct Index {
  @State message: string = 'HSP index page';

  build() {
    Column() {
      Text(this.message)
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Bold)
        .fontSize(32)
        .fontWeight(700)
        .fontColor($r('app.color.text_color'))
        .margin({ top: '32px' })
        .width('624px')

      List() {
        ListItem() {
          // 引用HAR的图片资源
          Image($r('app.media.example'))
            .id('example')
            .borderRadius('48px')
        }
        .margin({ top: '50%' })
        .width('312px')
      }
      .alignListItem(ListItemAlign.Center)
    }
    .backgroundColor($r('app.color.page_background'))
    .width('100%')
    .height('100%')
  }
}