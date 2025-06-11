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
import taskpool from '@ohos.taskpool';

// [Start ark_napi_coerce_to_native_binding_object]
@Concurrent
function getAddress() {
  let address: number = testNapi.getAddress();
  console.info('taskpool:: address is' + address);
}

@Concurrent
function store(a: number, b: number, c: number) {
  let size: number = testNapi.getSetSize();
  console.info('set size is' + size + 'before store');
  testNapi.store(a);
  testNapi.store(b);
  testNapi.store(c);
  size = testNapi.getSetSize();
  console.info('set size is' + size + 'after store');
}

@Concurrent
function erase(a: number) {
  let size: number = testNapi.getSetSize();
  console.info('set size is' + size + 'before erase');
  testNapi.erase(a);
  size = testNapi.getSetSize();
  console.info('set size is' + size + 'after erase');
}

@Concurrent
function clear() {
  let size: number = testNapi.getSetSize();
  console.info('set size is' + size + 'before clear');
  testNapi.clear();
  size = testNapi.getSetSize();
  console.info('set size is' + size + 'after clear');
}

async function test01(): Promise<void> {
  let address: number = testNapi.getAddress();
  console.info('host thread address is' + address);

  let task1 = new taskpool.Task(getAddress);
  await taskpool.execute(task1);

  let task2 = new taskpool.Task(store, 1, 2, 3);
  await taskpool.execute(task2);

  let task3 = new taskpool.Task(store, 4, 5, 6);
  await taskpool.execute(task3);

  let task4 = new taskpool.Task(erase, 3);
  await taskpool.execute(task4);

  let task5 = new taskpool.Task(erase, 5);
  await taskpool.execute(task5);

  let task6 = new taskpool.Task(clear);
  await taskpool.execute(task6);
}
// [End ark_napi_coerce_to_native_binding_object]

// [Start ark_napi_serialize_deserialize_delete_serialization_data]
class Obj {
  numKey: number = 0;
}
// [StartExclude ark_napi_serialize_deserialize_delete_serialization_data]

