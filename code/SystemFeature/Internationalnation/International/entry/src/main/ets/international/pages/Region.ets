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
import i18n from '@ohos.i18n';
import router from '@ohos.router';
import Logger from '../../utils/Logger';
import OperationListView from '../../components/OperationListView';
import TitleBar from '../../components/TitleBar';

const TAG: string = 'Country';

@Entry
@Component
struct Region {
  private params = router.getParams() as Record<string, string>;
  private country: string = this.params.currentCountry as string;
  private localLanguage: string = this.params.language;
  private suggestIds: Array<string> = [];
  private countryIds: Array<string> = [];
  @State countries: Array<Countrie> = [];
  @State suggestCounties: Array<SuggestCountie> = [];

  aboutToAppear() {
    Logger.info(TAG, `this.country = ${this.country}`);
    try {
      this.countryIds = i18n.System.getSystemCountries(this.localLanguage);
    } catch (err) {
      Logger.error(`getSystemCountries failed, code is ${err.code}, message is ${err.message}`);
    }
    Logger.info(TAG, `systemCountryIds = ${JSON.stringify(this.countryIds)}`);
    this.countryIds.forEach(id => {
      let country = i18n.System.getDisplayCountry(id, this.localLanguage);
      this.countries.push({ key: country, value: '' });
      let isSuggested: boolean = false;
      try {
        isSuggested = i18n.System.isSuggested(this.localLanguage, id);
      } catch (err) {
        Logger.error(`isSuggested failed, code is ${err.code}, message is ${err.message}`);
      }
      if (isSuggested) {
        this.suggestIds.push(id);
        this.suggestCounties.push({ key: country, value: '' });
      }
    })
  }

  setSuggestRegion = (index: number) => {
    let region = this.suggestIds[index];
    try {
      i18n.System.setSystemRegion(region);
    } catch (err) {
      Logger.error(`setSystemRegion failed, code is ${err.code}, message is ${err.message}`);
    }
    router.back();
  }
  setRegion = (index: number) => {
    let region = this.countryIds[index];
    try {
      i18n.System.setSystemRegion(region);
    } catch (err) {
      Logger.error(`setSystemRegion failed, code is ${err.code}, message is ${err.message}`);
    }
    router.back();
  }

  @Builder
  CurrentCountryView() {
    Row() {
      Text(this.country)
        .fontSize(22)
      Blank()
      Image($r('app.media.check'))
        .width(25).height(50)
        .objectFit(ImageFit.Contain)
    }
    .size({ width: '95%' })
    .padding(10)
    .backgroundColor($r('app.color.white'))
    .margin({ top: 10 })
    .border({ color: $r('app.color.white'), width: 1, radius: 15 })
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true, title: $r('app.string.select_region') })
      Scroll() {
        Column() {
          Text($r('app.string.current_region'))
            .fontSize(20).fontColor($r('app.color.gray'))
            .width('95%')
            .margin({ left: 10, top: 15 })
          this.CurrentCountryView()
          OperationListView({
            title: $r('app.string.suggest_region'),
            operations: this.suggestCounties,
            handleItemClick: this.setSuggestRegion
          })
          OperationListView({
            title: $r('app.string.all_region'),
            operations: this.countries,
            handleItemClick: this.setRegion
          })
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.f5f5f5'))
  }
}

class Countrie {
  key: string = '';
  value: string = '';
}

class SuggestCountie {
  key: string = '';
  value: string = '';
}