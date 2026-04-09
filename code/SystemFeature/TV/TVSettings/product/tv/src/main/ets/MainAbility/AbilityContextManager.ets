/*
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

import LogUtil from '../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';

const TAG: string = 'AbilityContextManager : ';

/*
Ability Context管理类
2023-12-11
*/
export class AbilityContextManager {
  private contexts: Array<Object> = new Array();

  static getInstance(): AbilityContextManager {
    if (!Boolean(AppStorage.get<AbilityContextManager>('abilityContextManager')).valueOf()) {
      AppStorage.setOrCreate('abilityContextManager', new AbilityContextManager());
    }
    return AppStorage.get<AbilityContextManager>('abilityContextManager') as AbilityContextManager
  }

  private addAbilityContext(context: Object): void {
    this.contexts.push(context);
    AppStorage.setOrCreate('pageContext', this.getAbilityContext());
  }

  private removeAbilityContext(context: Object): void {
    for (let index = 0; index < this.contexts.length; index++) {
      let current = this.contexts[index];
      if (current == context) {
        this.contexts.splice(index, 1);
      }
    }
    AppStorage.setOrCreate('pageContext', this.getAbilityContext());
  }

  private getAbilityContext(): Object | null {
    LogUtil.info(`${TAG} getContext length ${this.contexts.length}`);
    if (this.contexts.length <= 0) {
      return null;
    }
    return this.contexts[0];
  }

  static addContext(context: Object): void {
    AbilityContextManager.getInstance().addAbilityContext(context);
  }

  static removeContext(context: Object): void {
    AbilityContextManager.getInstance().removeAbilityContext(context);
  }

  static getContext(context: Object): void {
    AbilityContextManager.getInstance().getAbilityContext();
  }
}
