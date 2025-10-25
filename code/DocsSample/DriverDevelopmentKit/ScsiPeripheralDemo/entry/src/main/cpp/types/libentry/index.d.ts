/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

declare namespace scsiNapi {
  type DeviceInfo = {
    devType: number;	// 设备类型，例如：spc、sbc、mmc
    vendor: string;		// 厂商标识
    product: string;	// 产品标识
    revision: string;	// 产品版本
    originData: string; // inqiry命令查询的原始数据
  };
  function scsiInit(deviceId:number): number;                                                               // 初始化ddk并打开设备文件
  function inquiry(deviceId:number): [DeviceInfo, number];                                                  // 读取设备的基本信息
  function readCapacity(deviceId:number, blockAddr: number): [number, number, number];                      // 读取设备容量，返回最后一个逻辑块地址，单个逻辑块大小
  function testUnitReady(deviceId:number): number;                                                          // 检测某个逻辑单元是否准备好
  function requestSense(deviceId:number): [string, string, number];                                         // 检测上次命令的执行状态
  function readBlocksData(deviceId:number, blockAddr:number, blockNum:number): [string, number];            // 读取指定范围的块数据，参数是起始块和块数量
  function writeBlocksData(deviceId:number, blockAddr:number, blockNum:number, data:string): number;        // 修改指定范围的块数据，参数是起始块和块数量
  function verifyBlocksData(deviceId:number, blockAddr:number, blockNum:number): number;                    // 校验指定范围的块数据，参数是起始块和块数量
  function sendCDBData(deviceId:number, cmdData:number[], cmdLen:number, direction:number, extraData:string): [string, number]; // 发送通用命令，发送内容为CDB数据和额外需要写的数据，返回响应内容
  function releaseResource(): void;                                                                         // 释放资源
}
export default scsiNapi;