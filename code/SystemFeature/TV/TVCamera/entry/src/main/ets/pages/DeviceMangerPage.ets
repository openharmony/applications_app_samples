/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Logger from '../utils/Logger';
import CameraService from '../models/CameraModel';
import { KeyCode } from '@kit.InputKit';
import remoteDeviceModel from '../models/RemoteDeviceModel';
import RemoteDeviceModel from '../models/RemoteDeviceModel';
import { ColorMetrics, LengthMetrics, promptAction, router } from '@kit.ArkUI';
import UserPrivacyDialog from '../Dialog/MainDialog';
import { CamerasListDialog } from '../Dialog/SettingDialog';
import { camera } from '@kit.CameraKit';
import { JSON } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';
import { bindFunction, unbindFunction } from '../common/Constants';

const TAG = 'IndexPage';
const self: Record<string, string | number> = {
  'currentTabIndex': 0,
  'surfaceIdone': '',
}
//1.new LocalStorage(数据)
const storage = new LocalStorage(self);

@Extend(Text)
function itemStyle() {
  .width('840lpx')
  .borderRadius('18lpx')
  .backgroundColor('#464648')
  .height('96lpx')
  .fontSize('36lpx')
  .fontColor('#FFFFFF')
  .textAlign(TextAlign.Center)
  .textOverflow({
    overflow: TextOverflow.Ellipsis
  })
  .maxLines(2)

}

interface DeviceBasicInfo {
  deviceId: string;
  deviceName: string;
  deviceType: string;
  networkId?: string;
  id: number
}

@Entry(storage)
@Component
struct Index {
  @State isFous: boolean = false;
  private listScroller: Scroller = new Scroller();
  private listScroller1: Scroller = new Scroller();
  private cameraManager: camera.CameraManager = camera.getCameraManager(getContext(this));
  @State screenH: number = 1080;
  @State rowNum: number = 0; // 图片的行数
  @State colNum: number = 6; // 图片的列数
  @State imgNun: number = 0; // 图片的数量
  private scroller: Scroller = new Scroller();
  @State focusIds: number = 0;
  @State currentCameraId: string = ''; // 当前选中的相机Id
  @State camerasList: camera.CameraDevice[] = []
  @State listFirstIndex: number = -1; //
  @State listSecondIndex: number = -1;
  @State focusTab: string = 'tab11';
  @LocalStorageLink('currentTabIndex') @Watch('currentTabIndexChange') currentTabIndex: number = 0; // 被选中的页签索引
  @LocalStorageLink('surfaceIdone') surfaceIdone: string = '';
  @State isDiscovering: boolean = false;
  @State buttonDescribe: ResourceStr = $r('app.string.clickToDiscoverDevice');
  @State buttonColor: string = 'blue';
  @State fontColor: string = '#DBFFFFFF';
  private debounce = true;
  @State trustDeviceList: DeviceBasicInfo[] = [];
  @State unTrustDeviceList: DeviceBasicInfo[] = [];
  private mXComponentController: XComponentController = new XComponentController();
  private select: number | number[] = 0;
  @State files: string[] = [];
  @State imagePath: string = '';
  @State content: ResourceStr = '';
  @State title: ResourceStr = '';
  text: ResourceStr = $r('app.string.noPhotos');
  private imageTimer: number = 0;
  @State deviceId: string = '';
  @State deviceName: string = '';
  @State path: string = '';
  @State netWorkId: string | undefined = ''
  @State functionId:string = '';
  controller: CustomDialogController = new CustomDialogController({
    builder: UserPrivacyDialog({
      confirm: this.onConfirm,
      content: this.content,
      title: this.title,
      deviceId: this.deviceId,
      deviceName: this.deviceName,
      path: this.path,
      functionId:this.functionId
    }),
    openAnimation: {
      duration: 500
    },
    gridCount: 12,
    alignment: DialogAlignment.Center,
    customStyle: true
  });
  camerasDialogController: CustomDialogController = new CustomDialogController({
    builder: CamerasListDialog({
      camerasList: this.camerasList,
      currentCameraId: this.currentCameraId,
      confirm: this.onConfirms,
      surfaceIdone: this.surfaceIdone
    }),
    openAnimation: {
      duration: 500
    },
    gridCount: 12,
    alignment: DialogAlignment.Center,
    customStyle: true
  });

