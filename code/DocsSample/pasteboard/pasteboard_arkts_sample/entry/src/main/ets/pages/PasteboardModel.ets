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

// [Start pasteboard_timelaps_PasteData1]
// [Start pasteboard_usedata]
// [Start pasteboard_useudc]
import { BusinessError, pasteboard } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [StartExclude pasteboard_usedata]
import { unifiedDataChannel, uniformDataStruct, uniformTypeDescriptor } from '@kit.ArkData';
// [EndExclude pasteboard_usedata]
const systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
// [End pasteboard_timelaps_PasteData1]
// [StartExclude pasteboard_usedata]
// [StartExclude pasteboard_useudc]
export namespace TestJs {
  // 使用基础数据类型进行复制粘贴
  // [EndExclude pasteboard_usedata]
  export async function setPlainData(content: string): Promise<void> {
    let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, content);
    await systemPasteboard.setData(pasteData);
  }
  export async function getPlainData(): Promise<string> {
    // 从系统剪贴板中读取数据
    let data = await systemPasteboard.getData();
    // 从剪贴板数据中获取条目数量
    let recordCount = data.getRecordCount();
    // 从剪贴板数据中获取对应条目信息
    let result = '';
    for (let i = 0; i < recordCount; i++) {
      let record = data.getRecord(i).toPlainText();
      hilog.info(0xFF00, '[Sample_pasteboard]', 'Get data success, record:' + record);
      result += record;
    }
    return result;
  }
  // [End pasteboard_usedata]

  // 使用统一数据类型进行复制粘贴
  // [EndExclude pasteboard_useudc]
  // 1.构造一条PlainText数据
  export async function handleUniformData() {
    let plainText: uniformDataStruct.PlainText = {
      uniformDataType: uniformTypeDescriptor.UniformDataType.PLAIN_TEXT,
      textContent: 'PLAINTEXT_CONTENT',
      abstract: 'PLAINTEXT_ABSTRACT',
    }

    let record = new unifiedDataChannel.UnifiedRecord(uniformTypeDescriptor.UniformDataType.PLAIN_TEXT, plainText);
    let data = new unifiedDataChannel.UnifiedData();
    data.addRecord(record);
    // 2.向系统剪贴板中存入一条PlainText数据
    systemPasteboard.setUnifiedData(data).then((data: void) => {
      hilog.info(0xFF00, '[Sample_pasteboard]', 'Succeeded in setting UnifiedData.');
      // 存入成功，处理正常场景
    }).catch((err: BusinessError) => {
      hilog.error(0xFF00, '[Sample_pasteboard]', 'Failed to set UnifiedData. Cause: ' + err.message);
      // 处理异常场景
    });
    // 3.从系统剪贴板中读取这条text数据
    systemPasteboard.getUnifiedData().then((data) => {
      let records: unifiedDataChannel.UnifiedRecord[] = data.getRecords();
      for (let j = 0; j < records.length; j++) {
        if (records[j].getType() === uniformTypeDescriptor.UniformDataType.PLAIN_TEXT) {
          let text = records[j].getValue() as uniformDataStruct.PlainText;
          hilog.info(0xFF00, '[Sample_pasteboard]', `${j + 1}.${text.textContent}`);
        }
      }
    }).catch((err: BusinessError) => {
      hilog.error(0xFF00, '[Sample_pasteboard]', 'Failed to get UnifiedData. Cause: ' + err.message);
      // 处理异常场景
    });
  }
  // [End pasteboard_useudc]

  // 使用基于PasteData级别的延迟复制粘贴（不建议使用，会影响粘贴体验和成功率）
  export async function pasteDatatimelate() {
    // [Start pasteboard_timelaps_PasteData2]
    let plainTextData = new unifiedDataChannel.UnifiedData();
    let getDelayPlainText = ((dataType: string) => {
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
    // [End pasteboard_timelaps_PasteData2]
    // [Start pasteboard_timelaps_PasteData3]
    let setDelayPlainText = () => {
      plainTextData.properties.shareOptions = unifiedDataChannel.ShareOptions.CROSS_APP;
      // 跨应用使用时设置为CROSS_APP，本应用内使用时设置为IN_APP
      plainTextData.properties.getDelayData = getDelayPlainText;
      pasteboard.getSystemPasteboard().setUnifiedData(plainTextData).then(() => {
        hilog.info(0xFF00, '[Sample_pasteboard]', 'Succeeded in set PlainText.');
        // 存入成功，处理正常场景
      }).catch((error: BusinessError) => {
        hilog.error(0xFF00, '[Sample_pasteboard]', 'Failed to set PlainText. Cause: ' + error.message);
        // 处理异常场景
      });
    }
    // [End pasteboard_timelaps_PasteData3]
    // [Start pasteboard_timelaps_PasteData4]
    let getPlainTextUnifiedData = (() => {
      pasteboard.getSystemPasteboard().getUnifiedData().then((data) => {
        let outputData = data;
        let records = outputData.getRecords();
        if (records[0].getType() == uniformTypeDescriptor.UniformDataType.PLAIN_TEXT) {
          let record = records[0] as unifiedDataChannel.PlainText;
          hilog.info(0xFF00, '[Sample_pasteboard]', 'GetPlainText success, type:' + records[0].getType());
          // 注意：用户复制的数据内容属于敏感信息，禁止应用程序使用日志明文打印从剪贴板获取到的数据内容。
        } else {
          hilog.info(0xFF00, '[Sample_pasteboard]', 'Get Plain Text Data No Success, Type is: ' + records[0].getType());
        }
      }).catch((error: BusinessError) => {
        hilog.error(0xFF00, '[Sample_pasteboard]', 'Failed to get PlainTextUnifiedData. Cause: ' + error.message);
        // 处理异常场景
      })
    })
    // [End pasteboard_timelaps_PasteData4]
    // [Start pasteboard_timelaps_PasteData5]
    try {
      systemPasteboard.setAppShareOptions(pasteboard.ShareOption.LOCALDEVICE);
      hilog.info(0xFF00, '[Sample_pasteboard]', 'Set app share options success.');
    } catch (err) {
      hilog.error(0xFF00, '[Sample_pasteboard]', 'Failed to Set app share options. Cause: ' + err.message);
      // 处理异常场景
    }
    // [End pasteboard_timelaps_PasteData5]
    // [Start pasteboard_timelaps_PasteData6]
    try {
      systemPasteboard.removeAppShareOptions();
      hilog.info(0xFF00, '[Sample_pasteboard]', 'Remove app share options success.');
    } catch (err) {
      hilog.error(0xFF00, '[Sample_pasteboard]', 'Failed to Remove app share options. Cause: ' + err.message);
      // 处理异常场景
    }
    // [End pasteboard_timelaps_PasteData6]
  }
}
