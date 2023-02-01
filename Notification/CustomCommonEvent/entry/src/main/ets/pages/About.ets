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

import consts from '../module/Consts'
import { Header } from '../component/Header'

@Entry
@Component
struct About {
  build() {
    Column() {
      Header({src: 'aboutTitle.png'})
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Image($rawfile('icon.png')).size({ width: 114, height: 114 })
        Text($r('app.string.sample_version')).size({ width: '80%', height: '5%' })
          .fontSize(10)
          .textAlign(TextAlign.Center)
          .fontColor(0x878980)
        Text($r('app.string.sample_desc')).size({ width: '80%', height: '25%' })
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontColor(0x878980)
      }.size({ width: '90%', height: '90%' })
    }.size({ width: '100%', height: '100%' })
    .backgroundImage($rawfile('vbg720.png'))
    .backgroundImageSize(ImageSize.Contain)
  }
}