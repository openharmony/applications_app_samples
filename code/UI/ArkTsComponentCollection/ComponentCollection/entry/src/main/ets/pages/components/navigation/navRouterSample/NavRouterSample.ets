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

import { TitleBar } from '../../../../common/TitleBar'
import { getStringData } from '../../../../data/ResourceDataHandle'

@Entry
@Component
struct NavRouterSample {
  private arr: number[] = [1, 2, 3];

  build() {
    Column() {
      TitleBar({ title: $r('app.string.navRouter_title') })
      Navigation() {

        List({ space: 12 }) {
          ForEach(this.arr, (item: number) => {
            ListItem() {
              NavRouter() {
                Text(getStringData($r('app.string.nav_router')) + item)
                  .width("100%")
                  .height(72)
                  .backgroundColor('#FFFFFF')
                  .borderRadius(24)
                  .fontSize(16)
                  .fontWeight(500)
                  .textAlign(TextAlign.Center)
                NavDestination() {
                  Text("NavDestinationContent" + item)
                }
                .title("NavDestinationTitle" + item)
              }
            }
            .id('Navigation' + item)
          }, (item: number) => item.toString())
        }
        .width("90%")
        .margin({ top: 12 })
      }
      .mode(NavigationMode.Stack)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F1F3F5')
  }
}