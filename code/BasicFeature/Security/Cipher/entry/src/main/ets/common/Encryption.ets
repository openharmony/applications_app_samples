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

import prompt from '@ohos.prompt'
import { CipherModel } from '../model/CipherModel'
import Logger from '../model/Logger'

const TAG: string = '[Encryption]'

@Component
export struct Encryption {
  @State info: string = ''
  @State message: string = ''
  @State algorithmType: string = 'Encryption Algorithm'
  private cipherModel: CipherModel = new CipherModel()

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Select([{ value: 'RSA' },
          { value: 'AES' }])
          .id('encryptionAlgorithm')
          .margin(4)
          .selected(0)
          .value(this.algorithmType)
          .font({ size: 20, weight: 300, family: 'serif', style: FontStyle.Normal })
          .optionFont({ size: 16, weight: 280, family: 'serif', style: FontStyle.Normal })
          .selectedOptionFont({ size: 16, weight: 280, family: 'serif', style: FontStyle.Normal })
          .onSelect((index: number, value: string) => {
            this.algorithmType = value
            Logger.info(TAG, `Select: ${index} value: ${value}`)
          })

        TextArea()
          .margin(4)
          .width('60%')
          .id('encryptionInput')
          .onChange((value: string) => {
            this.message = value
          })

        Row() {
          Button($r('app.string.encryption'))
            .margin(10)
            .fontSize(20)
            .width('45%')
            .height('6%')
            .id('encryptionBtn')
            .onClick(() => {
              if (this.message === '') {
                prompt.showToast({
                  message: 'This message is null.'
                })
              } else {
                if (this.algorithmType === 'RSA') {
                  this.cipherModel.rsaEncrypt(this.message, (result) => {
                    Logger.info(TAG, `this result = ${JSON.stringify(result)}`)
                    this.info = `Encryption result is :  ${result.text}`
                  })
                } else {
                  this.cipherModel.aesEncrypt(this.message, (result) => {
                    Logger.info(TAG, `this result = ${JSON.stringify(result)}`)
                    this.info = `Encryption result is :  ${result.text}`
                  })
                }
              }
            })

          Button($r('app.string.reset'))
            .margin(10)
            .fontSize(20)
            .width('30%')
            .height('6%')
            .id('encryptionResetBtn')
            .onClick(() => {
              this.info = ''
            })
        }
        .margin(10)

        Text(this.info)
          .id('encryptionInfo')
          .fontSize(18)
          .width('85%')
          .height('25%')
          .border({ width: 2, color: Color.Black })
          .margin(10)
          .copyOption(CopyOptions.InApp)
      }
    }
    .width('100%')
    .height('100%')
  }
}