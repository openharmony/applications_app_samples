/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start testOne_one]
// TestArray.js
{
  let arr = [10, 20, 30, 40];
  function replacer(key, value) {
    if (key === '2') {
        return value * 2;
    }
    return value;
  }
  console.info(JSON.stringify(arr, replacer));
  // 实际输出：[10,20,30,40]
}
// [End testOne_one]

// [Start testOne_two]
// TestArray.js
{
  let arr = [10, 20, 30, 40];
  function replacer(key, value) {
    if (typeof key === 'number') {
      key = String(key);
    }
    if (key === '2') {
        return value * 2;
    }
    return value;
  }
  console.info(JSON.stringify(arr, replacer));
  // 实际输出：[10,20,60,40]
}
// [End testOne_two]

// [Start test_rangeError]
// TestArray.js
const typedArr = new Uint8Array([10, 20, 30]);
try {
  const result = Object.entries(typedArr);
  console.info('no error throw');
} catch(e) {
  console.info(e);
}
// 期望输出：no error throw
// 实际输出: RangeError: object entries is not supported IsJSUint8Array or IsJSUint16Array
// [End test_rangeError]

// [Start test_nothrow]
// TestArray.js
const typedArr = new Uint8Array([10, 20, 30]);
try {
  const normalArr1 = Array.from(typedArr);
  const result = Object.entries(normalArr1);
  console.info('no error throw');
} catch(e) {
  console.info(e);
}
// 输出：no error throw
// [End test_nothrow]

// [Start testThree_one]
// TestArray.js
{
  let handler = {
    get(target, key) {
      console.info('get', key, typeof key);
      return Reflect.get(target, key);
    },
    set(target, key, value) {
      console.info('set', key, typeof key);
      return Reflect.set(target, key, value);
    },
    deleteProperty(target, key) {
      console.info('delete', key, typeof key);
      return Reflect.deleteProperty(target, key);
    },
    has(target, key) {
      console.info('has', key, typeof key);
      return Reflect.has(target, key);
    }
  }
  let obj = {};
  let px = new Proxy(obj, handler);
  px[1];
  // 实际输出：get 1 number
  px[2] = 2;
  // 实际输出：set 2 number
  3 in px;
  // 实际输出：has 3 number
  delete px[2];
  // 实际输出：delete 2 number
}
// [End testThree_one]

// [Start testThree_two]
// TestArray.js
{
  let handler = {
    get(target, key) {
      if (typeof key === 'number') {
        key = String(key);
      }
      console.info('get', key, typeof key);
      return Reflect.get(target, key);
    },
    set(target, key, value) {
      if (typeof key === 'number') {
        key = String(key);
      }
      console.info('set', key, typeof key);
      return Reflect.set(target, key, value);
    },
    deleteProperty(target, key) {
      if (typeof key === 'number') {
        key = String(key);
      }
      console.info('delete', key, typeof key);
      return Reflect.deleteProperty(target, key);
    },
    has(target, key) {
      if (typeof key === 'number') {
        key = String(key);
      }
      console.info('has', key, typeof key);
      return Reflect.has(target, key);
    }
  }
  let obj = {};
  let px = new Proxy(obj, handler);
  px[1];
  // 实际输出：get 1 string
  px[2] = 2;
  // 实际输出：set 2 string
  3 in px;
  // 实际输出：has 3 string
  delete px[2];
  // 实际输出：delete 2 string
}
// [End testThree_two]
