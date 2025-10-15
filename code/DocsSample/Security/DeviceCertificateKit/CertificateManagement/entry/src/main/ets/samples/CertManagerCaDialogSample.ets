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
// [Start certificate_management_ca_dialog_development_guide]
import { certificateManagerDialog } from '@kit.DeviceCertificateKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { UIContext } from '@kit.ArkUI';
import { util } from '@kit.ArkTS';

let certType = certificateManagerDialog.CertificateType.CA_CERT;
let certUri: string = '';
/* 用户CA证书数据需要业务赋值。 */
let cert: Uint8Array = new util.TextEncoder().encodeInto(`-----BEGIN CERTIFICATE-----
MIIDSTCCAjECFFRZKkiBuiZ+zqfjJOg05yeTePM9MA0GCSqGSIb3DQEBCwUAMGEx
CzAJBgNVBAYTAmNuMQ0wCwYDVQQIDARvaG9zMQswCQYDVQQHDAJjbTEhMB8GA1UE
CgwYSW50ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMRMwEQYDVQQDDApUZXN0Um9vdENB
MB4XDTI1MTAxNTA3MzE0MloXDTI2MTAxNTA3MzE0MlowYTELMAkGA1UEBhMCY24x
DTALBgNVBAgMBG9ob3MxCzAJBgNVBAcMAmNtMSEwHwYDVQQKDBhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQxEzARBgNVBAMMClRlc3RSb290Q0EwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQC5p4eoQJyTBvn01M8SwEi8dguTIPGmD3a8SGIj
KXaB6ltv742H5EBjgk+zC8+Gis0ehEqwk3pVnnmByeYvrERxsUqDt69/FndlfTxI
C2/2MxWVk97g/6TpJ5Lt2mTrH+rSOgUDyU27aPn12ZnDF1mLsT+U+CBmfj4+J4tW
yzdFNj7kcKMQQok+L1dtFlDNMNpMA1UqADzoC3XgFl49CpDtoFId9DVsgUPkPfX1
89cCunomgJe1b17FzxfNu2yhbl5cnUEjeHGbmBgBIB7uG8tjGstnDPx7fl3Xrj+Q
fRrwCpVKD9RxoyUBFbHttixxY5bHFUdvHRB251sxD+JfxxxLAgMBAAEwDQYJKoZI
hvcNAQELBQADggEBAEGbNqcMU7C/lrIytI/OTtzYbkWDsfnRSPxlCUoZ2Xh3S83A
SNQ9Ze5tDwWdW9Hlde9May6hzvuQSYeMLLnyM8WGResXCs7UbnSQe7fGfUu+xDGb
h4tamnRFtZydxCCgDT9lIdHeutlPwOuxlR4HXpeowGeGJX0iFrdo6D0iXAY34hic
yLQzuBqE/1s3PLA83Fi4EOOOV7P/ahmOLtBFlHbySHV68i9PNeNr9SDykH9/RgI9
5G8ZTZj8oSmbTGGtfNuVXybMyJMRlz6BkxG++kYcg7STRBqHGX7RrWHiupguNreO
4sJBdSpWBq172ZEyOvTqC4xX9lLYqwwBQ++TFoo=
-----END CERTIFICATE-----`);

async function installUserCADialogSample() {
  /* context为应用的上下文信息，由调用方自行获取，此处仅为示例。 */
  let context: common.Context = new UIContext().getHostContext() as common.Context;
  let certScope = certificateManagerDialog.CertificateScope.CURRENT_USER; /* 安装在当前用户下。 */
  try {
    /* 安装证书。 */
    certificateManagerDialog.openInstallCertificateDialog(context, certType, certScope, cert).then((result) => {
      console.info('Succeeded in opening install ca dialog.');
      certUri = result;
    }).catch((err: BusinessError) => {
      console.error(`Failed to open install ca dialog. Code: ${err.code}, message: ${err.message}`);
    })
  } catch (error) {
    console.error(`Failed to open install ca dialog. Code: ${error.code}, message: ${error.message}`);
  }
}

async function uninstallUserCADialogSample() {
  /* context为应用的上下文信息，由调用方自行获取，此处仅为示例。 */
  let context: common.Context = new UIContext().getHostContext() as common.Context;
  try {
    /* 删除证书。 */
    certificateManagerDialog.openUninstallCertificateDialog(context, certType, certUri).then(() => {
      console.info('Succeeded in opening uninstall ca dialog.');
    }).catch((err: BusinessError) => {
      console.error(`Failed to open uninstall ca dialog. Code: ${err.code}, message: ${err.message}`);
    })
  } catch (error) {
    console.error(`Failed to open uninstall ca dialog. Code: ${error.code}, message: ${error.message}`);
  }
}

async function certDetailDialogSample() {
  /* context为应用的上下文信息，由调用方自行获取，此处仅为示例。 */
  let context: common.Context = new UIContext().getHostContext() as common.Context;
  try {
    let property: certificateManagerDialog.CertificateDialogProperty = {
      showInstallButton: false    /* 不显示安装按钮。 */
    };
    /* 显示证书详情。 */
    certificateManagerDialog.openCertificateDetailDialog(context, cert, property).then(() => {
      console.info('Succeeded in opening show ca detail dialog.');
    }).catch((err: BusinessError) => {
      console.error(`Failed to open show ca detail dialog. Code: ${err.code}, message: ${err.message}`);
    })
  } catch (error) {
    console.error(`Failed to open show ca detail dialog. Code: ${error.code}, message: ${error.message}`);
  }
}
// [End certificate_management_ca_dialog_development_guide]

export { installUserCADialogSample, uninstallUserCADialogSample, certDetailDialogSample };