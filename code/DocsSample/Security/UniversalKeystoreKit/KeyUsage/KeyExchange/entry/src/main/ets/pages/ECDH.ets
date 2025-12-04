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
// [Start key_agreement_X25519]

/*
 * 以下以ECDH密钥的Promise操作使用为例
 */
import { huks } from '@kit.UniversalKeystoreKit';
import { BusinessError } from '@kit.BasicServicesKit';

function stringToUint8Array(str: string) {
  let arr: number[] = [];
  for (let i = 0, j = str.length; i < j; ++i) {
    arr.push(str.charCodeAt(i));
  }
  return new Uint8Array(arr);
}

function uint8ArrayToString(fileData: Uint8Array) {
  let dataString = '';
  for (let i = 0; i < fileData.length; i++) {
    dataString += String.fromCharCode(fileData[i]);
  }
  return dataString;
}

/*
 * 确定密钥别名和封装密钥属性参数集
 */
let srcKeyAliasFirst = 'AgreeECDHKeyFirstAlias';
let srcKeyAliasSecond = 'AgreeECDHKeySecondAlias';
let agreeECDHInData = 'AgreeECDHTestIndata';
let finishOutData: Uint8Array;
let handle: number;
let exportKey: Uint8Array;
let exportKeyFirst: Uint8Array;
let exportKeySecond: Uint8Array;
/* 集成生成密钥参数集 */
let properties: huks.HuksParam[] = [{
  tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
  value: huks.HuksKeyAlg.HUKS_ALG_ECC,
}, {
  tag: huks.HuksTag.HUKS_TAG_PURPOSE,
  value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_AGREE,
}, {
  tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
  value: huks.HuksKeySize.HUKS_ECC_KEY_SIZE_256,
}, {
  tag: huks.HuksTag.HUKS_TAG_DIGEST,
  value: huks.HuksKeyDigest.HUKS_DIGEST_NONE,
}, {
  tag: huks.HuksTag.HUKS_TAG_PADDING,
  value: huks.HuksKeyPadding.HUKS_PADDING_NONE,
}, {
  tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
  value: huks.HuksCipherMode.HUKS_MODE_CBC,
}, {
  tag: huks.HuksTag.HUKS_TAG_DERIVED_AGREED_KEY_STORAGE_FLAG,
  value: huks.HuksKeyStorageType.HUKS_STORAGE_ONLY_USED_IN_HUKS,
}
]
let huksOptions: huks.HuksOptions = {
  properties: properties,
  inData: new Uint8Array([])
}
/* 集成第一个协商参数集 */
const finishProperties: huks.HuksParam[] = [{
  tag: huks.HuksTag.HUKS_TAG_DERIVED_AGREED_KEY_STORAGE_FLAG,
  value: huks.HuksKeyStorageType.HUKS_STORAGE_ONLY_USED_IN_HUKS,
}, {
  tag: huks.HuksTag.HUKS_TAG_IS_KEY_ALIAS,
  value: true
}, {
  tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
  value: huks.HuksKeyAlg.HUKS_ALG_ECDH,
}, {
  tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
  value: huks.HuksKeySize.HUKS_ECC_KEY_SIZE_256,
}, {
  tag: huks.HuksTag.HUKS_TAG_PURPOSE,
  value:
  huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT |
  huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT,
}, {
  tag: huks.HuksTag.HUKS_TAG_DIGEST,
  value: huks.HuksKeyDigest.HUKS_DIGEST_NONE,
}, {
  tag: huks.HuksTag.HUKS_TAG_PADDING,
  value: huks.HuksKeyPadding.HUKS_PADDING_NONE,
}, {
  tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
  value: huks.HuksCipherMode.HUKS_MODE_CBC,
}
];
let finishOptionsFirst: huks.HuksOptions = {
  properties: [
    ...finishProperties, {
    tag: huks.HuksTag.HUKS_TAG_KEY_ALIAS,
    value: stringToUint8Array(srcKeyAliasFirst + 'final'),
  }],
  inData: stringToUint8Array(agreeECDHInData)
}
/* 集成第二个协商参数集 */
let finishOptionsSecond: huks.HuksOptions = {
  properties: [
    ...finishProperties, {
    tag: huks.HuksTag.HUKS_TAG_KEY_ALIAS,
    value: stringToUint8Array(srcKeyAliasSecond + 'final'),
  }],
  inData: stringToUint8Array(agreeECDHInData)
}

/* 生成密钥 */
async function generateKeyItem(keyAlias: string, huksOptions: huks.HuksOptions) {
  console.info('promise: enter generateKeyItem');
  try {
    await huks.generateKeyItem(keyAlias, huksOptions)
      .then(() => {
        console.info(`promise: generateKeyItem success`);
      }).catch((error: BusinessError) => {
        console.error(`promise: generateKeyItem failed, errCode : ${error.code}, errMsg : ${error.message}`);
      })
  } catch (error) {
    console.error(`promise: generateKeyItem input arg invalid`);
  }
}

