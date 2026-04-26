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
import Log from '@ohos/common/src/main/ets/default/Log';
import getSingleInstance, { getAudioManager
} from '@ohos/common/src/main/ets/default/SingleInstanceHelper';
import { AudioVolumeType, VolumeInfo } from '../common/Constants';

const TAG = 'VolumePanelModel';

/** Event payload for AudioManager 'volumeChange'. */
interface AudioVolumeChangePayload {
  volumeType: audio.AudioVolumeType;
  volume: number;
  updateUi: boolean;
}

export interface VolumeListener {
  updateVolumeInfo(status: VolumeInfo): void;
}

export interface VolumeCallQueueItemData {
  interfaceName: InterfaceName;
  streamType: number;
  volumeLevel?: number;
  muteFlag?: boolean;
  callbackFunction(err: BusinessError, data?: boolean | number): void;
}

enum InterfaceName {
  isMute,
  mute,
  getVolume,
  setVolume
}

class VolumeCallQueueItem implements VolumeCallQueueItemData {
  public interfaceName: InterfaceName;
  public streamType: number;
  public volumeLevel?: number;
  public muteFlag?: boolean;
  public callbackFunction: (err: BusinessError, data?: boolean | number) => void;

  constructor(
    interfaceName: InterfaceName,
    streamType: number,
    callbackFunction: (err: BusinessError, data?: boolean | number) => void,
    volumeLevel?: number,
    muteFlag?: boolean
  ) {
    this.interfaceName = interfaceName;
    this.streamType = streamType;
    this.callbackFunction = callbackFunction;
    if (volumeLevel !== undefined) {
      this.volumeLevel = volumeLevel;
    }
    if (muteFlag !== undefined) {
      this.muteFlag = muteFlag;
    }
  }
}

export class VolumePanelService {
  public mIsStart = false;
  public mListeners = new Set<VolumeListener>();
  public mAudioManager = getAudioManager();
  public mInterfaceCallQueue: VolumeCallQueueItemData[] = [];

  constructor() {
    Log.showInfo(TAG, 'constructor');
  }

