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

// [Start certificate_chain_validation_for_sm2]

import { cert } from '@kit.DeviceCertificateKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';

function stringToUint8Array(str: string): Uint8Array {
  const encoder = new util.TextEncoder();
  return encoder.encodeInto(str);
}

// [StartExclude certificate_chain_validation_for_sm2]
// 待校验的终端实体证书
let sm2EndEntityCertData = '-----BEGIN CERTIFICATE-----\r\n' +
  'MIICETCCAbegAwIBAgIBAjAKBggqgRzPVQGDdTBiMQswCQYDVQQGEwJYWDELMAkG\r\n' +
  'A1UECAwCWFgxFDASBgNVBAoMC2NlcnRpZmljYXRlMQ8wDQYDVQQLDAZ0ZXN0aW4x\r\n' +
  'HzAdBgNVBAMMFmNlcnRpZmljYXRlLnRlc3Rpbi5jb20wHhcNMjQwNTIyMDcwMDA2\r\n' +
  'WhcNMzQwNTIwMDcwMDA2WjBmMQswCQYDVQQGEwJYWDELMAkGA1UECAwCWFgxFDAS\r\n' +
  'BgNVBAoMC2NlcnRpZmljYXRlMREwDwYDVQQLDAh0ZXN0c2lnbjEhMB8GA1UEAwwY\r\n' +
  'Y2VydGlmaWNhdGUudGVzdHNpZ24uY29tMFkwEwYHKoZIzj0CAQYIKoEcz1UBgi0D\r\n' +
  'QgAEyp/bWrol7RGQaQfSaMgRQGgSBNV8Pu6M6Jl7jYLNlXMQ3Nbc3rU36f7teirK\r\n' +
  'y22ymVlhWnTQOC73AP+uMZp3rqNaMFgwCQYDVR0TBAIwADALBgNVHQ8EBAMCBsAw\r\n' +
  'HQYDVR0OBBYEFA7RZ1QXVll8KuvBR6hmNnldJgAPMB8GA1UdIwQYMBaAFLF6vKQB\r\n' +
  '1DF442gd6o7bN6Yv9u06MAoGCCqBHM9VAYN1A0gAMEUCIQCh+dr3D4bWWZP8M3nJ\r\n' +
  'eqzfKKt2YIsE7YhO3/PVTAhhPwIgarpo3xJ9OlGLgzH/Xl094Jc9rpOtJ/a2fgbw\r\n' +
  'QM9Qpfg=\r\n' +
  '-----END CERTIFICATE-----\r\n';

// 中间CA证书
let sm2IntermediateCaCertData = '-----BEGIN CERTIFICATE-----\r\n' +
  'MIICHjCCAcOgAwIBAgIBATAKBggqgRzPVQGDdTBvMQswCQYDVQQGEwJYWDELMAkG\r\n' +
  'A1UECAwCWFgxCzAJBgNVBAcMAlhYMRQwEgYDVQQKDAtjZXJ0aWZpY2F0ZTEPMA0G\r\n' +
  'A1UECwwGdGVzdGNhMR8wHQYDVQQDDBZjZXJ0aWZpY2F0ZS50ZXN0Y2EuY29tMB4X\r\n' +
  'DTI0MDUyMjA3MDAwNloXDTM0MDUyMDA3MDAwNlowYjELMAkGA1UEBhMCWFgxCzAJ\r\n' +
  'BgNVBAgMAlhYMRQwEgYDVQQKDAtjZXJ0aWZpY2F0ZTEPMA0GA1UECwwGdGVzdGlu\r\n' +
  'MR8wHQYDVQQDDBZjZXJ0aWZpY2F0ZS50ZXN0aW4uY29tMFkwEwYHKoZIzj0CAQYI\r\n' +
  'KoEcz1UBgi0DQgAEN7ryctUk9ISQTs+qQzvk3hTZLj4f90pCfFEC3e8O/au8RTs0\r\n' +
  '3f6fuwGWX0zH297CI80eaAYidzK25FkJZA7PnqNdMFswDAYDVR0TBAUwAwEB/zAL\r\n' +
  'BgNVHQ8EBAMCAQYwHQYDVR0OBBYEFLF6vKQB1DF442gd6o7bN6Yv9u06MB8GA1Ud\r\n' +
  'IwQYMBaAFB+u42AfwCBbDWuMyrC+6RNVkQPWMAoGCCqBHM9VAYN1A0kAMEYCIQDY\r\n' +
  'DSufjGI1nxynGaD+SZR/s4TlPfxgOJ9J4hcT9xpweAIhAMqOe3N5nZVKlZrM71WC\r\n' +
  'lvFqnJkmAkkZ8lJlmp4v79BQ\r\n' +
  '-----END CERTIFICATE-----\r\n';

