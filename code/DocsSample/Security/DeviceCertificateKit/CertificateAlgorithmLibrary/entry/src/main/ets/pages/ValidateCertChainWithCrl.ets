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

// [Start certificate_chain_validation_with_crl]

import { cert } from '@kit.DeviceCertificateKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';

// string转Uint8Array。
function stringToUint8Array(str: string): Uint8Array {
  const encoder = new util.TextEncoder();
  return encoder.encodeInto(str);
}

// [StartExclude certificate_chain_validation_with_crl]
// 待校验的终端实体证书
let endEntityCertData = '-----BEGIN CERTIFICATE-----\n' +
  'MIIECzCCAfOgAwIBAgIBAjANBgkqhkiG9w0BAQsFADAcMRowGAYDVQQDDBFJbnRl\n' +
  'cm1lZGlhdGUgQ0EgQjAeFw0yNjA0MjIwMzMyMzBaFw0yNzA0MjIwMzMyMzBaMBcx\n' +
  'FTATBgNVBAMMDEVuZCBFbnRpdHkgQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC\n' +
  'AQoCggEBAJ6kDzNZZ2zJWGBzuhkAG/T+iaUAsDX4aD67ymy4IZRaMdyxANMhBY4h\n' +
  'zE8beJVUbbSE5azoBZMLp0Q4hGQJ47oRQs+KDQhcBoyjieTjy5PlGXZRWXS+UUlQ\n' +
  'CitvrKIQdOgEPTobnittM477IdvQvZnG0HyXMJ8JIBqO6P7zKGVLitRp7dFhmlqk\n' +
  'URa+6SQlXR6NEufEr7o0NxmIeW6NFoiR3d5I9dTcac9v7WbnjQJnJrT/OZsu6wO4\n' +
  'g5J0+9XYcfTasUhE4t3uMud83MTYFoc6I+UB7DLXkQ9Izno0L5rsosvreuLt66FU\n' +
  'BZvwhrAAKL1F7WsNUI/4M1QCQEQ4hJUCAwEAAaNdMFswCQYDVR0TBAIwADAOBgNV\n' +
  'HQ8BAf8EBAMCBaAwHQYDVR0OBBYEFJhW2oDE9pORHR/yzzDdPVsrFKIgMB8GA1Ud\n' +
  'IwQYMBaAFL9frj70l74JvBydNByebO70RE6mMA0GCSqGSIb3DQEBCwUAA4ICAQCI\n' +
  'FSWyJ9d9v6IZNbwk15h6lrndLfRY5EKByuucNPuzKewuS1NB/+XlHlD6+nx7Wi79\n' +
  'lacxLk/o6y9SGrvTiKcTDXi+ofunv5YamKc4KODm+AecnsNOVmoRK50/4WON+e8L\n' +
  'szEC6Cy+FTXz3OSt53ryvYcTdZRqKzlWIwDmn7RmduDuewPfUmApuaETDEDo+FgF\n' +
  'DFaqGS25cvHpcrLoGP/zZGk3u3JspMrOhibuo0NSj6hOP5VwrvFL0lM24XfSZBuH\n' +
  'BMuXrcHc+0LDrNCENQU09aKpiymioiaqqxsEQeFV3mImNR67YpSnbg1NgLJdx6vl\n' +
  '1vVqOqG7lph7uJQHTNvKP9lJ4NiFUPbc4gTjY5lq7cbQi33rfybr/gEZhrhuOlNE\n' +
  'vXj83JopNc+J2huB/hvYYEvLlmgh1ekRPo2DMqtmDg80ebqU6DR+MX/ptcCOU/vn\n' +
  'C88EhzYxcshIds/KBVRtTlSgTrVNzlyseiecR8lAa8yHDzZYzqIko4vsVq8Za6JQ\n' +
  'QOpa26OjcMAu5gTZDFUCxtWRfB1p3la8R/tvh+ZJS3lTkd/t+ttTLEF7Zb3xRL/o\n' +
  'hvK+KbTjPeZ6hkk64lm2Dk1T80h0wR5eqabORQXbf1Pz3SP+wsNarOeuJWbQUEpk\n' +
  '3yGEYlpb4HOiaKLsrFOen4u2FQVA8hSvbmb9ClngoQ==\n' +
  '-----END CERTIFICATE-----\n'

