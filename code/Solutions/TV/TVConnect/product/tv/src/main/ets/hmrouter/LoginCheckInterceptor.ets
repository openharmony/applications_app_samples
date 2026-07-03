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

import {
  HMActionType,
  HMInterceptor,
  HMInterceptorAction,
  HMInterceptorInfo,
  HMRouterMgr,
  IHMInterceptor
} from '@hadss/hmrouter';
import { Logger, LoginEvent } from '@ohos/common';

@HMInterceptor({ interceptorName: 'LoginCheckInterceptor' })
export class LoginCheckInterceptor implements IHMInterceptor {
  handle(info: HMInterceptorInfo): HMInterceptorAction {
    let isLogin = AppStorage.get<boolean>(LoginEvent.LOGIN_STORAGE);
    Logger.debug('AppRouter',
      `LoginInterceptor srcName=${info.srcName} targetName=${info.targetName} type=${info.type} isLogin=${isLogin}`);
    if (info.type == HMActionType.POP) {
      return HMInterceptorAction.DO_NEXT;
    }
    if (isLogin == true) {
      return HMInterceptorAction.DO_NEXT;
    } else {
      HMRouterMgr.push({
        pageUrl: 'AccountLoginPagePage',
        skipAllInterceptor: true
      });
      return HMInterceptorAction.DO_REJECT;
    }
  }
}