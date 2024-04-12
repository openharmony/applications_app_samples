/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
  message: string | undefined
}

const TAG: string = "SettingRightLayout";

@Component
export struct SettingRightLayout {
  @Link isIndex: number;
  private controller: CustomDialogController = new CustomDialogController({
    builder: null
  });
  @Link settingMessageNum: number; // 传进来的点击设置
  private title: Array<string> = ['', '自拍镜像', '视频防抖', '曝光模式', '对焦模式', '拍摄质量', '拍摄时显示地理位置', '照片格式', '照片方向配置', '照片分辨率', '视频分辨率', '录像帧率', '参考线',];
  private settingItemDataList: Array<Array<string>> = [
    [], [],
    ['关闭视频防抖', '基础防抖算法', '一般防抖算法', '最好防抖算法', '自动进行选择'],
    ['锁定曝光模式', '自动曝光模式', '连续自动曝光'],
    ['手动对焦', '连续自动对焦', '自动变焦', '对焦锁定'],
    ['高', '中', '差'],
    [],
    ['PNG', 'JPG', 'BMP', 'WEBP', 'JPEG'],
    ['0', '90', '180', '270'],
    ['1920*1080', '1280*720', '640*480'],
    ['1920*1080', '1280*720', '640*480'],
    ['15', '30'],
  ];

  getModeIconObj(): ResourceObj {
    if (this.settingMessageNum == 1) {
      return { icon: $r('app.media.pic_camera_mirror'), message: '自拍镜像功能只能在前置摄像头打开时可使用。' };
    } else if (this.settingMessageNum == 6) {
      return { icon: $r('app.media.pic_camera_mirror'), message: '显示地理位置，用于记录照片或视频拍摄地理位置信息。' };
    } else if (this.settingMessageNum == 12) {
      return { icon: $r('app.media.pic_camera_line'), message: '打开相机参考线，可以帮你创造出构图更出色的画面。' };
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