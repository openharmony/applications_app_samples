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
import MouseManagerUtil from '../util/MouseManagerUtil'
import {
  setPointerVisible,
  isPointerVisible,
  setPointerSpeed,
  setPointerStyle,
  getPointerStyle
} from '../util/MouseManagerUtil'
import { pointerStyleArr, PointerStyleData } from '../model/PointerStyleData'
import { getString } from '@ohos/common/src/main/ets/util/ResourceUtil';
import pointer from '@ohos.multimodalInput.pointer'

/**
 * 鼠标管理视图
 */
@Preview
@Component
export struct MouseManager {
  @State mMouseEvent: string = ''
  @State mIsVisible: boolean | undefined = false;
  // 鼠标速度
  private mPointerSpeedArr = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11']
  // 鼠标样式
  @State mPointerStyleVal: string = getString($r('app.string.mouse_style_default'))
  @State mSpeedIndex: number = 4
  @State mSpeedVal: string = this.mPointerSpeedArr[4]
  @State mStyleIndex: number = 0
  private mSheetArr: Array<SheetInfo> = []
  private mPointerStyleArr: Array<PointerStyleData> = pointerStyleArr
  @State mIsShowMouseData: boolean = false // 是否显示鼠标详情，在开启监听后才显示

  async aboutToAppear() {
    this.mIsVisible = await isPointerVisible()
    let pointerStyle = await getPointerStyle()
    this.initPointerStyle(pointerStyle)
  }

  initPointerStyle(style: pointer.PointerStyle) {
    let isCheck: boolean = true
    for (let item of this.mPointerStyleArr) {
      if (isCheck && style && item.style === style) {
        this.mPointerStyleVal = item.name
        isCheck = false
      }
      let sheetInfo: SheetInfo = {
        title: item.name,
        icon: item.icon,
        action: () => {
          setPointerStyle(item.style)
          this.mPointerStyleVal = item.name
        }
      }
      this.mSheetArr.push(sheetInfo)
    }
  }

  aboutToDisappear() {
    MouseManagerUtil.unregisterMouse()
  }

  onMouseEvent(data: string) {
    this.mMouseEvent = data
  }

  /**
   * 显示选择鼠标移动速度弹窗
   */
  showSelectSpeedDialog() {
    TextPickerDialog.show({
      range: this.mPointerSpeedArr,
      selected: this.mSpeedIndex,
      onAccept: (result: TextPickerResult) => {
        let indexTemp: number | number[] = result.index;
        let speedTemp: string | string[] = result.value;
        this.mSpeedIndex = indexTemp as number;
        this.mSpeedVal = speedTemp as string;
        setPointerSpeed(Number(this.mSpeedVal))
        console.info("TextPickerDialog:onAccept()" + JSON.stringify(result))
      }
    })
  }

  /**
   * 显示鼠标样式弹窗
   */
  showPointerStyleDialog() {
    ActionSheet.show({
      title: $r('app.string.mouse_pointer_style_title'),
      message: $r('app.string.mouse_pointer_style_hint'),
      autoCancel: true,
      alignment: DialogAlignment.Bottom,
      sheets: this.mSheetArr
    })
  }

  @Builder CustomDivider() {
    Divider()
      .strokeWidth('1px')
      .color($r('sys.color.ohos_id_color_subheading_separator'))
      .margin({
        bottom: px2vp(8)
      })
  }

  build() {
    Scroll() {
      Column({ space: 12 }) {
        Text($r('app.string.mouse_setting'))
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontWeight(FontWeight.Regular)
          .fontFamily('HarmonyHeiTi')

        Column() {
          Row() {
            Text($r('app.string.mouse_setting_show'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontWeight(FontWeight.Medium)
            Blank()
            Toggle({
              type: ToggleType.Switch,
              isOn: this.mIsVisible
            })
              .width(42)
              .onChange((isOn) => {
                setPointerVisible(isOn)
              })
          }
          .width('100%')
          .height(48)

          this.CustomDivider()

          Row() {
            Text($r('app.string.mouse_setting_speed_title'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontWeight(FontWeight.Medium)
            Blank()
            Row() {
              Text(this.mSpeedVal)
                .fontColor($r('app.color.battery_info_value_text'))
                .fontSize($r('sys.float.ohos_id_text_size_body2'))
                .margin({
                  right: px2vp(12)
                })

              Image($r('app.media.icon_right_grey'))
                .width(12)
                .height(12)
                .objectFit(ImageFit.Contain)
            }
            .onClick(() => {
              this.showSelectSpeedDialog()
            })
          }
          .width('100%')
          .height(48)

          this.CustomDivider()

          Row() {
            Text($r('app.string.mouse_setting_style_title'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontWeight(FontWeight.Medium)
            Blank()
            Row() {
              Text(this.mPointerStyleVal)
                .fontColor($r('app.color.battery_info_value_text'))
                .fontSize($r('sys.float.ohos_id_text_size_body2'))
                .margin({
                  right: px2vp(12)
                })

              Image($r('app.media.icon_right_grey'))
                .width(12)
                .height(12)
                .objectFit(ImageFit.Contain)
            }
            .onClick(() => {
              this.showPointerStyleDialog()
            })
          }
          .width('100%')
          .height(48)
        }
        .width('100%')
        .padding(px2vp(24))
        .backgroundColor($r('sys.color.ohos_id_color_list_card_bg'))
        .border({
          radius: $r('sys.float.ohos_id_corner_radius_default_l')
        })
        .id('columnMouseSetting')

        Text($r('app.string.mouse_listener_title'))
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontWeight(FontWeight.Regular)
          .fontFamily('HarmonyHeiTi')

        Column() {
          Row() {
            Text($r('app.string.mouse_listener_open'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontWeight(FontWeight.Medium)
            Blank()
            Toggle({
              type: ToggleType.Switch,
              isOn: false
            })
              .width(42)
              .onChange((isOn) => {
                this.mIsShowMouseData = isOn
                if (isOn) {
                  MouseManagerUtil.registerMouse((data: string): void => this.onMouseEvent(data));
                } else {
                  MouseManagerUtil.unregisterMouse()
                }
              })
              .id('toggleMouseListener')
          }
          .width('100%')
          .height(48)

          Text($r('app.string.mouse_listener_open_hint'))
            .fontColor($r('app.color.battery_info_value_text'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .width('100%')
        }
        .padding(px2vp(24))
        .backgroundColor($r('sys.color.ohos_id_color_list_card_bg'))
        .border({
          radius: $r('sys.float.ohos_id_corner_radius_default_l')
        })
        .id('columnMouseListener')

        if (this.mIsShowMouseData) {
          Text($r('app.string.mouse_event_info_title'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontWeight(FontWeight.Regular)
            .fontFamily('HarmonyHeiTi')
          Column() {
            Text(this.mMouseEvent)
              .fontColor($r('app.color.input_consumer_hint'))
              .fontSize(14)
              .fontWeight(FontWeight.Regular)
              .width('100%')
          }
          .padding(px2vp(24))
          .backgroundColor($r('sys.color.ohos_id_color_list_card_bg'))
          .border({
            radius: $r('sys.float.ohos_id_corner_radius_default_l')
          })
          .id('columnMouseEvent')
        }

      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .margin(px2vp(24))
    }
    .width('100%')
    .scrollBar(BarState.Off)
    .id('scrollMouse')
  }
}