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

export class LoginEvent {
  public static readonly LOGIN_STORAGE = 'LOGIN_STORAGE';
  public static readonly LOGIN_EVENT = 'LOGIN_EVENT';
  public static readonly APP_LOGIN = 'APP_LOGIN';
  public static readonly APP_OUT_LOGIN = 'APP_OUT_LOGIN';

  public static appSetLoginState() {
    AppStorage.setOrCreate(LoginEvent.LOGIN_STORAGE, UserLibraryDao.getIsLogin());
  }

  public static sendLoginEvent() {
    AppStorage.set(LoginEvent.LOGIN_STORAGE, true);
    let option: commonEventManager.CommonEventPublishData = {
      data: LoginEvent.APP_LOGIN
    };
    commonEventManager.publish(LoginEvent.LOGIN_EVENT, option, () => {

    });
  }

  public static sendOutLoginEvent() {
    AppStorage.set(LoginEvent.LOGIN_STORAGE, false);
    let option: commonEventManager.CommonEventPublishData = {
      data: LoginEvent.APP_OUT_LOGIN
    };
    commonEventManager.publish(LoginEvent.LOGIN_EVENT, option, () => {

    });
  }
}