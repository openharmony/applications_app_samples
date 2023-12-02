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
    if (name !== 'PlayMusic') {
      logger.info(TAG, `onExecuteInUIAbilityForegroundMode unsupported insight intent ${name}`);
      result = {
        // decided by developer
        code: 404,
        result: {
          message: `onExecuteInUIAbilityForegroundMode unsupported insight intent ${name}`
        }
      };
      return result;
    }

    // if developer need load content
    router.pushUrl({
      url: 'pages/IntentPage'
    });

    result = {
      code: 0,
      result: {
        message: 'onExecuteInUIAbilityForegroundMode execute insight intent succeed.',
        name: name,
        param: JSON.stringify(param)
      }
    };
    return result;
  }

  onExecuteInServiceExtensionAbility(name: string, param: Record<string, Object>): insightIntent.ExecuteResult {
    let result: insightIntent.ExecuteResult;
    if (name !== 'PlayMusic') {
      logger.info(TAG, `onExecuteInServiceExtensionAbility unsupported insight intent ${name}`);
      result = {
        // decided by developer
        code: 404,
        result: {
          message: `onExecuteInServiceExtensionAbility unsupported insight intent ${name}`
        }
      };
      return result;
    }

    result = {
      code: 0,
      result: {
        message: 'onExecuteInServiceExtensionAbility execute insight intent succeed.',
        name: name,
        param: JSON.stringify(param)
      }
    };
    return result;
  }
}