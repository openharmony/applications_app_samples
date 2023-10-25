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
import { InputDeviceInfo } from '../../model/InputDeviceInfo'
import inputDevice from '@ohos.multimodalInput.inputDevice'
/**
 * 输入设备详情弹窗
 */
@CustomDialog
export struct InputDeviceDataDialog {
  @Link mDeviceInfo: InputDeviceInfo
  mController?: CustomDialogController;
  cancel?: () => void

  build() {
    Scroll() {
      Column() {
        Text(this.mDeviceInfo.name)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .margin({
            bottom: px2vp(48)
          })

        DeviceData({
          title: $r('app.string.input_device_id'),
          context: this.mDeviceInfo.id.toString()
        })

        DeviceData({
          title: $r('app.string.input_device_uniq'),
          context: this.mDeviceInfo.uniq
        })

        DeviceData({
          title: $r('app.string.input_device_style'),
          context: this.mDeviceInfo.sources.join(',')
        })

        DeviceData({
          title: $r('app.string.input_device_axis_ranges'),
        })

        ForEach(this.mDeviceInfo.axisRanges, (item: inputDevice.AxisRange) => {
          Column() {
            DeviceData({
              title: $r('app.string.input_device_source_style'),
              context: item.source
            })

            DeviceData({
              title: $r('app.string.input_device_axis_type'),
              context: item.axis
            })

            DeviceData({
              title: $r('app.string.input_device_max'),
              context: item.max.toString()
            })

            DeviceData({
              title: $r('app.string.input_device_min'),
              context: item.min.toString()
            })

            DeviceData({
              title: $r('app.string.input_device_fuzz'),
              context: item.fuzz.toString()
            })

            DeviceData({
              title: $r('app.string.input_device_flat'),
              context: item.flat.toString()
            })

            DeviceData({
              title: $r('app.string.input_device_resolution'),
              context: item.resolution.toString()
            })
          }
          .width('97%')
          .justifyContent(FlexAlign.End)
          .alignItems(HorizontalAlign.Center)
        })

        DeviceData({
          title: $r('app.string.input_device_bus'),
          context: this.mDeviceInfo.bus.toString()
        })

        DeviceData({
          title: $r('app.string.input_device_product'),
          context: this.mDeviceInfo.product.toString()
        })

        DeviceData({
          title: $r('app.string.input_device_vendor'),
          context: this.mDeviceInfo.vendor.toString()
        })

        DeviceData({
          title: $r('app.string.input_device_version'),
          context: this.mDeviceInfo.version.toString(),
          isShowDivider: false
        })
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.End)
      .padding(px2vp(24))
    }
  }
}

@Component
struct DeviceData {
  title: string | Resource = '';
  context?: string = ''
  isShowDivider?: boolean = true

  @Builder CustomDivider() {
    Divider()
      .strokeWidth('1px')
      .color($r('sys.color.ohos_id_color_subheading_separator'))
      .margin({
        bottom: px2vp(8)
      })
  }

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontWeight(FontWeight.Medium)

        Blank()
        Text(this.context)
          .fontColor($r('app.color.battery_info_value_text'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
      }
      .width('100%')
      .height(47)

      if (this.isShowDivider) {
        this.CustomDivider()
      }
    }
    .width('100%')
    .height(48)
  }
}