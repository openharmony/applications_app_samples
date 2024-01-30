/*
* Copyright (C) 2023-2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Logger from '../../utils/Logger';
@Entry
@Component
struct Index {
  aboutToAppear() {
    Logger.info('testTag', '%{public}s', 'TestAbility index aboutToAppear');
  }
  @State message: string = 'TEST CASE';
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(60)
          .fontWeight(FontWeight.Bold)
        Button() {
          Text('next page')
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }.type(ButtonType.Capsule)
        .margin({
          top: 30
        })
        .backgroundColor('#0D9FFB')
        .width('35%')
        .height('5%')
      }
      .width(360)
    }
    .height('100%')
  }
}