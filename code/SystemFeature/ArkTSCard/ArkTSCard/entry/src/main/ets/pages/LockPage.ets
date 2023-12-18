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
import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';
import formHost from '@ohos.app.form.formHost';
import router from '@ohos.router';

interface Form {
  id: number
};

interface Error {
  errcode: number,
  msg: string
};

@Entry
@Component
struct LockPage {
  protected staticFormId1_1: number = 0;
  protected staticFormId1_2: number = 0;
  protected dynamicFormId1_1: number = 0;
  protected dynamicFormId1_2: number = 0;
  @State want: Want = {};
  @StorageLink('isUnlock') isUnlock: Boolean = false;
  private context = getContext(this) as common.UIAbilityContext;

  onPageShow(): void {
    Logger.info(`onPageShow`);
    if (this.isUnlock) {
      this.context.startAbility(this.want).then(() => {
        AppStorage.setOrCreate('isUnlock', false);
      })
    };
  }

  build() {
    Row() {
      Column() {
        Row() {
          FormComponent({
            id: this.staticFormId1_1,
            name: 'StaticMusicLockCard',
            bundle: 'com.samples.arktscard',
            ability: 'EntryFormAbility',
            module: 'entry',
            dimension: FormDimension.DIMENSION_1_1,
            temporary: false,
            renderingMode: FormRenderingMode.SINGLE_COLOR
          })
            .allowUpdate(true)
            .size({ width: 72, height: 72 })
            .visibility(Visibility.Visible)
            .onAcquired((form: Form) => {
              Logger.info(`form info : ${JSON.stringify(form)}`);
              this.staticFormId1_1 = form.id;
              let formIds: string[] = [this.staticFormId1_1.toString()];
              formHost.setRouterProxy(formIds, (want: Want) => {
                this.want = want;
                router.pushUrl({ url: 'pages/UnlockPage' });
              });
            })
            .onError((err: Error) => {
              Logger.info(`fail to add form, err: ${JSON.stringify(err)}`);
            })
          FormComponent({
            id: this.dynamicFormId1_1,
            name: 'DynamicMusicLockCard',
            bundle: 'com.samples.arktscard',
            ability: 'EntryFormAbility',
            module: 'entry',
            dimension: FormDimension.DIMENSION_1_1,
            temporary: false,
            renderingMode: FormRenderingMode.SINGLE_COLOR
          })
            .allowUpdate(true)
            .size({ width: 72, height: 72 })
            .visibility(Visibility.Visible)
            .margin({
              left: '48px'
            })
            .onAcquired((form: Form) => {
              Logger.info(`form info : ${JSON.stringify(form)}`);
              this.dynamicFormId1_1 = form.id;
              let formIds: string[] = [this.dynamicFormId1_1.toString()];
              formHost.setRouterProxy(formIds, (want: Want) => {
                this.want = want;
                router.pushUrl({ url: 'pages/UnlockPage' });
              });
            })
            .onError((err: Error) => {
              Logger.info(`fail to add form, err: ${JSON.stringify(err)}`);
            })
        }

        FormComponent({
          id: this.dynamicFormId1_2,
          name: 'DynamicMusicLockLongCard',
          bundle: 'com.samples.arktscard',
          ability: 'EntryFormAbility',
          module: 'entry',
          dimension: FormDimension.Dimension_1_2,
          temporary: false,
          renderingMode: FormRenderingMode.SINGLE_COLOR
        })
          .allowUpdate(true)
          .borderRadius('54px')
          .size({ width: 174, height: 72 })
          .visibility(Visibility.Visible)
          .margin({
            top: '48px'
          })
          .onAcquired((form: Form) => {
            Logger.info(`form info : ${JSON.stringify(form)}`);
            this.dynamicFormId1_2 = form.id;
            let formIds: string[] = [this.dynamicFormId1_2.toString()];
            formHost.setRouterProxy(formIds, (want: Want) => {
              this.want = want;
              router.pushUrl({ url: 'pages/UnlockPage' });
            });
          })
          .onError((err: Error) => {
            Logger.info(`fail to add form, err: ${JSON.stringify(err)}`);
          })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: '24px', left: '72px' })

      Column() {
        FormComponent({
          id: this.staticFormId1_2,
          name: 'StaticMusicLockLongCard',
          bundle: 'com.samples.arktscard',
          ability: 'EntryFormAbility',
          module: 'entry',
          dimension: FormDimension.Dimension_1_2,
          temporary: false,
          renderingMode: FormRenderingMode.SINGLE_COLOR
        })
          .allowUpdate(true)
          .borderRadius('54px')
          .size({ width: 174, height: 72 })
          .visibility(Visibility.Visible)
          .onAcquired((form: Form) => {
            Logger.info(`form info : ${JSON.stringify(form)}`);
            this.staticFormId1_2 = form.id;
            let formIds: string[] = [this.staticFormId1_2.toString()];
            formHost.setRouterProxy(formIds, (want: Want) => {
              this.want = want;
              router.pushUrl({ url: 'pages/UnlockPage' });
            });
          })
          .onError((err: Error) => {
            Logger.info(`fail to add form, err: ${JSON.stringify(err)}`);
          });
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: '24px', left: '48px' })
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Top)
    .backgroundImage($r('app.media.lock'))
    .backgroundImageSize({ width: '100%', height: '100%' })
  }
}
