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

'use shared'

@Sendable
export default class Handle {
  private static instance: Handle = new Handle;
  static getInstance(): Handle {
    // 返回单例对象
    return Handle.instance;
  }

  static syncGet(): void {
    // 同步Get方法
  }

  static syncSet(num: number): number {
    // 模拟同步步骤1
    console.info('taskpool: this is 1st print!');
    // 模拟同步步骤2
    console.info('taskpool: this is 2nd print!');
    return ++num;
  }

  static syncSet2(num: number): number {
    // 模拟同步步骤1
    console.info('taskpool: this is syncSet2 1st print!');
    // 模拟同步步骤2
    console.info('taskpool: this is syncSet2 2nd print!');
    return ++num;
  }
}