/*
 * Copyright (c) 2023-2026 Huawei Device Co., Ltd.
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

import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { wantAgent, WantAgent } from '@kit.AbilityKit';
import { ble } from '@kit.ConnectivityKit';
import { constant } from '@kit.ConnectivityKit';

let TAG = "bt_js "
let serverDeviceId: string = ""
let gattClient: ble.GattClientDevice
let gattServer: ble.GattServer
let descValue2901 = string2ArrayBuffer("hello desc2901");
let characterValue = string2ArrayBuffer("hello characterValue")

function callback(info: backgroundTaskManager.ContinuousTaskSuspendInfo) {
  // 长时任务id
  console.info('OnContinuousTaskSuspend callback id ' + info.continuousTaskId);
  // 长时任务取消原因
  console.info('OnContinuousTaskSuspend callback reason ' + info.suspendReason);
}

function string2ArrayBuffer(str: string) {
  let array = new Uint8Array(str.length);
  for(let i = 0; i < str.length; i++) {
    array[i] = str.charCodeAt(i);
  }
  return array.buffer;
}

@Entry
@Component
struct BluetoothInteractionIndex {
  // 通过getUIContext().getHostContext()方法，来获取page所在的UIAbility上下文
  private context: Context | undefined = this.getUIContext().getHostContext();

  BLEDeviceFind() {
    console.info(TAG + 'BLEDeviceFind');
    ble.on('BLEDeviceFind', (data) => {
      console.info(TAG + 'BLEScan device' + JSON.stringify(data));
      data.forEach((item, index, array) => {
        console.log(TAG + `index: ${index}, deviceId:${item.deviceId}, rssi: ${item.rssi}, deviceName:  ${item.deviceName}`)
      })
      // 设置deviceId用于创建GattClientDevice
      if (data.length > 0) {
        serverDeviceId = data[0].deviceId;
        console.info(TAG + 'scan result serverDeviceId:' + serverDeviceId);
      }
      this.CreateGattClient();
      this.Connect();
      this.StopBleScan();
    });
  }

  StartBLEScan() {
    console.info(TAG + 'StartBLEScan')
    // 根据实际业务情况定义过滤器
    let filter1: ble.ScanFilter = {
      "name":"Mate 80 Pro",
      // "deviceId": "B2:47:9A:87:40:09",
    }
    let filterArray: Array<ble.ScanFilter> = new Array();
    filterArray.push(filter1);
    let scanOption: ble.ScanOptions = {
      "dutyMode": 0,
      "interval": 0,
      "matchMode":1
    };
    try {
      ble.startBLEScan(filterArray, scanOption);
    } catch (err) {
      console.error(TAG + `errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }

  CreateGattClient() {
    console.info(TAG + 'CreateGattClient');
    try {
      gattClient = ble.createGattClientDevice(serverDeviceId);
      console.info(TAG + 'CreateGattClient success');
    } catch (err) {
      console.info(TAG + `errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }

  Connect() {
    console.info(TAG + 'GattClient Connect');
    try {
      gattClient.connect();
    } catch (err) {
      console.info(TAG + `errCode: ${err.code}, errMessage: ${err.message}`);
    }
    gattClient.on('BLEConnectionStateChange', (state) => {
      console.info(TAG + 'GattClient BLEConnectionStateChange deviceId:' + state.deviceId + ' state: ' + state.state);
      if (state.state == constant.ProfileConnectionState.STATE_DISCONNECTED) {
        console.info(TAG + 'GattClient disconnected, startBleScan');
        this.StartBLEScan();
      }
    })
  }

  OnRegisterStateChangeClient() {
    console.info(TAG + 'GattClient on');
    try {
      gattClient.on('BLECharacteristicChange', (character) => {
        let value = new Uint8Array(character.characteristicValue);
        console.info(TAG + 'value' + value[0]);

      });
      gattClient.on('BLEConnectionStateChange', (state) => {
        console.info(TAG + 'GattClient BLEConnectionStateChange deviceId:' + state.deviceId + ' state: ' + state.state);
        if (state.state == constant.ProfileConnectionState.STATE_DISCONNECTED) {
          console.info(TAG + 'GattClient disconnected, startBleScan');
          this.StartBLEScan();
        }
      });
      gattClient.on('BLEMtuChange', (mtu) => {
        console.info(TAG + 'BLEMtuChange, mtu:' + mtu);
      });
    } catch (err) {
      console.info(TAG + `errCode: ${err.code}, errMessage: ${err.message}`);
    }

  }

  StopBleScan() {
    console.info(TAG + 'StopBleScan');
    try {
      ble.stopBLEScan();
    } catch (err) {
      console.info(TAG + `errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }

  // 申请长时任务.then()写法
  startContinuousTask() {
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      // 点击通知后，将要执行的动作列表
      // 添加需要被拉起应用的bundleName和abilityName
      wants: [
        {
          bundleName: 'ohos.samples.continuoustask',
          abilityName: 'MainAbility'
        }
      ],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG],
    };

    try {
      wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: WantAgent) => {
        try {
          let list: string[] = ['bluetoothInteraction'];
          backgroundTaskManager.startBackgroundRunning(this.context, list, wantAgentObj).
          then((res: backgroundTaskManager.ContinuousTaskNotification) => {
            console.info('Operation startBackgroundRunning succeeded');
          }).catch((error: BusinessError) => {
            console.error(`Failed to Operation startBackgroundRunning. code is ${error.code} message is ${error.message}`);
          });
        } catch (error) {
          console.error(`Failed to Operation startBackgroundRunning. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
        }
      });
    } catch (error) {
      console.error(`Failed to Operation getWantAgent. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  // 取消长时任务.then()写法
  stopContinuousTask() {
    backgroundTaskManager.stopBackgroundRunning(this.context).then(() => {
      console.info(`Succeeded in operationing stopBackgroundRunning.`);
    }).catch((err: BusinessError) => {
      console.error(`Failed to operation stopBackgroundRunning. Code is ${err.code}, message is ${err.message}`);
    });
  }

  OnContinuousTaskSuspend() {
    try {
      backgroundTaskManager.on('continuousTaskSuspend', callback);
      console.info(`Succeeded in operationing continuousTaskSuspend.`);
    } catch (error) {
      console.error(`Operation continuousTaskSuspend failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  OffContinuousTaskSuspend() {
    try {
      backgroundTaskManager.off('continuousTaskSuspend', callback);
      console.info(`Succeeded in operationing OffContinuousTaskSuspend.`);
    } catch (error) {
      console.error(`Operation OffContinuousTaskSuspend failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  AddGattServer() {
    let descriptors: Array<ble.BLEDescriptor> = [];
    let buf = new ArrayBuffer(1);
    let descrptor1: ble.BLEDescriptor = {
      "serviceUuid": "0000bbbb-0000-1000-8000-00805f9b34fb",
      "characteristicUuid": "0000bbbb-0000-1000-8000-00805f9b34fb",
      "descriptorUuid": "0000bbbb-0000-1000-8000-00805f9b34fb",
      "descriptorValue": buf,
      "permissions": {
        "read": true,
        // "readEncrypted": true,
        // "readEncryptedMitm": true,
        "write":true,
        // "writeEncrypted": true,
        // "writeEncryptedMitm": true,
        // "writeSigned": true,
        // "writeSignedMitm": true,
      },
    };
    let descrptor2: ble.BLEDescriptor = {
      "serviceUuid": "0000bbbb-0000-1000-8000-00805f9b34fb",
      "characteristicUuid": "0000bbbb-0000-1000-8000-00805f9b34fb",
      "descriptorUuid": "0000bbbb-0000-1000-8000-00805f9b34fb",
      "descriptorValue": string2ArrayBuffer('desc2901'),
    };
    descriptors.push(descrptor1);
    descriptors.push(descrptor2);

    let charateristatics: Array<ble.BLECharacteristic> = [];
    let charateristatic: ble.BLECharacteristic = {
      "serviceUuid": "0000bbbb-0000-1000-8000-00805f9b34fb",
      "characteristicUuid": "0000bbbb-0000-1000-8000-00805f9b34fb",
      "characteristicValue": string2ArrayBuffer("hello gatt character"),
      "descriptors": descriptors,
      "properties": {
        "write": true,
        // "writeNoResponse": true,
        "read": true,
        // "notify": true,
        // "broadcast": true,
        // "authenticatedSignedWrite": true,
        // "extendedProperties": true,
      },
      "permissions": {
        "read": true,
        // "readEncrypted": true,
        // "readEncryptedMitm": true,
        "write":true,
        // "writeEncrypted": true,
        // "writeEncryptedMitm": true,
        // "writeSigned": true,
        // "writeSignedMitm": true,
      },
    };
    charateristatics.push(charateristatic);
    let curGattService: ble.GattService = {
      "serviceUuid": "0000bbbb-0000-1000-8000-00805f9b34fb",
      "characteristics": charateristatics,
      "isPrimary":true,
      "includeServices": [],
    };

    try {
      gattServer.addService(curGattService);
    } catch (err) {
      console.error(TAG + `errCode is ${err.code}, message is ${err.message}`);
    }

  }

  StartAdvertising() {
    let advSettings: ble.AdvertiseSetting = {
      "interval": 200,
      "txPower": 0,
      "connectable": true,
    };
    let serviceUuidsArray: Array<string> = new Array();
    serviceUuidsArray.push("00001111-0000-1000-8000-00805f9b34fb");
    let advdata: ble.AdvertiseData = {
      "serviceUuids": serviceUuidsArray,
      "manufactureData": new Array(),
      "serviceData": new Array(),
      "includeDeviceName": true,
    };

    try {
      ble.startAdvertising(advSettings, advdata);
    } catch (err) {
      console.error(TAG + `errCode is ${err.code}, message is ${err.message}`);
    }
  }

  OnRegisterStateChangeServer() {
    gattServer.on("connectionStateChange", (data) => {
      console.info(TAG + `Succeeded in operationing stopBackgroundRunning.`);
    });
    gattServer.on("BLEMtuChange", (mtu) => {
      console.info(TAG + `BLEMtuChange mtu:` + mtu);
    });
    gattServer.on("descriptorWrite", (descriptorWriteRequest) => {
      console.info(TAG + `descriptorWrite`);
      if (descriptorWriteRequest.descriptorUuid == "00002901-0000-1000-8000-00805f9b34fb") {
        descValue2901 = descriptorWriteRequest.value;
        console.info(TAG + `onDescriptorWrite` + descValue2901);
      }

      gattServer.sendResponse({
        "status": 0,
        "offset": descriptorWriteRequest.offset,
        "value": descriptorWriteRequest.value,
        "deviceId": descriptorWriteRequest.deviceId,
        "transId": descriptorWriteRequest.transId,
      });
    });
    gattServer.on("characteristicWrite", (characterWriteRequest) => {
      console.info(TAG + `onCharacterWriteRequest`);
      if (characterWriteRequest.characteristicUuid == "0000BBBC-0000-1000-8000-00805F9B34FB") {
        characterValue = characterWriteRequest.value;
        console.info(TAG + `onCharacterWriteRequest` + characterValue);
      }

      gattServer.sendResponse({
        "status": 0,
        "offset": characterWriteRequest.offset,
        "value": characterWriteRequest.value,
        "deviceId": characterWriteRequest.deviceId,
        "transId": characterWriteRequest.transId,
      });
    });

  }

  build() {
    Row() {
      Column() {
        Text('蓝牙客户端')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Row() {
          Button("注册蓝牙设备监听").fontSize(10).height(40).onClick(() => {
            this.BLEDeviceFind();
          })

          Button("开始蓝牙扫描").fontSize(10).height(50).onClick(() => {
            this.StartBLEScan();
          })
        }

        Row() {
          Button("注册蓝牙连接状态监听").fontSize(10).height(40).onClick(() => {
            this.OnRegisterStateChangeClient();
          })

          Button("停止蓝牙扫描").fontSize(10).height(50).onClick(() => {
            this.StopBleScan();
          })
        }

        Button() {
          Text('申请蓝牙长时任务').fontSize(25).fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({ top: 10 })
        .backgroundColor('#0D9FFB')
        .width(250)
        .height(40)
        .id('applyContinuousTask')
        .onClick(() => {
          // 通过按钮申请蓝牙长时任务
          this.startContinuousTask();
        })

        Button() {
          Text('取消蓝牙长时任务').fontSize(25).fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({ top: 10 })
        .backgroundColor('#0D9FFB')
        .width(250)
        .height(40)
        .id('resetContinuousTask')
        .onClick(() => {
          // 此处结束具体的长时任务的执行

          // 通过按钮取消长时任务
          this.stopContinuousTask();
        })

        Button() {
          Text('注册暂停回调').fontSize(25).fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({ top: 10 })
        .backgroundColor('#0D9FFB')
        .width(250)
        .height(40)
        .onClick(() => {
          // 通过按钮注册长时任务取消回调
          this.OnContinuousTaskSuspend();
        })

        Button() {
          Text('解注册取消回调').fontSize(25).fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({ top: 10 })
        .backgroundColor('#0D9FFB')
        .width(250)
        .height(40)
        .onClick(() => {
          // 通过按钮取消注册长时任务取消回调
          this.OffContinuousTaskSuspend();
        })

        Text('蓝牙服务器')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Row() {
          Button("gattServerTest").fontSize(15).height(60).onClick(() => {
            console.info(TAG + 'gattServerTest');
            gattServer = ble.createGattServer();
            this.AddGattServer();
            this.StartAdvertising();
            this.OnRegisterStateChangeServer();
          })
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}