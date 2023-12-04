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

import InputConsumerUtil from '../util/InputConsumerUtil'
import keyCode from '@ohos.multimodalInput.keyCode'
import { formatJson } from '@ohos/common/src/main/ets/util/JSONUtils';
import inputConsumer from '@ohos.multimodalInput.inputConsumer'

/**
 * 组合按键
 */
@Preview
@Component
export struct InputConsumer {
  @State mIsShowImage: boolean = false
  @State mIsShowInputConsumerInfo: boolean = false
  @State mInputConsumerInfo: string = ''

  callback(KeyOptions: inputConsumer.KeyOptions): void {
    this.mInputConsumerInfo = formatJson(JSON.stringify(KeyOptions))
    const finalKey: number = KeyOptions.finalKey
    switch (finalKey) {
      case keyCode.KeyCode.KEYCODE_S: {
        this.mIsShowImage = true
        break
      }
      case keyCode.KeyCode.KEYCODE_D: {
        this.mIsShowImage = false
        break
      }
      default: {
        break
      }
    }
  }

  aboutToDisappear() {
    this.clear()
  }

  clear() {
    InputConsumerUtil.unsubscribe()
    this.mInputConsumerInfo = ''
    this.mIsShowImage = false
    this.mIsShowInputConsumerInfo = false
  }

  build() {
    Column({ space: px2vp(8) }) {
      Column() {
        Row() {
          Text($r('app.string.input_consumer_listener'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
            .fontWeight(FontWeight.Regular)
          Blank()
          Toggle({
            type: ToggleType.Switch,
            isOn: false
          })
            .width(42)
            .onChange((isOn) => {
              if (isOn) {
                this.mIsShowInputConsumerInfo = true
                InputConsumerUtil.subscribe((KeyOptions: inputConsumer.KeyOptions): void => this.callback(KeyOptions))
              } else {
                this.clear()
              }
            })
            .id('inputConsumerToggle')
        }
        .width('100%')

        Text($r('app.string.input_consumer_hint'))
          .fontColor($r('app.color.battery_info_value_text'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
          .width('100%')

        if (this.mIsShowInputConsumerInfo) {
          Text(this.mInputConsumerInfo.length > 0 ? this.mInputConsumerInfo : $r('app.string.input_wait'))
            .fontColor($r('app.color.input_consumer_hint'))
            .fontSize(14)
            .width('100%')
            .fontWeight(FontWeight.Regular)
            .margin({
              top: px2vp(20)
            })
            .id('textInputConsumerInfo')
        }
      }

      if (this.mIsShowImage) {
        Image($r('app.media.img_openatom'))
          .height('10%')
          .objectFit(ImageFit.Contain)
      }
    }
    .margin(px2vp(24))
    .padding(px2vp(24))
    .backgroundColor(Color.White)
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
  }
}