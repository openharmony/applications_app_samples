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

import router from '@ohos.router'
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';

@Entry
@Component
struct DetailExample {
  // 接收Navigator.ets的传参
  private text:string = (router.getParams() as Record<string, string>).text;

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar({ title: $r('app.string.navigator_second_page') })
        .margin({bottom:12})
      Navigator({ target: 'pages/components/navigation/navigatorSample/NavigatorThirdPage', type: NavigationType.Push }) {
        Text($r('app.string.navigator_second_page_push'))
          .width('100%')
          .textAlign(TextAlign.Center)
          .height(20)
          .id(`navigation_002`)
      }
      .margin({bottom:30})

      Text(this.text['message'])
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontColor(Color.Red)
    }
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}