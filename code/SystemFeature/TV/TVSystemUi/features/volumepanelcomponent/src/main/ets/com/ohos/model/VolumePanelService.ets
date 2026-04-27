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
 

import { audio } from '@kit.AudioKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Log from '../../../../../../../../common/src/main/ets/default/Log';
import getSingleInstance, { getAudioManager
} from '../../../../../../../../common/src/main/ets/default/SingleInstanceHelper';
import { AudioVolumeType, VolumeInfo } from '../common/Constants';

const TAG = 'VolumePanelModel';

export interface VolumeListener {
  updateVolumeInfo(status: VolumeInfo): void;
}

export interface VolumeCallQueueItemData {
  interfaceName: InterfaceName,
  params: boolean | number[],

  callbackFunction(err: BusinessError, data?: boolean | number): void;
}

enum InterfaceName {
  isMute,
  mute,
  getVolume,
  setVolume
}

// VolumePanelService 是音量面板的数据层，封装对系统 AudioManager 的所有读写调用。
// 采用观察者模式（VolumeListener）将音量变化推送给上层 ViewModel，
// 保证 UI 层与系统音频 API 完全解耦，便于单独测试和替换底层实现。

export class VolumePanelService {
  public mIsStart = false;
  public mListeners = new Set<VolumeListener>();
  public private mAudioManager = getAudioManager();
  // 串行调用队列：AudioManager 的 callback 风格 API 不支持并发调用同一类型接口，
  // 用队列保证 isMute/setVolume 等操作严格按序执行，避免回调顺序错乱导致音量状态不一致。
  public private mInterfaceCallQueue: VolumeCallQueueItemData[] = [] ;

  constructor() {
    Log.showInfo(TAG, 'constructor');
  }

  startService(): void {
    if (this.mIsStart) {
      return;
    }
    this.mIsStart = true;
    Log.showInfo(TAG, 'startService');
    // 注册系统音量变化监听，而非轮询，是为了保证 TV 遥控器物理音量键触发时
    // UI 能实时响应而不引入额外延迟或 CPU 占用。
    this.mAudioManager.on('volumeChange', this.onVolumeChange.bind(this));
  }

  stopService(): void {
    if (!this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, 'stopService');
    this.mIsStart = false;
  }

  registerListener(listener: VolumeListener): void {
    let res = this.mListeners.add(listener);
    Log.showInfo(TAG, `registser VolumeListener ${res}`);
  }

  unregisterListener(listener: VolumeListener): void {
    let res = this.mListeners.delete(listener);
    Log.showInfo(TAG, `unregistser VolumeListener ${res}`);
  }

  // 音量变化事件回调：系统上报的 volumeType 是平台内部枚举，需转换为业务侧枚举后
  // 再查询静音状态，两者合并成完整 VolumeInfo 才能驱动 UI 正确展示图标和滑块位置。
  async onVolumeChange(data): Promise<void> {
    Log.showInfo(TAG, `音量加减`);
    Log.showInfo(TAG, 'onVolumeChange');
    // 判断是否是语音电话/铃声/媒体/闹钟/无障碍/语音助手类型
    let volumeType = this.formatAudioVolumeTypeFromInterface(data.volumeType);
    this.isMute(volumeType, (volumeType2: AudioVolumeType, data2: boolean) => {
      Log.showInfo(TAG, `onVolumeChange->isMute, volumeType2: ${volumeType2} data2: ${String(data2)}`);
      let volumeInfo: VolumeInfo = {
        volumeType: volumeType,
        volume: data.volume,
        isMute: data2,
        updateUi: data.updateUi
      };
      this.mListeners.forEach(listener => listener.updateVolumeInfo(volumeInfo));
    });
  }

  isMute(volumeType: AudioVolumeType, callback: (volumeType: AudioVolumeType, data: boolean) => void): void {
    Log.showInfo(TAG, `isMute, volumeType: ${volumeType}`);
    let interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
    this.addInterfaceCallQueue({
      interfaceName: InterfaceName.isMute,
      params: [interfaceVolumeType],
      callbackFunction: (err, data: boolean) => {
        Log.showInfo(TAG, `isMute, err: ${err} data: ${JSON.stringify(data)}`);
        if (err) {
          return;
        }
        callback(volumeType, data);
      }
    });
  }

