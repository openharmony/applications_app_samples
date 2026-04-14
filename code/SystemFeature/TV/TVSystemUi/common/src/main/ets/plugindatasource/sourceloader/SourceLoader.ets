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
import { ItemComponentData, LoaderConfigInfo } from '../common/Constants';
import { AbilityInfoWithId } from '../common/BundleParseUtil';

const TAG = 'SourceLoader';

export type LoaderChannel = {
  add: (item: ItemComponentData) => void;
  remove: (item: ItemComponentData) => void;
  onLoadPluginComponentData: (item: ItemComponentData) => void;
};

export default abstract class SourceLoader {
  private mChannel: LoaderChannel | undefined;

  constructor(config: LoaderConfigInfo) {
    Log.showDebug(TAG, 'constructor');
  }

  setChannel(channel: LoaderChannel): void {
    this.mChannel = channel;
  }

  protected getChannel(): LoaderChannel | undefined {
    return this.mChannel;
  }

  protected addItem(itemData: ItemComponentData): void {
    this.mChannel?.add(itemData);
  }

  protected removeItem(itemData: ItemComponentData): void {
    this.mChannel?.remove(itemData);
  }

  abstract clearData(): void;

  abstract onBundleRemove(bundleName: string): void;

  abstract reloadData(userId: number): void;

  abstract onAbilityAdd(abilityInfo: AbilityInfoWithId): void;
}