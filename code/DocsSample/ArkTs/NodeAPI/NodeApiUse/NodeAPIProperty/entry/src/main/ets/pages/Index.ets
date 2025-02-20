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
import { napiDeleteProperty } from './napiDeleteProperty';
import { napiHasOwnProperty } from './napiHasOwnProperty';

@Entry
@Component
struct Index {
  @State result: string = ''
  private items: string[] = [
    'Reset Result Message',
    '1.napiGetPropertyNames',
    '2.napiSetProperty',
    '3.napiGetProperty',
    '4.napiHasProperty',
    '5.napiDeleteProperty',
    '6.napiHasOwnProperty',
    '7.napiSetNamedProperty',
    '8.napiGetNamedProperty',
    '9.napiHasNamedProperty',
    '10.napiDefineProperties',
    '11.napiGetAllPropertyNames'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 4 })
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
                } else if (item === '1.napiGetPropertyNames') {
                  // napi_get_property_names
                  try {
                    class Obj {
                      public data: number = 0
                      public message: string = ''
                    }

                    let obj: Obj = { data: 0, message: 'hello world' };
                    let propertyNames = testNapi.getPropertyNames(obj);
                    if (Array.isArray(propertyNames) && propertyNames.length > 0) {
                      hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_property_names: %{public}s',
                        propertyNames[0]);
                      hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_property_names: %{public}s',
                        propertyNames[1]);
                      this.result = 'napiGetPropertyNamesSuccess';
                    }
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_get_property_names error: %{public}s',
                      error.message);
                    this.result = 'napiGetPropertyNamesFail';
                  }
                } else if (item === '2.napiSetProperty') {
                  // napi_set_property
                  try {
                    class Obj {
                      public data: number = 0
                      public message: string = ''
                    }

                    let obj: Obj = { data: 0, message: 'hello world' };
                    let result = testNapi.setProperty(obj, 'code', 'hi');
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_set_property: %{public}s',
                      JSON.stringify(result));
                    this.result = 'napiSetPropertySuccess';
                  } catch (error) {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_set_property error: %{public}s', error.message);
                    this.result = 'napiSetPropertyFail';
                  }
                } else if (item === '3.napiGetProperty') {
                  // napi_get_property
                  try {
                    class Obj {
                      public data: number = 0
                      public message: string = ''
                    }

                    let obj: Obj = { data: 0, message: 'hello world' };
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_property: %{public}s',
                      testNapi.getProperty(obj, 'message'));
                    this.result = 'napiGetPropertySuccess';
                  } catch (error) {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_property error: %{public}s', error.message);
                    this.result = 'napiGetPropertyFail';
                  }
                } else if (item === '4.napiHasProperty') {
                  // napi_has_property
                  try {
                    class Obj {
                      public data: number = 0
                      public message: string = ''
                    }

                    let obj: Obj = { data: 0, message: 'hello world' };
                    let resultFalse = testNapi.hasProperty(obj, 0);
                    let resultTrue = testNapi.hasProperty(obj, 'data');
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_has_property: %{public}s',
                      JSON.stringify(resultFalse));
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_has_property: %{public}s',
                      JSON.stringify(resultTrue));
                    this.result = 'napiHasPropertySuccess';
                  } catch (error) {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_has_property error: %{public}s', error.message);
                    this.result = 'napiHasPropertyFail';
                  }
                } else if (item === '5.napiDeleteProperty') {
                  // napi_delete_property
                  napiDeleteProperty();
                  this.result = 'napiDeletePropertySuccess';
                } else if (item === '6.napiHasOwnProperty') {
                  // napi_has_own_property
                  napiHasOwnProperty();
                  this.result = 'napiHasOwnPropertySuccess';
                } else if (item === '7.napiSetNamedProperty') {
                  // napi_set_named_property
                  let obj = testNapi.napiSetNamedProperty('myProperty');
                  let objAsString = JSON.stringify(obj);
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_set_named_property: %{public}s', objAsString);
                  this.result = 'napiSetNamedPropertySuccess';
                } else if (item === '8.napiGetNamedProperty') {
                  // napi_get_named_property
                  interface NestedObj {
                    nestedStr: string;
                    nestedNum: number;
                  }

                  class Obj {
                    public str: string = '';
                    public num: number = 0;
                    public bol: boolean = false;
                    public nestedObj: NestedObj = { nestedStr: '', nestedNum: 0 };
                  }

                  let obj: Obj = {
                    str: 'bar',
                    num: 42,
                    bol: true,
                    nestedObj: { nestedStr: 'nestedValue', nestedNum: 123 }
                  };
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_named_property : %{public}s',
                    testNapi.napiGetNamedProperty(obj, 'str'));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_named_property : %{public}d',
                    testNapi.napiGetNamedProperty(obj, 'num'));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_named_property : %{public}s',
                    testNapi.napiGetNamedProperty(obj, 'bol'));
                  let nestedObj = testNapi.napiGetNamedProperty(obj, 'nestedObj');
                  let objAsString = JSON.stringify(nestedObj);
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_named_property : %{public}s', objAsString);
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_named_property : %{public}s',
                    testNapi.napiGetNamedProperty(obj, 'null'));
                  this.result = 'napiGetNamedPropertySuccess';
                } else if (item === '9.napiHasNamedProperty') {
                  // napi_has_named_property
                  interface NestedObj {
                    nestedStr: string;
                    nestedNum: number;
                  }

                  class Obj {
                    public str: string = '';
                    public num: number = 0;
                    public bol: boolean = false;
                    public nestedObj: NestedObj = { nestedStr: '', nestedNum: 0 };
                  }

                  let obj: Obj = {
                    str: 'bar',
                    num: 42,
                    bol: true,
                    nestedObj: { nestedStr: 'nestedValue', nestedNum: 123 }
                  };
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_has_named_property : %{public}s',
                    testNapi.napiHasNamedProperty(obj, 'str'));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_has_named_property : %{public}s',
                    testNapi.napiHasNamedProperty(obj, 'nestedStr'));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_has_named_property : %{public}s',
                    testNapi.napiHasNamedProperty(obj, 'bol'));
                  this.result = 'napiHasNamedPropertySuccess';
                } else if (item === '10.napiDefineProperties') {
                  // napi_define_properties
                  // 定义method类型的属性
                  hilog.info(0x0000, 'testTag', 'Test Node-API define_method_properties:%{public}d',
                    testNapi.defineMethodProperties()
                      .defineMethodPropertiesExample());
                  // 定义string类型的属性
                  hilog.info(0x0000, 'testTag', 'Test Node-API define_string_properties::%{public}s ',
                    testNapi.defineStringProperties()
                      .defineStringPropertiesExample);
                  // getter和setter
                  hilog.info(0x0000, 'testTag', 'Test Node-API get::%{public}s ',
                    testNapi.createStringWithGetterSetter()
                      .getterCallback());
                  hilog.info(0x0000, 'testTag', 'Test Node-API setter::%{public}s ',
                    testNapi.createStringWithGetterSetter()
                      .setterCallback('set data'));
                  this.result = 'napiDefinePropertiesSuccess';
                } else if (item === '11.napiGetAllPropertyNames') {
                  // napi_get_all_property_names
                  try {
                    class Obj {
                      public data: number = 0
                      public message: string = ''
                    }

                    let obj: Obj = { data: 0, message: 'hello world' };
                    let propertyNames = testNapi.getAllPropertyNames(obj);
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_all_property_names: %{public}s',
                      JSON.stringify(propertyNames));
                    this.result = 'napiGetAllPropertyNamesSuccess';
                  } catch (error) {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_all_property_names error: %{public}s',
                      error.message);
                    this.result = 'napiGetAllPropertyNamesFail';
                  }
                }
              })
          }
        })
      }.scrollBar(BarState.Off)
      .width('90%')
      .id('List')
    }.width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding({ top: 5 })
  }
}