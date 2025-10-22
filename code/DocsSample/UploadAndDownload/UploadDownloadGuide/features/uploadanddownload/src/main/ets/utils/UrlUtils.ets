/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import preferences from '@ohos.data.preferences';
import { logger } from './Logger';
import { BusinessError} from '@kit.BasicServicesKit';

const TAG: string = 'UrlUtils';
const URL_KEY: string = 'url';
const STORE_NAME: string = 'server_url';
const DEFAULT_SERVER_URL: string = 'http://192.168.1.1/';

class UrlUtil {
  async getUrl(context: common.UIAbilityContext): Promise<string> {
    let url = '';
    try {
      let preference = await preferences.getPreferences(context, STORE_NAME);
      url = await preference.get(URL_KEY, '') as string;
      if (url == '') {
        url = DEFAULT_SERVER_URL;
        logger.info(TAG, 'config url is null');
      }
      logger.info(TAG, `getUrl,url= ${url}`);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      logger.error(TAG, `Get url error, code= ${err.code}, message=${err.message}`);
    }
    return url;
  }

  async saveUrl(context: common.UIAbilityContext, url: string) {
    try {
      let preference = await preferences.getPreferences(context, STORE_NAME);
      await preference.put(URL_KEY, url);
      await preference.flush();
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      logger.error(TAG, `Save url error, code= ${err.code}, message=${err.message}`);
    }
  }
}

export const urlUtils = new UrlUtil();
