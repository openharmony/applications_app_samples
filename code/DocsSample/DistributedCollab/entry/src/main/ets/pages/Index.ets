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

import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
// [Start import_abilityConnectionManager]
import {abilityConnectionManager, distributedDeviceManager } from '@kit.DistributedServiceKit';
// [End import_abilityConnectionManager]
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

export default interface XComponentContext {
  drawPattern(): void;
  getStatus(): XComponentContextStatus;
};

interface XComponentContextStatus {
  hasDraw: boolean;
  hasChangeColor: boolean;
}

const TAG: string = "IndexPage_DemoTest";

// [Start source_1]
let dmClass: distributedDeviceManager.DeviceManager;

function initDmClass(): void {
  // 其中createDeviceManager接口为系统API
  try {
    dmClass = distributedDeviceManager.createDeviceManager('com.example.remotephotodemo');
  } catch (err) {
    hilog.info(0x0000, 'testTag', 'createDeviceManager err');
  }
}

// 获取设备B的设备ID
function getRemoteDeviceId(): string | undefined {
  initDmClass();
  if (typeof dmClass === 'object' && dmClass !== null) {
    hilog.info(0x0000, 'testTag', 'getRemoteDeviceId begin');
    let list = dmClass.getAvailableDeviceListSync();
    if (typeof (list) === 'undefined' || typeof (list.length) === 'undefined') {
      hilog.info(0x0000, 'testTag', 'getRemoteDeviceId err: list is null');
      return;
    }
    if (list.length === 0) {
      hilog.info(0x0000, 'testTag', 'getRemoteDeviceId err: list is empty');
      return;
    }
    // 弹框选择设备
    return list[0].networkId;
  } else {
    hilog.info(0x0000, 'testTag', 'getRemoteDeviceId err: dmClass is null');
    return;
  }
}
// [End source_1]

@Entry
@Component
struct Index {
  @State currentStatus: string = "init";
  @StorageLink('isConnected') isConnected: boolean = false;
  @StorageLink('receiveMessage') receiveMessage: string = "";
  @StorageLink('sessionId') sessionId: number = -1;
  private xComponentContext: XComponentContext | undefined = undefined;
  @StorageLink('pixelMap') currentPixelMap: PixelMap |null= null;
  // XComponentController控制器
  private mComponentController: XComponentController = new XComponentController();
  private scroller: Scroller = new Scroller();

  async requestPermission() {
    // 申请权限
    let permissionNames: Permissions[] = [
      'ohos.permission.CAMERA',
      'ohos.permission.MICROPHONE',
      'ohos.permission.READ_MEDIA',
      'ohos.permission.WRITE_MEDIA',
      'ohos.permission.DISTRIBUTED_DATASYNC'
    ];
    let atManager = abilityAccessCtrl.createAtManager();
    await atManager.requestPermissionsFromUser(this.getUIContext().getHostContext(), permissionNames).then((data) => {
      console.info(TAG + 'getPermission success');
    });
  }

  onPageShow() {
    this.requestPermission();
  }

  // [Start source_2]
  createSession(): void {
    // 定义peer信息
    const peerInfo: abilityConnectionManager.PeerInfo = {
      deviceId: getRemoteDeviceId()!,
      bundleName: 'com.example.myapplication',
      moduleName: 'entry',
      abilityName: 'EntryAbility',
    };
    const myRecord: Record<string, string> = {
      'newKey1': 'value1',
    };

    // 定义连接选项
    const connectOption: abilityConnectionManager.ConnectOptions = {
      needSendData: true,
      startOptions: abilityConnectionManager.StartOptionParams.START_IN_FOREGROUND,
      parameters: myRecord
    };
    console.info(TAG + JSON.stringify(peerInfo))
    console.info(TAG + JSON.stringify(connectOption))
    let context = this.getUIContext().getHostContext();
    try {
      this.sessionId = abilityConnectionManager.createAbilityConnectionSession('collabTest', context, peerInfo, connectOption);
      hilog.info(0x0000, 'testTag', 'createSession sessionId is', this.sessionId);
      abilityConnectionManager.connect(this.sessionId).then((connectResult) => {
        if (!connectResult.isConnected) {
          hilog.info(0x0000, 'testTag', 'connect failed');
          return;
        }
      }).catch(() => {
        hilog.error(0x0000, 'testTag', 'connect failed');
      })
    } catch (error) {
      hilog.error(0x0000, 'testTag', error);
    }
  }
  // [End source_2]

  registerSessionEvent() {
    if (this.sessionId == -1) {
      return;
    }

    abilityConnectionManager.on('connect', this.sessionId,(callbackInfo) => {
      this.receiveMessage = 'connect';
    });

    abilityConnectionManager.on('disconnect', this.sessionId,(callbackInfo) => {
      this.receiveMessage = 'disconnect';
      abilityConnectionManager.destroyAbilityConnectionSession(this.sessionId);
    })

    abilityConnectionManager.on('receiveMessage', this.sessionId,(callbackInfo) => {
      this.receiveMessage = callbackInfo.msg!;
    })

    abilityConnectionManager.on('receiveData',this.sessionId,(callbackInfo) => {
      let decoder = util.TextDecoder.create('utf-8');
      let str = decoder.decodeWithStream(new Uint8Array(callbackInfo.data));
      this.receiveMessage = str;
    })
  }

