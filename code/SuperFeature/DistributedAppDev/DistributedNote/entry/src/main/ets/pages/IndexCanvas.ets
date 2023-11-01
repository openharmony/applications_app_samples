/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import router from '@ohos.router';
import deviceManager from '@ohos.distributedDeviceManager';
import common from '@ohos.app.ability.common';
import { BUNDLE, ABILITY } from '../model/Const';
import DistributedCanvasModel from '../model/DistributedCanvasModel';
import Logger from '../model/Logger';
import CanvasPath from '../model/Canvas';
import RemoteDeviceModel from '../model/RemoteDeviceModel';
import { CanvasDataSource } from '../common/BasicDataSource';
import DeviceDialog from '../common/DeviceDialog';
import TitleBar from '../common/TitleBar';

const TAG: string = 'Sample_IndexCanvas';

@Entry
@Component
struct IndexCanvas {
  private path2Df: Path2D = new Path2D();
  private path2De: Path2D = new Path2D();
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private settings1: RenderingContextSettings = new RenderingContextSettings(true);
  private context1: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings1);
  private dialogController?: CustomDialogController;
  private selectedIndex: number = 0;
  private sessionId: string = '';
  @StorageLink('sessionId') globalSessionId: string = '';
  @StorageLink('canvasModel') globalObject: DistributedCanvasModel = new DistributedCanvasModel();
  @StorageLink('isOnline') globalIsOnline: boolean = false;
  @State devices: Array<deviceManager.DeviceBasicInfo> = [];
  private canvasDataSource: CanvasDataSource = new CanvasDataSource();

  onPageShow() {
    this.canvasDataSource.pathArray = this.globalObject.distributedCanvas.pathArray;
    this.canvasDataSource.notifyDataReload();
    Logger.info(TAG, `this.sessionId = ${this.sessionId}`);
    Logger.info(TAG, `globalSessionId = ${this.globalSessionId}`);
    if (this.sessionId !== this.globalSessionId) {
      this.sessionId = this.globalSessionId;
      this.share();
    }
  }

  showDialog = () => {
    RemoteDeviceModel.registerDeviceListCallback(() => {
      Logger.info(TAG, 'registerDeviceListCallback, callback entered');
      this.devices = [];
      this.devices = RemoteDeviceModel.discoverDevices.length > 0 ? RemoteDeviceModel.discoverDevices : RemoteDeviceModel.devices;
      if (this.dialogController) {
        this.dialogController.close();
        this.dialogController = undefined;
      }
      this.dialogController = new CustomDialogController({
        builder: DeviceDialog({
          devices: this.devices,
          onSelectedIndexChange: this.onSelectedDevice
        }),
        autoCancel: true
      })
      this.dialogController.open();
    })
  }

  share() {
    Logger.info(TAG, `sessionId = ${this.sessionId}`)
    this.globalObject.setChangeCallback(() => {
      this.canvasDataSource.pathArray = this.globalObject.distributedCanvas.pathArray;
      this.canvasDataSource.notifyDataReload();
    })
    this.globalObject.setStatusCallback((session, networkId, status) => {
      Logger.info(TAG, `StatusCallback,${status}`);
      if (status === 'online') {
        this.globalIsOnline = true;
      } else {
        this.globalIsOnline = false;
      }
    })
    this.globalObject.distributedCanvas.setSessionId(this.sessionId);
    AppStorage.SetOrCreate('canvasModel', this.globalObject);
    AppStorage.SetOrCreate('isOnline', this.globalIsOnline);
  }

  clearSelectState() {
    this.devices = [];
    this.dialogController?.close();
    this.dialogController = undefined;
  }

  onSelectedDevice = (selectedIndex: number) => {
    this.selectedIndex = selectedIndex;
    Logger.info(TAG, 'start ability ......');
    if (RemoteDeviceModel === null || RemoteDeviceModel.discoverDevices.length <= 0) {
      Logger.info(TAG, `start ability device:${JSON.stringify(this.devices)}`);
      this.startAbility(this.devices[this.selectedIndex].networkId as string);
      this.clearSelectState();
      return;
    }
    Logger.info(TAG, 'start ability, needAuth');
    RemoteDeviceModel.authenticateDevice(this.devices[this.selectedIndex], (device: deviceManager.DeviceBasicInfo) => {
      Logger.info(TAG, 'auth and online finished');
      this.startAbility(device.networkId);
    })
    Logger.info(TAG, 'start ability2 ......');
    this.clearSelectState();
  }

  startAbility(deviceId: string) {
    this.globalObject = new DistributedCanvasModel();
    this.sessionId = this.globalObject.genSessionId();
    AppStorage.SetOrCreate('sessionId', this.sessionId);
    this.canvasDataSource.pathArray = [];
    this.canvasDataSource.notifyDataReload();
    this.globalObject.off();
    this.share();
    Logger.info(TAG, `startAbility deviceId:${deviceId}`);
    let context = getContext(this) as common.UIAbilityContext;
    context.startAbility({
      bundleName: BUNDLE,
      abilityName: ABILITY,
      deviceId: deviceId,
      parameters: {
        sessionId: this.sessionId,
      }
    })
  }

  build() {
    Column() {
      TitleBar({ rightBtn: $r('app.media.trans'), onRightBtnClicked: this.showDialog })
      Row() {
        Text($r('app.string.state'))
          .fontSize(30)
        Image(this.globalIsOnline ? $r('app.media.green') : $r('app.media.red'))
          .size({ width: 30, height: 30 })
          .objectFit(ImageFit.Contain)
      }
      .width('100%')
      .padding(16)

      List() {
        LazyForEach(this.canvasDataSource, (item: CanvasPath, index) => {
          ListItem() {
            if (index === 0) {
              Canvas(this.context)
                .width('100%')
                .height(200)
                .backgroundColor('#00ffff')
                .onReady(() => {
                  if (item.path === 'rect') {
                    this.context.save();
                    this.path2Df.rect(80, 80, 100, 100);
                    this.context.stroke(this.path2Df);
                    this.context.restore();
                  }
                  if (item.path === 'ellipse') {
                    this.context.restore();
                    this.path2De.ellipse(100, 100, 50, 100, Math.PI * 0.25, Math.PI * 0.5, Math.PI);
                    this.path2De.closePath();
                    this.context.stroke(this.path2De);
                    this.context.save();
                  }
                })
                .id(item.path + 'ready')
            }
          }
          ListItem() {
            if (index === 1) {
              Canvas(this.context1)
                .width('100%')
                .height(200)
                .backgroundColor('#00ffff')
                .onReady(() => {
                  if (item.path === 'rect') {
                    this.context1.save();
                    this.path2Df.rect(80, 80, 100, 100);
                    this.context1.stroke(this.path2Df);
                    this.context1.restore();
                  }
                  if (item.path === 'ellipse') {
                    this.context1.restore();
                    this.path2De.ellipse(100, 100, 50, 100, Math.PI * 0.25, Math.PI * 0.5, Math.PI);
                    this.path2De.closePath();
                    this.context1.stroke(this.path2De);
                    this.context1.save();
                  }
                })
                .id(item.path + 'ready')
            }
          }
        }, (item: CanvasPath) => JSON.stringify(item))
      }

      Row() {
        Button('ellipse')
          .width(130)
          .height(45)
          .key('ellipse')
          .onClick(() => {
            if (this.globalObject.isContainString('ellipse') === -1) {
              this.globalObject.add('ellipse');
            }
            this.onPageShow();
          })
        Button('rect')
          .width(130)
          .height(45)
          .key('rect')
          .onClick(() => {
            if (this.globalObject.isContainString('rect') === -1) {
              this.globalObject.add('rect');
            }
            this.onPageShow();
          })
      }.margin({ top: 10 })
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)

      Row() {
        Button('back')
          .width(130)
          .height(45)
          .key('back')
          .backgroundColor(Color.Orange)
          .onClick(() => {
            this.globalObject.clear();
            this.canvasDataSource.pathArray = [];
            this.canvasDataSource.notifyDataReload();
            this.context.clearRect(0, 0, 950, 950);
            router.back()
          })
        Button('delete')
          .width(130)
          .height(45)
          .key('delete')
          .onClick(() => {
            this.globalObject.clear();
            this.canvasDataSource.pathArray = [];
            this.canvasDataSource.notifyDataReload();
            this.context.clearRect(0, 0, 950, 950);
          })
      }.margin({ top: 10 })
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}