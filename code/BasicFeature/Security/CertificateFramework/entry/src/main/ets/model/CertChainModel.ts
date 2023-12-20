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
import Logger from './Logger';
import { CHAIN_DATA_CRL, CHAIN_DATA_HAS_CRL, CHAIN_DATA_MAP, CHAIN_DATA_ROOT, stringToUint8Array } from './Data';

interface IDataInfo {
  certChainData: string;
  certChainRoot: string;
  certChainCRL: string;
}

interface IResponse {
  code: number;
}
/**
 * 功能模型
 */
export class CertChainModel {
  private tag = 'CertChain';
  private certChain: cert.X509CertChain;

  dataDisplay(): IDataInfo {
    return {
      certChainData: CHAIN_DATA_HAS_CRL,
      certChainRoot: CHAIN_DATA_ROOT,
      certChainCRL: CHAIN_DATA_CRL,
    };
  }

  async createX509CertChain(): Promise<void> {
    const encodingBlob: cert.EncodingBlob = {
      data: stringToUint8Array(CHAIN_DATA_HAS_CRL),
      encodingFormat: cert.EncodingFormat.FORMAT_PEM
    };
    try {
      this.certChain = await cert.createX509CertChain(encodingBlob);
      Logger.info(this.tag, 'createX509CertChain success.');
    } catch (err) {
      Logger.info(this.tag, JSON.stringify(err));
    }
  }

  async validate(hasCrl: boolean): Promise<IResponse> {
    if (!this.certChain) {
      await this.createX509CertChain();
    }
    try {
      const validateParameters = await this.createValidateParameters(hasCrl);
      const res = await this.certChain.validate(validateParameters);
      Logger.info(this.tag, 'validate success.');
      return {
        code: res ? 200 : -1
      };
    } catch (err) {
      Logger.error(this.tag, 'validate error.');
      return {
        code: -1
      };
    }
  }

  async createValidateParameters(hasCrl: boolean): Promise<cert.CertChainValidationParameters> {
    const encodingBlob = {
      data: stringToUint8Array(CHAIN_DATA_ROOT),
      encodingFormat: cert.EncodingFormat.FORMAT_PEM
    };
    const x509Cert = await cert.createX509Cert(encodingBlob);

    const trustAnchors = [
      {
        CACert: x509Cert,
        CAPubKey: CHAIN_DATA_MAP.CAPubKey,
        CASubject: CHAIN_DATA_MAP.CASubject
      }
    ];

    const validateParameters: cert.CertChainValidationParameters = {
      trustAnchors
    };

    if (hasCrl) {
      const encodingBlob = {
        data: stringToUint8Array(CHAIN_DATA_CRL),
        encodingFormat: cert.EncodingFormat.FORMAT_PEM
      };
      const crl = await cert.createX509CRL(encodingBlob);
      const certCrlCollection = await cert.createCertCRLCollection([], [crl]);
      validateParameters.certCRLs = [certCrlCollection];
    };

    return validateParameters;
  }
}
