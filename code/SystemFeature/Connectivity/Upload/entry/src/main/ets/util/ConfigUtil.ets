/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import config from '../config/config'
import data_preferences from '@ohos.data.preferences';

let preferenceIns = null;

export async function getUploadUrl(context: Context): Promise<string> {
  return getConfig(context, ConfigType.uploadUrl)
}

export async function getDownloadListUrl(context: Context): Promise<string> {
  return getConfig(context, ConfigType.downloadListUrl)
}

export async function saveConfig(context: Context, type: ConfigType, value: string) {
  if (value == null || value.length == 0 || type == null) {
    return
  }
  let key = null;
  switch (type) {
    case ConfigType.host:
      key = config.HOST_KEY;
      break
    case ConfigType.path:
      key = config.PATH_KEY;
      break
  }
  if (key != null) {
    const pref = await getPreferences(context)
    await pref.put(key, value)
  }
}

export async function getConfig(context: Context, type: ConfigType): Promise<string> {
  //先从preference读取，没有得话，从config.ets获取
  const pref = await getPreferences(context)
  switch (type) {
    case ConfigType.host:
      return await pref.get(config.HOST_KEY, config.HOST_DEFAULT)
    case ConfigType.path:
      return await pref.get(config.PATH_KEY, config.PATH_DEFAULT)
    case ConfigType.baseUrl:
      const host = await getConfig(context, ConfigType.host)
      const path = await getConfig(context, ConfigType.path)
      return host + path;
    case ConfigType.uploadUrl:
      return await getConfig(context, ConfigType.baseUrl)
    case ConfigType.downloadListUrl:
      const baseUrl = await getConfig(context, ConfigType.baseUrl)
      return baseUrl + config.QUERY_FILE_PATH
    default:
      return ""
  }
}


async function getPreferences(context: Context) {
  if (preferenceIns == null) {
    preferenceIns = await data_preferences.getPreferences(context, config.PREFERENCES_NAME)
  }
  return preferenceIns;
}

export enum ConfigType {
  host,
  path,
  baseUrl,
  uploadUrl,
  downloadListUrl
}