/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start head]
// 导入usbManager模块
import { usbManager } from '@kit.BasicServicesKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';

// [End head]
@Entry
@Component
struct Index {
  @State logInfo_: string = '';
  @State deviceList_: usbManager.USBDevice[] = [];
  @State pipe_: usbManager.USBDevicePipe | undefined = undefined;
  @State interface_: usbManager.USBInterface | undefined = undefined;

  private getDevices() {
    // [Start getDevices]
    // 获取设备列表。
    let deviceList: usbManager.USBDevice[] = usbManager.getDevices();
    console.info(`deviceList: ${deviceList}`);
    this.logInfo_ += '\n[INFO] deviceList: ' + JSON.stringify(deviceList);
    if (deviceList === undefined || deviceList.length === 0) {
      console.error('deviceList is empty');
      this.logInfo_ += '\n[ERROR] deviceList is empty';
      return;
    }
    /*
      deviceList结构示例
      [
        {
          name: '1-1',
          serial: '',
          manufacturerName: '',
          productName: '',
          version: '',
          vendorId: 7531,
          productId: 2,
          clazz: 9,
          subClass: 0,
          protocol: 1,
          devAddress: 1,
          busNum: 1,
          configs: [
            {
              id: 1,
              attributes: 224,
              isRemoteWakeup: true,
              isSelfPowered: true,
              maxPower: 0,
              name: '1-1',
              interfaces: [
                {
                  id: 0,
                  protocol: 0,
                  clazz: 9,
                  subClass: 0,
                  alternateSetting: 0,
                  name: '1-1',
                  endpoints: [
                    {
                      address: 129,
                      attributes: 3,
                      interval: 12,
                      maxPacketSize: 4,
                      direction: 128,
                      number: 1,
                      type: 3,
                      interfaceId: 0,
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
     */
    this.deviceList_ = deviceList;
    // [End getDevices]
  }

  private requestRight() {
    // [Start requestRight]
    if (this.deviceList_ === undefined || this.deviceList_.length === 0) {
      console.error('deviceList is empty');
      this.logInfo_ += '\n[ERROR] deviceList is empty';
      return;
    }
    let deviceList: usbManager.USBDevice[] = this.deviceList_;
    let deviceName: string = deviceList[0].name;
    // 申请操作指定的device的操作权限。
    usbManager.requestRight(deviceName).then((hasRight: boolean) => {
      console.info('usb device request right result: ' + hasRight);
      this.logInfo_ += '\n[INFO] usb device request right result: ' + JSON.stringify(hasRight);
    }).catch((error: BusinessError) => {
      console.error(`usb device request right failed : ${error}`);
      this.logInfo_ += '\n[ERROR] usb device request right failed: ' + JSON.stringify(error);
    });
    // [End requestRight]
  }

  private connectDevice() {
    // [Start connectDevice]
    if (this.deviceList_ === undefined || this.deviceList_.length === 0) {
      console.error('deviceList_ is empty');
      this.logInfo_ += '\n[ERROR] deviceList is empty';
      return;
    }
    let deviceList: usbManager.USBDevice[] = this.deviceList_;
    if (!usbManager.hasRight(deviceList[0]?.name)) {
      console.error('permission denied');
      this.logInfo_ += '\n[ERROR] permission denied';
      return;
    }
    // 打开设备，获取数据传输通道。
    let pipe: usbManager.USBDevicePipe = usbManager.connectDevice(deviceList[0]);
    if (!deviceList?.[0]?.configs?.[0]?.interfaces?.[0]) {
      console.error('invalid interface');
      this.logInfo_ += '\n[ERROR] invalid interface';
      return;
    }
    let interface1: usbManager.USBInterface = deviceList?.[0]?.configs?.[0]?.interfaces?.[0];
    /*
      打开对应接口，在设备信息（deviceList）中选取对应的interface。
      interface1为设备配置中的一个接口。
     */
    usbManager.claimInterface(pipe, interface1, true);
    this.pipe_ = pipe;
    this.interface_ = interface1;
    console.info('open device success');
    this.logInfo_ += '\n[INFO] open device success';
    // [End connectDevice]
  }

