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
// [Start activate_permission_example]
// [Start revoke_permission_example]
// [Start persist_permission_example]
import { BusinessError } from '@kit.BasicServicesKit';
import { picker } from '@kit.CoreFileKit';
import { fileShare } from '@kit.CoreFileKit';

// [StartExclude activate_permission_example]
// [StartExclude revoke_permission_example]
export async function persistPermissionExample() {
  try {
    // [StartExclude persist_permission_example]
    // [Start can_use_example]
    if (!canIUse('SystemCapability.FileManagement.AppFileService.FolderAuthorization')) {
      console.error('this api is not supported on this device');
      return;
    }
    // [End can_use_example]
    // [EndExclude persist_permission_example]
    let documentSelectOptions = new picker.DocumentSelectOptions();
    let documentPicker = new picker.DocumentViewPicker();
    let uris = await documentPicker.select(documentSelectOptions);
    let policyInfo: fileShare.PolicyInfo = {
      uri: uris[0],
      operationMode: fileShare.OperationMode.READ_MODE,
    };
    let policies: fileShare.PolicyInfo[] = [policyInfo];
    fileShare.persistPermission(policies).then(() => {
      console.info('persistPermission successfully');
    }).catch((err: BusinessError<Array<fileShare.PolicyErrorResult>>) => {
      console.error('persistPermission failed with error message: ' + err.message + ', error code: ' + err.code);
      if (err.code == 13900001 && err.data) {
        for (let i = 0; i < err.data.length; i++) {
          console.error('error code : ' + JSON.stringify(err.data[i].code));
          console.error('error uri : ' + JSON.stringify(err.data[i].uri));
          console.error('error reason : ' + JSON.stringify(err.data[i].message));
        }
      }
    });
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(`persistPermission failed with err, Error code: ${err.code}, message: ${err.message}`);
  }
}
// [End persist_permission_example]
// [EndExclude revoke_permission_example]
export async function revokePermissionExample() {
  try {
    let uri = 'file://docs/storage/Users/username/tmp.txt';
    let policyInfo: fileShare.PolicyInfo = {
      uri: uri,
      operationMode: fileShare.OperationMode.READ_MODE,
    };
    let policies: fileShare.PolicyInfo[] = [policyInfo];
    fileShare.revokePermission(policies).then(() => {
      console.info('revokePermission successfully');
    }).catch((err: BusinessError<Array<fileShare.PolicyErrorResult>>) => {
      console.error('revokePermission failed with error message: ' + err.message + ', error code: ' + err.code);
      if (err.code == 13900001 && err.data) {
        for (let i = 0; i < err.data.length; i++) {
          console.error('error code : ' + JSON.stringify(err.data[i].code));
          console.error('error uri : ' + JSON.stringify(err.data[i].uri));
          console.error('error reason : ' + JSON.stringify(err.data[i].message));
        }
      }
    });
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(`revokePermission failed with err, Error code: ${err.code}, message: ${err.message}`);
  }
}
// [End revoke_permission_example]
// [EndExclude activate_permission_example]
export async function activatePermissionExample() {
  try {
    let uri = 'file://docs/storage/Users/username/tmp.txt';
    let policyInfo: fileShare.PolicyInfo = {
      uri: uri,
      operationMode: fileShare.OperationMode.READ_MODE,
    };
    let policies: fileShare.PolicyInfo[] = [policyInfo];
    fileShare.activatePermission(policies).then(() => {
      console.info('activatePermission successfully');
    }).catch((err: BusinessError<Array<fileShare.PolicyErrorResult>>) => {
      console.error('activatePermission failed with error message: ' + err.message + ', error code: ' + err.code);
      if (err.code == 13900001 && err.data) {
        for (let i = 0; i < err.data.length; i++) {
          console.error('error code : ' + JSON.stringify(err.data[i].code));
          console.error('error uri : ' + JSON.stringify(err.data[i].uri));
          console.error('error reason : ' + JSON.stringify(err.data[i].message));
          if (err.data[i].code == fileShare.PolicyErrorCode.PERMISSION_NOT_PERSISTED) {
            //可以选择进行持久化后再激活。
          }
        }
      }
    });
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(`activatePermission failed with err, Error code: ${err.code}, message: ${err.message}`);
  }
}
// [End activate_permission_example]