  getSupportedCamerasFn(): Boolean {
    return this.cameraManager!.getSupportedCameras().length >= 1;
  }

  getSupportedCamerasFns(): Boolean {
    return this.cameraManager!.getSupportedCameras().length >= 2;
  }

  switchFunction() {
    // 2秒防抖
    if (this.debounce) {
      let unTrustDeviceLisTimer = 0;
      let trustDeviceLisTimer = 0;
      this.debounce = false;
      this.isDiscovering = !this.isDiscovering;
      this.buttonDescribe = this.isDiscovering ? $r('app.string.startDiscoverDevice') : $r('app.string.clickToDiscoverDevice');
      this.buttonColor = this.isDiscovering ? 'red' : 'blue';
      if (this.isDiscovering) {
        remoteDeviceModel.startDiscovering();

        unTrustDeviceLisTimer = setInterval(() => {
          this.unTrustDeviceList = remoteDeviceModel.getUnTrustDeviceList() as DeviceBasicInfo[];
          if (this.unTrustDeviceList?.length) {
            this.unTrustDeviceList.forEach((obj: DeviceBasicInfo, index: number) => {
              obj.id = Number(index) + 1;
            });
          } else {
            this.unTrustDeviceList = [];
          }
        }, 1000);

        trustDeviceLisTimer = setInterval(() => {
          this.trustDeviceList =
            this.isDiscovering ? remoteDeviceModel.getAvailableDeviceList() as DeviceBasicInfo[] : [];
          if (this.trustDeviceList?.length) {
            this.trustDeviceList.forEach((obj: DeviceBasicInfo, index: number) => {
              obj.id = Number(index) + 1;
            });
          } else {
            this.trustDeviceList = [];
          }
        }, 1000);

      } else {
        clearInterval(unTrustDeviceLisTimer);
        clearInterval(trustDeviceLisTimer);
        remoteDeviceModel.stopDiscovering();
      }
      setTimeout(() => {
        this.debounce = true;
      }, 2000);
    } else {
      promptAction.showToast({
        message: $r('app.string.clickToLongToStop'),
        duration: 1000,
      });
    }
  }

  async onConfirm(title: ResourceStr, deviceId: string, deviceName: string, path: string) {
    if (this.functionId == bindFunction) {
      Logger.info(TAG, 'bind init success!');
      remoteDeviceModel.bindTarget(deviceId);
      promptAction.showToast({
        message:$r('app.string.startDiscover0DeviceName',deviceName),
        duration: 5000,
      });
    } else if (this.functionId == unbindFunction) {
      Logger.info(TAG, 'unbind init success!');
      remoteDeviceModel.unbindTarget(deviceId);
      promptAction.showToast({
        message:$r('app.string.unbindDevice',deviceName),
        duration: 3000,
      });
    }
  }

  async onConfirms(currentCameraId: string, resArrItem: camera.CameraDevice, surfaceIdone: string) {
    if (surfaceIdone) {
      await CameraService.initCamera(surfaceIdone, resArrItem, this.netWorkId);
    }
    this.clickFocusBtn('tab22');
  }

  bindFunction(deviceId: string, deviceName: string) {
    if (this.trustDeviceList.some(item => item.deviceId === deviceId)) {
      promptAction.showToast({
        message: $r('app.string.trustAlert',deviceName),
        duration: 3000,
      });
    } else {
      this.title = $r('app.string.connectedDevice');
      this.content = $r('app.string.connectDeviceAlert',deviceName);
      this.deviceId = deviceId;
      this.deviceName = deviceName;
      this.path = '';
      this.functionId = bindFunction;
      this.controller.open();

    }
  }

