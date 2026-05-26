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
import {
  deviceControlComponent,
  deviceItemComponent,
  deviceRadio,
  deviceStatus,
  deviceSwitch,
  LocationInfo
} from './DeviceItemComponent';
import { image } from '@kit.ImageKit';
import DevicesManager from '../viewmodel/DevicesManager';
import {
  Device,
  DeviceLibraryAccess,
  InfConstants,
  InfDevice,
  InfDeviceState,
  Logger,
  PageViewUtils,
  ProtocolType
} from '@ohos/common';
import fs from '@ohos.file.fs';
import { SwitchControl, SwitchScreensControl, RestartControl } from '@ohos/common/src/main/ets/inf/ControlCmd';
import { BusinessError } from '@kit.BasicServicesKit';
import promptAction from '@ohos.promptAction';
import { ConnectType } from '@ohos/common/src/main/ets/inf/TypeEnum';
import {
  ConnectChangeAction,
  DeviceManagerFactory,
  MessageAction,
  ControlOption,
  QueryOption
} from '@ohos/device_manager';
import { ProfileServices } from './profileview/ViewModel';
import { parseProfileServices } from '../util/ThingModelParser';
import { ServiceDto } from './profileview/ThingModelDto';
import { scale } from '../util/ScreenAdaptation';

