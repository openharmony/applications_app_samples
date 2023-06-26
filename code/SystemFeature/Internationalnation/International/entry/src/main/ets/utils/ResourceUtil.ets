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
import common from '@ohos.app.ability.common';

class ResourceUtil {
  getString(id: number) {
    let context = getContext(this) as common.UIAbilityContext;
    return context.resourceManager.getStringSync(id);
  }

  async getStringArray(id: number) {
    let context = getContext(this) as common.UIAbilityContext;
    let strArray = await context.resourceManager.getStringArrayValue(id);
    return strArray;
  }

  async getPluralString(id: number, num: number) {
    let context = getContext(this) as common.UIAbilityContext;
    let plural = await context.resourceManager.getPluralStringValue(id, num);
    return plural;
  }

  async getDirection() {
    let context = getContext(this) as common.UIAbilityContext;
    let configuration = await context.resourceManager.getConfiguration();
    if (configuration.direction === 1) { // 1代表Horizontal，0代表Vertical
      return 'Horizontal';
    } else {
      return 'Vertical';
    }
  }
}

export default new ResourceUtil()