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
import { ServerType } from '@ohos/common/index';
import BlePackageWrapper from './BlePackageWrapper';

/**
 * ble发送的基础数据包，如果超过大小，会进行分包
 */
export default class BlePackage {
  /**
   * 解析一个wrapper
   * @param wrapper
   * @returns
   */
  public static parser(wrapper: BlePackageWrapper): BlePackage {
    // return new BlePackage();
    throw Error('not implement');
  }

  /**
   * 把多个wrapper分包合并成一个，并解析
   * @param wrappers
   * @returns
   */
  public static parserSubPackage(wrappers: Array<BlePackageWrapper>): BlePackage {
    // return new BlePackage();
    throw Error('not implement');
  }

  /**
   * package最后的明文信息，只包含业务信息，传输协议部分信息剔除。
   */
  public cmdType: number;
  public messageId: number;
  public returnFlag: number;
  public optType: number;
  public serverType: ServerType;
  public body: string;

  constructor(cmdType: number,
    messageId: number,
    returnFlag: number,
    optType: number,
    serverType: ServerType,
    body: string) {
    this.cmdType = cmdType;
    this.messageId = messageId;
    this.returnFlag = returnFlag;
    this.optType = optType;
    this.serverType = serverType;
    this.body = body;
  }
};