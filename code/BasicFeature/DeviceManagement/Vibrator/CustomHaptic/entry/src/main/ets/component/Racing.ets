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

import { getImageRacingList, ImageDataSource } from '../module/ImageData'
import CommonLayout from './Common'

@Component
export default struct RacingLayout {
  @State carList: ImageDataSource = new ImageDataSource(getImageRacingList())
  @State status: boolean[] = [false, false, false, false, false, false, false]
  @Link vibrationIntensity: string
  @Link php: string

  build() {
    CommonLayout({
      dataList: $carList,
      status: $status,
      vibrationIntensity: $vibrationIntensity,
      php: $php
    })
  }
}
