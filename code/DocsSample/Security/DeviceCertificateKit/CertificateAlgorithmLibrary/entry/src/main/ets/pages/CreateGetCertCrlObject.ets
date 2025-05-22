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



// [Start certificate_collection_and_certificate_revocation_list_collection_object_creation_and_acquisition]
import { cert } from '@kit.DeviceCertificateKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';

async function createX509CRL(): Promise<cert.X509CRL> {
  let crlData = '-----BEGIN X509 CRL-----\n' +
    'MIHzMF4CAQMwDQYJKoZIhvcNAQEEBQAwFTETMBEGA1UEAxMKQ1JMIGlzc3VlchcN\n' +
    'MTcwODA3MTExOTU1WhcNMzIxMjE0MDA1MzIwWjAVMBMCAgPoFw0zMjEyMTQwMDUz\n' +
    'MjBaMA0GCSqGSIb3DQEBBAUAA4GBACEPHhlaCTWA42ykeaOyR0SGQIHIOUR3gcDH\n' +
    'J1LaNwiL+gDxI9rMQmlhsUGJmPIPdRs9uYyI+f854lsWYisD2PUEpn3DbEvzwYeQ\n' +
    '5SqQoPDoM+YfZZa23hoTLsu52toXobP74sf/9K501p/+8hm4ROMLBoRT86GQKY6g\n' +
    'eavsH0Q3\n' +
    '-----END X509 CRL-----\n';

  // 证书吊销列表二进制数据，需业务自行赋值
  let textEncoder = new util.TextEncoder();
  let encodingBlob: cert.EncodingBlob = {
    data: textEncoder.encodeInto(crlData),
    // 根据encodingData的格式进行赋值，支持FORMAT_PEM和FORMAT_DER
    encodingFormat: cert.EncodingFormat.FORMAT_PEM
  };
  let x509CRL: cert.X509CRL = {} as cert.X509CRL;
  try {
    x509CRL = await cert.createX509CRL(encodingBlob);
  } catch (err) {
    let e: BusinessError = err as BusinessError;
    console.error(`createX509CRL failed, errCode: ${e.code}, errMsg: ${e.message}`);
  }
  return x509CRL;
}

async function createX509Cert(): Promise<cert.X509Cert> {
  let certData = '-----BEGIN CERTIFICATE-----\n' +
    'MIIBHTCBwwICA+gwCgYIKoZIzj0EAwIwGjEYMBYGA1UEAwwPRXhhbXBsZSBSb290\n' +
    'IENBMB4XDTIzMDkwNTAyNDgyMloXDTI2MDUzMTAyNDgyMlowGjEYMBYGA1UEAwwP\n' +
    'RXhhbXBsZSBSb290IENBMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEHjG74yMI\n' +
    'ueO7z3T+dyuEIrhxTg2fqgeNB3SGfsIXlsiUfLTatUsU0i/sePnrKglj2H8Abbx9\n' +
    'PK0tsW/VgqwDIDAKBggqhkjOPQQDAgNJADBGAiEApVZno/Z7WyDc/muRN1y57uaY\n' +
    'Mjrgnvp/AMdE8qmFiDwCIQCrIYdHVO1awaPgcdALZY+uLQi6mEs/oMJLUcmaag3E\n' +
    'Qw==\n' +
    '-----END CERTIFICATE-----\n';

  let textEncoder = new util.TextEncoder();
  let encodingBlob: cert.EncodingBlob = {
    data: textEncoder.encodeInto(certData),
    // 根据encodingData的格式进行赋值，支持FORMAT_PEM和FORMAT_DER
    encodingFormat: cert.EncodingFormat.FORMAT_PEM
  };

  let x509Cert: cert.X509Cert = {} as cert.X509Cert;
  try {
    x509Cert = await cert.createX509Cert(encodingBlob);
  } catch (err) {
    let e: BusinessError = err as BusinessError;
    console.error(`createX509Cert failed, errCode: ${e.code}, errMsg: ${e.message}`);
  }
  return x509Cert;
}

async function sample() {
  const x509Cert = await createX509Cert();
  const x509CRL = await createX509CRL();
  let collection: cert.CertCRLCollection = {} as cert.CertCRLCollection;
  try {
    collection = cert.createCertCRLCollection([x509Cert], [x509CRL]);
    console.log('createCertCRLCollection success');
  } catch (err) {
    console.error('createCertCRLCollection failed');
  }

  const certParam: cert.X509CertMatchParameters = {
    validDate: '231128000000Z'
  }
  try {
    let certs: cert.X509Cert[] = await collection.selectCerts(certParam);
  } catch (err) {
    console.error('selectCerts failed');
  }

  const crlParam: cert.X509CRLMatchParameters = {
    x509Cert: x509Cert
  }
  try {
    let crls: cert.X509CRL[] = await collection.selectCRLs(crlParam);
    console.error('selectCRLs success');
  } catch (err) {
    console.error('selectCRLs failed');
  }
}


// [End certificate_collection_and_certificate_revocation_list_collection_object_creation_and_acquisition]
@Entry
@Component
struct Index {
  @State message: string = 'CreateGetCertCrlObject';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Button('Call CreateGetCertCrlObject')
        .width('70%')
        .onClick(() => {
          try {
            sample();
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