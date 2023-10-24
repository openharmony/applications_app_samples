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

import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import { TitleBar } from '../../../../common/TitleBar';

@Entry
@Component
struct BackExample {
  build() {
    Column() {
      TitleBar({title : $r('app.string.navigator_third_page')})
      Navigator({ target: 'pages/components/navigation/navigatorSample/NavigatorSample', type: NavigationType.Back }) {
        Text($r('app.string.navigator_third_page_back'))
          .width('100%')
          .textAlign(TextAlign.Center)
          .id(`navigator_003`)
      }
    }
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}