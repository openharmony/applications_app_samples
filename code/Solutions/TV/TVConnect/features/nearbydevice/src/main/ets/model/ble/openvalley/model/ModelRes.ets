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
import { BaseModel, Channel, Func } from './BaseModel';

export enum ResultCode {

  /**
   * 成功
   */
  SUC = 0,
  /**
   * 通用错误
   */
  ERROR_GENERAL = SUC + 1,
  /**
   * ESB协议或命令不支持
   */
  ERROR_CMD_NOT_SUPPORT = ERROR_GENERAL + 1,
  /**
   * 参数无效/不合法
   */
  ERROR_PARAM_INVALID = ERROR_CMD_NOT_SUPPORT + 1,
  /**
   * 参数为空
   */
  ERROR_PARAM_NULL = ERROR_PARAM_INVALID + 1,
  /**
   * 内存错误
   */
  ERROR_MEMORY = ERROR_PARAM_NULL + 1,
  /**
   * 查询 ID 信息出错
   */
  ERROR_QUERY_ID = ERROR_MEMORY + 1,
  /**
   * 查询基本信息出错
   */
  ERROR_QUERY_BASE = ERROR_QUERY_ID + 1,
  /**
   * 查询蓝牙信息出错
   */
  ERROR_QUERY_BLE = ERROR_QUERY_BASE + 1,
  /**
   * 查询配置信息出错
   */
  ERROR_QUERY_CFG = ERROR_QUERY_BLE + 1,
  /**
   * 设置配置信息出错
   */
  ERROR_SET_CFG = ERROR_QUERY_CFG + 1,
  /**
   * 查询设备信息出错
   */
  ERROR_QUERY_DEV = ERROR_SET_CFG + 1,
  /**
   * 设置设备信息出错
   */
  ERROR_SET_DEV = ERROR_QUERY_DEV + 1,
  /**
   * 查询设备运行信息出错
   */
  ERROR_QUERY_RUN = ERROR_SET_DEV + 1,
  /**
   * 添加机电设备出错
   */
  ERROR_DEVICE_ADD = ERROR_QUERY_RUN + 1,
  /**
   * 更新机电设备出错
   */
  ERROR_DEVICE_UPDATE = ERROR_DEVICE_ADD + 1,
  /**
   * 删除机电设备出错
   */
  ERROR_DEVICE_DELETE = ERROR_DEVICE_UPDATE + 1,
  /**
   * 查询联动场景失败
   */
  ERROR_QUERY_SCENE = ERROR_DEVICE_DELETE + 1,
  /**
   * 添加联动场景失败
   */
  ERROR_ADD_SCENE = ERROR_QUERY_SCENE + 1,
  /**
   * 更新联动场景失败
   */
  ERROR_UPDATE_SCENE = ERROR_ADD_SCENE + 1,
  /**
   * 删除联动场景失败
   */
  ERROR_DELETE_SCENE = ERROR_UPDATE_SCENE + 1,
  /**
   * 执行联动场景失败
   */
  ERROR_EXECUTE_SCENE = ERROR_DELETE_SCENE + 1,

}

export abstract class ModelRes<T> extends BaseModel<T> {
  public result: ResultCode;

  constructor(result: ResultCode, localId: string, remoteId: string, channel: Channel, func: Func) {
    super(localId, remoteId, channel, func);
    this.result = result;
  }

  isSuc(): boolean {
    return this.result == ResultCode.SUC;
  }

  abstract isSelf(): boolean;

  getResultMessage(): string {
    switch (this.result) {
      case ResultCode.SUC:
        return '成功';
      case ResultCode.ERROR_GENERAL:
        return '通用错误';
      case ResultCode.ERROR_CMD_NOT_SUPPORT:
        return '命令不支持';
      case ResultCode.ERROR_PARAM_INVALID:
        return '参数无效';
      case ResultCode.ERROR_PARAM_NULL:
        return '参数为空';
      case ResultCode.ERROR_MEMORY:
        return '内存不足';
      case ResultCode.ERROR_QUERY_ID:
        return '查询ID错误';
      case ResultCode.ERROR_QUERY_BASE:
        return '查询基本信息出错';
      case ResultCode.ERROR_QUERY_BLE:
        return '查询蓝牙信息出错';
      case ResultCode.ERROR_QUERY_CFG:
        return '查询配置信息出错';
      case ResultCode.ERROR_SET_CFG:
        return '设置配置信息出错';
      case ResultCode.ERROR_QUERY_DEV:
        return '查询设备信息出错';
      case ResultCode.ERROR_SET_DEV:
        return '设置设备信息出错';
      case ResultCode.ERROR_QUERY_RUN:
        return '查询运行信息出错';
      case ResultCode.ERROR_DEVICE_ADD:
        return '添加设备出错';
      case ResultCode.ERROR_DEVICE_UPDATE:
        return '更新设备出错';
      case ResultCode.ERROR_DEVICE_DELETE:
        return '删除设备出错';
      case ResultCode.ERROR_QUERY_SCENE:
        return '查询联动场景失败';
      case ResultCode.ERROR_ADD_SCENE:
        return '添加联动场景失败';
      case ResultCode.ERROR_UPDATE_SCENE:
        return '更新联动场景失败';
      case ResultCode.ERROR_DELETE_SCENE:
        return '删除联动场景失败';
      case ResultCode.ERROR_EXECUTE_SCENE:
        return '联动场景执行出错';
    }
    return '未知错误';
  }
}