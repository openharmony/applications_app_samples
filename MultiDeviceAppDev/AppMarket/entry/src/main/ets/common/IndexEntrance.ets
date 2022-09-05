/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { entranceIcons } from '../model/HomeData'
import { AllIcons } from '../model/HomeDataType'

@Component
export default struct IndexEntrance {
  build() {
    Row() {
      ForEach(entranceIcons, (icon: AllIcons) => {
        Column() {
          Image(icon.image)
            .width(40)
            .height(40)
            .margin({ bottom: 4 })
          Text(icon.title)
            .fontSize(12)
            .textAlign(TextAlign.Center)
            .fontWeight(400)
        }
      })
    }
    .width('100%')
    .height(64)
    .justifyContent(FlexAlign.SpaceEvenly)
    .padding({ left: 12, right: 12 })
  }
}