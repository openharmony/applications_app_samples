/*
 * Copyright (c) 2020 Huawei Device Co., Ltd.
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

import featureAbility from '@ohos.ability.featureAbility'
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

@Entry
@Component
struct Index {
  private noteDataSource: NoteDataSource = new NoteDataSource([{ title: '', content: '' }])
  @State isDistributed: boolean = false
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel()

  aboutToAppear() {
    featureAbility.getContext()
      .requestPermissionsFromUser(['ohos.permission.DISTRIBUTED_DATASYNC'], 3, function (result) {
        Logger.info(`KvStore[IndexPage] grantPermission,requestPermissionsFromUser,result.requestCode=${result}`)
      })
    featureAbility.getWant((error, want) => {
      Logger.info('KvStore[IndexPage] featureAbility.getWant =' + JSON.stringify(want.parameters));
      if (want.parameters.isFA === 'FA') {
        this.isDistributed = true
      }
    })
    kvStoreModel.setOnMessageReceivedListener(NOTES_CHANGE, (value) => {
      Logger.info('kvstore[IndexPage] NOTES_CHANGE' + value)
      if (this.isDistributed) {
        if (value.search(EXIT) != -1) {
          Logger.info('[json]EXIT' + EXIT)
          featureAbility.terminateSelf((error) => {
            Logger.info('kvstore[IndexPage] terminateSelf finished, error=' + error)
          })
        } else {
          var str = value.substring(0, value.lastIndexOf('}]') + 2)
          this.noteDataSource['dataArray'] = transStrToNoteModel(str)
          this.noteDataSource.notifyDataReload()
          var strNum = value.substring(value.lastIndexOf('numBegin') + 'numBegin'.length, value.lastIndexOf('numEnd'))
          notesNum = Number(strNum)
        }
      }
    })
  }

  deleteNoteCallBack = (item) => {
    Logger.info('KvStore[IndexPage] deleteNote' + item);
    var index = this.noteDataSource['dataArray'].indexOf(item)
    this.noteDataSource['dataArray'].splice(index, 1)
    this.noteDataSource.notifyDataReload()
    kvStoreModel.put(NOTES_CHANGE, JSON.stringify(this.noteDataSource['dataArray']) + 'numBegin' + notesNum + 'numEnd')
  }

  startAbilityCallBack = (key) => {
    Logger.info('KvStore[IndexPage] startAbilityCallBack' + key);
    if (NOTES_CHANGE === key) {
      kvStoreModel.put(NOTES_CHANGE, JSON.stringify(this.noteDataSource['dataArray']) + 'numBegin' + notesNum + 'numEnd')
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
            Logger.info('KvStore[IndexPage] GridItem.click' + item.title);
            if (item.title === '' && item.content === '') {
              notesNum += 1
              this.noteDataSource['dataArray'][this.noteDataSource['dataArray'].length-1] = { title: '笔记' + notesNum, content: '笔记内容' }
              this.noteDataSource['dataArray'].push({ title: '', content: '' })
              this.noteDataSource.notifyDataReload()
              if (this.isDistributed) {
                kvStoreModel.put(NOTES_CHANGE, JSON.stringify(this.noteDataSource['dataArray']) + 'numBegin' + notesNum + 'numEnd')
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
    if (this.remoteDeviceModel != null) {
      this.remoteDeviceModel.unregisterDeviceListCallback()
    }
    if (this.isDistributed) {
      this.isDistributed = false
    }
  }
}