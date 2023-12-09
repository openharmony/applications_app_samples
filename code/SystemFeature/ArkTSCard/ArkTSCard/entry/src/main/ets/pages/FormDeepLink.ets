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

import Logger from '../util/Logger';

interface Form {
  id: number
};

interface Error {
  errcode: number,
  msg: string
};

@Entry
@Component
struct CardExample {
  @State staticMusicCardId: number = 0;
  @State dynamicMusicCardId: number = 0;
  @State staticBookCardId: number = 0;
  @State dynamicBookCard: number = 0;
  @State staticWeatherCardFormId: number = 0;
  @State dynamicWeatherCardId: number = 0;

  build() {
    Column() {
      Column() {
        Text("EntryAbility")
          .fontWeight(700)
          .fontColor("#FF182431")
          .fontSize(24)
          .textAlign(TextAlign.Start)
          .width('624px')
          .height('66px')
      }
      .width('100%')

      Column() {
        FormComponent({
          id: this.staticMusicCardId,
          name: 'StaticMusicCard',
          bundle: 'com.samples.arktscard',
          ability: 'EntryFormAbility',
          module: 'entry',
          dimension: FormDimension.Dimension_2_2,
          temporary: false
        })
          .allowUpdate(true)
          .borderRadius('48px')
          .size({ width: 414, height: 88 })
          .visibility(Visibility.Visible)
          .margin({
            top: 12
          })
          .onAcquired((form: Form) => {
            Logger.info(`form info : ${JSON.stringify(form)}`);
            this.staticMusicCardId = form.id;
          })
          .onError((err: Error) => {
            Logger.info(`fail to add form, err: ${JSON.stringify(err)}`);
          })
      }

      Column() {
        FormComponent({
          id: this.dynamicMusicCardId,
          name: 'DynamicMusicCard',
          bundle: 'com.samples.arktscard',
          ability: 'EntryFormAbility',
          module: 'entry',
          dimension: FormDimension.Dimension_2_2,
          temporary: false
        })
          .allowUpdate(true)
          .borderRadius('48px')
          .size({ width: 414, height: 88 })
          .visibility(Visibility.Visible)
          .margin({
            top: 12
          })
          .onAcquired((form: Form) => {
            Logger.info(`form info : ${JSON.stringify(form)}`);
            this.dynamicMusicCardId = form.id;
          })
          .onError((err: Error) => {
            Logger.info(`fail to add form, err: ${JSON.stringify(err)}`);
          })
      }

      Column() {
        FormComponent({
          id: this.staticBookCardId,
          name: 'StaticBookCard',
          bundle: 'com.samples.arktscard',
          ability: 'EntryFormAbility',
          module: 'entry',
          dimension: FormDimension.Dimension_2_2,
          temporary: false
        })
          .allowUpdate(true)
          .borderRadius('48px')
          .size({ width: 414, height: 88 })
          .visibility(Visibility.Visible)
          .margin({
            top: 12
          })
          .onAcquired((form: Form) => {
            Logger.info(`form info : ${JSON.stringify(form)}`);
            this.staticBookCardId = form.id;
          })
          .onError((err: Error) => {
            Logger.info(`fail to add form, err: ${JSON.stringify(err)}`);
          })
      }

      Column() {
        FormComponent({
          id: this.dynamicBookCard,
          name: 'DynamicBookCard',
          bundle: 'com.samples.arktscard',
          ability: 'EntryFormAbility',
          module: 'entry',
          dimension: FormDimension.Dimension_2_2,
          temporary: false
        })
          .allowUpdate(true)
          .borderRadius('48px')
          .size({ width: 414, height: 88 })
          .visibility(Visibility.Visible)
          .margin({
            top: 12
          })
          .onAcquired((form: Form) => {
            Logger.info(`form info : ${JSON.stringify(form)}`);
            this.dynamicBookCard = form.id;
          })
          .onError((err: Error) => {
            Logger.info(`fail to add form, err: ${JSON.stringify(err)}`);
          })
      }

      Column() {
        FormComponent({
          id: this.staticWeatherCardFormId,
          name: 'StaticWeatherCard',
          bundle: 'com.samples.arktscard',
          ability: 'EntryFormAbility',
          module: 'entry',
          dimension: FormDimension.Dimension_2_2,
          temporary: false
        })
          .allowUpdate(true)
          .borderRadius('48px')
          .size({ width: 414, height: 88 })
          .visibility(Visibility.Visible)
          .margin({
            top: 12
          })
          .onAcquired((form: Form) => {
            Logger.info(`form info : ${JSON.stringify(form)}`);
            this.staticWeatherCardFormId = form.id;
          })
          .onError((err: Error) => {
            Logger.info(`fail to add form, err: ${JSON.stringify(err)}`);
          })
      }

      Column() {
        FormComponent({
          id: this.dynamicWeatherCardId,
          name: 'DynamicWeatherCard',
          bundle: 'com.samples.arktscard',
          ability: 'EntryFormAbility',
          module: 'entry',
          dimension: FormDimension.Dimension_2_2,
          temporary: false
        })
          .allowUpdate(true)
          .borderRadius('48px')
          .size({ width: 414, height: 88 })
          .visibility(Visibility.Visible)
          .margin({
            top: 12
          })
          .onAcquired((form: Form) => {
            Logger.info(`form info : ${JSON.stringify(form)}`);
            this.dynamicWeatherCardId = form.id;
          })
          .onError((err: Error) => {
            Logger.info(`fail to add form, err: ${JSON.stringify(err)}`);
          })
      }
    }
    .backgroundColor($r('app.color.page_background'))
    .width('100%')
    .height('100%')
  }
}
