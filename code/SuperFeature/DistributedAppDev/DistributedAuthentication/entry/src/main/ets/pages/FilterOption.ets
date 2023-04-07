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

import deviceInfo from '@ohos.deviceInfo';
import logger from '../common/Logger';
import router from '@ohos.router';

@CustomDialog
struct FilterOptionDialog {
  title: string;
  filterItems: string[];
  controller: CustomDialogController;
  cancel: () => void;
  confirm: (selectedIndex, title) => void;
  selectedIndex: number;
  filterOptions: Object;

  build() {
    Column() {
      Text(this.title)
        .fontSize(20)
        .fontColor('#182431')
        .fontFamily('HarmonyHeiTi-Medium')
        .fontWeight(500)
        .margin({bottom: 24})

      List() {
        ForEach(this.filterItems, (item, index) => {
          ListItem() {
            Column() {
              Row() {
                Text(item)
                  .fontSize(16)
                  .fontFamily('HarmonyHeiTi-Medium')
                  .fontWeight(500)
                  .fontColor('#182431')
                Blank()
                Radio({ value: item, group: this.title })
                  .checked(index == this.selectedIndex ? true : false)
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.selectedIndex = index;
                    }
                    logger.info(item + ' status is ' + isChecked);
                  })
                  .align(Alignment.End)
              }
              .margin({bottom: 6, top: 6})
              .width('100%')

              Divider()
                .color('#182431')
                .opacity(0.05)
                .visibility(index == this.filterItems.length - 1 ? Visibility.None : Visibility.Visible)
            }.width('100%')
            .height(48)
          }
        }, item => JSON.stringify(item))
      }.width('100%')
      .height((this.filterItems.length) * 48)

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.cancel'))
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })
          .backgroundColor(0xffffff)
          .fontColor('#007DFF')
          .fontWeight(500)
        Divider()
          .vertical(true)
          .height(24)
          .color('#182431')
          .opacity(0.2)
          .alignSelf(ItemAlign.Center)
        Button($r('app.string.confirm'))
          .onClick(() => {
            this.controller.close()
            this.confirm(this.selectedIndex, this.title)
          })
          .backgroundColor(0xffffff)
          .fontColor('#007DFF')
          .fontWeight(500)
      }
    }
    .margin({ bottom: 12, left: 12, right: 12 })
    .borderRadius(24)
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Start)
    .padding(24)
  }
}

@Entry
@Component
export struct FilterOption {
  @State deviceType: string = '';
  @State authForm: string = '';
  @State isOnline: string = '';
  @State isTrusted: string = '';
  @State range: string = '';
  dialogController: CustomDialogController = null;
  filterOptions: Object = new Object();
  onSelectedIndexChange = async (index: number, title: string) => {
    this.onSelected(index, title);
  }

  aboutToAppear() {
    try {
      this.deviceType = globalThis.DeviceTypeItemList[globalThis.filterOptions[globalThis.deviceTypeName]];
      this.authForm = globalThis.AuthFormItemList[globalThis.filterOptions[globalThis.authFormName]];
      this.isOnline = globalThis.IsOnlineItemList[globalThis.filterOptions[globalThis.isOnlineName]];
      this.isTrusted = globalThis.IsTrustedItemList[globalThis.filterOptions[globalThis.isTrustedName]];
      this.range = globalThis.RangeItemList[globalThis.filterOptions[globalThis.rangeName]];
    } catch (error) {
      logger.error(`getStringByNameSync failed, error code: ${error.code}, message: ${error.message}.`);
    }
    logger.info('aboutToAppear filterOptions = ' + JSON.stringify(globalThis.filterOptions));
  }

  onCancel() {
    logger.info('Callback when the first button is clicked');
  }

  onSelected(index: number, title: string) {
    logger.info('filterOptions = ' + JSON.stringify(globalThis.filterOptions) + ' index = ' + index +
      ' title = ' + title);
    globalThis.filterOptions[title] = index;
    this.deviceType = globalThis.DeviceTypeItemList[globalThis.filterOptions[globalThis.deviceTypeName]];
    this.authForm = globalThis.AuthFormItemList[globalThis.filterOptions[globalThis.authFormName]];
    this.isOnline = globalThis.IsOnlineItemList[globalThis.filterOptions[globalThis.isOnlineName]];
    this.isTrusted = globalThis.IsTrustedItemList[globalThis.filterOptions[globalThis.isTrustedName]];
    this.range = globalThis.RangeItemList[globalThis.filterOptions[globalThis.rangeName]];
  }

  existApp() {
    logger.info('Click the callback in the blank area');
  }

