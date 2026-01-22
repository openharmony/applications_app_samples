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

// [Start create-cms-enveloped-object]

import { cert } from '@kit.DeviceCertificateKit';

let eccCertData = '-----BEGIN CERTIFICATE-----\n' +
  'MIICOjCCAd+gAwIBAgIGAXKnJjrAMAoGCCqGSM49BAMCMHkxCzAJBgNVBAYTAmNo\n' +
  'MQ8wDQYDVQQIDAZodWF3ZWkxDTALBgNVBAcMBHhpYW4xDzANBgNVBAoMBmh1YXdl\n' +
  'aTENMAsGA1UECwwEdGVzdDENMAsGA1UEAwwEYW5uZTEbMBkGCSqGSIb3DQEJARYM\n' +
  'dGVzdEAxMjMuY29tMB4XDTI0MTEyNzAzMjQ1MFoXDTM0MTEyNTAzMjQ1MFoweTEL\n' +
  'MAkGA1UEBhMCY2gxDzANBgNVBAgMBmh1YXdlaTENMAsGA1UEBwwEeGlhbjEPMA0G\n' +
  'A1UECgwGaHVhd2VpMQ0wCwYDVQQLDAR0ZXN0MQ0wCwYDVQQDDARhbm5lMRswGQYJ\n' +
  'KoZIhvcNAQkBFgx0ZXN0QDEyMy5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNC\n' +
  'AARzg16D6tsNHZa7w0tLHFprXg5kUQgXv/vv3KIM21hY+WDYMz1OST4tmTeQWQF8\n' +
  'kARtjjbHBxtOPufWxMfxf51Wo1MwUTAdBgNVHQ4EFgQUU/P31GCBwyrj3yXkoNaX\n' +
  'xvPp8uIwHwYDVR0jBBgwFoAUU/P31GCBwyrj3yXkoNaXxvPp8uIwDwYDVR0TAQH/\n' +
  'BAUwAwEB/zAKBggqhkjOPQQDAgNJADBGAiEA/wCfbTorAWEEZcgd0CgfXI+EzXu2\n' +
  'Y88BmDD5LFlj3N0CIQDB34h77Li0CSpYpS4+7Mug237zbkFjHR3Q4/VWOT1G1A==\n' +
  '-----END CERTIFICATE-----\n';

let rsaCertData = '-----BEGIN CERTIFICATE-----\n' +
  'MIICXjCCAcegAwIBAgIGAXKnJjrAMA0GCSqGSIb3DQEBCwUAMEgxCzAJBgNVBAYT\n' +
  'AkNOMQwwCgYDVQQIDANzaGExDTALBgNVBAcMBHhpYW4xDTALBgNVBAoMBHRlc3Qx\n' +
  'DTALBgNVBAMMBHRlc3QwHhcNMjQxMTIyMDkwNTIyWhcNMzQxMTIwMDkwNTIyWjBI\n' +
  'MQswCQYDVQQGEwJDTjEMMAoGA1UECAwDc2hhMQ0wCwYDVQQHDAR4aWFuMQ0wCwYD\n' +
  'VQQKDAR0ZXN0MQ0wCwYDVQQDDAR0ZXN0MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCB\n' +
  'iQKBgQC6nCZTM16Rk2c4P/hwfVm++jqe6GCA/PXXGe4YL218q1dTKMHBGEw8kXi0\n' +
  'XLDcyyC2yUn8ywN2QSyly6ke9EE6PGfZywStLp4g2PTTWB04sS3aXT2y+fToiTXQ\n' +
  '3AxfFYRpB+EgSdSCkJs6jKXVwbzu54kEtQTfs8UdBQ9nVKaJLwIDAQABo1MwUTAd\n' +
  'BgNVHQ4EFgQU6QXnt1smb2HRSO/2zuRQnz/SDxowHwYDVR0jBBgwFoAU6QXnt1sm\n' +
  'b2HRSO/2zuRQnz/SDxowDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOB\n' +
  'gQBPR/+5xzFG1XlTdgwWVvqVxvhGUkbMTGW0IviJ+jbKsi57vnVsOtFzEA6y+bYx\n' +
  'xG/kEOcwLtzeVHOQA+ZU5SVcc+qc0dfFiWjL2PSAG4bpqSTjujpuUk+g8ugixbG1\n' +
  'a26pkDJhNeB/E3eBIbeydSY0A/dIGb6vbGo6BSq2KvnWAA==\n' +
  '-----END CERTIFICATE-----\n';

// string转Uint8Array。
function stringToUint8Array(str: string): Uint8Array {
  let arr: number[] = [];
  for (let i = 0, j = str.length; i < j; i++) {
    arr.push(str.charCodeAt(i));
  }
  return new Uint8Array(arr);
}

async function testGetEncryptedContentData() {
  try {
    let ecccertEncodingBlob: cert.EncodingBlob = {
      data: stringToUint8Array(eccCertData),
      // 根据encodingData的格式进行赋值，支持FORMAT_PEM和FORMAT_DER。
      encodingFormat: cert.EncodingFormat.FORMAT_PEM
    };

    let rsacertEncodingBlob: cert.EncodingBlob = {
      data: stringToUint8Array(rsaCertData),
      // 根据encodingData的格式进行赋值，支持FORMAT_PEM和FORMAT_DER。
      encodingFormat: cert.EncodingFormat.FORMAT_PEM
    };

    let eccx509Certcert = await cert.createX509Cert(ecccertEncodingBlob);
    let rsax509Certcert = await cert.createX509Cert(rsacertEncodingBlob);

    let cmsContentType = cert.CmsContentType.ENVELOPED_DATA;
    let cmsGenerator = cert.createCmsGenerator(cmsContentType);
    console.info(`createCmsGenerator result: success.`);
    let algorithm = cert.CmsRecipientEncryptionAlgorithm.AES_256_GCM;
    cmsGenerator.setRecipientEncryptionAlgorithm(algorithm);
    console.info(`setRecipientEncryptionAlgorithm result: success.`);
    let eccCert: cert.CmsKeyAgreeRecipientInfo = {
      cert: eccx509Certcert,
      digestAlgorithm: cert.CmsKeyAgreeRecipientDigestAlgorithm.SHA256,
    };
    let rsaCert: cert.CmsKeyTransRecipientInfo = {
      cert: rsax509Certcert,
    };
    let recipientInfo: cert.CmsRecipientInfo = {
      keyTransInfo: rsaCert,
      keyAgreeInfo: eccCert,
    };
    await cmsGenerator.addRecipientInfo(recipientInfo);
    console.info(`addRecipientInfo result: success.`);
    let content = new Uint8Array([1, 2, 3, 4]);
    let optionsFinal: cert.CmsGeneratorOptions = {
      contentDataFormat: cert.CmsContentDataFormat.BINARY,
      outFormat: cert.CmsFormat.PEM,
      isDetached: true
    };
    let cms = await cmsGenerator.doFinal(content, optionsFinal);
    console.info(`doFinal result: success, cms = %s`, cms);
    let data = await cmsGenerator.getEncryptedContentData();
    console.info(`getEncryptedContentData result: success, data = %s`, data);
  } catch (err) {
    console.error(`testGetEncryptedContentData failed: errCode: ${err.code}, message: ${err.message}`);
  }
}

// [End create-cms-enveloped-object]
@Entry
@Component
struct Index {
  @State message: string = 'CreateCmsEnvelopedObject';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Button('Call CreateCmsEnvelopedObject')
        .width('70%')
        .onClick(()=>{
          try {
            testGetEncryptedContentData();
            this.message = 'Call Success';
          } catch {
            this.message = 'Call Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}