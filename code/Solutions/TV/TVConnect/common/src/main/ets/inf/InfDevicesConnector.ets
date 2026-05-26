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
import { InfDevice } from './InfDevice';
import { ProtocolType } from './TypeEnum';

export declare interface InfDevicesConnector {

  /**
   * 进行连接
   * @param device
   * @returns
   */
  connect(device: InfDevice): Promise<boolean>;

  /**
   * 获取当前连接的设备
   * @returns
   */
  getCurrentConnectedDevice(): InfDevice | undefined;

  /**
   * 停止连接
   * @param device
   * @returns
   */
  stopConnect(device: InfDevice): Promise<boolean>;
}

/**
 * 和设备成功连接后，都会产生一个connectedInfo，所有的设备控制，都依赖connectedInfo
 */
export interface ConnectedInfo {
  getDevice(): InfDevice;

  getProtocolType(): ProtocolType;
}