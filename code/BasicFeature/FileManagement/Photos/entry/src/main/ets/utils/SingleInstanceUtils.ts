/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { Log } from './Log';
import { GlobalContext } from '../common/GlobalContext';

const TAG = 'SingleInstanceHelper';
let globalThis = GlobalContext.getContext();

export function stashOrGetObject<T>(objectClass: object, storageKey: string): T {
  if (!new Boolean(globalThis.getObject(storageKey)).valueOf()) {
    globalThis.setObject(storageKey, objectClass);
    Log.debug(TAG, 'Create key of ' + storageKey);
  }
  return globalThis.getObject(storageKey) as T;
}
