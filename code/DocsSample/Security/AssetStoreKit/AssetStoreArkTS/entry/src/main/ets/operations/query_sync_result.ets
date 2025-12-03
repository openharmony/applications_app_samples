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

import { sleep } from './common';
// [Start import]
import { asset } from '@kit.AssetStoreKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End import]

export async function querySyncResult(): Promise<string> {
  let result: string = '';
  // [Start query_sync_result]
  let query: asset.AssetMap = new Map();
  asset.querySyncResult(query).then((res: asset.SyncResult) => {
    console.info(`Succeeded in querying sync result: ${JSON.stringify(res)}`);
    // [StartExclude query_sync_result]
    result = 'Succeeded in querying sync result';
    // [EndExclude query_sync_result]
  }).catch((err: BusinessError) => {
    console.error(`Failed to query sync result of Asset. Code is ${err.code}, message is ${err.message}`);
    // [StartExclude query_sync_result]
    result = 'Failed to query sync result of Asset';
    // [EndExclude query_sync_result]
  });
  // [End query_sync_result]
  await sleep(500);
  return result;
}