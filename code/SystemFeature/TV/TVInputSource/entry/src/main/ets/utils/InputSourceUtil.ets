/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { TimingInfoEntity } from '../entity/TimingInfoEntity';
import { SourceManager } from '../manager/SourceManager';
import displaySetting from '@ohos.tvservice.displaySetting';

/**
 * 输入源工具类
 */
export class InputSourceUtil {
  /**
   * 获取信号源详细信息
   */
  public static getSourceInfo(sourceId: number): string {
    let sourceName: string = InputSourceUtil.getSourceName(sourceId);
    let timingInfo: TimingInfoEntity = SourceManager.getTimingInfo();
    let height: number = timingInfo.getHeight() ? timingInfo.getHeight() : 1080;
    let frame: number = timingInfo.getFrameRate() ? timingInfo.getFrameRate() : 60;
    if (timingInfo.getIsInterlace()) {
      sourceName + ' ' + height + 'I' + '@' + frame + 'Hz';
    }
    return sourceName + ' ' + height + 'P' + '@' + frame + 'Hz';
  }

  /**
   * 获取信号源名称
   */
  public static getSourceName(sourceId: number): string {
    // return CommonUtil.getString(InputSourceUtil.getSourceNameById(sourceId))
    return InputSourceUtil.getSourceNameById(sourceId);
  }

  /**
   * 根据信号源获取信号资源
   */
  public static getSourceNameById(id: number): string {
    switch (id) {
      case 0:
        return 'MEDIA';
      case 1:
        return 'HDMI1';
      case 2:
        return 'HDMI2';
      case 3:
        return 'HDMI3';
      case 4:
        return 'HDMI4';
      case 5:
        return 'AV';
      case 6:
      case 7:
      case 8:
        return 'DTV';
      case 9:
        // 投屏
      case 10:
        return 'VGA';
        // 图形输入
      case 11:
        // 流媒体
      default:
        break;
    }
    return 'HDMI1';
  }

  /**
   * 选择信号源
   */
  public static selectSource(sourceId: number, callback: () => void) {
    displaySetting.selectSource(sourceId, (e: Error, ret: boolean) => {
      if (!e) {
        callback()
      } else {

      }
    });
  }

  /**
   * 释放信号源
   */
  public static async deSelectSource(sourceId: number) {
    await displaySetting.deselectSource(sourceId);
  }

  /**
   * 信号源是否可用（接口只能查当前源）
   */
  public static async isSourceAvailable(): Promise<boolean> {
    let isAvailable: boolean = false;
    try {
      let curSignalStatus: displaySetting.SignalStatus = await displaySetting.getSignalStatus();
      return curSignalStatus === displaySetting.SignalStatus.SIGNAL_SUPPORT;
    } catch (err) {
      return isAvailable;
    }
  }

  /**
   * 注册信号状态监听器（接口只支持当前源）
   */
  public static registerSignalListener(callback: (signalStatus: displaySetting.SignalStatus) => void): void {
    try {
      displaySetting.on('signalStatusChange', (sourceSignal: displaySetting.SourceSignal) => {
        console.log('signalStatusChange sourceSignal --- ' + JSON.stringify(sourceSignal));
        callback(sourceSignal.status);
      });
    } catch (err) {
      console.error('registerSignalListener err', JSON.stringify(err));
    }
  }

  /**
   * 注销状态信号监听器
   */
  public static unregisterSignalListener(): void {
    try {
      displaySetting.off('signalStatusChange', () => {
      });
    } catch (err) {
      console.error('unregisterSignalListener err', JSON.stringify(err));
    }
  }

  /**
   * 获取信号源图标
   */
  public static getSourceIcon(sourceId: number, isFocus: boolean): Resource {
    switch (sourceId) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
        return isFocus ? $r('app.media.HDMI_focus') : $r('app.media.HDMI');
      case 5:
        return isFocus ? $r('app.media.AV_focus') : $r('app.media.AV');
      case 6:
      case 7:
      case 8:
        return isFocus ? $r('app.media.DTV_focus') : $r('app.media.DTV');
      case 9:
        // 投屏
      case 10:
        // 图形输入
      case 11:
        // 流媒体
      default:
        break;
    }
    return isFocus ? $r('app.media.HDMI_focus') : $r('app.media.HDMI');
  }
}
