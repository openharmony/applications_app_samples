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

import EnterpriseAdminExtensionAbility from '@ohos.enterprise.EnterpriseAdminExtensionAbility'
import Logger from '../common/Logger'

export default class EnterpriseAdminAbility extends EnterpriseAdminExtensionAbility {
  onAdminEnabled() {
    Logger.info("onAdminEnabled")
  }

  onAdminDisabled() {
    Logger.info("onAdminDisabled")
  }

  onBundleAdded(bundleName: string) {
    Logger.info("EnterpriseAdminAbility", "onBundleAdded bundleName:" + bundleName)
  }

  onBundleRemoved(bundleName: string) {
    Logger.info("EnterpriseAdminAbility", "onBundleRemoved bundleName" + bundleName)
  }
};