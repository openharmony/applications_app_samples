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
import dataPreferences from '@ohos.data.preferences'; // 假设 HarmonyOS 提供的存储模块
import { Logger } from '@ohos/common';

export default class Net {
  public context: Context = getContext();
  private static instance: Net;
  public ip: string = '';
  public typeId: string = '5';
  public orgId: string = '';
  public deptId: string = '';

  private constructor() {
    this.loadProperties();
  }

  public static getInstance(): Net {
    if (!Net.instance) {
      Net.instance = new Net();
    }
    return Net.instance;
  }

  private saveProperties() {
    dataPreferences.getPreferences(this.context, 'netConfig', (err, preferences) => {
      if (err) {
        Logger.error('Failed to get preferences:' + err);
        return;
      }
      Logger.info(`Saving properties: Ip=${this.ip}, typeId=${this.typeId}, orgId=${this.orgId}, deptId=${this.deptId}`);
      preferences.putSync('Ip', this.ip);
      preferences.putSync('typeId', this.typeId);
      preferences.putSync('orgId', this.orgId);
      preferences.putSync('deptId', this.deptId);
      preferences.flush();
    });
  }

  private loadProperties() {
    dataPreferences.getPreferences(this.context, 'netConfig', (err, preferences) => {
      if (err) {
        Logger.error('Failed to get preferences:' + err);
        return;
      }
      this.ip = preferences.getSync('Ip', '222.173.253.70:18080') as string;
      this.typeId = preferences.getSync('typeId', '5') as string;
      this.orgId = preferences.getSync('orgId', '') as string;
      this.deptId = preferences.getSync('deptId', '') as string;
    });
  }

  // Example setters that save properties after setting them
  public setIp(ip: string) {
    this.ip = ip;
    this.saveProperties();
  }

  public setTypeId(typeId: string) {
    this.typeId = typeId;
    this.saveProperties();
  }

  public setOrgId(orgId: string) {
    this.orgId = orgId;
    this.saveProperties();
  }

  public setDeptId(deptId: string) {
    this.deptId = deptId;
    this.saveProperties();
  }
};
