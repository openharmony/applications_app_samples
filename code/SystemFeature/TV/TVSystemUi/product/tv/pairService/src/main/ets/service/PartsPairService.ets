/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { ServiceExtensionAbility, Want, common, Permissions } from '@kit.AbilityKit';
import { PermissionUtils } from '../util/PermissionUtils';
import LogUtil from '../util/LogUtil';
import { rpc } from '@kit.IPCKit';
import partsPairController from './PartsPairController';
import PartsPairIdlImpl from './PartsPairIdlImpl';
import { BusinessError } from '@kit.BasicServicesKit';
import { PairingState } from '../model/PairingState';

const LIVE_DURATION = 10 * 60 * 1000

export const BT_PERMISSIONS: Permissions[] = ['ohos.permission.ACCESS_BLUETOOTH', 'ohos.permission.MANAGE_BLUETOOTH']

const TAG = '[PPL_pairing_service]'

export let serviceExtensionContext: common.ServiceExtensionContext | undefined = undefined

export default class PartsPairService extends ServiceExtensionAbility {
  public idlImpl: PartsPairIdlImpl = new PartsPairIdlImpl('idlImpl');
  public isStart: boolean = false
  public connectedClientSize = 0

  // 服务启动后设置 LIVE_DURATION（10分钟）定时自检：
  // 若三模遥控器已连接则仅停止扫描保持服务存活以监听信源切换；
  // 否则销毁自身，避免配对服务长期驻留后台消耗系统资源。
  onCreate(want: Want): void {
    serviceExtensionContext = this.context;
    LogUtil.info(TAG, `onCreate, want: ${want.abilityName}`);
    setTimeout(() => {
      // 三模遥控器连接上的话, 要监听信源状态变化, 切换控制对象, 不能停止服务, 只停止扫描即可
      if (partsPairController.is3ModeRemoteConnected()) {
        partsPairController.stopScan()
      } else {
        this.context.terminateSelf()
      }
    }, LIVE_DURATION)
    this.doPairing()
  };

  onRequest(want: Want, startId: number): void {
    LogUtil.info(TAG, `onRequest, want: ${JSON.stringify(want)}`);
    const command = want.parameters?.command
    if (command === 'set3ModeRemoteToTV') {
      partsPairController.set3ModeRemoteToTV()
    } else if (command === 'setTVFullScreenState') {
      const fullScreen = want.parameters?.fullScreen
      if (fullScreen === true) {
        partsPairController.setTVFullScreenState(true)
      } else {
        partsPairController.setTVFullScreenState(false)
      }
    } else if (command === 'doPairing'){
      this.doPairing()
    }
  };

  onConnect(want: Want): rpc.RemoteObject {
    LogUtil.info(TAG, `onConnect, want: ${JSON.stringify(want)}`);
    this.connectedClientSize++
    this.doPairing()
    return this.idlImpl as rpc.RemoteObject;
  };

  onDisconnect(want: Want): void {
    this.connectedClientSize--
    LogUtil.info(TAG, `onDisconnect, want: ${JSON.stringify(want)}`);
  };

  onDestroy(): void {
    LogUtil.info(TAG, 'onDestroy');
    partsPairController.stop()
  };

  // 每次 onCreate/onConnect/onRequest 都会调用 doPairing，
  // 而非只在 onCreate 调用一次，是为了处理权限被动态撤销后重新授权的场景，
  // 确保权限恢复后配对流程能自动重启而无需用户手动重新触发。
  private doPairing() {
    LogUtil.info(TAG, `doPairing`)
    PermissionUtils.requestPermission(BT_PERMISSIONS).then((result) => {
      if (result) {
        LogUtil.info(TAG, `permission grant`)
        partsPairController.setStateChangeListener((state) => {
          if (state === PairingState.STATE_PAIRED) {
            if (this.connectedClientSize === 0) {
              this.startPairingAbility()
            }
          }
        })
        partsPairController.start()
      } else {
        LogUtil.info(TAG, `permission denied`)
      }
    })
  }

  private async startPairingAbility() {
    this.context.startAbility({
      bundleName: 'com.ohos.partslist',
      abilityName: 'PairingAbility'
    }).then(() => {
      LogUtil.info(TAG, `start Ability success`)
    }).catch((error: BusinessError) => {
      LogUtil.error(TAG, `start Ability fail ${JSON.stringify(error)}`)
    })
  }
}
