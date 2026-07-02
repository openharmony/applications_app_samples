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
 * @namespace LogCatcher
 * @since 10
 */
declare namespace LogCatcher {
  /**
   * catch system log
   *
   * @param { string }  bundleName bundle name
   * @param { (result: number, resultPath: string) => void }  callback the callback of result file path
   * @since 10
   */
  function catchLog(bundleName: string, uid: string, timestamp: number, type: number, callback: (result: number, resultPath: string) => void);

  /**
   * catch system log
   * 
   * @param { string }  bundleName bundle name
   * @returns { Promise<string> } Returns result file path.
   *
   * @since 10
   */
  function catchLog(bundleName: string, uid: string, timestamp: number, type: number) : Promise<string>;
}

export default LogCatcher;
