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

/**
 * Common constants for all features.
 */
export default class PreferenceConstants {
  /**
   * The tag is used to print log.
   */
  public static readonly TAG = '[PreferenceModel]';
  /**
   * The key value of the data store.
   */
  public static readonly KEY_NAME = 'IpDevices';
  /**
   * The name of the data store.
   */
  public static readonly PREFERENCES_NAME = 'IpStore';
  public static readonly PREFERENCE_IP_ARRAY_KEY: string = 'IdArr';
  /**
   * Duration of prompt.
   */
  public static readonly DURATION: number = 3000;
};
