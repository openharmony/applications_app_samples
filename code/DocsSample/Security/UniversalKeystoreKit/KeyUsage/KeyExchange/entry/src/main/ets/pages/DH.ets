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

/*
*以下以 DH密钥的Promise操作使用为例
*/
import { huks } from '@kit.UniversalKeystoreKit';

function stringToUint8Array(str: string) {
  let arr: number[] = []
  for (let i = 0, j = str.length; i < j; ++i) {
    arr.push(str.charCodeAt(i));
  }
  return new Uint8Array(arr);
}

function uint8ArrayToBigInt(arr: Uint8Array): bigint {
  let i = 0
  const byteMax: bigint = BigInt('0x100')
  let result: bigint = BigInt('0')
  while (i < arr.length) {
    result = result * byteMax
    result = result + BigInt(arr[i])
    i += 1
  }
  return result;
}

const dhAgree: huks.HuksParam[] = [{
  tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
  value: huks.HuksKeyAlg.HUKS_ALG_DH,
}, {
  tag: huks.HuksTag.HUKS_TAG_PURPOSE,
  value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_AGREE,
}]
const dh2048Agree: huks.HuksParam[] = [
  ...dhAgree, {
  tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
  value: huks.HuksKeySize.HUKS_DH_KEY_SIZE_2048,
}]
const dhGenOptions: huks.HuksOptions = {
  properties: dh2048Agree,
  inData: new Uint8Array([])
}
const emptyOptions: huks.HuksOptions = {
  properties: [],
  inData: new Uint8Array([])
}

async function huksDhAgreeExportKey(keyAlias: string,
  peerPubKey: huks.HuksReturnResult): Promise<huks.HuksReturnResult> {
  const initHandle = await huks.initSession(keyAlias, dhGenOptions)
  const dhAgreeUpdateBobPubKey: huks.HuksOptions = {
    properties: [
      ...dh2048Agree, {
      tag: huks.HuksTag.HUKS_TAG_DERIVED_AGREED_KEY_STORAGE_FLAG,
      value: huks.HuksKeyStorageType.HUKS_STORAGE_KEY_EXPORT_ALLOWED,
    }],
    inData: peerPubKey.outData
  }
  await huks.updateSession(initHandle.handle, dhAgreeUpdateBobPubKey)
  return await huks.finishSession(initHandle.handle, emptyOptions)
}

async function huksDhAgreeExportTest(
  aliasA: string, aliasB: string,
  pubKeyA: huks.HuksReturnResult, pubKeyB: huks.HuksReturnResult) {

  const agreedKeyFromAlice = await huksDhAgreeExportKey(aliasA, pubKeyB);
  console.info(`ok! agreedKeyFromAlice export is 0x${uint8ArrayToBigInt(agreedKeyFromAlice.outData).toString(16)}`);

  const agreedKeyFromBob = await huksDhAgreeExportKey(aliasB, pubKeyA);
  console.info(`ok! agreedKeyFromBob export is 0x${uint8ArrayToBigInt(agreedKeyFromBob.outData).toString(16)}`);
}

