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

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State result: string = ''
  private items: string[] = [
    'Reset Result Message',
    '1.napiCreateArray',
    '2.napiCreateArrayWithLength',
    '3.napiGetArrayLength',
    '4.napiIsArray',
    '5.napiSetElement',
    '6.napiGetElement',
    '7.napiHasElement',
    '8.napiDeleteElement',
    '9.napiCreateTypedArray',
    '10.napiIsTypedArray',
    '11.napiGetTypedArrayInfo',
    '12.napiCreateDataView',
    '13.napiIsDataView',
    '14.napiGetDataViewInfo'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(23)
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
                } else if (item === '1.napiCreateArray') {
                  // [Start ark_napi_create_array]
                  //使用Node-API接口进行array相关开发 napi_create_array
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_array:%{public}s',
                    JSON.stringify(testNapi.createArray()));
                  // [End ark_napi_create_array]
                  this.result = 'napiCreateArraySuccess';
                } else if (item === '2.napiCreateArrayWithLength') {
                  // [Start ark_napi_create_array_with_length]
                  // 使用Node-API接口进行array相关开发 napi_create_array_with_length
                  let array = testNapi.createArrayWithLength(6);
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_array_with_length:%{public}d', array.length);
                  // [End ark_napi_create_array_with_length]
                  this.result = 'napiCreateArrayWithLengthSuccess';
                } else if (item === '3.napiGetArrayLength') {
                  // [Start ark_napi_get_array_length]
                  // 使用Node-API接口进行array相关开发 napi_get_array_length
                  const arr = [0, 1, 2, 3, 4, 5];
                  hilog.info(0x0000, 'testTag', 'Test Node-API get_array_length:%{public}d',
                    testNapi.getArrayLength(arr));
                  // [End ark_napi_get_array_length]
                  this.result = 'napiGetArrayLengthSuccess';
                } else if (item === '4.napiIsArray') {
                  // [Start ark_napi_is_array]
                  // 使用Node-API接口进行array相关开发 napi_is_array
                  try {
                    let value = new Array<number>(1);
                    let data = "123";
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_array: %{public}s',
                      testNapi.isArray<number>(value));
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_array: %{public}s',
                      testNapi.isArray<string>(data));
                    // [StartExclude ark_napi_is_array]
                    this.result = 'napiIsArraySuccess';
                    // [EndExclude ark_napi_is_array]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_is_array error: %{public}s', error.message);
                    // [StartExclude ark_napi_is_array]
                    this.result = 'napiIsArrayFail';
                    // [EndExclude ark_napi_is_array]
                  }
                  // [End ark_napi_is_array]
                } else if (item === '5.napiSetElement') {
                  // [Start ark_napi_set_element]
                  // 使用Node-API接口进行array相关开发 napi_set_element
                  let arr = [10, 20, 30];
                  testNapi.napiSetElement<number | string>(arr, 1, 'newElement');
                  testNapi.napiSetElement<number | string>(arr, 2, 50);
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_set_element arr: %{public}s', arr.toString());
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_set_element arr[3]: %{public}s', arr[3]);

                  interface MyObject {
                    first: number;
                    second: number;
                  }

                  let obj: MyObject = {
                    first: 1,
                    second: 2
                  };
                  testNapi.napiSetElement<number | string | Object>(arr, 4, obj);
                  let objAsString = JSON.stringify(arr[4]);
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_set_element arr[4]: %{public}s', objAsString);
                  // [End ark_napi_set_element]
                  this.result = 'napiSetElementSuccess';
                } else if (item === '6.napiGetElement') {
                  // [Start ark_napi_get_element]
                  // 使用Node-API接口进行array相关开发 napi_get_element
                  interface MyObject {
                    first: number;
                    second: number;
                  }

                  let obj: MyObject = {
                    first: 1,
                    second: 2
                  };
                  let arr = [10, 'hello', null, obj];
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_element arr[0]: %{public}d',
                    testNapi.napiGetElement<number | string | null | Object>(arr, 0));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_element arr[1]: %{public}s',
                    testNapi.napiGetElement<number | string | null | Object>(arr, 1));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_element arr[2]: %{public}s',
                    testNapi.napiGetElement<number | string | null | Object>(arr, 2));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_element arr[3]: %{public}s',
                    testNapi.napiGetElement<number | string | null | Object>(arr, 3));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_element arr[4]: %{public}s',
                    JSON.stringify(testNapi.napiGetElement(arr, 4)));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_element arr[null]: %{public}s',
                    testNapi.napiGetElement<number | string | null | Object>(arr, 5));
                  // [End ark_napi_get_element]
                  this.result = 'napiGetElementSuccess';
                } else if (item === '7.napiHasElement') {
                  // [Start ark_napi_has_element]
                  // 使用Node-API接口进行array相关开发 napi_has_element
                  let arr = [10, 'hello', null, 'world'];
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_has_element arr[0]: %{public}s',
                    testNapi.napiHasElement<number | string | null>(arr, 0));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_has_element arr[7]: %{public}s',
                    testNapi.napiHasElement<number | string | null>(arr, 7));
                  // [End ark_napi_has_element]
                  this.result = 'napiHasElementSuccess';
                } else if (item === '8.napiDeleteElement') {
                  // [Start ark_napi_delete_element]
                  // 使用Node-API接口进行array相关开发 napi_delete_element
                  let arr = [10, 'hello', null, 'world'];
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_has_element arr[0]: %{public}s',
                    testNapi.napiHasElement<number | string | null>(arr, 0));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_delete_element arr[0]: %{public}s',
                    testNapi.napiDeleteElement<number | string | null>(arr, 0));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_has_element deleted arr[0]: %{public}s',
                    testNapi.napiHasElement<number | string | null>(arr, 0));
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_element arr[0]: %{public}d',
                    testNapi.napiGetElement<number | string | null>(arr, 0));
                  // [End ark_napi_delete_element]
                  this.result = 'napiDeleteElementSuccess';
                } else if (item === '9.napiCreateTypedArray') {
                  // [Start ark_napi_create_typed_array]
                  // 使用Node-API接口进行array相关开发 napi_create_typedarray
                  let typedArray = testNapi.createTypedArray<Int8Array>(testNapi.TypedArrayTypes["INT8_ARRAY"]);
                  if (typedArray instanceof Int8Array) {
                    hilog.info(0x0000, 'testTag', ' Node-API napi_create_typedarray: Int8Array');
                    // [StartExclude ark_napi_create_typed_array]
                    this.result = 'napiCreateInt8ArraySuccess';
                    // [EndExclude ark_napi_create_typed_array]
                  }
                  let uint8Array = testNapi.createTypedArray<Uint8Array>(testNapi.TypedArrayTypes["UINT8_ARRAY"]);
                  if (uint8Array instanceof Uint8Array) {
                    hilog.info(0x0000, 'testTag', ' Node-API napi_create_typedarray: Uint8Array');
                    // [StartExclude ark_napi_create_typed_array]
                    this.result = 'napiCreateUint8ArraySuccess';
                    // [EndExclude ark_napi_create_typed_array]
                  }
                  // [End ark_napi_create_typed_array]
                } else if (item === '10.napiIsTypedArray') {
                  // [Start ark_napi_is_typed_array]
                  // 使用Node-API接口进行array相关开发 napi_is_typedarray
                  try {
                    let value = new Uint8Array([1, 2, 3, 4]);
                    let data = "123";
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_typedarray: %{public}s',
                      testNapi.isTypedarray(value));
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_typedarray: %{public}s',
                      testNapi.isTypedarray(data));
                    // [StartExclude ark_napi_is_typed_array]
                    this.result = 'napiIsTypedArraySuccess';
                    // [EndExclude ark_napi_is_typed_array]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_is_typedarray error: %{public}s', error.message);
                    // [StartExclude ark_napi_is_typed_array]
                    this.result = 'napiIsTypedArrayFail';
                    // [EndExclude ark_napi_is_typed_array]
                  }
                  // [End ark_napi_is_typed_array]
                } else if (item === '11.napiGetTypedArrayInfo') {
                  // [Start ark_napi_get_typed_array_info]
                  // 使用Node-API接口进行array相关开发 napi_get_typedarray_info
                  // 传入TypedArray类型数据。TypedArray是一种用来描述二进制数据的类数组数据视图，没有直接构造器，可以用其子类构造类数组
                  // TypedArray的子类有: Int8Array Uint8Array Uint8ClampedArray Int16Array Int32Array等
                  let int8Array = new Int8Array([15, 7]);
                  // 定义枚举类型 这些都是TypedArray的属性
                  enum InfoType {
                    TYPE = 1, // 传入的TypedArray的类型
                    LENGTH = 2, // 传入的TypedArray的长度
                    ARRAY_BUFFER = 3, // TypedArray下的ArrayBuffer
                    BYTE_OFFSET = 4 // 数组的第一个元素所在的基础原生数组中的字节偏移量
                  };
                  let arrbuff = testNapi.getTypedarrayInfo(int8Array, InfoType.ARRAY_BUFFER) as ArrayBuffer;
                  // 将arraybuffer转为数组
                  let arr = new Array(new Int8Array(arrbuff));
                  hilog.info(0x0000, 'Node-API', 'get_typedarray_info_arraybuffer: %{public}s', arr.toString());
                  hilog.info(0x0000, 'Node-API', 'get_typedarray_info_isIn8Array: %{public}s',
                    testNapi.getTypedarrayInfo(int8Array, InfoType.TYPE).toString());
                  hilog.info(0x0000, 'Node-API', 'get_typedarray_info_length: %{public}d',
                    testNapi.getTypedarrayInfo(int8Array, InfoType.LENGTH));
                  hilog.info(0x0000, 'Node-API', 'get_typedarray_info_byte_offset: %{public}d',
                    testNapi.getTypedarrayInfo(int8Array, InfoType.BYTE_OFFSET));
                  // [End ark_napi_get_typed_array_info]
                  this.result = 'napiGetTypedArrayInfoSuccess';
                } else if (item === '12.napiCreateDataView') {
                  // [Start ark_napi_create_data_view]
                  // 使用Node-API接口进行array相关开发 napi_create_dataview
                  const arrayBuffer = new ArrayBuffer(16);
                  const dataView = testNapi.createDataView(arrayBuffer) as DataView;
                  hilog.info(0x0000, 'testTag', 'Test Node-API dataView：%{public}d', dataView.byteLength);
                  hilog.info(0x0000, 'testTag', 'Test Node-API dataView第一个数据：%{public}d', dataView.getInt8(0));
                  // [End ark_napi_create_data_view]
                  this.result = 'napiCreateDataViewSuccess';
                } else if (item === '13.napiIsDataView') {
                  // [Start ark_napi_is_data_view]
                  // 使用Node-API接口进行array相关开发 napi_is_dataview
                  try {
                    let buffer = new ArrayBuffer(16);
                    let dataView = new DataView(buffer);
                    let data = "123";
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_dataview: %{public}s',
                      testNapi.isDataView(dataView));
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_dataview: %{public}s',
                      testNapi.isDataView(data));
                    // [StartExclude ark_napi_is_data_view]
                    this.result = 'napiIsDataViewSuccess';
                    // [EndExclude ark_napi_is_data_view]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_is_dataview error: %{public}s', error.message);
                    // [StartExclude ark_napi_is_data_view]
                    this.result = 'napiIsDataViewFail';
                    // [EndExclude ark_napi_is_data_view]
                  }
                  // [End ark_napi_is_data_view]
                } else if (item === '14.napiGetDataViewInfo') {
                  // [Start ark_napi_get_data_view_info]
                  // 使用Node-API接口进行array相关开发 napi_get_dataview_info
                  // 创建一个ArrayBuffer
                  let arrayBuffer = new Int8Array([2, 5]).buffer;
                  // 使用arrayBuffer创建一个dataView
                  let dataView = new DataView(arrayBuffer);
                  // 定义一个枚举类型
                  enum InfoType {
                    BYTE_LENGTH = 0,
                    ARRAY_BUFFER = 1,
                    BYTE_OFFSET = 2,
                  };
                  // 传入DataView类型参数查询DataView的字节数
                  hilog.info(0x0000, 'Node-API', 'get_dataview_info_bytelength %{public}d',
                    testNapi.getDataViewInfo(dataView, InfoType.BYTE_LENGTH));
                  // 传入DataView类型参数查询DataView的ArrayBuffer
                  let arrbuff = testNapi.getDataViewInfo(dataView, InfoType.ARRAY_BUFFER) as ArrayBuffer;
                  // 将arraybuffer转为数组
                  let arr = Array.from(new Int8Array(arrbuff));
                  hilog.info(0x0000, 'Node-API', 'get_dataview_info_arraybuffer %{public}s', arr.toString());
                  // 传入DataView类型参数查询DataView开始投影的数据缓冲区中的字节偏移量
                  hilog.info(0x0000, 'Node-API', 'get_dataview_info_byteoffset %{public}d',
                    testNapi.getDataViewInfo(dataView, InfoType.BYTE_OFFSET));
                  // [End ark_napi_get_data_view_info]
                  this.result = 'napiGetDataViewInfoSuccess';
                }
              })
          }
        })
      }.scrollBar(BarState.Off)
      .width('90%')
      .id('List')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding({ top: 5 })
  }
}

