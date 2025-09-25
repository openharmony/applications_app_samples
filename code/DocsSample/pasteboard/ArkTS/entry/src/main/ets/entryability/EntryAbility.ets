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

// [Start oh_jsvm_get_arraybuffer_info]
import {BusinessError, pasteboard} from '@kit.BasicServicesKit';
import {unifiedDataChannel, uniformDataStruct, uniformTypeDescriptor } from '@kit.ArkData';
import {AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';

// [StartExclude oh_jsvm_get_arraybuffer_info]
//使用基础数据类型进行复制粘贴
// [EndExclude oh_jsvm_get_arraybuffer_info]
export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    // 获取系统剪贴板对象
    let text = "test";
    // 创建一条纯文本类型的剪贴板内容对象
    let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
    // 将数据写入系统剪贴板
    let systemPasteboard = pasteboard.getSystemPasteboard();
    await systemPasteboard.setData(pasteData);
    //从系统剪贴板中读取数据
    let data = await systemPasteboard.getData();
    let recordCount = data.getRecordCount();
    for (let i = 0; i < recordCount; i++) {
      let record = data.getRecord(i).toPlainText();
      console.info('Get data success, record:' + record);
    }
  }
}

// [StartExclude oh_jsvm_get_arraybuffer_info]
//使用统一数据类型进行复制粘贴
// [EndExclude oh_jsvm_get_arraybuffer_info]
// 1.构造一条PlainText数据
let plainText : uniformDataStruct.PlainText = {
  uniformDataType: uniformTypeDescriptor.UniformDataType.PLAIN_TEXT,
  textContent : 'PLAINTEXT_CONTENT',
  abstract : 'PLAINTEXT_ABSTRACT',
}
let record = new unifiedDataChannel.UnifiedRecord(uniformTypeDescriptor.UniformDataType.PLAIN_TEXT, plainText);
let data = new unifiedDataChannel.UnifiedData();
data.addRecord(record);
// 2.向系统剪贴板中存入一条PlainText数据
const systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
systemPasteboard.setUnifiedData(data).then((data: void) => {
  console.info('Succeeded in setting UnifiedData.');
  // 存入成功，处理正常场景
}).catch((err: BusinessError) => {
  console.error('Failed to set UnifiedData. Cause: ' + err.message);
  // 处理异常场景
});
// 3.从系统剪贴板中读取这条text数据
systemPasteboard.getUnifiedData().then((data) => {
  let records: Array<unifiedDataChannel.UnifiedRecord> = data.getRecords();
  for (let j = 0; j < records.length; j++) {
    if (records[j].getType() === uniformTypeDescriptor.UniformDataType.PLAIN_TEXT) {
      let text = records[j].getValue() as uniformDataStruct.PlainText;
      console.info(`${j + 1}.${text.textContent}`);
    }
  }
}).catch((err: BusinessError) => {
  console.error('Failed to get UnifiedData. Cause: ' + err.message);
  // 处理异常场景
});

// [StartExclude oh_jsvm_get_arraybuffer_info]
// 使用基于PasteData级别的延迟复制粘贴（不建议使用）
// [EndExclude oh_jsvm_get_arraybuffer_info]
let plainTextData = new unifiedDataChannel.UnifiedData();
let GetDelayPlainText = ((dataType:string) => {
  let plainText = new unifiedDataChannel.PlainText();
  plainText.details = {
    Key: 'delayPlaintext',
    Value: 'delayPlaintext',
  };
  plainText.textContent = 'delayTextContent';
  plainText.abstract = 'delayTextContent';
  plainTextData.addRecord(plainText);
  return plainTextData;
});
let SetDelayPlainText = () => {
  plainTextData.properties.shareOptions = unifiedDataChannel.ShareOptions.CROSS_APP;
  // 跨应用使用时设置为CROSS_APP，本应用内使用时设置为IN_APP
  plainTextData.properties.getDelayData = GetDelayPlainText;
  pasteboard.getSystemPasteboard().setUnifiedData(plainTextData).then(()=>{
    // 存入成功，处理正常场景
  }).catch((error: BusinessError) => {
    // 处理异常场景
  });
}
let GetPlainTextUnifiedData = (() => {
  pasteboard.getSystemPasteboard().getUnifiedData().then((data) => {
    let outputData = data;
    let records = outputData.getRecords();
    if (records[0].getType() == uniformTypeDescriptor.UniformDataType.PLAIN_TEXT) {
      let record = records[0] as unifiedDataChannel.PlainText;
      console.info('GetPlainText success, type:' + records[0].getType() );
      //注意：用户复制的数据内容属于敏感信息，禁止应用程序使用日志明文打印从剪贴板获取到的数据内容。
    } else {
      console.info('Get Plain Text Data No Success, Type is: ' + records[0].getType());
    }
  }).catch((error: BusinessError) => {
    //处理异常场景
  })
})
//const systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
try {
  systemPasteboard.setAppShareOptions(pasteboard.ShareOption.LOCALDEVICE);
  console.info('Set app share options success.');
} catch (err) {
  //处理异常场景
}
try {
  systemPasteboard.removeAppShareOptions();
  console.info('Remove app share options success.');
} catch (err) {
  //处理异常场景
}
// [End oh_jsvm_get_arraybuffer_info]