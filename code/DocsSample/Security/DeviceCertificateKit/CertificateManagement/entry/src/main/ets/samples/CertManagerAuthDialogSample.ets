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
// [Start certificate_management_auth_dialog_development_guide]
import { certificateManagerDialog, certificateManager } from '@kit.DeviceCertificateKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { UIContext } from '@kit.ArkUI';

async function certificateManagerAuthDialogSample() {
  /* context为应用的上下文信息，调用方自行获取，此处仅为示例 */
  let context: common.Context = new UIContext().getHostContext() as common.Context;
  let certTypes: Array<certificateManagerDialog.CertificateType> = [
    certificateManagerDialog.CertificateType.CREDENTIAL_USER,
    certificateManagerDialog.CertificateType.CREDENTIAL_APP,
    certificateManagerDialog.CertificateType.CREDENTIAL_UKEY
  ];
  let certPurpose: certificateManager.CertificatePurpose = certificateManager.CertificatePurpose.PURPOSE_DEFAULT;
  let authorizeRequest: certificateManagerDialog.AuthorizeRequest = { certTypes: certTypes, certPurpose: certPurpose };
  try {
    certificateManagerDialog.openAuthorizeDialog(context, authorizeRequest).then((certReference: certificateManagerDialog.CertReference) => {
      let reference = certReference;
      console.info(`Success to open authorize dialog.`)
    }).catch((err: BusinessError) => {
        console.error(`Failed to open authorize dialog. Code: ${err.code}, message: ${err.message}`);
    });
  } catch (err) {
    let error = err as BusinessError;
    console.error(`Failed to open authorize dialog. Code: ${error.code}, message: ${error.message}`);
  }
}
// [End certificate_management_auth_dialog_development_guide]

export { certificateManagerAuthDialogSample };