/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import {
  addAsset, removeAsset, updateAsset, queryAssetPlaintext, queryAssetAttribute, queryBatchAssetAttributes,
  addUserAuthAsset, removeUserAuthAsset, queryUserAuthAsset,
  addGroupAsset, removeGroupAsset, updateGroupAsset, queryGroupAssetPlaintext, queryGroupAssetAttribute,
  addSyncAsset, querySyncResult
} from '../operations';

@Entry
@Component
struct Index {
  @State message1: string = 'Add Asset';
  @State message2: string = 'Query Asset Plaintext';
  @State message3: string = 'Query Asset Attribute';
  @State message4: string = 'Query Batch Asset Attributes';
  @State message5: string = 'Update Asset';
  @State message6: string = 'Remove Asset';

  @State message7: string = 'Add User-Auth Asset';
  @State message8: string = 'Query User-Auth Asset';
  @State message9: string = 'Remove User-Auth Asset';

  @State message10: string = 'Add Group Asset';
  @State message11: string = 'Query Group Asset Plaintext';
  @State message12: string = 'Query Group Asset Attribute';
  @State message13: string = 'Update Group Asset';
  @State message14: string = 'Remove Group Asset';

  @State message15: string = 'Add Sync Asset';
  @State message16: string = 'Query Sync Result';

  build() {
    Column() {
      Button(this.message1).width('70%').margin(3)
        .onClick(async () => {
          addAsset().then(str => this.message1 = str);
        })
      Button(this.message2).width('70%').margin(3)
        .onClick(async () => {
          queryAssetPlaintext().then(str => this.message2 = str);
        })
      Button(this.message3).width('70%').margin(3)
        .onClick(async () => {
          queryAssetAttribute().then(str => this.message3 = str);
        })
      Button(this.message4).width('70%').margin(3)
        .onClick(async () => {
          queryBatchAssetAttributes().then(str => this.message4 = str);
        })
      Button(this.message5).width('70%').margin(3)
        .onClick(async () => {
          updateAsset().then(str => this.message5 = str);
        })
      Button(this.message6).width('70%').margin(3)
        .onClick(async () => {
          removeAsset().then(str => this.message6 = str);
        })
      Button(this.message7).width('70%').margin(3)
        .onClick(async () => {
          addUserAuthAsset().then(str => this.message7 = str);
        })
      Button(this.message8).width('70%').margin(3)
        .onClick(async () => {
          queryUserAuthAsset().then(str => this.message8 = str);
        })
      Button(this.message9).width('70%').margin(3)
        .onClick(async () => {
          removeUserAuthAsset().then(str => this.message9 = str); // 需设置设备锁屏密码。
        })
      Button(this.message10).width('70%').margin(3)
        .onClick(async () => {
          addGroupAsset().then(str => this.message10 = str);
        })
      Button(this.message11).width('70%').margin(3)
        .onClick(async () => {
          queryGroupAssetPlaintext().then(str => this.message11 = str);
        })
      Button(this.message12).width('70%').margin(3)
        .onClick(async () => {
          queryGroupAssetAttribute().then(str => this.message12 = str);
        })
      Button(this.message13).width('70%').margin(3)
        .onClick(async () => {
          updateGroupAsset().then(str => this.message13 = str);
        })
      Button(this.message14).width('70%').margin(3)
        .onClick(async () => {
          removeGroupAsset().then(str => this.message14 = str);
        })
      Button(this.message15).width('70%').margin(3)
        .onClick(async () => {
          addSyncAsset().then(str => this.message15 = str);
        })
      Button(this.message16).width('70%').margin(3)
        .onClick(async () => {
          querySyncResult().then(str => this.message16 = str);
        })
    }
    .height('100%')
    .width('100%')
  }
}