// 中间CA证书
let intermediateCaCertData = '-----BEGIN CERTIFICATE-----\n' +
  'MIIFETCCAvmgAwIBAgIBAjANBgkqhkiG9w0BAQsFADAUMRIwEAYDVQQDDAlSb290\n' +
  'IENBIEMwHhcNMjYwNDIyMDMzMjI0WhcNMzEwNDIxMDMzMjI0WjAcMRowGAYDVQQD\n' +
  'DBFJbnRlcm1lZGlhdGUgQ0EgQjCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoC\n' +
  'ggIBAOHx4AS4PDhfotzQhzENLnpg0eRViZedoTirkwcvyosHsfCYo/GlQl/39UDK\n' +
  'tRcsJpf44VodjF5LVNP1p3jdajUbxtIxedlriWQEoLR91zM1pvDDF3/DbQH3XVrK\n' +
  'WBKfoHZnuyI/ALzb3+xMm6yUs36eTU8l74Uvf505CaA3z78HPLK3WHZqIIFa7GCe\n' +
  '7lTAs0kLkWAVemHgZRvrUhe4KDFTJ0pPbRh5Eec8MeNlzdoL+8SLdzWpdHp/UK8j\n' +
  '5MEirYY3ZMS7GsJFCmfGwR3Lt6CgdF1fPUMiBL5U2I7iqSapNRLUaz/YYXkS1tiH\n' +
  'NmQN4tNOGkjVOdJwOGhMVwED2t0gTMvcl1Vkg2eNg+i7E1G5aXM0uvh15uZTMxD5\n' +
  '/40V6LEQpK/ZVXT0/tGz2y62PkZNB3se9BxyPaS7imiucLrk3J5Xb5ZYUY0tghTO\n' +
  '21RKY1x4ZY0vZ+/sdmzmBYIBZGUT2VO+0Ps0JUiCFV/fbcp9wgtEoOX7OXyIn4a2\n' +
  'Ykk3PZ4g5o9uYLuhVkGAP0oCCpe9OIK7Km2HltqBdJimAnQAmir2eleP7/JAqiM4\n' +
  '8s4IGfcxsYwloXEdtcpLcOxWO8SzQ6bHtgXKJz68GZWTfV1k0dkK9aorechVTIUV\n' +
  'Sb2/r2PnkA7DQ8Hyyb6ggXjx7caMfaCxGAOUZ6LGwIl+CiIBAgMBAAGjZjBkMBIG\n' +
  'A1UdEwEB/wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBS/X64+\n' +
  '9Je+CbwcnTQcnmzu9EROpjAfBgNVHSMEGDAWgBRmFRYyyPwx6ybhUTwt5nNR0LTx\n' +
  'FjANBgkqhkiG9w0BAQsFAAOCAgEAVn4OXo8yPqM2pr6JjBRpowfOPDIpWFvdguT6\n' +
  '7dbT3Rc+48rdtQA3S+x1eHYC8pyRek/JB+Ha6RDcCFV6DvqPKm18BHAGmRF8E+Yv\n' +
  'EeI/rzgh8nmZia9VOYLHQu6hhTByJEEAQpUhyXLKMkTtg31hUc6W815i71KcGLfy\n' +
  '7j6pghteRkViIMIEsM6jgzgpfyoAM1jOqIRcnwMGis7pWsnpOXOZnasULb7fOswO\n' +
  'YYsX6rkKtZNpfCE+f6DcAdhYSPIHqF3eHXIbe4SdjjC35BmvMNyauYy09xebjPNA\n' +
  'e3TrBQlHfdwa5aDR7YL0tqZAMv9k3Czff5dT209E+ESR6k3pmOKC+Bk8/Uiiy8p6\n' +
  'oeML/NFDrQsKxKKW8FviNp6hFS9HBcBdvbdwDcf3/VtK1+TaO+J42KRhdLC7t18w\n' +
  'DhZisaKO4vpwwMKkx+KOXLgcJyNJLqmPdeVWdLXJRAqk8qVpzolYbhjN/Wnh/w2T\n' +
  't+yJX2CNvxw2Ta3kYBoPOaOTuJ7dVXvHYW7lcu/bJ9iW6zP18cQn7FMKqUQCl96+\n' +
  'YDG3/1LCW8rEdgfJa7bzdp8QXtxezDEOEoaIBgW4xXR4dHmVJ34HLPQvIWxrW/UL\n' +
  'fzwaehx74azJmcgBbxNvlhySEJhB0MdWA0uArLwZPFrLt2bFUDjqhyHoyYltobzE\n' +
  'QmpA+Gw=\n' +
  '-----END CERTIFICATE-----\n'

