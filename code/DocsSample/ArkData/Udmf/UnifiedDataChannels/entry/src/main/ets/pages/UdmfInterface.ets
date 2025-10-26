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

// [Start import_module]
import { unifiedDataChannel, uniformTypeDescriptor, uniformDataStruct } from '@kit.ArkData';
import hilog from '@ohos.hilog';
// [End import_module]

// [Start import_unifiedData_object_module]
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';

// [End import_unifiedData_object_module]

export function insertUnifiedData() {
  // [Start unified_data_channels_insert_data]
  // [StartExclude unified_data_channels_insert_data]
  // 准备PlainText文本数据内容
  // [EndExclude unified_data_channels_insert_data]
  let plainTextObj: uniformDataStruct.PlainText = {
    uniformDataType: 'general.plain-text',
    textContent: 'Hello world',
    abstract: 'This is abstract'
  }
  let record =
    new unifiedDataChannel.UnifiedRecord(uniformTypeDescriptor.UniformDataType.PLAIN_TEXT, plainTextObj);
  // [StartExclude unified_data_channels_insert_data]
  // 准备HTML数据内容
  // [EndExclude unified_data_channels_insert_data]
  let htmlObj: uniformDataStruct.HTML = {
    uniformDataType: 'general.html',
    htmlContent: '<div><p>Hello world</p></div>',
    plainContent: 'Hello world'
  }
  // [StartExclude unified_data_channels_insert_data]
  // 为该记录增加一种样式，两种样式存储的是同一个数据，为不同表达形式
  // [EndExclude unified_data_channels_insert_data]
  record.addEntry(uniformTypeDescriptor.UniformDataType.HTML, htmlObj);
  let unifiedData = new unifiedDataChannel.UnifiedData(record);

  // [StartExclude unified_data_channels_insert_data]
  // 准备pixelMap数据内容
  // [EndExclude unified_data_channels_insert_data]
  let arrayBuffer = new ArrayBuffer(4 * 3 * 3);
  let opt: image.InitializationOptions = {
    editable: true,
    pixelFormat: 3,
    size: { height: 3, width: 3 },
    alphaType: 3
  };
  let pixelMap: uniformDataStruct.PixelMap = {
    uniformDataType: 'openharmony.pixel-map',
    pixelMap: image.createPixelMapSync(arrayBuffer, opt)
  }
  unifiedData.addRecord(new unifiedDataChannel.UnifiedRecord(
    uniformTypeDescriptor.UniformDataType.OPENHARMONY_PIXEL_MAP, pixelMap));
  // [StartExclude unified_data_channels_insert_data]
  // 指定要插入数据的数据通路枚举类型
  // [EndExclude unified_data_channels_insert_data]
  let options: unifiedDataChannel.Options = {
    intention: unifiedDataChannel.Intention.DATA_HUB
  }
  try {
    unifiedDataChannel.insertData(options, unifiedData, (err, key) => {
      if (err === undefined) {
        hilog.info(0xFF00, '[Sample_Udmf]', `Succeeded in inserting data. key = ${key}`);
      } else {
        hilog.error(0xFF00, '[Sample_Udmf]', `Succeeded in inserting data. key = ${key})`);
      }
    });
  } catch (e) {
    let error: BusinessError = e as BusinessError;
    hilog.error(0xFF00, '[Sample_Udmf]',
      `Insert data throws an exception. code is ${error.code},message is ${error.message}`);
  }
  // [End unified_data_channels_insert_data]
}

export function updateUnifiedData() {
  // [Start unified_data_channels_update_data]
  let plainTextUpdate: uniformDataStruct.PlainText = {
    uniformDataType: 'general.plain-text',
    textContent: 'How are you',
    abstract: 'This is abstract'
  }
  let recordUpdate =
    new unifiedDataChannel.UnifiedRecord(uniformTypeDescriptor.UniformDataType.PLAIN_TEXT, plainTextUpdate);
  let htmlUpdate: uniformDataStruct.HTML = {
    uniformDataType: 'general.html',
    htmlContent: '<div><p>How are you</p></div>',
    plainContent: 'How are you'
  }
  recordUpdate.addEntry(uniformTypeDescriptor.UniformDataType.HTML, htmlUpdate);
  let unifiedDataUpdate = new unifiedDataChannel.UnifiedData(recordUpdate);

  // [StartExclude unified_data_channels_update_data]
  // 指定要更新的统一数据对象的URI
  // [EndExclude unified_data_channels_update_data]
  let optionsUpdate: unifiedDataChannel.Options = {
    // [StartExclude unified_data_channels_update_data]
    // 此处的key值仅为示例，不可直接使用，其值与insertData接口回调函数中key保持一致
    // [EndExclude unified_data_channels_update_data]
    key: 'udmf://DataHub/com.ohos.test/0123456789'
  };

  try {
    unifiedDataChannel.updateData(optionsUpdate, unifiedDataUpdate, (err) => {
      if (err === undefined) {
        hilog.info(0xFF00, '[Sample_Udmf]', `Succeeded in updating data.`);
      } else {
        hilog.error(0xFF00, '[Sample_Udmf]', `Failed to update data. code is ${err.code},message is ${err.message}`);
      }
    });
  } catch (e) {
    let error: BusinessError = e as BusinessError;
    hilog.error(0xFF00, '[Sample_Udmf]',
      `Update data throws an exception. code is ${error.code},message is ${error.message}`);
  }
  // [End unified_data_channels_update_data]
}

