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

import { BleAdvertisingManager } from '../bluetoothService/BluetoothAdvertising';
import { BleScanManager } from '../bluetoothService/BluetoothScan';
import { BluetoothSwitch } from '../bluetoothService/BluetoothSwitch'
import { GattClientManager, GattData } from '../bluetoothService/GattClientManager';
import { GattServerManager } from '../bluetoothService/GattServerManager';
import { ScanData } from '../common/ScanData';
import { ScanDialog } from '../common/ScanDialog';
import { AdvertisingDialog } from '../common/AdvertisingDialog';
import access from '@ohos.bluetooth.access';
import { ToastReport } from '../common/ToastReport';
import { ble } from '@kit.ConnectivityKit';
import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';


@Entry
@Component
struct bluetoothSample {
  private bluetoothSwitch: BluetoothSwitch = new BluetoothSwitch();
  private bleScanManager: BleScanManager = new BleScanManager();
  private bleAdvertisingManager: BleAdvertisingManager = new BleAdvertisingManager();
  private gattServerManager: GattServerManager = new GattServerManager();
  private gattClientManager: GattClientManager = new GattClientManager();
  @State scanData: ScanData[] = [];
  @State textValueOfDeviceName: string | undefined = '';
  @State inputValueOfDeviceName: string | undefined = '';
  @State textValueOfDeviceId: string | undefined = '';
  @State inputValueOfDeviceId: string | undefined = '';
  @State scanFlag: Boolean = true;
  @State textValueOfInterval: string = '';
  @State inputValueOfInterval: string = '';
  @State textValueOfManufactureId: string = '';
  @State textValueOfAdvManufactureId: string = '';
  @State inputValueOfManufactureId: string = '';
  @State inputValueOfAdvManufactureId: string = '';
  @State textValueOfManufactureValueBuffer: string = '';
  @State textValueOfAdvManufactureValueBuffer: string = '';
  @State inputValueOfAdvManufactureValueBuffer: Uint8Array = new Uint8Array;
  @State inputValueOfAdvServiceBuffer: Uint8Array = new Uint8Array;
  @State inputValueOfAdvServiceUuids: string = '';
  @State inputValueOfAdvIncludeDeviceName: boolean = false;
  @State textValueOfAdvIncludeDeviceName: string = '';
  @State textValueOfAdvServiceBuffer: string = '';
  @State textValueOfAdvServiceUuids: string = '';
  @State currentIndex: number = 0;
  @State gattState: number = 0;
  @State serviceResult: string = '';
  @State refresh: boolean = false;
  @State marText: string = '';
  gattData: GattData = new GattData();
  connectDeviceId: string = '';
  scroller: Scroller = new Scroller();
  @StorageLink('advertiserState') @Watch('onAdvertiserStateChange') advertiserState: ble.AdvertisingState =
    ble.AdvertisingState.STOPPED;

  onAdvertiserStateChange() {
    console.info(`onAdvertiserStateChange: advertiserState = ${JSON.stringify(this.advertiserState)}`)
  }

  getAdvertiserStateDescription(): ResourceStr {
    let description = 'Stopped'
    switch (this.advertiserState) {
      case ble.AdvertisingState.STARTED:
        description = 'Started';
        break
      case ble.AdvertisingState.ENABLED:
        description = 'Enable';
        break
      case ble.AdvertisingState.DISABLED:
        description = 'Disabled';
        break
      case ble.AdvertisingState.STOPPED:
        description = 'Stopped';
        break
    }
    return description
  }