  // getVolumeInfo 是初始化和静音切换后的完整状态同步入口：
  // 先拉取音量值再查静音标志，确保 UI 显示的音量和静音图标始终来自同一时刻的系统快照。
  getVolumeInfo(volumeType: AudioVolumeType, callback?: (volumeInfo: VolumeInfo) => void): void {
    Log.showInfo(TAG, `getVolumeInfo, volumeType: ${volumeType}`);
    this.getVolume(volumeType, (volumeType: AudioVolumeType, data: number) => {
      Log.showInfo(TAG, `getVolumeInfo->getVolume`);
      this.isMute(volumeType, (volumeType2: AudioVolumeType, data2: boolean) => {
        Log.showInfo(TAG, `getVolumeInfo->isMute`);
        let volumeInfo: VolumeInfo = {
          volumeType: volumeType,
          volume: data,
          isMute: data2,
          updateUi: false
        };
        this.mListeners.forEach(listener => listener.updateVolumeInfo(volumeInfo));
        if (callback) {
          callback(volumeInfo);
        }
      });
    });
  }

  isActive(volumeType: AudioVolumeType, callback: (volumeType: AudioVolumeType, data: boolean) => void): void {
    Log.showInfo(TAG, `isActive, volumeType: ${volumeType}`);
    let interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
    this.mAudioManager.isActive(interfaceVolumeType, (err: BusinessError, data: boolean) => {
      Log.showInfo(TAG, `isActive, err: ${err} data: ${JSON.stringify(data)}`);
      if (err) {
        return;
      }
      callback(volumeType, data);
    });
  }

