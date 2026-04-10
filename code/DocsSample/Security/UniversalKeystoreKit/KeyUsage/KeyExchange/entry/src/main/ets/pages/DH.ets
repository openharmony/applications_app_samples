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
// [Start key_agreement_dh]

/*
 * 下面以DH密钥的Promise操作使用为例
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

function uint8ArrayToBigInt(arr: Uint8Array): bigint {
  let i = 0;
  const byteMax: bigint = BigInt('0x100');
  let result: bigint = BigInt('0');
  while (i < arr.length) {
    result = result * byteMax;
    result = result + BigInt(arr[i]);
    i += 1;
  }
  return result;
}

function uint8ArrayToString(fileData: Uint8Array) {
  let dataString = '';
  for (let i = 0; i < fileData.length; i++) {
    dataString += String.fromCharCode(fileData[i]);
  }
  return dataString;
}

let handle: number;
let finishOutData: Uint8Array;
let exportKey: Uint8Array;
const dhAgree: huks.HuksParam[] = [{
  tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
  value: huks.HuksKeyAlg.HUKS_ALG_DH,
}, {
  tag: huks.HuksTag.HUKS_TAG_PURPOSE,
  value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_AGREE,
}];
const dh2048Agree: huks.HuksParam[] = [
  ...dhAgree, {
  tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
  value: huks.HuksKeySize.HUKS_DH_KEY_SIZE_2048,
}];
const dhGenOptions: huks.HuksOptions = {
  properties: dh2048Agree,
  inData: new Uint8Array([])
};
const emptyOptions: huks.HuksOptions = {
  properties: [],
  inData: new Uint8Array([])
};

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

async function huksDhAgreeExportKey(keyAlias: string,
  peerPubKey: Uint8Array) {
  await initSession(keyAlias, dhGenOptions);
  const dhAgreeUpdateBobPubKey: huks.HuksOptions = {
    properties: [
      ...dh2048Agree, {
      tag: huks.HuksTag.HUKS_TAG_DERIVED_AGREED_KEY_STORAGE_FLAG,
      value: huks.HuksKeyStorageType.HUKS_STORAGE_KEY_EXPORT_ALLOWED,
    }],
    inData: peerPubKey
  };
  await updateSession(handle, dhAgreeUpdateBobPubKey);
  await finishSession(handle, emptyOptions);
}

async function huksDhAgreeInHuks(keyAlias: string, peerPubKey: Uint8Array,
  aliasAgreedKey: string) {
  const onlyUsedInHuks: huks.HuksParam[] = [{
    tag: huks.HuksTag.HUKS_TAG_KEY_STORAGE_FLAG,
    value: huks.HuksKeyStorageType.HUKS_STORAGE_ONLY_USED_IN_HUKS,
  }, {
    tag: huks.HuksTag.HUKS_TAG_DERIVED_AGREED_KEY_STORAGE_FLAG,
    value: huks.HuksKeyStorageType.HUKS_STORAGE_ONLY_USED_IN_HUKS,
  }];
  const dhAgreeInit: huks.HuksOptions = {
    properties: [
      ...dhAgree,
      { tag: huks.HuksTag.HUKS_TAG_KEY_SIZE, value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_256, },
      ...onlyUsedInHuks],
    inData: new Uint8Array([])
  };
  const dhAgreeFinishParams: huks.HuksParam[] = [
    ...onlyUsedInHuks,
    { tag: huks.HuksTag.HUKS_TAG_IS_KEY_ALIAS, value: true },
    { tag: huks.HuksTag.HUKS_TAG_ALGORITHM, value: huks.HuksKeyAlg.HUKS_ALG_AES },
    { tag: huks.HuksTag.HUKS_TAG_KEY_SIZE, value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_256 },
    {
      tag: huks.HuksTag.HUKS_TAG_PURPOSE,
      value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT | huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
    }
  ];

  await initSession(keyAlias, dhAgreeInit);
  const dhAgreeUpdatePubKey: huks.HuksOptions = {
    properties: [...dhAgree, ...onlyUsedInHuks],
    inData: peerPubKey
  };
  await huks.updateSession(handle.handle, dhAgreeUpdatePubKey);
  const dhAgreeAliceFinish: huks.HuksOptions = {
    properties: [...dhAgreeFinishParams, {
      tag: huks.HuksTag.HUKS_TAG_KEY_ALIAS, value: stringToUint8Array(aliasAgreedKey)
    }], inData: new Uint8Array([])
  };
  return await huks.finishSession(handle.handle, dhAgreeAliceFinish);
}

async function huksDhAgreeInHuksTest(
  aliasA: string, aliasB: string,
  pubKeyA: Uint8Array, pubKeyB: Uint8Array,
  aliasAgreedKeyFromA: string, aliasAgreedKeyFromB: string) {

  await huksDhAgreeInHuks(aliasA, pubKeyB, aliasAgreedKeyFromA);
  const aliceAgreedExist = await huks.isKeyItemExist(aliasAgreedKeyFromA, emptyOptions);
  console.info(`ok! aliceAgreedExist in huks is ${aliceAgreedExist}`);

  await huksDhAgreeInHuks(aliasB, pubKeyA, aliasAgreedKeyFromB);
  const bobAgreedExist = await huks.isKeyItemExist(aliasAgreedKeyFromB, emptyOptions);
  console.info(`ok! bobAgreedExist in huks is ${bobAgreedExist}`);

  await deleteKeyItem(aliasAgreedKeyFromA, emptyOptions);
  await deleteKeyItem(aliasAgreedKeyFromB, emptyOptions);
}

async function huksDhAgreeTest() {
  const aliasAlice = 'alice';
  const aliasBob = 'bob';

  /* 调用generateKeyItem生成别名为alice与bob的两个密钥 */
  await generateKeyItem(aliasAlice, dhGenOptions);
  await generateKeyItem(aliasBob, dhGenOptions);

  /* 导出非对称密钥alice与bob的公钥 */
  await exportKeyItem(aliasAlice, emptyOptions);
  const pubKeyAlice = exportKey;
  await exportKeyItem(aliasBob, emptyOptions);
  const pubKeyBob = exportKey;

  /* 开始协商，协商生成的密钥返回给业务管理 */
  await huksDhAgreeExportKey(aliasAlice, pubKeyBob);
  await huksDhAgreeExportKey(aliasBob, pubKeyAlice);

  /* 开始协商，协商生成的密钥由HUKS管理 */
  await huksDhAgreeInHuksTest(aliasAlice, aliasBob, pubKeyAlice, pubKeyBob, 'agreedKeyFromAlice', 'agreedKeyFromBob');
  /* 设备A、B删除密钥 */
  await deleteKeyItem(aliasAlice, emptyOptions);
  await deleteKeyItem(aliasBob, emptyOptions);
}

// [End key_agreement_dh]
@Entry
@Component
struct Index {
  @State message: string = 'DH';

  build() {
    Column({ space: 12 }) {
      Text(this.message)
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(Infinity)
        .textAlign(TextAlign.Start)
      Button($r('app.string.dh'))
        .padding('12vp')
        .height('40vp')
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_emphasize'))
        .fontSize('14sp')
        .fontColor('#ffffff')
        .onClick(async () => {
          try {
            await huksDhAgreeTest();
            this.message = 'DH Result: Success';
          } catch {
            this.message = 'DH Result: Failed';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