async function huksDhAgreeInHuks(keyAlias: string, peerPubKey: huks.HuksReturnResult,
  aliasAgreedKey: string): Promise<huks.HuksReturnResult> {
  const onlyUsedInHuks: huks.HuksParam[] = [{
    tag: huks.HuksTag.HUKS_TAG_KEY_STORAGE_FLAG,
    value: huks.HuksKeyStorageType.HUKS_STORAGE_ONLY_USED_IN_HUKS,
  }, {
    tag: huks.HuksTag.HUKS_TAG_DERIVED_AGREED_KEY_STORAGE_FLAG,
    value: huks.HuksKeyStorageType.HUKS_STORAGE_ONLY_USED_IN_HUKS,
  }]
  const dhAgreeInit: huks.HuksOptions = {
    properties: [
      ...dhAgree,
      { tag: huks.HuksTag.HUKS_TAG_KEY_SIZE, value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_256, },
      ...onlyUsedInHuks],
    inData: new Uint8Array([])
  }
  const dhAgreeFinishParams: huks.HuksParam[] = [
    ...onlyUsedInHuks,
    { tag: huks.HuksTag.HUKS_TAG_IS_KEY_ALIAS, value: true },
    { tag: huks.HuksTag.HUKS_TAG_ALGORITHM, value: huks.HuksKeyAlg.HUKS_ALG_AES },
    { tag: huks.HuksTag.HUKS_TAG_KEY_SIZE, value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_256 },
    {
      tag: huks.HuksTag.HUKS_TAG_PURPOSE,
      value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT | huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
    }]

  const handle = await huks.initSession(keyAlias, dhAgreeInit)
  const dhAgreeUpdatePubKey: huks.HuksOptions = {
    properties: [...dhAgree, ...onlyUsedInHuks],
    inData: peerPubKey.outData
  }
  await huks.updateSession(handle.handle, dhAgreeUpdatePubKey)
  const dhAgreeAliceFinnish: huks.HuksOptions = {
    properties: [...dhAgreeFinishParams, {
      tag: huks.HuksTag.HUKS_TAG_KEY_ALIAS, value: stringToUint8Array(aliasAgreedKey)
    }], inData: new Uint8Array([])
  }
  return await huks.finishSession(handle.handle, dhAgreeAliceFinnish);
}

async function huksDhAgreeInHuksTest(
  aliasA: string, aliasB: string,
  pubKeyA: huks.HuksReturnResult, pubKeyB: huks.HuksReturnResult,
  aliasAgreedKeyFromA: string, aliasAgreedKeyFromB: string) {

  const finishAliceResult = await huksDhAgreeInHuks(aliasA, pubKeyB, aliasAgreedKeyFromA);
  console.info(`ok! finishAliceResult in huks is 0x${uint8ArrayToBigInt(finishAliceResult.outData).toString(16)}`);
  const aliceAgreedExist = await huks.isKeyItemExist(aliasAgreedKeyFromA, emptyOptions);
  console.info(`ok! aliceAgreedExist in huks is ${aliceAgreedExist}`);

  const finishBobResult = await huksDhAgreeInHuks(aliasB, pubKeyA, aliasAgreedKeyFromB);
  console.info(`ok! finishBobResult in huks is 0x${uint8ArrayToBigInt(finishBobResult.outData).toString(16)}`);
  const bobAgreedExist = await huks.isKeyItemExist(aliasAgreedKeyFromB, emptyOptions);
  console.info(`ok! bobAgreedExist in huks is ${bobAgreedExist}`);

  await huks.deleteKeyItem(aliasAgreedKeyFromA, emptyOptions);
  await huks.deleteKeyItem(aliasAgreedKeyFromB, emptyOptions);
}

export default async function huksDhAgreeTest() {
  const aliasAlice = 'alice';
  const aliasBob = 'bob';

  /* 调用generateKeyItem生成别名为alice与bob的两个密钥 */
  await huks.generateKeyItem(aliasAlice, dhGenOptions);
  await huks.generateKeyItem(aliasBob, dhGenOptions);

  /* 导出非对称密钥alice与bob的的公钥 */
  const pubKeyAlice = await huks.exportKeyItem(aliasAlice, emptyOptions);
  const pubKeyBob = await huks.exportKeyItem(aliasBob, emptyOptions);

  /* 开始协商，协商生成的密钥返回给业务管理 */
  await huksDhAgreeExportTest(aliasAlice, aliasBob, pubKeyAlice, pubKeyBob);

  /* 开始协商，协商生成的密钥由HUKS管理 */
  await huksDhAgreeInHuksTest(aliasAlice, aliasBob, pubKeyAlice, pubKeyBob, 'agreedKeyFromAlice', 'agreedKeyFromBob');

  await huks.deleteKeyItem(aliasAlice, emptyOptions);
  await huks.deleteKeyItem(aliasBob, emptyOptions);
}

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
