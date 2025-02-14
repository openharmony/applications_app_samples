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

import { ArkTSUtils } from '@kit.ArkTS';

'use shared'

@Sendable
class Config {
  public lock: ArkTSUtils.locks.AsyncLock = new ArkTSUtils.locks.AsyncLock;
  public isLogin: boolean = false;
  public loginUser?: string;
  public wifiOn: boolean = false;

  async login(user: string) {
    return this.lock.lockAsync(() => {
      this.isLogin = true;
      this.loginUser = user;
    }, ArkTSUtils.locks.AsyncLockMode.EXCLUSIVE)
  }

  async logout(user?: string) {
    return this.lock.lockAsync(() => {
      this.isLogin = false;
      this.loginUser = '';
    }, ArkTSUtils.locks.AsyncLockMode.EXCLUSIVE)
  }

  async getIsLogin(): Promise<boolean> {
    return this.lock.lockAsync(() => {
      return this.isLogin;
    }, ArkTSUtils.locks.AsyncLockMode.SHARED)
  }

  async getUser(): Promise<string> {
    return this.lock.lockAsync(() => {
      return this.loginUser!;
    }, ArkTSUtils.locks.AsyncLockMode.SHARED)
  }

  async setWifiState(state: boolean) {
    return this.lock.lockAsync(() => {
      this.wifiOn = state;
    }, ArkTSUtils.locks.AsyncLockMode.EXCLUSIVE)
  }

  async isWifiOn() {
    return this.lock.lockAsync(() => {
      return this.wifiOn;
    }, ArkTSUtils.locks.AsyncLockMode.SHARED)
  }
}

export let config = new Config();