/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import featureAbility from '@ohos.ability.featureAbility';
import hilog from '@ohos.hilog';

const TAG: string = 'MainAbility';
const domain: number = 0xFF00;

class MainAbility {
  onCreate() {
    // 获取context并调用相关方法
    let context = featureAbility.getContext();
    context.getBundleName((data, bundleName) => {
      hilog.info(domain, TAG, 'ability bundleName:' ,bundleName);
    });
    hilog.info(domain, TAG, 'Application onCreate');
  }

  onDestroy() {
    hilog.info(domain, TAG, 'Application onDestroy');
  }

  onShow(): void {
    hilog.info(domain, TAG, 'Application onShow');
  }

  onHide(): void {
    hilog.info(domain, TAG, 'Application onHide');
  }

  onActive(): void {
    hilog.info(domain, TAG, 'Application onActive');
  }

  onInactive(): void {
    hilog.info(domain, TAG, 'Application onInactive');
  }

  onNewWant() {
    hilog.info(domain, TAG, 'Application onNewWant');
  }
}

export default new MainAbility();