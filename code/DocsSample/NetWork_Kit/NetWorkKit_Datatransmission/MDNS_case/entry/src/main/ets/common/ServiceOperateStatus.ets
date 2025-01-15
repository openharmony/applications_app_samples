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

export function resourceToString(resource: Resource): string {
  return getContext().resourceManager.getStringSync(resource);
}

interface  ServiceOperateStatus {
  ADD_SUCCESS: string;
  ADD_FAIL: string;
  ADDING: string;
  RESOLVE_SUCCESS: string;
  RESOLVE_FAIL: string;
  RESOLVING: string;
  REMOVE_SUCCESS: string;
  REMOVE_FAIL: string;
  REMOVING: string;
  DISCOVERY_STARTED: string;
  DISCOVERY_FAIL1: string;
  DISCOVERY_FAIL2: string;
  DISCOVERY_FAIL3: string;
  DISCOVERY_STARTING: string;
  STOPPED: string;
  STOP_FAIL: string;
  STOPPING: string;
}

export const serviceOperateStatus:ServiceOperateStatus  = {
  ADD_SUCCESS: resourceToString($r('app.string.ADD_SUCCESS')),
  ADD_FAIL: resourceToString($r('app.string.ADD_FAIL')),
  ADDING: resourceToString($r('app.string.ADDING')),
  RESOLVE_SUCCESS: resourceToString($r('app.string.RESOLVE_SUCCESS')),
  RESOLVE_FAIL: resourceToString($r('app.string.RESOLVE_FAIL')),
  RESOLVING: resourceToString($r('app.string.RESOLVING')),
  REMOVE_SUCCESS: resourceToString($r('app.string.REMOVE_SUCCESS')),
  REMOVE_FAIL: resourceToString($r('app.string.REMOVE_FAIL')),
  REMOVING: resourceToString($r('app.string.REMOVING')),
  DISCOVERY_STARTED: resourceToString($r('app.string.DISCOVERY_STARTED')),
  DISCOVERY_FAIL1: resourceToString($r('app.string.DISCOVERY_FAIL1')),
  DISCOVERY_FAIL2: resourceToString($r('app.string.DISCOVERY_FAIL2')),
  DISCOVERY_FAIL3: resourceToString($r('app.string.DISCOVERY_FAIL3')),
  DISCOVERY_STARTING: resourceToString($r('app.string.DISCOVERY_STARTING')),
  STOPPED: resourceToString($r('app.string.STOPPED')),
  STOP_FAIL: resourceToString($r('app.string.STOP_FAIL')),
  STOPPING: resourceToString($r('app.string.STOPPING'))
};