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

import router from '@ohos.router'
import Logger from '../model/Logger'
import { AccountData } from '../model/AccountData'
import { AccountModel } from '../model/AccountModel'

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount() {
    return 0
  }

  public getData(index: number) {
    return undefined
  }

  registerDataChangeListener(listener: DataChangeListener) {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener) {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  notifyDataReload() {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index)
    })
  }

  notifyDataChange(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataChange(index)
    })
  }

  notifyDataDelete(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index)
    })
  }

  notifyDataMove(from: number, to: number) {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to)
    })
  }
}

class MyDataSource extends BasicDataSource {
  private dataArray: Array<{
    text: Resource,
    inputType: InputType,
    length: number,
    event: number,
    inputFilter: string,
    promptText: Resource
  }> = [
    {
      text: $r('app.string.username'),
      inputType: InputType.Normal,
      length: 15,
      event: 0,
      inputFilter: '^[A-Za-z0-9_]+$',
      promptText: $r('app.string.prompt_username')
    },
    {
      text: $r('app.string.email'),
      inputType: InputType.Normal,
      length: 18,
      event: 1,
      inputFilter: '',
      promptText: $r('app.string.prompt_email')
    },
    {
      text: $r('app.string.signature'),
      inputType: InputType.Normal,
      length: 18,
      event: 2,
      inputFilter: '',
      promptText: $r('app.string.prompt_signature')
    },
    {
      text: $r('app.string.password'),
      inputType: InputType.Password,
      length: 18,
      event: 3,
      inputFilter: '',
      promptText: $r('app.string.prompt_password')
    },
    {
      text: $r('app.string.confirm_password'),
      inputType: InputType.Password,
      length: 18,
      event: 4,
      inputFilter: '',
      promptText: $r('app.string.prompt_confirm_password')
    }
  ]

  public totalCount() {
    return this.dataArray.length
  }

  public getData(index: number) {
    return this.dataArray[index]
  }

  public addData(index: number) {
    this.dataArray.splice(index, 0)
    this.notifyDataAdd(index)
  }

  public pushData(index: number) {
    this.dataArray.push()
    this.notifyDataAdd(this.dataArray.length - 1)
  }

  public replaceData(result: any[]) {
    this.dataArray = result
  }
}

const TAG: string = '[RegisterInfo]'

@Component
export struct RegisterInfo {
  @State passWord: string = ''
  @State username: string = ''
  @State emailInfo: string = ''
  @State signature: string = ''
  @State confirmPassword: string = ''
  @State dataSet: MyDataSource = new MyDataSource()
  private bundleName: string = ''
  private storage: AccountData = AccountData.getInstance()
  private accountModel: AccountModel = new AccountModel()

  build() {
    Column() {
      Row() {
        Text($r('app.string.appname'))
          .margin(10)
          .fontSize(18)
          .width('25%')
          .textAlign(TextAlign.End)
        Text(this.bundleName)
          .margin(10)
          .width('55%')
          .fontSize(20)
          .textAlign(TextAlign.Center)
      }
      .margin(5)

      LazyForEach(this.dataSet, (item, index) => {
        Row() {
          Text(item.text)
            .margin(10)
            .fontSize(18)
            .width('25%')
            .textAlign(TextAlign.End)
            .backgroundColor('#ffffff')
          Column() {
            Text(item.promptText)
              .fontSize(14)
              .width('80%')
              .fontColor('#ffb0b0b0')
              .textAlign(TextAlign.Center)

            TextInput({ placeholder: 'xxxxx' })
              .id('Register' + (index + 1))
              .margin(10)
              .width('55%')
              .fontSize(20)
              .maxLength(20)
              .type(item.inputType)
              .maxLength(item.length)
              .inputFilter(item.inputFilter)
              .fontWeight(FontWeight.Bold)
              .placeholderFont({ size: 16, weight: FontWeight.Normal })
              .onChange(async (value: string) => {
                switch (item.event) {
                  case 0:
                    this.username = value
                    break
                  case 1:
                    this.emailInfo = value
                    break
                  case 2:
                    this.signature = value
                    break
                  case 3:
                    this.passWord = value
                    break
                  case 4:
                    this.confirmPassword = value
                    break
                  default:
                    break
                }
              })
          }
        }
        .margin(5)
      }, item => JSON.stringify(item))

      Button($r('app.string.setting'))
        .id('complete')
        .margin(10)
        .width('60%')
        .fontSize(20)
        .fontColor(Color.White)
        .type(ButtonType.Capsule)
        .onClick(async () => {
          let res = /^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$/
          let result = await this.storage.hasStorageValue(getContext(), this.username, this.bundleName)
          Logger.info(TAG, `This result is ${result}`)
          if (this.username === '') {
            AlertDialog.show(
              {
                message: $r('app.string.blank'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    Logger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          } else if (result) {
            AlertDialog.show(
              {
                message: $r('app.string.has'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    Logger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          } else if (this.emailInfo !== '' && !res.test(this.emailInfo)) {
            AlertDialog.show(
              {
                message: $r('app.string.emailinfo'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    Logger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          } else if (this.passWord === '') {
            AlertDialog.show(
              {
                message: $r('app.string.password_blank'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    Logger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          } else if (this.passWord !== '' && this.passWord.length < 6) {
            AlertDialog.show(
              {
                message: $r('app.string.min_password'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    Logger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          } else if (this.confirmPassword !== this.passWord) {
            AlertDialog.show(
              {
                message: $r('app.string.password_error'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    Logger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          } else {
            if (this.username !== '') {
              await this.accountModel.addAccount(`${this.username}_${this.bundleName}`)
            }
            if (this.emailInfo !== '') {
              await this.accountModel.setAccountCredential(`${this.username}_${this.bundleName}`, `email_${this.bundleName}`, this.emailInfo)
            }
            if (this.signature !== '') {
              await this.accountModel.setAccountCredential(`${this.username}_${this.bundleName}`, `signature_${this.bundleName}`, this.signature)
            }
            await this.accountModel.setAssociatedData(`${this.username}_${this.bundleName}`, `key_${this.bundleName}`, this.passWord)
            await this.storage.putStorageValue(getContext(), this.username, this.passWord, this.bundleName)
            await this.storage.putStorageValue(getContext(), this.bundleName, 'true', `${this.username}_${this.bundleName}`)
            AlertDialog.show(
              {
                message: $r('app.string.register_info'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    router.push({
                      url: 'pages/Login',
                      params: {
                        bundleName: this.bundleName
                      }
                    })
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          }
        })
    }
  }
}