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

import Logger from './util/Logger'

const TAG: string = 'app'

export default {
  // ability启动，对应Stage模型中MainAbility的onCreate
  onCreate() {
    Logger.info(TAG, 'Application onCreate')
  },
  // ability到前台，对应Stage模型中MainAbility的onForeground
  onShow() {
    Logger.info(TAG, 'Application onShow')
  },
  // ability退出，对应Stage模型中MainAbility的onBackground
  onHide() {
    Logger.info(TAG, 'Application onHide')
  },
  // ability到前台，对应Stage模型中MainAbility的onWindowStageCreate
  onActive()
  {
    Logger.info(TAG, 'Application onActive')
  },
  // ability到后台，对应Stage模型中MainAbility的onWindowStageDestroy
  onInactive() {
    Logger.info(TAG, 'Application onInactive')
  },
  // ability销毁，对应Stage模型中MainAbility的onDestroy
  onDestroy() {
    Logger.info(TAG, 'Application onDestroy')
  }
}