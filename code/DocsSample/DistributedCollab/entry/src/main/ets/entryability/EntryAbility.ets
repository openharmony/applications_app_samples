/*
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

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import abilityConnectionManager from '@ohos.distributedsched.abilityConnectionManager';
import { util } from '@kit.ArkTS';

const TAG:string = "WatchAbility_DemoTest";

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onContinue(wantParam: Record<string, Object>): AbilityConstant.OnContinueResult {
    return 1;
  }
  // [Start collab]
  onCollaborate(wantParam: Record<string, Object>): AbilityConstant.CollaborateResult {
    hilog.info(0x0000, 'testTag', '%{public}s', 'on collaborate');
    let param = wantParam['ohos.extra.param.key.supportCollaborateIndex'] as Record<string, Object>
    this.onCollab(param);
    return 0;
  }

  onCollab(collabParam: Record<string, Object>) {
    const sessionId = this.createSessionFromWant(collabParam);
    if (sessionId == -1) {
      return;
    }
    this.registerSessionEvent(sessionId);
    const collabToken = collabParam['ohos.dms.collabToken'] as string;
    abilityConnectionManager.acceptConnect(sessionId, collabToken).then(() => {
      AppStorage.setOrCreate<number>('sessionId', sessionId);
    }).catch(() => {
      console.error(TAG + `acceptConnect failed` );
    })
  }

  createSessionFromWant(collabParam: Record<string, Object>): number {
    let sessionId = -1;
    const peerInfo = collabParam['PeerInfo'] as abilityConnectionManager.PeerInfo;
    if (peerInfo == undefined) {
      return sessionId;
    }
    // 定义连接选项
    const options = collabParam['ConnectOption'] as abilityConnectionManager.ConnectOptions;
    try {
      sessionId = abilityConnectionManager.createAbilityConnectionSession('collabTest', this.context, peerInfo, options);
    } catch (error) {
      console.error(error);
    }
    return sessionId;
  }
  // [End collab]
  // [Start abilityconnectionmanager_on]
  registerSessionEvent(sessionId: number) {
    abilityConnectionManager.on('connect',sessionId,(callbackInfo) => {
      AppStorage.setOrCreate<boolean>('isConnected', true);
      AppStorage.setOrCreate<string>('receiveMessage', 'connect success');
    });
    abilityConnectionManager.on('disconnect',sessionId,(callbackInfo) => {
      abilityConnectionManager.destroyAbilityConnectionSession(sessionId)
      AppStorage.setOrCreate<boolean>('isConnected', false);
      AppStorage.setOrCreate<string>('receiveMessage', 'session disconnect');
    })
    abilityConnectionManager.on('receiveMessage',sessionId,(callbackInfo) => {
      AppStorage.setOrCreate<string>('receiveMessage', callbackInfo.msg);
      if (callbackInfo.msg == 'startStream') {
        hilog.info(0x0000, 'testTag', 'startStream');
      }
    })
    abilityConnectionManager.on('receiveData',sessionId,(callbackInfo) => {
      hilog.info(0x0000, 'testTag', 'Success.');
    })
  }
  // [End abilityconnectionmanager_on]
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }
}

