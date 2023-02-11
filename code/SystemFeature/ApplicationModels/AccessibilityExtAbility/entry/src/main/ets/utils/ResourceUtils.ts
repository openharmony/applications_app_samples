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

import Logger from './Logger'

class ResourceUtils {
  constructor() {
  }

  static getStringByName(context, name) {
    Logger.info("ResourceUtils getStringByName")
    if (context == null) {
      Logger.error("ResourceUtils context is null")
      return
    }
    let value = null
    try {
      value = context.resourceManager.getStringByNameSync(name)
    } catch (error) {
      Logger.error("ResourceUtils Failed to get string. Cause: " + JSON.stringify(error))
    }
    return value
  }

  static getStringByResource(context, resource) {
    Logger.info("ResourceUtils getStringByResource")
    if (context == null) {
      Logger.error("ResourceUtils context is null")
      return
    }
    let value = null
    try {
      value = context.resourceManager.getStringSync(resource)
    } catch (error) {
      Logger.error("ResourceUtils Failed to get string. Cause: " + JSON.stringify(error))
    }
    return value
  }
}

export default ResourceUtils