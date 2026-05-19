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

// [Start certificate_chain_validation_with_system_ca]

import { cert } from '@kit.DeviceCertificateKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';

// string转Uint8Array。
function stringToUint8Array(str: string): Uint8Array {
  const encoder = new util.TextEncoder();
  return encoder.encodeInto(str);
}

// [StartExclude certificate_chain_validation_with_system_ca]
// 待校验的终端实体证书
let endEntityCertData = '-----BEGIN CERTIFICATE-----\r\n' +
  'MIIIBDCCBuygAwIBAgIMIQ6D5jWg1xsz8IC1MA0GCSqGSIb3DQEBCwUAMFAxCzAJ\r\n' +
  'BgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSYwJAYDVQQDEx1H\r\n' +
  'bG9iYWxTaWduIFJTQSBPViBTU0wgQ0EgMjAxODAeFw0yNTA3MDIwNjM2MDNaFw0y\r\n' +
  'NjA4MDMwNjM2MDJaMIGGMQswCQYDVQQGEwJDTjEQMA4GA1UECBMHSmlhbmdzdTEQ\r\n' +
  'MA4GA1UEBxMHTmFuamluZzEvMC0GA1UEChMmSHVhd2VpIFNvZnR3YXJlIFRlY2hu\r\n' +
  'b2xvZ2llcyBDby4sIEx0ZC4xIjAgBgNVBAMTGWxvZ3NlcnZpY2UxLmRiYW5rY2xv\r\n' +
  'dWQuY24wggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQCOkSeHSJaUHsAh\r\n' +
  '9jHzar5MQnA6mKYJw7ho8Q9yrcx1K7qj49wl+a2zQ9v+CpXHnX7UfO2SiGvbS0w0\r\n' +
  '9zeckFwxj7NZJNH2+qFzutkNIaDq4k71e9VhrniISYA+a9Ej9LCacTf2p+J75Ks7\r\n' +
  'KyC7OynlFCrx9J6UmIkOiJBGMxxFbtuwyrmTxNS4l/RZQ3GWO1a/OL0sIEQIcnHj\r\n' +
  'd0mGIVUOpeJsx7kI100/W/Jy2n2WYbe/FSBOqhDvNhLtMe8wIzu71Ljo9QSCfVry\r\n' +
  'lucfI1TC60QTLP9smPqqKNnxZn7pDwp0DSMTECa/Qmxwui36+U2fwCSuBfbfAeOK\r\n' +
  'bhd+1Eq52Ki+eWRPeI6ACc6ai+C+RuYJgFysBphT+uOXCCL300zmUbzDkghicSsG\r\n' +
  'iRng24/MAokEMdi8PdIchax5wDWR9Ox3W8+RUACqAoC3wecDDJ+E/tYw/ro9QTWP\r\n' +
  'V9dXA6r3R7QaxB9fYqm7p3bbnlOrhBYmb0Jv+KPQ+qUePgOPDhMCAwEAAaOCBCUw\r\n' +
  'ggQhMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMIGOBggrBgEFBQcBAQSB\r\n' +
  'gTB/MEQGCCsGAQUFBzAChjhodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2Nh\r\n' +
  'Y2VydC9nc3JzYW92c3NsY2EyMDE4LmNydDA3BggrBgEFBQcwAYYraHR0cDovL29j\r\n' +
  'c3AuZ2xvYmFsc2lnbi5jb20vZ3Nyc2FvdnNzbGNhMjAxODBWBgNVHSAETzBNMEEG\r\n' +
  'CSsGAQQBoDIBFDA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWdu\r\n' +
  'LmNvbS9yZXBvc2l0b3J5LzAIBgZngQwBAgIwPwYDVR0fBDgwNjA0oDKgMIYuaHR0\r\n' +
  'cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3JzYW92c3NsY2EyMDE4LmNybDCB9QYD\r\n' +
  'VR0RBIHtMIHqghlsb2dzZXJ2aWNlMS5kYmFua2Nsb3VkLmNugg8qLmRiYW5rY2xv\r\n' +
  'dWQuY26CECouZGJhbmtjbG91ZC5jb22CDSouaGljbG91ZC5jb22CECouZHQuaGlj\r\n' +
  'bG91ZC5jb22CEiouY2xvdWQuaHVhd2VpLmNvbYIUKi50aGluZ3MuaGljbG91ZC5j\r\n' +
  'b22CFiouYnVnYm91bnR5Lmh1YXdlaS5jb22CDCouaHVhd2VpLmNvbYIWKi5kZXZl\r\n' +
  'bG9wZXIuaHVhd2VpLmNvbYIQKi5vcC5oaWNsb3VkLmNvbYIPKi5oYXJtb255b3Mu\r\n' +
  'Y29tMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAfBgNVHSMEGDAWgBT4\r\n' +
  '73/yzXhnqN5vjySNiPGHAwKz6zAdBgNVHQ4EFgQU/1F8htpS+aPKi25LCdrPMcDJ\r\n' +
  'vWAwggF+BgorBgEEAdZ5AgQCBIIBbgSCAWoBaAB1AMs49xWJfIShRF9bwd37yW7y\r\n' +
  'mlnNRwppBYWwyxTDFFjnAAABl8nZj5cAAAQDAEYwRAIgfPQurIKPP9QFyk+FvuM8\r\n' +
  'EDULQ0Y/+aswyXm1njl2+4gCIAmpcyQUItRca4DYe4NwlnflJeDP2OGuBfb4dtvN\r\n' +
  'OcgkAHcA2AlVO5RPev/IFhlvlE+Fq7D4/F6HVSYPFdEucrtFSxQAAAGXydmPoQAA\r\n' +
  'BAMASDBGAiEAwlFW3u9G/UnSV6zPgRDfOF95ty+PUmRwVfL6Gl7KQ5ICIQDlCJ5f\r\n' +
  '7luAEkbhT8T3VWTtOlzXY5OzJwMF3v4VcE1SGQB2AMIxfldFGaNF7n843rKQQevH\r\n' +
  'wiFaIr9/1bWtdprZDlLNAAABl8nZkQ4AAAQDAEcwRQIgcM0rZSzfxkxPeGlaepYP\r\n' +
  'vXxIe77WcKJOuX0BLVVsgrcCIQCgKvdD3zJ5ettx6eVkeKftShLwNa1jBzEoZRv4\r\n' +
  'aIGMmzANBgkqhkiG9w0BAQsFAAOCAQEAGj6foM35o54ujB2UUzQ4ZrGIeVtlYgYJ\r\n' +
  'oUDlWaiXzLwCEVdUsgIMQ81y6UXshMUbJoH2eNZXiEHYQDd1qcgui++GLIAID31+\r\n' +
  'iG0/gOhikhmNiGEfvTAsnaLVxwtb05W0IaBvG69xCTAHJuNfYNaPP7J1IzHYnDUk\r\n' +
  'mg72KkvF7kMXEzYgJ6EPiP7L+FJ1fIggu3fJVW9f3HjAEtMail9W7Ekn/kIzwjNs\r\n' +
  '8somwVMAvOSSc3nXejQieufpQlMZZB8YlMYMQalwoRea4h9CSvUBYz3CMxa9lyh0\r\n' +
  'RLvFpzNoUuYm6lZoStoySmr4hdk5QDMEVy+L5m24sqN7kHOgPnomSg==\r\n' +
  '-----END CERTIFICATE-----\r\n';

