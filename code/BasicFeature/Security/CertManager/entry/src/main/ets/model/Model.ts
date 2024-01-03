/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import certManager from '@ohos.security.certManager';
import util from '@ohos.util';
import Logger from './Logger';
import { PRI_RSA_DATA, STAIN_SIGNATURE_TEXT, TAG } from './Data';
interface IDataInfo {
  originInfo: string;
  certTextInfo: string;
  signatureInfo: string;
}

interface IResponse {
  code: number;
  data: string;
  message?: string;
}

function stringToUint8Array(str: String): Uint8Array {
  if (str.length === 0) {
    Logger.error(TAG, 'str length is 0');
    return null;
  }

  let len = str.length;
  let tempArray = [];
  for (let i = 0; i < len; ++i) {
    tempArray.push(str.charCodeAt(i));
  }
  let array = new Uint8Array(tempArray);
  return array;
}

/**
 * 功能模型
 */
export class CertManagerModel {
  // origin data
  private originText = 'Dear Tom, can we go for a spring outing on Sunday at the Central Garden?';
  private originData = stringToUint8Array(this.originText);
  private stainOriginText = 'Dear Tom, can we go for a spring outing together on Monday at the lakeside garden?';

  private utilBase = new util.Base64Helper();

  // signature data
  private signature: Uint8Array;
  private stainSignature: Uint8Array;
  private cmResult: certManager.CMResult;

  dataDisplay(): IDataInfo {
    this.cmResult = null;
    this.signature = null;
    this.stainSignature = null;
    this.originData = stringToUint8Array(this.originText);
    return {
      certTextInfo: this.utilBase.encodeToStringSync(PRI_RSA_DATA),
      originInfo: this.originText,
      signatureInfo: ''
    };
  }

  modifyOriginData(): IDataInfo {
    this.originData = stringToUint8Array(this.stainOriginText);
    this.signature = this.stainSignature;
    return {
      certTextInfo: this.utilBase.encodeToStringSync(PRI_RSA_DATA),
      originInfo: this.stainOriginText,
      signatureInfo: this.signature ? this.utilBase.encodeToStringSync(this.signature) : ''
    };
  }

  modifySignatureData(): IDataInfo {
    this.originData = stringToUint8Array(this.originText);
    if (this.signature) {
      this.signature = STAIN_SIGNATURE_TEXT;
    }
    return {
      certTextInfo: this.utilBase.encodeToStringSync(PRI_RSA_DATA),
      originInfo: this.originText,
      signatureInfo: this.signature ? this.utilBase.encodeToStringSync(this.signature) : ''
    };
  }

  async install(): Promise<IResponse> {
    const keystorePwd: string = '123456';
    const certAlias: string = 'testPriCredential001';
    try {
      this.cmResult = await certManager.installPrivateCertificate(PRI_RSA_DATA, keystorePwd, certAlias);
      Logger.info(TAG, 'install success.');
      return {
        code: 200,
        data: ''
      };
    } catch (err) {
      Logger.error(TAG, 'install error.');
      return {
        code: err.code,
        data: err.message
      };
    }
  }

  async sign(): Promise<IResponse> {
    if (!this.cmResult) {
      await this.install();
    }
    const signSpec = {
      padding: certManager.CmKeyPadding.CM_PADDING_PSS,
      digest: certManager.CmKeyDigest.CM_DIGEST_SHA1,
      purpose: certManager.CmKeyPurpose.CM_KEY_PURPOSE_SIGN
    };

    try {
      const signHandle = await certManager.init(this.cmResult.uri, signSpec);
      await certManager.update(signHandle.handle, this.originData);
      const signResult = await certManager.finish(signHandle.handle);

      this.stainSignature = signResult.outData;
      this.signature = signResult.outData;
      Logger.error(TAG, 'sign success.');
      return {
        code: 200,
        data: this.utilBase.encodeToStringSync(this.signature)
      };
    } catch (err) {
      Logger.error(TAG, 'sign error.');
      return {
        code: err.code,
        message: err.message,
        data: err.message
      };
    }
  }

  async verify(): Promise<IResponse> {
    if (!this.signature) {
      await this.sign();
    }
    const verifySpec = {
      padding: certManager.CmKeyPadding.CM_PADDING_PSS,
      digest: certManager.CmKeyDigest.CM_DIGEST_SHA1,
      purpose: certManager.CmKeyPurpose.CM_KEY_PURPOSE_VERIFY
    };
    try {
      const verifyHandle = await certManager.init(this.cmResult.uri, verifySpec);
      await certManager.update(verifyHandle.handle, this.originData);
      await certManager.finish(verifyHandle.handle, this.signature);
      Logger.error(TAG, 'verify success.');
      return {
        code: 200,
        data: this.utilBase.encodeToStringSync(this.signature),
      };
    } catch (err) {
      Logger.error(TAG, 'verify error.');
      return {
        code: err.code,
        message: err.message,
        data: this.utilBase.encodeToStringSync(this.signature),
      };
    }
  }
}
