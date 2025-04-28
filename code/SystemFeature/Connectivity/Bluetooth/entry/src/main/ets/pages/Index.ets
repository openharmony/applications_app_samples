/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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
import logger from '../Model/Logger';
import { TitleBar } from '../Commom/TitleBar';
import { BusinessError } from '@ohos.base';
import access from '@ohos.bluetooth.access';
import common from '@ohos.app.ability.common';
import connection from '@ohos.bluetooth.connection';
import promptAction from '@ohos.promptAction';


const TAG: string = 'Index';
const TIME: number = 0; // 设备可被发现的持续时间

@Entry
@Component
struct Index {
  @State isOn: boolean = false;
  @State deviceList: Array<string> = [];
  @State discoveryList: Array<string> = [];
  @State changeValue: string = '';
  @State submitValue: string = '';
  @State isSearchState: boolean = false;
  @State deviceNames: string[] = [];
  private intervalId: number = -1;
  handlerClickButton = () => {
    let context = getContext(this) as common.UIAbilityContext;
    context.terminateSelf();
  }

  foundDevices() {
    connection.on('bluetoothDeviceFind', (data) => {
      logger.info(TAG, `enter on bluetoothDeviceFind`);
      let list = connection.getPairedDevices();
      if (list !== null && list.length > 0) {
        this.deviceList = list;
        logger.info(TAG, `deviceList =  ${JSON.stringify(this.deviceList)}`);
      }
      if (data !== null && data.length > 0) {
        if (this.discoveryList.indexOf(data[0]) === -1 && this.deviceList.indexOf(data[0]) === -1) {
          this.discoveryList.push(data[0]);
        }
        logger.info(TAG, `discoveryList = ${JSON.stringify(this.discoveryList)}`);
      }
    })
    try {
      connection.startBluetoothDiscovery();
    } catch (err) {
      const errCode = (err as BusinessError).code;
      const errMessage = (err as BusinessError).message;
      logger.error(TAG, 'startBluetoothDiscovery failed' + errCode + ', errMessage: ' + errMessage);
    }
    try {
      connection.setBluetoothScanMode(connection.ScanMode.SCAN_MODE_CONNECTABLE_GENERAL_DISCOVERABLE, TIME);
    } catch (err) {
      const errCode = (err as BusinessError).code;
      const errMessage = (err as BusinessError).message;
      logger.error(TAG, 'setBluetoothScanMode failed' + errCode + ', errMessage: ' + errMessage);
    }

  }

  async aboutToAppear() {
    let state = access.getState();
    if (state === access.BluetoothState.STATE_ON) {
      this.isOn = true;
      this.foundDevices();
    }
    if (state === access.BluetoothState.STATE_OFF) {
      this.isOn = false;
    }

    connection.on('pinRequired', (data) => {
      logger.info(TAG, `enter pinRequired`);
      logger.info(TAG, `onPinRequiredData = ${JSON.stringify(data)}`);
    })

    connection.on('bondStateChange', (data) => {
      logger.info(TAG, ` nter bondStateChange`);
      logger.info(TAG, `data = ${JSON.stringify(data)}`);
      if (data.state === connection.BondState.BOND_STATE_BONDED) {
        logger.info(TAG, `BOND_STATE_BONDED`);
        let index = this.discoveryList.indexOf(data.deviceId);
        this.discoveryList.splice(index, 1);
        this.deviceList = connection.getPairedDevices();
      }
      if (data.state === connection.BondState.BOND_STATE_INVALID) {
        logger.info(TAG, `BOND_STATE_INVALID`);
        this.deviceList = connection.getPairedDevices();
      }
      logger.info(TAG, `bondStateChange,data = ${JSON.stringify(data)}`);
    })

    this.intervalId = setInterval(() => {
      this.discoveryList = [];
      this.foundDevices();
    }, 30000)

  }

  async aboutToDisappear() {
    clearInterval(this.intervalId);
  }

  initBluetooth() {
    access.on('stateChange', (data) => {
      logger.info(TAG, `enter on stateChange`);
      if (data === access.BluetoothState.STATE_ON) {
        logger.info(TAG, ` nter BluetoothState.STATE_ON`);
        this.foundDevices();
      }
      if (data === access.BluetoothState.STATE_OFF) {
        logger.info(TAG, `enter BluetoothState.STATE_OFF`);
        connection.off('bluetoothDeviceFind', (data) => {
          logger.info(TAG, `offBluetoothDeviceFindData = ${JSON.stringify(data)}`);
        })
        try {
          connection.stopBluetoothDiscovery();
        } catch (err) {
          const errCode = (err as BusinessError).code;
          const errMessage = (err as BusinessError).message;
          logger.error(TAG + 'errCode: ' + errCode + ', errMessage: ' + errMessage);
        }
        this.discoveryList = [];
      }
      logger.info(TAG, `BluetoothState = ${JSON.stringify(data)}`);
    })
    access.enableBluetooth();
  }

