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
import LazyDataSource, { BaseData } from '../../utils/LazyDataSource';

const TAG: string = 'EditPreferred';

@Entry
@Component
struct EditPreferred {
  @State preferredLanguages: LazyDataSource = new LazyDataSource();
  private params = router.getParams() as Record<string, string>;
  private localLanguage: string = this.params.language as string;
  private deletePreferredLanguages: Array<number> = [];

  aboutToAppear() {
    let preferredLanguages: Array<BaseData> = [];
    let preferredLanguageIds = i18n.System.getPreferredLanguageList();
    Logger.info(TAG, `this.preferredLanguageIds = ${JSON.stringify(preferredLanguageIds)}`);
    preferredLanguageIds.forEach(id => {
      preferredLanguages.push({
        id: id,
        key: i18n.System.getDisplayLanguage(id, id),
        value: i18n.System.getDisplayLanguage(id, this.localLanguage)
      });
    });
    this.preferredLanguages.dataArray = preferredLanguages;
    this.preferredLanguages.notifyDataReload();
  }

  @Builder
  PreferredItem($$: Data) {
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
          Text($$.preferred.key)
            .fontColor($$.preferred.id === this.localLanguage ? $r('app.color.blue') : $r('app.color.black'))
            .fontSize(22)
            .margin({ top: 10, bottom: 10 })
          if ($$.preferred.id !== this.localLanguage) {
            Text($$.preferred.value)
              .fontColor($r('app.color.gray'))
              .fontSize(22)
              .margin({ top: 10, bottom: 10 })
          }
        }
        .alignItems(HorizontalAlign.Start)

        Blank()
        if ($$.preferred.id !== this.localLanguage) {
          Image($r('app.media.delete'))
            .size({ width: 40, height: 40 })
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              this.deletePreferredLanguages.push($$.index);
              this.preferredLanguages.dataArray.splice($$.index, 1);
              this.preferredLanguages.notifyDataReload();
            })
        }
      }
      .width('100%')
    }
    .width('100%')
  }

  @Builder
  PreferredView() {
    Column() {
      List() {
        LazyForEach(this.preferredLanguages, (item: BaseData, index: number) => {
          ListItem() {
            this.PreferredItem(new Data(item, index));
          }
        }, (item: string) => JSON.stringify(item))
      }
    }
    .width('95%')
    .padding(10)
    .margin({ top: 20, bottom: 10 })
    .backgroundColor($r('app.color.white'))
    .border({ color: $r('app.color.white'), width: 1, radius: 15 })
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(60).height('100%')
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back();
          })
        Text($r('app.string.edit_language'))
          .fontSize(30)
          .layoutWeight(1)
        Blank()
        Image($r('app.media.check'))
          .key('check')
          .width(60)
          .height('100%')
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.deletePreferredLanguages.forEach((item: number) => {
              try {
                i18n.System.removePreferredLanguage(item);
              } catch (err) {
                Logger.error(`removePreferredLanguage failed, code is ${err.code}, message is ${err.message}`);
              }
            });
            router.back();
          })
      }
      .width('100%')
      .height('8%')
      .constraintSize({ minHeight: 70 })
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.f5f5f5'))

      Scroll() {
        this.PreferredView();
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.f5f5f5'))
  }
}

class Data {
  preferred: BaseData = new BaseData();
  index: number = 0;

  constructor(preferred: BaseData, index: number) {
    this.preferred = preferred;
    this.index = index;
  }
}