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
import remoteDeviceModel from '../models/RemoteDeviceModel';
import { promptAction } from '@kit.ArkUI';
import { distributedDeviceManager as deviceManager } from '@kit.DistributedServiceKit';
import RemoteDeviceModel from '../models/RemoteDeviceModel';
import { KeyCode } from '@kit.InputKit';
import DeviceConfirmDialog from '../Components/DeviceConfirmDialog';

const TAG = 'DeviceMangerPage';

@Builder
export function DistributedAttestationBuilder() {
  DeviceMangerPage();
}

@Component
export struct DeviceMangerPage {
  @State isDiscovering: boolean = false;
  @State buttonDescribe: string = '点击开始发现设备';
  @State buttonColor: string = '#33FFFFFF';
  @State fontColor: string = '#DBFFFFFF';
  @State title: string = '可信设备（已认证设备）';
  @State trustDeviceList: Array<deviceManager.DeviceBasicInfo> = [];
  @State unTrustDeviceList: Array<deviceManager.DeviceBasicInfo> = [];
  @State showDeviceList: Array<deviceManager.DeviceBasicInfo> = [];
  @State focusId: string = 'button';
  private listScroller: Scroller = new Scroller();
  private unTrustDeviceLisTimer: number = 0;
  private trustDeviceLisTimer: number = 0;
  @State dialogContent: string = '';
  @State dialogTitle: string = '';
  @State deviceId: string = '';
  @State deviceName: string = '';
  @State path: string = '';
  controller: CustomDialogController = new CustomDialogController({
    builder: DeviceConfirmDialog({
      confirm: this.onConfirm,
      content: this.dialogContent,
      title: this.dialogTitle,
      deviceId: this.deviceId,
      deviceName: this.deviceName,
      path: this.path,
    }),
    //autoCancel:false
    openAnimation: {
      duration: 500
    },
    gridCount: 12,
    alignment: DialogAlignment.Center,
    customStyle: true
  });

  async onConfirm(title: string, deviceId: string, deviceName: string, path: string) {
    if (title == '连接设备') {
      remoteDeviceModel.bindTarget(deviceId);
      promptAction.showToast({
        message: `开始连接${deviceName}...`,
        duration: 5000,
      });
    } else if (title == '删除设备') {
      remoteDeviceModel.unbindTarget(deviceId);
      promptAction.showToast({
        message: `开始解绑${deviceName}...`,
        duration: 3000,
      });
    }
  }

  async aboutToAppear() {
    // 初始化分布式model
    RemoteDeviceModel.createRemoteDeviceModel();
    // 进入页面就开始发现设备
    this.discoverDevice();
    // 进入分布式页面聚焦焦点
    this.requestFocus(this.focusId);
  }

  aboutToDisappear() {
    clearInterval(this.unTrustDeviceLisTimer);
    clearInterval(this.trustDeviceLisTimer);
    remoteDeviceModel.stopDiscovering();
  }

  switchFunction() {
    this.showDeviceList = [];
    this.isDiscovering = !this.isDiscovering;
    this.buttonDescribe = this.isDiscovering ? '正在发现设备' : '点击开始发现设备';
    this.buttonColor = this.isDiscovering ? '#DBFFFFFF' : '#33FFFFFF';
    this.fontColor = this.isDiscovering ? '#DB000000' : '#DBFFFFFF';
    this.title = this.isDiscovering ? '在线设备' : '可信设备';
    this.showDeviceList = this.isDiscovering ? this.trustDeviceList : this.unTrustDeviceList;
  }

  discoverDevice() {
    remoteDeviceModel.startDiscovering();

    this.unTrustDeviceLisTimer = setInterval(() => {
      this.unTrustDeviceList = remoteDeviceModel.getUnTrustDeviceList() || [];
      if (this.isDiscovering) {
        this.showDeviceList = this.unTrustDeviceList;
      }
    }, 1000);

    this.trustDeviceLisTimer = setInterval(() => {
      this.trustDeviceList = remoteDeviceModel.getAvailableDeviceList() || [];
      if (!this.isDiscovering) {
        this.showDeviceList = this.trustDeviceList;
      }
    }, 1000);

  }

  bindFunction(deviceId: string, deviceName: string) {
    if (this.trustDeviceList.some(item => item.deviceId === deviceId)) {
      promptAction.showToast({
        message: `${deviceName}已认证，请勿重复认证`,
        duration: 3000,
      });
    } else {
      this.dialogTitle = '连接设备';
      this.dialogContent = `确定要连接${deviceName}设备吗?`;
      this.deviceId = deviceId;
      this.deviceName = deviceName;
      this.path = '';
      this.controller.open();
    }
  }

  unBindFunction(deviceId: string, deviceName: string) {
    this.dialogTitle = '删除设备';
    this.dialogContent = `确定要删除${deviceName}设备吗？`;
    this.deviceId = deviceId;
    this.deviceName = deviceName;
    this.path = '';
    this.controller.open();
  }