  build() {
    Column() {
      TitleBar({ handlerClickButton: this.handlerClickButton })
      Scroll() {
        Column() {
          Row() {
            Column() {
              Text($r('app.string.bluetooth'))
                .fontSize(30)
                .margin({ top: 20 })
                .alignSelf(ItemAlign.Start)
              if (true === this.isOn) {
                Text($r('app.string.discovery'))
                  .fontSize(20)
                  .alignSelf(ItemAlign.Start)
              }
            }

            Blank()

            Column() {
              Toggle({ type: ToggleType.Switch, isOn: this.isOn })
                .selectedColor('#ff2982ea')
                .onChange((isOn: boolean) => {
                  if (isOn) {
                    this.isOn = true;
                    this.initBluetooth();
                  } else {
                    this.isOn = false;
                    try {
                      connection.stopBluetoothDiscovery();
                    } catch (err) {
                      const errCode = (err as BusinessError).code;
                      const errMessage = (err as BusinessError).message;
                      logger.error(TAG + 'errCode: ' + errCode + ', errMessage: ' + errMessage);
                    }
                    access.disableBluetooth();
                    this.deviceList = [];
                    this.discoveryList = [];
                  }
                })
            }
            .id('toggleBtn')
          }
          .width('90%')

          if (this.isOn) {
            Divider()
              .vertical(false)
              .strokeWidth(10)
              .color('#ffece7e7')
              .lineCap(LineCapStyle.Butt)
              .margin('1%')

            Text($r('app.string.paired_device'))
              .fontSize(25)
              .fontColor('#ff565555')
              .margin({ left: '5%' })
              .alignSelf(ItemAlign.Start)

            ForEach(this.deviceList, (item: string, index) => {
              Row() {
                Text(item)
                  .fontSize(20)
              }
              .alignSelf(ItemAlign.Start)
              .width('100%')
              .height(50)
              .margin({ left: '5%', top: '1%' })
              .id(`pairedDevice${index}`)
              .onClick(() => {
                AlertDialog.show({
                  title: $r('app.string.disconnect'),
                  message: '此操作将会断开您与以下设备的连接：' + item,
                  primaryButton: {
                    value: $r('app.string.cancel'),
                    action: () => {
                    }
                  },
                  secondaryButton: {
                    value: $r('app.string.confirm'),
                    action: () => {
                      connection.cancelPairedDevice(item).then(() => {
                        logger.info(TAG, `${item}cancelPairedDevice success`);
                        this.deviceList = connection.getPairedDevices();
                        this.discoveryList = [];
                        try {
                          connection.startBluetoothDiscovery();
                        } catch (err) {
                          const errCode = (err as BusinessError).code;
                          const errMessage = (err as BusinessError).message;
                          logger.error(TAG, 'startBluetoothDiscovery failed' + errCode + ', errMessage: ' + errMessage);
                        }
                      });
                    }
                  }
                })
              })
            })

            Divider()
              .vertical(false)
              .strokeWidth(10)
              .color('#ffece7e7')
              .lineCap(LineCapStyle.Butt)
              .margin('1%')

            Text($r('app.string.available_device'))
              .fontSize(25)
              .fontColor('#ff565555')
              .margin({ left: '5%', bottom: '2%' })
              .alignSelf(ItemAlign.Start)

            Column() {
              Search({ value: this.changeValue, placeholder: 'Type to search...' })
                .searchButton('SEARCH')
                .width('90%')
                .height(40)
                .backgroundColor('#F5F5F5')
                .placeholderColor(Color.Grey)
                .placeholderFont({ size: 14, weight: 400 })
                .textFont({ size: 14, weight: 400 })
                .onSubmit((value: string) => {
                  this.submitValue = value;
                  this.isSearchState = true;
                  this.searchResultList(value);
                  if (this.deviceNames.length === 0) {
                    promptAction.showToast({
                      message: $r('app.string.no_relevant_devices_found')
                    })
                  }
                })
                .onChange((value: string) => {
                  this.changeValue = value;
                  // 清空数据
                  this.deviceNames.splice(0, this.deviceNames.length);
                })
                .margin(20)

              ForEach(this.deviceNames, (item: string) => {
                Row() {
                  Text(item)
                    .fontSize(20)
                }
                .backgroundColor('#F5F5F5')
                .alignSelf(ItemAlign.Start)
                .width('100%')
                .height(50)
                .margin({ left: '5%', top: '1%' })
                .onClick(() => {
                  logger.info(TAG, `start bluetooth.pairDevice,item = ${item}`);
                  let pairStatus = connection.pairDevice(item);
                  logger.info(TAG, `pairStatus = ${pairStatus}`);
                })
              })
            }.width('100%')

            ForEach(this.discoveryList, (item: string) => {
              Row() {
                Text(item)
                  .fontSize(20)
              }
              .alignSelf(ItemAlign.Start)
              .width('100%')
              .height(50)
              .margin({ left: '5%', top: '1%' })
              .onClick(() => {
                logger.info(TAG, `start bluetooth.pairDevice,item = ${item}`);
                let pairStatus = connection.pairDevice(item);
                logger.info(TAG, `pairStatus = ${pairStatus}`);
              })

              Divider()
                .vertical(false)
                .color('#ffece7e7')
                .lineCap(LineCapStyle.Butt)
                .margin('1%')
            })
          }
        }
      }
      .constraintSize({ maxHeight: '85%' })
    }
  }

  searchResultList(value: string) {
    this.discoveryList.forEach(item => {
      if (item.includes(value)) {
        this.deviceNames.push(item);
      }
    })
  }
}