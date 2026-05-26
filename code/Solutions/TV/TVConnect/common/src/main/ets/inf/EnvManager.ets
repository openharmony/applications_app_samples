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
import { Logger } from '../utils/Logger';
import { InfAccessManager } from './InfAccessManager';
import { getProtocolCode, ProtocolType } from './TypeEnum';

const NOT_FOUND_TIP: string = 'cant found the access manager by code';

const ENV_TAG = 'EnvManager';

export class EnvManager {
  public static instance: EnvManager = new EnvManager();
  private accessManagerArray: InfAccessManager[] = [];
  private noAccessArray: string[] = [];

  public static getInstance(): EnvManager {
    return EnvManager.instance;
  }

  registerAccessManager(infAccessManager: InfAccessManager) {
    let index =
      this.accessManagerArray.findIndex((manager) => manager.getAccessCode() == infAccessManager.getAccessCode());
    if (index >= 0) {
      Logger.warn(ENV_TAG, `registerAccessManager filter ${infAccessManager.getAccessCode()}`);
      return;
    }
    this.accessManagerArray.push(infAccessManager);
  }

  private getAccessManagerByCode(code: string): InfAccessManager | null {
    for (let i = 0; i < this.accessManagerArray.length; i++) {
      let accessManager: InfAccessManager = this.accessManagerArray[i];
      if (accessManager.getAccessCode() === code) {
        return accessManager;
      }
    }
    return null;
  }

  async recheckNoAccessCodes(): Promise<Array<string>> {
    this.noAccessArray = [];
    for (let i = 0; i < this.accessManagerArray.length; i++) {
      let accessManager: InfAccessManager = this.accessManagerArray[i];
      if (!(await accessManager.isEnable())) {
        if (!this.noAccessArray.includes(accessManager.getAccessCode())) {
          this.noAccessArray.push(accessManager.getAccessCode());
        }
      }
    }
    return this.noAccessArray;
  }

  /**
   * 获取还未授权的能力code
   * @returns
   */
  getNoAccessCodes(): Array<string> {
    return this.noAccessArray;
  }

  /**
   * 某个协议是否可用
   * @param type
   * @returns
   */
  isProtocolEnable(type: ProtocolType.BLE | ProtocolType.WIFI): boolean {
    let noAccessArray: string[] = this.getNoAccessCodes();
    for (let i = 0; i < noAccessArray.length; i++) {
      if (noAccessArray[i] == getProtocolCode(type)) {
        return false;
      }
    }
    return true;
  }

  getAccessNumber(): number {
    return this.accessManagerArray.length;
  }

  /**
   * 是否还未有任何权限
   * @returns
   */
  isNoAccess(): boolean {
    Logger.debug(ENV_TAG, 'this.getNoAccessCodes().length = ' + this.getNoAccessCodes().length);
    return this.getNoAccessCodes().length == this.accessManagerArray.length;
  }

  /**
   * 根据code，获取能力名
   * @param code
   * @returns
   */
  getAccessNameResourceByCode(code: string): Resource | null {
    let manager: InfAccessManager | null = this.getAccessManagerByCode(code);
    if (manager != null) {
      return manager.getAccessName();
    } else {
      Logger.fatal(ENV_TAG, NOT_FOUND_TIP);
      return null;
    }
  }

  /**
   * 根据code，打开能力
   * @param code
   * @returns
   */
  async enableAccessByCode(context: Context, code: string): Promise<boolean> {
    let manager: InfAccessManager | null = this.getAccessManagerByCode(code);
    if (manager != null) {
      Logger.debug(ENV_TAG, 'enable access: code = ' + code);
      return await manager.applyAccess(context);
    } else {
      Logger.fatal(ENV_TAG, NOT_FOUND_TIP);
      return false;
    }
  }
}