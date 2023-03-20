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

import data_rdb from '@ohos.data.relationalStore'
import common from '@ohos.app.ability.common'
import Want from '@ohos.app.ability.Want'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import router from '@ohos.router'
import Contact from '../model/Contact'
import ContactDataSource from '../common/BasicDataSource'
import LiteStore from '../model/LiteStore'
import Logger from '../model/Logger'
import RdbModel from '../model/RdbModel'
import { BottomBtn } from '../common/BottomBtn'
import { ContactItem } from '../common/ContactItem'
import { PopupMenu } from '../common/PopupMenu'
import { SyncState } from '../model/LiteStore'
import { SearchBar } from '../common/SearchBar'
import { TitleBar } from '../common/TitleBar'
import { TABLE_NAME, BUNDLE, ABILITY, SQL_CREATE_TABLE, COLUMNS } from '../model/RdbConst'

const TAG: string = 'Index'

@Entry
@Component
struct Index {
  private liteStore = new LiteStore("sync_state", getContext(this) as common.UIAbilityContext)
  private rdbModel = new RdbModel(TABLE_NAME, SQL_CREATE_TABLE, COLUMNS, getContext(this) as common.UIAbilityContext)
  private intervalId: number = undefined
  private contacts: ContactDataSource = new ContactDataSource()
  @State isMultiCheck: boolean = false
  @State isSelectedAll: boolean = false
  @State state: {
    popupMenu: boolean,
    isDistributed: boolean,
    isStage: boolean,
    selectedIndex: number,
    syncState: string,
    distributedDevice: string
  } = {
    popupMenu: false,
    isDistributed: false,
    isStage: false,
    selectedIndex: 0,
    syncState: SyncState.ManualSync,
    distributedDevice: ''
  }

  aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear')
    let context = getContext(this) as common.UIAbilityContext
    let atManager = abilityAccessCtrl.createAtManager()
    try {
      atManager.requestPermissionsFromUser(context, ['ohos.permission.DISTRIBUTED_DATASYNC']).then((data) => {
        Logger.info(TAG, `data: ${JSON.stringify(data)}`)
      }).catch((err) => {
        Logger.info(TAG, `err: ${JSON.stringify(err)}`)
      })
    } catch (err) {
      Logger.info(TAG, `catch err->${JSON.stringify(err)}`);
    }
  }

  getWant() {
    let want: Want = AppStorage.Get('want')
    if (this.state.isDistributed && want.parameters.isStage === 'EXIT') {
      Logger.info(TAG, 'isStage = EXIT')
      this.state.isStage = false
      this.state.isDistributed = false
      this.state.selectedIndex = 0
      this.state.distributedDevice = ''
      this.rdbModel.offDataChange()
    }
    if (!this.state.isDistributed && want.parameters.isStage === 'Stage') {
      Logger.info(TAG, 'isStage = Stage')
      this.state.isStage = true
      this.state.isDistributed = true
      this.state.distributedDevice = want.parameters.device.toString()
      let context = getContext(this) as common.UIAbilityContext
      context.startAbility({
        bundleName: BUNDLE,
        abilityName: ABILITY,
        deviceId: this.state.distributedDevice,
        parameters: {
          isStage: 'CONNECT'
        }
      })
      Logger.info(TAG, 'onDataChange')
      this.rdbModel.onDataChange(this.state.distributedDevice, (result) => {
        this.contacts['dataArray'] = result
        this.contacts.notifyDataReload()
      })
    }
  }

  async onPageShow() {
    try {
      await this.rdbModel.getRdbStore()
      this.intervalId = setInterval(() => {
        this.getWant()
      }, 1000)
      await this.getData()
    } catch (err) {
      Logger.error('onPageShow:' + JSON.stringify(err))
    }
  }

  async getData() {
    Logger.info(TAG, 'getData')
    let predicates = new data_rdb.RdbPredicates(TABLE_NAME)
    this.contacts['dataArray'] = await this.rdbModel.query(predicates)
    this.contacts.notifyDataReload()
    Logger.info(TAG, 'getData contacts count' + this.contacts['dataArray'].length)
    let syncState = await this.liteStore.getValue()
    this.state.syncState = `${syncState}`
    if (!this.state.isStage && this.state.isDistributed && syncState === SyncState.AutomaticSync) {
      await this.syncData()
    }
  }

  showDeleteDialog() {
    let deleteContacts = []
    this.contacts['dataArray'].forEach((contact) => {
      if (contact.isSelected) {
        deleteContacts.push(contact)
      }
    })
    if (deleteContacts.length == 0) {
      return
    }
    AlertDialog.show({
      message: $r('app.string.delete_contact'),
      primaryButton: {
        value: $r('app.string.sure'),
        fontColor: Color.Red,
        action: async () => {
          await this.rdbModel.deleteContacts(deleteContacts)
          await this.getData()
          this.quitMultiCheck()
        }
      },
      secondaryButton: {
        value: $r('app.string.cancel'),
        fontColor: Color.Blue,
        action: () => {
        }
      }
    })
  }

  handleClickContact(item, index) {
    Logger.info(TAG, `handleClickContact, item = ${JSON.stringify(item)}`)
    if (this.isMultiCheck) {
      let tempContacts = this.contacts['dataArray']
      this.contacts['dataArray'] = []
      tempContacts[index].isSelected = !item.isSelected
      this.contacts['dataArray'] = tempContacts
      this.contacts.notifyDataReload()
    } else {
      router.pushUrl({
        url: 'pages/ContactEdit',
        params: { contact: item, isInsert: false }
      })
    }
  }

  refreshSelectState(isSelect) {
    this.contacts['dataArray'].forEach((contact) => {
      contact.isSelected = isSelect
    })
    this.contacts.notifyDataReload()
  }

  quitMultiCheck() {
    this.isSelectedAll = false
    this.refreshSelectState(this.isSelectedAll)
    this.isMultiCheck = false
  }

  handleBottomBtnClick = (index) => {
    switch (index) {
      case 0:
        this.isSelectedAll = !this.isSelectedAll
        this.refreshSelectState(this.isSelectedAll)
        break
      case 1:
        this.showDeleteDialog()
        break
      case 2:
        this.quitMultiCheck()
        break
      default:
        break
    }
  }
  handleRightBtn = () => {
    this.state.popupMenu = !this.state.popupMenu
  }
  syncData = () => {
    Logger.info(TAG, 'sync data')
    let predicates = new data_rdb.RdbPredicates(TABLE_NAME)
    predicates.inAllDevices()
    this.rdbModel.syncData(predicates)
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column() {
        Stack() {
          if (this.state.isStage) {
            TitleBar()
          } else {
            TitleBar({ rightBtn: $r('app.media.more'), handleRightBtn: this.handleRightBtn })
          }
          if (this.state.isDistributed && !this.state.isStage && this.state.syncState === SyncState.ManualSync) {
            Row() {
              Blank()

              Image($r('app.media.ic_syncto'))
                .size({ width: 50, height: 60 })
                .onClick(this.syncData)
            }.width('80%')
          }
        }.width('100%')

        SearchBar()
        List() {
          LazyForEach(this.contacts, (item, index) => {
            ListItem() {
              ContactItem({ contact: item, isMultiCheck: $isMultiCheck })
            }
            .onClick(() => {
              this.handleClickContact(item, index)
            })
          }, item => item.id.toString())
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 10, right: 10 })
        .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 16, endMargin: 16 })
      }
      .width('100%')
      .height('100%')

      if (this.state.popupMenu) {
        PopupMenu({ state: $state, handleStartAbility: this.syncData })
      }

      BottomBtn({
        isMultiCheck: this.isMultiCheck,
        isSelectedAll: this.isSelectedAll,
        handleBottomBtnClick: this.handleBottomBtnClick
      })

      if (!this.isMultiCheck && !this.state.isStage) {
        Button() {
          Image($r('app.media.add'))
            .height('100%').width('100%')
            .objectFit(ImageFit.Contain)
            .align(Alignment.End)
        }
        .key('btnAdd')
        .size({ width: '15%', height: 80 })
        .margin({ right: 20, bottom: 50 })
        .type(ButtonType.Circle)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          Logger.info(TAG, 'onClick')
          router.pushUrl({
            url: 'pages/ContactEdit',
            params: { contact: new Contact(0, '', 0, '', ''), isInsert: true }
          })
        })
      }
    }
    .size({ width: '100%', height: '100%' })
  }

  async onBackPress() {
    Logger.info(TAG, 'onBackPress')
    let context = getContext(this) as common.UIAbilityContext
    context.startAbility({
      bundleName: BUNDLE,
      abilityName: ABILITY,
      deviceId: this.state.distributedDevice,
      parameters: {
        isStage: 'EXIT'
      }
    })
    this.rdbModel.offDataChange()
  }

  onPageHide() {
    Logger.info(TAG, 'onBackPress')
    clearInterval(this.intervalId)
  }
}