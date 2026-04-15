/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { promptAction } from '@kit.ArkUI';
import { camera } from '@kit.CameraKit';

/**
 * 摄像头热插拔提示信息管理类
 * 提供统一的用户提示信息和Toast显示
 */
export class CameraHotplugToast {
  /**
   * 统一显示普通提示信息。
   *
   * @param message 提示文案
   * @param duration 显示时长，单位毫秒
   * @returns void
   */
  static showToast(message: string, duration: number = 3000): void {
    promptAction.showToast({
      message: message,
      duration: duration,
    });
  }
  
  /**
   * 获取摄像头友好名称
   */
  private static getCameraFriendlyName(cameraId: string, cameraDevice?: camera.CameraDevice): string {
    if (!cameraDevice) {
      return `摄像头 ${cameraId.substring(0, 8)}`;
    }
    
    const connectionTypeMap = new Map([
      [0, '内置摄像头'],
      [1, 'USB摄像头'],
      [2, '远程摄像头']
    ]);
    
    const positionMap = new Map([
      [1, '后置'],
      [2, '前置']
    ]);
    
    const typeMap = new Map([
      [1, '广角'],
      [2, '超广角'],
      [3, '长焦'],
      [4, '深度']
    ]);
    
    const connectionType = connectionTypeMap.get(cameraDevice.connectionType) || '摄像头';
    const position = positionMap.get(cameraDevice.cameraPosition);
    const type = typeMap.get(cameraDevice.cameraType);
    
    let name = connectionType;
    if (position) {
      name += position;
    }
    if (type) {
      name += type;
    }
    
    return name;
  }
  
  /**
   * 显示摄像头连接提示
   */
  static showCameraConnected(cameraId: string, cameraDevice?: camera.CameraDevice, page: string = '') {
    const cameraName = CameraHotplugToast.getCameraFriendlyName(cameraId, cameraDevice);
    const pagePrefix = page ? `[${page}] ` : '';
    
    // 使用最新的API替代废弃的showToast方法
    promptAction.showToast({
      message: `${pagePrefix}检测到新设备: ${cameraName}`,
      duration: 3000,
    });
  }
  
  /**
   * 显示摄像头断开提示
   */
  static showCameraDisconnected(cameraId: string, cameraDevice?: camera.CameraDevice, page: string = '') {
    const cameraName = CameraHotplugToast.getCameraFriendlyName(cameraId, cameraDevice);
    const pagePrefix = page ? `[${page}] ` : '';
    
    // 使用最新的API替代废弃的showToast方法
    promptAction.showToast({
      message: `${pagePrefix}设备已断开: ${cameraName}`,
      duration: 3000,
    });
  }
  
  /**
   * 显示摄像头切换提示
   */
  static showCameraSwitched(fromCameraId: string, toCameraId: string, toCameraDevice?: camera.CameraDevice, page: string = '') {
    const toCameraName = CameraHotplugToast.getCameraFriendlyName(toCameraId, toCameraDevice);
    const pagePrefix = page ? `[${page}] ` : '';
    
    // 使用最新的API替代废弃的showToast方法
    promptAction.showToast({
      message: `${pagePrefix}已切换到: ${toCameraName}`,
      duration: 3000,
    });
  }
  
  /**
   * 显示无摄像头提示
   */
  static showNoCameraAvailable(page: string = '') {
    const pagePrefix = page ? `[${page}] ` : '';
    
    // 使用最新的API替代废弃的showToast方法
    promptAction.showToast({
      message: `${pagePrefix}请连接摄像头设备`,
      duration: 5000,
    });
  }
  
  /**
   * 显示摄像头重新连接提示
   */
  static showCameraReconnected(cameraId: string, cameraDevice?: camera.CameraDevice, page: string = '') {
    const cameraName = CameraHotplugToast.getCameraFriendlyName(cameraId, cameraDevice);
    const pagePrefix = page ? `[${page}] ` : '';
    
    // 使用最新的API替代废弃的showToast方法
    promptAction.showToast({
      message: `${pagePrefix}设备重新连接: ${cameraName}`,
      duration: 3000,
    });
  }
  
  /**
   * 显示多摄像头列表更新提示
   */
  static showCameraListUpdated(oldCount: number, newCount: number, page: string = '') {
    const pagePrefix = page ? `[${page}] ` : '';
    let message = '';
    
    if (newCount > oldCount) {
      const addedCount = newCount - oldCount;
      message = `${pagePrefix}新增 ${addedCount} 个摄像头设备 (总计: ${newCount})`;
    } else if (newCount < oldCount) {
      const removedCount = oldCount - newCount;
      message = `${pagePrefix}移除 ${removedCount} 个摄像头设备 (总计: ${newCount})`;
    } else {
      message = `${pagePrefix}摄像头列表已更新 (总计: ${newCount})`;
    }
    
    // 使用最新的API替代废弃的showToast方法
    promptAction.showToast({
      message: message,
      duration: 3000,
    });
  }
  
  /**
   * 显示摄像头初始化失败提示
   */
  static showCameraInitFailed(cameraId: string, cameraDevice?: camera.CameraDevice, page: string = '') {
    const cameraName = CameraHotplugToast.getCameraFriendlyName(cameraId, cameraDevice);
    const pagePrefix = page ? `[${page}] ` : '';
    
    // 使用最新的API替代废弃的showToast方法
    promptAction.showToast({
      message: `${pagePrefix}${cameraName} 初始化失败`,
      duration: 4000,
    });
  }
  
  /**
   * 显示录像中断提示
   */
  static showRecordingInterrupted(cameraId: string, cameraDevice?: camera.CameraDevice, page: string = '') {
    const cameraName = CameraHotplugToast.getCameraFriendlyName(cameraId, cameraDevice);
    const pagePrefix = page ? `[${page}] ` : '';
    
    // 使用最新的API替代废弃的showToast方法
    promptAction.showToast({
      message: `${pagePrefix}录像已中断: ${cameraName} 断开连接`,
      duration: 4000,
    });
  }
  
  /**
   * 显示拍照中断提示
   */
  static showPhotoInterrupted(cameraId: string, cameraDevice?: camera.CameraDevice, page: string = '') {
    const cameraName = CameraHotplugToast.getCameraFriendlyName(cameraId, cameraDevice);
    const pagePrefix = page ? `[${page}] ` : '';
    
    // 使用最新的API替代废弃的showToast方法
    promptAction.showToast({
      message: `${pagePrefix}拍照已中断: ${cameraName} 断开连接`,
      duration: 4000,
    });
  }
  
  /**
   * 显示摄像头权限提示
   */
  static showCameraPermissionRequired(page: string = '') {
    const pagePrefix = page ? `[${page}] ` : '';
    
    // 使用最新的API替代废弃的showToast方法
    promptAction.showToast({
      message: `${pagePrefix}需要摄像头权限才能使用此功能`,
      duration: 4000,
    });
  }
  
  /**
   * 显示摄像头忙碌提示
   */
  static showCameraBusy(cameraId: string, cameraDevice?: camera.CameraDevice, page: string = '') {
    const cameraName = CameraHotplugToast.getCameraFriendlyName(cameraId, cameraDevice);
    const pagePrefix = page ? `[${page}] ` : '';
    
    // 使用最新的API替代废弃的showToast方法
    promptAction.showToast({
      message: `${pagePrefix}${cameraName} 正在使用中`,
      duration: 3000,
    });
  }
}

export default CameraHotplugToast;
