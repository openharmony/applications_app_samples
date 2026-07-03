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
import { StringUtils } from 'library_communication';

export enum Cmd {
  NONE = -1,
  /**
   * 认证成功
   */
  AUTH_SUCCESS = 0,
  /**
   * 认证失败
   */
  AUTH_FAIL = 1,
  /**
   * 设备未激活
   */
  DEV_UNACTIVATED = 2,
  /**
   * 连接未认证（配置证明认证成功前收到透传数据时回复此命令）
   */
  CONNECTION_NOT_AUTHENTICATED = 101,
  /**
   * 密钥未交换，只支持非加密透传数据（未收到公钥信息，却收到加密透传数据时回复此命令）
   */
  KEY_NOT_EXCHANGED = 102,
  /**
   * 未加密数据被拒绝（进入加密模式后，收到未加密的透传数据回复此命令）
   */
  UNENCRYPTED_DATA_REJECTED = 103,

}

export class AuthenticationRes {
  public cmd: Cmd = Cmd.NONE;
  public cmdDesc: string;
  public keyinfo: string;

  constructor(json: string) {
    let res = JSON.parse(json) as AuthenticationRes;
    this.cmd = res.cmd;
    this.cmdDesc = res.cmdDesc;
    this.keyinfo = res.keyinfo;
  }

  isSelf(): boolean {
    return this.cmd != Cmd.NONE && !StringUtils.isEmpty(this.cmdDesc);
  }
}

