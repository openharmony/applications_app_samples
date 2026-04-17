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
import { OnPositionChangedCallback } from './DlnaService';
import { OnPlayerErrorCallback } from './DlnaService';
import {
  OnPlayerStatusChangedCallback,
  OnVolumeChangedCallback,
  StatusCallback,
  PositionCallback,
  VolumeCallback
} from './DlnaService';
import DlnaService from './DlnaService';
import { rpc } from '@kit.IPCKit';
import { inputEventClient, KeyCode } from '@kit.InputKit';

type RemoteRequestCallback = (errCode: number, returnValue: number) => void;

export default class DlnaServiceStub extends rpc.RemoteObject implements DlnaService {
  public constructor(des: string) {
    super(des);
    this.surfaceId = ''
    this.position = 0
    this.duration = 0
    this.playerStatus = 0
    this.playFlag = true

  }

  public async onRemoteMessageRequest(
    code: number,
    data: rpc.MessageSequence,
    reply: rpc.MessageSequence,
    option: rpc.MessageOption
  ): Promise<boolean> {
    console.log('onRemoteMessageRequest called, code = ' + code);
    data.readInterfaceToken()
    switch (code) {
      case DlnaServiceStub.COMMAND_ON_POSITION_CHANGED: {
        let _position = data.readInt();
        let _duration = data.readInt();
        this.onPositionChanged(_position, _duration, (errCode: number, returnValue: number) => {
          reply.writeInt(errCode);
          if (errCode == 0) {
            reply.writeInt(returnValue);
          }
        });
        return true;
      }
      case DlnaServiceStub.COMMAND_ON_PLAYER_STATUS_CHANGED: {
        let _playerStatus = data.readInt();
        this.onPlayerStatusChanged(_playerStatus, (errCode: number, returnValue: number) => {
          reply.writeInt(errCode);
          if (errCode == 0) {
            reply.writeInt(returnValue);
          }
        });
        return true;
      }
      case DlnaServiceStub.COMMAND_ON_PLAYER_ERROR: {
        this.onPlayerError((errCode: number, returnValue: number) => {
          reply.writeInt(errCode);
          if (errCode == 0) {
            reply.writeInt(returnValue);
          }
        });
        return true;
      }
      case DlnaServiceStub.COMMAND_ON_VOLUNE_CHANGED: {
        let _volume = data.readInt();
        let _maxVolume = data.readInt();
        this.onVolumeChanged(_volume, _maxVolume, (errCode: number, returnValue: number) => {
          reply.writeInt(errCode);
          if (errCode == 0) {
            reply.writeInt(returnValue);
          }
        });
        return true;
      }
      default: {
        console.log('invalid request code' + code);
        break;
      }
    }
    return false;
  }

  public position: number
  public duration: number
  private playerStatus: number
  private surfaceId: string
  public playFlag: boolean
  private onStatusCallback: StatusCallback = (_playFlag: boolean): void => {
  }
  private onPositionCallback: PositionCallback = (_position: number, _duration: number): void => {
  }
  private onVolumeCallback: VolumeCallback = (_volume: number, _maxVolume: number): void => {
  }

  public onPositionChanged(position: number, duration: number, callback: OnPositionChangedCallback): void {
    console.log('onPositionChanged position:' + position + 'duration:' + duration);
    if (this.onPositionCallback && position >= 0) {
      this.onPositionCallback(duration, position)
    }
    callback(0, position)
  }

  public onPlayerStatusChanged(playerStatus: number, callback: OnPlayerStatusChangedCallback): void {
    if (playerStatus == 5 || 
    playerStatus == 6 || 
    playerStatus == 7 || 
    playerStatus == 8 || 
    playerStatus == 9 || 
    playerStatus == 14) {

      this.playFlag = true
    } else {

      this.playFlag = false
    }
    if (this.onStatusCallback) {
      this.onStatusCallback(this.playFlag)
    }
    callback(0, playerStatus)
  }

  public onVolumeChanged(volume: number, maxVolume: number, callback: OnVolumeChangedCallback): void {

    console.log('onVolumeChanged volume:' + volume + 'maxVolume:' + maxVolume);
    if (this.onVolumeCallback) {
      this.onVolumeCallback(volume, maxVolume)
    }
    callback(0, volume, maxVolume)
  }

  public onPlayerError(callback: OnPlayerErrorCallback): void {
    let keyDown: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_BACK,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyUp: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_BACK,
      keyDownDuration: 0,
      isIntercepted: false
    };

    try {
      // 触发tab点击，使默认焦点组件多态样式生效
      inputEventClient.injectEvent({ KeyEvent: keyDown });
      inputEventClient.injectEvent({ KeyEvent: keyUp });
    } catch (e) {
      console.log('tab key event click false')
    }
    callback(0, 0)
  }

  public setStatusCallback(statusCallback: StatusCallback,
    positionCallback: PositionCallback, volumeCallback: VolumeCallback): void {
    this.onStatusCallback = statusCallback
    this.onPositionCallback = positionCallback
    this.onVolumeCallback = volumeCallback
  }


  public static readonly COMMAND_ON_POSITION_CHANGED = 1;
  public static readonly COMMAND_ON_PLAYER_STATUS_CHANGED = 2;
  public static readonly COMMAND_ON_PLAYER_ERROR = 3;
  public static readonly COMMAND_ON_VOLUNE_CHANGED = 4;
}