  connectRemoteAbility(): void {
    this.createSession();
    if (this.sessionId == -1) {
      return;
    }
    this.receiveMessage = 'start connect';
    this.registerSessionEvent();
    abilityConnectionManager.connect(this.sessionId).then((connectResult:abilityConnectionManager.ConnectResult) => {
      if (!connectResult.isConnected) {
        return;
      }
      this.receiveMessage = 'connect success';
      this.isConnected = true;
    }).catch((error: BusinessError) => {
      // 处理异常情况
      hilog.error(0x0000, 'testTag', `sendMsg failed with ${error}`);
      console.log(`error: ${error}`);
    });
  }

  sendMessage(): void {
    if (!this.isConnected) {
      hilog.error(0x0000, 'testTag', 'session disconnect');
    }
    console.log(TAG + `sendMessage, sessionId is ` + this.sessionId );
    this.receiveMessage = 'send message';
    // [start sendMessage]
    abilityConnectionManager.sendMessage(this.sessionId, 'message send success').then(() => {
      hilog.info(0x0000, 'testTag', 'sendMessage success');
      console.log(TAG + `sendMessage success, sessionId is ` + this.sessionId );
    }).catch((error: BusinessError) => {
      hilog.error(0x0000, 'testTag', 'connect failed');
    });
  // [end sendMessage]
  }

  sendData(): void {
    if (!this.isConnected) {
      hilog.error(0x0000, 'testTag', 'session disconnect');
    }
    this.receiveMessage = 'send data';
    let textEncoder = util.TextEncoder.create('utf-8');
    const arrayBuffer  = textEncoder.encodeInto('data send success');
    console.log(TAG + `sendData, sessionId is ` + this.sessionId );
    abilityConnectionManager.sendData(this.sessionId, arrayBuffer.buffer).then(() => {
      console.log(`sendData success, sessionId is ` + this.sessionId );
    }).catch((error: BusinessError) => {
      hilog.error(0x0000, 'testTag', 'send data failed');
    });
  }
// [Start disconnect]
  disconnectRemoteAbility(): void {
    if (this.sessionId == -1) {
      hilog.info(0x0000, 'testTag', 'Invalid session ID.');
      return;
    }
    abilityConnectionManager.disconnect(this.sessionId);
    this.receiveMessage = 'disConnect';
  }

  destroySession(): void {
    try {
      abilityConnectionManager.destroyAbilityConnectionSession(this.sessionId);
      this.receiveMessage = 'destroy';
    } catch (err) {
      console.log(TAG, 'createDeviceManager err: ' + JSON.stringify(err));
      hilog.error(0x0000, 'testTag', 'connect failed');
    }
// [End disconnect]
  }

  build() {

    Scroll(this.scroller) {
      Column() {
        TextInput({
          text: this.receiveMessage,
        })
          .fontWeight(400)
          .fontSize(20)
          .borderWidth(2)
          .borderColor(Color.Black)
          .textAlign(TextAlign.Center)
          .align(Alignment.Center)
          .height(40)
          .width('65%')
          .onChange((value: string) => {
            this.receiveMessage = value;
          })
          .type(InputType.Normal)
          .backgroundColor(Color.Transparent)
          .margin({ top: 5 })
          .restoreId(2)
          .id('textInput')

        Column() {
          Button('start connect')
            .fontSize('16fp')
            .fontWeight(500)
            .margin({ top: 8 })
            .onClick(() => this.connectRemoteAbility())
            .width('50%')
            .height(40)

          Button('send message')
            .fontSize('16fp')
            .fontWeight(500)
            .margin({ top: 8 })
            .onClick(() => this.sendMessage())
            .width('50%')
            .height(40)

          Button('send data')
            .fontSize('16fp')
            .fontWeight(500)
            .margin({ top: 8 })
            .onClick(() => this.sendData())
            .width('50%')
            .height(40)

          Button('disconnect')
            .fontSize('16fp')
            .fontWeight(500)
            .margin({ top: 8 })
            .onClick(() => this.disconnectRemoteAbility())
            .width('50%')
            .height(40)

          Button('destroy connection')
            .fontSize('16fp')
            .fontWeight(500)
            .margin({ top: 8 })
            .onClick(() => this.destroySession())
            .width('50%')
            .height(40)
        }
        .width('100%')
        .height('auto')
        .justifyContent(FlexAlign.Start)
      }
    }
    .width('100%')
    .height(800)
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .align(Alignment.Center)
    .friction(0.6)
    .edgeEffect(EdgeEffect.Spring)
    .onScrollEdge(() => {
      // To the edge
    })
    .onScrollStop(() => {
      // Scroll Stop
    })
    .onAreaChange((oldArea: Area, newArea: Area) => {
      // Scroll
    })
  }
}