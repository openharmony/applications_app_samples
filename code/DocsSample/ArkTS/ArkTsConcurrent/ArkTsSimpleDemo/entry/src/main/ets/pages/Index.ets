/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { listAllTests, selectTest, startTest} from '../managers/manager';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Index {
  @State message: string = 'Please run a test...';

  build() {
    Row() {
      Navigation() {
        Column({space: 16}) {
          Select(listAllTests().map<SelectOption>((v) => {
            return { value: v[0] }
          }))
            .id("selectTest")
            .value("Choose the test option")
            .onSelect(selectTest)
            .width('88%')
            .height('12vp')
            .optionWidth("414vp")
          Button("Execute this Test")
            .onClick(() => {
              this.message = '';
              let res = startTest();
              res.then((v) => {
                promptAction.showToast({
                  message: v
                });
              }).catch((e: Error) => {
                promptAction.showToast({
                  message: e.message
                });
              });
            })
            .id("execute")
            .position({ x: "6%", y: "90%" })
            .width('88%')
            .fontSize(16)
            .height('40')
        }
        .width("100%")
        .height("100%")
      }.title("ArkTS-SimpleDemo")

    }
    .width("100%")
    .height("100%")
  }
}