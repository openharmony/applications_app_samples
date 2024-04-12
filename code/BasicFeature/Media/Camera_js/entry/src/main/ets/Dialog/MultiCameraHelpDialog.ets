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

@CustomDialog
export struct MultiCameraHelpDialog {
  build() {
    Column() {
      Row() {
        Image($r('app.media.pic_popup_left')).size({ width: 240, height: 280 })
        Image($r('app.media.pic_popup_right')).size({ width: 240, height: 280 })
      }

      Text('请确保对方设备的WLAN和蓝牙已打开，并在“设置”>“超级终端”>“本机”调整允许被发现的范围。').fontWeight(500).fontSize(18).fontColor('#182431')
    }
  }
}