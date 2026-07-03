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
import { UserLibraryDao } from '../database/dao/UserLibraryDao';
import commonEventManager from '@ohos.commonEventManager';

export class UserDataEvent {
  public static readonly USER_DATA_IS_CHANGE = 'USER_DATA_IS_CHANGE';

  public static UserDataIsChangeState() {
    AppStorage.setOrCreate(UserDataEvent.USER_DATA_IS_CHANGE, false);
  }

  public static UserDataIsChangeEvent() {
    let isChange = AppStorage.get(UserDataEvent.USER_DATA_IS_CHANGE) as boolean;
    AppStorage.set(UserDataEvent.USER_DATA_IS_CHANGE, !isChange);
  }
}