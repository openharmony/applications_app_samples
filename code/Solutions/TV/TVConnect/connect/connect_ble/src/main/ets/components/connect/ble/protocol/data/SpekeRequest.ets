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
export class SpekeRequest {
  public sessionId: string;
  public puuid: string;
  public cmd: string;
  public securityData: SecurityData;
  public dataLength: number;

  constructor(sessionId: string,
    puuid: string,
    cmd: string,
    securityData: SecurityData,
    dataLength: number) {
    this.sessionId = sessionId;
    this.puuid = puuid;
    this.cmd = cmd;
    this.securityData = securityData;
    this.dataLength = dataLength;
  }
}

class SecurityData {
  public message: number;
  public payload: Payload;

  constructor(message: number, payload: Payload) {
    this.message = message;
    this.payload = payload;
  }
}

class Payload {
  public version: Version;
  //安全随机数
  public challenge: string;
  //随机盐值
  public salt: string;
  //公钥
  public epk: string;

  constructor(version: Version, challengh: string, salt: string, epk: string) {
    this.version = version;
    this.challenge = challengh;
    this.salt = salt;
    this.epk = epk;
  }
}

class Version {
  public currentVersion: string;
  public minVersion: string;

  constructor(currentVersion: string, minVersion: string) {
    this.currentVersion = currentVersion;
    this.minVersion = minVersion;
  }
}