  private bulkTransfer() {
    // [Start bulkTransfer]
    if (this.pipe_ === undefined || this.interface_ === undefined) {
      console.error('pipe_ or interface_ is null');
      this.logInfo_ += '\n[ERROR] pipe_ or interface_ is null';
      return;
    }
    let pipe: usbManager.USBDevicePipe = this.pipe_;
    let interface1: usbManager.USBInterface = this.interface_;
    /*
      读取数据，在device信息中选取对应数据接收的endpoint来做数据传输
     （endpoint.direction == 0x80）；dataUint8Array是要读取的数据，类型为Uint8Array。
     */
    let inEndpoint: usbManager.USBEndpoint = interface1.endpoints?.[1];
    let outEndpoint: usbManager.USBEndpoint = interface1.endpoints?.[0];
    let dataUint8Array: Uint8Array = new Uint8Array(1024);
    if (inEndpoint !== undefined && inEndpoint.direction === 0x80) {
      usbManager.bulkTransfer(pipe, inEndpoint, dataUint8Array, 15000).then((dataLength: number) => {
        if (dataLength >= 0) {
          console.info(`usb readData result Length : ${dataLength}`);
          this.logInfo_ += '\n[INFO] usb readData result Length: ' + JSON.stringify(dataLength);
        } else {
          console.error('usb readData failed');
          this.logInfo_ += '\n[ERROR] usb readData failed';
        }
      }).catch((error: BusinessError) => {
        console.error(`usb readData error : ${error}`);
        this.logInfo_ += '\n[ERROR] usb readData error: ' + JSON.stringify(error);
      });
    }

    // 发送数据，在device信息中选取对应数据发送的endpoint来做数据传输。（endpoint.direction == 0）
    if (outEndpoint !== undefined && outEndpoint.direction === 0) {
      usbManager.bulkTransfer(pipe, outEndpoint, dataUint8Array, 15000).then((dataLength: number) => {
        if (dataLength >= 0) {
          console.info(`usb writeData result write length : ${dataLength}`);
          this.logInfo_ += '\n[INFO] usb writeData result write length: ' + JSON.stringify(dataLength);
        } else {
          console.error('usb writeData failed');
          this.logInfo_ += '\n[ERROR] usb writeData failed';
        }
      }).catch((error: BusinessError) => {
        console.error(`usb writeData error : ${error}`);
        this.logInfo_ += '\n[ERROR] usb writeData error: ' + JSON.stringify(error);
      });
    }
    // [End bulkTransfer]
  }

  private controlTransfer() {
    // [Start controlTransfer]
    if (this.pipe_ === undefined) {
      console.error('pipe_ is null');
      this.logInfo_ += '\n[ERROR] pipe_ is null';
      return;
    }
    let pipe: usbManager.USBDevicePipe = this.pipe_;
    /*
      构造控制传输参数
     */
    let param: usbManager.USBDeviceRequestParams = {
      bmRequestType: 0x80, // 0x80指一次由设备到主机的标准请求命令
      bRequest: 0x06, // 0x06指获取描述符
      wValue: 0x01 << 8 | 0, // 该值为2个字节，高字节指描述符类型，此处0x01指设备描述符；低字节指描述符索引，设备描述符不涉及，填0
      wIndex: 0, // 索引值，可填0
      wLength: 18, // 描述符的长度，此处18表示设备描述符长度，最大支持1024
      data: new Uint8Array(18)
    };

    usbManager.usbControlTransfer(pipe, param).then((ret: number) => {
      console.info(`usbControlTransfer = ${ret}`);
      this.logInfo_ += '\n[INFO] usbControlTransfer = ' + JSON.stringify(ret);
    })
    // [End controlTransfer]
  }

