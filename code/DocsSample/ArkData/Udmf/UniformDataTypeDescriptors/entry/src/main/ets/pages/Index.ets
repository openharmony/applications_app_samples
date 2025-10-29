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
//  1.导入模块
import { uniformTypeDescriptor } from '@kit.ArkData';
import hilog from '@ohos.hilog';
// [End import_module]

// [Start uniform_type_descriptor_test]
function uniformTypeDescriptorTest() {
  try {
    // 2.可根据 “.mp3” 文件后缀查询对应UTD数据类型，并查询对应UTD数据类型的具体属性
    let fileExtension = '.mp3';
    let typeIds1 = uniformTypeDescriptor.getUniformDataTypesByFilenameExtension(fileExtension);
    if (typeIds1.length == 0) {
      return;
    }
    let typeObj1 = uniformTypeDescriptor.getTypeDescriptor(typeIds1[0]);
    hilog.info(0xFF00, '[Sample_Udmf]', `typeId: ${typeObj1.typeId}`);
    hilog.info(0xFF00, '[Sample_Udmf]', `belongingToTypes: ${typeObj1.belongingToTypes}`);
    hilog.info(0xFF00, '[Sample_Udmf]', `description: ${typeObj1.description}`);
    hilog.info(0xFF00, '[Sample_Udmf]', `filenameExtensions: ${typeObj1.filenameExtensions}`);
    hilog.info(0xFF00, '[Sample_Udmf]', `mimeTypes: ${typeObj1.mimeTypes}`);

    // 3.可根据 “audio/mp3” MIMEType查询对应UTD数据类型，并查询对应UTD数据类型的具体属性。
    let mimeType = 'audio/mp3';
    let typeIds2 = uniformTypeDescriptor.getUniformDataTypesByMIMEType(mimeType);
    if (typeIds2.length == 0) {
      return;
    }
    let typeObj2 = uniformTypeDescriptor.getTypeDescriptor(typeIds2[0]);
    hilog.info(0xFF00, '[Sample_Udmf]', `typeId: ${typeObj2.typeId}`);
    hilog.info(0xFF00, '[Sample_Udmf]', `belongingToTypes: ${typeObj2.belongingToTypes}`);
    hilog.info(0xFF00, '[Sample_Udmf]', `description: ${typeObj2.description}`);
    hilog.info(0xFF00, '[Sample_Udmf]', `filenameExtensions: ${typeObj2.filenameExtensions}`);
    hilog.info(0xFF00, '[Sample_Udmf]', `mimeTypes: ${typeObj2.mimeTypes}`);

    // 4.将数据类型进行比较，确认是否同一种数据类型
    if (typeObj1 != null && typeObj2 != null) {
      let ret = typeObj1.equals(typeObj2);
      hilog.info(0xFF00, '[Sample_Udmf]', `typeObj1 equals typeObj2, ret: ${ret}`);
    }

    // 5.将查询到的标准数据类型“general.mp3”与表示音频数据的已知标准数据类型“general.audio”做比较查询，确认是否存在归属关系。
    if (typeObj1 != null) {
      let ret = typeObj1.belongsTo('general.audio');
      hilog.info(0xFF00, '[Sample_Udmf]', `belongsTo, ret: + ${ret}`);
      let mediaTypeObj = uniformTypeDescriptor.getTypeDescriptor('general.media');
      // 确认是否存在归属关系
      ret = mediaTypeObj.isHigherLevelType('general.audio');
      hilog.info(0xFF00, '[Sample_Udmf]', `isHigherLevelType, ret: + ${ret}`);
    }
  } catch (err) {
    hilog.error(0xFF00, '[Sample_Udmf]', `err message: ${err.message}, err code: ${err.code}`);
  }
}
// [End uniform_type_descriptor_test]

function getMimeTypeByFilenameExtensions() {
  // [Start get_filename_extensions_by_mimeType]
  try {
    // 2.可根据 “.ts” 文件后缀查询对应UTD数据类型。
    let fileExtension = '.ts';
    let typeIds = uniformTypeDescriptor.getUniformDataTypesByFilenameExtension(fileExtension);
    for (let typeId of typeIds) {
      // 3.根据UTD数据类型查询对应的MIMEType列表。
      let typeObj = uniformTypeDescriptor.getTypeDescriptor(typeId);
      let mimeTypes = typeObj.mimeTypes;
      hilog.info(0xFF00, '[Sample_Udmf]', `mimeTypes: ${mimeTypes}`);
    }
  } catch (err) {
    hilog.error(0xFF00, '[Sample_Udmf]', `err message: ${err.message}, err code: ${err.code}`);
  }
  // [End get_filename_extensions_by_mimeType]
}

function getFilenameExtensionByMimeType() {
  // [Start get_filename_extension_by_mimeType]
  try {
    // 2.可根据 “text/plain” MIMEType查询对应UTD数据类型。
    let mimeType = 'text/plain';
    let typeIds = uniformTypeDescriptor.getUniformDataTypesByMIMEType(mimeType);
    for (let typeId of typeIds) {
      // 3. 根据UTD数据类型查询对应的文件后缀列表
      let typeObj = uniformTypeDescriptor.getTypeDescriptor(typeId);
      let filenameExtensions = typeObj.filenameExtensions;
      hilog.info(0xFF00, '[Sample_Udmf]', `filenameExtensions: ${filenameExtensions}`);
    }
  } catch (err) {
    hilog.error(0xFF00, '[Sample_Udmf]', `err message: ${err.message}, err code: ${err.code}`);
  }
  // [End get_filename_extension_by_mimeType]
}

@Entry
@Component
struct Index {

  build() {
    Column() {
      Button('uniformTypeDescriptorTest')
        .width('50%')
        .height('5%')
        .margin({ top: 15, bottom: 15 } as Margin)
        .onClick(() => {
          uniformTypeDescriptorTest();
        })

      Button('getMimeTypeByFilenameExtensions')
        .width('50%')
        .height('5%')
        .margin({ top: 15, bottom: 15 } as Margin)
        .onClick(() => {
          getMimeTypeByFilenameExtensions();
        })

    Button('getFilenameExtensionByMimeType')
      .width('50%')
      .height('5%')
      .margin({ top: 15, bottom: 15 } as Margin)
      .onClick(() => {
        getFilenameExtensionByMimeType();
      })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .height('100%')
    .width('100%')
  }
}