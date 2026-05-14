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
// 构造单例对象
export class GlobalContext {
  public static dbHelper: Object | undefined = undefined;
  public static thisContext: Object | undefined = undefined;
  private static instance: GlobalContext | null = null;
  private context = new Map<string, Object>();
  private properties = new Map<string, string>();

  private constructor() {
  }

  public static getContext(): GlobalContext {
    if (GlobalContext.instance === null) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  getObject(value: string): object | undefined {
    return this.context.get(value);
  }

  setObject(key: string, objectClass: object | undefined): void {
    if (objectClass !== undefined) {
      this.context.set(key, objectClass);
    }
  }

  getProperty(key: string): string | undefined {
    return this.properties.get(key);
  }

  setProperty(key: string, value: string): void {
    this.properties.set(key, value);
  }
}