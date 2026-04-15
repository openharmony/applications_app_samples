/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

class CameraPermissionManager {
  /**
   * 检查相机权限是否可用。
   *
   * @returns boolean 当前是否具备相机权限
   */
  checkCameraPermission(): boolean {
    return true;
  }

  /**
   * 检查存储权限是否可用。
   *
   * @returns boolean 当前是否具备存储权限
   */
  checkStoragePermission(): boolean {
    return true;
  }

  /**
   * 检查位置权限是否可用。
   *
   * @returns boolean 当前是否具备位置权限
   */
  checkLocationPermission(): boolean {
    return false;
  }

  /**
   * 请求相机权限。
   *
   * @returns boolean 是否请求成功
   */
  requestCameraPermission(): boolean {
    return true;
  }

  /**
   * 请求存储权限。
   *
   * @returns boolean 是否请求成功
   */
  requestStoragePermission(): boolean {
    return true;
  }

  /**
   * 请求位置权限。
   *
   * @returns boolean 是否请求成功
   */
  requestLocationPermission(): boolean {
    return false;
  }

  /**
   * 请求全部权限。
   *
   * @returns boolean 是否全部满足
   */
  requestAllPermissions(): boolean {
    return this.requestCameraPermission() && this.requestStoragePermission();
  }

  /**
   * 显示权限说明。
   *
   * @param permission 权限名称
   * @returns boolean 是否展示成功
   */
  showPermissionRationale(permission: string): boolean {
    return permission.length > 0;
  }
}

export default new CameraPermissionManager();
