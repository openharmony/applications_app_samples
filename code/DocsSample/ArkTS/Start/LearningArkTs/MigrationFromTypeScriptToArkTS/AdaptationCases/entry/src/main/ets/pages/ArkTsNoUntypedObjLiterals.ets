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

// [Start specifying_object_literal_type_for_type_imports]
import { image } from '@kit.ImageKit';
// [StartExclude specifying_object_literal_type_for_type_imports]
// [Start obtaining_the_type]
// app.ets
import test from './test';

let option: test.I = { id: '', type: 0 };
test.foo('', option);
// [End obtaining_the_type]
// [EndExclude specifying_object_literal_type_for_type_imports]
const area: image.PositionArea = { // 写明具体类型
  pixels: new ArrayBuffer(8),
  offset: 0,
  stride: 8,
  region: { size: { height: 1, width: 2 }, x: 0, y: 0 }
}
// [End specifying_object_literal_type_for_type_imports]
{
  // [Start remove_the_constructor]
  // 去除构造函数
  class Test {
    public value: number = 1
  }

  let t: Test = { value: 2 };
  // [End remove_the_constructor]
}

{
  // [Start use_new]
  // 使用new
  class Test {
    public value: number = 1

    constructor(value: number) {
      this.value = value;
    }
  }

  let t: Test = new Test(2);
  // [End use_new]
}

{
  // [Start using_an_identifier_as_the_object]
  class Test {
    public value: number = 0
  }
  let arr: Test[] = [
    {
      value: 1
    },
    {
      value: 2
    },
    {
      value: 3
    }
  ]
  // [End using_an_identifier_as_the_object]
}

{
  // [Start using_a_string_as_the_object]
  let obj: Record<string, number | string> = {
    'value': 123,
    'name': 'abc'
  }
  // [End using_a_string_as_the_object]
}
// [Start include_index_signature]
function foo(obj: Record<string, string>): string {
  if (obj != undefined && obj != null) {
    return obj.value1 + obj.value2;
  }
  return '';
}
// [End include_index_signature]
{
  // [Start include_object_literals]
  class T {
    public value: number = 0
    public name: string = ''
  }

  (fn: (v: T) => void) => {
    fn({ value: 123, name: '' });
  }
  // [End include_object_literals]
}

{
  // [Start include_method]
  interface T {
    foo: (value: number) => number
  }

  let t:T = { foo: (value) => { return value } };
  // [End include_method]
}

{
  // [Start include_method_two]
  class T {
    public foo: (value: number) => number = (value: number) => {
      return value;
    }
  }

  let t:T = new T();
  // [End include_method_two]
}

// [Start export_default_object]
class Test {
  onCreate() {
    // ...
  }
  onDestroy() {
    // ...
  }
}

export default new Test()
// [End export_default_object]
// [Start passing_parameters]
function emit(event: string, ...args: Object[]): void {}

let emitArg: Record<string, number | boolean> = {
  'action': 11,
  'outers': false
}

emit('', emitArg);
// [End passing_parameters]
