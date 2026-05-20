/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import { napiGetPrototype } from './napiGetPrototype';

// 定义一个类
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

@Entry
@Component
struct Index {
  @State result: string = ''
  private items: string[] = [
    'Reset Result Message',
    '1.napiGetPrototype',
    '2.napiCreateObject',
    '3.napiObjectFreeze',
    '4.napiObjectSeal',
    '5.napiTypeOf',
    '6.napiInstanceOf',
    '7.napiTypeTagObject',
    '8.napiCreateExternal',
    '9.napiGetValueExternal',
    '10.napiCreateSymbol'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 3 })
      List({ space: '10vp' }) {
        ForEach(this.items, (item: string) => {
          ListItem() {
            Text(item)
              .fontSize(16)
              .width('100%')
              .height(60)
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Bold)
              .borderRadius(30)
              .backgroundColor(Color.White)
              .onClick(() => {
                if (item === 'Reset Result Message') {
                  this.result = '';
                } else if (item === '1.napiGetPrototype') {
                  napiGetPrototype();
                  this.result = 'napiGetPrototypeSuccess';
                } else if (item === '2.napiCreateObject') {
                  // [Start ark_napi_create_object]
                  // napi_create_object
                  try {
                    const myObject = testNapi.createObject();
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_object: %{public}s', myObject.name);
                    // [StartExclude ark_napi_create_object]
                    this.result = 'napiCreateObjectSuccess';
                    // [EndExclude ark_napi_create_object]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_create_object errorCode: %{public}s, errorMessage: %{public}s', error.code,
                      error.message);
                    // [StartExclude ark_napi_create_object]
                    this.result = 'napiCreateObjectFail';
                    // [EndExclude ark_napi_create_object]
                  }
                  // [End ark_napi_create_object]
                } else if (item === '3.napiObjectFreeze') {
                  // [Start ark_napi_object_freeze]
                  // napi_object_freeze
                  try {
                    class Obj {
                      public data: number = 0
                      public message: string = ''
                    }

                    let obj: Obj = { data: 0, message: 'hello world' };
                    let objFreeze = testNapi.objectFreeze(obj);
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_object_freeze: %{public}s', (objFreeze.data = 1));
                    // [StartExclude ark_napi_object_freeze]
                    this.result = 'napiObjectFreezeSuccess';
                    // [EndExclude ark_napi_object_freeze]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_object_freeze error: %{public}s', error.message);
                    // [StartExclude ark_napi_object_freeze]
                    this.result = 'napiObjectFreezeFail';
                    // [EndExclude ark_napi_object_freeze]
                  }
                  // [End ark_napi_object_freeze]
                } else if (item === '4.napiObjectSeal') {
                  // [Start ark_napi_object_seal]
                  // napi_object_seal
                  try {
                    class Obj {
                      public data: number = 0
                      public message: string = ''
                      // 可选属性
                      public address?: number = 0
                    }

                    let obj: Obj = { data: 0, message: 'hello world' };
                    let objSeal = testNapi.objectSeal(obj);
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_object_seal: %{public}s', objSeal.message);
                    objSeal.data = 1;
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_object_seal: %{public}d', objSeal.data);
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_object_seal: %{public}d', (objSeal.id = 1));
                    // [StartExclude ark_napi_object_seal]
                    this.result = 'napiObjectSealSuccess';
                    // [EndExclude ark_napi_object_seal]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_object_seal error: %{public}s', error.message);
                    // [StartExclude ark_napi_object_seal]
                    this.result = 'napiObjectSealFail';
                    // [EndExclude ark_napi_object_seal]
                  }
                  // [End ark_napi_object_seal]
                } else if (item === '5.napiTypeOf') {
                  // [Start ark_napi_typeof]
                  // napi_typeof
                  try {
                    let varUndefined: undefined;
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_typeof: %{public}s',
                      testNapi.napiTypeOf(varUndefined));
                    let varNull: null = null;
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_typeof: %{public}s',
                      testNapi.napiTypeOf(varNull));
                    let varTrue = true;
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_typeof: %{public}s',
                      testNapi.napiTypeOf(varTrue));
                    let varNum = 1;
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_typeof: %{public}s',
                      testNapi.napiTypeOf(varNum));
                    let varString = 'str';
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_typeof: %{public}s',
                      testNapi.napiTypeOf(varString));

                    class Obj {
                      public id: number = 0
                      public name: string = ''
                    }

                    let varObject: Obj = { id: 1, name: 'LiLei' };
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_typeof: %{public}s',
                      testNapi.napiTypeOf(varObject));
                    const addNum = (a: number, b: number): number => a * b;
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_typeof: %{public}s',
                      testNapi.napiTypeOf(addNum));
                    let varBigint = BigInt('1234567890123456789012345678901234567890');
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_typeof: %{public}s',
                      testNapi.napiTypeOf(varBigint));
                    // [StartExclude ark_napi_typeof]
                    this.result = 'napiTypeOfSuccess';
                    // [EndExclude ark_napi_typeof]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_typeof error: %{public}s', error.message);
                    // [StartExclude ark_napi_typeof]
                    this.result = 'napiTypeOfFail';
                    // [EndExclude ark_napi_typeof]
                  }
                  // [End ark_napi_typeof]
                } else if (item === '6.napiInstanceOf') {
                  // [Start ark_napi_instanceof]
                  // napi_instanceof
                  try {
                    class Person {
                      public name: string;
                      public age: number;

                      constructor(name: string, age: number) {
                        this.name = name;
                        this.age = age;
                      }
                    }

                    const person = new Person('Alice', 30);

                    class Obj {
                      public data: number = 0
                      public message: string = ''
                    }

                    let obj: Obj = { data: 0, message: 'hello world' };
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_instanceof: %{public}s',
                      testNapi.napiInstanceOf(person, Person));
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_instanceof: %{public}s',
                      testNapi.napiInstanceOf(obj, Person));
                    // [StartExclude ark_napi_instanceof]
                    this.result = 'napiInstanceOfSuccess';
                    // [EndExclude ark_napi_instanceof]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_instanceof error: %{public}s', error.message);
                    // [StartExclude ark_napi_instanceof]
                    this.result = 'napiInstanceOfFail';
                    // [EndExclude ark_napi_instanceof]
                  }
                  // [End ark_napi_instanceof]
                } else if (item === '7.napiTypeTagObject') {
                  // [Start ark_napi_type_tag_object]
                  // napi_type_tag_object and napi_check_object_type_tag
                  class Obj {
                    public data: number = 0
                    public message: string = ''
                  }

                  let objA: Obj = { data: 0, message: 'hello world' };
                  let objB: Obj = { data: 10, message: 'typeTag' };
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_type_tag_object objA -> 0: %{public}s',
                    testNapi.setTypeTagToObject(objA, 0));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_type_tag_object objB -> 0: %{public}s',
                    testNapi.setTypeTagToObject(objB, 0));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_check_object_type_tag objA -> 0: %{public}s',
                    testNapi.checkObjectTypeTag(objA, 0));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_check_object_type_tag objB -> 1: %{public}s',
                    testNapi.checkObjectTypeTag(objB, 1));
                  // [End ark_napi_type_tag_object]
                  this.result = 'napiTypeTagObjectSuccess';
                } else if (item === '8.napiCreateExternal') {
                  // [Start ark_napi_create_external]
                  // napi_create_external
                  const externalData = testNapi.createExternal();
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_external:%{public}s',
                    testNapi.getExternalType(externalData));
                  // [End ark_napi_create_external]
                  this.result = 'napiCreateExternalSuccess';
                } else if (item === '9.napiGetValueExternal') {
                  // [Start ark_napi_get_value_external]
                  // napi_get_value_external
                  hilog.info(0x0000, 'Node-API', 'get_value_external:%{public}d', testNapi.getValueExternal());
                  // [End ark_napi_get_value_external]
                  this.result = 'napiGetValueExternalSuccess';
                } else if (item === '10.napiCreateSymbol') {
                  // [Start ark_napi_create_symbol]
                  // napi_create_symbol
                  let varSymbol = testNapi.createSymbol();
                  hilog.info(0x0000, 'Node-API', 'createSymbol:%{public}s', typeof varSymbol);
                  // [End ark_napi_create_symbol]
                  this.result = 'napiCreateSymbolSuccess';
                }
              })
          }
        })
      }.scrollBar(BarState.Off)
      .width('90%')
    }.width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding({ top: 5 })
  }
}
