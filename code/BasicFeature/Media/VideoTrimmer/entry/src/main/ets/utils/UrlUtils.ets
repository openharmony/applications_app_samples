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

import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { logger } from './Logger';

const TAG: string = 'videoTrimmer_UrlUtils';
const URL_KEY: string = 'url';
const STORE_NAME: string = 'server_url';

/**
 * 上传下载地址管理类
 */
class UrlUtil {
  /**
   * 获取上传下载地址
   */
  async getUrl(context: common.UIAbilityContext): Promise<string> {
    let preference = await preferences.getPreferences(context, STORE_NAME);
    let url = await preference.get(URL_KEY, '') as string;
    logger.info(TAG, `getUrl,url= ${url}`);
    return url;
  }

  /**
   * 设置保存上传下载地址
   */
  async saveUrl(context: common.UIAbilityContext, url: string) {
    let preference = await preferences.getPreferences(context, STORE_NAME);
    await preference.put(URL_KEY, url);
    await preference.flush();
    logger.info(TAG, `saveUrl,url= ${url}`);
  }
}

export const urlUtils = new UrlUtil();
