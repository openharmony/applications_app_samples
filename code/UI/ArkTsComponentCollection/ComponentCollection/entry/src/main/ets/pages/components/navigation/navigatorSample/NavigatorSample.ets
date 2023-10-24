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

import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';

@Entry
@Component
struct NavigationSample {
  @State active: boolean = false
  private Text: Record<string, Resource> = { 'message': $r('app.string.navigator_return_message') };

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar({ title: $r('app.string.navigator_title') })
        .margin({ bottom: 12 })
      Navigator({
        target: 'pages/components/navigation/navigatorSample/NavigatorSecondPage',
        type: NavigationType.Push
      }) {
        Text($r('app.string.navigation_first_page_push'))
          .width('100%')
          .textAlign(TextAlign.Center)
          .id(`navigator_001`)
      }.params({ text: this.Text }) // 传参数到Detail页面
      .margin({ bottom: 12 })
    }
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}