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

import { stashOrGetObject } from '../utils/SingleInstanceUtils';

const TAG = 'SelectManager';

class SelectManager {
  private status: Map<string, boolean> = new Map<string, boolean>();

  isSelect(key: string, defaultValue: boolean): boolean {
    if (this.status.has(key)) {
      return this.status.get(key);
    } else {
      return defaultValue;
    }
  }

  setSelect(key: string, value: boolean): void {
    this.status.set(key, value);
  }

  deleteSelect(key: string): void {
    this.status.delete(key);
  }
}

export let selectManager: SelectManager = stashOrGetObject<SelectManager>(new SelectManager(), TAG);