@Entry
@Component
struct Index {
  @State result: string = ''
  private items: string[] = [
    'Reset Result Message',
    '1.napiLoadModule',
    '2.napiCreateObjectWithProperties',
    '3.napiCreateObjectWithNamedProperties',
    '4.napiRunScriptPath',
    '5.napiCoerceToNativeBindingObject',
    '6.napiAboutSerialize',
    '7.napiIsSendable',
    '8.napiDefineSendableClass',
    '9.napiCreateSendableObjectWithProperties',
    '10.napiCreateSendableArray',
    '11.napiCreateSendableArrayWithLength',
    '12.napiCreateSendableArraybuffer',
    '13.napiCreateSendableTypedArray',
    '14.napiWrapSendable',
    '15.napiWrapSendableWithSize',
    '16.napiUnwrapSendable',
    '17.napiRemoveWrapSendable'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(17)
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
                } else if (item === '1.napiLoadModule') {
                  // [Start ark_node_api_module_add]
                  hilog.info(0x0000, 'testTag', 'Test Node-API 2 + 3 = %{public}d', testNapi.add(2, 3));
                  // [End ark_node_api_module_add]
                  this.result = 'napiLoadModuleSuccess';
                } else if (item === '2.napiCreateObjectWithProperties') {
                  // [Start ark_node_api_module_create_object_properties]
                  // ArkTS Object相关 napi_create_object_with_properties
                  let value1 = testNapi.createObjectWithProperties('createObject');
                  hilog.info(0x0000, 'testTag', 'Node-API napi_create_object_with_properties:%{public}s',
                    JSON.stringify(value1));
                  // [End ark_node_api_module_create_object_properties]
                  this.result = 'napiCreateObjectWithPropertiesSuccess';
                } else if (item === '3.napiCreateObjectWithNamedProperties') {
                  // [Start ark_node_api_module_create_object_name_properties]
                  // ArkTS Object相关 napi_create_object_with_named_properties
                  let value2 = testNapi.createObjectWithNameProperties('ls');
                  hilog.info(0x0000, 'testTag', 'Node-API napi_create_object_with_named_properties:%{public}s',
                    JSON.stringify(value2));
                  // [End ark_node_api_module_create_object_name_properties]
                  this.result = 'napiCreateObjectWithNamedPropertiesSuccess';
                } else if (item === '4.napiRunScriptPath') {
                  // [Start ark_node_api_module_run_script_path]
                  // 运行指定abc文件 napi_run_script_path
                  try { // 在此处执行错误返回false，成功就返回true
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_run_script_path: %{public}s',
                      testNapi.runScriptPath());
                    // [StartExclude ark_node_api_module_run_script_path]
                    this.result = 'napiRunScriptPathSuccess';
                    // [EndExclude ark_node_api_module_run_script_path]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_run_script_path errorMessage: %{public}s',
                      error.message);
                    // [StartExclude ark_node_api_module_run_script_path]
                    this.result = 'napiRunScriptPathFail';
                    // [EndExclude ark_node_api_module_run_script_path]
                  }
                  // [End ark_node_api_module_run_script_path]
                } else if (item === '5.napiCoerceToNativeBindingObject') {
                  // 给ArkTS对象绑定回调和回调所需的参数 napi_coerce_to_native_binding_object
                  test01();
                  this.result = 'napiCoerceToNativeBindingObjectSuccess';
                } else if (item === '6.napiAboutSerialize') {
                  // [EndExclude ark_napi_serialize_deserialize_delete_serialization_data]
                  // 序列化和反序列化
                  let obj: Obj = { numKey: 500 };
                  hilog.info(0x0000, 'testTag', ' Node-API aboutSerialize: %{public}d', testNapi.aboutSerialize(obj));
                  // [End ark_napi_serialize_deserialize_delete_serialization_data]
                  this.result = 'napiAboutSerializeSuccess';
                } else if (item === '7.napiIsSendable') {
                  // [Start ark_napi_is_sendable]
                  // Sendable相关 napi_is_sendable
                  let value = testNapi.isSendable('createObject');
                  hilog.info(0x0000, 'testTag', 'Node-API napi_is_sendable: %{public}s', JSON.stringify(value));
                  // [End ark_napi_is_sendable]
                  this.result = 'napiIsSendableSuccess';
                } else if (item === '8.napiDefineSendableClass') {
                  // [Start ark_napi_define_sendable_class]
                  // Sendable相关 napi_define_sendable_class
                  let value = new testNapi.SendableClass();
                  hilog.info(0x0000, 'testTag', 'Node-API napi_define_sendable_class: %{public}s', value.str);
                  // [End ark_napi_define_sendable_class]
                  this.result = 'napiDefineSendableClassSuccess';
                } else if (item === '9.napiCreateSendableObjectWithProperties') {
                  // [Start ark_napi_create_sendable_object_with_properties]
                  // Sendable相关 napi_create_sendable_object_with_properties
                  let value = testNapi.getSendableObject();
                  hilog.info(0x0000, 'testTag', 'Node-API napi_create_sendable_object_with_properties: %{public}s',
                    JSON.stringify(value));
                  // [End ark_napi_create_sendable_object_with_properties]
                  this.result = 'napiCreateSendableObjectWithPropertiesSuccess';
                } else if (item === '10.napiCreateSendableArray') {
                  // [Start ark_napi_create_sendable_array]
                  // Sendable相关 napi_create_sendable_array
                  let value = testNapi.getSendableArray();
                  hilog.info(0x0000, 'testTag', 'Node-API napi_create_sendable_array: %{public}s',
                    JSON.stringify(value));
                  // [End ark_napi_create_sendable_array]
                  this.result = 'napiCreateSendableArraySuccess';
                } else if (item === '11.napiCreateSendableArrayWithLength') {
                  // [Start ark_napi_create_sendable_array_with_length]
                  // Sendable相关 napi_create_sendable_array_with_length
                  let value = testNapi.getSendableArrayWithLength();
                  hilog.info(0x0000, 'testTag', 'Node-API napi_create_sendable_array_with_length: %{public}s',
                    JSON.stringify(value.length));
                  // [End ark_napi_create_sendable_array_with_length]
                  this.result = 'napiCreateSendableArrayWithLengthSuccess';
                } else if (item === '12.napiCreateSendableArraybuffer') {
                  // [Start ark_napi_create_sendable_arraybuffer]
                  // Sendable相关 napi_create_sendable_arraybuffer
                  testNapi.getSendableArrayBuffer();
                  // [End ark_napi_create_sendable_arraybuffer]
                  this.result = 'napiCreateSendableArraybufferSuccess';
                } else if (item === '13.napiCreateSendableTypedArray') {
                  // [Start ark_napi_create_sendable_typed_array]
                  // Sendable相关 napi_create_sendable_typedarray
                  testNapi.getSendableTypedArray();
                  // [End ark_napi_create_sendable_typed_array]
                  this.result = 'napiCreateSendableTypedArraySuccess';
                } else if (item === '14.napiWrapSendable') {
                  // [Start ark_napi_wrap_sendable]
                  // Sendable相关 napi_wrap_sendable
                  testNapi.wrapSendable();
                  // [End ark_napi_wrap_sendable]
                  this.result = 'napiWrapSendableSuccess';
                } else if (item === '15.napiWrapSendableWithSize') {
                  // [Start ark_napi_wrap_sendable_with_size]
                  // Sendable相关 napi_wrap_sendable_with_size
                  testNapi.wrapSendableWithSize();
                  // [End ark_napi_wrap_sendable_with_size]
                  this.result = 'napiWrapSendableWithSizeSuccess';
                } else if (item === '16.napiUnwrapSendable') {
                  // [Start ark_napi_unwrap_sendable]
                  // Sendable相关 napi_unwrap_sendable
                  testNapi.unwrapSendable();
                  // [End ark_napi_unwrap_sendable]
                  this.result = 'napiUnwrapSendableSuccess';
                } else if (item === '17.napiRemoveWrapSendable') {
                  // [Start ark_napi_remove_wrap_sendable]
                  // Sendable相关 napi_remove_wrap_sendable
                  testNapi.removeWrapSendable();
                  // [End ark_napi_remove_wrap_sendable]
                  this.result = 'napiRemoveWrapSendableSuccess';
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
