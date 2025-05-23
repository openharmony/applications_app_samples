/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { MyDataSource } from '../model/OptionsData'

@CustomDialog
export struct CustomDialogList {
  private menu: Array<string> = []
  controller: CustomDialogController
  action: (value: string) => void

  build() {
    Column() {
      LazyForEach(new MyDataSource(this.menu), item => {
        Text(item)
          .fontSize(24)
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            this.controller.close()
            this.action(item)
          })
      }, item => JSON.stringify(item))
    }
    .id('menu')
  }
}