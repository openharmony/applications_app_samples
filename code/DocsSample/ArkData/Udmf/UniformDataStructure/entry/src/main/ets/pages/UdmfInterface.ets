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
// 1. 导入unifiedDataChannel和uniformTypeDescriptor模块。
import { uniformDataStruct, uniformTypeDescriptor, unifiedDataChannel } from '@kit.ArkData';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End import_module]

export function uniformDataStructure() {
  // [Start unified_data_structure]
  // 2. 创建超链接数据记录。
  let hyperlinkDetails: Record<string, string> = {
    'attr1': 'value1',
    'attr2': 'value2'
  }
  let hyperlink: uniformDataStruct.Hyperlink = {
    uniformDataType: 'general.hyperlink',
    url: 'www.XXX.com',
    description: 'This is the description of this hyperlink',
    details: hyperlinkDetails
  }

  // 修改hyperlink属性description
  hyperlink.description = '...';

  // 访问对象属性。
  hilog.info(0xFF00, '[Sample_Udmf]', `hyperlink.url = ${hyperlink.url}`);

  // 3. 创建纯文本数据类型记录，将其添加到刚才创建的UnifiedData对象。
  let plainTextDetails: Record<string, string> = {
    'attr1': 'value1',
    'attr2': 'value2'
  }
  let plainText: uniformDataStruct.PlainText = {
    uniformDataType: 'general.plain-text',
    textContent: 'This is plainText textContent example',
    abstract: 'this is abstract',
    details: plainTextDetails
  }
  // 4. 创建一个统一数据对象实例。
  let unifiedData = new unifiedDataChannel.UnifiedData();
  let hyperlinkRecord =
    new unifiedDataChannel.UnifiedRecord(uniformTypeDescriptor.UniformDataType.HYPERLINK, hyperlink);
  let plainTextRecord =
    new unifiedDataChannel.UnifiedRecord(uniformTypeDescriptor.UniformDataType.PLAIN_TEXT, plainText);

  // 5. 添加plainText数据记录。
  unifiedData.addRecord(hyperlinkRecord);
  unifiedData.addRecord(plainTextRecord);

  // 6. 记录添加完成后，可获取当前UnifiedData对象内的所有数据记录。
  let records = unifiedData.getRecords();

  // 7. 遍历每条记录，判断该记录的数据类型，转换为子类对象，得到原数据记录。
  for (let i = 0; i < records.length; i++) {
    let unifiedDataRecord = records[i] as unifiedDataChannel.UnifiedRecord;
    let record = unifiedDataRecord.getValue() as object;
    if (record != undefined) {
      // 读取该数据记录的类型
      let type: string = record['uniformDataType'];
      switch (type) {
        case uniformTypeDescriptor.UniformDataType.HYPERLINK:
          Object.keys(record).forEach(key => {
            hilog.info(0xFF00, '[Sample_Udmf]', `show records: ${key} + , value: ${record[key]}`);
          });
          break;
        case uniformTypeDescriptor.UniformDataType.PLAIN_TEXT:
          Object.keys(record).forEach(key => {
            hilog.info(0xFF00, '[Sample_Udmf]', `show records: ${key} + , value: ${record[key]}`);
          });
          break;
        default:
          break;
      }
    }
  }
  // [End unified_data_structure]
}