  openDialog(itemList: string[], titleResource: Resource) {
    let title = '';
    try {
      title = globalThis.resourceManager.getStringSync(titleResource.id);
    } catch (error) {
      logger.error(`getStringByNameSync failed, error code: ${error.code}, message: ${error.message}.`);
    }

    this.dialogController = new CustomDialogController({
      builder: FilterOptionDialog({
        title: title,
        filterItems: itemList,
        cancel: this.onCancel,
        confirm: this.onSelectedIndexChange,
        selectedIndex: globalThis.filterOptions[title]
      }),
      cancel: this.existApp,
      autoCancel: true,
      alignment: deviceInfo.deviceType == 'tablet' ? DialogAlignment.Center : DialogAlignment.Bottom,
      gridCount: 4,
      customStyle: deviceInfo.deviceType == 'tablet' ? false : true
    });
    this.dialogController.open();
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .height(24)
          .width(24)
          .margin({ right: 16 })
          .onClick(() => {
            router.back();
          })
          .visibility(deviceInfo.deviceType == 'tablet' ? Visibility.None : Visibility.Visible)

        Text($r('app.string.filter_options'))
          .fontColor('#182431')
          .fontFamily('HarmonyHeiTi-Medium')
          .fontWeight(500)
          .fontSize(20)
          .lineHeight(26)
      }
      .width('100%')
      .margin({top: 12, bottom: 24})
      .padding({ left: 12 })

      Column() {
        Row() {
          Text($r('app.string.device_type'))
            .fontColor('#182431')
            .fontSize(16)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontWeight(500)
          Blank()
          Text(this.deviceType)
            .fontColor('#182431')
            .fontFamily('HarmonyHeiTi')
            .fontSize(14)
            .opacity(0.6)
          Image($r('app.media.ic_arrow'))
            .width(12)
            .height(24)
            .margin({left: 4})
        }
        .margin({top: 4})
        .width('100%')
        .height(48)
        .onClick(() => {
          this.openDialog(globalThis.DeviceTypeItemList, $r('app.string.device_type'));
        })

        Divider()
          .color('#182431')
          .opacity(0.05)

        Row() {
          Text($r('app.string.is_online'))
            .fontColor('#182431')
            .fontSize(16)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontWeight(500)
          Blank()
          Text(this.isOnline)
            .fontColor('#182431')
            .fontFamily('HarmonyHeiTi')
            .fontSize(14)
            .opacity(0.6)
          Image($r('app.media.ic_arrow'))
            .width(12)
            .height(24)
            .margin({left: 4})
        }
        .width('100%')
        .height(48)
        .onClick(() => {
          this.openDialog(globalThis.IsOnlineItemList, $r('app.string.is_online'));
        })

        Divider()
          .color('#182431')
          .opacity(0.05)

        Row() {
          Text($r('app.string.is_trusted'))
            .fontColor('#182431')
            .fontSize(16)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontWeight(500)
          Blank()
          Text(this.isTrusted)
            .fontColor('#182431')
            .fontFamily('HarmonyHeiTi')
            .fontSize(14)
            .opacity(0.6)
          Image($r('app.media.ic_arrow'))
            .width(12)
            .height(24)
            .margin({left: 4})
        }
        .width('100%')
        .height(48)
        .onClick(() => {
          this.openDialog(globalThis.IsTrustedItemList, $r('app.string.is_trusted'));
        })

        Divider()
          .color('#182431')
          .opacity(0.05)

        Row() {
          Text($r('app.string.auth_form'))
            .fontColor('#182431')
            .fontSize(16)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontWeight(500)
          Blank()
          Text(this.authForm)
            .fontColor('#182431')
            .fontFamily('HarmonyHeiTi')
            .fontSize(14)
            .opacity(0.6)
          Image($r('app.media.ic_arrow'))
            .width(12)
            .height(24)
            .margin({left: 4})
        }
        .width('100%')
        .height(48)
        .onClick(() => {
          this.openDialog(globalThis.AuthFormItemList, $r('app.string.auth_form'));
        })

        Divider()
          .color('#182431')
          .opacity(0.05)

        Row() {
          Text($r('app.string.range'))
            .fontColor('#182431')
            .fontSize(16)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontWeight(500)
          Blank()
          Text(this.range)
            .fontColor('#182431')
            .fontFamily('HarmonyHeiTi')
            .fontSize(14)
            .opacity(0.6)
          Image($r('app.media.ic_arrow'))
            .width(12)
            .height(24)
            .margin({left: 4})
        }
        .width('100%')
        .height(48)
        .onClick(() => {
          this.openDialog(globalThis.RangeItemList, $r('app.string.range'));
        })
        .margin({bottom: 4})
      }.width('100%')
      .borderRadius(24)
      .padding({left: 12, right: 12})
      .backgroundColor('#FFFFFF')
    }.backgroundColor('#F1F3F5')
    .padding(12)
    .width('100%')
    .height('100%')
  }
}