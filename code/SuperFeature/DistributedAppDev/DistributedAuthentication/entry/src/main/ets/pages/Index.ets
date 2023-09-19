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

import deviceInfo from '@ohos.deviceInfo';
import deviceManager from '@ohos.distributedHardware.deviceManager';
import logger from '../common/Logger';
import remoteDeviceModel from '../model/RemoteDeviceModel';
import router from '@ohos.router';
import { FilterOption } from '../pages/FilterOption';
import { ListDeviceView } from '../pages/ListDeviceView';

@Entry
@Component
struct Index {
  @State isShowLoading: boolean = false;
  @State indexWidth: string = '100%';
  @StorageLink('localDevice') localDevice: deviceManager.DeviceInfo = null;
  @StorageLink('trustedDeviceList') trustedDeviceList: Array<deviceManager.DeviceInfo> =
    new Array<deviceManager.DeviceInfo>();
  @StorageLink('discoverDeviceList') discoverDeviceList: Array<deviceManager.DeviceInfo> =
    new Array<deviceManager.DeviceInfo>();
  @State isSupportRange: boolean = false;
  @State isAllowDiscovered: boolean = true;
  @State isLocalDeviceActive: boolean = false;
  @State filterOption: string = '';
  @State isDiscovering: boolean = false;

  scroller: Scroller = new Scroller();

  async routeFilterOptionPage() {
    let options = {
      url: 'pages/FilterOption',
    };
    try {
      await router.pushUrl(options);
    } catch (err) {
      logger.info(`fail callback, code: ${err.code}, msg: ${err.msg}`);
    }
  }

  getDeviceTypeIcon(deviceType): Resource {
    if (deviceType == deviceManager.DeviceType.TABLET) {
      return $r('app.media.ic_pad');
    } else if (deviceType == deviceManager.DeviceType.PHONE) {
      return $r('app.media.ic_phone');
    } else if (deviceType == deviceManager.DeviceType.UNKNOWN_TYPE) {
      return $r('app.media.ic_pc');
    } else {
      return $r('app.media.ic_pc');
    }
  }

  async aboutToAppear() {
    await remoteDeviceModel.createDeviceManager();
    try {
      logger.info(`local deviceType:` + deviceInfo.deviceType);
      globalThis.deviceTypeName = globalThis.resourceManager.getStringSync($r('app.string.device_type').id);
      globalThis.authFormName = globalThis.resourceManager.getStringSync($r('app.string.auth_form').id);
      globalThis.isOnlineName = globalThis.resourceManager.getStringSync($r('app.string.is_online').id);
      globalThis.isTrustedName = globalThis.resourceManager.getStringSync($r('app.string.is_trusted').id);
      globalThis.rangeName = globalThis.resourceManager.getStringSync($r('app.string.range').id);
      globalThis.filterOptions = new Object();
      globalThis.filterOptions[globalThis.deviceTypeName] = 0;
      globalThis.filterOptions[globalThis.authFormName] = 0;
      globalThis.filterOptions[globalThis.isOnlineName] = 0;
      globalThis.filterOptions[globalThis.isTrustedName] = 0;
      globalThis.filterOptions[globalThis.rangeName] = 0;
    } catch (error) {
      logger.error(`getStringByNameSync failed, error code: ${error.code}, message: ${error.message}.`);
    }
  }

  getFilterOption() {
    let filterOptionList = new Object();
    filterOptionList[globalThis.deviceTypeName] = globalThis.DeviceTypeItemList;
    filterOptionList[globalThis.authFormName] = globalThis.AuthFormItemList;
    filterOptionList[globalThis.isOnlineName] = globalThis.IsOnlineItemList;
    filterOptionList[globalThis.isTrustedName] = globalThis.IsTrustedItemList;
    filterOptionList[globalThis.rangeName] = globalThis.RangeItemList;

    this.filterOption = '';
    for (var i in globalThis.filterOptions) {
      if (globalThis.filterOptions[i] == 0) {
        continue;
      }
      this.filterOption += filterOptionList[i][globalThis.filterOptions[i]] + ' ';
    }
    logger.info('[DeviceManager.RemoteDeviceModel] this.filterOption = ' + JSON.stringify(this.filterOption));
  }

