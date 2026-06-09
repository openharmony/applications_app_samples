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
import bundleManager from '@ohos.bundle.bundleManager';
import { BusinessError } from '@ohos.base';
import { Logger } from '@ohos/common';

/**
 * 关于信息
 */
@Observed
export class AppInfo {
  public name: Resource | string = '';
  public versionCode: Resource | string = '';
}

/**
 * 获取当前app信息
 */
export async function getBundleInfo() {
  let bundleFlags =
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION | bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA;
  let appInfo: AppInfo = new AppInfo();
  await bundleManager.getBundleInfoForSelf(bundleFlags).then((data) => {
    try {
      appInfo.name = getContext().resourceManager.getStringSync(data.appInfo.labelResource);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      Logger.error(`getStringSync failed, error code: ${code}, message: ${message}.`);
    }
    appInfo.versionCode = data.versionName;
    return appInfo;
  });
  return appInfo;
}