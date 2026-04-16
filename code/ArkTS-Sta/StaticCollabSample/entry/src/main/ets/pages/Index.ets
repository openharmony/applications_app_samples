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

// [Start sta_import]
import abilityConnectionManager from '@kit.DistributedKit';
import distributedDeviceManager from '@kit.DistributedKit';
import { util } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit';
import { AppStorage, Entry, Component, State, StorageLink, Watch, Scroll, Scroller, Column, Text, Button, TextInput, ScrollDirection, BarState, FlexAlign, HorizontalAlign, TextAlign, FontWeight } from '@kit.ArkUI';
// [End sta_import]

const TAG: string = 'CollabSample_Index';

// [Start sta_deviceManager]
let dmInstance: distributedDeviceManager.DeviceManager | null = null;

function initDeviceManager(): void {
  try {
    dmInstance = distributedDeviceManager.createDeviceManager('com.example.staticCollabSample');
    hilog.info(0x0000, TAG, 'Device manager created');
  } catch (err) {
    hilog.error(0x0000, TAG, 'Create device manager failed');
  }
}

function getRemoteDeviceId(): string | undefined {
  initDeviceManager();
  if (dmInstance === null) {
    hilog.error(0x0000, TAG, 'Device manager is null');
    return undefined;
  }

  const dm = dmInstance as distributedDeviceManager.DeviceManager;
  const listResult: distributedDeviceManager.DeviceBasicInfo[] = dm.getAvailableDeviceListSync();
  if (listResult.length === 0) {
    hilog.info(0x0000, TAG, 'No available devices');
    return undefined;
  }
  const networkId = listResult[0].networkId;
  if (networkId === undefined || networkId === null) {
    hilog.info(0x0000, TAG, 'No network ID found');
    return undefined;
  }
  hilog.info(0x0000, TAG, 'Found device');
  return networkId;
}
// [End sta_deviceManager]

@Entry
@Component
struct Index {
  @State currentStatus: string = 'init';
  @StorageLink('isConnected') isConnected: boolean = false;
  @StorageLink('receiveMessage') receiveMessage: string = '';
  @StorageLink('sessionId') @Watch('sessionIdWatch') sessionId: int = -1;
  @StorageLink('receiveWatchMessage') @Watch('receiveWatchMessageFuc') receiveWatchMessage: string = '';
  private scroller: Scroller = new Scroller();
  private eventRegistered: boolean = false;

  requestPermissions(): void {
    const permissions: Permissions[] = [
      'ohos.permission.CAMERA',
      'ohos.permission.MICROPHONE',
      'ohos.permission.READ_MEDIA',
      'ohos.permission.WRITE_MEDIA',
      'ohos.permission.DISTRIBUTED_DATASYNC'
    ];

    const atManager = abilityAccessCtrl.createAtManager();
    try {
      const context = this.getUIContext().getHostContext();
      if (context !== undefined && context !== null) {
        atManager.requestPermissionsFromUser(context, permissions).then((data) => {
          hilog.info(0x0000, TAG, 'Permissions requested');
        });
      }
    } catch (err) {
      hilog.error(0x0000, TAG, 'Request permissions failed');
    }
  }

  onPageShow(): void {
    this.requestPermissions();
  }

  sessionIdWatch(propertyName: string): void {
    hilog.info(0x0000, TAG, 'sessionId1 changed to: ' + this.sessionId + ', propertyName: ' + propertyName);
    if (this.sessionId !== -1 && !this.eventRegistered) {
      this.eventRegistered = true;
    }
    hilog.info(0x0000, TAG, 'sessionIdWatch end');
  }

  receiveWatchMessageFuc(propertyName: string): void {
    this.receiveMessage = 'connect success';
    hilog.info(0x0000, TAG, 'receiveWatchMessageFuc called');
    this.receiveMessage = 'connect success';
    this.isConnected = true;
    hilog.info(0x0000, TAG, 'sessionId changed to: ' + this.sessionId + ', propertyName: ' + propertyName + ' receiveWatchMessage:' + this.receiveMessage);
    this.receiveMessage = 'connect success';
    this.isConnected = true;
    hilog.info(0x0000, TAG, 'sessionIdWatch end, this.receiveMessage:' + this.receiveMessage);
  }
// [Start sta_createSession]
  createSession(): void {
    const remoteDeviceId = getRemoteDeviceId();
    if (remoteDeviceId === undefined) {
      hilog.error(0x0000, TAG, 'No remote device available');
      this.receiveMessage = 'No remote device found';
      return;
    }

    const peerInfo: abilityConnectionManager.PeerInfo = {
      deviceId: remoteDeviceId,
      bundleName: 'com.example.staticCollabSample',
      moduleName: 'entry',
      abilityName: 'EntryAbility',
      serviceName: 'collabService'
    };

    const connectOption: abilityConnectionManager.ConnectOptions = {
      needSendData: true,
      startOptions: abilityConnectionManager.StartOptionParams.START_IN_FOREGROUND
    };

    try {
      const context = this.getUIContext().getHostContext();
      if (context !== undefined && context !== null) {
        this.sessionId = abilityConnectionManager.createAbilityConnectionSession(
          'collabTest',
          context,
          peerInfo,
          connectOption
        );
        hilog.info(0x0000, TAG, 'Session created mxd');
        this.receiveMessage = 'Session created: ' + this.sessionId;
      }
    } catch (error) {
      hilog.error(0x0000, TAG, 'Create session failed');
      this.receiveMessage = 'Create session failed';
    }
  }
// [End sta_createSession]

