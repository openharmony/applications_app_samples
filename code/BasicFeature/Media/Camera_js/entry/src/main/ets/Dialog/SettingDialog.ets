/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { CameraConfig } from '../common/CameraConfig';
import { GlobalContext } from '../common/GlobalContext';
import { SettingPublicLayout } from '../common/SettingPublicLayout';
import Logger from '../model/Logger';

const TAG: string = 'SettingDialog';

@CustomDialog
export struct SettingDialog {
  private controller: CustomDialogController;
  @Prop surfaceId: string;
  @Prop cameraDeviceIndex: number;
  @Link referenceLineBol: boolean;
  // 点击的某一个设置的索引
  @State leftSliderIndex: number = 1;

  /**
   * 镜像持久化，再次进入，确定开关是否开启
   */
  getMirrorBol(bol: boolean): void {
    let cameraConfig: CameraConfig = GlobalContext.get().getObject('cameraConfig') as CameraConfig;
    cameraConfig.mirrorBol = bol;
    GlobalContext.get().setObject('cameraConfig', cameraConfig);
  }

  /**
   * 地理位置持久化，再次进入，确定开关是否开启
   */
  getLocationBol(bol: boolean): void {
    let cameraConfig: CameraConfig = GlobalContext.get().getObject('cameraConfig') as CameraConfig;
    cameraConfig.locationBol = bol;
    GlobalContext.get().setObject('cameraConfig', cameraConfig);
  }

  /**
   * 参考线持久化，再次进入，确定开关是否开启
   */
  getReferenceLineBol(bol: boolean): void {
    let cameraConfig: CameraConfig = GlobalContext.get().getObject('cameraConfig') as CameraConfig;
    cameraConfig.referenceLineBol = bol;
    GlobalContext.get().setObject('cameraConfig', cameraConfig);
    this.referenceLineBol = bol;
  }

  /**
   * HDR拍摄持久化，再次进入，确定开关是否开启
   */
  getHdrPhotoBol(bol: boolean): void {
    let cameraConfig: CameraConfig = GlobalContext.get().getObject('cameraConfig') as CameraConfig;
    cameraConfig.hdrPhotoBol = bol;
    GlobalContext.get().setObject('cameraConfig', cameraConfig);
  }

  /**
   * HDR录像持久化，再次进入，确定开关是否开启
   */
  getHdrVideoBol(bol: boolean): void {
    let cameraConfig: CameraConfig = GlobalContext.get().getObject('cameraConfig') as CameraConfig;
    cameraConfig.hdrVideoBol = bol;
    GlobalContext.get().setObject('cameraConfig', cameraConfig);
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Flex({
          justifyContent: FlexAlign.Start,
          direction: FlexDirection.Column,
          alignItems: ItemAlign.Center
        }) {
          Row({ space: 24 }) {
            Image($r('app.media.ic_public_back'))
              .size({ width: 24, height: 24 })
              .zIndex(1)
              .onClick(() => {
                Logger.info(TAG, 'back onClick');
                this.controller.close();
              })
            Text($r('app.string.setting'))
              .fontSize(24)
              .fontWeight(700)
              .textAlign(TextAlign.Start)
              .width('96%')
              .onClick(() => {
                this.controller.close();
              })
          }
          .margin({ top: '24vp', bottom: '24vp', left: '24vp' })

          Column() {
            SettingPublicLayout({
              icon: $r('app.media.ic_camera_set__Mirror'),
              isModeBol: true,
              borderBol: false,
              iconModeBol: true,
              modeMessage: $r('app.string.photo_mirror'),
              backNum: 1,
              leftSliderIndex: $leftSliderIndex,
              setModeBol: (GlobalContext.get().getObject('cameraConfig') as CameraConfig).mirrorBol,
              getModeBol: this.getMirrorBol
            })
          }
          .width('97%')

          Column() {
            SettingPublicLayout({
              icon: $r('app.media.ic_camera_set__Antishake'),
              isModeBol: true,
              borderBol: true,
              borderBole: true,
              backNum: 2,
              leftSliderIndex: $leftSliderIndex,
              modeMessage: $r('app.string.video_steady')
            })

            Divider()
              .width('94%')

            SettingPublicLayout({
              backNum: 3,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_exposure'),
              modeMessage: $r('app.string.video_exposure')
            })

            Divider()
              .width('94%')

            SettingPublicLayout({
              backNum: 4,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_AF'),
              modeMessage: $r('app.string.af_mode')
            })

            Divider()
              .width('94%')

            SettingPublicLayout({
              backNum: 5,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_Quality'),
              modeMessage: $r('app.string.photo_quality')
            })

            Divider()
              .width('94%')

            SettingPublicLayout({
              backNum: 6,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_Location'),
              isModeBol: true,
              borderBol: true,
              borderBole: false,
              iconModeBol: true,
              modeMessage: $r('app.string.display_photo_location'),
              setModeBol: (GlobalContext.get().getObject('cameraConfig') as CameraConfig).locationBol,
              getModeBol: this.getLocationBol
            })
          }
          .width('97%')
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ top: 15 })

          Column() {
            SettingPublicLayout({
              backNum: 7,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_Format'),
              modeMessage: $r('app.string.photo_format'),
              isModeBol: true,
              borderBol: true,
              borderBole: true,
            })

            Divider()
              .width('94%')

            SettingPublicLayout({
              backNum: 8,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_class'),
              modeMessage: $r('app.string.photo_direction_config')
            })

            Divider()
              .width('94%')

            SettingPublicLayout({
              backNum: 9,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_pic_Resolution'),
              modeMessage: $r('app.string.photo_ratio')
            })

            Divider()
              .width('94%')

            SettingPublicLayout({
              backNum: 10,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_video_Resolution'),
              modeMessage: $r('app.string.video_ratio')
            })

            Divider()
              .width('94%')

            SettingPublicLayout({
              backNum: 11,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_video_Rate'),
              modeMessage: $r('app.string.video_frame'),
              isModeBol: true,
              borderBol: true,
              borderBole: false,
            })


          }
          .width('97%')
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ top: 15 })

          Column() {
            SettingPublicLayout({
              backNum: 12,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_line'),
              modeMessage: $r('app.string.reference_line'),
              isModeBol: true,
              borderBol: false,
              iconModeBol: true,
              setModeBol: (GlobalContext.get().getObject('cameraConfig') as CameraConfig).referenceLineBol,
              getModeBol: this.getReferenceLineBol
            })
            Divider()
              .width('94%')

            SettingPublicLayout({
              backNum: 13,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_photo_hdr'),
              isModeBol: true,
              borderBol: true,
              borderBole: false,
              iconModeBol: true,
              modeMessage: $r('app.string.hdr_photo'),
              setModeBol: (GlobalContext.get().getObject('cameraConfig') as CameraConfig).hdrPhotoBol,
              getModeBol: this.getHdrPhotoBol
            })
            Divider()
              .width('94%')

            SettingPublicLayout({
              backNum: 13,
              leftSliderIndex: $leftSliderIndex,
              icon: $r('app.media.ic_camera_set_video_hdr'),
              isModeBol: true,
              borderBol: true,
              borderBole: false,
              iconModeBol: true,
              modeMessage: $r('app.string.hdr_video'),
              setModeBol: (GlobalContext.get().getObject('cameraConfig') as CameraConfig).hdrVideoBol,
              getModeBol: this.getHdrVideoBol
            })
          }
          .width('97%')
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ top: 15 })

        }
        .width('100%')
      }
      .size({ width: '96%', height: '100%' })
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor('#F1F3F5')
  }
}