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

import common from '@ohos.app.ability.common';
import commonEventManager from '@ohos.commonEventManager';
import preferences from '@ohos.data.preferences';
import { CommonEventData } from './commonEvent/commonEventData';
import { CommonEventSubscriber } from './commonEvent/commonEventSubscriber';
import { logger } from './Logger';

const TAG: string = 'UrlUtils';
const URL_KEY: string = 'url';
const STORE_NAME: string = 'server_url';
const DEFAULT_SERVER_URL: string = 'http://192.168.1.1/';

class UrlUtil {
  async getUrl(context: common.UIAbilityContext): Promise<string> {
    let preference = await preferences.getPreferences(context, STORE_NAME);
    let url = await preference.get(URL_KEY, '') as string;
    if (url == '') {
      url = DEFAULT_SERVER_URL;
      logger.info(TAG, 'config url is null');
    }
    logger.info(TAG, `getUrl,url= ${url}`);
    return url;
  }

  async saveUrl(context: common.UIAbilityContext, url: string) {
    let preference = await preferences.getPreferences(context, STORE_NAME);
    await preference.put(URL_KEY, url);
    await preference.flush();
  }
}

export const urlUtils = new UrlUtil();
