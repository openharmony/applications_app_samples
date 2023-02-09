/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import deviceManager from '@ohos.distributedHardware.deviceManager'
import router from '@ohos.router'
import { BUNDLE, ABILITY } from '../model/Const'
import DeviceDialog from '../common/DeviceDialog'
import DistributedObjectModel from '../model/DistributedObjectModel'
import Logger from '../model/Logger'
import Note from '../model/Note'
import NoteDataSource from '../common/BasicDataSource'
import NoteItem from '../common/NoteItem'
import RemoteDeviceModel from '../model/RemoteDeviceModel'
import TitleBar from '../common/TitleBar'
const TAG: string = 'Index'

@Entry
@Component
struct Index {
  private dialogController?: CustomDialogController
  private selectedIndex: number = 0
  private sessionId: string = ''
  @StorageLink('sessionId') globalSessionId: string = ''
  @StorageLink('objectModel') globalObject: DistributedObjectModel = new DistributedObjectModel()
  @State devices: Array<deviceManager.DeviceInfo> = []
  @State isOnline: boolean = false
  @State notes: Array<Note> = []
  private noteDataSource : NoteDataSource = new NoteDataSource()

  onPageShow() {
    this.noteDataSource['dataArray'] = this.globalObject.distributedObject.documents
    this.noteDataSource.notifyDataReload()
    Logger.info(TAG, `this.sessionId = ${this.sessionId}`)
    Logger.info(TAG, `globalSessionId = ${this.globalSessionId}`)
    if (this.sessionId !== this.globalSessionId) {
      this.sessionId = this.globalSessionId
      this.share()
    }
  }

  share() {
    Logger.info(TAG, `sessionId = ${this.sessionId}`)
    this.globalObject.setChangeCallback(() => {
      this.noteDataSource['dataArray'] = this.globalObject.distributedObject.documents
      this.noteDataSource.notifyDataReload()
    })
    this.globalObject.setStatusCallback((session, networkId, status) => {
      Logger.info(TAG, `StatusCallback,${status}`)
      if (status === 'online') {
        this.isOnline = true
      } else {
        this.isOnline = false
      }
    })
    this.globalObject.distributedObject.setSessionId(this.sessionId)
    AppStorage.SetOrCreate('objectModel', this.globalObject)
  }

  clearSelectState() {
    this.devices = []
    this.dialogController.close()
    this.dialogController = undefined
  }

  onSelectedDevice = (selectedIndex) => {
    this.selectedIndex = selectedIndex
    Logger.info(TAG, 'start ability ......')
    if (RemoteDeviceModel === null || RemoteDeviceModel.discoverDevices.length <= 0) {
      Logger.info(TAG, `start ability device:${JSON.stringify(this.devices)}`)
      this.startAbility(this.devices[this.selectedIndex].deviceId)
      this.clearSelectState()
      return
    }
    Logger.info(TAG, 'start ability, needAuth')
    RemoteDeviceModel.authenticateDevice(this.devices[this.selectedIndex], (device) => {
      Logger.info(TAG, 'auth and online finished')
      this.startAbility(device.deviceId)
    })
    Logger.info(TAG, 'start ability2 ......')
    this.clearSelectState()
  }

  startAbility(deviceId) {
    this.globalObject = new DistributedObjectModel()
    this.sessionId = this.globalObject.genSessionId()
    AppStorage.SetOrCreate('sessionId', this.sessionId)
    this.noteDataSource['dataArray'] = []
    this.noteDataSource.notifyDataReload()
    this.globalObject.off()
    this.share()
    Logger.info(TAG, `startAbility deviceId:${deviceId}`)
    let context = getContext(this) as any
    context.startAbility({
      bundleName: BUNDLE,
      abilityName: ABILITY,
      deviceId: deviceId,
      parameters: {
        sessionId: this.sessionId,
      }
    })
  }

  showDialog = () => {
    RemoteDeviceModel.registerDeviceListCallback(() => {
      Logger.info(TAG, 'registerDeviceListCallback, callback entered')
      this.devices = []
      this.devices = RemoteDeviceModel.discoverDevices.length > 0 ? RemoteDeviceModel.discoverDevices : RemoteDeviceModel.devices
      if (this.dialogController) {
        this.dialogController.close()
        this.dialogController = undefined
      }
      this.dialogController = new CustomDialogController({
        builder: DeviceDialog({
          devices: this.devices,
          onSelectedIndexChange: this.onSelectedDevice
        }),
        autoCancel: true
      })
      this.dialogController.open()
    })
  }

  build() {
    Column() {
      TitleBar({ rightBtn: $r('app.media.trans'), onRightBtnClicked: this.showDialog })

      Row() {
        Text($r('app.string.state'))
          .fontSize(30)
        Image(this.isOnline ? $r('app.media.green') : $r('app.media.red'))
          .size({ width: 30, height: 30 })
          .objectFit(ImageFit.Contain)
      }
      .width('100%')
      .padding(16)

      List({ space: 10 }) {
        LazyForEach(this.noteDataSource, (item, index) => {
          ListItem() {
            NoteItem({ note: item, index: index })
          }
        }, item => item.title)
      }
      .width('95%')
      .margin(10)
      .layoutWeight(1)

      Row() {
        Column() {
          Image($r('app.media.clear'))
            .size({ width: 40, height: 40 })
          Text($r('app.string.clear'))
            .fontColor(Color.Red)
            .fontSize(20)
        }.layoutWeight(1)
        .key('clearNote')
        .onClick(() => {
          Logger.info(TAG, 'clear notes')
          this.noteDataSource['dataArray'] = []
          this.noteDataSource.notifyDataReload()
          this.globalObject.clear()
          AppStorage.SetOrCreate('sessionId', this.sessionId)
        })

        Column() {
          Image($r('app.media.add'))
            .size({ width: 40, height: 40 })
          Text($r('app.string.add'))
            .fontColor(Color.Black)
            .fontSize(20)
        }.layoutWeight(1)
        .key('addNote')
        .onClick(() => {
          router.push({
            url: 'pages/Edit',
            params: {
              note: new Note('', '', -1),
              isAdd: true
            }
          })
        })
      }
      .width('100%')
      .padding(10)
      .backgroundColor('#F0F0F0')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}