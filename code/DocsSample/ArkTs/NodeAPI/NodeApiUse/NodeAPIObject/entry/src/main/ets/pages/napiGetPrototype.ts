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

import testNapi from 'libentry.so';
import { hilog } from '@kit.PerformanceAnalysisKit';

export function napiGetPrototype() {
  class Person {
    // 属性
    name: string;
    age: number;

    // 构造函数
    constructor(name: string, age: number) {
      this.name = name;
      this.age = age;
    }
  }

  //创建类的实例
  const person = new Person('Alice', 30);
  // 传入实例对象，获取该对象的原型
  let applePrototype = testNapi.getPrototype(person);
  // 判断通过testNapi.getPrototype()函数获取到的原型是不是apple的原型
  // 在DevEco Studio 4.1及以后的版本中，由于ArkTS没有原型的概念，因此尝试进行原型赋值或相关操作时，将会触发错误提示'Prototype assignment is not supported (arkts-no-prototype-assignment)'，以下代码需在ts文件中执行
  if (applePrototype === Person.prototype) {
    hilog.info(0x0000, 'Node-API', 'get_prototype_success');
  } else {
    hilog.info(0x0000, 'Node-API', 'get_prototype_fail');
  }
};