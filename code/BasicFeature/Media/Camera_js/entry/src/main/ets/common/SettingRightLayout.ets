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

import { SettingItem } from './SettingItem';
import Logger from '../model/Logger';

interface ResourceObj {
  icon: Resource | string | undefined,
  message: string | Resource | undefined
}

const TAG: string = "SettingRightLayout";

@Component
export struct SettingRightLayout {
  @Link isIndex: number;
  private controller: CustomDialogController = new CustomDialogController({
    builder: null
  });
  @Link settingMessageNum: number // 传进来的点击设置
  private title: Array<string | Resource> = ['', $r('app.string.photo_mirror'), $r('app.string.video_steady'), $r('app.string.video_exposure'), $r('app.string.af_mode'),
    $r('app.string.photo_quality'), $r('app.string.display_photo_location'), $r('app.string.photo_format'), $r('app.string.photo_direction_config'),
    $r('app.string.photo_ratio'), $r('app.string.video_ratio'), $r('app.string.video_frame'), $r('app.string.reference_line'),];
  private settingItemDataList: Array<Array<string | Resource>> = [
    [], [],
    [$r('app.string.close_video_stabilization'), $r('app.string.basic_stabilization_algorithm'), $r('app.string.commonly_stabilization_algorithm'),
      $r('app.string.best_stabilization_algorithm'), $r('app.string.auto_choice')],
    [$r('app.string.lock_exposure_mode'), $r('app.string.auto_exposure_mode'), $r('app.string.continuous_exposure_mode')],
    [$r('app.string.manual_focus'), $r('app.string.continuous_autofocus'), $r('app.string.automatic_zoom'), $r('app.string.focus_lock')],
    [$r('app.string.high'), $r('app.string.middle'), $r('app.string.difference')],
    [],
    ['PNG', 'JPG', 'BMP', 'WEBP', 'JPEG'],
    ['0', '90', '180', '270'],
    ['1280*960'],
    ['640*480'],
    ['15', '30'],
  ];

  getModeIconObj(): ResourceObj {
    if (this.settingMessageNum == 1) {
      return { icon: $r('app.media.pic_camera_mirror'), message: $r('app.string.mirror_message') };
    } else if (this.settingMessageNum == 6) {
      return { icon: $r('app.media.pic_camera_mirror'), message: $r('app.string.location_message') };
    } else if (this.settingMessageNum == 12) {
      return { icon: $r('app.media.pic_camera_line'), message: $r('app.string.camera_line_message') };
    } else {
      return { icon: undefined, message: undefined };
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_public_back'))
          .size({ width: 24, height: 24 })
          .position({ x: '0', y: '0' })
          .zIndex(1)
          .onClick(() => {
            Logger.info(TAG, 'back onClick');
            this.controller.close();
          })
        Text(this.title[this.settingMessageNum])
          .fontSize(24)
          .fontWeight(700)
          .fontColor('#182431')
          .width('96%')
          .textAlign(TextAlign.Start)
          .margin({ left: 40 })
      }
      .margin({ top: '150px', bottom: '25px', left: '30px' })

      if (this.settingMessageNum == 1 || this.settingMessageNum == 6 || this.settingMessageNum == 12) {
        Column() {
          Image(this.getModeIconObj().icon)
            .width(450)
            .height(350)
            .objectFit(ImageFit.ScaleDown)
          Text(this.getModeIconObj().message)
            .fontColor('#182431')
            .fontSize(18)
            .fontWeight(400)
        }
        .margin({ top: 90 })
      } else {
        Column() {
          ForEach(this.settingItemDataList[this.settingMessageNum], (item: string, index: number) => {
            SettingItem({
              itemData: item,
              index: index,
              isIndex: $isIndex,
              settingMessageNum: this.settingMessageNum
            })
          })
        }
        .margin({ top: 20, left: 12, right: 12 })
        .padding({ left: 12, right: 12 })
        .borderRadius(24)
        .width('100%')
        .backgroundColor(Color.White)
      }
    }
  }
}