  unBindFunction(deviceId: string, deviceName: string) {
    this.title = $r('app.string.deleteDevice');
    this.content = $r('app.string.deleteDeviceAlert',deviceName);
    this.deviceId = deviceId;
    this.deviceName = deviceName;
    this.path = '';
    this.functionId = unbindFunction;
    this.controller.open();

  }

  currentTabIndexChange() {
  }

  async aboutToAppear() {
    RemoteDeviceModel.createRemoteDeviceModel();
    Logger.info(TAG, 'DeviceMangerPage init success!');
  }

  async onPageShow() {
    if (this.surfaceIdone) {
      await CameraService.initCamera(this.surfaceIdone, undefined, this.netWorkId);
    }
    Logger.info(TAG, '----------onPageShow----------');
    let focusId = AppStorage.get<string>('focusTab') || 'tab11';
    focusControl.requestFocus(focusId);
  }

  async onPageHide() {
    if (this.surfaceIdone) {
      await CameraService.releaseCamera();
    }
    Logger.info(TAG, '----------onPageHide----------');
    AppStorage.setOrCreate<string>('focusTab', this.focusTab);
  }

  clickFocusBtn(id: string) {
    this.focusTab = id;
    AppStorage.setOrCreate<string>('focusTab', id);
    focusControl.requestFocus(id);
  }

  onBackPress(): boolean | void {
    (getContext() as common.UIAbilityContext).terminateSelf();
    return true;
  }