// 中间CA证书
let intermediateCaCertData = '-----BEGIN CERTIFICATE-----\r\n' +
  'MIIETjCCAzagAwIBAgINAe5fIh38YjvUMzqFVzANBgkqhkiG9w0BAQsFADBMMSAw\r\n' +
  'HgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFs\r\n' +
  'U2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjAeFw0xODExMjEwMDAwMDBaFw0yODEx\r\n' +
  'MjEwMDAwMDBaMFAxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52\r\n' +
  'LXNhMSYwJAYDVQQDEx1HbG9iYWxTaWduIFJTQSBPViBTU0wgQ0EgMjAxODCCASIw\r\n' +
  'DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKdaydUMGCEAI9WXD+uu3Vxoa2uP\r\n' +
  'UGATeoHLl+6OimGUSyZ59gSnKvuk2la77qCk8HuKf1UfR5NhDW5xUTolJAgvjOH3\r\n' +
  'idaSz6+zpz8w7bXfIa7+9UQX/dhj2S/TgVprX9NHsKzyqzskeU8fxy7quRU6fBhM\r\n' +
  'abO1IFkJXinDY+YuRluqlJBJDrnw9UqhCS98NE3QvADFBlV5Bs6i0BDxSEPouVq1\r\n' +
  'lVW9MdIbPYa+oewNEtssmSStR8JvA+Z6cLVwzM0nLKWMjsIYPJLJLnNvBhBWk0Cq\r\n' +
  'o8VS++XFBdZpaFwGue5RieGKDkFNm5KQConpFmvv73W+eka440eKHRwup08CAwEA\r\n' +
  'AaOCASkwggElMA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0G\r\n' +
  'A1UdDgQWBBT473/yzXhnqN5vjySNiPGHAwKz6zAfBgNVHSMEGDAWgBSP8Et/qC5F\r\n' +
  'JK5NUPpjmove4t0bvDA+BggrBgEFBQcBAQQyMDAwLgYIKwYBBQUHMAGGImh0dHA6\r\n' +
  'Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9yb290cjMwNgYDVR0fBC8wLTAroCmgJ4Yl\r\n' +
  'aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIzLmNybDBHBgNVHSAEQDA+\r\n' +
  'MDwGBFUdIAAwNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5j\r\n' +
  'b20vcmVwb3NpdG9yeS8wDQYJKoZIhvcNAQELBQADggEBAJmQyC1fQorUC2bbmANz\r\n' +
  'EdSIhlIoU4r7rd/9c446ZwTbw1MUcBQJfMPg+NccmBqixD7b6QDjynCy8SIwIVbb\r\n' +
  '0615XoFYC20UgDX1b10d65pHBf9ZjQCxQNqQmJYaumxtf4z1s4DfjGRzNpZ5eWl0\r\n' +
  '6r/4ngGPoJVpjemEuunl1Ig423g7mNA2eymw0lIYkN5SQwCuaifIFJ6GlazhgDEw\r\n' +
  'fpolu4usBCOmmQDo8dIm7A9+O4orkjgTHY+GzYZSR+Y0fFukAj6KYXwidlNalFMz\r\n' +
  'hriSqHKvoflShx8xpfywgVcvzfTO3PYkz6fiNJBonf6q8amaEsybwMbDqKWwIX7e\r\n' +
  'SPY=\r\n' +
  '-----END CERTIFICATE-----\r\n';
// [EndExclude certificate_chain_validation_with_system_ca]

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

async function validateCertChainWithSystemCa(): Promise<void> {
  try {
    // 创建证书对象
    let endEntityCert = await createX509Cert(endEntityCertData);
    let intermediateCaCert = await createX509Cert(intermediateCaCertData);

    // 构建校验参数
    let params: cert.CertValidationParams = {
      // 不信任的中间证书，用于构建证书链
      untrustedCerts: [intermediateCaCert],
      // 信任系统预置CA证书
      trustSystemCa: true,
      // 忽略证书过期或未生效
      ignoreErrs: [cert.CertResult.ERR_CERT_HAS_EXPIRED, cert.CertResult.ERR_CERT_NOT_YET_VALID],
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
    let error = err as BusinessError;
    console.error('validate failed, errCode: ' + error.code + ', errMsg: ' + error.message);
    throw new Error(error.message)
  }
}

// [End certificate_chain_validation_with_system_ca]
@Entry
@Component
struct Index {
  @State message: string = 'ValidateCertChainWithSystemCa';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Button('Call ValidateCertChainWithSystemCa')
        .width('70%')
        .onClick(() => {
          validateCertChainWithSystemCa().then(() => {
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