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

import Logger from '../data/Logger'
import { Home } from '../component/Home'
import context from '@ohos.application.context'

const TAG: string = 'Index'

@Entry
@Component
struct Index {
  async aboutToAppear() {
    let permission: string[] = ['ohos.permission.WRITE_CONTACTS', 'ohos.permission.READ_CONTACTS']
    let ctx = getContext(this) as context.AbilityContext
    let result = await ctx.requestPermissionsFromUser(permission)
    Logger.info(TAG, `grantPermission,requestPermissionsFromUser,result.requestCode = ${JSON.stringify(result)}`)
  }

  build() {
    Column() {
      Home()
    }
    .width('100%')
    .height('100%')
  }
}