async function getPhoto(uri: string | undefined): Promise<image.PixelMap | undefined> {
  if (uri == undefined || uri.length == 0) {
    return;
  }
  try {
    let file = fs.openSync(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    file.tryLock(true);
    let photoSize = fs.statSync(file.fd).size;
    let buffer = new ArrayBuffer(photoSize);
    fs.readSync(file.fd, buffer);
    file.unlock();
    fs.closeSync(file);
    let imageSource: image.ImageSource = image.createImageSource(buffer);
    return await imageSource.createPixelMap();
  } catch (errData) {
  }
  return undefined;
}

@Component
export struct DeviceDetailDialog {
  @State deviceImage: image.PixelMap | ResourceStr | undefined = undefined;
  @State sheet: Boolean = false;
  @State deviceName: string | Resource = '';
  private deviceInfo: Device | null = null;
  @State switch: boolean = false;
  @State online: boolean = false;
  @State showSwanLinkDisp: boolean = false;
  @State locationStr: string = '';
  pageType: string = 'DeviceDetailDialog';
  private receiversType: string = 'DeviceDetailDialog';
  @State selectedValue: string = ''; // 初始选中哪个
  @State thingModelServices: ProfileServices[] = [];

  aboutToAppear() {
    let device = DevicesManager.getInstance().getConnectingDevice();
    Logger.warn('DeviceDetailDialog aboutToAppear', `===>device ${JSON.stringify(device)}`);
    if (device != undefined) {
      DeviceLibraryAccess.queryDevice(device.getProductID()).then((deviceInfo) => {
        Logger.info('DeviceDetailDialog aboutToAppear',
          `===>queryDevice queryDevice.then ${JSON.stringify(deviceInfo)}`);
        this.deviceInfo = deviceInfo;
        getPhoto(this.deviceInfo?.deviceIcons[0]).then((data) => {
          this.deviceImage = data;
        });
      });
    }
    if (device != undefined && device.getProtocolType() !== ProtocolType.VIRTUAL) {
      Logger.warn('DeviceDetailDialog aboutToAppear', `===>getProtocolType: ${device.getProtocolType()}`);
      this.online = true;
      let queryOption: QueryOption = {
        unionCode: device.getUnionCode(),
        deviceId: '',
        productId: device.getProductID(),
        protocolType: device.getSubProtocolType(),
        sids: ['switch']
      };
      DeviceManagerFactory.getDeviceManager().queryDeviceState(queryOption).then((result) => {
        Logger.warn('DeviceDetailDialog aboutToAppear', `===>queryOption queryDeviceState.then `);
      }).catch((error: BusinessError) => {
        console.error(`===>DeviceDetailPage queryDeviceState(switch) error code= ${error.code}`);
        if (error.code != InfConstants.SID_NOT_SUPPORT) {
          this.online = false;
        }
      });
      let queryOption2: QueryOption = {
        unionCode: device.getUnionCode(),
        deviceId: '',
        productId: device.getProductID(),
        protocolType: device.getSubProtocolType(),
        sids: ['gps']
      };
      DeviceManagerFactory.getDeviceManager().queryDeviceState(queryOption2).then((result) => {
        Logger.warn('DeviceDetailDialog aboutToAppear', `===>queryOption2 queryDeviceState.then `);
      }).catch((error: BusinessError) => {
        console.error(`DeviceDetailPage queryDeviceState(gps) error code= ${error.code}`);
      });
      let queryModelOption: QueryOption = {
        unionCode: device.getUnionCode(),
        deviceId: '',
        productId: device.getProductID(),
        protocolType: device.getSubProtocolType(),
        sids: ['thing_model']
      };
      // model请求
      DeviceManagerFactory.getDeviceManager().queryDeviceState(queryModelOption).then((result) => {
        Logger.warn('DeviceDetailDialog aboutToAppear', `===>queryModelOption queryDeviceState.then `);
      }).catch((error: BusinessError) => {
        console.error(`DeviceDetailPage queryDeviceState(model) error code= ${error.code}`);
      });
      // 快速打开页面，上一个页面的 aboutToDisappear 可能在在aboutToAppear 后执行
      this.receiversType = `${this.pageType}${new Date().getTime()}`;
      DeviceManagerFactory.getDeviceManager()
        .registerConnectStateChanged(this.receiversType, (connectChangeAction: ConnectChangeAction) => {
          Logger.warn('DeviceDetailDialog aboutToAppear',
            `===>ConnectStateChanged() state= ${connectChangeAction.action}`);
          if (connectChangeAction.unionCode != device?.getUnionCode()) {
            console.warn(`DeviceDetailPage ConnectStateChanged device not match`);
            return;
          }
          let action = connectChangeAction.action;
          this.online = action == ConnectType.ONLINE;
          if (action == ConnectType.OFFLINE) {
            Logger.warn('DeviceDetailDialog aboutToAppear', `===>action = ${action}`);
            promptAction.showToast({
              message: $r('app.string.devices_online'),
              duration: 2000,
            });
          }
        });
      DeviceManagerFactory.getDeviceManager()
        .registerMessageReceivers(this.receiversType,
          (messageAction: MessageAction) => {
            //DeviceManager.ets中的dispatchMessage调用，
            // 最终参数是callEvent中的this.dispatchMessage赋值的
            Logger.warn('DeviceDetailDialog aboutToAppear',
              `===>MessageReceivers() messageAction: ${JSON.stringify(messageAction)}, message= ${JSON.stringify(messageAction.message)}`);
            let messages = messageAction.message;
            if (messageAction.unionCode != device?.getUnionCode()) {
              console.warn(`DeviceDetailPage MessageReceivers device not match`);
              return;
            }
            messages.forEach((item): void => this.processMessage(item));
          });
    } else {
      this.online = false;
    }
    setTimeout(() => {
      PageViewUtils.tabClick();
    }, 1000);
  }

  aboutToDisappear(): void {
    DeviceManagerFactory.getDeviceManager().unRegisterConnectStateChanged(this.receiversType);
    DeviceManagerFactory.getDeviceManager().unRegisterMessageReceivers(this.receiversType);
  }

  private processMessage(infDeviceState: InfDeviceState) {
    let data = infDeviceState.data;
    if (infDeviceState.sid == 'switch') {
      let state = data['on'];
      this.switch = state == 1;
      console.debug(`===>DeviceDetailPage processMessage state= ${state}`);
    } else if (infDeviceState.sid == 'gps') {
      this.locationStr = `(${data['longitude']},${data['latitude']})`;
      console.debug(`===>DeviceDetailPage processMessage gps= ${this.locationStr}`);
    } else if (infDeviceState.sid == 'thing_model') {
      Logger.debug('DeviceDetailPage', `===>processMessage() data= ${JSON.stringify(data)}`);
      Logger.warn('DeviceDetailPage', `===>typeof services= ${typeof data['services']}`);
      const jsonString = JSON.stringify(data['services']);
      const servicesDto = JSON.parse(jsonString) as ServiceDto[];
      this.thingModelServices = parseProfileServices(servicesDto);
      console.debug(`===>DeviceDetailPage model= ${infDeviceState.sid}`);
      Logger.warn('DeviceDetailPage', `===>processMessage() data= ${JSON.stringify(this.thingModelServices)}`);
    }
  }

  /**
   * 返回当前连接的设备用于后续的控制
   * 只返回ble ,wifi ，iot 类型的连接设备
   * @returns
   */
  private getConnectingDevice(): undefined | InfDevice {
    let device = DevicesManager.getInstance().getConnectingDevice();
    if (device == undefined) {
      return undefined;
    }
    let protocolType = device.getProtocolType();
    Logger.info(`===>protocolType:device.getProtocolType(): ${protocolType}`);
    if (protocolType == ProtocolType.WIFI ||
      protocolType == ProtocolType.BLE) {
      return device;
    }
    return undefined;
  }

  private getControlOption(serviceId: string, controlJson: string): ControlOption | undefined {
    let device = this.getConnectingDevice();
    if (device == undefined) {
      return undefined;
    }
    let option: ControlOption = {
      unionCode: device.getUnionCode(),
      deviceId: '',
      productId: device.getProductID(),
      protocolType: device.getSubProtocolType(),
      serviceId: serviceId,
      controlJson: controlJson,
    };
    return option;
  }

  private controlDevice(option: ControlOption) {
    DeviceManagerFactory.getDeviceManager()
      .controlDevice(option)     //最后走到了IotHelper里面的controlDevice，向设备发消息主要是connectSession?.sendCommand
      .then((result) => {
        console.debug('===>deviceSwitch DeviceDetailDialog controlDevice success!');
      })
      .catch(() => {
        Logger.warn(`===>deviceSwitch: 指令发送失败，请检查设备连接状态`);
        promptAction.showToast({
          message: $r('app.string.cmd_send_failed'),
          duration: 2000,
        });
      });
  }

  build() {
    Column() {
      Column() {
        Grid() {
          GridItem() {
            deviceStatus({
              settingHeight: 'app.string.wh_value_80',
              settingTitle: $r('app.string.device_status_text'),
              online: this.online,
            });
          };

          if (!this.showSwanLinkDisp) {
            GridItem() {
              LocationInfo({
                settingHeight: 'app.string.wh_value_80',
                settingTitle: $r('app.string.position_information_text'),
                settingSubTitle: this.locationStr || $r('app.string.no_position'),
                settingIcon: $r('app.media.ic_public_arrow_right'),
              });
            };
          }

          if (this.showSwanLinkDisp) {
            GridItem() {
              deviceControlComponent({
                settingHeight: 'app.string.wh_value_80',
                settingTitle: $r('app.string.previousPicture'),
                settingIcon: $r('app.media.ic_public_previous'),
              }).onClick(() => {
                let switchControl = new SwitchScreensControl(0);
                let option = this.getControlOption(switchControl.getServiceId(), switchControl.getDataJson());
                if (option == undefined) {
                  return;
                }
                DeviceManagerFactory.getDeviceManager().controlDevice(option).then(() => {
                  console.debug('DeviceDetailDialog controlDevice 0 success!');
                }).catch((error: BusinessError) => {
                  console.error(`DeviceDetailDialog controlDevice 0 error code = ${error.code}`);
                });
              });
            };

            GridItem() {
              deviceControlComponent({
                settingHeight: 'app.string.wh_value_80',
                settingTitle: $r('app.string.nextPicture'),
                settingIcon: $r('app.media.ic_public_next'),
              }).onClick(() => {
                let switchControl = new SwitchScreensControl(1);
                let option = this.getControlOption(switchControl.getServiceId(), switchControl.getDataJson());
                if (option == undefined) {
                  return;
                }
                DeviceManagerFactory.getDeviceManager().controlDevice(option)
                  .then(() => {
                    console.debug('DeviceDetailDialog controlDevice 1 success!');
                  }).catch((error: BusinessError) => {
                  console.error(`DeviceDetailDialog controlDevice 1 error code = ${error.code}`);
                });
              });
            };
          }
        }
        .rowsTemplate('1fr')
        .columnsTemplate('1fr 1fr')
        .width('95%')
        .rowsGap(scale(15))
        .columnsGap(scale(15))
        .height($r('app.string.wh_value_100'))
        .margin({
          left: $r('app.string.distance_4'),
          top: $r('app.string.distance_8'),
          bottom: $r('app.string.distance_8')
        });

        Grid() {
          GridItem() {
            deviceRadio({
              settingHeight: 'app.string.wh_value_60',
              settingTitle: $r('app.string.button_text_reboot'),
              enabledSwitch: true,
              value: 'reboot',
              selectedValue: this.selectedValue,
              onChange: (value: string) => {
                //发送重启命令
                Logger.warn(`===>currnt checked value is: ${value}`);
                let restartControl = new RestartControl(0);
                let option = this.getControlOption(restartControl.getServiceId(), restartControl.getDataJson());
                Logger.warn(`===>重启deviceRadio option: this.getControlOption: ${JSON.stringify(option)}`);
                if (option == undefined) {
                  return;
                }
                this.controlDevice(option);
              }
            });
          };

          GridItem() {
            deviceRadio({
              settingHeight: 'app.string.wh_value_60',
              settingTitle: $r('app.string.button_text_hibernate'),
              enabledSwitch: true,
              value: 'hibernate',
              selectedValue: this.selectedValue,
              onChange: (value: string) => {
                //发送休眠命令
                Logger.warn(`===>currnt checked value is: ${value}`);
                let switchControl = new SwitchControl(0);
                let option = this.getControlOption(switchControl.getServiceId(), switchControl.getDataJson());
                Logger.warn(`===>休眠deviceRadio option: this.getControlOption: ${JSON.stringify(option)}`);
                if (option == undefined) {
                  return;
                }
                this.controlDevice(option);
              }
            });
          };

          GridItem() {
            deviceRadio({
              settingHeight: 'app.string.wh_value_60',
              settingTitle: $r('app.string.button_text_ScreenOn'),
              enabledSwitch: true,
              value: 'ScreenOn',
              selectedValue: this.selectedValue,
              onChange: (value: string) => {
                Logger.warn(`===>currnt checked value is: ${value}`);
                //发送亮屏命令
                let switchControl = new SwitchControl(1);
                let option = this.getControlOption(switchControl.getServiceId(), switchControl.getDataJson());
                Logger.warn(`===>亮屏deviceRadio option: this.getControlOption: ${JSON.stringify(option)}`);
                if (option == undefined) {
                  return;
                }
                this.controlDevice(option);
              }
            });
          };

          GridItem() {
            deviceRadio({
              settingHeight: 'app.string.wh_value_60',
              settingTitle: $r('app.string.button_text_ScreenOff'),
              enabledSwitch: true,
              value: 'ScreenOff',
              selectedValue: this.selectedValue,
              onChange: (value: string) => {
                Logger.warn(`===>currnt checked value is: ${value}`);
                //发送熄屏命令
                let switchControl = new SwitchControl(0);
                let option = this.getControlOption(switchControl.getServiceId(), switchControl.getDataJson());
                Logger.warn(`===>熄屏deviceRadio option: this.getControlOption: ${JSON.stringify(option)}`);
                if (option == undefined) {
                  return;
                }
                this.controlDevice(option);
              }
            });
          };
        }
        .rowsTemplate('1fr 1fr 1fr 1fr 1fr')
        .columnsTemplate('1fr')
        .width('95%')
        .rowsGap(scale(15))
        .height($r('app.string.wh_value_400'))
        .margin({
          left: $r('app.string.distance_4'),
          top: $r('app.string.distance_8'),
          bottom: $r('app.string.distance_8')
        });
      }
      .width('50%')
      .justifyContent(FlexAlign.Center);
    };
  }
}


