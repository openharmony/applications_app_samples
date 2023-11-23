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

import { GoodsList } from '../component/GoodsList'

export class StaticContentPageDataTwo {
  names: string
  values: NavPathStack

  constructor(name: string, param: NavPathStack) {
    this.names = name
    this.values = param
  }
}

@Builder
export function StaticContentPageTwo(info: StaticContentPageDataTwo) {
  NavDestination() {
    Column() {
      Scroll() {
        GoodsList();
      }
      .width('100%')
      .height('100%')
      .margin({ top: 170 })
      .scrollBar(BarState.Off)
      .flexGrow(1)
      .flexShrink(1)
      .align(Alignment.Top)
    }
  }
  .backgroundImageSize({ width: '100%', height: 200 })
  .backgroundImage($r('app.media.home_background'), ImageRepeat.NoRepeat)
  .title('pageTwo')
  .onBackPressed(() => {
    info.values.pop();
    return true;
  })
}