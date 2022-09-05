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

import prompt from '@ohos.prompt'
import innerBundleManager from '@ohos.bundle.innerBundleManager'
import { MyDataSource } from '../model/Apps'
import Logger from '../model/Logger'
import featureAbility from '@ohos.ability.featureAbility'

const TAG = '[BringApps]'

@Component
export struct BringApp {
  @State text: string = ''
  @State bundleName: string[] = []
  @State abilityName: string[] = []
  @State app: MyDataSource = new MyDataSource()

  async aboutToAppear() {
    let result: any[] = []
    result = await innerBundleManager.getAllLauncherAbilityInfos(100)
    if (result !== []) {
      for (let i = 0; i < result.length; i++) {
        this.bundleName.push(result[i].elementName.bundleName)
        this.abilityName.push(result[i].elementName.abilityName)
      }
      Logger.info(TAG, `this bundleName is ${JSON.stringify(this.bundleName)}`)
      Logger.info(TAG, `this abilityName is ${JSON.stringify(this.abilityName)}`)
    }
  }

  build() {
    Scroll() {
      Column() {
        LazyForEach(this.app, (item, index) => {
          Row() {
            Image(item.img)
              .margin(5)
              .width('20%')
              .height('60%')
              .objectFit(ImageFit.Contain)

            Text(item.name)
              .margin(5)
              .fontSize(20)
              .textAlign(TextAlign.Start)

            Blank()
              .width('10%')

            Image($r('app.media.right'))
              .margin(10)
              .width('15%')
              .height('20%')
              .objectFit(ImageFit.Contain)
          }
          .key('app' + index)
          .margin(5)
          .width('95%')
          .height('12%')
          .borderRadius(20)
          .backgroundColor('#f6f6f6')
          .onClick(async () => {
            let wantBundleName: string = ''
            let wantAbilityName: string = ''
            for (let i = 0, j = 0; i < this.bundleName.length, j < this.abilityName.length; i++, j++) {
              if (this.bundleName[i].includes(item.info) && this.abilityName[i].includes(item.info)) {
                wantBundleName = this.bundleName[i]
                wantAbilityName = this.abilityName[i]
                break
              }
            }
            try {
              await featureAbility.startAbility({
                want: {
                  bundleName: wantBundleName,
                  abilityName: wantAbilityName,
                },
              })
              this.text = 'Success!'
            } catch (err) {
              this.text = 'Error!'
              Logger.info(TAG, `err is ${JSON.stringify(err)}`)
            }
            prompt.showToast({
              message: this.text,
              duration: 1500
            })
          })
        }, item => item.name)
      }
    }
    .width('100%')
    .height('100%')
    .layoutWeight(1)
  }
}