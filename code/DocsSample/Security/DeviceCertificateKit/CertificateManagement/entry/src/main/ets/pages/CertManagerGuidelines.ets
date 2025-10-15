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
// [Start certificate_management_development_guidance]

import { certificateManager } from '@kit.DeviceCertificateKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';

async function privateCredSample() {
  /* 安装的凭据数据需要业务赋值，本例数据非凭据数据。 */
  let keystoreBase64Str = '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';
  /* 凭据数据转换为Uint8Array，凭据数据为der格式 */
  let keystore: Uint8Array = new util.Base64Helper().decodeSync(keystoreBase64Str);

  /* 安装凭据对应的密码，业务赋值。 */
  let keystorePwd: string = 'huawei';
  let appKeyUri: string = '';
  try {
    /* 安装应用证书凭据。 */
    const res: certificateManager.CMResult = await certificateManager.installPrivateCertificate(keystore, keystorePwd, 'testPriCredential');
    appKeyUri = (res.uri != undefined) ? res.uri : '';
    console.info(`InstallPrivateCertificate success appKeyUri: ${appKeyUri}`);
  } catch (err) {
    let e: BusinessError = err as BusinessError;
    console.error(`Failed to install private certificate. Code: ${e.code}, message: ${e.message}`);
  }

  try {
    /* 获取应用证书凭据。 */
    let res: certificateManager.CMResult = await certificateManager.getPrivateCertificate(appKeyUri);
    if (res === undefined || res.credential == undefined) {
      console.error('The result of getting private certificate is undefined.');
    } else {
      let credential = res.credential;
      console.info('Succeeded in getting private certificate.');
    }
  } catch (err) {
    console.error(`Failed to get private certificate. Code: ${err.code}, message: ${err.message}`);
  }

  try {
    /* srcData为待签名、验签的数据，业务自行赋值。 */
    let srcData: Uint8Array = new Uint8Array([
      0x86, 0xf7, 0x0d, 0x01, 0x07, 0x01,
    ]);

    /* 构造签名的属性参数。 */
    const signSpec: certificateManager.CMSignatureSpec = {
      purpose: certificateManager.CmKeyPurpose.CM_KEY_PURPOSE_SIGN,
      padding: certificateManager.CmKeyPadding.CM_PADDING_PSS,
      digest: certificateManager.CmKeyDigest.CM_DIGEST_SHA256
    };

    /* 签名。 */
    const signHandle: certificateManager.CMHandle = await certificateManager.init(appKeyUri, signSpec);
    await certificateManager.update(signHandle.handle, srcData);
    const signResult: certificateManager.CMResult = await certificateManager.finish(signHandle.handle);

    /* 构造验签的属性参数。 */
    const verifySpec: certificateManager.CMSignatureSpec = {
      purpose: certificateManager.CmKeyPurpose.CM_KEY_PURPOSE_VERIFY,
      padding: certificateManager.CmKeyPadding.CM_PADDING_PSS,
      digest: certificateManager.CmKeyDigest.CM_DIGEST_SHA256
    };

    /* 验签。 */
    const verifyHandle: certificateManager.CMHandle = await certificateManager.init(appKeyUri, verifySpec);
    await certificateManager.update(verifyHandle.handle, srcData);
    const verifyResult = await certificateManager.finish(verifyHandle.handle, signResult.outData);
    console.info('Succeeded in signing and verifying.');
  } catch (err) {
    let e: BusinessError = err as BusinessError;
    console.error(`Failed to sign or verify. Code: ${e.code}, message: ${e.message}`);
  }

  try {
    /* 删除应用证书凭据。 */
    await certificateManager.uninstallPrivateCertificate(appKeyUri);
  } catch (err) {
    let e: BusinessError = err as BusinessError;
    console.error(`Failed to uninstall private certificate. Code: ${e.code}, message: ${e.message}`);
  }
}

// [End certificate_management_development_guidance]

@Entry
@Component
struct Index {
  @State message: string = 'CertManagerGuidelines';

  build() {
    Column({space: 5}) {
      Text(this.message)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.call_certManagerGuidelines'))
        .width('70%')
        .onClick(()=>{
          privateCredSample();
          this.message = 'CertManagerGuidelines Success';
        })
    }
    .height('100%')
    .width('100%')
  }
}