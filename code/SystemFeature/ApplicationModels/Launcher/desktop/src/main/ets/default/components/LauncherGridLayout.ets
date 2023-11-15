/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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


import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import wantConstant from '@ohos.ability.wantConstant';
import Want from '@ohos.app.ability.Want';
import Bubble from './Bubble';
import CardItem from './CardItem';
import { CommonConstants, GridLayoutItemInfo, Logger, LauncherDataSource, ResourceManager,
  FormCardItem } from '@ohos/base';
import { CardItemInfo } from '../../../../../../base/index';
import { DesktopLayoutModel, SHOPPING_BUNDLE } from '../model/DesktopLayoutModel';
import { FormModel } from '../../../../../../base/index';

const TAG: string = 'LauncherGridLayout'

@Component
export default struct LauncherGridLayout {
  @StorageLink('DesktopLayoutModel') desktopLayoutModel: DesktopLayoutModel | undefined = undefined;
  @StorageLink('cardLabelId') cardLabelId: string = '';
  @State columnsTemplate: string = '';
  @State rowsTemplate: string = '';
  @State gridInfos: Array<GridLayoutItemInfo> = [];
  private gridData: LauncherDataSource | undefined = undefined;
  private delayTime: number = 3000;
  private createCardTime: number = 500;

  build() {
    Grid() {
      LazyForEach(this.gridData, (item: GridLayoutItemInfo) => {
        GridItem() {
          if (item.typeId === CommonConstants.TYPE_APP) {
            Bubble({
              appInfo: item,
              icon: ResourceManager.getInstance(getContext(this))
                .getCachedAppIcon(item.appIconId, item.bundleName)
            })
          } else if (item.typeId === CommonConstants.TYPE_IMAGE) {
            Image($r('app.media.card'))
              .size({ width: '80%' })
              .aspectRatio(1)
              .onClick(async () => {
                this.startShopping()
                setTimeout(async () => {
                  await this.createCardAndInstall(item)
                }, this.delayTime)
              })
          } else {
            CardItem({ formInfo: item })
          }
        }
        .rowStart(item.row)
        .columnStart(item.column)
        .rowEnd(item.row + item.area[0] - 1)
        .columnEnd(item.column + item.area[1] - 1)
      }, (item: GridLayoutItemInfo) => {
        return `${item.typeId}${item.row}${item.column}`;
      })
    }
    .columnsTemplate(this.columnsTemplate)
    .rowsTemplate(this.rowsTemplate)
    .columnsGap(10)
    .rowsGap(10)
  }

  aboutToAppear() {
    Logger.info(TAG, `gridInfos.size = ${this.gridInfos.length}`);
    this.gridData = new LauncherDataSource(this.gridInfos);
    for (let i = 0;i < CommonConstants.DEFAULT_COLUMN_COUNT; i++) {
      this.columnsTemplate += '1fr ';
    }
    for (let i = 0;i < CommonConstants.DEFAULT_ROW_COUNT; i++) {
      this.rowsTemplate += '1fr ';
    }
    Logger.info(TAG, `this.columnsTemplate = ${this.columnsTemplate},this.rowsTemplate = ${this.rowsTemplate}`);
  }

  // 拉起元服务
  startShopping(): void {
    let orangeWant : Want = {
      bundleName: SHOPPING_BUNDLE,
      moduleName: 'entry',
      abilityName: 'EntryAbility',
      flags: wantConstant.Flags.FLAG_INSTALL_ON_DEMAND
    }
    let context = getContext(this) as common.ServiceExtensionContext
    context.startAbility(orangeWant)
  }

  // 点击桌面占位图触发免安装与替换桌面卡片的逻辑
  async createCardAndInstall(item: GridLayoutItemInfo): Promise<void> {
    // 包名需要修改 'com.samples.asorangeshopping'
    let currentBundleFormsInfo: Array<CardItemInfo> = await FormModel.getFormsInfoByBundleName(SHOPPING_BUNDLE)
    let formCardItem = new FormCardItem();
    formCardItem.cardId = 0;
    formCardItem.appName = currentBundleFormsInfo[0].appName!;
    formCardItem.cardName = currentBundleFormsInfo[0].cardName;
    formCardItem.bundleName = currentBundleFormsInfo[0].bundleName;
    formCardItem.abilityName = currentBundleFormsInfo[0].abilityName;
    formCardItem.moduleName = currentBundleFormsInfo[0].moduleName;
    formCardItem.dimension = currentBundleFormsInfo[0].supportDimensions[0];
    formCardItem.formConfigAbility = currentBundleFormsInfo[0].formConfigAbility;
    formCardItem.appLabelId = this.cardLabelId;
    Logger.info(`currentBundleFormsInfo: ${JSON.stringify(currentBundleFormsInfo)}, formCardItem: ${JSON.stringify(formCardItem)}`);

    // 如果bundleName查询失败，不替换卡片
    if (formCardItem.bundleName === '') {
      promptAction.showToast({
        message: $r('app.string.install_asorangeshopping')
      })
      return;
    }
    // 移除桌面占位图
    await this.desktopLayoutModel?.removeItemFromDeskTop(item);
    setTimeout(async () => {
      // 创建桌面卡片
      await this.desktopLayoutModel?.createCardToDeskTop(formCardItem);
    }, this.createCardTime)
    AppStorage.SetOrCreate('formMgrItem', currentBundleFormsInfo);
  }
}