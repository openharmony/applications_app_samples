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

import { settingItem } from './SettingItem'
import { SettingDataObj } from '../common/Constants'

class GetModeIcon {
  icon: Resource;
  message: Resource;

  constructor(icon: Resource, message: Resource) {
    this.icon = icon;
    this.message = message;
  }
};

@Component
export struct settingRightLayout {
  @Prop @Watch('onSettingMessageFn') settingMessageNum: number; // Incoming click settings
  private title: Array<Resource> = [$r('app.string.CONTENT_TYPE_UNKNOWN'), $r('app.string.SELFIE_IMAGE'), $r('app.string.STEADY_VIDEO'), $r('app.string.EXPOSURE_MODE'),
    $r('app.string.FOCUS_MODE'), $r('app.string.CAPTURE_QUALITY'),
    $r('app.string.DISPLAY_LOCATION'), $r('app.string.PHOTO_FORMAT'),
    $r('app.string.PHOTO_DIRECTION_CONFIGURATION'), $r('app.string.PHOTO_RESOLUTION'),
    $r('app.string.VIDEO_RESOLUTION'), $r('app.string.VIDEO_RATE'), $r('app.string.REFERENCE_LINE'),];
  private settingItemDataList: Array<Array<Resource>> = [
    [], [],
    [$r('app.string.CLOSE_STEADY_VIDEO'), $r('app.string.BASIC_ANTI_SHAKE_ALGORITHM'), $r('app.string.GENERAL_ANTI_SHAKE_ALGORITHM'), $r('app.string.BEST_ANTI_SHAKE_ALGORITHM'), $r('app.string.AUTO_SELECT')],
    [$r('app.string.LOCK_EXPOSURE_MODE'), $r('app.string.AUTO_EXPOSURE_MODE'), $r('app.string.CONTINUE_AUTO_EXPOSURE')],
    [$r('app.string.MANUAL_FOCUS'), $r('app.string.CONTINUE_AUTO_FOCUS'), $r('app.string.AUTO_ZOOM'), $r('app.string.LOCK_FOCUS')],
    [$r('app.string.HIGH'), $r('app.string.MIDDLE'), $r('app.string.BAD')],
    [],
    [$r('app.string.PHOTO_FORMAT_PNG'), $r('app.string.PHOTO_FORMAT_JPG'), $r('app.string.PHOTO_FORMAT_BMP'), $r('app.string.PHOTO_FORMAT_WEBP'), $r('app.string.PHOTO_FORMAT_JPEG')],
    [$r('app.string.SRC'), $r('app.string.OVERTURN90'), $r('app.string.OVERTURN180'), $r('app.string.OVERTURN270')],
    [$r('app.string.RESOLUTION1'), $r('app.string.RESOLUTION2'), $r('app.string.RESOLUTION3')],
    [$r('app.string.RESOLUTION1'), $r('app.string.RESOLUTION2'), $r('app.string.RESOLUTION3')],
    [$r('app.string.VIDEO_RATE_15'), $r('app.string.VIDEO_RATE_30')],
  ];
  @State isIndex: number = 0;
  private settingItemNumberArray = [2, 3, 4, 5, 7, 8, 9, 10, 11];
  private settingDataObj: SettingDataObj = {
    mirrorBol: false,
    videoStabilizationMode: 0,
    exposureMode: 1,
    focusMode: 2,
    photoQuality: 1,
    locationBol: false,
    photoFormat: 1,
    photoOrientation: 0,
    photoResolution: 0,
    videoResolution: 0,
    videoFrame: 0,
    referenceLineBol: false
  };
  private getModeIcon1: GetModeIcon = new GetModeIcon($r('app.media.pic_camera_mirror'), $r('app.string.SELF_IMAGE_FUNC_ONLY_FRONT_CAMERA_OPEN_USE'))
  private getModeIcon6: GetModeIcon = new GetModeIcon($r('app.media.pic_camera_mirror'), $r('app.string.DISPLAY_LOCATION_RECORD_PHOTO_OR_VIDEO_INFO'))
  private getModeIcon12: GetModeIcon = new GetModeIcon($r('app.media.pic_camera_line'), $r('app.string.OPEN_CAMERA_REFERENCE_LINE_CREATE_BETTER_FRAME'))

  onSettingMessageFn() {
    switch (this.settingMessageNum) {
      case 2:
        this.isIndex = this.settingDataObj.videoStabilizationMode;
        break;
      case 3:
        this.isIndex = this.settingDataObj.exposureMode;
        break;
      case 4:
        this.isIndex = this.settingDataObj.focusMode;
        break;
      case 5:
        this.isIndex = this.settingDataObj.photoQuality;
        break;
      case 7:
        this.isIndex = this.settingDataObj.photoFormat;
        break;
      case 8:
        this.isIndex = this.settingDataObj.photoOrientation;
        break;
      case 9:
        this.isIndex = this.settingDataObj.photoResolution;
        break;
      case 10:
        this.isIndex = this.settingDataObj.videoResolution;
        break;
      case 11:
        this.isIndex = this.settingDataObj.videoFrame;
        break;
    }
  }

  build() {
    Column() {
      Row() {
        Text(this.title[this.settingMessageNum])
          .fontSize(24)
          .fontWeight(700)
          .fontColor('#182431')
          .width('96%')
          .textAlign(TextAlign.Start)
      }.margin({ top: 20 })

      if (this.settingMessageNum == 1 || this.settingMessageNum == 6 || this.settingMessageNum == 12) {
        Column() {
          Image(this.getModeIcon1.icon).width(450).height(350).objectFit(ImageFit.ScaleDown);
          Text(this.getModeIcon1.message).fontColor('#182431').fontSize(18).fontWeight(400);
        }.margin({ top: 90 })
      } else if (this.settingMessageNum == 6) {
        Column() {
          Image(this.getModeIcon6.icon).width(450).height(350).objectFit(ImageFit.ScaleDown);
          Text(this.getModeIcon6.message).fontColor('#182431').fontSize(18).fontWeight(400);
        }.margin({ top: 90 })
      } else if (this.settingMessageNum == 12) {
        Column() {
          Image(this.getModeIcon12.icon).width(450).height(350).objectFit(ImageFit.ScaleDown);
          Text(this.getModeIcon12.message).fontColor('#182431').fontSize(18).fontWeight(400);
        }.margin({ top: 90 })
      } else {
        Column() {
          ForEach(this.settingItemDataList[this.settingMessageNum], (item: string, index: number) => {
            settingItem({
              itemData: item,
              index: index,
              isIndex: $isIndex,
              settingMessageNum: this.settingMessageNum
            })
          })
        }
        .margin({ top: 20 })
        .borderRadius(24)
        .width(720)
        .backgroundColor(Color.White)
      }
    }
  }
}