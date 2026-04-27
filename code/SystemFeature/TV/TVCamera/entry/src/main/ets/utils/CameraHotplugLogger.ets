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
 
import { hilog } from '@kit.PerformanceAnalysisKit';
import Logger from './Logger';
import { camera } from '@kit.CameraKit';

/**
 * 摄像头热插拔专用日志工具类
 * 提供统一的日志格式和详细的摄像头信息记录
 */
export class CameraHotplugLogger {
  private static readonly DOMAIN = 0x0000;
  private static readonly TAG_PREFIX = 'CAMERA_HOTPLUG';
  
  /**
   * 获取当前时间戳字符串
   */
  private static getTimestamp(): string {
    const now = new Date();
    return now.toISOString().replace('T', ' ').substring(0, 23);
  }
  
  /**
   * 获取摄像头详细信息字符串
   */
  private static getCameraInfo(cameraId: string, cameraDevice?: camera.CameraDevice): string {
    if (!cameraDevice) {
      return `[ID:${cameraId}]`;
    }
    
    const connectionTypeMap = new Map([
      [0, 'LOCAL'],    // 本地相机
      [1, 'USB'],      // USB相机
      [2, 'REMOTE']    // 远程相机
    ]);
    
    const positionMap = new Map([
      [0, 'UNSPECIFIED'],
      [1, 'BACK'],
      [2, 'FRONT']
    ]);
    
    const typeMap = new Map([
      [0, 'UNSPECIFIED'],
      [1, 'WIDE_ANGLE'],
      [2, 'ULTRA_WIDE'],
      [3, 'TELEPHOTO'],
      [4, 'TRUE_DEPTH']
    ]);
    
    const connectionType = connectionTypeMap.get(cameraDevice.connectionType) || 'UNKNOWN';
    const position = positionMap.get(cameraDevice.cameraPosition) || 'UNKNOWN';
    const type = typeMap.get(cameraDevice.cameraType) || 'UNKNOWN';
    
    return `[ID:${cameraId}|TYPE:${connectionType}|POS:${position}|CAM:${type}]`;
  }
  
  /**
   * 记录摄像头连接事件
   */
  static logCameraConnected(page: string, cameraId: string, cameraDevice?: camera.CameraDevice) {
    const timestamp = CameraHotplugLogger.getTimestamp();
    const cameraInfo = CameraHotplugLogger.getCameraInfo(cameraId, cameraDevice);
    const message = `${timestamp} [${page}] CAMERA_CONNECTED ${cameraInfo}`;
    
    hilog.info(CameraHotplugLogger.DOMAIN, `${CameraHotplugLogger.TAG_PREFIX}_CONNECT`, message);
    Logger.info(`${CameraHotplugLogger.TAG_PREFIX}_CONNECT`, message);
  }
  
  /**
   * 记录摄像头断开事件
   */
  static logCameraDisconnected(page: string, cameraId: string, cameraDevice?: camera.CameraDevice) {
    const timestamp = CameraHotplugLogger.getTimestamp();
    const cameraInfo = CameraHotplugLogger.getCameraInfo(cameraId, cameraDevice);
    const message = `${timestamp} [${page}] CAMERA_DISCONNECTED ${cameraInfo}`;
    
    hilog.info(CameraHotplugLogger.DOMAIN, `${CameraHotplugLogger.TAG_PREFIX}_DISCONNECT`, message);
    Logger.info(`${CameraHotplugLogger.TAG_PREFIX}_DISCONNECT`, message);
  }
  
  /**
   * 记录摄像头切换事件
   */
  static logCameraSwitched(page: string, fromCameraId: string, toCameraId: string, reason: string) {
    const timestamp = CameraHotplugLogger.getTimestamp();
    const message = `${timestamp} [${page}] CAMERA_SWITCHED FROM:${fromCameraId} TO:${toCameraId} REASON:${reason}`;
    
    hilog.info(CameraHotplugLogger.DOMAIN, `${CameraHotplugLogger.TAG_PREFIX}_SWITCH`, message);
    Logger.info(`${CameraHotplugLogger.TAG_PREFIX}_SWITCH`, message);
  }
  
