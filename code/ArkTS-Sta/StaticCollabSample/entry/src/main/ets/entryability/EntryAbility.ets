'use static'
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

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import abilityConnectionManager from '@kit.DistributedKit';
import { AppStorage, UIContext } from '@kit.ArkUI';
import { BusinessError } from '@kit.BaseKit';

const TAG: string = 'CollabSample_EntryAbility';

export default class EntryAbility extends UIAbility {
  private uiContext: UIContext | null = null;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, TAG, 'Ability onCreate');
  }

  onContinue(wantParam: Record<string, Object>): AbilityConstant.OnContinueResult {
    hilog.info(0x0000, TAG, 'onContinue called');
    return AbilityConstant.OnContinueResult.AGREE;
  }

// [Start sta_collab]
  onCollaborate(wantParam: Record<string, Object>): AbilityConstant.CollaborateResult {
    hilog.info(0x0000, TAG, 'onCollaborate called1');
    let param = wantParam['ohos.extra.param.key.supportCollaborateIndex'] as Record<string, Object>;
    this.handleCollaborate(param);
    return AbilityConstant.CollaborateResult.ACCEPT;
  }

  handleCollaborate(collabParam: Record<string, Object>): void {
    hilog.info(0x0000, TAG, 'handleCollaborate called1');
    let sessionId: int = this.createSessionFromWant(collabParam);
    if (sessionId === -1) {
      hilog.error(0x0000, TAG, 'Failed to create session');
      return;
    }
    this.registerSessionEvent(sessionId);
    const collabToken = collabParam['ohos.dms.collabToken'] as string;
    abilityConnectionManager.acceptConnect(sessionId, collabToken).then(() => {
      AppStorage.setOrCreate('sessionId', sessionId);
      hilog.info(0x0000, TAG, 'Accept connect success, sessionId: ' + sessionId);
    }, (err: Error) => {
      hilog.error(0x0000, TAG, 'Accept connect failed: ' + err.message);
    });
  }

  createSessionFromWant(collabParam: Record<string, Object>): int {
    hilog.info(0x0000, TAG, 'createSessionFromWant called');
    let sessionId: int = -1;
    let peerInfo: abilityConnectionManager.PeerInfo = {
      bundleName: '',
      moduleName: '',
      abilityName: '',
      deviceId: '',
      serviceName: ''
    };
    const peerInfo1 = collabParam['PeerInfo'];
    if (peerInfo1 == undefined) {
      return sessionId;
    }
    const peerInfo1Record = peerInfo1 as Record<string, string>;
    peerInfo.bundleName = peerInfo1Record!['bundleName'] ?? '';
    peerInfo.moduleName = peerInfo1Record!['moduleName'] ?? '';
    peerInfo.abilityName = peerInfo1Record!['abilityName'] ?? '';
    peerInfo.deviceId = peerInfo1Record!['deviceId'] ?? '';
    peerInfo.serviceName = peerInfo1Record!['serviceName'] ?? '';
    hilog.info(0x0000, TAG, 'createSessionFromWant peerInfo is:' + JSON.stringify(peerInfo))
    if (peerInfo == undefined) {
      return sessionId;
    }
    hilog.info(0x0000, TAG, 'collabParam ConnectOption')
    const options1 = collabParam['ConnectOption'];
    hilog.info(0x0000, TAG, 'options1 is:' + JSON.stringify(options1))
    let options2 = collabParam['ConnectOption'] as Record<string, string | undefined>;
    hilog.info(0x0000, TAG, 'createSessionFromWant options2 as Record<string, string | undefined> is:' + JSON.stringify(options2))

    let options: abilityConnectionManager.ConnectOptions = {
    }

    options.needSendData = true;

    hilog.info(0x0000, TAG, 'createSessionFromWant options is:' + JSON.stringify(options))
    hilog.info(0x0000, TAG, 'createSessionFromWant options end:')
    try {
      hilog.info(0x0000, TAG, 'createSessionFromWant createAbilityConnectionSession start:')
      sessionId = abilityConnectionManager.createAbilityConnectionSession('collabTest', this.context, peerInfo, options);
      hilog.info(0x0000, TAG, 'createSessionFromWant createAbilityConnectionSession end:')
      AppStorage.setOrCreate('sessionId', sessionId);
      hilog.info(0x0000, TAG, 'createSessionFromWant createSession sessionId is' + sessionId);
    } catch (error) {
      hilog.error(0x0000, TAG, 'createSessionFromWant createSession error: ' + (error as BusinessError).message);
    }
    return sessionId;
  }
// [End sta_collab]

// [Start sta_abilityconnectionmanager_on]
  registerSessionEvent(sessionId: int): void {
    hilog.info(0x0000, TAG, 'registerSessionEvent called');
    abilityConnectionManager.onConnect(sessionId, (callbackInfo: abilityConnectionManager.EventCallbackInfo) => {
      hilog.info(0x0000, TAG, 'onConnect called');
      AppStorage.setOrCreate<string>('receiveWatchMessage', 'connect success'); // 目前Index.ets里会触发receiveWatchMessageFuc回调，但是回调至执行一行，后续再调
      AppStorage.setOrCreate('receiveMessage', 'connect success');
      hilog.info(0x0000, TAG, 'Session connected');
    });

    abilityConnectionManager.onDisconnect(sessionId, (callbackInfo: abilityConnectionManager.EventCallbackInfo) => {
      hilog.info(0x0000, TAG, 'onDisconnect called');
      abilityConnectionManager.destroyAbilityConnectionSession(sessionId);
      try {
        AppStorage.setOrCreate('isConnected', false);
        AppStorage.setOrCreate('receiveMessage', 'session disconnect');
      } catch (err) {
        hilog.error(0x0000, TAG, 'Error in onDisconnect: ' + JSON.stringify(err));
      }
      hilog.info(0x0000, TAG, 'Session disconnected');
    });

    abilityConnectionManager.onReceiveMessage(sessionId, (callbackInfo: abilityConnectionManager.EventCallbackInfo) => {
      hilog.info(0x0000, TAG, 'onReceiveMessage message called');
      const msg = callbackInfo.msg !== undefined && callbackInfo.msg !== null ? callbackInfo.msg : '';
      try {
        AppStorage.setOrCreate('receiveMessage', msg);
      } catch (err) {
        hilog.error(0x0000, TAG, 'Error in onReceiveMessage: ' + JSON.stringify(err));
      }
      hilog.info(0x0000, TAG, 'Received message: ' + msg);
    });

    abilityConnectionManager.onReceiveData(sessionId, (callbackInfo: abilityConnectionManager.EventCallbackInfo) => {
      hilog.info(0x0000, TAG, 'Received data');
    });
  }
// [End sta_abilityconnectionmanager_on]

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(0x0000, TAG, 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err) => {
      if (err && err.code) {
        hilog.error(0x0000, TAG, 'Failed to load content. Code: ' + err.code);
        return;
      }
      hilog.info(0x0000, TAG, 'Succeeded in loading content');
      this.uiContext = windowStage.getMainWindowSync().getUIContext();
      hilog.info(0x0000, TAG, 'UIContext initialized');
    });
  }
}
