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

import router from '@ohos.router'
import distributedAccount from '@ohos.account.distributedAccount'
import promptAction from '@ohos.promptAction'
import relationalStore from '@ohos.data.relationalStore'
import osAccount from '@ohos.account.osAccount'
import { TitleBar } from '../../common/component/TitleBar'
import { ListItemComponent } from '../../common/component/ListItemComponent'
import Logger from '../../model/Logger'
import DistributedAccountModel from '../../model/DistributedAccountModel'
import DatabaseUtils from '../../common/utils/DatabaseUtils'
import CommonConstants from '../../common/constants/CommonConstants'
import  { GlobalContext, routerParams } from '../../common/database/GlobalContext';

const TAG: string = `[DistributedAccountInfo]`
let distributedInfo: distributedAccount.DistributedInfo = (router.getParams() as routerParams).distributedInfo;
let distributedAccountModel = new DistributedAccountModel();

@Entry
@Component
struct DistributedAccountInfo {
  @State localName: string = ''

  aboutToAppear() {
    DatabaseUtils.queryAccountData(distributedInfo.name, GlobalContext.getrdbStore())
      .then(async (accountData: relationalStore.ResultSet) => {
        accountData.goToFirstRow()
        let accountManager = osAccount.getAccountManager();
        let accountInfo = await accountManager.queryOsAccountById(accountData.getLong(accountData.getColumnIndex(CommonConstants.FIELD_LOCAL_ID)))
        this.localName = accountInfo.localName
        accountData.close()
      })
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        TitleBar({ title: $r('app.string.DistributedAccount_info') })
        if (distributedInfo.avatar === '') {
          Image($r('app.media.ic_user_portrait'))
            .width(64)
            .aspectRatio(1)
            .borderRadius(32)
        } else {
          Image(distributedInfo.avatar)
            .width(56)
            .aspectRatio(1)
            .borderRadius(28)
        }

        Text($r('app.string.DistributedAccount_info'))
          .width('100%')
          .align(Alignment.Start)
          .padding({ left: 12 })
          .fontSize(16)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))

        Column() {
          ListItemComponent({ title: $r('app.string.AccountName'), endText: distributedInfo.name })
          ListItemComponent({ title: $r('app.string.NickName'), endText: distributedInfo.nickname })
          if (this.localName !== '') {
            ListItemComponent({ title: $r('app.string.Bound_System_Account'), endText: this.localName })
          }
        }
        .padding({ left: 12, right: 12, top: 4 })
        .borderRadius(24)
        .backgroundColor($r('sys.color.ohos_id_color_background'))

        Button($r('app.string.Unbind'))
          .id('Unbind')
          .width('100%')
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.unbind'),
                message: '',
                autoCancel: true,
                alignment: DialogAlignment.Bottom,
                offset: { dx: 0, dy: -20 },
                primaryButton: {
                  value: $r('app.string.Cancel'),
                  action: () => {
                    Logger.info(TAG, 'Callback when the first button is clicked')
                  }
                },
                secondaryButton: {
                  value: $r('app.string.unbind'),
                  fontColor: Color.Red,
                  action: () => {
                    DatabaseUtils.queryAccountData(distributedInfo.name, GlobalContext.getrdbStore())
                      .then((accountData: relationalStore.ResultSet) => {
                        accountData.goToFirstRow()
                        distributedAccountModel.unBind(accountData.getLong(accountData.getColumnIndex(CommonConstants.FIELD_LOCAL_ID)), accountData.getString(accountData.getColumnIndex(CommonConstants.FIELD_DISTRIBUTED_ACCOUNT_ID)), distributedInfo.name)
                          .then(() => {
                            router.replaceUrl({
                              url: 'pages/Index'
                            })
                            setTimeout(() => {
                              promptAction.showToast({ message: $r('app.string.Unbind_successful') })
                            }, 500)
                          })
                          .catch(() => {
                            promptAction.showToast({ message: $r('app.string.Unbind_failed') })
                          });
                        accountData.close()
                      })
                  }
                },
                cancel: () => {
                  Logger.info(TAG, 'Closed callbacks')
                }
              }
            )
          })
      }
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .scrollBar(BarState.Off)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .padding({
      top: $r('sys.float.ohos_id_default_padding_top'),
      bottom: $r('sys.float.ohos_id_default_padding_bottom_fixed'),
      left: $r('sys.float.ohos_id_max_padding_start'),
      right: $r('sys.float.ohos_id_max_padding_end')
    })
  }
}