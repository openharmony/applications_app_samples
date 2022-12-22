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
import Ability from '@ohos.application.Ability'
import logger from '../Model/Logger'

const TAG: string = 'MainAbility'

export default class MainAbility extends Ability {
  async onCreate(want, launchParam) {
    logger.info(TAG, `[Demo] MainAbility onCreate`)
    await this.context.requestPermissionsFromUser(['ohos.permission.USE_BLUETOOTH', 'ohos.permission.DISCOVER_BLUETOOTH', 'ohos.permission.LOCATION', 'ohos.permission.MANAGE_BLUETOOTH'])
  }

  onDestroy() {
    logger.info(TAG, `[Demo] MainAbility onDestroy`)
  }

  onWindowStageCreate(windowStage) {
    logger.info(TAG, `[Demo] MainAbility onWindowStageCreate`)
    windowStage.setUIContent(this.context, "pages/Index", null)
  }

  onWindowStageDestroy() {
    logger.info(TAG, `[Demo] MainAbility onWindowStageDestroy`)
  }

  onForeground() {
    logger.info(TAG, `[Demo] MainAbility onForeground`)
  }

  onBackground() {
    logger.info(TAG, `[Demo] MainAbility onBackground`)
  }
}