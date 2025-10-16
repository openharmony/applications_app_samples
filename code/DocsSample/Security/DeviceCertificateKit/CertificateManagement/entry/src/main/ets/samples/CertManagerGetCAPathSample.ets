
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
// [Start certificate_management_get_ca_path]
import { certificateManager } from '@kit.DeviceCertificateKit';

function getUserCaPathSample() {
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
// [End certificate_management_get_ca_path]

export { getUserCaPathSample };