/* 初始化密钥会话接口，并获取一个句柄（必选）和挑战值（可选） */
async function initSession(keyAlias: string, huksOptions: huks.HuksOptions) {
  console.info('promise: enter initSession');
  try {
    await huks.initSession(keyAlias, huksOptions)
      .then((data) => {
        handle = data.handle;
        console.info(`promise: initSession success`);
      }).catch((error: BusinessError) => {
        console.error(`promise: initSession failed, errCode : ${error.code}, errMsg : ${error.message}`);
      })
  } catch (error) {
    console.error(`promise: initSession input arg invalid`);
  }
}

/* 分段添加密钥操作的数据并进行相应的密钥操作，输出处理数据 */
async function updateSession(handle: number, huksOptions: huks.HuksOptions) {
  console.info('promise: enter updateSession');
  try {
    await huks.updateSession(handle, huksOptions)
      .then((data) => {
        console.info(`promise: updateSession success, data is ` + uint8ArrayToString(data.outData as Uint8Array));
      }).catch((error: BusinessError) => {
        console.error(`promise: updateSession failed, errCode : ${error.code}, errMsg : ${error.message}`);
      })
  } catch (error) {
    console.error(`promise: updateSession input arg invalid`);
  }
}

/* 结束密钥会话并进行相应的密钥操作，输出处理数据 */
async function finishSession(handle: number, huksOptions: huks.HuksOptions) {
  console.info('promise: enter finishSession');
  try {
    await huks.finishSession(handle, huksOptions)
      .then((data) => {
        finishOutData = data.outData as Uint8Array;
        console.info(`promise: finishSession success, data is ` + uint8ArrayToString(data.outData as Uint8Array));
      }).catch((error: BusinessError) => {
        console.error(`promise: finishSession failed, errCode : ${error.code}, errMsg : ${error.message}`);
      })
  } catch (error) {
    console.error(`promise: finishSession input arg invalid`);
  }
}

/* 导出密钥 */
async function exportKeyItem(keyAlias: string, huksOptions: huks.HuksOptions) {
  console.info('promise: enter exportKeyItem');
  try {
    await huks.exportKeyItem(keyAlias, huksOptions)
      .then((data) => {
        exportKey = data.outData as Uint8Array;
        console.info(`promise: exportKey success, data is ` + uint8ArrayToString(data.outData as Uint8Array));
      }).catch((error: BusinessError) => {
        console.error(`promise: exportKeyItem failed, errCode : ${error.code}, errMsg : ${error.message}`);
      })
  } catch (error) {
    console.error(`promise: exportKeyItem input arg invalid`);
  }
}

/* 删除密钥操作 */
async function deleteKeyItem(keyAlias: string, huksOptions: huks.HuksOptions) {
  console.info('promise: enter deleteKeyItem');
  try {
    await huks.deleteKeyItem(keyAlias, huksOptions)
      .then(() => {
        console.info(`promise: deleteKeyItem success`);
      }).catch((error: BusinessError) => {
        console.error(`promise: deleteKeyItem failed, errCode : ${error.code}, errMsg : ${error.message}`);
      })
  } catch (error) {
    console.error(`promise: deleteKeyItem input arg invalid`);
  }
}

async function testAgree() {
  /* 1.确定密钥别名并集成要参数集。A设备：srcKeyAliasFirst；B设备：srcKeyAliasSecond */
  /* 2.设备A生成密钥 */
  await generateKeyItem(srcKeyAliasFirst, huksOptions);
  /* 3.设备B生成密钥 */
  await generateKeyItem(srcKeyAliasSecond, huksOptions);
  /* 4.设备A、B导出非对称密钥的公钥 */
  await exportKeyItem(srcKeyAliasFirst, huksOptions);
  exportKeyFirst = exportKey;
  await exportKeyItem(srcKeyAliasSecond, huksOptions);
  exportKeySecond = exportKey;
  /* 5.对第一个密钥进行协商（三段式） */
  await initSession(srcKeyAliasFirst, huksOptions);
  huksOptions.inData = exportKeySecond;
  await updateSession(handle, huksOptions);
  await finishSession(handle, finishOptionsFirst);
  /* 6.对第二个密钥进行协商（三段式） */
  await initSession(srcKeyAliasSecond, huksOptions);
  huksOptions.inData = exportKeyFirst;
  await updateSession(handle, huksOptions);
  await finishSession(handle, finishOptionsSecond);
  /* 7.设备A、B删除密钥 */
  await deleteKeyItem(srcKeyAliasFirst, huksOptions);
  await deleteKeyItem(srcKeyAliasSecond, huksOptions);
}


// [End key_agreement_ECDH]
@Entry
@Component
struct Index {
  @State message: string = 'ECDH';

  build() {
    Column({ space: 12 }) {
      Text(this.message)
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(Infinity)
        .textAlign(TextAlign.Start)
      Button($r('app.string.ecdh'))
        .padding('12vp')
        .height('40vp')
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_emphasize'))
        .fontSize('14sp')
        .fontColor('#ffffff')
        .onClick(async () => {
          try {
            await testAgree();
            this.message = 'ECDH Result: Success';
          } catch {
            this.message = 'ECDH Result: Failed';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
