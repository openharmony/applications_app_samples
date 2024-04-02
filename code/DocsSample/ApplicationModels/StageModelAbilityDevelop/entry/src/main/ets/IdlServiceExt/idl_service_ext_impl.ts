/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import bundleManager from '@ohos.bundle.bundleManager';
import IdlServiceExtStub from './idl_service_ext_stub';
import hilog from '@ohos.hilog';
import rpc from '@ohos.rpc';
import type { BusinessError } from '@ohos.base';
import type { InsertDataToMapCallback } from './i_idl_service_ext';
import type { ProcessDataCallback } from './i_idl_service_ext';

const ERR_OK = 0;
const TAG: string = '[IdlServiceExtImpl]';
const DOMAIN_NUMBER: number = 0xFF00;
const ERR_DENY = -1;

// 开发者需要在这个类型里对接口进行实现
export default class ServiceExtImpl extends IdlServiceExtStub {
  processData(data: number, callback: ProcessDataCallback): void {
    // 开发者自行实现业务逻辑
    hilog.info(DOMAIN_NUMBER, TAG, `processData: ${data}`);

    let callerUid = rpc.IPCSkeleton.getCallingUid();
    bundleManager.getBundleNameByUid(callerUid).then((callerBundleName) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'getBundleNameByUid: ' + callerBundleName);
      // 对客户端包名进行识别
      if (callerBundleName !== 'com.samples.stagemodelabilitydevelop') { // 识别不通过
        hilog.info(DOMAIN_NUMBER, TAG, 'The caller bundle is not in trustlist, reject');
        return;
      }
      // 识别通过，执行正常业务逻辑
    }).catch((err: BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'getBundleNameByUid failed: ' + err.message);
    });

    let callerTokenId = rpc.IPCSkeleton.getCallingTokenId();
    let accessManger = abilityAccessCtrl.createAtManager();
    // 所校验的具体权限由开发者自行选择，此处ohos.permission.GET_BUNDLE_INFO_PRIVILEGED只作为示例
    let grantStatus = accessManger.verifyAccessTokenSync(callerTokenId, 'ohos.permission.GET_BUNDLE_INFO_PRIVILEGED');
    if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
      hilog.info(DOMAIN_NUMBER, TAG, 'PERMISSION_DENIED');
      callback(ERR_DENY, data); // 鉴权失败，返回错误
      return;
    }
    hilog.info(DOMAIN_NUMBER, TAG, 'verify access token success.');
    callback(ERR_OK, data + 1); // 鉴权通过，执行正常业务逻辑
  };

  insertDataToMap(key: string, val: number, callback: InsertDataToMapCallback): void {
    // 开发者自行实现业务逻辑
    hilog.info(DOMAIN_NUMBER, TAG, `insertDataToMap, key: ${key}  val: ${val}`);
    callback(ERR_OK);
  };
};