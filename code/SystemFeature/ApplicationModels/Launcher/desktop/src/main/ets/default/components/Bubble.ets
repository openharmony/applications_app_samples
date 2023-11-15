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

import { DesktopLayoutModel } from '../model/DesktopLayoutModel'
import {
  AppMenu,
  CardItemInfo,
  CheckEmptyUtils,
  CommonConstants,
  DeleteDialog,
  FormCardItem,
  GridLayoutItemInfo,
  Logger,
  MenuInfo,
  ResourceManager
} from '@ohos/base'
import notificationSubscribe from '@ohos.notificationSubscribe';

const TAG: string = 'Bubble'

@Component
export default struct Bubble {
  @StorageLink('DesktopLayoutModel') desktopLayoutModel: DesktopLayoutModel | undefined = undefined;
  private appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
  private mDefaultAppIcon: string = '';
  private menuInfos: Array<MenuInfo> | undefined = [];
  private context: Context | undefined = undefined;
  @State customPopup: boolean = false;
  @State formInfo: CardItemInfo = new CardItemInfo();
  @State icon: string = '';
  @State badgeNum: number = 0;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: DeleteDialog({
      confirm: () => {
        // 卸载应用的逻辑
        this.desktopLayoutModel?.uninstallAppItem(this.appInfo);
      },
      appInfo: this.appInfo,
      dialogContent: this.appInfo.appName + ' ?',
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom
  })

  @Builder MenuBuilder() {
    Column() {
      AppMenu({
        menuInfos: this.menuInfos
      })
    }
    .justifyContent(FlexAlign.Center)
    .width(243)
    .borderRadius(12)
  }

  @Builder popupBuilder() {
    Stack({ alignContent: Alignment.TopEnd }) {
      FormComponent({
        id: this.formInfo.cardId,
        name: this.formInfo.cardName,
        bundle: this.formInfo.bundleName,
        ability: this.formInfo.abilityName,
        module: this.formInfo.moduleName,
        dimension: this.formInfo.supportDimensions[0]
      })
        .clip(new Rect({
          width: CommonConstants.FORM_COMPONENT_WIDTH[this.formInfo.supportDimensions[0] - 1],
          height: CommonConstants.FORM_COMPONENT_HEIGHT[this.formInfo.supportDimensions[0] - 1],
          radius: CommonConstants.DEFAULT_CARD_RADIUS
        }))
        .size({
          width: CommonConstants.FORM_COMPONENT_WIDTH[this.formInfo.supportDimensions[0] - 1],
          height: CommonConstants.FORM_COMPONENT_HEIGHT[this.formInfo.supportDimensions[0] - 1]
        })
        .onAcquired(form => {
          this.formInfo.cardId = form.id
          Logger.info(TAG, `onAcquired this.formInfo.cardId: ${this.formInfo.cardId}`)
        })

      Image($r('app.media.add'))
        .size({ width: 30, height: 30 })
        .objectFit(ImageFit.Cover)
        .backgroundColor(0x77000000)
        .borderRadius(16)
        .onClick(() => {
          let selectForm = this.getSelectedFormInfo()
          if (!CheckEmptyUtils.isEmpty(selectForm)) {
            this.desktopLayoutModel?.createCardToDeskTop(this.getSelectedFormInfo())
          }
          this.customPopup = false
        })
    }
  }

