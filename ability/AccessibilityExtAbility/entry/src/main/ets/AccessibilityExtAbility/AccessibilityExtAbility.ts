/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import AccessibilityExtensionAbility from '@ohos.application.AccessibilityExtensionAbility'
import AccessibilityManager from './AccessibilityManager'
import Logger from '../utils/Logger'

class AccessibilityExtAbility extends AccessibilityExtensionAbility {
  onConnect() {
    Logger.info("AccessibilityExtAbility onConnect")
    AccessibilityManager.getInstance().onStart(this.context)
  }

  onDisconnect() {
    Logger.info("AccessibilityExtAbility onDisconnect")
    AccessibilityManager.getInstance().onStop()
  }

  onAccessibilityEvent(accessibilityEvent) {
    Logger.info("AccessibilityExtAbility onAccessibilityEvent type: " + accessibilityEvent.eventType)
    AccessibilityManager.getInstance().onEvent(accessibilityEvent)
  }
}

export default AccessibilityExtAbility