  build() {
    Column() {
      Row() {
        //第一个界面
        Row() {
          Column() {
            Row() {
              Column() {
                Text($r('app.string.trustDevice')).fontSize('48lpx').fontColor('#FFFFFF').fontWeight(FontWeight.Bold)
                Text('点击菜单键删除已认证设备').fontSize('30lpx').fontColor('#50FFFFFF').fontWeight(500)
                List({ scroller: this.listScroller1 }) {
                  ForEach(this.trustDeviceList, (item: DeviceBasicInfo, index: number
                  ) => {
                    ListItem() {
                      Column() {
                        Text(item.deviceName)
                          .fontSize('36lpx')
                          .fontColor(this.listFirstIndex == item.id ? Color.Black : Color.White)
                      }
                      .backgroundColor(this.listFirstIndex == item.id ? '#DEDEDE' : '#464648')
                      .width('860lpx')
                      .borderRadius('18lpx')
                      .height('114lpx')
                      .focusBox({
                        margin: LengthMetrics.px(5),
                        strokeColor: ColorMetrics.resourceColor(Color.White),
                        strokeWidth: LengthMetrics.px(2)
                      })
                      .justifyContent(FlexAlign.Center)
                      .alignItems(HorizontalAlign.Center)
                      .onClick(() => {
                        // 方便点击调试，遥控器需要删除这段
                        this.currentTabIndex = 1;
                        this.clickFocusBtn('tab22');
                        this.netWorkId = item.networkId;
                        Logger.info(TAG, 'clickIndex==='+item.deviceId+'===='+JSON.stringify(item)+'======='+item.deviceName);
                      })
                      .onKeyEvent((e) => {
                        if (e.keyCode == KeyCode.KEYCODE_MENU && e.type == KeyType.Up) {
                          this.unBindFunction(item.deviceId, item.deviceName);
                          e.stopPropagation();
                        }
                      });
                    }
                    .margin({ bottom: '24lpx' })
                    .height('114lpx')
                    .focusable(true)
                    .id('listFirst' + item.id)
                    .onFocus(() => {
                      this.listFirstIndex = item.id;
                      if (this.listFirstIndex == 1) {
                        this.listScroller1.scrollToIndex(0);
                      }
                    })
                    .onHover(()=>{
                      this.clickFocusBtn('listFirst' + item.id);
                    })
                    .onBlur(() => {
                      this.listFirstIndex = -1;
                    })
                    .width('100%')
                  }, (item: DeviceBasicInfo) => JSON.stringify(item))
                }.width('100%').margin({ top: '24lpx' })
              }
              .height('100%')
            }
            .margin({ top: '91lpx' })
            .alignItems(VerticalAlign.Top)
            .layoutWeight(1)

            Row() {
              Column() {
                Text($r('app.string.onlineDevice')).fontSize('48lpx').fontColor('#FFFFFF').fontWeight(FontWeight.Bold)
                List({ scroller: this.listScroller }) {
                  ForEach(this.unTrustDeviceList, (item: DeviceBasicInfo, index: number) => {
                    ListItem() {
                      Column() {
                        Text(item.deviceName + ' , ' + item.deviceId + ' , ' + item.deviceType + ' , ' + item.networkId)
                          .fontSize('36lpx')
                          .fontColor(this.listSecondIndex == item.id ? Color.Black : Color.White)
                      }
                      .backgroundColor(this.listSecondIndex == item.id ? '#DEDEDE' : '#464648')
                      .width('860lpx')
                      .borderRadius('18lpx')
                      .height('114lpx')
                      .focusBox({
                        margin: LengthMetrics.px(5),
                        strokeColor: ColorMetrics.resourceColor(Color.White),
                        strokeWidth: LengthMetrics.px(2)
                      })
                      .justifyContent(FlexAlign.Center)
                      .alignItems(HorizontalAlign.Center)
                      .onClick(() => {
                        this.bindFunction(item.deviceId, item.deviceName);
                      });
                    }
                    .height('114lpx')
                    .width('100%')
                    .margin({ bottom: '24lpx' })
                    .focusable(true)
                    .focusBox({
                      margin: LengthMetrics.px(5),
                      strokeColor: ColorMetrics.resourceColor(Color.White),
                      strokeWidth: LengthMetrics.px(2)
                    })
                    .id('listSecond' + item.id)
                    .onFocus(() => {
                      this.listSecondIndex = item.id;
                      if (this.listSecondIndex == 1) {
                        this.listScroller.scrollToIndex(0);
                      }
                    })
                    .onHover(()=>{
                      this.clickFocusBtn('listSecond' + item.id);
                    })
                    .onBlur(() => {
                      this.listSecondIndex = -1;
                    });
                  }, (item: DeviceBasicInfo) => JSON.stringify(item))
                }.width('100%').margin({ top: '24lpx' })
              }
            }
            .margin({ top: '24lpx' })
            .alignItems(VerticalAlign.Top)
            .width('100%')
            .layoutWeight(1)

            Row() {
              Button(this.buttonDescribe)
                .fontSize('36lpx')
                .fontWeight(FontWeight.Medium)
                .fontColor(Color.Black)
                .width('606lpx')
                .height('118lpx')
                .borderRadius('100lpx')
                .backgroundColor('#DEDEDE')
                .defaultFocus(true)
                .focusable(true)
                .focusBox({
                  margin: LengthMetrics.px(5),
                  strokeColor: ColorMetrics.resourceColor(Color.White),
                  strokeWidth: LengthMetrics.px(2)
                })
                .id('tab11')
                .onClick(() => {
                  this.clickFocusBtn('tab11');
                  this.switchFunction();
                });
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .focusable(true)
            .margin({ top: '24lpx',bottom:'113lpx' })
          }
          .width('100%').height('100%').padding({ top: '91lpx' })
        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Black)
        .visibility(this.currentTabIndex == 0 ? Visibility.Visible : Visibility.None)

        //第二个界面
        Row() {
          Column() {
            Stack({ alignContent: Alignment.Bottom }) {
              Column() {
                XComponent({
                  id: 'componentId',
                  type: XComponentType.SURFACE,
                  controller: this.mXComponentController
                })
                  .width('100%')
                  .height('100%')
                  .backgroundColor(Color.Black)
                  .onLoad(async () => {
                    Logger.info(TAG, 'onLoad is called');
                    this.mXComponentController.setXComponentSurfaceRect({ surfaceWidth: 1080, surfaceHeight: 1920 });
                    this.surfaceIdone = this.mXComponentController.getXComponentSurfaceId();
                    Logger.info(TAG, `onLoad surfaceId: ${this.surfaceIdone}`);
                    if (this.surfaceIdone) {
                      await CameraService.releaseCamera();
                      await CameraService.initCamera(this.surfaceIdone, undefined, this.netWorkId);
                    }
                  });

              }
              .width('100%')
              .height('100%')
              .backgroundColor(Color.Transparent)

              Row() {
                Column() {
                  Image($r('app.media.distributed_photography'))
                    .width('120lpx')
                    .height('120lpx')
                    .margin({ bottom: '12lpx' })
                    .focusable(true)
                    .focusBox({
                      margin: LengthMetrics.px(5),
                      strokeColor: ColorMetrics.resourceColor(Color.White),
                      strokeWidth: LengthMetrics.px(2)
                    })
                    .id('tab21')
                    .onHover(() => {
                      this.clickFocusBtn('tab21');
                    })
                    .onClick(() => {
                      Logger.info(TAG, 'takePicture begin');
                      let cameraString = CameraService.getSupportedCamerasString();
                      if (cameraString.length > 0) {
                        promptAction.showToast({ message: '拍照中...', duration: 200 });
                        CameraService.takePicture(this.surfaceIdone);
                      } else {
                        promptAction.showToast({
                          message: $r('app.string.pleaseConnectCamera'),
                          duration: 2000,
                        });
                      }
                    });
                  Text($r('app.string.camera')).fontSize('36lpx').fontColor(this.focusTab == 'tab21' ? '#0A59F7' : Color.White)
                }.width('114lpx').height('154lpx')
                .margin({ right: '248lpx' })

                Column() {
                  Image($r('app.media.distributed_multi'))
                    .width('120lpx')
                    .height('120lpx')
                    .margin({ bottom: '12lpx' })
                    .focusable(true)
                    .focusBox({
                      margin: LengthMetrics.px(5),
                      strokeColor: ColorMetrics.resourceColor(Color.White),
                      strokeWidth: LengthMetrics.px(2)
                    })
                    .id('tab22')
                    .onHover(() => {
                      this.clickFocusBtn('tab22');
                    })
                    .onClick(() => {
                      this.camerasList = CameraService.getSupportedCameras();
                      let cameraString = CameraService.getSupportedCamerasString();
                      if (cameraString.length > 0) {
                        this.currentCameraId = AppStorage.get<string>('cameraId') || this.camerasList[0].cameraId;
                        AppStorage.setOrCreate<string>('cameraId', this.currentCameraId);
                        this.camerasDialogController.open();
                      } else {
                        promptAction.showToast({
                          message:$r('app.string.noCameraDevice'),
                          duration: 2000
                        });
                      }
                    });
                  Text($r('app.string.multiCamera')).fontSize('36lpx').fontColor(this.focusTab == 'tab22' ? '#0A59F7' : Color.White)
                }.width('114lpx').height('154lpx')
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .backgroundColor(Color.Transparent)
              .height('154lpx')
              .margin({ bottom: '132lpx' })
            }.width('100%').height('100%').backgroundColor(Color.Transparent)
          }
          .width('100%').height('100%').backgroundColor(Color.Transparent)
        }
        .height('100%')
        .width('100%')
        .backgroundColor(Color.Transparent)
        .visibility(this.currentTabIndex == 1 ? Visibility.Visible : Visibility.None)

      }.width('100%').height('100%')
    }
    .width('100%')
    .height('100%')
    .focusable(true)
    .onKeyEvent(e => {
      if (e.keyCode == KeyCode.KEYCODE_ESCAPE) {
        router.back();
      }
      if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Up) {
        if (this.focusTab == 'tab21') {
          this.currentTabIndex = 0;
          this.clickFocusBtn('tab11');
        } else if (this.focusTab == 'tab22') {
          this.clickFocusBtn('tab21');
        } else if (this.focusTab == 'tab11') {
          (getContext() as common.UIAbilityContext).terminateSelf();
        }
      }
      if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Up) {
        if (this.focusTab == 'tab11') {
          this.currentTabIndex = 1;
          this.clickFocusBtn('tab21');
        } else if (this.focusTab == 'tab21') {
          this.clickFocusBtn('tab22');
        }
      }
    });
  }
}
