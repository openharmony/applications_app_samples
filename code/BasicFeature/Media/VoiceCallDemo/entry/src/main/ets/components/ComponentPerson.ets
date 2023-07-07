/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Caller from '../bean/Caller';

/**
 * 头像和名称
 */
@Component
export default struct ComponentPerson {
  @Link mPerson: Caller;

  build() {
    Column() {
      Button() {
        Text(this.mPerson.head)
          .fontSize(60)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.color_fff'))
      }
      .type(ButtonType.Circle)
      .enabled(false)
      .height(136)
      .width(136)
      .backgroundColor($r('app.color.color_02_000'))
      .margin({ bottom: 56 })

      Text(this.mPerson.name)
        .fontSize(40)
        .fontColor($r('app.color.color_fff'))
        .fontWeight(FontWeight.Regular)
        .fontFamily('HarmonyOS Sans SC')
    }
  }
}