  startService(): void {
    if (this.mIsStart) {
      return;
    }
    this.mIsStart = true;
    Log.showInfo(TAG, 'startService');
    try {
      this.mAudioManager.on('volumeChange', this.onVolumeChange.bind(this));
    } catch (err) {
      Log.showError(TAG, 'on volumeChange, err ' + JSON.stringify(err));
    }
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

  onVolumeChange(data: AudioVolumeChangePayload): void {
    Log.showInfo(TAG, `音量加减`);
    Log.showInfo(TAG, 'onVolumeChange');
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
    const item: VolumeCallQueueItem = new VolumeCallQueueItem(
      InterfaceName.isMute,
      interfaceVolumeType,
      (err: BusinessError, data?: boolean | number): void => {
        Log.showInfo(TAG, `isMute, err: ${err} data: ${JSON.stringify(data)}`);
        if (err) {
          return;
        }
        if (typeof data === 'boolean') {
          callback(volumeType, data);
        }
      }
    );
    this.addInterfaceCallQueue(item);
  }

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
    const item: VolumeCallQueueItem = new VolumeCallQueueItem(
      InterfaceName.getVolume,
      interfaceVolumeType,
      (err: BusinessError, data?: boolean | number): void => {
        Log.showInfo(TAG, `getVolume, err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
        if (err) {
          return;
        }
        if (typeof data === 'number') {
          callback(volumeType, data);
        }
      }
    );
    this.addInterfaceCallQueue(item);
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
    const item: VolumeCallQueueItem = new VolumeCallQueueItem(
      InterfaceName.setVolume,
      interfaceVolumeType,
      (err: BusinessError, _data?: boolean | number): void => {
        Log.showInfo(TAG, `setVolume, callback err: ${err} `);
        if (err) {
          return;
        }
        if (callback) {
          callback();
        }
      },
      volume,
      undefined
    );
    this.addInterfaceCallQueue(item);
  }

  setMute(volumeType: AudioVolumeType, mute: boolean, callback?: () => void): void {
    Log.showInfo(TAG, `setMute, volumeType: ${volumeType} mute: ${mute}`);
    let interfaceVolumeType = this.formatAudioVolumeTypeToInterface(volumeType);
    const item: VolumeCallQueueItem = new VolumeCallQueueItem(
      InterfaceName.mute,
      interfaceVolumeType,
      (err: BusinessError, _data?: boolean | number): void => {
        Log.showInfo(TAG, `setMute, err: ${JSON.stringify(err)}`);
        if (err) {
          return;
        }
        this.getVolumeInfo(volumeType, (volumeInfo: VolumeInfo) => {
          Log.showInfo(TAG, `setMute, volumeInfo: ${JSON.stringify(volumeInfo)}`);
          if (callback) {
            callback();
          }
        });
      },
      undefined,
      mute
    );
    this.addInterfaceCallQueue(item);
  }

  formatAudioVolumeTypeFromInterface(audioVolumeType: audio.AudioVolumeType): AudioVolumeType {
    if (audioVolumeType === audio.AudioVolumeType.VOICE_CALL) {
      return AudioVolumeType.VOICE_CALL;
    }
    if (audioVolumeType === audio.AudioVolumeType.RINGTONE) {
      return AudioVolumeType.RINGTONE;
    }
    if (audioVolumeType === audio.AudioVolumeType.MEDIA) {
      return AudioVolumeType.MEDIA;
    }
    if (audioVolumeType === audio.AudioVolumeType.VOICE_ASSISTANT) {
      return AudioVolumeType.VOICE_ASSISTANT;
    }
    return AudioVolumeType.MEDIA;
  }

  formatAudioVolumeTypeToInterface(audioVolumeType: AudioVolumeType): audio.AudioVolumeType {
    if (audioVolumeType === AudioVolumeType.VOICE_CALL) {
      return audio.AudioVolumeType.VOICE_CALL;
    }
    if (audioVolumeType === AudioVolumeType.RINGTONE) {
      return audio.AudioVolumeType.RINGTONE;
    }
    if (audioVolumeType === AudioVolumeType.MEDIA) {
      return audio.AudioVolumeType.MEDIA;
    }
    if (audioVolumeType === AudioVolumeType.VOICE_ASSISTANT) {
      return audio.AudioVolumeType.VOICE_ASSISTANT;
    }
    return audio.AudioVolumeType.MEDIA;
  }

  private peekQueueHead(): VolumeCallQueueItemData | undefined {
    for (const item of this.mInterfaceCallQueue) {
      return item;
    }
    return undefined;
  }

  addInterfaceCallQueue(data: VolumeCallQueueItemData): void {
    Log.showDebug(TAG,
      `addInterfaceCallQueue, interfaceName: ${data.interfaceName} streamType: ${data.streamType}`);
    this.mInterfaceCallQueue.push(data);
    if (this.mInterfaceCallQueue.length === 1) {
      this.execInterfaceCallQueueFirst();
    }
  }

  execInterfaceCallQueueFirst(): void {
    Log.showInfo(TAG, `execInterfaceCallQueueFirst, ${this.mInterfaceCallQueue.length}`);
    const head = this.peekQueueHead();
    if (head === undefined) {
      return;
    }
    const queueData: VolumeCallQueueItemData = head;
    if (queueData.interfaceName === InterfaceName.isMute) {
      this.mAudioManager.isMute(queueData.streamType, (err: BusinessError, data: boolean) => {
        Log.showInfo(TAG, 'execInterfaceCallQueueFirst, isMute callback');
        this.execInterfaceCallQueueNext().then(() => {
        }).catch((_e: Error) => {
        });
        queueData.callbackFunction(err, data);
      });
    } else if (queueData.interfaceName === InterfaceName.mute) {
      const muteVal: boolean | undefined = queueData.muteFlag;
      if (muteVal === undefined) {
        Log.showError(TAG, 'mute queue item missing muteFlag');
        return;
      }
      this.mAudioManager.mute(queueData.streamType, muteVal, (err: BusinessError) => {
        Log.showInfo(TAG, 'execInterfaceCallQueueFirst, mute callback');
        this.execInterfaceCallQueueNext().then(() => {
        }).catch((_e: Error) => {
        });
        queueData.callbackFunction(err);
      });
    } else if (queueData.interfaceName === InterfaceName.getVolume) {
      this.mAudioManager.getVolume(queueData.streamType, (err: BusinessError, data: number) => {
        Log.showInfo(TAG, 'execInterfaceCallQueueFirst, getVolume callback');
        this.execInterfaceCallQueueNext().then(() => {
        }).catch((_e: Error) => {
        });
        queueData.callbackFunction(err, data);
      });
    } else if (queueData.interfaceName === InterfaceName.setVolume) {
      const level: number | undefined = queueData.volumeLevel;
      if (level === undefined) {
        Log.showError(TAG, 'setVolume queue item missing volumeLevel');
        return;
      }
      this.mAudioManager.setVolume(queueData.streamType, level, (err: BusinessError) => {
        Log.showInfo(TAG, 'execInterfaceCallQueueFirst, setVolume callback');
        this.execInterfaceCallQueueNext().then(() => {
        }).catch((_e: Error) => {
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

let volumePanelService: VolumePanelService = getSingleInstance((): VolumePanelService => new VolumePanelService(), TAG);

export default volumePanelService;
