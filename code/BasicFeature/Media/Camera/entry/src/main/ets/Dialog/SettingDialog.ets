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

import { settingPublicLayout } from '../common/SettingPublicLayout';
import { settingRightLayout } from '../common/SettingRightLayout';
import { SettingDataObj } from '../common/Constants'

@CustomDialog
export struct settingDialog {
  private controller: CustomDialogController;
  @Prop surfaceId: string;
  @Prop cameraDeviceIndex: number;
  @Link referenceLineBol: boolean;
  // Index of a certain setting clicked on
  @State leftSliderIndex: number = 1;
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

  // Mirror persistence, enter again, confirm if the switch is turned on
  getMirrorBol(bol: boolean) {
    this.settingDataObj.mirrorBol = bol;
  }

  // Persistent geographical location, re-enter to determine if the switch is turned on
  getLocationBol(bol: boolean) {
    this.settingDataObj.locationBol = bol;
  }

  // Persist the reference line, enter again to determine if the switch is turned on
  getReferenceLineBol(bol: boolean) {
    this.settingDataObj.referenceLineBol = bol;
    this.referenceLineBol = bol;
  }

  onPageShow() {
    console.info('globalThis onPageShow:' + JSON.stringify(this.settingDataObj));
  }

  onPageHide() {
    console.info('globalThis onPageHide:' + JSON.stringify(this.settingDataObj));
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Column() {
          Row() {
            Text($r('app.string.SETTING'))
              .fontSize(26)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
              .width('96%')
              .onClick(() => {
                this.controller.close()
              })
          }.margin({ top: '100px', bottom: '20px' })

          settingPublicLayout({
            icon: $r('app.media.ic_camera_set__mirror'),
            isModeBol: true,
            borderBol: false,
            iconModeBol: true,
            modeMessage: $r('app.string.SELFIE_IMAGE'),
            backNum: 1,
            leftSliderIndex: $leftSliderIndex,
            setModeBol: this.settingDataObj.mirrorBol,
          })
          Column() {
            settingPublicLayout({
              icon: $r('app.media.ic_camera_set__antishake'),
              isModeBol: true,
              borderBol: true,
              borderBole: true,
              backNum: 2,
              leftSliderIndex: $leftSliderIndex,
              modeMessage: $r('app.string.STEADY_VIDEO')
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 3,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_exposure'),
              modeMessage: $r('app.string.EXPOSURE_MODE')
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 4,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_af'),
              modeMessage: $r('app.string.FOCUS_MODE')
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 5,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_quality'),
              modeMessage: $r('app.string.CAPTURE_QUALITY')
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 6,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_location'),
              isModeBol: true,
              borderBol: true,
              borderBole: false,
              iconModeBol: true,
              modeMessage: $r('app.string.DISPLAY_LOCATION'),
              setModeBol: this.settingDataObj.locationBol,
            })

          }
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ top: 15 })

          Column() {
            settingPublicLayout({
              backNum: 7,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_format'),
              modeMessage: $r('app.string.PHOTO_FORMAT'),
              isModeBol: true,
              borderBol: true,
              borderBole: true,
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 8,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_class'),
              modeMessage: $r('app.string.PHOTO_DIRECTION_CONFIGURATION')
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 9,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_pic_resolution'),
              modeMessage: $r('app.string.PHOTO_RESOLUTION')
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 10,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_video_resolution'),
              modeMessage: $r('app.string.VIDEO_RESOLUTION')
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 11,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_video_rate'),
              modeMessage: $r('app.string.VIDEO_RATE'),
              isModeBol: true,
              borderBol: true,
              borderBole: false,
            })
          }
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ top: 15 })

          settingPublicLayout({
            backNum: 12,
            leftSliderIndex: $leftSliderIndex,
            icon: $r('app.media.ic_camera_set_line'),
            modeMessage: $r('app.string.REFERENCE_LINE'),
            isModeBol: true,
            borderBol: false,
            iconModeBol: true,
            setModeBol: this.settingDataObj.referenceLineBol,
          })
            .margin({ top: 15 })
        }
        .width('38%')

        // Set Right Selection List
        Column() {
          settingRightLayout({ settingMessageNum: this.leftSliderIndex });
        }
        .width('58%')
      }
      .height('100%')
      .width('96%')

    }
    // page display
    .onAppear(() => {
    })
    // Page disappears
    .onDisAppear(async () => {
      console.info('globalThis onPageHide:' + JSON.stringify(this.settingDataObj));
    })
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}