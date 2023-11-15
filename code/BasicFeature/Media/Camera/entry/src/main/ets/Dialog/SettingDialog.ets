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

@CustomDialog
export struct settingDialog {
  private controller: CustomDialogController;
  @Prop surfaceId: string;
  @Prop cameraDeviceIndex: number;
  @Link referenceLineBol: boolean;
  // Index of a certain setting clicked on
  @State leftSliderIndex: number = 1;

  // Mirror persistence, enter again, confirm if the switch is turned on
  getMirrorBol(bol) {
    globalThis.settingDataObj.mirrorBol = bol;
  }
  // Persistent geographical location, re-enter to determine if the switch is turned on
  getLocationBol(bol) {
    globalThis.settingDataObj.locationBol = bol;
  }
  // Persist the reference line, enter again to determine if the switch is turned on
  getReferenceLineBol(bol) {
    globalThis.settingDataObj.referenceLineBol = bol;
    this.referenceLineBol = bol;
  }

  onPageShow() {
    console.info('globalThis onPageShow:' + JSON.stringify(globalThis.settingDataObj));
  }

  onPageHide() {
    console.info('globalThis onPageHide:' + JSON.stringify(globalThis.settingDataObj));
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Column() {
          Row() {
            Text('设置')
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
            modeMessage: '自拍镜像',
            backNum: 1,
            leftSliderIndex: $leftSliderIndex,
            setModeBol: globalThis.settingDataObj.mirrorBol,
            getModeBol: this.getMirrorBol.bind(this)
          })
          Column() {
            settingPublicLayout({
              icon: $r('app.media.ic_camera_set__antishake'),
              isModeBol: true,
              borderBol: true,
              borderBole: true,
              backNum: 2,
              leftSliderIndex: $leftSliderIndex,
              modeMessage: '视频防抖'
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 3,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_exposure'),
              modeMessage: '曝光模式'
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 4,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_af'),
              modeMessage: '对焦模式'
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 5,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_quality'),
              modeMessage: '拍摄质量'
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
              modeMessage: '拍摄时显示地理位置',
              setModeBol: globalThis.settingDataObj.locationBol,
              getModeBol: this.getLocationBol.bind(this)
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
              modeMessage: '照片格式',
              isModeBol: true,
              borderBol: true,
              borderBole: true,
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 8,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_class'),
              modeMessage: '照片方向配置'
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 9,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_pic_resolution'),
              modeMessage: '照片分辨率'
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 10,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_video_resolution'),
              modeMessage: '视频分辨率'
            })
            Divider().width(420).margin({ left: 20 })
            settingPublicLayout({
              backNum: 11,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_video_rate'),
              modeMessage: '录像帧率',
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
            modeMessage: '参考线',
            isModeBol: true,
            borderBol: false,
            iconModeBol: true,
            setModeBol: globalThis.settingDataObj.referenceLineBol,
            getModeBol: this.getReferenceLineBol.bind(this)
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
      console.info('globalThis onPageHide:' + JSON.stringify(globalThis.settingDataObj));
    })
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}