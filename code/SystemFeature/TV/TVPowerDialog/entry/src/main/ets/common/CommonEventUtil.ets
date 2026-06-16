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
import commonEvent from '@ohos.commonEventManager';
import Logger from './Logger';

export function commonEventPowerDataFunc(powerBoolean: boolean) {
  let commonEventData: commonEvent.CommonEventPublishData = {
    parameters: {
      powerBoolean: powerBoolean,
    }
  };
  try {
    commonEvent.publish('powerBoolean', commonEventData, (err) => {
      Logger.info('onSystemEvent powerBoolean Err:' + JSON.stringify(err));
    });
  } catch (err) {
    Logger.info('onSystemEvent  powerBoolean catch Err:' + JSON.stringify(err));
  }
}