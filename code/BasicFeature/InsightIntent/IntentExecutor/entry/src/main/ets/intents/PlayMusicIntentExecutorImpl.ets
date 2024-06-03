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
  onExecuteInUIAbilityForegroundMode(name: string, param: Record<string, Object>,
                                     pageLoader: window.WindowStage): insightIntent.ExecuteResult {
    let result: insightIntent.ExecuteResult;
    let msg: Record<string, Object>;
    if (name !== 'PlayMusic') {
      logger.info(TAG, `onExecuteInUIAbilityForegroundMode unsupported insight intent ${name}`);
      msg = {
        'message': `onExecuteInUIAbilityForegroundMode unsupported insight intent ${name}`
      };
      result = {
        // decided by developer
        code: 404,
        result: msg
      };
      return result;
    }

    // if developer need load content
    try {
      router.pushUrl({
        url: 'pages/IntentPage'
      });
    } catch (err) {
      logger.error(TAG, `pushUrl failed,code:${JSON.stringify(err.code)},message:${JSON.stringify(err.message)}`)
    }


    msg = {
      'message': 'onExecuteInUIAbilityForegroundMode execute insight intent succeed.',
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