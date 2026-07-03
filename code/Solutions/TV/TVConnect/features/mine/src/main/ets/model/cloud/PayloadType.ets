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
// 登陆注册相关type

// 手机验证码获取
export interface CodeGetType {
  phone: string;
}

export interface CodeGetBackType {
  code: number;
  data: PhoneValidCodeReqNoVO;
  msg: string;
}

export interface PhoneValidCodeReqNoVO {
  validCodeReqNo: string;
}

// 账号注册
export interface RegistrationType {
  account: string;
  password: string;
  phone: string;
  validCode: string;
  validCodeReqNo: string;
}

export interface RegistrationBackType {
  code: number;
  data: boolean;
  msg: string;
}

// 账号信息获取设置
export interface UserDataType {
  avatar?: string;
  nickname?: string;
  phone?: string;
  email?: string;
  password?: string;
}

export interface UserDataBackType {
  enabled: boolean;
  id: string;
  avatar: string;
  signature: string;
  account: string;
  name: string;
  nickname: string;
  gender: string;
  age: string;
  birthday: string;
  nation: string;
  nativePlace: string;
  homeAddress: string;
  mailingAddress: string;
  idCardType: string;
  idCardNumber: string;
  cultureLevel: string;
  politicalOutlook: string;
  college: string;
  education: string;
  eduLength: string;
  degree: string;
  phone: string;
  email: string;
  homeTel: string;
  officeTel: string;
  emergencyContact: string;
  emergencyPhone: string;
  emergencyAddress: string;
  lastLoginIp: string;
  lastLoginAddress: string;
  lastLoginTime: string;
  lastLoginDevice: string;
  latestLoginIp: string;
  latestLoginAddress: string;
  latestLoginTime: string;
  latestLoginDevice: string;
  userStatus: string;
  sortCode: string;
  extJson: string;
  buttonCodeList: string;
  mobileButtonCodeList: string;

}

// 账号登录
export interface AccountLoginBackType {
  code: number;
  data: AccountLoginBackDataType;
  msg: string;
}

export interface AccountLoginBackDataType {
  token: string;
  mqttAccountVO: mqttAccountVO;
}

export interface mqttAccountVO {
  mqttUrl: string;
  clientId: string;
  username: string;
  password: string;
}

export interface AccountLoginBackReturnType {
  code: number;
  token: string;
  mqttUrl: string;
  clientId: string;
  mqttUsername: string;
  mqttPassword: string;
}

export interface phoneLoginBackType {
  code: number;
  data: string;
  msg: string;
}
