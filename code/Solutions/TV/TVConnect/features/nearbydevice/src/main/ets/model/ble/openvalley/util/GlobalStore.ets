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
import common from '@ohos.app.ability.common';
import { PreferencesUtils, StringUtils } from 'library_communication';
import { ControllerItem } from '../entity/ControllerItem';
import { SecretKeyAndSign } from '../entity/SecretKeyAndSign';
import { GlobalContext } from './GlobalContext';


const TAG = 'GlobalStore';

const SP_NAME: string = 'openvalley_zaiohos_controller';
const KEY_ACCOUNT: string = 'account';
const KEY_TENANT_ID: string = 'tenantId';
const KEY_REFRESH_TOKEN: string = 'refresh_token';
const KEY_ACCESS_TOKEN: string = 'access_token';
const KEY_SECRET_KEY_AND_SIGN: string = 'secret_key_and_sign';
const KEY_LOCAL_CONTROLLER_ITEM: string = 'local_controller_item';

export class GlobalStore {
  private static instance: GlobalStore | null = null;
  private context: common.Context;

  private constructor() {
    this.context = GlobalContext.get().getObject('context') as common.Context;
  }

  public static getInstance(): GlobalStore {
    if (!GlobalStore.instance) {
      GlobalStore.instance = new GlobalStore();
    }
    return GlobalStore.instance;
  }

  public clear() {
    this.clearTenantId();
    this.clearRefreshToken();
    this.clearAccessToken();
    this.clearSecretKeyAndSign();
  }

  public saveAccount(account: string) {
    PreferencesUtils.save(this.context, KEY_ACCOUNT, account);
  }

  public getAccount(): string {
    return PreferencesUtils.get(this.context, KEY_ACCOUNT, '').toString();
  }

  public saveTenantId(tenantId: string) {
    PreferencesUtils.save(this.context, KEY_TENANT_ID, tenantId);
  }


  public getTenantId(): string {
    return PreferencesUtils.get(this.context, KEY_TENANT_ID, '').toString();
  }

  public clearTenantId() {
    PreferencesUtils.delete(this.context, KEY_TENANT_ID);
  }

  public saveRefreshToken(refreshToken: string) {
    PreferencesUtils.save(this.context, KEY_REFRESH_TOKEN, refreshToken);
  }

  public getRefreshToken(): string {
    return PreferencesUtils.get(this.context, KEY_REFRESH_TOKEN, '').toString();
  }

  public clearRefreshToken() {
    PreferencesUtils.delete(this.context, KEY_REFRESH_TOKEN);
  }

  public saveAccessToken(accessToken: string) {
    PreferencesUtils.save(this.context, KEY_ACCESS_TOKEN, accessToken);
  }

  public getAccessToken(): string {
    return PreferencesUtils.get(this.context, KEY_ACCESS_TOKEN, '').toString();
  }

  public clearAccessToken() {
    PreferencesUtils.delete(this.context, KEY_ACCESS_TOKEN);
  }

  public saveSecretKeyAndSign(secretKeyAndSign: SecretKeyAndSign) {
    PreferencesUtils.save(this.context, KEY_SECRET_KEY_AND_SIGN, JSON.stringify(secretKeyAndSign));
  }

  public getSecretKeyAndSign(): SecretKeyAndSign | null {
    let jsonStr: string = PreferencesUtils.get(this.context, KEY_SECRET_KEY_AND_SIGN, '');
    if (StringUtils.isEmpty(jsonStr)) {
      return null;
    }
    return JSON.parse(jsonStr) as SecretKeyAndSign;
  }

  public clearSecretKeyAndSign() {
    PreferencesUtils.delete(this.context, KEY_SECRET_KEY_AND_SIGN);
  }

  public saveLocalControllerItem(controllerItem: ControllerItem) {
    PreferencesUtils.save(this.context, KEY_LOCAL_CONTROLLER_ITEM, JSON.stringify(controllerItem));
  }

  public getLocalControllerItem(): ControllerItem | null {
    let jsonStr: string = PreferencesUtils.get(this.context, KEY_LOCAL_CONTROLLER_ITEM, '');
    if (StringUtils.isEmpty(jsonStr)) {
      return null;
    }
    return JSON.parse(jsonStr) as ControllerItem;
  }

  public clearLocalControllerItem() {
    PreferencesUtils.delete(this.context, KEY_LOCAL_CONTROLLER_ITEM);
  }
}