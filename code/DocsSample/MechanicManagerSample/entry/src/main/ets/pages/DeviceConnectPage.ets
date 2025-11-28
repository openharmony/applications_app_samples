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
import { access, connection } from '@kit.ConnectivityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { logger } from '../utils/Logger';
import { mechanicManager } from '@kit.MechanicKit';
import { JSON } from '@kit.ArkTS';

const TAG = '[DeviceConnect_Page] ';

interface broadcastParam {
  cust: string,
  device_name: string
}

interface deviceInfo {
  device_id: string,
  device_name: string
}

let param: broadcastParam = {
  cust: '123',
  device_name: ''
};

@Entry
@Component
struct DeviceConnectPage {
  @State message: string = '设备连接';
  @State deviceList: Array<string> = [];
  @State deviceName: string = '';
  @State param: broadcastParam = {
    cust: '123',
    device_name: ''
  };
  @State deviceInfoList: Array<deviceInfo> = [];

  // 定义配对状态变化函数回调
  onReceiveEvent(data: connection.BondStateParam) {
    logger.info(TAG + 'onReceiveEvent pair result: ' + JSON.stringify(data));
    logger.info(TAG + 'onReceiveEvent pair result data.state: ' + data.state.toString());
    this.deviceList = connection.getPairedDevices();
    this.deviceList.forEach(deviceId => {
      // 检查 device_id 是否已经存在于 deviceInfoList 中
      const exists = this.deviceInfoList.some(info => info.device_id === deviceId);

      if (!exists) {
        // 创建 deviceInfo 对象
        let deviceInfo: deviceInfo = {
          device_id: deviceId,
          device_name: this.getDeviceName(deviceId)
        };

        // 将 deviceInfo 对象添加到 deviceInfoList
        this.deviceInfoList.push(deviceInfo);
      }
    });
    logger.info(TAG + 'onReceiveEvent pair result this.deviceList: ' + JSON.stringify(this.deviceList));
    if (data.state == connection.BondState.BOND_STATE_BONDED) {
      logger.info(TAG + 'onReceiveEvent pair result data.state: ' + data.state.toString());
      logger.info(TAG + 'onReceiveEvent pair result this.deviceList: ' + JSON.stringify(this.deviceList));
    }
  }

  onPageShow(): void {
    logger.info(TAG + 'onPageShow');
    let state = access.getState();

    if (state == access.BluetoothState.STATE_ON) {
      this.deviceList = connection.getPairedDevices();
      this.deviceList.forEach(deviceId => {
        // 检查 device_id 是否已经存在于 deviceInfoList 中
        const exists = this.deviceInfoList.some(info => info.device_id === deviceId);

        if (!exists) {
          // 创建 deviceInfo 对象
          let deviceInfo: deviceInfo = {
            device_id: deviceId,
            device_name: this.getDeviceName(deviceId)
          };

          // 将 deviceInfo 对象添加到 deviceInfoList
          this.deviceInfoList.push(deviceInfo);
        }
      });
      logger.info(TAG + 'onPageShow pair this.deviceList: ' + JSON.stringify(this.deviceList));
      logger.info(TAG + 'onPageShow pair this.deviceInfoList: ' + JSON.stringify(this.deviceInfoList));
    }

    try {
      // 发起订阅
      connection.on('bondStateChange', this.onReceiveEvent);
    } catch (err) {
      logger.error(TAG + 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  getDeviceName(deviceId: string): string {
    logger.info(TAG + 'getDeviceName in. deviceId = ' + deviceId);
    try {
      let remoteDeviceName: string = connection.getRemoteDeviceName(deviceId);
      this.deviceName = remoteDeviceName;
      logger.info(TAG + 'getDeviceName in. deviceName = ' + this.deviceName);
    } catch (err) {
      this.deviceName = '';
      logger.error('get paired DeviceName errCode: ' + (err as BusinessError).code + ', errMessage: ' +
      (err as BusinessError).message);
    }
    return this.deviceName;
  }

  build() {
    Column() {
      Text(this.message)
        .id('DeviceConnectPageHelloWorld')
        .fontSize('35fp')
        .fontWeight(FontWeight.Bold)

      Divider()
        .vertical(false)
        .strokeWidth(10)
        .color('#ffece7e7')
        .lineCap(LineCapStyle.Butt)
        .margin('1%')

      Text('已配对的设备')
        .fontSize(25)
        .fontColor('#ff565555')
        .margin({ left: '5%' })
        .alignSelf(ItemAlign.Start)

      ForEach(this.deviceInfoList, (item: deviceInfo, index) => {
        Row() {

          Text(item.device_name)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ right: 10 })

          Text(item.device_id)
            .fontSize(16)
            .margin({ right: 30 })
            .onClick(() => {
              AlertDialog.show({
                title: '断开连接？',
                message: '此操作将会断开您与以下设备的连接：' + item,
                primaryButton: {
                  value: '取消',
                  action: () => {
                  }
                },
                secondaryButton: {
                  value: '确定',
                  action: () => {
                  }
                }
              })
            })

          Button('连接')
            .onClick(() => {
              logger.info(`onClick in`)
              this.deviceName = this.getDeviceName(item.device_id);
              this.param = {
                cust: '123',
                device_name: this.deviceName
              };
              logger.info(`this.param = ${JSON.stringify(this.param)} `)
              logger.info(`current mac : item = ${JSON.stringify(item)} `)
              logger.info(`current mac : item type = ${typeof (item)} `)

              try {
                mechanicManager.setUserOperation(mechanicManager.Operation.CONNECT, item.device_id,
                  JSON.stringify(this.param));
              } catch (err) {
                logger.error(`mechanicManager setUserOperation err: = ${err.message} `)
              }

            })
        }
        .alignSelf(ItemAlign.Start)
        .width('100%')
        .height(50)
        .margin({ left: '5%', top: '1%' })
        .id(`pairedDevice${index}`)
      })


    }
    .height('100%')
    .width('100%')
  }
}