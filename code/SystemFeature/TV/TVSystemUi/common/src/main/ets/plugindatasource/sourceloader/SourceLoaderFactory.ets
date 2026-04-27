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
import SourceLoader, { LoaderChannel } from './SourceLoader';
import DataAbilitySourceLoader from './DataAbilitySourceLoader';
import MetaSourceLoader from './MetaSourceLoader';
import PluginSourceLoader from './PluginSourceLoader';
import { LoaderConfigInfo } from '../common/Constants';

const TAG = 'SourceLoaderFactory';

const classMap: { [key: string]: any } = {
  MetaSource: MetaSourceLoader,
  PluginSourceLoader: PluginSourceLoader,
  DataAbilitySourceLoader: DataAbilitySourceLoader,
};

export default class SourceLoaderFactory {
  private mChannel: LoaderChannel;

  constructor(channel: LoaderChannel) {
    Log.showDebug(TAG, `constructor, channel: ${channel}`);
    this.mChannel = channel;
  }

  getSourceLoader(pluginType: string, config: LoaderConfigInfo): null | SourceLoader {
    let clz = classMap[pluginType];
    if (!clz) {
      Log.showError(TAG, `Can't find pluginType: ${pluginType}`);
      return null;
    }
    let loader: SourceLoader = new clz(config);
    loader.setChannel(this.mChannel);
    return loader;
  }
}