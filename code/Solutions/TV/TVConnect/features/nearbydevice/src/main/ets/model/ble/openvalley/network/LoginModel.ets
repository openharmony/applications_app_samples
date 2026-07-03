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
export class LoginReq {
  public clientId: string = 'app-base';
  public grantType: string = 'password';
  public username: string;
  public password: string;
  public tenantId: string;

  constructor(username: string, password: string, tenantId: string) {
    this.username = username;
    this.password = password;
    this.tenantId = tenantId;
  }
}

export class LoginRes {
  public code: string = '';
  public msg: string = '';
  public data?: LoginData;
}

export class LoginData {
  public accessToken?: string;
  public refreshToken?: string;
  public tokenType?: string;
  public redirectUri?: string;
}
