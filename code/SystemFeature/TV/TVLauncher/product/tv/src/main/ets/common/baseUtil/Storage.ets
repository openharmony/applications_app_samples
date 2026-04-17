/**
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { Context } from '@kit.AbilityKit'
import { preferences } from '@kit.ArkData'

export const storeToken = 'infoList'

export const preferenceToken = 'shortcuts_preferences'
// 前2个不可移动  前6个不可移除
export const infoList: string[] = ['输入源', '视频播放器', 'FUNUI影视', '设置', '图库', '全部应用', '相机', '音乐'];
const TAG: string = 'StoreAppList'

export default class StoreAppList {
  private context: Context

  constructor(context: Context) {
    this.context = context
  }

  getStore() {
    return preferences.getPreferencesSync(this.context, {
      name: preferenceToken
    })
  }

  async setAppList(appInfoList: string[]) {
    const appStore = this.getStore()
    await appStore.put(storeToken, appInfoList)
    await appStore.flush()
  }

  getAppList(): string[] {
    const appStore = this.getStore()
    let aa = appStore.getSync(storeToken, infoList)
    return aa as string[] ;
  }
}

export const GET_RESOURSE_TIME = 4000

export const GET_RESOURSE_TIME_INTERVAL = 6 * 60 * 60 * 1000
