/*
 * Copyright (c) 2020-2023 Huawei Device Co., Ltd.
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

import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import common from '@ohos.app.ability.common'
import { NoteModel } from '../model/NoteDataModel'
import { NoteListItem } from '../common/NoteItem'
import NoteDataSource from '../common/BasicDataSource'
import { TitleBar } from '../common/TitleBar'
import { KvStoreModel } from '../model/KvStoreModel'
import { RemoteDeviceModel } from '../model/RemoteDeviceModel'
import { transStrToNoteModel } from '../model/NoteDataModel'
import Logger from '../util/Logger'

const NOTES_CHANGE = 'notesChange'
const EXIT = 'exit'
let kvStoreModel: KvStoreModel = new KvStoreModel()
let notesNum: number = 0
const TAG = 'KvstoreIndexPage'

@Entry
@Component
struct Index {
  private noteDataSource: NoteDataSource = new NoteDataSource([{ title: '', content: '' }])
  @State isDistributed: boolean = false
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel()

  aboutToAppear() {
    let context = getContext(this) as common.UIAbilityContext
    let atManager = abilityAccessCtrl.createAtManager()
    try {
      atManager.requestPermissionsFromUser(context,['ohos.permission.DISTRIBUTED_DATASYNC']).then((data) => {
        Logger.info(TAG, `data: ${JSON.stringify(data)}`)
      }).catch((err) => {
        Logger.info(TAG, `err: ${JSON.stringify(err)}`)
      })
    } catch (err) {
      Logger.info(TAG, `catch err->${JSON.stringify(err)}`);
    }
    let want = JSON.parse(AppStorage.Get('wantMsg'))
    Logger.info(TAG,`getWant =${JSON.stringify(want)}`);
    if (want.parameters.isStage === 'Stage') {
      this.isDistributed = true
    }
    kvStoreModel.setOnMessageReceivedListener(NOTES_CHANGE, (value) => {
      Logger.info(TAG,`NOTES_CHANGE${value}`)
      if (this.isDistributed) {
        if (value.search(EXIT) !== -1) {
          Logger.info(TAG,`[json]EXIT${EXIT}`)
          context.terminateSelf((error) => {
            Logger.info(TAG,`terminateSelf finished, error=${error}`)
          })
        } else {
          let str = value.substring(0, value.lastIndexOf('}]') + 2)
          this.noteDataSource['dataArray'] = transStrToNoteModel(str)
          this.noteDataSource.notifyDataReload()
          let strNum = value.substring(value.lastIndexOf('numBegin') + 'numBegin'.length, value.lastIndexOf('numEnd'))
          notesNum = Number(strNum)
        }
      }
    })
  }

  deleteNoteCallBack = (item: NoteModel) => {
    Logger.info(TAG, `deleteNote${JSON.stringify(item)}`);
    let dataArray: NoteModel[] = this.noteDataSource['dataArray']
    for (let i = 0;i < dataArray.length; i++) {
      Logger.info(TAG, `i = ${i} and dataArray = ${JSON.stringify(dataArray[i])}`)
      if (dataArray[i].title === item.title) {
        Logger.info(TAG, `deleteNote index` + i);
        this.noteDataSource['dataArray'].splice(i, 1)
        break
      }
    }
    this.noteDataSource.notifyDataReload()
    kvStoreModel.put(NOTES_CHANGE, JSON.stringify(this.noteDataSource['dataArray']) + 'numBegin' + notesNum + 'numEnd')
  }
  startAbilityCallBack = (key) => {
    Logger.info(TAG,`startAbilityCallBack${key}`);
    if (NOTES_CHANGE === key) {
      kvStoreModel.put(NOTES_CHANGE, `${JSON.stringify(this.noteDataSource['dataArray'])}numBegin${notesNum}numEnd`)
    }
    if (EXIT === key) {
      kvStoreModel.put(NOTES_CHANGE, EXIT)
    }
  }

  build() {
    Column() {
      TitleBar({
        startAbilityCallBack: this.startAbilityCallBack.bind(this),
        remoteDeviceModel: this.remoteDeviceModel,
        isDistributed: $isDistributed
      })

      Grid() {
        LazyForEach(this.noteDataSource, item => {
          GridItem() {
            NoteListItem({
              note: item,
              deleteNoteCallBack: this.deleteNoteCallBack
            })
          }
          .onClick(() => {
            Logger.info(TAG,`GridItem.click${item.title}`);
            if (item.title === '' && item.content === '') {
              notesNum += 1
              this.noteDataSource['dataArray'][this.noteDataSource['dataArray'].length-1] = {
                title: `note ${notesNum}`,
                content: 'noteContent'
              }
              this.noteDataSource['dataArray'].push({ title: '', content: '' })
              this.noteDataSource.notifyDataReload()
              if (this.isDistributed) {
                kvStoreModel.put(NOTES_CHANGE, `${JSON.stringify(this.noteDataSource['dataArray'])}numBegin${notesNum}numEnd`)
              }
            }
          })
        }, item => item.title)
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .padding(10)
      .margin({ bottom: 50 })
    }
  }

  onDestroy() {
    if (this.remoteDeviceModel !== null) {
      this.remoteDeviceModel.unregisterDeviceListCallback()
    }
    if (this.isDistributed) {
      this.isDistributed = false
    }
  }
}