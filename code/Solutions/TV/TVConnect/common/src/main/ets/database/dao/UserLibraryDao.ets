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

import { preferences } from '@kit.ArkData';
import { CommonConstants } from '../../constants/CommonConstants';
import { Logger } from '../../utils/Logger';
import { UserDataEvent } from '../../utils/UserDataEvent';
import { UserData } from '../entity/UserDate';
import { fileIo } from '@kit.CoreFileKit';

// 用户信息持久化
export class UserLibraryDao {
  // 设置数据
  public static async setUserData(userData: UserData) {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      if (userData.userName != null) {
        dataPreferences.putSync('userName', userData.userName);
      }
      if (userData.userAccount != null) {
        dataPreferences.putSync('userAccount', userData.userAccount);
      }
      if (userData.userPassword != null) {
        dataPreferences.putSync('userPassword', userData.userPassword);
      }
      if (userData.userAvatar != null) {
        let historyUriName = dataPreferences.getSync('userAvatar', '') as string;
        if (historyUriName) {
          let filesDir = context.filesDir;
          let historyUri = filesDir + historyUriName;
          let isFileRight = await fileIo.access(historyUri);
          if (isFileRight) {
            await fileIo.unlink(historyUri);
          }
        }
        dataPreferences.putSync('userAvatar', userData.userAvatar);
      }
      if (userData.userPhoneNumber != null) {
        dataPreferences.putSync('userPhoneNumber', userData.userPhoneNumber);
      }
      if (userData.userEmail != null) {
        dataPreferences.putSync('userEmail', userData.userEmail);
      }
      if (userData.userToken != null) {
        dataPreferences.putSync('userToken', userData.userToken);
      }
      if (userData.userMqttUrl != null) {
        dataPreferences.putSync('userMqttUrl', userData.userMqttUrl);
      }
      if (userData.userClientId != null) {
        dataPreferences.putSync('userClientId', userData.userClientId);
      }
      if (userData.mqttPassword != null) {
        dataPreferences.putSync('mqttPassword', userData.mqttPassword);
      }
      if (userData.mqttUserName != null) {
        dataPreferences.putSync('mqttUserName', userData.mqttUserName);
      }
      if (userData.isLogin != null) {
        dataPreferences.putSync('userIsLogin', userData.isLogin);
      }
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('setUserData successful');
    } catch (e) {
      Logger.error(`setUserData failed, error code: ${e}.`);
    }
  }

  // 获取数据
  public static getUserName(): string {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      let userName = dataPreferences.getSync('userName', '') as string;
      Logger.debug('getUserName successful');
      return userName;
    } catch (e) {
      Logger.error(`getUserName failed, error code: ${e}.`);
      return '';
    }
  }

  public static getUserAccount(): string {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      let userAccount = dataPreferences.getSync('userAccount', '') as string;
      Logger.debug('getUserAccount successful');
      return userAccount;
    } catch (e) {
      Logger.error(`getUserAccount failed, error code: ${e}.`);
      return '';
    }
  }

  public static getUserPassword(): string {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      let userPassword = dataPreferences.getSync('userPassword', '') as string;
      Logger.debug('getUserPassword successful');
      return userPassword;
    } catch (e) {
      Logger.error(`getUserPassword failed, error code: ${e}.`);
      return '';
    }
  }

  public static getUserAvatar(): string {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      let userAvatar = dataPreferences.getSync('userAvatar', '') as string;
      Logger.debug('getUserAvatar successful');
      return userAvatar;
    } catch (e) {
      Logger.error(`getUserAvatar failed, error code: ${e}.`);
      return '';
    }
  }

  public static getPhoneNumber(): string {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      let phoneNumber = dataPreferences.getSync('userPhoneNumber', '') as string;
      Logger.debug('getPhoneNumber successful');
      return phoneNumber;
    } catch (e) {
      Logger.error(`getPhoneNumber failed, error code: ${e}.`);
      return '';
    }
  }

  public static getEmail(): string {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      let email = dataPreferences.getSync('userEmail', '') as string;
      Logger.debug('getEmail successful');
      return email;
    } catch (e) {
      Logger.error(`getEmail failed, error code: ${e}.`);
      return '';
    }
  }

  public static getToken(): string {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      let token = dataPreferences.getSync('userToken', '') as string;
      Logger.debug('getToken successful');
      return token;
    } catch (e) {
      Logger.error(`getToken failed, error code: ${e}.`);
      return '';
    }
  }

  public static getUserMqttUrl(): string {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      let userMqttUrl = dataPreferences.getSync('userMqttUrl', '') as string;
      Logger.debug('getUserMqttUrl successful');
      return userMqttUrl;
    } catch (e) {
      Logger.error(`getUserMqttUrl failed, error code: ${e}.`);
      return '';
    }
  }

  public static getUserClientId(): string {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      let userClientId = dataPreferences.getSync('userClientId', '') as string;
      Logger.debug('getUserClientId successful');
      return userClientId;
    } catch (e) {
      Logger.error(`getUserClientId failed, error code: ${e}.`);
      return '';
    }
  }

  public static getMqttPassword(): string {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      let mqttPassword = dataPreferences.getSync('mqttPassword', '') as string;
      Logger.debug('getMqttPassword successful');
      return mqttPassword;
    } catch (e) {
      Logger.error(`getMqttPassword failed, error code: ${e}.`);
      return '';
    }
  }

  public static getMqttUserName(): string {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      let mqttUserName = dataPreferences.getSync('mqttUserName', '') as string;
      Logger.debug('getMqttUserName successful');
      return mqttUserName;
    } catch (e) {
      Logger.error(`getMqttUserName failed, error code: ${e}.`);
      return '';
    }
  }

  public static getIsLogin(): boolean {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      let isLogin = dataPreferences.getSync('userIsLogin', false) as boolean;
      Logger.debug('getIsLogin successful');
      return isLogin;
    } catch (e) {
      Logger.error(`getIsLogin failed, error code: ${e}.`);
      return false;
    }
  }

  // 数据置空
  public static async deleteUserData() {
    try {
      Logger.debug('deleteUserData start');
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      dataPreferences.putSync('userName', '');
      dataPreferences.putSync('userAccount', '');
      dataPreferences.putSync('userPassword', '');
      let historyUriName = dataPreferences.getSync('userAvatar', '') as string;
      if (historyUriName) {
        let filesDir = context.filesDir;
        let historyUri = filesDir + historyUriName;
        let isFileRight = await fileIo.access(historyUri);
        if (isFileRight) {
          await fileIo.unlink(historyUri);
        }
      }
      dataPreferences.putSync('userAvatar', '');
      dataPreferences.putSync('userPhoneNumber', '');
      dataPreferences.putSync('userEmail', '');
      dataPreferences.putSync('userToken', '');
      dataPreferences.putSync('userMqttUrl', '');
      dataPreferences.putSync('userClientId', '');
      dataPreferences.putSync('mqttPassword', '');
      dataPreferences.putSync('mqttUserName', '');
      dataPreferences.putSync('userIsLogin', false);
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('deleteUserData successful');
    } catch (e) {
      Logger.error(`deleteUserData failed, error code: ${e}.`);
    }
  }

  public static async deleteUserName() {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      dataPreferences.putSync('userName', '');
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('deleteUserName successful');
    } catch (e) {
      Logger.error(`deleteUserName failed, error code: ${e}.`);
    }
  }

  public static async deleteUserAccount() {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      dataPreferences.putSync('userAccount', '');
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('deleteUserAccount successful');
    } catch (e) {
      Logger.error(`deleteUserAccount failed, error code: ${e}.`);
    }
  }

  public static async deleteUserPassword() {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      dataPreferences.putSync('userPassword', '');
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('deleteUserPassword successful');
    } catch (e) {
      Logger.error(`deleteUserPassword failed, error code: ${e}.`);
    }
  }

  public static async deleteUserAvatar() {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      let historyUriName = dataPreferences.getSync('userAvatar', '') as string;
      if (historyUriName) {
        let filesDir = context.filesDir;
        let historyUri = filesDir + historyUriName;
        let isFileRight = await fileIo.access(historyUri);
        if (isFileRight) {
          await fileIo.unlink(historyUri);
        }
      }
      dataPreferences.putSync('userAvatar', '');
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('deleteUserAvatar successful');
    } catch (e) {
      Logger.error(`deleteUserAvatar failed, error code: ${e}.`);
    }
  }

  public static async deleteUserEmail() {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      dataPreferences.putSync('userEmail', '');
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('deleteUserEmail successful');
    } catch (e) {
      Logger.error(`deleteUserEmail failed, error code: ${e}.`);
    }
  }

  public static async deletePhoneNumber() {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      dataPreferences.putSync('userPhoneNumber', '');
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('deletePhoneNumber successful');
    } catch (e) {
      Logger.error(`deletePhoneNumber failed, error code: ${e}.`);
    }
  }

  public static async deleteToken() {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      dataPreferences.putSync('userToken', '');
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('deleteToken successful');
    } catch (e) {
      Logger.error(`deleteToken failed, error code: ${e}.`);
    }
  }

  public static async deleteUserMqttUrl() {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      dataPreferences.putSync('userMqttUrl', '');
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('deleteUserMqttUrl successful');
    } catch (e) {
      Logger.error(`deleteUserMqttUrl failed, error code: ${e}.`);
    }
  }

  public static async deleteMqttPassword() {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      dataPreferences.putSync('mqttPassword', '');
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('deleteMqttPassword successful');
    } catch (e) {
      Logger.error(`deleteMqttPassword failed, error code: ${e}.`);
    }
  }

  public static async deleteMqttUserName() {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      dataPreferences.putSync('mqttUserName', '');
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('deleteMqttUserName successful');
    } catch (e) {
      Logger.error(`deleteMqttUserName failed, error code: ${e}.`);
    }
  }

  public static async deleteUserClientId() {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      dataPreferences.putSync('userClientId', '');
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('deleteUserClientId successful');
    } catch (e) {
      Logger.error(`deleteUserClientId failed, error code: ${e}.`);
    }
  }

  public static async deleteIsLogin() {
    try {
      let context = getContext();
      let dataPreferences: preferences.Preferences | null = null;
      let options: preferences.Options = { name: CommonConstants.USERDATA };
      dataPreferences = preferences.getPreferencesSync(context, options);
      dataPreferences.putSync('userIsLogin', false);
      await dataPreferences.flush();
      UserDataEvent.UserDataIsChangeEvent();
      Logger.debug('deleteIsLogin successful');
    } catch (e) {
      Logger.error(`deleteIsLogin failed, error code: ${e}.`);
    }
  }
}