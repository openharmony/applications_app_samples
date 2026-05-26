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
/*
 * json工具类
 * */
export class JsonUtil {
  public static parseToClass<T>(str: string | undefined | null, classTarget: ClassTargetInterface<T>): T | null {
    if (!str || !classTarget) {
      return null;
    }
    const classTar = classTarget.createClassTarget();
    let obj: Record<string, Object> | null = null;
    try {
      obj = JSON.parse(str);
    } catch (error) {
      obj = null;
    }
    if (!obj) {
      return null;
    }
    for (const key of Object.keys(obj)) {
      (classTar as Record<string, Object>)[key] = obj[key];
    }
    return classTar;
  }
}

interface ClassTargetInterface<T> {
  createClassTarget: () => T;
}