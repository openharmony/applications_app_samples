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

import insightIntentDriver from '@ohos.app.ability.insightIntentDriver';
import insightIntent from '@ohos.app.ability.insightIntent';
import { logger } from '../util/Logger';
import { BusinessError } from '@ohos.base';

const TAG: string = '[PlayMusicIntentDriver]';

class PlayMusicIntentDriver {
  public executeResult: insightIntent.ExecuteResult = { code: 0 };
  executeUIAbilityForeground = (): void => {
    let intentParam: Record<string, Object> = {
      'songName': 'City Of Stars',
    };
    let param: insightIntentDriver.ExecuteParam = {
      bundleName: 'com.samples.intentexecutor',
      moduleName: 'entry',
      abilityName: 'EntryAbility',
      insightIntentName: 'PlayMusic',
      insightIntentParam: intentParam,
      executeMode: insightIntent.ExecuteMode.UI_ABILITY_FOREGROUND,
    };

    try {
      insightIntentDriver.execute(param, (error: BusinessError, data: insightIntent.ExecuteResult) => {
        if (error) {
          logger.info(TAG, `executeUIAbilityForeground failed with ${JSON.stringify(error)}`);
        } else {
          logger.info(TAG, 'executeUIAbilityForeground succeed');
        }
        logger.info(TAG, `executeUIAbilityForeground result ${JSON.stringify(data)}`);
        this.executeResult = data;
      });
    } catch (error) {
      logger.info(TAG, `executeUIAbilityForeground error caught ${JSON.stringify(error)}`);
      this.executeResult = {
        code: -1,
        result: { 'error': JSON.stringify(error) }
      }
    }
  }
  executeServiceExtension = (): void => {
    let intentParam: Record<string, Object> = {
      'songName': 'City Of Stars',
    };
    let param: insightIntentDriver.ExecuteParam = {
      bundleName: 'com.samples.intentdriver',
      moduleName: 'entry',
      abilityName: 'ServiceExtAbility',
      insightIntentName: 'PlayMusic',
      insightIntentParam: intentParam,
      executeMode: insightIntent.ExecuteMode.SERVICE_EXTENSION_ABILITY,
    };

    try {
      insightIntentDriver.execute(param, (error: BusinessError, data: insightIntent.ExecuteResult) => {
        if (error) {
          logger.info(TAG, `executeServiceExtension failed with ${JSON.stringify(error)}`);
        } else {
          logger.info(TAG, 'executeServiceExtension succeed');
        }
        logger.info(TAG, `executeServiceExtension result ${JSON.stringify(data)}`);
        this.executeResult = data;
      })
    } catch (error) {
      logger.info(TAG, `executeServiceExtension error caught ${JSON.stringify(error)}`);
      this.executeResult = {
        code: -1,
        result: { 'error': JSON.stringify(error) }
      }
    }
  }
}

export let playMusicIntentDriver = new PlayMusicIntentDriver();