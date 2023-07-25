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

import Logger from '../util/Logger'

let context = getContext(this)

export function getStringArrayData(resourceArrayData: Resource[]):string[] {
  if (!resourceArrayData) {
    return
  }
  let resourceStringArrayData: string[] = []
  resourceArrayData.forEach(item => {
    try {
      resourceStringArrayData.push(context.resourceManager.getStringSync(item.id))
    } catch (error) {
      Logger.error(`callback getStringValue failed, error code: ${error.code}, message: ${error.message}.`)
    }
  })
  return resourceStringArrayData
}

export function getStringData(resourceData: Resource):string {
  if (!resourceData) {
    return
  }
  return context.resourceManager.getStringSync(resourceData.id)
}