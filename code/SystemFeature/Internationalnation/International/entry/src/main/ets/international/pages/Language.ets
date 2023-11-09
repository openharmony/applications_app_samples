/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import common from '@ohos.app.ability.common';
import i18n from '@ohos.i18n';
import prompt from '@ohos.prompt';
import router from '@ohos.router';
import TitleBar from '../../components/TitleBar';
import Logger from '../../utils/Logger';
import LazyDataSource, { BaseData } from '../../utils/LazyDataSource';
import OperationView from '../../components/OperationView';
import ResourceUtil from '../../utils/ResourceUtil';

const TAG: string = 'Language';

@Entry
@Component
struct Language {
  private context = getContext(this) as common.UIAbilityContext;
  private languageSwitchTips: string = '';
  @State localLanguage: string = '';
  @State preferredLanguages: LazyDataSource = new LazyDataSource();
  @State currentRegion: string = '';

  async aboutToAppear() {
    this.languageSwitchTips = await ResourceUtil.getString($r('app.string.language_switch_tips').id);
  }

  onPageShow() {
    this.refreshData();
  }

  refreshData() {
    this.currentRegion = i18n.System.getDisplayCountry(i18n.System.getSystemRegion(), i18n.System.getSystemLocale());
    Logger.info(TAG, `this.currentRegion = ${this.currentRegion}`);
    this.localLanguage = i18n.System.getSystemLanguage();
    Logger.info(TAG, `this.localLanguage = ${this.localLanguage}`);
    let preferredLanguages: BaseData[] = [];
    let preferredLanguageIds = i18n.System.getPreferredLanguageList();
    Logger.info(TAG, `this.preferredLanguageIds = ${JSON.stringify(preferredLanguageIds)}`);
    preferredLanguageIds.forEach(id => {
      let item: BaseData = {
        id: id,
        key: i18n.System.getDisplayLanguage(id, id),
        value: i18n.System.getDisplayLanguage(id, this.localLanguage)
      }
      preferredLanguages.push(item);
    });
    this.preferredLanguages.dataArray = preferredLanguages;
    this.preferredLanguages.notifyDataReload();
  }

  @Builder
  LanguageItem($$: Data) {
    Column() {
      if ($$.index !== 0) {
        Divider()
          .color($r('app.color.divider'))
          .width('100%')
          .strokeWidth(1)
          .margin({ top: 10, bottom: 10 })
      }
      Row() {
        Column() {
          Text($$.languageInfo.key)
            .fontSize(22)
            .margin({ top: 10, bottom: 10 })
            .fontColor($$.languageInfo.id === this.localLanguage ? $r('app.color.blue') : $r('app.color.black'))

          if ($$.languageInfo.id !== this.localLanguage) {
            Text($$.languageInfo.value)
              .fontColor($r('app.color.gray'))
              .fontSize(22)
              .width('100%')
              .margin({ top: 10, bottom: 10 })
          }
        }
        .alignItems(HorizontalAlign.Start)

        Blank()
        if ($$.languageInfo.id === this.localLanguage) {
          Image($r('app.media.check'))
            .size({ width: 35, height: 35 })
        }
      }
      .width('100%')
    }
    .width('100%')
    .onClick($$.handleClick)
  }

  @Builder
  LanguageView() {
    Column() {
      List() {
        LazyForEach(this.preferredLanguages, (item: BaseData, index: number) => {
          ListItem() {
            this.LanguageItem(new Data(item, index, () => {
              if (item.id !== this.localLanguage) {
                try {
                  i18n.System.setSystemLanguage(item.id);
                } catch (err) {
                  Logger.error(`setSystemLanguage failed, code is ${err.code}, message is ${err.message}`);
                }
                this.refreshData();
                prompt.showToast({
                  message: this.languageSwitchTips
                });
                setTimeout(() => {
                  this.context.terminateSelf();
                }, 2000);
              }
            }))
          }
        }, (item: BaseData) => item.key)
      }
    }
    .width('95%')
    .padding(10)
    .backgroundColor($r('app.color.white'))
    .margin({ top: 10 })
    .border({ color: $r('app.color.white'), width: 1, radius: 15 })
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.language_region') })
      Scroll() {
        Column() {
          Row() {
            Text($r('app.string.language'))
              .fontSize(22).fontColor($r('app.color.gray'))
            Blank()
            Text($r('app.string.edit'))
              .key('edit')
              .fontSize(22).fontColor($r('app.color.blue'))
              .margin({ right: 10 })
              .onClick(() => {
                router.push({
                  url: 'international/pages/EditPreferred',
                  params: {
                    language: this.localLanguage
                  }
                });
              })
          }
          .width('95%')
          .margin({ top: 20, right: 10, left: 10 })

          this.LanguageView()
          OperationView({ mKey: $r('app.string.add_language'), value: '', showArrow: false, handleClick: () => {
            router.push({
              url: 'international/pages/AddLanguage'
            });
          }
          })
          Text($r('app.string.region'))
            .fontSize(20).fontColor($r('app.color.gray'))
            .width('95%')
            .margin({ top: 20, right: 10, left: 10 })
          OperationView({ mKey: $r('app.string.current_region'), value: this.currentRegion, handleClick: () => {
            router.push({
              url: 'international/pages/Region',
              params: {
                language: this.localLanguage,
                currentCountry: this.currentRegion
              }
            });
          }
          })
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.f5f5f5'))
  }
}

class Data {
  languageInfo: BaseData = new BaseData();
  index: number = 0;
  handleClick: (event: ClickEvent) => void;

  constructor(languageInfo: BaseData, index: number, handleClick: (event: ClickEvent) => void) {
    this.languageInfo = languageInfo;
    this.index = index;
    this.handleClick = handleClick;
  }
}