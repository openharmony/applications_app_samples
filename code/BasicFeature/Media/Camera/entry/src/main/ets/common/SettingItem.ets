/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import cameraDemo from 'libentry.so';
import { SettingDataObj } from '../common/Constants'
import * as Common from '../common/Constants'

@Component
export struct settingItem {
  private itemData: string = ''; // The name of the selected mode
  @Prop settingMessageNum: number; // Incoming click settings
  private index: number = 0; // Index value of the selected mode
  @Link @Watch('onChangeFn') isIndex: number; // Which icon is selected by default
  @State isBol: boolean = false; // Hide Display Icons
  private settingDataObj: SettingDataObj = {
    MIRRORBOL: false,
    VIDEO_STABILIZATION_MODE: 0,
    EXPOSURE_MODE: 1,
    FOCUS_MODE: 2,
    PHOTO_QUALITY: 1,
    LOCATION_BOL: false,
    PHOTO_FORMAT: 1,
    PHOTO_ORIENTATION: 0,
    PHOTO_RESOLUTION: 0,
    VIDEO_RESOLUTION: 0,
    VIDEO_FRAME: 0,
    REFERENCElINE_BOL: false
  };

  // Corresponding to the selected setting parameters in the click mode setting
  selectMode() {
    switch (this.settingMessageNum) {
      case 2:
        this.settingDataObj.VIDEO_STABILIZATION_MODE = this.index;
        cameraDemo.isVideoStabilizationModeSupported(this.settingDataObj.VIDEO_STABILIZATION_MODE);
        break
      case 3:
        this.settingDataObj.EXPOSURE_MODE = this.index;
        cameraDemo.isExposureModeSupported(this.settingDataObj.EXPOSURE_MODE);
        break;
      case 4:
        this.settingDataObj.FOCUS_MODE = this.index;
        cameraDemo.isFocusModeSupported(this.settingDataObj.FOCUS_MODE);
        break;
      case 5:
        this.settingDataObj.PHOTO_QUALITY = this.index;
        break;
      case 7:
        this.settingDataObj.PHOTO_FORMAT = this.index;
        break;
      case 8:
        this.settingDataObj.PHOTO_ORIENTATION = this.index;
        break;
      case 9:
      // Photo resolution
        this.settingDataObj.PHOTO_RESOLUTION = this.index;
        let ind = this.itemData.indexOf('*');
        let photoResolutionWidth = Common.photoResolutionWidth;
        let photoResolutionHeight = Common.photoResolutionHeight;
        photoResolutionWidth = Number(this.itemData.substring(0, ind));
        photoResolutionHeight = Number(this.itemData.substring(ind + 1));
        break;
      case 10:
      // Video resolution
        this.settingDataObj.VIDEO_RESOLUTION = this.index;
        let index = this.itemData.indexOf('*');
        let videoResolutionWidth = Common.videoResolutionWidth;
        let videoResolutionHeight = Common.videoResolutionHeight;
        videoResolutionWidth = Number(this.itemData.substring(0, index));
        videoResolutionHeight = Number(this.itemData.substring(index + 1));
        break;
      case 11:
        this.settingDataObj.VIDEO_FRAME = this.index;
        let videoFrame = Common.videoFrame;
        videoFrame = this.itemData;
        break;
    }
  }

  onChangeFn() {
    if (this.index === this.isIndex) {
      this.isBol = true;
    } else {
      this.isBol = false;
    }
  }

  aboutToAppear() {
    this.onChangeFn();
  }

  build() {
    Column() {
      Row() {
        Text(this.itemData)
          .fontColor('#182431')
          .fontSize(16)
          .fontWeight(600)
          .textAlign(TextAlign.Start)
          .width('90%')
        if (this.isBol) {
          Image($r('app.media.ic_camera_set_checked')).width(24).height(24);
        } else {
          Image('').width(24).height(24).backgroundColor(Color.White);
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .height(65)
      .onClick(() => {
        this.isIndex = this.index;
        this.selectMode();
      })

      Divider().width(680).margin({ left: 10 })
    }
  }
}