export function deleteUnifiedData() {
  // [Start unified_data_channels_delete_data]
  // [StartExclude unified_data_channels_delete_data]
  // 指定要删除数据的数据通路枚举类型
  // [EndExclude unified_data_channels_delete_data]
  let optionsDelete: unifiedDataChannel.Options = {
    intention: unifiedDataChannel.Intention.DATA_HUB
  };

  try {
    unifiedDataChannel.deleteData(optionsDelete, (err, data) => {
      if (err === undefined) {
        hilog.info(0xFF00, '[Sample_Udmf]', `Succeeded in deleting data. size = ${data.length}`);
        for (let i = 0; i < data.length; i++) {
          let records = data[i].getRecords();
          for (let j = 0; j < records.length; j++) {
            let types = records[j].getTypes();
            // [Start unified_data_channels_delete_data]
            // 根据业务需要从记录中获取样式数据
            // [EndExclude unified_data_channels_delete_data]
            if (types.includes(uniformTypeDescriptor.UniformDataType.PLAIN_TEXT)) {
              let text =
                records[j].getEntry(uniformTypeDescriptor.UniformDataType.PLAIN_TEXT) as uniformDataStruct.PlainText;
              hilog.info(0xFF00, '[Sample_Udmf]', `${i + 1}.${text.textContent}`);
            }
            if (types.includes(uniformTypeDescriptor.UniformDataType.HTML)) {
              let html =
                records[j].getEntry(uniformTypeDescriptor.UniformDataType.HTML) as uniformDataStruct.HTML;
              hilog.info(0xFF00, '[Sample_Udmf]', `${i + 1}.${html.htmlContent}`);
            }
          }
        }
      } else {
        hilog.error(0xFF00, '[Sample_Udmf]', `Failed to delete data. code is ${err.code},message is ${err.message}`);
      }
    });
  } catch (e) {
    let error: BusinessError = e as BusinessError;
    hilog.error(0xFF00, '[Sample_Udmf]',
      `Delete data throws an exception. code is ${error.code},message is ${error.message}`);
  }
  // [End unified_data_channels_delete_data]
}

export function queryUnifiedData() {
  // [Start unified_data_channels_query_data]
  // [StartExclude unified_data_channels_query_data]
  // 指定要查询数据的数据通路枚举类型
  // [EndExclude unified_data_channels_query_data]
  let options: unifiedDataChannel.Options = {
    intention: unifiedDataChannel.Intention.DATA_HUB
  };

  try {
    unifiedDataChannel.queryData(options, (err, data) => {
      if (err === undefined) {
        hilog.info(0xFF00, '[Sample_Udmf]', `Succeeded in querying data. size = ${data.length}`);
        for (let i = 0; i < data.length; i++) {
          let records = data[i].getRecords();
          for (let j = 0; j < records.length; j++) {
            let types = records[j].getTypes();
            // [StartExclude unified_data_channels_query_data]
            // 根据业务需要从记录中获取样式数据
            // [EndExclude unified_data_channels_query_data]
            if (types.includes(uniformTypeDescriptor.UniformDataType.PLAIN_TEXT)) {
              let text =
                records[j].getEntry(uniformTypeDescriptor.UniformDataType.PLAIN_TEXT) as uniformDataStruct.PlainText;
              hilog.info(0xFF00, '[Sample_Udmf]', `${i + 1}.${text.textContent}`);
            }
            if (types.includes(uniformTypeDescriptor.UniformDataType.HTML)) {
              let html =
                records[j].getEntry(uniformTypeDescriptor.UniformDataType.HTML) as uniformDataStruct.HTML;
              hilog.info(0xFF00, '[Sample_Udmf]', `${i + 1}.${html.htmlContent}`);
            }
          }
        }
      } else {
        hilog.error(0xFF00, '[Sample_Udmf]', `Failed to query data. code is ${err.code},message is ${err.message}`);
      }
    });
  } catch (e) {
    let error: BusinessError = e as BusinessError;
    hilog.error(0xFF00, '[Sample_Udmf]',
      `Query data throws an exception. code is ${error.code},message is ${error.message}`);
  }
  // [End unified_data_channels_query_data]
}