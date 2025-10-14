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

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';

const ASSET_SUCCESS: number = 0;

@Entry
@Component
struct Index {
  @State message: string = 'AssetStoreNdk';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
      Button('AddAsset')
        .width('70%')
        .onClick(() => {
          let ret = testNapi.AddAsset();
          hilog.info(0x0000, 'testTag', 'AddAsset %{public}s', ret);
          if (ret === ASSET_SUCCESS) {
            this.message = 'AddAsset success';
          } else {
            this.message = 'AddAsset failed';
          }
        })
      Button('QueryAssetPlaintext')
        .width('70%')
        .onClick(() => {
          let ret = testNapi.QueryAssetPlaintext();
          hilog.info(0x0000, 'testTag', 'QueryAssetPlaintext %{public}s', ret);
          if (ret === ASSET_SUCCESS) {
            this.message = 'QueryAssetPlaintext success';
          } else {
            this.message = 'QueryAssetPlaintext failed';
          }
        })
      Button('QueryAssetAttribute')
        .width('70%')
        .onClick(() => {
          let ret = testNapi.QueryAssetAttribute();
          hilog.info(0x0000, 'testTag', 'QueryAssetAttribute %{public}s', ret);
          if (ret === ASSET_SUCCESS) {
            this.message = 'QueryAssetAttribute success';
          } else {
            this.message = 'QueryAssetAttribute failed';
          }
        })
      Button('QueryBatchAssetAttributes')
        .width('70%')
        .onClick(() => {
          let ret = testNapi.BatchQuery();
          hilog.info(0x0000, 'testTag', 'QueryBatchAssetAttributes %{public}s', ret);
          if (ret === ASSET_SUCCESS) {
            this.message = 'QueryBatchAssetAttributes success';
          } else {
            this.message = 'QueryBatchAssetAttributes failed';
          }
        })
      Button('UpdateAsset')
        .width('70%')
        .onClick(() => {
          let ret = testNapi.UpdateAsset();
          hilog.info(0x0000, 'testTag', 'UpdateAsset %{public}s', ret);
          if (ret === ASSET_SUCCESS) {
            this.message = 'UpdateAsset success';
          } else {
            this.message = 'UpdateAsset failed';
          }
        })
      Button('RemoveAsset')
        .width('70%')
        .onClick(() => {
          let ret = testNapi.RemoveAsset();
          hilog.info(0x0000, 'testTag', 'RemoveAsset %{public}s', ret);
          if (ret === ASSET_SUCCESS) {
            this.message = 'RemoveAsset success';
          } else {
            this.message = 'RemoveAsset failed';
          }
        })
      Button('AddGroupAsset')
        .width('70%')
        .onClick(() => {
          let ret = testNapi.AddGroupAsset();
          hilog.info(0x0000, 'testTag', 'AddGroupAsset %{public}s', ret);
          if (ret === ASSET_SUCCESS) {
            this.message = 'AddGroupAsset success';
          } else {
            this.message = 'AddGroupAsset failed';
          }
        })
      Button('QueryGroupAssetPlaintext')
        .width('70%')
        .onClick(() => {
          let ret = testNapi.QueryGroupPlaintext();
          hilog.info(0x0000, 'testTag', 'QueryGroupAssetPlaintext %{public}s', ret);
          if (ret === ASSET_SUCCESS) {
            this.message = 'QueryGroupAssetPlaintext success';
          } else {
            this.message = 'QueryGroupAssetPlaintext failed';
          }
        })
      Button('QueryGroupAssetAttribute')
        .width('70%')
        .onClick(() => {
          let ret = testNapi.QueryGroupAttribute();
          hilog.info(0x0000, 'testTag', 'QueryGroupAssetAttribute %{public}s', ret);
          if (ret === ASSET_SUCCESS) {
            this.message = 'QueryGroupAssetAttribute success';
          } else {
            this.message = 'QueryGroupAssetAttribute failed';
          }
        })
      Button('UpdateGroupAsset')
        .width('70%')
        .onClick(() => {
          let ret = testNapi.UpdateGroupAsset();
          hilog.info(0x0000, 'testTag', 'UpdateGroupAsset %{public}s', ret);
          if (ret === ASSET_SUCCESS) {
            this.message = 'UpdateGroupAsset success';
          } else {
            this.message = 'UpdateGroupAsset failed';
          }
        })
      Button('RemoveGroupAsset')
        .width('70%')
        .onClick(() => {
          let ret = testNapi.RemoveGroupAsset();
          hilog.info(0x0000, 'testTag', 'RemoveGroupAsset %{public}s', ret);
          if (ret === ASSET_SUCCESS) {
            this.message = 'RemoveGroupAsset success';
          } else {
            this.message = 'RemoveGroupAsset failed';
          }
        })
      Button('AddSyncAsset')
        .width('70%')
        .onClick(() => {
          let ret = testNapi.AddSyncAsset();
          hilog.info(0x0000, 'testTag', 'AddSyncAsset %{public}s', ret);
          if (ret === ASSET_SUCCESS) {
            this.message = 'AddSyncAsset success';
          } else {
            this.message = 'AddSyncAsset failed';
          }
        })
      Button('QuerySyncResult')
        .width('70%')
        .onClick(() => {
          let ret = testNapi.QuerySyncResult();
          hilog.info(0x0000, 'testTag', 'QuerySyncResult %{public}s', ret);
          if (ret === ASSET_SUCCESS) {
            this.message = 'QuerySyncResult success';
          } else {
            this.message = 'QuerySyncResult failed';
          }
        })
    }
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}