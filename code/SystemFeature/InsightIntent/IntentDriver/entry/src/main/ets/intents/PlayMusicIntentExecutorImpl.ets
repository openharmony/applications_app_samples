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

import IntentExecutor from '@ohos.app.ability.InsightIntentExecutor';
import insightIntent from '@ohos.app.ability.insightIntent';
import window from '@ohos.window';
import { logger } from '../util/Logger';
import router from '@ohos.router';

const TAG: string = '[PlayMusicIntentExecutorImpl]';

export default class PlayMusicIntentExecutorImpl extends IntentExecutor {
   onExecuteInServiceExtensionAbility(name: string, param: Record<string, Object>): insightIntent.ExecuteResult {
    let result: insightIntent.ExecuteResult;
    let msg: Record<string, Object>;
    if (name !== 'PlayMusic') {
      logger.info(TAG, `onExecuteInServiceExtensionAbility unsupported insight intent ${name}`);
      msg = {
        'message': `onExecuteInServiceExtensionAbility unsupported insight intent ${name}`
      };
      result = {
        // decided by developer
        code: 404,
        result: msg
      };
      return result;
    }

    msg = {
      'message': 'onExecuteInServiceExtensionAbility execute insight intent succeed.',
      'name': name,
      'param': JSON.stringify(param)
    };
    result = {
      code: 0,
      result: msg
    };
    return result;
  }
}