  onPageShow() {
    logger.info('onPageShow');
    this.getFilterOption();
  }

  build() {
    Row() {
      Scroll(this.scroller) {
        Column() {
          Column() {
            Text($r("app.string.app_name"))
              .fontColor('#182431')
              .fontSize(24)
              .fontFamily('HarmonyHeiTi-Medium')
              .fontWeight(500)
              .width('100%')
              .margin({ top: 12, bottom: 20 })
          }.width('100%')
          .margin({ left: 24 })

          Column() {
            Row() {
              Image(this.getDeviceTypeIcon(this.localDevice.deviceType))
                .width(24)
                .height(24)
              Text(this.localDevice.deviceName)
                .fontSize(16)
                .fontColor('#182431')
                .fontFamily('HarmonyHeiTi-Medium')
                .fontWeight(500)
                .margin({ left: 8 })
            }
            .width('100%')
            .height(48)

            Divider()
              .color('#182431')
              .opacity(0.05)

            Row() {
              Text($r('app.string.support_range'))
                .fontSize(16)
                .fontColor('#182431')
                .fontFamily('HarmonyHeiTi-Medium')
                .fontWeight(500)
              Blank()
              Toggle({ type: ToggleType.Switch, isOn: this.isSupportRange })
                .selectedColor('#007DFF')
                .switchPointColor('#FFFFFF')
                .onChange((isOn: boolean) => {
                  logger.info('Component status:' + isOn);
                  this.isSupportRange = isOn;
                  remoteDeviceModel.setIsSupportRange(this.isSupportRange);
                  if (this.isAllowDiscovered) {
                    this.isAllowDiscovered = false;
                    let gThis = this;
                    setTimeout(() => {
                      gThis.isAllowDiscovered = true;
                    }, 1000);
                  }
                })
            }.width('100%')
            .height(48)

            Divider()
              .color('#182431')
              .opacity(0.05)

            Row() {
              Text($r('app.string.allowed_discovered'))
                .fontSize(16)
                .fontColor('#182431')
                .fontFamily('HarmonyHeiTi-Medium')
                .fontWeight(500)
              Blank()
              Toggle({ type: ToggleType.Switch, isOn: this.isAllowDiscovered })
                .selectedColor('#007DFF')
                .switchPointColor('#FFFFFF')
                .onChange((isOn: boolean) => {
                  logger.info('Component status:' + isOn);
                  this.isAllowDiscovered = isOn;
                  if (this.isAllowDiscovered) {
                    remoteDeviceModel.publishDeviceDiscovery();
                  } else {
                    remoteDeviceModel.unPublishDeviceDiscovery();
                  }
                })
            }.width('100%')
            .height(48)
          }.borderRadius(24)
          .backgroundColor('#FFFFFF')
          .padding({ left: 12, right: 12, top: 4, bottom: 4 })
          .width('100%')

          Column() {
            Row() {
              Text($r('app.string.trusted_devices'))
                .fontSize(14)
                .fontColor('#182431')
                .fontFamily('HarmonyHeiTi-Medium')
                .lineHeight(19)
                .margin({ left: 12, top: 19, bottom: 10 })
                .opacity(0.6)

              Blank()

              Text($r('app.string.refresh'))
                .fontSize(14)
                .fontColor('#007DFF')
                .fontFamily('HarmonyHeiTi-Medium')
                .lineHeight(19)
                .margin({ left: 12, top: 19, bottom: 10, right: 12 })
                .onClick(() => {
                  remoteDeviceModel.getTrustedDeviceList();
                  this.isShowLoading = true;
                  let gThis = this;
                  setTimeout(() => {
                    gThis.isShowLoading = false;
                  }, 3000);
                })
                .visibility(this.isShowLoading ? Visibility.None : Visibility.Visible)
              LoadingProgress()
                .color('#007DFF')
                .width(24)
                .height(24)
                .margin({ left: 12, top: 19, bottom: 10, right: 12 })
                .visibility(this.isShowLoading ? Visibility.Visible : Visibility.None)
            }.width('100%')

            List() {
              ForEach(this.trustedDeviceList, (item, index) => {
                ListItem() {
                  Column() {
                    ListDeviceView({ deviceInfo: item, visible: Visibility.Visible })
                    Divider()
                      .color('#182431')
                      .opacity(0.05)
                      .visibility(index == this.trustedDeviceList.length - 1 ? Visibility.None : Visibility.Visible)
                  }
                }
              }, item => JSON.stringify(item))
            }
            .width('100%')
            .borderRadius(24)
            .padding({ left: 12, right: 12, top: 4, bottom: 4 })
            .backgroundColor('#FFFFFF')
          }.visibility(this.trustedDeviceList.length == 0 ? Visibility.None : Visibility.Visible)

          Column() {
            Row() {
              Text($r('app.string.usable_devices'))
                .fontSize(14)
                .fontColor('#182431')
                .fontFamily('HarmonyHeiTi-Medium')
                .lineHeight(19)
                .opacity(0.6)
                .margin({ left: 12, top: 19, bottom: 10 })

              Blank()

              Text(this.isDiscovering == false ? $r('app.string.discover') : $r('app.string.stop'))
                .fontSize(14)
                .fontColor(this.isDiscovering == false ? '#007DFF' : '#FA2A2D')
                .lineHeight(19)
                .margin({ left: 12, top: 19, bottom: 10, right: 12 })
                .onClick(() => {
                  if (this.isDiscovering) {
                    remoteDeviceModel.stopDeviceDiscovery();
                  } else {
                    remoteDeviceModel.startDeviceDiscovery();
                  }
                  this.isDiscovering = !this.isDiscovering;
                })
            }.width('100%')
          }.width('100%')

          Column() {
            Column() {
              Row() {
                Text($r('app.string.filter_options'))
                  .fontSize(16)
                  .fontColor('#182431')
                  .fontFamily('HarmonyHeiTi-Medium')
                  .fontWeight(500)
                Blank()
                Row() {
                  Text(this.filterOption)
                    .fontSize(14)
                    .fontColor('#182431')
                    .fontFamily('HarmonyHeiTi')
                    .opacity(0.6)
                    .margin({ left: 12 })
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(1)
                    .fontWeight(400)
                  Image($r('app.media.ic_arrow'))
                    .width(12)
                    .height(24)
                    .margin({ left: 8 })
                }
              }.onClick(() => {
                if (deviceInfo.deviceType == 'tablet') {
                  this.indexWidth = '50%';
                } else {
                  this.routeFilterOptionPage();
                }
              })
              .width('100%')
              .margin({ top: 12, bottom: 12 })

              Divider()
                .color('#182431')
                .opacity(0.05)
                .visibility(this.discoverDeviceList.length == 0 ? Visibility.None : Visibility.Visible)
            }.height(48)
            .alignItems(HorizontalAlign.Center)

            List() {
              ForEach(this.discoverDeviceList, (item, index) => {
                ListItem() {
                  Column() {
                    ListDeviceView({ deviceInfo: item })
                    Divider()
                      .color('#182431')
                      .opacity(0.05)
                      .visibility(index == this.discoverDeviceList.length - 1 ? Visibility.None : Visibility.Visible)
                  }
                }
                .onClick(() => {
                  remoteDeviceModel.authenticateDevice(item);
                })
              }, item => JSON.stringify(item))
            }
            .visibility(this.discoverDeviceList.length == 0 ? Visibility.None : Visibility.Visible)
            .width('100%')
          }.width('100%')
          .borderRadius(24)
          .padding({ left: 12, right: 12, bottom: 4, top: 4 })
          .backgroundColor('#FFFFFF')
        }
        .padding(12)
        .width(this.indexWidth)
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Vertical)
      .height('100%')
      .backgroundColor('#F1F3F5')
      .align(Alignment.Top)

      Column() {
        FilterOption()
      }.visibility(this.indexWidth == '50%' ? Visibility.Visible : Visibility.None)
      .width('50%')
      .height('100%')
    }
  }
}