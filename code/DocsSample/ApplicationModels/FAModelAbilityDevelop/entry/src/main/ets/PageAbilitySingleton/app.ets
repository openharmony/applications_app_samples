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

import Want from '@ohos.app.ability.Want';
import featureAbility from '@ohos.ability.featureAbility';
import bundle from '@ohos.bundle';
import { GlobalContext } from '../utils/GlobalContext';
import hilog from '@ohos.hilog';

const TAG: string = 'PageAbilitySingleton';
const domain: number = 0xFF00;

class PageAbilitySingleton {
  onCreate() {
    // 获取context并调用相关方法
    let context = featureAbility.getContext();
    context.setDisplayOrientation(bundle.DisplayOrientation.PORTRAIT).then(() => {
      hilog.info(domain, TAG, 'Set display orientation.')
    })
    hilog.info(domain, TAG, 'Application onCreate');
  }

  onDestroy() {
    hilog.info(domain, TAG, 'Application onDestroy');
  }

  onNewWant(want: Want) {
    featureAbility.getWant().then((want) => {
      GlobalContext.getContext().setObject('newWant', want);
    })
  }
}

export default new PageAbilitySingleton();