  private interruptTransfer() {
    // [Start interruptTransfer_getEndpoint]
    if (this.deviceList_ === undefined || this.deviceList_.length === 0) {
      console.error('deviceList_ is empty');
      this.logInfo_ += '\n[ERROR] deviceList_ is empty';
      return;
    }
    let usbDevice: usbManager.USBDevice = this.deviceList_[0];
    if (!usbManager.hasRight(usbDevice.name)) {
      console.error('permission denied');
      this.logInfo_ += '\n[ERROR] permission denied';
      return;
    }
    let devicePipe: usbManager.USBDevicePipe = usbManager.connectDevice(usbDevice);
    let usbConfigs: usbManager.USBConfiguration[] = usbDevice.configs;
    let usbInterfaces: usbManager.USBInterface[] = [];
    let usbInterface: usbManager.USBInterface | undefined = undefined;
    let usbEndpoints: usbManager.USBEndpoint[] = [];
    let usbEndpoint: usbManager.USBEndpoint | undefined = undefined;
    for (let i = 0; i < usbConfigs?.length; i++) {
      usbInterfaces = usbConfigs[i]?.interfaces;
      for (let j = 0; j < usbInterfaces?.length; j++) {
        usbEndpoints = usbInterfaces[j]?.endpoints;
        usbEndpoint = usbEndpoints?.find((value) => {
          return value.direction === 128 && value.type === usbManager.UsbEndpointTransferType.TRANSFER_TYPE_INTERRUPT;
        })
        if (usbEndpoint !== undefined) {
          usbInterface = usbInterfaces[j];
          break;
        }
      }
    }
    if (usbEndpoint === undefined) {
      console.error(`get usbEndpoint error`)
      this.logInfo_ += '\n[ERROR] get usbEndpoint error';
      return;
    }
    // [End interruptTransfer_getEndpoint]
    // [Start interruptTransfer_claimInterface]
    // 注册通信接口，注册成功返回0，注册失败返回其他错误码。
    let claimInterfaceResult: number = usbManager.claimInterface(devicePipe, usbInterface, true);
    if (claimInterfaceResult !== 0) {
      console.error(`claimInterface error = ${claimInterfaceResult}`)
      this.logInfo_ += '\n[ERROR] claimInterface error = ' + JSON.stringify(claimInterfaceResult);
      return;
    }
    // [End interruptTransfer_claimInterface]
    // [Start interruptTransfer_interruptTransfer]
    let transferParams: usbManager.UsbDataTransferParams | undefined = undefined;
    try {
      // 通信接口注册成功，传输数据
      transferParams = {
        devPipe: devicePipe,
        flags: usbManager.UsbTransferFlags.USB_TRANSFER_SHORT_NOT_OK,
        endpoint: usbEndpoint.address,
        type: usbManager.UsbEndpointTransferType.TRANSFER_TYPE_INTERRUPT,
        timeout: 2000,
        length: 10,
        callback: () => {
        },
        userData: new Uint8Array(10),
        buffer: new Uint8Array(10),
        isoPacketCount: 2,
      };

      transferParams.callback = (err: Error, callBackData: usbManager.SubmitTransferCallback) => {
        console.info(`callBackData = ${callBackData}`);
        this.logInfo_ += '\n[INFO] callBackData = ' + JSON.stringify(callBackData);
        console.info(`transfer success,result = ${transferParams?.buffer}`);
        this.logInfo_ += '\n[INFO] transfer success,result = ' + JSON.stringify(transferParams?.buffer);
      }
      usbManager.usbSubmitTransfer(transferParams);
      console.info('USB transfer request submitted.');
      this.logInfo_ += '\n[INFO] USB transfer request submitted.';
    } catch (error) {
      console.error(`USB transfer failed: ${error}`);
      this.logInfo_ += '\n[ERROR] USB transfer failed: ' + JSON.stringify(error);
    }
    // [End interruptTransfer_interruptTransfer]
    // [Start interruptTransfer_release]
    try {
      usbManager.usbCancelTransfer(transferParams);
      usbManager.releaseInterface(devicePipe, usbInterface);
      usbManager.closePipe(devicePipe);
    } catch (error) {
      console.error(`release failed: ${error}`);
      this.logInfo_ += '\n[ERROR] release failed: ' + JSON.stringify(error);
    }
    // [End interruptTransfer_release]
  }

