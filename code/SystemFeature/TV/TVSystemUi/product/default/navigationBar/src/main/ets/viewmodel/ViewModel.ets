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
 

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

import { privacyManager } from '@kit.AppGalleryKit';
import { Permissions } from 'permissions';
import { IndicatorType } from '../common/IndicatorConfig';
import Log from '../../../../../../../common/src/main/ets/default/Log';

const TAG = 'PrivacyIndicatorViewModel';

/**
 * 表示未使用权限。
 */
const PERMISSION_INACTIVE = 0;

/**
 * 相机权限
 */
const PERMISSION_CAMERA = 'ohos.permission.CAMERA';

/**
 * 定位权限
 */
const PERMISSION_LOCATION = 'ohos.permission.LOCATION';
const PERMISSION_APPROXIMATELY_LOCATION = 'ohos.permission.APPROXIMATELY_LOCATION';
const PERMISSION_LOCATION_IN_BACKGROUND = 'ohos.permission.LOCATION_IN_BACKGROUND';

/**
 * 麦克风权限
 */
const PERMISSION_MICROPHONE = 'ohos.permission.MICROPHONE';

export class ViewModel {
  private permissionNameList: Permissions[] = [PERMISSION_CAMERA, PERMISSION_MICROPHONE,
    PERMISSION_LOCATION, PERMISSION_APPROXIMATELY_LOCATION, PERMISSION_LOCATION_IN_BACKGROUND];
  private mIndicatorStatusMap: Map<number, boolean>;
  private mLocationStatusMap: Map<string, boolean>;
  private mCallback: (type: number) => {};

  constructor() {
    this.mIndicatorStatusMap = new Map();
    this.mIndicatorStatusMap.set(IndicatorType.TYPE_ORANGE, false);
    this.mIndicatorStatusMap.set(IndicatorType.TYPE_GREEN, false);
    this.mIndicatorStatusMap.set(IndicatorType.TYPE_BLUE, false);
    this.mLocationStatusMap = new Map();
    this.mLocationStatusMap.set(PERMISSION_LOCATION, false);
    this.mLocationStatusMap.set(PERMISSION_APPROXIMATELY_LOCATION, false);
    this.mLocationStatusMap.set(PERMISSION_LOCATION_IN_BACKGROUND, false);
  }

  setCallback(callback) {
    this.mCallback = callback;
  }

  registerPrivacyStateListener(): void {
    try {
      privacyManager.on('activeStateChange', this.permissionNameList, (data) => {
        Log.showInfo(TAG, 'permission state changed.');
        if (data == null) {
          Log.showWarn(TAG, 'response is invalid.');
          return;
        }
        const isShow = data.activeStatus != PERMISSION_INACTIVE;
        switch (data.permissionName) {
          case PERMISSION_CAMERA:
            this.refreshIndicatorStatus(IndicatorType.TYPE_ORANGE, isShow);
            break;
          case PERMISSION_MICROPHONE:
            this.refreshIndicatorStatus(IndicatorType.TYPE_GREEN, isShow);
            break;
          case PERMISSION_LOCATION:
          case PERMISSION_LOCATION_IN_BACKGROUND:
          case PERMISSION_APPROXIMATELY_LOCATION:
            this.mLocationStatusMap.set(data.permissionName, isShow);
            this.refreshIndicatorStatus(IndicatorType.TYPE_BLUE, this.getLocationStatus());
            break;
          default:
            Log.showDebug(TAG, 'no privacy type matched.');
            break;
        }
      });
    } catch (err) {
      Log.showError(TAG, `registerPrivacyStateListener error => ${JSON.stringify(err)}`);
    }
  }

  unregisterPrivacyStateListener(): void {
    try {
      privacyManager.off('activeStateChange', this.permissionNameList);
    } catch (err) {
      Log.showError(TAG, 'unregisterPrivacyStateListener error.');
    }
  }

  /**
   * 优先级：橙色相机>绿色麦克风>蓝色定位
   */
  private refreshIndicatorStatus(type: number, isShow: boolean): void {
    Log.showInfo(TAG, `indicator ${type} isShow: ${isShow}`);
    this.mIndicatorStatusMap.set(type, isShow);
    let resultType = IndicatorType.TYPE_NONE;
    if (this.mIndicatorStatusMap.get(IndicatorType.TYPE_ORANGE)) {
      resultType = IndicatorType.TYPE_ORANGE;
    } else if (this.mIndicatorStatusMap.get(IndicatorType.TYPE_GREEN)) {
      resultType = IndicatorType.TYPE_GREEN;
    } else if (this.mIndicatorStatusMap.get(IndicatorType.TYPE_BLUE)) {
      resultType = IndicatorType.TYPE_BLUE;
    } else {
      Log.showDebug(TAG, 'refresh no type matched.');
    }
    if (this.mCallback) {
      this.mCallback(resultType);
    }
  }

  /**
   * 定位权限
   * LOCATION_IN_BACKGROUND权限在后台时为true，前台时为false
   */
  private getLocationStatus(): boolean {
    return this.mLocationStatusMap.get(PERMISSION_LOCATION) ||
    this.mLocationStatusMap.get(PERMISSION_APPROXIMATELY_LOCATION) ||
    this.mLocationStatusMap.get(PERMISSION_LOCATION_IN_BACKGROUND);
  }
}