  requestFocus(focusId: string) {
    this.focusId = focusId;
    focusControl.requestFocus(focusId);
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Column() {
            Text(this.title)
              .fontSize('48lpx')
              .lineHeight('56lpx')
              .fontWeight(500)
              .fontColor('#E6FFFFFF')
              .margin({ top: '100lpx' })
              .visibility(!this.isDiscovering && this.showDeviceList.length === 0 ? Visibility.Hidden :
                Visibility.Visible);
            if (this.showDeviceList.length === 0) {
              Row() {
                Image($rawfile('NoDeveice.svg'))
                  .width('509lpx')
                  .objectFit(ImageFit.Cover)
                  .clip(true);
              }.layoutWeight(1);
            } else {
              List({ scroller: this.listScroller }) {
                ForEach(this.showDeviceList, (item: deviceManager.DeviceBasicInfo) => {
                  ListItem() {
                    Row() {
                      Column() {
                        Text(item.deviceName + ' , ' + item.deviceId + ' , ' + item.deviceType + ' , ' +
                        item.networkId)
                          .fontWeight(500)
                          .fontSize('36lpx')
                          .lineHeight('42lpx')
                          .fontColor('#DBFFFFFF')
                          .wordBreak(WordBreak.BREAK_ALL)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                          .maxLines(2);
                      }
                      .width('840lpx')
                      .height('150lpx')
                      .padding({
                        top: '33lpx',
                        bottom: '33lpx',
                        left: '24lpx',
                        right: '24lpx'
                      })
                      .borderRadius('18lpx')
                      .backgroundColor('#33ffffff');
                    }
                    .border({
                      width: item.deviceId === this.focusId ? '2lpx' : '0lpx',
                      color: item.deviceId === this.focusId ? '#E5FFFFFF' : '',
                    })
                    .margin({ top: '24lpx' })
                    .borderRadius('18lpx')
                    .padding(item.deviceId === this.focusId ? '8lpx' : '0')
                    .id(item.deviceId)
                    .onHover(() => {
                      this.focusId = item.deviceId;
                    })
                    .onClick(() => {
                      if (this.isDiscovering) {
                        this.bindFunction(item.deviceId, item.deviceName);
                      } else {
                        this.unBindFunction(item.deviceId, item.deviceName);
                      }
                    });
                  }.width('100%');
                }, (item: deviceManager.DeviceBasicInfo) => JSON.stringify(item));
              }
              .layoutWeight(1);
            }
          }
          .height('100%')
          .focusable(true);
        }
        .alignItems(VerticalAlign.Top)
        .layoutWeight(1);

        Row() {
          Column() {
            Button(this.buttonDescribe)
              .width('384lpx')
              .height('90lpx')
              .fontWeight(500)
              .fontSize('36lpx')//.fontColor('#DBFFFFFF')
              .fontColor(this.fontColor)
              .backgroundColor(this.buttonColor)
              .onClick(() => {
                this.requestFocus('button');
                this.switchFunction();
              })
              .borderRadius('100lpx')
              .focusable(true)
              .defaultFocus(true)
              .id('button');
          }
          .border({
            width: '2lpx',
            color: this.focusId === 'button' ? '#E5FFFFFF' : 'transparent'
          })
          .borderRadius('100lpx')
          .padding('8lpx');
        }
        .margin({ top: '48lpx', bottom: '132lpx' })
        .alignItems(VerticalAlign.Top);
      }
      .width('100%')
      .height('100%');
    }
    .hideTitleBar(true)
    .backgroundColor('#18181A')
    .onKeyEvent((event) => {
      event.stopPropagation();
      if (event.keyCode === KeyCode.KEYCODE_ENTER && event.type === KeyType.Up) {
        if (this.focusId === 'button') {

        } else {

        }
      } else if (event.keyCode === KeyCode.KEYCODE_DPAD_UP && event.type === KeyType.Up) {
        if (this.focusId === 'button') {
          if (this.showDeviceList.length > 0) {
            this.requestFocus(this.showDeviceList[0].deviceId);
            this.listScroller.scrollToIndex(0);
          }
        } else {
          let currentIndex = this.showDeviceList.findIndex((item) => item.deviceId === this.focusId);
          if (currentIndex !== -1 && currentIndex > 0) {
            currentIndex--;
            this.requestFocus(this.showDeviceList[currentIndex].deviceId);
            this.listScroller.scrollToIndex(currentIndex);
          } else {
            this.requestFocus('button');
          }
        }
      } else if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN && event.type === KeyType.Up) {
        let currentIndex = this.showDeviceList.findIndex((item) => item.deviceId === this.focusId);
        if (currentIndex !== -1) {
          if (currentIndex < this.showDeviceList.length - 1) {
            currentIndex++;
            this.requestFocus(this.showDeviceList[currentIndex].deviceId);
            this.listScroller.scrollToIndex(currentIndex);
          } else {
            this.requestFocus('button');
          }
        } else {
          this.requestFocus('button');
        }
      }
    });
  }
}