  private isochronousTransfer() {
    // [Start isochronousTransfer_getEndpoint]
    if (this.deviceList_ === undefined || this.deviceList_.length === 0) {
      console.error('deviceList_ is empty');
      this.logInfo_ += '\n[ERROR] deviceList_ is empty';
      return;
    }
    let usbDevice: usbManager.USBDevice = this.deviceList_[0];
    if (!usbManager.hasRight(usbDevice.name)) {
      console.error('permission denied');
      this.logInfo_ += '\n[ERROR] permission denied';
      return;
    }
    let devicePipe: usbManager.USBDevicePipe = usbManager.connectDevice(usbDevice);
    let usbConfigs: usbManager.USBConfiguration[] = usbDevice.configs;
    let usbInterfaces: usbManager.USBInterface[] = [];
    let usbInterface: usbManager.USBInterface | undefined = undefined;
    let usbEndpoints: usbManager.USBEndpoint[] = [];
    let usbEndpoint: usbManager.USBEndpoint | undefined = undefined;
    for (let i = 0; i < usbConfigs?.length; i++) {
      usbInterfaces = usbConfigs[i]?.interfaces;
      for (let j = 0; j < usbInterfaces?.length; j++) {
        usbEndpoints = usbInterfaces[j]?.endpoints;
        usbEndpoint = usbEndpoints?.find((value) => {
          // direction为请求方向，0表示写入数据，128表示读取数据
          return value.direction === 128 && value.type === usbManager.UsbEndpointTransferType.TRANSFER_TYPE_ISOCHRONOUS;
        })
        if (usbEndpoint !== undefined) {
          usbInterface = usbInterfaces[j];
          break;
        }
      }
    }
    if (usbEndpoint === undefined) {
      console.error(`get usbEndpoint error`);
      this.logInfo_ += '\n[ERROR] get usbEndpoint error';
      return;
    }
    // [End isochronousTransfer_getEndpoint]
    // [Start isochronousTransfer_claimInterface]
    // 注册通信接口，注册成功返回0，注册失败返回其他错误码。
    let claimInterfaceResult: number = usbManager.claimInterface(devicePipe, usbInterface, true);
    if (claimInterfaceResult !== 0) {
      console.error(`claimInterface error = ${claimInterfaceResult}`)
      this.logInfo_ += '\n[ERROR] claimInterface error = ' + JSON.stringify(claimInterfaceResult);
      return;
    }

    // 传输类型为“实时传输”时，需设置设备接口。设置成功返回0，注册失败返回其他错误码。
    if (usbEndpoint.type === usbManager.UsbEndpointTransferType.TRANSFER_TYPE_ISOCHRONOUS) {
      let setInterfaceResult = usbManager.setInterface(devicePipe, usbInterface);
      if (setInterfaceResult !== 0) {
        console.error(`setInterfaceResult error = ${setInterfaceResult}`)
        this.logInfo_ += '\n[ERROR] setInterfaceResult error = ' + JSON.stringify(setInterfaceResult);
        return;
      }
    }
    // [End isochronousTransfer_claimInterface]
    // [Start isochronousTransfer_isochronousTransfer]
    let transferParams: usbManager.UsbDataTransferParams | undefined = undefined;
    try {
      // 通信接口注册成功，传输数据
      transferParams = {
        devPipe: devicePipe,
        flags: usbManager.UsbTransferFlags.USB_TRANSFER_SHORT_NOT_OK,
        endpoint: usbEndpoint.address,
        type: usbManager.UsbEndpointTransferType.TRANSFER_TYPE_ISOCHRONOUS,
        timeout: 2000,
        length: 10,
        callback: () => {
        },
        userData: new Uint8Array(10),
        buffer: new Uint8Array(10),
        isoPacketCount: 2,
      };

      transferParams.callback = (err: Error, callBackData: usbManager.SubmitTransferCallback) => {
        console.info(`callBackData = ${callBackData}`);
        this.logInfo_ += '\n[INFO] callBackData = ' + JSON.stringify(callBackData);
        console.info('transfer success,result = ' + transferParams?.buffer.toString());
        this.logInfo_ += '\n[INFO] transfer success,result = ' + transferParams?.buffer.toString();
      }
      usbManager.usbSubmitTransfer(transferParams);
      console.info('USB transfer request submitted.');
      this.logInfo_ += '\n[INFO] USB transfer request submitted.';
    } catch (error) {
      console.error(`USB transfer failed: ${error}`);
      this.logInfo_ += '\n[ERROR] USB transfer failed: ' + JSON.stringify(error);
    }
    // [End isochronousTransfer_isochronousTransfer]
    // [Start isochronousTransfer_release]
    try {
      usbManager.usbCancelTransfer(transferParams);
      usbManager.releaseInterface(devicePipe, usbInterface);
      usbManager.closePipe(devicePipe);
    } catch (error) {
      console.error(`release failed: ${error}`);
      this.logInfo_ += '\n[ERROR] release failed: ' + JSON.stringify(error);
    }
    // [End isochronousTransfer_release]
  }

  private closePipe() {
    // [Start closePipe]
    if (this.pipe_ === undefined || this.interface_ === undefined) {
      console.error('pipe_ or interface_ is null');
      this.logInfo_ += '\n[ERROR] pipe_ or interface_ is null';
      return;
    }
    let pipe: usbManager.USBDevicePipe = this.pipe_;
    let interface1: usbManager.USBInterface = this.interface_;
    usbManager.releaseInterface(pipe, interface1);
    usbManager.closePipe(pipe);
    this.pipe_ = undefined;
    this.interface_ = undefined;
    console.info('close device success');
    this.logInfo_ += '\n[INFO] close device success';
    // [End closePipe]
  }

  build() {
    Column() {
      Row() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceBetween }) {
          TextArea({ text: this.logInfo_ })
            .height('100%')
            .width('100%')
            .fontSize(12)
            .onChange((value: string) => {
              this.logInfo_ = value;
            })
        }.height('100%').width('100%')
      }.height('45%')

      Row() {
        Button('获取设备列表', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {

            this.getDevices();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('获取设备操作权限', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.requestRight();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('打开设备', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.connectDevice();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('批量传输', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.bulkTransfer();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('控制传输', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.controlTransfer();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('中断传输', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.interruptTransfer();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('实时传输', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.isochronousTransfer();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('关闭设备', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.closePipe();
          })
          .width('100%')
      }.padding({ top: 10 })
    }.height('100%').width('100%').padding({ left: 10, right: 10 })
  }
}