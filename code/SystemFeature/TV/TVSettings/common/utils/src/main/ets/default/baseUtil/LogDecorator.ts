/**
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import LogUtil from './LogUtil';
import ConfigData from './ConfigData';

/**
 * Method log decorator
 */
const LogMethod = (target: Object, methodName: string, propertyDescriptor: PropertyDescriptor): PropertyDescriptor => {
  const method = propertyDescriptor.value;

  propertyDescriptor.value = function (...args: any[]) {
    const params = args.map(a => JSON.stringify(a)).join();
    LogUtil.info(ConfigData.TAG + `${target.constructor.name}#${methodName}(${params}) in `);

    const result = method.apply(this, args);
    const r = JSON.stringify(result);

    LogUtil.info(ConfigData.TAG + `${target.constructor.name}#${methodName}(${params}) out => ${r}`);
    return result;
  }

  return propertyDescriptor;
};

/**
 * Class decorator to log all methods
 */
export const LogAll = (target: any) => {
  Reflect.ownKeys(target.prototype).forEach(propertyKey => {
    let propertyDescriptor: PropertyDescriptor = Object.getOwnPropertyDescriptor(target.prototype, propertyKey);
    const method = propertyDescriptor.value;

    if (method) {
      propertyDescriptor.value = function (...args: any[]) {
        const params = args.map(a => JSON.stringify(a)).join();
        LogUtil.info(ConfigData.TAG + `${target.name}#${propertyKey.toString()}(${params}) in `);

        const result = method.apply(this, args);
        const r = JSON.stringify(result);

        LogUtil.info(ConfigData.TAG + `${target.name}#${propertyKey.toString()}(${params}) out => ${r}`);
        return result;
      }

      Object.defineProperty(target.prototype, propertyKey, propertyDescriptor);
    }
  });
}

export default LogMethod;
