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

import { sendableModuleTest } from './arkts-sendable-module';
import { imagePreprocessing } from './cpu-intensive-task';
import { ioTaskTest } from './io-intensive-task';
import { singleIoTest } from './single-io-development';
import { syncTaskTest } from './sync-task-development';
import { asyncConcurrencyTest } from './async-concurrency-overview';

type TestFunction = (() => string | Promise<string>);
type TestList = [name: string, func: TestFunction][];
let allTests: TestList = [
  ['arkts-utils/arkts-sendable-module', sendableModuleTest],
  ['arkts-utils/cpu-intensive-task-development', imagePreprocessing],
  ['arkts-utils/io-intensive-task-development', ioTaskTest],
  ['arkts-utils/single-io-development', singleIoTest],
  ['arkts-utils/sync-task-development', syncTaskTest],
  ['arkts-utils/async-concurrency-overview', asyncConcurrencyTest],
];

export function listAllTests(): TestList {
  return allTests;
}

let currentTest: string = allTests[0][0];
export function selectTest(index: number, value: string) {
  currentTest = value;
}

export function startTest(): Promise<string> {
  let item = allTests.find((v) => {
    return v[0] == currentTest;
  });
  if(item != undefined) {
    return new Promise((res) => {
      let v = item![1]();
      res(v);
    })
  } else {
    return Promise.resolve('Error! Selected test is not found.');
  }
}