// 根CA证书证书
let sm2RootCaCertData = '-----BEGIN CERTIFICATE-----\r\n' +
  'MIICQjCCAemgAwIBAgIUVH0RkiQvN0SqTKy1sdDzhXHtkggwCgYIKoEcz1UBg3Uw\r\n' +
  'bzELMAkGA1UEBhMCWFgxCzAJBgNVBAgMAlhYMQswCQYDVQQHDAJYWDEUMBIGA1UE\r\n' +
  'CgwLY2VydGlmaWNhdGUxDzANBgNVBAsMBnRlc3RjYTEfMB0GA1UEAwwWY2VydGlm\r\n' +
  'aWNhdGUudGVzdGNhLmNvbTAeFw0yNDA1MjIwNzAwMDZaFw0zNDA1MjAwNzAwMDZa\r\n' +
  'MG8xCzAJBgNVBAYTAlhYMQswCQYDVQQIDAJYWDELMAkGA1UEBwwCWFgxFDASBgNV\r\n' +
  'BAoMC2NlcnRpZmljYXRlMQ8wDQYDVQQLDAZ0ZXN0Y2ExHzAdBgNVBAMMFmNlcnRp\r\n' +
  'ZmljYXRlLnRlc3RjYS5jb20wWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAAQDpkiQ\r\n' +
  'sEW8nDG9uNqk08YZXOoAoIsNcOXNg+sm2HDraIjY2bLRo4gzfDqxgxAeth871qvR\r\n' +
  'fmHyP5p4l/iqiAnwo2MwYTAdBgNVHQ4EFgQUH67jYB/AIFsNa4zKsL7pE1WRA9Yw\r\n' +
  'HwYDVR0jBBgwFoAUH67jYB/AIFsNa4zKsL7pE1WRA9YwEgYDVR0TAQH/BAgwBgEB\r\n' +
  '/wIBHjALBgNVHQ8EBAMCAQYwCgYIKoEcz1UBg3UDRwAwRAIgDii62EqXUtA7rFTH\r\n' +
  'dFDboGzPHqV9EtZCc4jO1QfQLFoCIFVIa/Sc3G+gRCQsBr6LEwU4d1Dc0o071NSs\r\n' +
  'yjVOeyi/\r\n' +
  '-----END CERTIFICATE-----\r\n';
// [EndExclude certificate_chain_validation_for_sm2]

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

async function validateSm2CertChain(): Promise<void> {
  try {
    let sm2EndEntityCert = await createX509Cert(sm2EndEntityCertData);
    let sm2IntermediateCaCert = await createX509Cert(sm2IntermediateCaCertData);
    let sm2RootCaCert = await createX509Cert(sm2RootCaCertData);

    let userId = new Uint8Array([
      0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38,
      0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38
    ]);

    let params: cert.X509CertValidatorParams = {
      // 不信任的中间证书，用于构建证书链
      untrustedCerts: [sm2IntermediateCaCert],
      // 信任锚证书，用于验证证书链
      trustedCerts: [sm2RootCaCert],
      // 不校验证书有效期（仅用于示例，实际场景建议开启）
      validateDate: false,
      // sm2验签使用的用户ID
      userId: userId
    };
    // 创建证书链校验器实例
    let validator = cert.createCertChainValidator('PKIX');

    // 验证sm2EndEntityCert证书
    let result: cert.VerifyCertResult = await validator.validate(sm2EndEntityCert, params);
    console.info('validate success, certChain length: ' + result.certChain.length);
    for (let i = 0; i < result.certChain.length; i++) {
      let subject = result.certChain[i].getSubjectX500DistinguishedName().getName(cert.EncodingType.ENCODING_UTF8);
      console.info(`Cert ${i} subject: ${subject}`);
      let alg = result.certChain[i].getSignatureAlgName()
      console.info(`Cert ${i} Signature Algorithm: ${alg}`);
    }
  } catch (err) {
    let error = err as BusinessError;
    console.error('validate failed, errCode: ' + error.code + ', errMsg: ' + error.message);
  }
}

// [End certificate_chain_validation_for_sm2]
@Entry
@Component
struct Index {
  @State message: string = 'ValidateSm2CertChain';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Button('Call ValidateSm2CertChain')
        .width('70%')
        .onClick(() => {
          validateSm2CertChain().then(() => {
            this.message = 'Call Success';
          }).catch((err: BusinessError) => {
            this.message = 'Call Fail';
          });
        })
    }
    .height('100%')
    .width('100%')
  }
}