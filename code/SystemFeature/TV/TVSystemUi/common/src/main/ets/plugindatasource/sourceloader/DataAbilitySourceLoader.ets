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
 

import Log from '../../default/Log';
import { AbilityInfoWithId } from '../common/BundleParseUtil';
import { LoaderConfigInfo } from '../common/Constants';
import SourceLoader from './SourceLoader';

const TAG = 'DataAbilitySourceLoader';

export default class DataAbilitySourceLoader extends SourceLoader {
  constructor(config: LoaderConfigInfo) {
    super(config);
    Log.showDebug(TAG, 'constructor');
  }

  clearData(): void {
  }

  reloadData(userId: number): void {
  }

  onAbilityAdd(abilityInfo: AbilityInfoWithId): void {
  }

  onBundleRemove(bundleName: string): void {
  }
}