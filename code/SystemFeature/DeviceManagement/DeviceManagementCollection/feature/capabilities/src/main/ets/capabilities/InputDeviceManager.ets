/*
 * Copyright (c) 2023 Fujian Newland Auto-ID Tech.Co.,Ltd.
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
import { InputDeviceInfo } from '../model/InputDeviceInfo'
import { getDeviceList } from '../util/InputDeviceUtil'
import { InputDeviceDataDialog } from '../components/devicemanager/InputDeviceDataDialog'
import InputDevice from '../util/InputDeviceUtil'

@Component
struct InputDeviceList {
  mIsShowIcon: boolean = false;
  mIsShowStyle: boolean = false;
  @Link mInputDevices: InputDeviceInfo[]
  onClickItem: (deviceInfo: InputDeviceInfo) => void = () => {};

  @Builder CustomDivider() {
    Divider()
      .strokeWidth('1px')
      .color($r('sys.color.ohos_id_color_subheading_separator'))
      .margin({
        bottom: px2vp(8)
      })
  }

  build() {
    Column({ space: 12 }) {
      ForEach(this.mInputDevices, (item: InputDeviceInfo, index: number) => {
        Row() {
          if (this.mIsShowIcon) {
            Image(item.icon_source)
              .width(24)
              .height(24)
              .objectFit(ImageFit.Contain)
              .margin({
                right: px2vp(24)
              })
          }
          Column({ space: 4 }) {
            Row() {
              Column({ space: 4 }) {
                Text(item.name)
                  .fontColor($r('sys.color.ohos_id_color_text_primary'))
                  .fontSize($r('sys.float.ohos_id_text_size_body1'))
                  .maxLines(1)
                  .textOverflow({
                    overflow: TextOverflow.Ellipsis
                  })
                  .fontWeight(FontWeight.Medium)

                Text(item.id.toString())
                  .fontColor($r('app.color.battery_info_value_text'))
                  .fontSize($r('sys.float.ohos_id_text_size_body2'))
              }
              .width('70%')
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Start)

              Blank()
              if (this.mIsShowStyle) {
                Text(item.connect ? $r('app.string.input_device_connect') : $r('app.string.input_device_disconnect'))
                  .fontColor($r('app.color.battery_info_value_text'))
                  .fontSize($r('sys.float.ohos_id_text_size_body2'))
              }
            }
            .width('100%')
            .height(47)
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Center)

            if (index != this.mInputDevices?.length - 1) {
              this.CustomDivider()
            }

          }
          .width(this.mIsShowStyle ? '100%' : '90%')
        }
        .height(48)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          if (this.onClickItem) {
            this.onClickItem(item)
          }
        })
      }, (item: InputDeviceInfo) => item.id.toString())
    }
    .padding(px2vp(24))
    .backgroundColor($r('sys.color.ohos_id_color_list_card_bg'))
    .border({
      radius: $r('sys.float.ohos_id_corner_radius_default_l')
    })
  }
}

/**
 * 输入设备
 */
@Preview
@Component
export struct InputDeviceManager {
  @State mInputDevices: InputDeviceInfo[] = []
  @State mCurDevice: InputDeviceInfo | null = null;
  @State mInputDeviceList: InputDeviceInfo[] = []
  @State mIsListener: boolean = false
  @State mIsRefreshing: boolean = false
  dialogController: CustomDialogController = new CustomDialogController({
    builder: InputDeviceDataDialog({
      mDeviceInfo: $mCurDevice
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: {
      dx: 0,
      dy: -35
    }
  })

  aboutToAppear() {
    InputDevice.unregisterChange()
    // 获取设备列表
    this.getDevices()
  }

  aboutToDisappear() {
    InputDevice.unregisterChange()
    this.mInputDevices = []
    this.mInputDeviceList = []
    this.mCurDevice = null
    this.mIsListener = false
  }

  getDevices() {
    getDeviceList((data: InputDeviceInfo[]) => {
      this.mInputDevices = data
    })
  }

  onDeviceChange(devices: InputDeviceInfo[]) {
    this.mInputDeviceList = devices
    this.getDevices()
  }

  onClickItem(deviceInfo: InputDeviceInfo) {
    this.mCurDevice = deviceInfo
    if (this.dialogController != undefined) {
      this.dialogController.open()
    }
  }

  build() {
    Refresh({
      refreshing: $$this.mIsRefreshing,
      friction: 100
    }) {
      Scroll() {
        Column({ space: 12 }) {
          Column() {
            Row() {
              Text($r('app.string.input_device_change_title'))
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .fontSize($r('sys.float.ohos_id_text_size_body1'))
                .fontWeight(FontWeight.Medium)
              Blank()
              Toggle({
                type: ToggleType.Switch,
                isOn: this.mIsListener
              })
                .width(42)
                .onChange((isOn) => {
                  this.mIsListener = isOn
                  if (isOn) {
                    InputDevice.registerChange((devices: InputDeviceInfo[]): void => this.onDeviceChange(devices));
                  } else {
                    InputDevice.unregisterChange()
                  }
                })
            }
            .width('100%')
          }
          .padding(px2vp(24))
          .backgroundColor($r('sys.color.ohos_id_color_list_card_bg'))
          .border({
            radius: $r('sys.float.ohos_id_corner_radius_default_l')
          })

          if (this.mIsListener) {
            Text($r('app.string.input_device_status'))
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
              .fontSize($r('sys.float.ohos_id_text_size_body2'))
              .fontWeight(FontWeight.Regular)
              .fontFamily('HarmonyHeiTi')

            InputDeviceList({
              mInputDevices: $mInputDeviceList,
              mIsShowIcon: false,
              mIsShowStyle: true
            })
          }

          Text($r('app.string.input_device_list_title'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontWeight(FontWeight.Regular)
            .fontFamily('HarmonyHeiTi')

          InputDeviceList({
            mInputDevices: $mInputDevices,
            mIsShowIcon: true,
            mIsShowStyle: false,
            onClickItem: (deviceInfo: InputDeviceInfo): void => this.onClickItem(deviceInfo)
          })

        }.justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)
        .margin(px2vp(24))
      }
      .width('100%')
      .scrollBar(BarState.Off)
      .id('scrollInputDevice')
    }
    .width('100%')
    .onRefreshing(() => {
      this.mIsRefreshing = true
      this.getDevices()
      setTimeout(() => {
        this.mIsRefreshing = false
      }, 500)
    })
  }
}