// 根CA证书
let rootCaCertData = '-----BEGIN CERTIFICATE-----\n' +
  'MIIFCTCCAvGgAwIBAgIUas3tIOoiZhfgLsm5On5VlBQEZvowDQYJKoZIhvcNAQEL\n' +
  'BQAwFDESMBAGA1UEAwwJUm9vdCBDQSBDMB4XDTI2MDQyMjAzMzIxNloXDTM2MDQx\n' +
  'OTAzMzIxNlowFDESMBAGA1UEAwwJUm9vdCBDQSBDMIICIjANBgkqhkiG9w0BAQEF\n' +
  'AAOCAg8AMIICCgKCAgEAthsYJ4VBDZ4SY+Z74kBZ4HfWi7xFp59FDEPbLfPWm5ZF\n' +
  'YFS5A6PY3DjApKmgBb+VuElmZjSlr5d9KkrDuaoI1T+LD4jE0m6i0E90WcVQApTN\n' +
  'IfsQJhmPEYkrWqtXHnu/Z040DAOhlMCKnpJ+MliMyib61wiWTJR7EU1AA9fc5h+H\n' +
  'mAcVROlcr5hwy3tiejCIbV25MJZDdestTJaKf5IL0IjB6rOIKwvfpbv4ftkuojDJ\n' +
  'xw6KJAtOWIZqOmfndE6P7HUWO/HmPHfrHpIIRiRvSnFXenizHENRkIE1TrotLZiG\n' +
  'R38S83MhwcSpzsh4HkPI08e+hc8c2l/nQ2X/vT8JsdrMasnALpfkDRhyPMAFGqJx\n' +
  'Zpr5labymhmYbN05IquF97VSZjXQCsNQ98W9JkZY4ZgkL3CLppdGFhtfSd/CXc5G\n' +
  'VdC6Wt2CjQgNNx/nJR4pZvv3vgGprONeNs1Jj7WYglUI26ybNyzQQ21YdiptyrH4\n' +
  'fl7jzAW+QKiA4RCSRn83BCd3qtiu843mQLJUdZz4As+OWE+BAMxrm0K4KQz6WC83\n' +
  'e1MUbMxeNSHXPVDZRceg/wb/Juj6jgkyBjR3ttyUt6iyzMyJxKOezvMkGudHqIDL\n' +
  'D2dZzdTIv3NIdSm8w37lPBqXszcIESXWcX0oNCaQtfQZpPLNuve/Z+LdBV3xfVcC\n' +
  'AwEAAaNTMFEwHQYDVR0OBBYEFGYVFjLI/DHrJuFRPC3mc1HQtPEWMB8GA1UdIwQY\n' +
  'MBaAFGYVFjLI/DHrJuFRPC3mc1HQtPEWMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZI\n' +
  'hvcNAQELBQADggIBAEt0uc+4UDArTU9ZrQ53OTczL+ersl3K5ExU9p3H0Y34weXq\n' +
  'NN31HX9J7sGG0HsP41mRf0I28IUcxCySeHsb1c5/D/Fv+gQ7KB46QFDq9NsFqp6G\n' +
  'OnAofqjCrIio7RwdEqcgW5JnAhUTyyKGJmHyjsbiCoFMhVbEv44u79Ii781G8K5B\n' +
  'KJmV4IigyQD4PVDcNrQs0AOTrUmnQEjYYlh6q1G3TE43fkI+ce5tqY/xhpBvOpIg\n' +
  'NzYu1We9meWooJ3dQ8jdyBrEA4N2058+ZX1Zs0XidXuOlfwQaOlJ1u2cbQ2AkL6g\n' +
  'KGtwNVC8GTeJDeYvN07ggbRHs3msXJ0NBg4Ka3mrs+Wh0r5ajNxF8KQ3H5tVrafY\n' +
  'KPQYjaaNzd9TOitxTBtWT4P4gfT2AbE/3R0Do3zmOuEJTgStTL5tYla0lk8XnZRp\n' +
  'TD7hXrSPsBG065/Pnx3cOdFuOA4rRYcHZVpFCv3nyrMQMls2mHPN90QlkZ7L6IKy\n' +
  'YSPY3Vw5Jm5LgUzYbkLptAQAQTQS3m28k//GnNSx9jaQyhc9d1yBm5XbO7KYJ+MZ\n' +
  'JFDMCMmy/kCkc5VUZJF3f5f5MakmhpNKYWtOK9ezajyOmBlcDI2FLBs9rIfMoX4P\n' +
  'b/4V277AApPH//Dk2HjUkNjjKnlmi79QVqdd8vODxe22Td9qTJFdrkU0YTSI\n' +
  '-----END CERTIFICATE-----\n'