  build() {
    Column() {
      Badge({
        count: this.badgeNum,
        position: BadgePosition.RightTop,
        style: {badgeSize: 16, badgeColor: '#FA2A2D'}
      })
      {
        Image(this.icon)
          .height('50%')
          .aspectRatio(1)
          .objectFit(ImageFit.Cover)
          .borderRadius(10)
      }
      if (this.formInfo) {
        Text(this.appInfo.appName)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .maxLines(1)
          .margin({ top: 5 })
          .width('90%')
          .fontSize(14)
          .bindPopup(this.customPopup, {
            builder: this.popupBuilder,
            placement: Placement.Top,
            maskColor: 0x33000000,
            popupColor: Color.White,
            enableArrow: false,
            onStateChange: (e) => {
              if (!e.isVisible) {
                this.customPopup = false
              }
            }
          })
      } else {
        Text(this.appInfo.appName)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .maxLines(1)
          .margin({ top: 5 })
          .width('90%')
          .fontSize(14)
      }
    }
    .bindContextMenu(this.MenuBuilder, ResponseType.LongPress)
    .gesture(
    PanGesture({ fingers: 1, direction: PanDirection.Up, distance: 20 })
      .onActionStart((event: GestureEvent) => {
        console.info('Pan start')
      })
      .onActionUpdate((event: GestureEvent) => {
      })
      .onActionEnd(() => {
        console.info('Pan end')
        if (this.formInfo) {
          this.customPopup = true
        }
      })
    )
    .onClick(() => {
      this.desktopLayoutModel?.jumpTo(this.appInfo.abilityName, this.appInfo.bundleName)
    })
  }

  aboutToAppear() {
    this.updateIcon();
    this.menuInfos = this.desktopLayoutModel?.buildMenuInfoList(this.appInfo, this.dialogController);
    let appFormInfo = this.desktopLayoutModel?.getAppItemFormInfo(this.appInfo.bundleName!);
    if (appFormInfo && appFormInfo.length > 0) {
      this.formInfo = appFormInfo[0];
    }
    let subscriber: notificationSubscribe.NotificationSubscriber = {
      onConsume: this.onConsumeCallback,
      onCancel: this.onCancelCallback,
      onBadgeChanged: (data: BadgeNumberCallbackData) => {
        if (data.bundle === this.appInfo.bundleName) {
          this.badgeNum = data.badgeNumber;
          console.info("bundle: ", data.bundle);
          console.info("uid: ", data.uid);
          console.info("badgeNumber: ", data.badgeNumber);
        }
      }
    }
    let info: notificationSubscribe.NotificationSubscribeInfo = {
      bundleNames: [this.appInfo.bundleName!]
    };
    notificationSubscribe.subscribe(subscriber, info).then(() => {
      console.info(JSON.stringify(this.appInfo.bundleName) + "subscribe success");
    })
  }

  onConsumeCallback = (data: notificationSubscribe.SubscribeCallbackData) => {
    this.badgeNum += 1;
    console.info("Consume callback : " + JSON.stringify(data));
  }

  onCancelCallback = (data: notificationSubscribe.SubscribeCallbackData) => {
    console.info("Cancel callback" + JSON.stringify(data));
  }

  iconLoadCallback = (image: string) => {
    this.icon = image
  }

  public updateIcon() {
    ResourceManager.getInstance(this.context)
      .getAppIconWithCache(this.appInfo.appIconId, this.appInfo.bundleName,
        this.iconLoadCallback, this.mDefaultAppIcon)
  }

  getSelectedFormInfo(): FormCardItem | undefined {
    if (CheckEmptyUtils.isEmpty(this.formInfo)) {
      return undefined;
    }
    let formCardItem = new FormCardItem();
    formCardItem.cardId = this.formInfo.cardId;
    formCardItem.appName = this.appInfo.appName!;
    formCardItem.cardName = this.formInfo.cardName;
    formCardItem.bundleName = this.formInfo.bundleName;
    formCardItem.abilityName = this.formInfo.abilityName;
    formCardItem.moduleName = this.formInfo.moduleName;
    formCardItem.dimension = this.formInfo.supportDimensions[0];
    formCardItem.formConfigAbility = this.formInfo.formConfigAbility;
    formCardItem.appLabelId = this.formInfo.appLabelId;
    return formCardItem;
  }
}

export interface BadgeNumberCallbackData {
  readonly bundle: string;
  readonly uid: number;
  readonly badgeNumber: number;
}