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
// [Start certificate_management_user_ca]
import { certificateManager, certificateManagerDialog } from '@kit.DeviceCertificateKit';
import { util } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';
import { UIContext } from '@kit.ArkUI';

async function userCASample(): Promise<void> {
  /* 安装的用户CA证书数据需要业务赋值。 */
  let userCAData: Uint8Array = new util.TextEncoder().encodeInto('-----BEGIN CERTIFICATE-----\n' +
    'MIIDSTCCAjECFFRZKkiBuiZ+zqfjJOg05yeTePM9MA0GCSqGSIb3DQEBCwUAMGEx\n' +
    'CzAJBgNVBAYTAmNuMQ0wCwYDVQQIDARvaG9zMQswCQYDVQQHDAJjbTEhMB8GA1UE\n' +
    'CgwYSW50ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMRMwEQYDVQQDDApUZXN0Um9vdENB\n' +
    'MB4XDTI1MTAxNTA3MzE0MloXDTI2MTAxNTA3MzE0MlowYTELMAkGA1UEBhMCY24x\n' +
    'DTALBgNVBAgMBG9ob3MxCzAJBgNVBAcMAmNtMSEwHwYDVQQKDBhJbnRlcm5ldCBX\n' +
    'aWRnaXRzIFB0eSBMdGQxEzARBgNVBAMMClRlc3RSb290Q0EwggEiMA0GCSqGSIb3\n' +
    'DQEBAQUAA4IBDwAwggEKAoIBAQC5p4eoQJyTBvn01M8SwEi8dguTIPGmD3a8SGIj\n' +
    'KXaB6ltv742H5EBjgk+zC8+Gis0ehEqwk3pVnnmByeYvrERxsUqDt69/FndlfTxI\n' +
    'C2/2MxWVk97g/6TpJ5Lt2mTrH+rSOgUDyU27aPn12ZnDF1mLsT+U+CBmfj4+J4tW\n' +
    'yzdFNj7kcKMQQok+L1dtFlDNMNpMA1UqADzoC3XgFl49CpDtoFId9DVsgUPkPfX1\n' +
    '89cCunomgJe1b17FzxfNu2yhbl5cnUEjeHGbmBgBIB7uG8tjGstnDPx7fl3Xrj+Q\n' +
    'fRrwCpVKD9RxoyUBFbHttixxY5bHFUdvHRB251sxD+JfxxxLAgMBAAEwDQYJKoZI\n' +
    'hvcNAQELBQADggEBAEGbNqcMU7C/lrIytI/OTtzYbkWDsfnRSPxlCUoZ2Xh3S83A\n' +
    'SNQ9Ze5tDwWdW9Hlde9May6hzvuQSYeMLLnyM8WGResXCs7UbnSQe7fGfUu+xDGb\n' +
    'h4tamnRFtZydxCCgDT9lIdHeutlPwOuxlR4HXpeowGeGJX0iFrdo6D0iXAY34hic\n' +
    'yLQzuBqE/1s3PLA83Fi4EOOOV7P/ahmOLtBFlHbySHV68i9PNeNr9SDykH9/RgI9\n' +
    '5G8ZTZj8oSmbTGGtfNuVXybMyJMRlz6BkxG++kYcg7STRBqHGX7RrWHiupguNreO\n' +
    '4sJBdSpWBq172ZEyOvTqC4xX9lLYqwwBQ++TFoo=\n' +
    '-----END CERTIFICATE-----');

  let certUri: string = '';

  /* 场景1：在BYOD设备安装用户CA证书 */
  try {
    certUri = await installUserCACertDialog(userCAData);
  } catch (error) {
    console.error(`Failed to install user CA certificate.`);
  }
  /* 获取用户CA证书详情。 */
  getUserCACertInfo(certUri);
  /* 获取用户CA证书列表。 */
  getUserCACertList();
  /* 场景1：在BYOD设备卸载用户CA证书 */
  uninstallUserCACertDialog(certUri);

  /* 场景2：MDM应用在企业设备安装用户CA证书 */
  certUri = installUserCACertEnterprise(userCAData);
  /* 获取用户CA证书详情。 */
  getUserCACertInfo(certUri);
  /* 获取用户CA证书列表。 */
  getUserCACertList();
  /* 场景2：MDM应用在企业设备卸载用户CA证书 */
  uninstallUserCACertEnterprise(certUri);

  /* 获取CA证书的存储目录 */
  getUserCaPathSample();
}

async function installUserCACertDialog(userCAData: Uint8Array): Promise<string> {
  return new Promise<string>((resolve, reject) => {
    /* 场景1：在BYOD设备安装用户CA证书 */
    try {
      /* context为应用的上下文信息，调用方自行获取，此处仅为示例 */
      let context: common.Context = new UIContext().getHostContext() as common.Context;
      /* 安装用户证书凭据 */
      certificateManagerDialog.openInstallCertificateDialog(
        context,
        certificateManagerDialog.CertificateType.CA_CERT,
        certificateManagerDialog.CertificateScope.CURRENT_USER,
        userCAData
      ).then((keyUri: string) => {
        console.info(`Installing user CA certificate successful, keyUri: ${keyUri}`);
        resolve(keyUri);
      }).catch((error: BusinessError) => {
        console.error(`Failed to install user CA certificate. Code: ${error.code}, message: ${error.message}`);
        reject(error);
      });
    } catch (error) {
      console.error(`Failed to install user CA credential. Code: ${error.code}, message: ${error.message}`);
      reject(error);
    }
  })
}

