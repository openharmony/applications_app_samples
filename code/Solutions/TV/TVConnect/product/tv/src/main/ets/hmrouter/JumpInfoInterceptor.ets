/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { HMInterceptorAction, HMInterceptorInfo, IHMInterceptor } from '@hadss/hmrouter';
import { Logger } from '@ohos/common';

export class JumpInfoInterceptor implements IHMInterceptor {
  handle(info: HMInterceptorInfo): HMInterceptorAction {
    Logger.debug('AppRouter', `JumpInfo srcName= ${info.srcName} targetName= ${info.targetName} type= ${info.type}`);
    return HMInterceptorAction.DO_NEXT;
  }
}