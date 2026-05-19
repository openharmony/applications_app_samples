/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start certificate_chain_validation_with_custom_trust_anchor]

import { cert } from '@kit.DeviceCertificateKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';

// string转Uint8Array。
function stringToUint8Array(str: string): Uint8Array {
  const encoder = new util.TextEncoder();
  return encoder.encodeInto(str);
}

// [StartExclude certificate_chain_validation_with_custom_trust_anchor]
// 待校验的终端实体证书
let endEntityCertData = '-----BEGIN CERTIFICATE-----\n' +
  'MIICwzCCAmmgAwIBAgIUIThWddD/8p7w5QyXOoRY05O61FMwCgYIKoZIzj0EAwIw\n' +
  'gYsxCzAJBgNVBAYTAkNOMRAwDgYDVQQIDAdCZWlqaW5nMRAwDgYDVQQHDAdCZWlq\n' +
  'aW5nMRowGAYDVQQKDBFUZXN0IE9yZ2FuaXphdGlvbjEdMBsGA1UECwwUVGVzdCBJ\n' +
  'bnRlcm1lZGlhdGUgQ0ExHTAbBgNVBAMMFFRlc3QgSW50ZXJtZWRpYXRlIENBMB4X\n' +
  'DTI2MDMzMTA4MjY1OFoXDTI3MDMzMTA4MjY1OFowgYIxCzAJBgNVBAYTAkNOMRAw\n' +
  'DgYDVQQIDAdCZWlqaW5nMRAwDgYDVQQHDAdCZWlqaW5nMRowGAYDVQQKDBFUZXN0\n' +
  'IE9yZ2FuaXphdGlvbjEYMBYGA1UECwwPVGVzdCBEZXBhcnRtZW50MRkwFwYDVQQD\n' +
  'DBB0ZXN0LmV4YW1wbGUuY29tMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEspH8\n' +
  'JVcqNrg7oP4PYHADsW8tc1kIF86JG5SSjh1fz4ja3dF98PMMrsbQtcBZiwp8rD5e\n' +
  'Gp2Nv/C2ymnjJfrig6OBsTCBrjAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIFoDAd\n' +
  'BgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwHQYDVR0OBBYEFH6aJ7ZQayEZ\n' +
  'LeenLt7zowBoafRpMB8GA1UdIwQYMBaAFI2lMRV2YgzF/DBP92jUzOLdzSDdMDIG\n' +
  'A1UdEQQrMCmCEHRlc3QuZXhhbXBsZS5jb22CD3d3dy5leGFtcGxlLmNvbYcEfwAA\n' +
  'ATAKBggqhkjOPQQDAgNIADBFAiEAidnsForpQc9qTBpa68YEYS0TQRUySHaUB/pr\n' +
  'PNfAYqECIGGKM44mqQgSvZyYQHnlnu3jkbHpFJTaQBAvz9B1jFuc\n' +
  '-----END CERTIFICATE-----\n';

// 中间CA证书
let intermediateCaCertData = '-----BEGIN CERTIFICATE-----\n' +
  'MIICbzCCAhWgAwIBAgIUI8/xor2S98OupuBX6hWevxhvK+wwCgYIKoZIzj0EAwIw\n' +
  'ezELMAkGA1UEBhMCQ04xEDAOBgNVBAgMB0JlaWppbmcxEDAOBgNVBAcMB0JlaWpp\n' +
  'bmcxGjAYBgNVBAoMEVRlc3QgT3JnYW5pemF0aW9uMRUwEwYDVQQLDAxUZXN0IFJv\n' +
  'b3QgQ0ExFTATBgNVBAMMDFRlc3QgUm9vdCBDQTAeFw0yNjAzMzEwODI2NThaFw0z\n' +
  'MTAzMzAwODI2NThaMIGLMQswCQYDVQQGEwJDTjEQMA4GA1UECAwHQmVpamluZzEQ\n' +
  'MA4GA1UEBwwHQmVpamluZzEaMBgGA1UECgwRVGVzdCBPcmdhbml6YXRpb24xHTAb\n' +
  'BgNVBAsMFFRlc3QgSW50ZXJtZWRpYXRlIENBMR0wGwYDVQQDDBRUZXN0IEludGVy\n' +
  'bWVkaWF0ZSBDQTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABER6WRsCn7Bh3v8c\n' +
  'k6PIkLeM+ot5l0A46XJdfvuJco58ifzBHjtu4kFOkZTA9F0Hb6JefG590CK5ddiD\n' +
  'g5lOHwKjZjBkMBIGA1UdEwEB/wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgEGMB0G\n' +
  'A1UdDgQWBBSNpTEVdmIMxfwwT/do1Mzi3c0g3TAfBgNVHSMEGDAWgBS/nd4dYdW3\n' +
  'zFxQ1pl2U8I/bfUA3zAKBggqhkjOPQQDAgNIADBFAiEA87NkGCv47e5RWc8DsFd/\n' +
  'zL6/2Xn2EoveC+HoUYpxhZMCIAG+ZuTLmUsjalUGbWyR101hxHfvr4ImbEMeYSaA\n' +
  'sVBn\n' +
  '-----END CERTIFICATE-----\n';

