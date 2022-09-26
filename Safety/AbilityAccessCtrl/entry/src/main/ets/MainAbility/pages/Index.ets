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
import prompt from '@ohos.prompt';
import bundle from '@ohos.bundle'
import Logger from '../model/Logger'
import { requestModel } from '@ohos/requestModel'

const TAG: string = '[Index]'

@Entry
@Component
struct Index {
  private request?: requestModel

  aboutToAppear() {
    this.request = new requestModel(['ohos.permission.MICROPHONE'])
    this.request.requestPermission('ohos.samples.abilityaccessctrl')
  }

  build() {
    Row() {
      Column() {
      }
      .width('100%')
    }
    .height('100%')
  }
}