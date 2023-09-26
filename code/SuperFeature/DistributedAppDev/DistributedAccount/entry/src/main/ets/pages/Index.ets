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
import relationalStore from '@ohos.data.relationalStore';
import { BusinessError } from '@ohos.base';
import Logger from '../model/Logger';
import DistributedAccountModel from '../model/DistributedAccountModel';
import DatabaseUtils from '../common/utils/DatabaseUtils';
import { GlobalContext } from '../common/database/GlobalContext';

const TAG: string = `[Index]`
let distributedAccountModel = new DistributedAccountModel();

@Entry
@Component
struct Index {
  @State clickable: boolean = false
  @State photoSelectUri: string = ''
  @State @Watch('setClickable') osAccountSelect: string = ''
  localIdSelect: number = 0
  @State accountArr: Array<osAccount.OsAccountInfo> = []
  @State accountSelectArr: Array<SelectOption> = []
  @State @Watch('setClickable') distributedAccountName: string = ''
  @State distributedAccountNickName: string = ''

  // 选择头像
  photoSelect() {
    try {
      let photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new picker.PhotoViewPicker();
      photoPicker.select(photoSelectOptions).then((PhotoSelectResult) => {
        Logger.info(TAG, 'PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
        this.photoSelectUri = PhotoSelectResult.photoUris[0]
        Logger.info(TAG, 'PhotoViewPicker：' + this.photoSelectUri);
      }).catch((err: BusinessError) => {
        Logger.error(TAG, 'PhotoViewPicker.select failed with err: ' + err);
      });
    } catch (err) {
      Logger.error(TAG, 'PhotoViewPicker failed with err: ' + err);
    }
  }

  // 设置clickable标识值
  setClickable() {
    if (this.distributedAccountName !== '' && this.osAccountSelect !== '') {
      this.clickable = true
    }
  }

  async aboutToAppear() {
    // 判断是否绑定
    distributedAccountModel.getOsAccountDistributedInfo().then((data) => {
      // 已绑定直接跳转
      if (data.name !== 'ohosAnonymousName') {
        router.replaceUrl({
          url: 'distributedaccount/pages/DistributedAccountList'
        })
      }
    })
    // 获取所有系统帐号
    let accountManager = osAccount.getAccountManager();
    try {
      this.accountArr = await accountManager.queryAllCreatedOsAccounts()
      Logger.info(TAG, 'queryAllCreatedOsAccounts, accountArr: ' + JSON.stringify(this.accountArr));
      let osAccountArray: Array<SelectOption> = []
      let items: SelectOption = {
        value: "",
        icon: ""
      }
      for (let i = 0; i < this.accountArr.length; i++) {
        items = {
          value: this.accountArr[i].localName,
          icon: this.accountArr[i].photo
        }
        osAccountArray.push(items)
      }
      Logger.info(TAG, 'queryAllCreatedOsAccounts osAccountArray:' + JSON.stringify(this.accountSelectArr));
      this.accountSelectArr = osAccountArray
    } catch (e) {
      Logger.error(TAG, 'queryAllCreatedOsAccounts exception:' + JSON.stringify(e));
    }
  }

  build() {
    Scroll() {
      Column({ space: 20 }) {
        Image(this.photoSelectUri === '' ? $r('app.media.ic_user_portrait') : this.photoSelectUri)
          .id('select_avatar')
          .width(64)
          .aspectRatio(1)
          .margin({ top: 60 })
          .borderRadius(32)
          .onClick(() => {
            this.photoSelect()
          })

        Column() {
          TextInput({ placeholder: $r('app.string.AccountName_input'), text: this.distributedAccountName })
            .id('distributedAccountName')
            .backgroundColor($r('sys.color.ohos_id_color_background'))
            .padding({ top: 15, bottom: 15, left: 12, right: 12 })
            .onChange((value: string) => {
              DatabaseUtils.queryAccountData(value, GlobalContext.getrdbStore())
                .then((result: relationalStore.ResultSet) => {
                  if (result.rowCount === 0) {
                    this.distributedAccountName = value
                  } else {
                    this.clickable = false
                  }
                  result.close()
                })
            })

          Divider().padding({ left: 12, right: 12 })

          TextInput({ placeholder: $r('app.string.AccountNickName_input'), text: this.distributedAccountNickName })
            .id('distributedAccountNickName')
            .backgroundColor($r('sys.color.ohos_id_color_background'))
            .padding({ top: 15, bottom: 15, left: 12, right: 12 })
            .onChange((value: string) => {
              this.distributedAccountNickName = value
            })
        }
        .borderRadius(24)
        .backgroundColor($r('sys.color.ohos_id_color_background'))

        Row() {
          Text($r('app.string.select_osAccount'))
            .fontSize(16)
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          Blank()
          if (this.accountSelectArr.length !== 0) {
            Select(this.accountSelectArr)
              .id('select')
              .backgroundColor('#00000000')
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
        .padding({ left: 12 })

        Button($r('app.string.Bind'))
          .id('Bind')
          .width('100%')
          .backgroundColor(this.clickable ? '#007DFF' : '#99007DFF')
          .enabled(this.clickable ? true : false)
          .onClick(() => {
            distributedAccountModel.bind(this.localIdSelect, this.distributedAccountName, this.distributedAccountNickName, this.photoSelectUri)
              .then(() => {
                router.replaceUrl({
                  url: 'distributedaccount/pages/DistributedAccountList'
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
    .scrollBar(BarState.Off)
  }
}