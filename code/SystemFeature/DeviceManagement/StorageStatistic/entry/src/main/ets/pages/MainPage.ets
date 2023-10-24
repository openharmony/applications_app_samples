/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http:// www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


import Logger from '../utils/Logger';
import { QueryStorageData } from '../common/QueryStorageData';
import { StorageList } from './StorageList';
import abilityAccessCtrl, { PermissionRequestResult, Permissions } from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';

const TAG: string = 'MainPage';
const permissions: Array<Permissions> = ['ohos.permission.GET_INSTALLED_BUNDLE_LIST'];

@Entry
@Component
struct MainPage {
  @State isStorageDataInit: boolean = false;
  private queryStorageData: QueryStorageData = new QueryStorageData();

  async aboutToAppear() {
    let context = getContext(this) as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();
    try {
      await atManager.requestPermissionsFromUser(context, permissions).then((data:PermissionRequestResult) => {
        Logger.info(TAG, `data: ${JSON.stringify(data)}`);
      }).catch((err: BusinessError) => {
        Logger.info(TAG, `err: ${JSON.stringify(err)}`);
      })
    } catch(err) {
      Logger.info(TAG, `catch err->${JSON.stringify(err)}`);
    }
    this.queryStorageData.initData((hasInit: boolean) => {
      this.isStorageDataInit = hasInit;
      AppStorage.SetOrCreate('appDataList', this.queryStorageData.appDataList);
    })
  }

  build() {
    Scroll() {
      Column() {
        Text($r('app.string.main_storage_stats'))
          .width('100%')
          .margin({ bottom: 12, top: 12 })
          .textAlign(TextAlign.Start)
        if (this.isStorageDataInit) {
          StorageList({ queryData: this.queryStorageData })
        } else {
          Row() {
            LoadingProgress()
              .size({ width: 30, height: 30 })
              .color(Color.Gray)
            Text($r('app.string.common_please_wait'))
              .fontColor(Color.Gray)
          }
          .justifyContent(FlexAlign.Center)
        }
      }
      .constraintSize({ minHeight: '100%' })
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor($r('app.color.background'))
  }
}