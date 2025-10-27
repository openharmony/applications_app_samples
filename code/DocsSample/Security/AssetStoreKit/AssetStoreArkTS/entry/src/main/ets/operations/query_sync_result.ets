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

// [Start query_sync_result]
import { asset } from '@kit.AssetStoreKit';
import { BusinessError } from '@kit.BasicServicesKit';

export async function querySyncResult(): Promise<string> {
  let result: string = '';
  let query: asset.AssetMap = new Map();
  await asset.querySyncResult(query).then((res: asset.SyncResult) => {
    console.info(`Succeeded in querying sync result: ${JSON.stringify(res)}`);
    result = 'Succeeded in querying sync result';
  }).catch((err: BusinessError) => {
    console.error(`Failed to query sync result of Asset. Code is ${err.code}, message is ${err.message}`);
    result = 'Failed to query sync result of Asset';
  });
  return result;
}
// [End query_sync_result]