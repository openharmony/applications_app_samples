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

const TAG: string = '[ModifyInfo]'

interface ModifyFieldItem {
  text: Resource
  inputType: InputType
  length: number
  event: number
  promptText: Resource
}

class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount(): number {
    return 0
  }

  public getData(index: number): T | undefined {
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

class MyDataSource extends BasicDataSource<ModifyFieldItem> {
  private dataArray: ModifyFieldItem[] = [
    {
      text: $r('app.string.email'),
      inputType: InputType.Normal,
      length: 18,
      event: 0,
      promptText: $r('app.string.prompt_email')
    },
    {
      text: $r('app.string.signature'),
      inputType: InputType.Normal,
      length: 18,
      event: 1,
      promptText: $r('app.string.prompt_signature')
    },
    {
      text: $r('app.string.unpassword'),
      inputType: InputType.Password,
      length: 18,
      event: 2,
      promptText: $r('app.string.prompt_password')
    },
    {
      text: $r('app.string.unconfirm_password'),
      inputType: InputType.Password,
      length: 18,
      event: 3,
      promptText: $r('app.string.prompt_confirm_password')
    }
  ]

  public totalCount(): number {
    return this.dataArray.length
  }

  public getData(index: number): ModifyFieldItem | undefined {
    return this.dataArray[index]
  }

  public replaceData(result: ModifyFieldItem[]) {
    this.dataArray = result
  }
}

@Component
export struct ModifyInfo {
  @State passWord: string = ''
  @State emailInfo: string = ''
  @State signature: string = ''
  @State confirmPassword: string = ''
  @Prop username: string
  @Prop bundleName: string
  @Prop isWideLayout: boolean
  @State dataSet: MyDataSource = new MyDataSource()
  private storage: AccountData = AccountData.getInstance()
  private accountModel: AccountModel = new AccountModel()

  async getInfo(value: string, name: string, credentialType: string) {
    try {
      value = await this.accountModel.getAccountCredential(name, credentialType)
      Logger.info(TAG, `getAccountCredential email is ${value}`)
    } catch (err) {
      Logger.info(TAG, `getAccountCredential failed err is ${JSON.stringify(err)}`)
    }
    return value
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.appname'))
          .margin(10)
          .fontSize(18)
          .width('25%')
          .textAlign(TextAlign.End)
        Text(this.bundleName)
          .margin(20)
          .width('55%')
          .fontSize(20)
          .textAlign(TextAlign.Start)
      }
      .margin(5)

      Row() {
        Text($r('app.string.unusername'))
          .margin(10)
          .fontSize(18)
          .width('25%')
          .textAlign(TextAlign.End)
        Text(this.username)
          .margin(10)
          .width('55%')
          .fontSize(20)
          .textAlign(TextAlign.Start)
      }
      .margin(5)

      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        LazyForEach(this.dataSet, (item: ModifyFieldItem, index: number) => {
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
                .id('Modify' + (index + 1))
                .margin(10)
                .width('55%')
                .fontSize(20)
                .maxLength(20)
                .type(item.inputType)
                .maxLength(item.length)
                .fontWeight(FontWeight.Bold)
                .placeholderFont({ size: 16, weight: FontWeight.Normal })
                .onChange((value: string) => {
                  switch (item.event) {
                    case 0:
                      this.emailInfo = value
                      break
                    case 1:
                      this.signature = value
                      break
                    case 2:
                      this.passWord = value
                      break
                    case 3:
                      this.confirmPassword = value
                      break
                    default:
                      break
                  }
                })
            }
          }
          .margin(5)
          .width(this.isWideLayout ? '48%' : '100%')
        }, (item: ModifyFieldItem) => JSON.stringify(item))
      }
      .width('100%')

      Button($r('app.string.setting'))
        .id('modComplete')
        .margin(10)
        .width(this.isWideLayout ? '40%' : '60%')
        .fontSize(20)
        .fontColor(Color.White)
        .type(ButtonType.Capsule)
        .enabled(this.username !== '')
        .onClick(async () => {
          if (this.username === '') {
            return
          }
          if (this.emailInfo !== '') {
            await this.accountModel.setAccountCredential(`${this.username}_${this.bundleName}`, `email_${this.bundleName}`, this.emailInfo)
          }
          if (this.signature !== '') {
            await this.accountModel.setAccountCredential(`${this.username}_${this.bundleName}`, `signature_${this.bundleName}`, this.signature)
          }
          let res = /^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$/
          let userPassWord: string = await this.storage.getStorageValue(getContext(), this.username, this.bundleName)
          if (this.emailInfo !== '' && !res.test(this.emailInfo)) {
            AlertDialog.show(
              {
                message: $r('app.string.emailinfo'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    this.emailInfo = ''
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
          } else if (this.passWord !== '' && this.passWord === userPassWord) {
            AlertDialog.show(
              {
                message: $r('app.string.userpassword'),
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
          } else if (this.passWord !== '' && this.confirmPassword !== '') {
            await this.storage.putStorageValue(getContext(), this.username, this.passWord, this.bundleName)
            let email = await this.getInfo('', `${this.username}_${this.bundleName}`, `email_${this.bundleName}`)
            let signature = await this.getInfo('', `${this.username}_${this.bundleName}`, `signature_${this.bundleName}`)
            AlertDialog.show(
              {
                message: $r('app.string.modify_info'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    router.push({
                      url: 'pages/Account',
                      params: {
                        email: email,
                        signature: signature,
                        bundleName: this.bundleName,
                        username: this.username
                      }
                    })
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          }
          else {
            let email = await this.getInfo('', `${this.username}_${this.bundleName}`, `email_${this.bundleName}`)
            let signature = await this.getInfo('', `${this.username}_${this.bundleName}`, `signature_${this.bundleName}`)
            AlertDialog.show(
              {
                message: $r('app.string.modify_info'),
                confirm: {
                  value: $r('app.string.close'),
                  action: () => {
                    router.push({
                      url: 'pages/Account',
                      params: {
                        email: email,
                        signature: signature,
                        bundleName: this.bundleName,
                        username: this.username
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
