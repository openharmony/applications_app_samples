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

import ServiceExtension from '@ohos.app.ability.ServiceExtensionAbility';
import Want from '@ohos.app.ability.Want';
import { Configuration } from '@ohos.app.ability.Configuration';
import { logger } from '../util/Logger';

const TAG: string = '[ServiceExtAbility]';

export default class ServiceExtAbility extends ServiceExtension {
  onCreate(want: Want) {
    logger.info(TAG, `onCreate, want: ${want.abilityName}`);
  }

  onDestroy() {
    logger.info(TAG, `onDestroy`);
  }

  onRequest(want: Want, startId: number) {
    logger.info(TAG, `onRequest, want: ${want.abilityName}, startId: ${startId}`);
  }

  onConfigurationUpdate(config: Configuration) {
    logger.info(TAG, `onConfigurationUpdate, config: ${JSON.stringify(config)}`);
  }

  onDump(params: Array<string>) {
    logger.info(TAG, `onDump, params: ${JSON.stringify(params)}`);
    return ['params'];
  }
}