  @Builder
  tabBuilder(title: ResourceStr, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#F111C1' : '#6B6B6B')
    }
  }

  @State state: number = access.getState();

  public FlushBlueToothState(): access.BluetoothState {
    return this.state = access.getState();
  }

  advDialogController: CustomDialogController | null = new CustomDialogController({
    builder: AdvertisingDialog({
      cancel: () => {
        this.onCancel()
      },
      confirm: () => {
        this.onAccept()
      },
      textValueOfAdvManufactureId: $textValueOfAdvManufactureId,
      inputValueOfAdvManufactureId: $inputValueOfAdvManufactureId,
      textValueOfAdvManufactureValueBuffer: $textValueOfAdvManufactureValueBuffer,
      inputValueOfAdvManufactureValueBuffer: $inputValueOfAdvManufactureValueBuffer,
      textValueOfAdvServiceUuids: $textValueOfAdvServiceUuids,
      inputValueOfAdvServiceUuids: $inputValueOfAdvServiceUuids,
      textValueOfAdvServiceBuffer: $textValueOfAdvServiceBuffer,
      inputValueOfAdvServiceBuffer: $inputValueOfAdvServiceBuffer,
      textValueOfAdvIncludeDeviceName: $textValueOfAdvIncludeDeviceName,
      inputValueOfAdvIncludeDeviceName: $inputValueOfAdvIncludeDeviceName
    }),
    cancel: this.exitApp,
    autoCancel: true,
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      console.info('reason=' + JSON.stringify(dismissDialogAction.reason))
      console.log('dialog onWillDismiss')
      if (dismissDialogAction.reason == DismissReason.PRESS_BACK) {
        dismissDialogAction.dismiss()
      }
      if (dismissDialogAction.reason == DismissReason.TOUCH_OUTSIDE) {
        dismissDialogAction.dismiss()
      }
    },
    alignment: DialogAlignment.Top,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 10,
  })
  scanDialogController: CustomDialogController | null = new CustomDialogController({
    builder: ScanDialog({
      cancel: () => {
        this.onCancel()
      },
      confirm: () => {
        this.onAccept()
      },
      textValueOfInterval: $textValueOfInterval,
      inputValueOfInterval: $inputValueOfInterval,
      textValueOfManufactureId: $textValueOfManufactureId,
      inputValueOfManufactureId: $inputValueOfManufactureId,
      textValueOfDeviceName: $textValueOfDeviceName,
      inputValueOfDeviceName: $inputValueOfDeviceName,
      textValueOfDeviceId: $textValueOfDeviceId,
      inputValueOfDeviceId: $inputValueOfDeviceId,
    }),
    cancel: this.exitApp,
    autoCancel: true,
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      console.info('reason=' + JSON.stringify(dismissDialogAction.reason))
      console.log('dialog onWillDismiss')
      if (dismissDialogAction.reason == DismissReason.PRESS_BACK) {
        dismissDialogAction.dismiss()
      }
      if (dismissDialogAction.reason == DismissReason.TOUCH_OUTSIDE) {
        dismissDialogAction.dismiss()
      }
    },
    alignment: DialogAlignment.Top,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 10,
  })

  aboutToDisappear() {
    this.scanDialogController = null
  }

  onCancel() {
  }

  onAccept() {
  }

  exitApp() {
  }

  build() {
    Column() {
      Row() {
        Text('Bluetooth')
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontSize(30)
      }

      Column() {
        Text('BlueTooth State: ' + (this.state ? 'Connected' : 'Disconnected'))
          .margin(10)
        Text('BleState: ' + this.getAdvertiserStateDescription())
          .fontColor(Color.Red)
          .margin(10)
        if (this.marText) {
          Marquee({ src: this.marText, start: true })
            .margin(10)
        }
      }

      Tabs() {
        TabContent() {
          Column({ space: 5 }) {
            Column({ space: 5 }) {
              Button($r('app.string.Set_filtering_parameters'))
                .width('80%')
                .onClick(() => {
                  if (this.scanDialogController != null) {
                    this.scanDialogController.open();
                  }
                })
              Button($r('app.string.StartScan'))
                .width('80%')
                .onClick(() => {
                  this.bleScanManager.setScanParameter(this.inputValueOfInterval, this.inputValueOfManufactureId,
                    this.inputValueOfDeviceName, this.inputValueOfDeviceId);
                  this.bleScanManager.startScan();
                })
              Button($r('app.string.StopScan'))
                .width('80%')
                .onClick(() => {
                  this.bleScanManager.stopScan();
                  this.scanFlag = false;
                })
              Button($r('app.string.Refresh'))
                .width('80%')
                .backgroundColor(Color.Red)
                .onClick(() => {
                  this.scanData = this.bleScanManager.getScanData();
                })
            }
            .height('25%')
            .margin({ top: 5 })

            Scroll(this.scroller) {
              Column() {
                ForEach(this.scanData, (item: ScanData) => {
                  Row() {
                    Text('deviceId: ' + item.getDeviceId() + '\n' + 'deviceName: ' + item.getDeviceName() + '\n' +
                      'rssi: ' + item.getRssi() + '\n' + 'connectable: ' + item.getConnectable())
                      .width('70%')
                      .height(100)
                      .backgroundColor(0xFFFFFF)
                      .borderRadius(15)
                      .fontSize(16)
                      .textAlign(TextAlign.JUSTIFY)
                      .margin(10)

                    Button('connect')
                      .width('20%')
                      .margin(10)
                      .onClick(() => {
                        this.connectDeviceId = item.getDeviceId();
                        this.gattClientManager.startConnect(this.connectDeviceId);
                        this.marText = 'deviceId: ' + item.getDeviceId() + ' deviceName: ' + item.getDeviceName() +
                          ' rssi: ' + item.getRssi() + ' connectable: ' + item.getConnectable();
                      })
                  }
                  .backgroundColor(0xFFFFFF)
                  .borderRadius(15)
                  .margin(10)
                });

              }.width('100%')
            }
            .margin({ top: 5 })
            .height('55%')
            .scrollable(ScrollDirection.Vertical)
            .scrollBar(BarState.On)
            .scrollBarColor(Color.White)
            .scrollBarWidth(10)
            .friction(0.6)
            .edgeEffect(EdgeEffect.None)
            .onWillScroll((xOffset: number, yOffset: number) => {
              console.info(xOffset + ' ' + yOffset);
            })
          }
          .height('100%')
        }
        .backgroundColor(Color.Gray)
        .tabBar(this.tabBuilder('SCANNER', 0))

        TabContent() {
          Column({ space: 5 }) {
            Scroll() {
              Text(this.serviceResult)
                .width('100%')
                .height('100%')
                .margin(30)
            }
            .width('80%')
            .height('20%')

            Row() {
              Text('serviceUuid: ')

              TextInput().onChange((value: string) => {
                this.gattData.serviceUuid = value;
              }).height('40vp').width('70%')
            }.width('80%')

            Row() {
              Text('characteristicUuid: ')

              TextInput().onChange((value: string) => {
                this.gattData.characteristicUuid = value;
              }).height('40vp').width('70%')
            }.width('80%')

            Row() {
              Text('descriptorUuid: ')

              TextInput().onChange((value: string) => {
                this.gattData.descriptorUuid = value;
              }).height('40vp').width('70%')
            }.width('80%')

            Row() {
              Text('characteristicValue: ')

              TextInput().onChange((value: string) => {
                this.gattData.characteristicValue = value;
              }).height('40vp').width('70%')
            }.width('80%')

            Row() {
              Text('descriptorValue: ')

              TextInput().onChange((value: string) => {
                this.gattData.descriptorValue = value;
              }).height('40vp').width('70%')
            }.width('80%')

            Button($r('app.string.DiscoverService'))
              .width('80%')
              .onClick(() => {
                this.gattClientManager.discoverServices().then(() => {
                  this.serviceResult = this.gattClientManager.getResult();
                })
              })

            Row({ space: 30 }) {
              Button($r('app.string.readChar'))
                .width('30%')
                .onClick(() => {
                  this.gattClientManager.readCharacteristicValue();
                })

              Button($r('app.string.writeChar'))
                .width('30%')
                .onClick(() => {
                  this.gattClientManager.setGattData(this.gattData);
                  this.gattClientManager.writeCharacteristicValue();
                })
            }

            Row({ space: 30 }) {

              Button($r('app.string.readDes'))
                .width('30%')
                .onClick(() => {
                  this.gattClientManager.readDescriptorValue();
                })

              Button($r('app.string.writeDes'))
                .width('30%')
                .onClick(() => {
                  this.gattClientManager.setGattData(this.gattData);
                  this.gattClientManager.writeDescriptorValue();
                })
            }

            Button($r('app.string.disconnect'))
              .width('80%')
              .backgroundColor(Color.Red)
              .onClick(() => {
                this.gattClientManager.stopConnect();
                this.marText = '';
                this.serviceResult = '';
              })
          }
          .width('100%')
          .height('100%')
        }
        .backgroundColor(Color.Pink)
        .tabBar(this.tabBuilder('GATT', 1))
        .width('100%')
        .height('100%')

        TabContent() {
          Row() {
            Column({ space: 12 }) {
              Button($r('app.string.registerServer'))
                .width('80%')
                .onClick(() => {
                  this.gattServerManager.registerServer();
                })

              Button($r('app.string.unRegisterServer'))
                .width('80%')
                .onClick(() => {
                  this.gattServerManager.unRegisterServer();
                })

              Button($r('app.string.RegisterReadChar'))
                .width('80%')
                .onClick(() => {
                  this.gattServerManager.onCharacteristicRead();
                })

              Button($r('app.string.RegisterWriteChar'))
                .width('80%')
                .onClick(() => {
                  this.gattServerManager.onCharacteristicWrite();
                })

              Button($r('app.string.RegisterReadDes'))
                .width('80%')
                .onClick(() => {
                  this.gattServerManager.onDescriptorRead();
                })

              Button($r('app.string.RegisterWriteDes'))
                .width('80%')
                .onClick(() => {
                  this.gattServerManager.onDescriptorWrite();
                })
            }
            .width('50%')

            Column({ space: 12 }) {
              Button($r('app.string.setAdv'))
                .width('80%')
                .onClick(() => {
                  this.advDialogController?.open();
                })

              Button($r('app.string.startAdv'))
                .width('80%')
                .onClick(() => {
                  this.bleAdvertisingManager.setAdvertisingParameter(Number(this.inputValueOfAdvManufactureId),
                    this.inputValueOfAdvManufactureValueBuffer, this.inputValueOfAdvServiceUuids,
                    this.inputValueOfAdvServiceBuffer, this.inputValueOfAdvIncludeDeviceName);
                  this.bleAdvertisingManager.startAdvertising();
                })

              Button($r('app.string.stopAdv'))
                .width('80%')
                .onClick(() => {
                  console.info('disable Advertising');
                  this.bleAdvertisingManager.disableAdvertising();
                  console.info('Advertising over');
                })

              Button($r('app.string.continueAdv'))
                .width('80%')
                .onClick(() => {
                  this.bleAdvertisingManager.enableAdvertising(0);
                })

              Button($r('app.string.closeAdv'))
                .width('80%')
                .onClick(() => {
                  this.bleAdvertisingManager.stopAdvertising();
                })
            }
            .width('50%')
          }
        }

        .backgroundColor(Color.Orange)
        .tabBar(this.tabBuilder('ADVERTISER', 2))

        TabContent() {
          Column({ space: 12 }) {
            Button($r('app.string.openBlueTooth'))
              .width('80%')
              .onClick(() => {
                this.state = access.getState();
                if (this.state == 0) {
                  this.bluetoothSwitch.openBluetooth();
                }
                setTimeout(() => {
                  this.state = access.getState();
                }, 2000)
                setTimeout(() => {
                  this.state = access.getState();
                }, 5000)
              })

            Button($r('app.string.closeBlueTooth'))
              .width('80%')
              .onClick(() => {
                this.state = access.getState();
                if (this.state == 2) {
                  try {
                    this.bluetoothSwitch.closeBluetooth();
                  } catch (err) {
                    console.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' +
                    (err as BusinessError).message);
                  }
                }
                setTimeout(() => {
                  this.state = access.getState();
                }, 2000)
              })
          }
        }
        .backgroundColor(Color.Yellow)
        .tabBar(this.tabBuilder('SWITCH', 3))
      }
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .backgroundColor('#F1F3F5')
    }
  }
}

