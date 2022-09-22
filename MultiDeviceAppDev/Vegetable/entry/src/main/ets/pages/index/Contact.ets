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

@Preview
@Component
export struct Contact {
  build() {
    Column() {
      Divider().strokeWidth(1).color('#19001111')
      Column() {
        Text('Contact us')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)
        Text('Address:410 JiangHong Road, ZhangLi')
          .width('100%')
          .textAlign(TextAlign.Start)
        Text('Tel:0000-00000000')
          .width('100%')
          .textAlign(TextAlign.Start)
        Text('Email:test@test.com')
          .width('100%')
          .textAlign(TextAlign.Start)
      }
    }.height('100%').justifyContent(FlexAlign.Center)
  }
}