  /**
   * 记录摄像头列表更新事件
   */
  static logCameraListUpdated(page: string, oldCount: number, newCount: number, cameraIds: string[]) {
    const timestamp = CameraHotplugLogger.getTimestamp();
    const cameraList = cameraIds.join(',');
    const message = `${timestamp} [${page}] CAMERA_LIST_UPDATED COUNT:${oldCount}->${newCount} CAMERAS:[${cameraList}]`;
    
    hilog.info(CameraHotplugLogger.DOMAIN, `${CameraHotplugLogger.TAG_PREFIX}_LIST`, message);
    Logger.info(`${CameraHotplugLogger.TAG_PREFIX}_LIST`, message);
  }
  
  /**
   * 记录摄像头初始化事件
   */
  static logCameraInitialized(page: string, cameraId: string, surfaceId: string, success: boolean) {
    const timestamp = CameraHotplugLogger.getTimestamp();
    const status = success ? 'SUCCESS' : 'FAILED';
    const message = `${timestamp} [${page}] CAMERA_INIT ${status} ID:${cameraId} SURFACE:${surfaceId}`;
    
    hilog.info(CameraHotplugLogger.DOMAIN, `${CameraHotplugLogger.TAG_PREFIX}_INIT`, message);
    Logger.info(`${CameraHotplugLogger.TAG_PREFIX}_INIT`, message);
  }
  
  /**
   * 记录摄像头释放事件
   */
  static logCameraReleased(page: string, cameraId: string, reason: string) {
    const timestamp = CameraHotplugLogger.getTimestamp();
    const message = `${timestamp} [${page}] CAMERA_RELEASED ID:${cameraId} REASON:${reason}`;
    
    hilog.info(CameraHotplugLogger.DOMAIN, `${CameraHotplugLogger.TAG_PREFIX}_RELEASE`, message);
    Logger.info(`${CameraHotplugLogger.TAG_PREFIX}_RELEASE`, message);
  }
  
  /**
   * 记录摄像头状态变化事件
   */
  static logCameraStatusChange(page: string, cameraId: string, oldStatus: string, newStatus: string) {
    const timestamp = CameraHotplugLogger.getTimestamp();
    const message = `${timestamp} [${page}] CAMERA_STATUS_CHANGE ID:${cameraId} STATUS:${oldStatus}->${newStatus}`;
    
    hilog.info(CameraHotplugLogger.DOMAIN, `${CameraHotplugLogger.TAG_PREFIX}_STATUS`, message);
    Logger.info(`${CameraHotplugLogger.TAG_PREFIX}_STATUS`, message);
  }
  
  /**
   * 记录错误事件
   */
  static logError(page: string, operation: string, cameraId: string, error: string) {
    const timestamp = CameraHotplugLogger.getTimestamp();
    const message = `${timestamp} [${page}] CAMERA_ERROR OP:${operation} ID:${cameraId} ERROR:${error}`;
    
    hilog.error(CameraHotplugLogger.DOMAIN, `${CameraHotplugLogger.TAG_PREFIX}_ERROR`, message);
    Logger.error(`${CameraHotplugLogger.TAG_PREFIX}_ERROR`, message);
  }
  
  /**
   * 记录用户操作事件
   */
  static logUserAction(page: string, action: string, cameraId: string, details?: string) {
    const timestamp = CameraHotplugLogger.getTimestamp();
    const detailsStr = details ? ` DETAILS:${details}` : '';
    const message = `${timestamp} [${page}] USER_ACTION ACTION:${action} ID:${cameraId}${detailsStr}`;
    
    hilog.info(CameraHotplugLogger.DOMAIN, `${CameraHotplugLogger.TAG_PREFIX}_USER`, message);
    Logger.info(`${CameraHotplugLogger.TAG_PREFIX}_USER`, message);
  }
}
