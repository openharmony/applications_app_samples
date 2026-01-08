/*
* Copyright (c) 2023-2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License")
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

import basicTest from './basicExampleTest/BasicExample.test';
import executeOrder1 from './basicExampleTest/ExecuteOrder1.test';
import executeOrder2 from './basicExampleTest/ExecuteOrder2.test';
import executeOrder3 from './basicExampleTest/ExecuteOrder3.test';
import executeOrder4 from './basicExampleTest/ExecuteOrder4.test';
import assert from './assertExampleTest/AssertExample.test';
import param from './paramExampleTest/paramExample.test';
import custom from './customExampleTest/customExample.test';
import cover from './coverExampleTest/coverExample.test';
import callBack from './callBackExampleTest/callBackExample.test';
import customAssertTest from './customEexpect/customAssert.test';
import resourceReferenceTest from './resourceReferenceTest/resourceReference.test';
import dataDriver from './dataDriver/DataDriver.test';
import afterReturn from './mock/AfterReturn.test';
import afterThrow from './mock/AfterThrow.test';
import argumentMatchersForAny from './mock/ArgumentMatchersForAny.test';
import argumentMatchersForRegex from './mock/ArgumentMatchersForRegex.test';
import argumentMatchersForString from './mock/ArgumentMatchersForString.test';
import clearMock from './mock/ClearMock.test';
import ignoreMock from './mock/IgnoreMock.test';
import mockStatic from './mock/MockStatic.test';
import mockPrivateFunc from './mock/MockPrivateFunc.test';
import mockProperty from './mock/MockProperty.test';
import returnPromise from './mock/ReturnPromise.test';
import vertify from './mock/Vertify.test';
import vertifyTimes from './mock/VertifyTimes.test';

export default function testsuite() {
  basicTest();
  executeOrder1();
  executeOrder2();
  executeOrder3();
  executeOrder4();
  assert();
  param();
  custom();
  cover();
  callBack();
  customAssertTest();
  resourceReferenceTest();
  dataDriver();
  afterReturn();
  afterThrow();
  argumentMatchersForAny();
  argumentMatchersForRegex();
  argumentMatchersForString();
  clearMock();
  ignoreMock();
  mockStatic();
  mockPrivateFunc();
  mockProperty();
  returnPromise();
  vertify();
  vertifyTimes();
}