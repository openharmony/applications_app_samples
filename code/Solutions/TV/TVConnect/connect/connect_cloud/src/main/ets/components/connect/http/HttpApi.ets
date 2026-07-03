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

import {
  AddDeviceToProjectBody,
  DevVerifyCode,
  ProjectId,
  Project,
  ControlResult,
  VerifyCode,
  DevSnapshotMsg,
  DevicesRes,
  RequestBody,
  ProductProfile,
  ControlBody
} from './model/ProjectDeviceModel';
import { HttpRequest, Logger } from '@ohos/common';

export class HttpApi {
  private static httpApi: HttpApi = new HttpApi();

  public static getInstance(): HttpApi {
    return HttpApi.httpApi;
  }

  async getAllProject(): Promise<Array<Project>> {
    return HttpRequest.get<Array<Project>>('/device_cloud/app/project/list');
  }

  async addProject(project: Project): Promise<boolean> {
    return HttpRequest.post<boolean>('/device_cloud/app/project/add', project);
  }

  async updateProject(project: Project): Promise<boolean> {
    return HttpRequest.post<boolean>('/device_cloud/app/project/edit', project);
  }

  async deleteProject(projectId: string): Promise<boolean> {
    let id: ProjectId = {
      id: projectId
    };
    return HttpRequest.post<boolean>('/device_cloud/app/project/delete', id);
  }

  async getAllDevices(projectId: string): Promise<DevicesRes> {
    let content: Record<string, string> = {};
    content['projectId'] = projectId;
    return HttpRequest.post<DevicesRes>(`/device_cloud/app/projectdevice/list`, content);
  }

  async addDeviceToProject(addDeviceToProjectBody: AddDeviceToProjectBody): Promise<void> {
    return HttpRequest.post<void>(`/device_cloud/app/projectdevice/add`, addDeviceToProjectBody);
  }

  // 获取设备注册验证码
  async getDevVerifyCode(devVerifyCode: DevVerifyCode): Promise<VerifyCode> {
    return HttpRequest.post<VerifyCode>(`/device_cloud/iot/device/registryCode`, devVerifyCode);
  }

  // 获取设备激活状态
  async getDeviceIsActive(deviceId: string, projectId: string): Promise<string> {
    return HttpRequest.get<string>(`/project-management/projects/${projectId}/device/${deviceId}/active-status`);
  }

  async modifyDeviceName(deviceId: string, projectId: string, name: string): Promise<void> {
    let content: Record<string, string> = {};
    content['name'] = name;
    return HttpRequest.post<void>(`/project-management/projects/${projectId}/device/${deviceId}`, content);
  }

  async deleteDevice(deviceId: string, projectId: string): Promise<void> {
    return HttpRequest.get<void>(`/device_cloud/iot/device/${projectId}/${deviceId}/delete`);
  }

  async controlDevice(controlMsg: ControlBody): Promise<void> {
    Logger.info('HttpApi', `===>controlDevice controlMsg: ${JSON.stringify(controlMsg)}`);
    return HttpRequest.post<void>(`/device_cloud/iot/device/command`, controlMsg);
  }

  // 获取设备本地控制码
  async getLocalControlAuthCode(devicesArr: Array<string>): Promise<ControlResult> {
    return HttpRequest.post<ControlResult>(`/project-management/projects/{projectId}/devices/authcode`, devicesArr);
  }


  // 获取指定设备快照数据
  getDevSnapshotMsg(devid: string, projectId: string): Promise<DevSnapshotMsg> {
    let content: Record<string, string> = {};
    content['devid'] = devid;
    content['projectId'] = projectId;
    return HttpRequest.post<DevSnapshotMsg>(`/device_cloud/iot/device/shadow`, content);
  }

  // 获取指定设备所有快照数据
  getDevAllSnapshotMsg(devid: string, projectId: string) {
    Logger.info('HttpApi', `===>getDevAllSnapshotMsg devid: ${devid}, projectId:${projectId}`);
    let content: Record<string, string> = {};
    content['devid'] = devid;
    content['projectId'] = projectId;
    return HttpRequest.post<void>(`/device_cloud/iot/device/allShadow`, content);
  }

  // 获取设备物模型
  async getProductProfile(productId: string): Promise<ProductProfile> {
    return HttpRequest.get<ProductProfile>(`/device_cloud/product/downloadProfile?prodId=00002`);
  }
}