  getVolume(volumeType: AudioVolumeType, callback: (volumeType: AudioVolumeType, data: number) => void): void {
    Log.showInfo(TAG, `getVolume, volumeType: ${volumeType}`);
    let interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
    this.addInterfaceCallQueue({
      interfaceName: InterfaceName.getVolume,
      params: [interfaceVolumeType],
      callbackFunction: (err: BusinessError, data: number) => {
        Log.showInfo(TAG, `getVolume, err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
        if (err) {
          return;
        }
        callback(volumeType, data);
      }
    });
  }

  getMaxVolume(volumeType: AudioVolumeType, callback: (volumeType: AudioVolumeType, data: number) => void): void {
    Log.showInfo(TAG, `getMaxVolume, volumeType: ${volumeType}`);
    let interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
    this.mAudioManager.getMaxVolume(interfaceVolumeType, (err: BusinessError, data: number) => {
      Log.showInfo(TAG, `getMaxVolume, err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
      if (err) {
        return;
      }
      callback(volumeType, data);
    });
  }

  getMinVolume(volumeType: AudioVolumeType, callback: (volumeType: AudioVolumeType, data: number) => void): void {
    Log.showInfo(TAG, `getMinVolume, volumeType: ${volumeType}`);
    let interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
    this.mAudioManager.getMinVolume(interfaceVolumeType, (err: BusinessError, data: number) => {
      Log.showInfo(TAG, `getMinVolume, err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
      if (err) {
        return;
      }
      callback(volumeType, data);
    });
  }

  // setVolumeAndMute 是用户拖拽滑块或点击静音键的统一入口。
  // 之所以将 setVolume 和 setMute 合并为一次调用，是因为 TV 遥控器场景下
  // 用户期望"拖到最低即静音"的原子行为，分两步调用会导致中间态短暂播放声音。
  setVolumeAndMute(volumeType: AudioVolumeType, volume: number, mute: boolean, callback?: () => void): void {
    Log.showInfo(TAG, `setVolumeAndMute, volumeType: ${volumeType} volume: ${volume} mute: ${mute}`);
    if (volume !== undefined && mute !== undefined) {
      this.setVolume(volumeType, volume, () => {
        Log.showInfo(TAG, `setVolume`);
        this.setMute(volumeType, mute, callback);
      });
    } else if (volume !== undefined) {
      this.setVolume(volumeType, volume);
    } else if (mute !== undefined) {
      this.setMute(volumeType, mute, callback);
    }
  }

  setVolume(volumeType: AudioVolumeType, volume: number, callback?: () => void): void {
    Log.showInfo(TAG, `setVolume, volumeType: ${volumeType} volume: ${volume}`);
    let interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
    this.addInterfaceCallQueue({
      interfaceName: InterfaceName.setVolume,
      params: [interfaceVolumeType, volume],
      callbackFunction: (err: BusinessError) => {
        Log.showInfo(TAG, `setVolume, callback err: ${err} `);
        if (err) {
          return;
        }
        if (callback) {
          callback();
        }
      }
    });
  }

  setMute(volumeType: AudioVolumeType, mute: boolean, callback?: () => void): void {
    Log.showInfo(TAG, `setMute, volumeType: ${volumeType} mute: ${mute}`);
    let interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
    this.addInterfaceCallQueue({
      interfaceName: InterfaceName.mute,
      params: [interfaceVolumeType, mute],
      callbackFunction: (err: BusinessError) => {
        Log.showInfo(TAG, `setMute, err: ${JSON.stringify(err)}`);
        if (err) {
          return;
        }
        // 静音完成后主动拉取一次完整音量状态，确保所有 Listener 收到的静音后信息一致，
        // 防止因系统事件延迟到达导致 UI 与实际静音状态短暂不同步。
        this.getVolumeInfo(volumeType, (volumeInfo: VolumeInfo) => {
          Log.showInfo(TAG, `setMute, volumeInfo: ${JSON.stringify(volumeInfo)}`);
          if (callback) {
            callback();
          }
        });
      }
    });
  }

  formatAudioVolumeTypeFromInterface(audioVolumeType): AudioVolumeType {
    let formatValue: AudioVolumeType;
    if (audioVolumeType == audio.AudioVolumeType.VOICE_CALL) {
      formatValue = AudioVolumeType.VOICE_CALL;
    } else if (audioVolumeType == audio.AudioVolumeType.RINGTONE) {
      formatValue = AudioVolumeType.RINGTONE;
    } else if (audioVolumeType == audio.AudioVolumeType.MEDIA) {
      formatValue = AudioVolumeType.MEDIA;
    } else if (audioVolumeType == audio.AudioVolumeType.VOICE_ASSISTANT) {
      formatValue = AudioVolumeType.VOICE_ASSISTANT;
    }
    return formatValue;
  }

  formatAudioVolumeTypeToInterface(audioVolumeType: AudioVolumeType) {
    let formatValue;
    if (audioVolumeType == AudioVolumeType.VOICE_CALL) {
      formatValue = audio.AudioVolumeType.VOICE_CALL;
    } else if (audioVolumeType == AudioVolumeType.RINGTONE) {
      formatValue = audio.AudioVolumeType.RINGTONE;
    } else if (audioVolumeType == AudioVolumeType.MEDIA) {
      formatValue = audio.AudioVolumeType.MEDIA;
    } else if (audioVolumeType == AudioVolumeType.VOICE_ASSISTANT) {
      formatValue = audio.AudioVolumeType.VOICE_ASSISTANT;
    }
    return formatValue;
  }

  // 串行队列的入队逻辑：只有队列为空时才立即执行，否则仅入队等待前序任务回调后驱动。
  // 这是因为 HarmonyOS AudioManager callback 接口不可重入，并发调用会导致结果顺序不可预测。
  addInterfaceCallQueue(data: VolumeCallQueueItemData): void {
    Log.showDebug(TAG, `addInterfaceCallQueue, interfaceName: ${data.interfaceName} params: ${JSON.stringify(data.params)}`);
    this.mInterfaceCallQueue.push(data);
    if (this.mInterfaceCallQueue.length == 1) {
      this.execInterfaceCallQueueFirst();
    }
  }

  execInterfaceCallQueueFirst(): void {
    Log.showInfo(TAG, `execInterfaceCallQueueFirst, ${this.mInterfaceCallQueue.length}`);
    let queueData = this.mInterfaceCallQueue[0];
    if (queueData.interfaceName == InterfaceName.isMute) {
      this.mAudioManager.isMute(queueData.params[0], (err: BusinessError, data: boolean) => {
        Log.showInfo(TAG, 'execInterfaceCallQueueFirst, isMute callback');
        this.execInterfaceCallQueueNext().then(() => {
        }).catch((e) => {
        });
        queueData.callbackFunction(err, data);
      });
    } else if (queueData.interfaceName == InterfaceName.mute) {
      this.mAudioManager.mute(queueData.params[0], queueData.params[1], (err: BusinessError) => {
        Log.showInfo(TAG, 'execInterfaceCallQueueFirst, mute callback');
        this.execInterfaceCallQueueNext().then(() => {
        }).catch((e) => {
        });
        queueData.callbackFunction(err);
      });
    } else if (queueData.interfaceName == InterfaceName.getVolume) {
      this.mAudioManager.getVolume(queueData.params[0], (err: BusinessError, data: number) => {
        Log.showInfo(TAG, 'execInterfaceCallQueueFirst, getVolume callback');
        this.execInterfaceCallQueueNext().then(() => {
        }).catch((e) => {
        });
        queueData.callbackFunction(err, data);
      });
    } else if (queueData.interfaceName == InterfaceName.setVolume) {
      this.mAudioManager.setVolume(queueData.params[0], queueData.params[1], (err: BusinessError) => {
        Log.showInfo(TAG, 'execInterfaceCallQueueFirst, setVolume callback');
        this.execInterfaceCallQueueNext().then(() => {
        }).catch((e) => {
        });
        queueData.callbackFunction(err);
      });
    }
  }

  async execInterfaceCallQueueNext(): Promise<void> {
    Log.showInfo(TAG, `execInterfaceCallQueueNext, ${this.mInterfaceCallQueue.length}`);
    this.mInterfaceCallQueue.splice(0, 1);
    if (this.mInterfaceCallQueue.length > 0) {
      this.execInterfaceCallQueueFirst();
    }
  }
}

let volumePanelService = getSingleInstance(VolumePanelService, TAG);

export default volumePanelService;
