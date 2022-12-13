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
import featureAbility from '@ohos.ability.featureAbility'
import i18n from '@ohos.i18n'
import prompt from '@ohos.prompt'
import router from '@ohos.router'
import TitleBar from '../view/TitleBar'
import Logger from '../model/Logger'
import LazyDataSource from '../model/LazyDataSource'
import OperationView from '../view/OperationView'
import ResourceUtil from '../model/ResourceUtil'

const TAG: string = 'Language'

class LanguageInfo {
  id: string
  language: string
  country: string
}


@Entry
@Component
struct Language {
  private languageSwitchTips: string = ''
  @State localLanguage: string = ''
  @State preferredLanguages: LazyDataSource = new LazyDataSource()
  @State currentRegion: string = ''

  async aboutToAppear() {
    this.languageSwitchTips = await ResourceUtil.getString($r('app.string.language_switch_tips').id)
  }

  onPageShow() {
    this.refreshData()
  }

  refreshData() {
    this.currentRegion = i18n.getDisplayCountry(i18n.getSystemRegion(), i18n.getSystemLocale())
    Logger.info(TAG, `this.currentRegion = ${this.currentRegion}`)
    this.localLanguage = i18n.getSystemLanguage()
    Logger.info(TAG, `this.localLanguage = ${this.localLanguage}`)
    var preferredLanguages = []
    let preferredLanguageIds = i18n.getPreferredLanguageList()
    Logger.info(TAG, `this.preferredLanguageIds = ${JSON.stringify(preferredLanguageIds)}`)
    preferredLanguageIds.forEach(id => {
      preferredLanguages.push({
        id: id,
        language: i18n.getDisplayLanguage(id, id),
        country: i18n.getDisplayLanguage(id, this.localLanguage)
      })
    })
    this.preferredLanguages['dataArray'] = preferredLanguages
    this.preferredLanguages.notifyDataReload()
  }

  @Builder
  LanguageItem(languageInfo, index, handleClick) {
    Column() {
      if (index !== 0) {
        Divider()
          .color(Color.Gray)
          .width('100%')
          .strokeWidth(1)
          .margin({ top: 10, bottom: 10 })
      }
      Row() {
        Column() {
          Text(languageInfo.language)
            .fontSize(22)
            .margin({ top: 10, bottom: 10 })
            .fontColor(languageInfo.id === this.localLanguage ? Color.Blue : Color.Black)

          if (languageInfo.id !== this.localLanguage) {
            Text(languageInfo.country)
              .fontColor(Color.Gray)
              .fontSize(22)
              .width('100%')
              .margin({ top: 10, bottom: 10 })
          }
        }
        .alignItems(HorizontalAlign.Start)

        Blank()
        if (languageInfo.id === this.localLanguage) {
          Image($r('app.media.check'))
            .size({ width: 35, height: 35 })
        }
      }
      .width('100%')
    }
    .width('100%')
    .onClick(handleClick)
  }

  @Builder
  LanguageView() {
    Column() {
      LazyForEach(this.preferredLanguages, (item, index) => {
        this.LanguageItem(item, index, () => {
          if (item.id !== this.localLanguage) {
            try {
              i18n.System.setSystemLanguage(item.id)
            } catch (err) {
              Logger.error(`setSystemLanguage failed, code is ${err.code}, message is ${err.message}`)
            }
            this.refreshData()
            prompt.showToast({
              message: this.languageSwitchTips
            })
            setTimeout(() => {
              featureAbility.terminateSelf()
            }, 2000)
          }
        })
      }, item => item.language)
    }
    .width('95%')
    .padding(10)
    .backgroundColor(Color.White)
    .margin({ top: 10 })
    .border({ color: Color.White, width: 1, radius: 15 })
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.language_region') })
      Scroll() {
        Column() {
          Row() {
            Text($r('app.string.language'))
              .fontSize(22).fontColor(Color.Gray)
            Blank()
            Text($r('app.string.edit'))
              .key('edit')
              .fontSize(22).fontColor(Color.Blue)
              .onClick(() => {
                router.push({
                  url: 'pages/EditPreferred',
                  params: {
                    language: this.localLanguage
                  }
                })
              })
          }
          .width('95%')
          .margin({ top: 20, right: 10, left: 10 })
          .padding({ left: 10, right: 10 })

          this.LanguageView()
          OperationView({ mKey: $r('app.string.add_language'), value: '', showArrow: false, handleClick: () => {
            router.push({
              url: 'pages/AddLanguage'
            })
          } })
          Text($r('app.string.region'))
            .fontSize(20).fontColor(Color.Gray)
            .width('95%')
            .margin({ top: 20 })
          OperationView({ mKey: $r('app.string.current_region'), value: this.currentRegion, handleClick: () => {
            router.push({
              url: 'pages/Region',
              params: {
                language: this.localLanguage,
                currentCountry: this.currentRegion
              }
            })
          } })
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}