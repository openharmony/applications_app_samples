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
import { PermissionsClass } from '../utils/PermissionUtil';

export declare interface InfAccessManager {

  /**
   * 查询当前能力是否可用，包括权限是否正确
   * @returns
   */
  isEnable(): Promise<boolean>;

  /**
   * 申请权限，开启能力，部分开启需要权限，包含权限申请过程
   */
  applyAccess(context: Context): Promise<boolean>;

  /**
   * 获取能力名称，唯一标识符，重复的能力会被筛选掉
   * @returns
   */
  getAccessCode(): string;

  /**
   * 获取能力名
   * @returns
   */
  getAccessName(): Resource;

  /**
   * 获取需要用户授权的权限
   * @returns
   */
  getUserAuthPermission(): Array<PermissionsClass>;
}