function installUserCACertEnterprise(userCAData: Uint8Array): string {
  /* 场景2：MDM应用在企业设备安装用户CA证书 */
  try {
    /* 在当前用户下，安装用户CA证书。 */
    let result = certificateManager.installUserTrustedCertificateSync(
      userCAData,
      certificateManager.CertScope.CURRENT_USER
    );
    let certUri = result.uri ?? '';
    console.info(`Sync install user CA certificate successful, certUri is ${certUri}`);
    return certUri
  } catch (err) {
    console.error(`Failed to sync install user CA certificate. Code: ${err.code}, message: ${err.message}`);
  }
  return '';
}

async function getUserCACertInfo(certUri: string): Promise<void> {
  try {
    /* 获取用户CA证书详情。 */
    let result = await certificateManager.getUserTrustedCertificate(certUri);
    if (result === undefined || result.certInfo == undefined) {
      console.error('The result of getting user ca cert is undefined.');
    } else {
      let certInfo = result.certInfo;
      console.info('Succeeded in getting user ca cert.');
    }
  } catch (err) {
    console.error(`Failed to get user ca certificate. Code: ${err.code}, message: ${err.message}`);
  }
}

async function getUserCACertList(): Promise<void> {
  try {
    /* 获取当前用户下的用户CA证书列表。 */
    let certScope = certificateManager.CertScope.CURRENT_USER;
    let result = await certificateManager.getAllUserTrustedCertificates(certScope);
    if (result == undefined) { /* 用户根CA证书个数为0时，返回result为undefined。 */
      console.info('the count of the user trusted certificates is 0');
    } else if (result.certList == undefined) {
      console.error('The result of getting current user trusted certificates is undefined.');
    } else {
      let list = result.certList;
      console.info('Succeeded in getting user ca cert list.');
    }
  } catch (err) {
    console.error(`Failed to get user ca certificate. Code: ${err.code}, message: ${err.message}`);
  }
}

async function uninstallUserCACertDialog(certUri: string): Promise<void> {
  try {
    /* 场景2：在BYOD设备卸载用户CA证书 */
    /* context为应用的上下文信息，调用方自行获取，此处仅为示例 */
    let context: common.Context = new UIContext().getHostContext() as common.Context;
    certificateManagerDialog.openUninstallCertificateDialog(
      context,
      certificateManagerDialog.CertificateType.CA_CERT,
      certUri
    ).then(() => {
      console.info(`Uninstall user ca certificate successful.`);
    }).catch((error: BusinessError) => {
      console.error(`Failed to uninstall user ca certificate. Code: ${error.code}, message: ${error.message}`);
    });
  } catch (err) {
    console.error(`Failed to uninstall user ca certificate. Code: ${err.code}, message: ${err.message}`);
  }
}

function getUserCaPathSample(): void {
  try {
    /* 获取系统CA的存储位置。 */
    let property1: certificateManager.CertStoreProperty = {
      certType: certificateManager.CertType.CA_CERT_SYSTEM,
    }
    let systemCAPath = certificateManager.getCertificateStorePath(property1);
    console.info(`Success to get system ca path: ${systemCAPath}`);

    /* 获取当前用户的用户CA存储位置。 */
    let property2: certificateManager.CertStoreProperty = {
      certType: certificateManager.CertType.CA_CERT_USER,
      certScope: certificateManager.CertScope.CURRENT_USER,
    }
    let userCACurrentPath = certificateManager.getCertificateStorePath(property2);
    console.info(`Success to get current user's user ca path: ${userCACurrentPath}`);

    /* 获取设备公共的用户CA存储位置。 */
    let property3: certificateManager.CertStoreProperty = {
      certType: certificateManager.CertType.CA_CERT_USER,
      certScope: certificateManager.CertScope.GLOBAL_USER,
    }
    let globalCACurrentPath = certificateManager.getCertificateStorePath(property3);
    console.info(`Success to get global user's user ca path: ${globalCACurrentPath}`);
  } catch (error) {
    console.error(`Failed to get store path. Code: ${error.code}, message: ${error.message}`);
  }
}

async function uninstallUserCACertEnterprise(certUri: string): Promise<void> {
  try {
    /* 场景2：MDM应用在企业设备卸载用户CA证书 */
    certificateManager.uninstallUserTrustedCertificateSync(certUri);
    console.info(`Uninstall user ca certificate successful.`);
  } catch (err) {
    console.error(`Failed to uninstall user ca certificate. Code: ${err.code}, message: ${err.message}`);
  }
}
// [End certificate_management_user_ca]

export { userCASample };