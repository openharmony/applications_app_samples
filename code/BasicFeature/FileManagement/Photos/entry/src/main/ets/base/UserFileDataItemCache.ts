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

import { UserFileDataItem } from './UserFileDataItem';
import { stashOrGetObject } from '../utils/SingleInstanceUtils';

const TAG = 'UserFileDataItemCache';

class UserFileDataItemCache {
    private userFileDataItemMap = new Map<string, UserFileDataItem>();

    hasKey(key: string): boolean {
        return this.userFileDataItemMap.has(key);
    }

    deleteKey(key: string): boolean {
        return this.userFileDataItemMap.delete(key);
    }

    set(key: string, value: UserFileDataItem): void {
        this.userFileDataItemMap.set(key, value);
    }

    get(key: string): UserFileDataItem {
        return this.userFileDataItemMap.get(key);
    }

    clearAll(): void {
        this.userFileDataItemMap.clear();
    }
}

export let userFileDataItemCache: UserFileDataItemCache = stashOrGetObject<UserFileDataItemCache>(new UserFileDataItemCache(), TAG);