// 根CA证书
let rootCaCertData = '-----BEGIN CERTIFICATE-----\n' +
  'MIICWzCCAgGgAwIBAgIUd/I1bFJJw/xQtPEJP6C1E4Fj9jswCgYIKoZIzj0EAwIw\n' +
  'ezELMAkGA1UEBhMCQ04xEDAOBgNVBAgMB0JlaWppbmcxEDAOBgNVBAcMB0JlaWpp\n' +
  'bmcxGjAYBgNVBAoMEVRlc3QgT3JnYW5pemF0aW9uMRUwEwYDVQQLDAxUZXN0IFJv\n' +
  'b3QgQ0ExFTATBgNVBAMMDFRlc3QgUm9vdCBDQTAeFw0yNjAzMzEwODI2NTdaFw0z\n' +
  'NjAzMjgwODI2NTdaMHsxCzAJBgNVBAYTAkNOMRAwDgYDVQQIDAdCZWlqaW5nMRAw\n' +
  'DgYDVQQHDAdCZWlqaW5nMRowGAYDVQQKDBFUZXN0IE9yZ2FuaXphdGlvbjEVMBMG\n' +
  'A1UECwwMVGVzdCBSb290IENBMRUwEwYDVQQDDAxUZXN0IFJvb3QgQ0EwWTATBgcq\n' +
  'hkjOPQIBBggqhkjOPQMBBwNCAASFeWawqQET+c6EowNooKYiTw1KPzJBgssxQXo7\n' +
  'UEXSQnLHh8sBwVvNN4oFVFImT31DyJVKwxBXpwbrEN1s8J1Io2MwYTAPBgNVHRMB\n' +
  'Af8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUv53eHWHVt8xcUNaZ\n' +
  'dlPCP231AN8wHwYDVR0jBBgwFoAUv53eHWHVt8xcUNaZdlPCP231AN8wCgYIKoZI\n' +
  'zj0EAwIDSAAwRQIhAIbyIrOZL1GhkRiI2i4IhKmFa4AoXJftTEA5wev99QpkAiA3\n' +
  'khFrJ4rRSpHqbfGN1U14HkFKiCXBalaIe+NISxgC3Q==\n' +
  '-----END CERTIFICATE-----\n';
// [EndExclude certificate_chain_validation_with_custom_trust_anchor]

async function createX509Cert(certData: string): Promise<cert.X509Cert> {
  let encodingBlob: cert.EncodingBlob = {
    data: stringToUint8Array(certData),
    encodingFormat: cert.EncodingFormat.FORMAT_PEM
  };

  let x509Cert: cert.X509Cert = {} as cert.X509Cert;
  try {
    x509Cert = await cert.createX509Cert(encodingBlob);
  } catch (error) {
    let e: BusinessError = error as BusinessError;
    console.error(`createX509Cert failed: errCode: ${e.code}, message: ${e.message}`);
  }
  return x509Cert;
}

async function validateCertChainWithCustomTrustAnchor(): Promise<void> {
  try {
    // 创建证书对象
    let endEntityCert = await createX509Cert(endEntityCertData);
    let intermediateCaCert = await createX509Cert(intermediateCaCertData);
    let rootCaCert = await createX509Cert(rootCaCertData);

    // 构建校验参数
    let params: cert.CertValidationParams = {
      // 不信任的中间证书，用于构建证书链
      untrustedCerts: [intermediateCaCert],
      // 信任锚证书，用于验证证书链
      trustedCerts: [rootCaCert],
      // 不信任系统预置CA证书
      trustSystemCa: false,
      date: '20260422121212Z'
    };
    // 创建证书链校验器实例
    let validator = cert.createCertChainValidator('PKIX');

    // 验证endEntityCert
    let result: cert.CertValidationResult = await validator.validateCert(endEntityCert, params);
    console.info('validate success, certChain length: ' + result.certChain.length);
    for (let i = 0; i < result.certChain.length; i++) {
      let subject = result.certChain[i].getSubjectX500DistinguishedName().getName(cert.EncodingType.ENCODING_UTF8);
      console.info(`Cert ${i} subject: ${subject}`);
    }
  } catch (err) {
    // 校验失败
    let error = err as BusinessError;
    console.error('validate failed, errCode: ' + error.code + ', errMsg: ' + error.message);
    throw new Error(error.message)
  }
}

// [End certificate_chain_validation_with_custom_trust_anchor]
@Entry
@Component
struct Index {
  @State message: string = 'ValidateCertChainWithCustomTrustAnchor';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Button('Call ValidateCertChainWithCustomTrustAnchor')
        .width('70%')
        .onClick(() => {
          validateCertChainWithCustomTrustAnchor().then(() => {
            this.message = 'Call Success';
          }).catch((err: BusinessError) => {
            this.message = 'Call Fail, ' + err.message;
          });
        })
    }
    .height('100%')
    .width('100%')
  }
}