  registerSessionEvent(): void {
    if (this.sessionId === -1) {
      return;
    }

    abilityConnectionManager.onConnect(this.sessionId, (callbackInfo: abilityConnectionManager.EventCallbackInfo) => {
      this.receiveMessage = 'Connected';
      hilog.info(0x0000, TAG, 'Connected');
    });

    abilityConnectionManager.onDisconnect(this.sessionId,
      (callbackInfo: abilityConnectionManager.EventCallbackInfo) => {
      this.receiveMessage = 'Disconnected';
      abilityConnectionManager.destroyAbilityConnectionSession(this.sessionId);
      hilog.info(0x0000, TAG, 'Disconnected');
    });

    abilityConnectionManager.onReceiveMessage(
      this.sessionId,
      (callbackInfo: abilityConnectionManager.EventCallbackInfo) => {
        this.receiveMessage = 'Received: ' + callbackInfo.msg;
        hilog.info(0x0000, TAG, 'Message received');
      }
    );

    abilityConnectionManager.onReceiveData(this.sessionId, (callbackInfo) => {
      const decoder = util.TextDecoder.create('utf-8');
      const dataBuffer = callbackInfo.data ?? new ArrayBuffer(0);
      const data = new Uint8Array(dataBuffer);
      const str = decoder.decodeToString(data);
      this.receiveMessage = 'Data received: ' + str;
      hilog.info(0x0000, TAG, 'Data received');
    });
  }

  connectRemoteAbility(): void {
    this.createSession();
    if (this.sessionId === -1) {
      this.receiveMessage = 'Invalid session ID';
      return;
    }

    this.receiveMessage = 'Connecting...';
    this.registerSessionEvent();

    abilityConnectionManager.connect(this.sessionId).then((result) => {
      if (!result.isConnected) {
        this.receiveMessage = 'Connection failed';
        hilog.error(0x0000, TAG, 'Connection failed');
      } else {
        this.receiveMessage = 'Connection success';
        this.isConnected = true;
        hilog.info(0x0000, TAG, 'Connection success');
      }
    }, (err: Error) => {
      this.receiveMessage = 'Connection error';
      hilog.error(0x0000, TAG, 'Connection error');
    });
  }

// [Start sta_sendMessage]
  sendMessage(): void {
    if (!this.isConnected) {
      this.receiveMessage = 'Not connected';
      hilog.error(0x0000, TAG, 'Session not connected');
      return;
    }

    this.receiveMessage = 'Sending message...';
    abilityConnectionManager.sendMessage(this.sessionId, 'Hello from peer').then(() => {
      this.receiveMessage = 'Message sent';
      hilog.info(0x0000, TAG, 'Message sent');
    }, (err: Error) => {
      this.receiveMessage = 'Send failed';
      hilog.error(0x0000, TAG, 'Send message failed');
    });
  }
// [End sta_sendMessage]

// [Start sta_sendData]
  sendData(): void {
    if (!this.isConnected) {
      this.receiveMessage = 'Not connected';
      hilog.error(0x0000, TAG, 'Session not connected');
      return;
    }

    this.receiveMessage = 'Sending data...';
    const textEncoder = util.TextEncoder.create('utf-8');
    const arrayBuffer = textEncoder.encodeInto('Data from peer');
    abilityConnectionManager.sendData(this.sessionId, arrayBuffer.buffer).then(() => {
      this.receiveMessage = 'Data sent';
      hilog.info(0x0000, TAG, 'Data sent');
    }, (err: Error) => {
      this.receiveMessage = 'Send data failed';
      hilog.error(0x0000, TAG, 'Send data failed');
    });
  }
// [End sta_sendData]

// [Start sta_disconnect]
  disconnectRemoteAbility(): void {
    if (this.sessionId === -1) {
      this.receiveMessage = 'Invalid session ID';
      return;
    }

    abilityConnectionManager.disconnect(this.sessionId);
    this.receiveMessage = 'Disconnecting...';
    hilog.info(0x0000, TAG, 'Disconnecting');
  }

  destroySession(): void {
    if (this.sessionId === -1) {
      this.receiveMessage = 'Invalid session ID';
      return;
    }

    try {
      abilityConnectionManager.destroyAbilityConnectionSession(this.sessionId);
      this.receiveMessage = 'Session destroyed';
      this.sessionId = -1;
      this.isConnected = false;
      hilog.info(0x0000, TAG, 'Session destroyed');
    } catch (err) {
      this.receiveMessage = 'Destroy failed';
      hilog.error(0x0000, TAG, 'Destroy session failed');
    }
  }
// [End sta_disconnect]

  build() {
    Scroll(this.scroller) {
      Column() {
        Text('Distributed Collaboration Sample')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 20 })

        TextInput({ text: this.receiveMessage })
          .fontSize(16)
          .borderWidth(2)
          .borderColor('#333333')
          .textAlign(TextAlign.Center)
          .height(50)
          .width('80%')
          .margin({ bottom: 20 })
          .id('messageInput')

        Column() {
          Button('Connect')
            .fontSize(16)
            .margin({ top: 8 })
            .onClick(() => this.connectRemoteAbility())
            .width('70%')
            .height(45)

          Button('Send Message')
            .fontSize(16)
            .margin({ top: 8 })
            .onClick(() => this.sendMessage())
            .width('70%')
            .height(45)

          Button('Send Data')
            .fontSize(16)
            .margin({ top: 8 })
            .onClick(() => this.sendData())
            .width('70%')
            .height(45)

          Button('Disconnect')
            .fontSize(16)
            .margin({ top: 8 })
            .onClick(() => this.disconnectRemoteAbility())
            .width('70%')
            .height(45)

          Button('Destroy Session')
            .fontSize(16)
            .margin({ top: 8 })
            .onClick(() => this.destroySession())
            .width('70%')
            .height(45)
        }
        .width('100%')
        .height('auto')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
    .backgroundColor('#F5F5F5')
  }
}
