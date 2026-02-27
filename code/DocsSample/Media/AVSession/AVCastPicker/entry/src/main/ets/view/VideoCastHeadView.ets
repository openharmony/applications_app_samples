/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { AVCastPicker, AVCastPickerStyle } from '@kit.AVSessionKit';
import { VideoCastController } from '../controller/VideoCastController';
import { VideoSessionController } from '../controller/VideoSessionController';
import { IconButton } from '../view/CommonView'

@Component
export struct VideoCastHeadView {
  @StorageLink('avCastController') avCastPlayerController?: VideoCastController = undefined;
  @StorageLink('avSessionController') avSessionController ?: VideoSessionController = undefined;
  @StorageLink('avplayerContinueTime') avplayerContinueTime: number = 0;
  @StorageLink('avplayerContinueIndex') avplayerContinueIndex: number = 0;
  @StorageLink('deviceName') deviceName: string = '';
  @Link path: NavPathStack;
  showDeviceName: boolean = true;

  build() {
    Row() {
      IconButton({ iconResource: $r('sys.symbol.chevron_left') })
        .margin({
          right: 8
        })
        .onClick(() => {
          this.path.clear();
        })
      Text(this.deviceName)
        .fontWeight(700)
        .fontSize(20)
        .fontColor(Color.White)
        .visibility(this.showDeviceName ? Visibility.Visible : Visibility.None)
      Blank()
      Row(){
        AVCastPicker({
          normalColor: Color.White,
          pickerStyle: AVCastPickerStyle.STYLE_PANEL,
          sessionType: 'video',
        })
          .width(24)
          .height(24)
      }
      .width(40)
      .height(40)
      .backgroundColor('rgba(255,255,255,0.1)')
      .borderRadius(20)
      .justifyContent(FlexAlign.Center)
      .margin({
        right: 8
      })
      IconButton({ iconResource: $r('sys.symbol.power') })
        .onClick(async () => {
          if (this.avCastPlayerController && this.avSessionController) {
            await this.avCastPlayerController.releaseAVCast();
            this.avCastPlayerController = undefined;
            await this.avSessionController.stopCasting();
          }
        })
    }
    .width('100%')
    .height(56)
    .alignItems(VerticalAlign.Center)
  }
}