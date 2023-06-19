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
import promptAction from '@ohos.promptAction';
import picker from '@ohos.file.picker';
import osAccount from '@ohos.account.osAccount';
import Logger from '../model/Logger';
import DistributedAccountModel from '../model/DistributedAccountModel';

const TAG: string = `[Index]`
let distributedAccountModel = new DistributedAccountModel();

@Entry
@Component
struct Index {
  @State photoSelectUri: string = ''
  @State osAccountSelect: string = ''
  localIdSelect: number
  @State accountArr: Array<osAccount.OsAccountInfo> = []
  @State accountSelectArr: Array<SelectOption> = []
  @State distributedAccountName: string = ''
  @State distributedAccountNickName: string = ''

  // 选择头像
  PhotoSelect() {
    try {
      let PhotoSelectOptions = new picker.PhotoSelectOptions();
      PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      PhotoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new picker.PhotoViewPicker();
      photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult) => {
        Logger.info(TAG, 'PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
        this.photoSelectUri = PhotoSelectResult.photoUris[0]
        Logger.info(TAG, 'PhotoViewPicker：' + this.photoSelectUri);
      }).catch((err) => {
        Logger.error(TAG, 'PhotoViewPicker.select failed with err: ' + err);
      });
    } catch (err) {
      Logger.error(TAG, 'PhotoViewPicker failed with err: ' + err);
    }
  }

  async aboutToAppear() {
    // 判断是否绑定
    distributedAccountModel.getOsAccountDistributedInfo().then((data) => {
      // 已绑定直接跳转
      if (data.name !== 'ohosAnonymousName') {
        router.replaceUrl({
          url: 'pages/DistributedAccountList'
        })
      }
    })
    // 获取所有系统帐号
    let accountManager = osAccount.getAccountManager();
    try {
      this.accountArr = await accountManager.queryAllCreatedOsAccounts()
      Logger.info(TAG, 'queryAllCreatedOsAccounts, accountArr: ' + JSON.stringify(this.accountArr));
      let OsAccountArray = []
      for (let i = 0; i < this.accountArr.length; i++) {
        OsAccountArray.push({ value: this.accountArr[i].localName, icon: this.accountArr[i].photo })
      }
      Logger.info(TAG, 'queryAllCreatedOsAccounts OsAccountArray:' + JSON.stringify(this.accountSelectArr));
      this.accountSelectArr = OsAccountArray
    } catch (e) {
      Logger.error(TAG, 'queryAllCreatedOsAccounts exception:' + JSON.stringify(e));
    }
  }

  build() {
    Scroll() {
      Column({ space: 20 }) {
        if (this.photoSelectUri === '') {
          Text($r('app.string.select_avatar'))
            .id('select_avatar')
            .width(72)
            .align(Alignment.Center)
            .aspectRatio(1)
            .fontSize(16)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .backgroundColor($r('sys.color.ohos_id_color_background'))
            .borderRadius(36)
            .onClick(() => {
              this.PhotoSelect()
            })
        } else {
          Image(this.photoSelectUri)
            .width(72)
            .aspectRatio(1)
            .borderRadius(36)
        }

        TextInput({ placeholder: $r('app.string.AccountName_input'), text: this.distributedAccountName })
          .id('distributedAccountName')
          .onChange((value: string) => {
            this.distributedAccountName = value
          })

        TextInput({ placeholder: $r('app.string.AccountNickName_input'), text: this.distributedAccountNickName })
          .id('distributedAccountNickName')
          .onChange((value: string) => {
            this.distributedAccountNickName = value
          })

        Row() {
          Text($r('app.string.select_osAccount'))
            .fontSize(16)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
          Blank()
          if (this.accountSelectArr.length !== 0) {
            Select(this.accountSelectArr)
              .id('select')
              .font({ size: 16, weight: FontWeight.Regular })
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .selectedOptionFont({ size: 16, weight: FontWeight.Normal })
              .optionFont({ size: 16, weight: FontWeight.Normal })
              .onSelect((index: number) => {
                this.osAccountSelect = this.accountSelectArr[index].value.toString()
                this.localIdSelect = this.accountArr[index].localId
              })
          }
        }
        .width('100%')

        Button($r('app.string.Bind'))
          .id('Bind')
          .width('100%')
          .onClick(() => {
            distributedAccountModel.Bind(this.localIdSelect, this.distributedAccountName, this.distributedAccountNickName, this.photoSelectUri)
              .then(() => {
                router.replaceUrl({
                  url: 'pages/DistributedAccountList'
                })
                setTimeout(() => {
                  promptAction.showToast({ message: $r('app.string.Bind_successful') })
                }, 100)
              })
              .catch(() => {
                promptAction.showToast({ message: $r('app.string.Bind_failed') })
              });
          })
      }
      .width('100%')
      .constraintSize({
        minHeight: '100%'
      })
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .padding({
        top: $r('sys.float.ohos_id_default_padding_top'),
        bottom: $r('sys.float.ohos_id_default_padding_bottom_fixed'),
        left: $r('sys.float.ohos_id_max_padding_start'),
        right: $r('sys.float.ohos_id_max_padding_end')
      })
    }
  }
}