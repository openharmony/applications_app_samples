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

import LogUtil  from './LogUtil';

export default function catchError(defaultResult: Object): (target: Object, methodName: string,
  descriptor: PropertyDescriptor) => PropertyDescriptor {
  return (target: Object, methodName: string, descriptor: PropertyDescriptor): PropertyDescriptor => {
    LogUtil.log(`${target.constructor.name}, methodName: ${methodName}, defaultResult: ${JSON.stringify(defaultResult)}`);
    const originalMethod = descriptor.value as ((...args: Object[]) => Object);
    descriptor.value = (...args: Object[]): Object => {
      try {
        return originalMethod(...args) as Object;
      } catch (error) {
        LogUtil.error(`${target.constructor.name}, methodName: ${methodName}, error: ${JSON.stringify(error)}`);
        return defaultResult;
      }
    }
    return descriptor;
  };
}
