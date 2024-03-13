/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';
import distributedAccount from '@ohos.account.distributedAccount';
import osAccount from '@ohos.account.osAccount';
import Logger from '../../model/Logger';
import DistributedAccountModel from '../../model/DistributedAccountModel';
import DistributedAccountDataSource from '../../model/BasicDataSource';

const TAG: string = `[DistributedAccountList]`
let distributedAccountModel = new DistributedAccountModel();

@Entry
@Component
struct DistributedAccountList {
  private distributedAccountArr: DistributedAccountDataSource = new DistributedAccountDataSource([])
  private accountArr: Array<osAccount.OsAccountInfo> = []

  async onPageShow() {
    this.distributedAccountArr.clearData();
    let accountManager = osAccount.getAccountManager();
    this.accountArr = await accountManager.queryAllCreatedOsAccounts()
    Logger.info('queryAllCreatedOsAccounts, accountArr: ' + JSON.stringify(this.accountArr));
    for (let i = 0; i < this.accountArr.length; i++) {
      distributedAccountModel.getOsAccountDistributedInfoByLocalId(this.accountArr[i].localId)
        .then((distributedAccountInfo) => {
          // 显示可解绑的分布式帐号
          if (distributedAccountInfo.status === 1) {
            this.distributedAccountArr.pushData(distributedAccountInfo)
          }
        })
    }
    this.distributedAccountArr.notifyDataReload()
  }

  build() {
    Column({ space: 16 }) {
      Row() {
        Text($r('app.string.Logged_DistributedAccount_management'))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }
      .width('100%')
      .padding({ left: 12 })

      List({ space: 16 }) {
        LazyForEach(this.distributedAccountArr, (item: distributedAccount.DistributedInfo, index: number | undefined) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize(16)
                .fontWeight(500)
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
              Blank()
              Image($r('app.media.ic_arrow'))
                .width(24)
                .aspectRatio(1)
            }
            .id('distributedAccount' + index)
            .width('100%')
            .height(64)
            .borderRadius(24)
            .backgroundColor($r('sys.color.ohos_id_color_background'))
            .padding({ top: 16, bottom: 16, left: 12, right: 12 })
            .onClick(() => {
              router.pushUrl({
                url: 'distributedaccount/pages/DistributedAccountInfo',
                params: {
                  distributedInfo: item
                }
              })
            })
          }
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .padding({
      top: $r('sys.float.ohos_id_default_padding_top'),
      bottom: $r('sys.float.ohos_id_default_padding_bottom_fixed'),
      left: $r('sys.float.ohos_id_max_padding_start'),
      right: $r('sys.float.ohos_id_max_padding_end')
    })
  }
}