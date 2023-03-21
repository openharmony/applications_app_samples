/*
* Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import usb from '@ohos.usbV9'
import commonEventManager from '@ohos.commonEventManager'
import promptAction from '@ohos.promptAction'
import DeviceCustomDialog from '../common/DeviceCustomDialog'
import CheckEmptyUtils from '../utils/CheckEmptyUtils'
import DeviceAttribute from '../model/DeviceAttribute'
import DeviceList from '../common/DeviceList'
import Logger from '../model/Logger'

const TAG: string = '[Index]'
const DURATION: number = 1500

@CustomDialog
struct CustomUSBDeviceInfoDialog {
  private controller: CustomDialogController
  private device?: DeviceAttribute
  onCancel = () => {
    this.controller.close()
  }

  build() {
    Column() {
      DeviceCustomDialog({ device: this.device, onCancel: this.onCancel })
    }
    .width('80%')
  }
}

@Entry
@Component
struct Index {
  @State result: string = ''
  @State isListener: boolean = false
  @State isRefreshing: boolean = false
  @Provide('devicesList') devices: Array<DeviceAttribute> = []
  @State device: DeviceAttribute = new DeviceAttribute()
  @State isSubscribed: boolean = false
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomUSBDeviceInfoDialog({ device: this.device }),
    cancel: this.existApp,
    autoCancel: true
  })
  private commonEventSubscriber: any = undefined
  private eventTips = {
    ATTACHED: 'usual.event.hardware.usb.action.USB_DEVICE_ATTACHED',
    DETACHED: 'usual.event.hardware.usb.action.USB_DEVICE_DETACHED'
  }

  existApp() {
    Logger.info(TAG, 'Click the callback in the blank area')
  }

  listenerSwitch(isListener: boolean) {
    if (isListener) {
      this.subUsbListener()
    } else {
      this.unSubscriberListener()
    }
  }

  subUsbListener() {
    Logger.info(TAG, 'usb subUsbListener....')
    if (this.isSubscribed) {
      Logger.info(TAG, 'usb event already subscribed')
      return
    }
    let commonEventSubscribeInfo = {
      events: [commonEventManager.Support.COMMON_EVENT_USB_DEVICE_DETACHED, commonEventManager.Support.COMMON_EVENT_USB_DEVICE_ATTACHED]
    }
    let promise = commonEventManager.createSubscriber(commonEventSubscribeInfo)
    promise.then((data) => {
      promptAction.showToast({ message: $r('app.string.toast_start_listening'), duration: DURATION })
      Logger.info(TAG, 'usb CreateSubscriberCallBack....')
      this.commonEventSubscriber = data
      commonEventManager.subscribe(this.commonEventSubscriber, this.subscriberCallBack.bind(this))
      Logger.info(TAG, 'Subscriber.subscribe success')
      this.isSubscribed = true
    }).catch((err) => {
      Logger.info(TAG, `Subscriber.createSubscriber promise err = ${JSON.stringify(err)}`)
    })
  }

  subscriberCallBack(err, data) {
    Logger.info(TAG, `SubscriberCallBack  data = ${JSON.stringify(data)}`)
    if (data.event === this.eventTips.ATTACHED) {
      promptAction.showToast({ message: $r('app.string.toast_inserted'), duration: DURATION })
    } else {
      promptAction.showToast({ message: $r('app.string.toast_removed'), duration: DURATION })
    }
    this.getDeviceList()
  }

  getDeviceList() {
    Logger.info(TAG, `usb getDeviceList...`)
    this.devices = []
    let usbDevices: usb.USBDevice[] = usb.getDevices()
    Logger.info(TAG, `usb getDeviceList 000 is : ${JSON.stringify(usbDevices)}`)
    if (CheckEmptyUtils.isEmpty(usbDevices)) {
      Logger.info(TAG, `usbDevices is null`)
      return
    }
    if (CheckEmptyUtils.isEmptyArray(usbDevices)) {
      Logger.info(TAG, `usb getDeviceList is null`)
      this.result = 'device list is empty'
      return
    }
    for (let index = 0; index < usbDevices.length; index++) {
      Logger.info(TAG, `usb this.devices ${index} : ${JSON.stringify(this.devices)}`)
      let deviceAttribute = {
        version: usbDevices[index].version,
        serial: usbDevices[index].serial,
        productName: usbDevices[index].productName,
        manufacturerName: usbDevices[index].manufacturerName,
        name: usbDevices[index].name,
        productId: usbDevices[index].productId,
        vendorId: usbDevices[index].vendorId,
        busAddress: usbDevices[index].busNum,
        clazz: usbDevices[index].clazz,
        deviceAddress: usbDevices[index].devAddress
      }
      if (this.devices.indexOf(deviceAttribute) === -1) {
        this.devices.push(deviceAttribute)
      }
      Logger.info(TAG, `usb this.devices : ${JSON.stringify(this.devices)}`)
    }
  }

  unSubscriberListener() {
    if (!this.isSubscribed || CheckEmptyUtils.isEmpty(this.commonEventSubscriber)) {
      Logger.info(TAG, `usb event not subscribed`)
      return
    }
    promptAction.showToast({ message: $r('app.string.toast_listening_cancel'), duration: DURATION })
    Logger.info(TAG, `usb event unsubscribed`)
    commonEventManager.unsubscribe(this.commonEventSubscriber, () => {
      Logger.info(TAG, `usb event unsubscribed`)
    })
    this.isSubscribed = false
  }

  build() {
    Column() {
      Text($r('app.string.EntryAbility_label'))
        .height(50)
        .fontSize(25)
        .width('100%')
        .padding({ left: 10 })
        .fontColor(Color.White)
        .textAlign(TextAlign.Start)
        .backgroundColor('#0D9FFB')
        .fontWeight(FontWeight.Bold)

      Row() {
        Text($r('app.string.usb_listener'))
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .margin({ right: 70 })
        Toggle({ type: ToggleType.Switch, isOn: this.isListener })
          .key('startUSBMonitorSwitch')
          .selectedColor(0xed6f21)
          .switchPointColor(0xe5ffffff)
          .margin({ left: 70 })
          .onChange((isOn: boolean) => {
            Logger.info(TAG, `Component status:${isOn}`)
            this.isListener = !this.isListener
            this.listenerSwitch(this.isListener)
          })
      }
      .margin({ top: 50 })
      DeviceList({
        isRefreshing: $isRefreshing,
        device: $device,
        getDeviceList: () => {
          this.getDeviceList()
        },
        openDialog: () => {
          this.dialogController.open()
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}