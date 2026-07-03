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
import { DeviceUtils, HttpRequest, Logger, UserLibraryDao } from '@ohos/common';
import { UserData } from '@ohos/common/src/main/ets/database/entity/UserDate';
import { LoginUtil } from '../utils/LoginUtil';
import {
  AccountLoginBackDataType,
  AccountLoginBackReturnType,
  PhoneValidCodeReqNoVO,
  UserDataBackType,
  UserDataType,
} from './PayloadType';

export class LoginCloud {
  private static readonly URL_USER_LOGIN_GET_CODE = '/device_cloud/auth/app/getPhoneValidCode?phone=';
  private static readonly URL_USER_REGISTER = '/device_cloud/app/user/add';
  private static readonly URL_USER_GET_DATA = '/device_cloud/auth/app/getLoginUser';
  private static readonly URL_USER_SET_DATA = '/device_cloud/app/user/edit';
  private static readonly URL_USER_ACCOUNT_LOGIN = '/device_cloud/auth/app/doLogin';
  private static readonly URL_USER_PHONE_LOGIN = '/device_cloud/auth/app/doLoginByPhone';
  private static readonly URL_USER_GET_LOGIN_USER = '/device_cloud/auth/app/getLoginUser?account=';
  private static readonly URL_USER_GET_LOGIN_OUT = '/device_cloud/auth/app/doLogout';
  private static readonly URL_USER_CANCEL_ACCOUNT = '/device_cloud/app/user/delete';

  public static async getLoginCode(phone: string): Promise<string> {
    Logger.info('getLoginCode start');
    let url = LoginCloud.URL_USER_LOGIN_GET_CODE + phone;
    Logger.info('getLoginCode start url' + url);
    let validCodeReqNoVOData = await HttpRequest.get<PhoneValidCodeReqNoVO>(url);
    Logger.info('getLoginCode start validCodeReqNoVOData' + JSON.stringify(validCodeReqNoVOData));
    return validCodeReqNoVOData.validCodeReqNo;
  }

  public static async tryToRegister(account: string, password: string, phone: string, validCode: string,
    validCodeReqNo: string): Promise<boolean> {
    Logger.info('tryToRegister start');
    let url = LoginCloud.URL_USER_REGISTER;
    let extraData: Record<string, string> = {};
    extraData['account'] = account;
    extraData['password'] = password;
    extraData['phone'] = phone;
    extraData['validCode'] = validCode;
    extraData['validCodeReqNo'] = validCodeReqNo;
    return HttpRequest.post<boolean>(url, extraData);
  }

  public static async getUserData(): Promise<UserDataBackType> {
    Logger.info('getUserData start');
    let url = LoginCloud.URL_USER_GET_DATA;
    let userData = await HttpRequest.get<UserDataBackType>(url);
    return userData;
  }

  public static async setUserData(userData: UserDataType): Promise<boolean> {
    Logger.info('setUserData start');
    let url = LoginCloud.URL_USER_SET_DATA;
    let account = UserLibraryDao.getUserAccount();
    let extraData: Record<string, string> = {};
    extraData['account'] = account;
    if (userData.avatar != null) {
      extraData['avatar'] = userData.avatar;
    }
    if (userData.nickname != null) {
      extraData['nickname'] = userData.nickname;
    }
    if (userData.phone != null) {
      extraData['phone'] = userData.phone;
    }
    if (userData.email != null) {
      extraData['email'] = userData.email;
    }
    if (userData.password != null) {
      extraData['password'] = userData.password;
    }
    let isSuccess = await HttpRequest.post<boolean>(url, extraData);
    if (isSuccess) {
      let setUserData: UserData = {};
      if (userData.nickname != null) {
        setUserData.userName = userData.nickname;
      }
      if (userData.phone != null) {
        setUserData.userPhoneNumber = userData.phone;
      }
      if (userData.email != null) {
        setUserData.userEmail = userData.email;
      }
      if (userData.password != null) {
        setUserData.userPassword = userData.password;
      }
      await UserLibraryDao.setUserData(setUserData);
    }
    return isSuccess;
  }

  public static async accountLogin(account: string, password: string): Promise<AccountLoginBackReturnType> {
    Logger.info('accountLogin start');
    let url = LoginCloud.URL_USER_ACCOUNT_LOGIN;
    let deviceID = DeviceUtils.getDeviceIdSync();

    let extraData: Record<string, string> = {};
    extraData['account'] = account;
    extraData['password'] = password;
    extraData['device'] = deviceID;
    let dataType = await HttpRequest.post<AccountLoginBackDataType>(url, extraData);
    let message: AccountLoginBackReturnType = {
      code: 200, // code为200则登录成功，返回值正确
      token: dataType.token,
      mqttUrl: dataType.mqttAccountVO.mqttUrl,
      clientId: dataType.mqttAccountVO.clientId,
      mqttPassword: dataType.mqttAccountVO.password,
      mqttUsername: dataType.mqttAccountVO.username,
    };
    await UserLibraryDao.setUserData({ userToken: message.token });
    let userData = await LoginCloud.getUserData();
    await UserLibraryDao.setUserData({
      userName: userData.nickname,
      userAccount: account,
      userPassword: password,
      userPhoneNumber: userData.phone,
      userEmail: userData.email,
      userToken: message.token,
      userMqttUrl: message.mqttUrl,
      userClientId: message.clientId,
      mqttUserName: message.mqttUsername,
      mqttPassword: message.mqttPassword,
      isLogin: true
    });
    if (userData.avatar) {
      await LoginUtil.base64ToApplicationSandbox(userData.avatar);
    } else {
      await UserLibraryDao.deleteUserAvatar();
    }
    return message;
  }

  public static async phoneLogin(phone: string, validCode: string, validCodeReqNo: string): Promise<string> {
    Logger.info('phoneLogin start');
    let url = LoginCloud.URL_USER_PHONE_LOGIN;
    let deviceID = DeviceUtils.getDeviceIdSync();
    let extraData: Record<string, string> = {};
    extraData['phone'] = phone;
    extraData['validCode'] = validCode;
    extraData['device'] = deviceID;
    extraData['validCodeReqNo'] = validCodeReqNo;
    let dataType = await HttpRequest.post<string>(url, extraData);
    return dataType;
  }

  public static async getLoginOut(): Promise<string> {
    Logger.info('getLoginOut start');
    let device = DeviceUtils.getDeviceIdSync();
    let url = LoginCloud.URL_USER_GET_LOGIN_OUT;
    if (device) {
      url = url + '?device=' + device;
    }
    let message = await HttpRequest.get<string>(url);
    await UserLibraryDao.deleteUserData();
    return message;
  }

  public static async cancelAccount(): Promise<boolean> {
    Logger.info('cancelAccount start');
    let url = LoginCloud.URL_USER_CANCEL_ACCOUNT;
    let account = UserLibraryDao.getUserAccount();
    let deviceId = DeviceUtils.getDeviceIdSync();
    let extraData: Record<string, string> = {};
    extraData['account'] = account;
    extraData['deviceId'] = deviceId;
    let isCancel = await HttpRequest.post<boolean>(url, extraData);
    await UserLibraryDao.deleteUserData();
    return isCancel;
  }
}