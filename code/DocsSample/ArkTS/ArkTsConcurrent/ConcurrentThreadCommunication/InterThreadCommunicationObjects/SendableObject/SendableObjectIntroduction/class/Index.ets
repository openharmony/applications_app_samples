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

// [Start example_modify_class]
export { MainPage } from './src/main/ets/components/MainPage';

@Sendable
class SendableTestClass {
  desc: string = 'sendable: this is SendableTestClass ';
  num: number = 5;
  printName() {
    console.info('sendable: SendableTestClass desc is: ' + this.desc);
  }
  get getNum(): number {
    return this.num;
  }
}

let object = new SendableTestClass;
export { object }
// [End example_modify_class]
