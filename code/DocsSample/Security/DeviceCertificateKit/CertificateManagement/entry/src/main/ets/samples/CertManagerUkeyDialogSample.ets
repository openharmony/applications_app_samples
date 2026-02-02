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
// [Start certificate_management_ukey_dialog_development_guide]
import { certificateManagerDialog, certificateManager } from '@kit.DeviceCertificateKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { UIContext } from '@kit.ArkUI';

async function certificateManagerUkeyDialogSample() {
  let keyUri: string = 'test'; /* USB凭据的唯一标识符，此处省略 */
  let ukeyInfo: certificateManager.UkeyInfo = { /* USB凭据的属性信息，此处省略 */
      certPurpose: certificateManager.CertificatePurpose.PURPOSE_DEFAULT,
    }
  try {
    certificateManager.getUkeyCertificate(keyUri, ukeyInfo).then((cmResult) => {
        let list = cmResult.credentialDetailList;
        console.info('Succeeded in getting detail of USB key certificate.');
    }).catch((err: BusinessError) => {
      console.error(`Failed to get detail of USB key certificate. Code: ${err.code}, message: ${err.message}`);
    })
  } catch (error) {
    console.error(`Failed to get detail of USB key certificate. Code: ${error.code}, message: ${error.message}`);
  }
}
// [End certificate_management_ukey_dialog_development_guide]

export { certificateManagerUkeyDialogSample };