// 中间CA证书签发的CRL
let crlData = '-----BEGIN X509 CRL-----\n' +
  'MIICdDBeAgEBMA0GCSqGSIb3DQEBCwUAMBwxGjAYBgNVBAMMEUludGVybWVkaWF0\n' +
  'ZSBDQSBCFw0yNjA0MjIwNDA3MzRaFw0yNjA1MjIwNDA3MzRaoA4wDDAKBgNVHRQE\n' +
  'AwIBATANBgkqhkiG9w0BAQsFAAOCAgEAOC6cKVy9i1oC0qaaD2eaDJX9lfMHqhl3\n' +
  'nN8LFQbyWx+hIq9khHigOAKpSJ3HDe0JV/zNQc3X3WRzm7HGv2C0cClo66NxRwAc\n' +
  'XuqEQIM47ElwzvD+4Qp+ybcEBt9K1NDviqgjzOwFNF618Rp+Hsd8DduArypN/tEL\n' +
  '2dLz2q7pYfdTlvvZsO+Gr+MoipFbUOtaMu4p5TU1PSFChNPbSwPAGxNHj25qgyg2\n' +
  'vDWPfjRTDet/MkTSzIzxni2TnaCZhjiVMLjiRuD+PfQhKVW2b0FFD7NV6N/S64iy\n' +
  'iS6uLzeQ3oeFavx2x6UXUHd0XHXYIUEaIsx9qovCeNIpFOL94U+mOabSASRKUK22\n' +
  'Emc+s2zN8OqOxrdbInpBn/vfTtPPig09Pu5kJ+4p59sn3E2BkX0S0dUWEg7XTlnA\n' +
  'aFZrk65dzmE951YeK/cpGxXbNibKnad0aSU/WkMGmuKyqW/igaWexjKK0sPODiTm\n' +
  'k3lPFh2dtrwK8/S+UqkIOA0Ys8Mlwa3GzTp9D6vUFOiLKznExUIquB2dernkuqxu\n' +
  'AWejix65gTVVqv9xfqz3ajaIyJa0MWTjlm8Tbwo3k91O494wpO4UvfgGvllrDYam\n' +
  'ttxn4k20bA1C0xuyVbnvy8p3pgmYu8CBwUFxIHcTpUkxKsTrH3y95bo4Ia6ZJRIo\n' +
  '06X9QfF9+yo=\n' +
  '-----END X509 CRL-----\n'
// [EndExclude certificate_chain_validation_with_crl]

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

async function createX509CRL(crlDataStr: string): Promise<cert.X509CRL> {
  let encodingBlob: cert.EncodingBlob = {
    data: stringToUint8Array(crlDataStr),
    encodingFormat: cert.EncodingFormat.FORMAT_PEM
  };

  let x509CRL: cert.X509CRL = {} as cert.X509CRL;
  try {
    x509CRL = await cert.createX509CRL(encodingBlob);
  } catch (error) {
    let e: BusinessError = error as BusinessError;
    console.error(`createX509CRL failed: errCode: ${e.code}, message: ${e.message}`);
  }
  return x509CRL;
}

async function validateCertChainWithCrl(): Promise<void> {
  try {
    // 创建证书对象
    let endEntityCert = await createX509Cert(endEntityCertData);
    let intermediateCaCert = await createX509Cert(intermediateCaCertData);
    let rootCaCert = await createX509Cert(rootCaCertData);

    // 创建CRL对象
    let crl = await createX509CRL(crlData);

    // 构建吊销校验参数
    let revokedParams: cert.X509CertRevokedParams = {
      // 启用CRL检查
      revocationFlags: [cert.CertRevocationFlag.CERT_REVOCATION_CRL_CHECK],
      // 提供CRL列表
      crls: [crl]
    };

    // 构建校验参数
    let params: cert.CertValidationParams = {
      untrustedCerts: [intermediateCaCert],
      trustedCerts: [rootCaCert],
      trustSystemCa: false,
      // 不校验证书有效期（仅用于示例，实际场景建议开启）
      validateDate: false,
      // 设置吊销校验参数
      revokedParams: revokedParams,
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
    if (error.code === cert.CertResult.ERR_CERT_HAS_REVOKED) {
      console.error('certificate has been revoked');
    } else {
      console.error('validate failed, errCode: ' + error.code + ', errMsg: ' + error.message);
      throw new Error(error.message)
    }
  }
}

// [End certificate_chain_validation_with_crl]
@Entry
@Component
struct Index {
  @State message: string = 'ValidateCertChainWithCrl';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Button('Call ValidateCertChainWithCrl')
        .width('70%')
        .onClick(() => {
          validateCertChainWithCrl().then(() => {
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