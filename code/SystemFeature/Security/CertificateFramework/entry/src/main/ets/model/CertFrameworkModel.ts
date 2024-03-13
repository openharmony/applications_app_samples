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

import cert from '@ohos.security.cert';
import cryptoFrameWork from '@ohos.security.cryptoFramework';
import util from '@ohos.util';
import { CERT_DATA, SIGNATURE_TEXT, STAIN_SIGNATURE_TEXT, stringToUint8Array, TAG } from './Data';
import Logger from './Logger';

export interface IDataInfo {
  certInfo: string;
  originInfo: string;
  signatureInfo: string;
}

/**
 * 功能模型
 */
export class CertFrameworkModel {
  // cert data
  private certEncodingBlob = {
    data: CERT_DATA,
    encodingFormat: cert.EncodingFormat.FORMAT_DER
  };

  // origin data
  private originText: String = 'Dear Tom, can we go for a spring outing on Sunday at the Central Garden?';

  private originData = { data: stringToUint8Array(this.originText) };

  private stainOriginText: String = 'Dear Tom, can we go for a spring outing together on Monday at the lakeside garden?';

  // signature data
  private signature: cryptoFrameWork.DataBlob = { data: SIGNATURE_TEXT };


  async dataDisplay(callback): Promise<void> {
    this.originData.data = stringToUint8Array(this.originText);
    this.signature.data = SIGNATURE_TEXT;

    let utilBase = new util.Base64Helper();
    let data = {
      certInfo: utilBase.encodeToStringSync(CERT_DATA),
      originInfo: this.originText,
      signatureInfo: utilBase.encodeToStringSync(SIGNATURE_TEXT)
    };
    callback(data);
  }

  async modifyOriginData(callback): Promise<void> {
    this.originData.data = stringToUint8Array(this.stainOriginText);
    this.signature.data = SIGNATURE_TEXT;

    let utilBase = new util.Base64Helper();
    let data = {
      originInfo: this.stainOriginText,
      signatureInfo: utilBase.encodeToStringSync(SIGNATURE_TEXT)
    };
    callback(data);
  }

  async modifySignatureData(callback): Promise<void> {
    this.originData.data = stringToUint8Array(this.originText);
    this.signature.data = STAIN_SIGNATURE_TEXT;

    let utilBase = new util.Base64Helper();
    let data = {
      originInfo: this.originText,
      signatureInfo: utilBase.encodeToStringSync(STAIN_SIGNATURE_TEXT)
    };
    callback(data);
  }

  private async getPubKey(callback): Promise<void> {
    let certObject: cert.X509Cert;
    let pubKey: cryptoFrameWork.PubKey;

    // create x509 cert object
    await cert.createX509Cert(this.certEncodingBlob).then((x509Cert) => {
      Logger.info(TAG, 'create x509 cert object success.');
      certObject = x509Cert;
    }).catch((err) => {
      Logger.error(TAG, `create x509 cert object failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });

    // get pubKey from cert
    try {
      let pubKeyObject: cryptoFrameWork.PubKey = certObject.getPublicKey();
      let pubKeyBlob: cryptoFrameWork.DataBlob = pubKeyObject.getEncoded();
      let keyGenerator: cryptoFrameWork.AsyKeyGenerator = cryptoFrameWork.createAsyKeyGenerator('RSA1024');

      await keyGenerator.convertKey(pubKeyBlob, null).then((keyPair) => {
        Logger.info(TAG, 'get keyPair success.');
        pubKey = keyPair.pubKey;
        callback(pubKey);
      }).catch((err) => {
        Logger.error(TAG, `get keyPair failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
      });
      Logger.info(TAG, 'get pubKey success.');
    } catch (err) {
      Logger.error(TAG, `get pubKey failed, ${JSON.stringify(err)}`);
    }
  }

  async verify(callback): Promise<void> {
    // get pubkey
    let pubKey: cryptoFrameWork.PubKey;
    await this.getPubKey((result) => {
      pubKey = result;
    });

    // create verifier
    let verifier: cryptoFrameWork.Verify;
    try {
      verifier = cryptoFrameWork.createVerify('RSA1024|PKCS1|SHA256');
      Logger.info(TAG, 'create verifier success.');
    } catch (err) {
      Logger.error(TAG, `create verifier, ${JSON.stringify(err)}`);
    }

    // verify init
    await verifier.init(pubKey).then(() => {
      Logger.info(TAG, 'verify init success.');
    }).catch((err) => {
      Logger.error(TAG, `verify init failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });

    // verify operation
    await verifier.verify(this.originData, this.signature).then((res) => {
      Logger.info(TAG, 'verify operation success.');
      let result = res;
      callback(result);
    }).catch((err) => {
      Logger.error(TAG, `verify operation failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });
  }
}