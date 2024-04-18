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

import CameraService from '../model/CameraService';
import DateTimeUtil from '../model/DateTimeUtil';
import Logger from '../model/Logger';

const TAG: string = "RecodeStopDialog";

@CustomDialog
export struct RecodeStopDialog {
  private controller: CustomDialogController;
  @Link isModeBol: boolean;
  @Link videoRecodeTime: number;
  // 时间管理器
  @State dateTimeUtil: DateTimeUtil = new DateTimeUtil();
  @Link isRecording: boolean;

  build() {
    Column() {
      Text($r('app.string.recording_completed'))
        .fontSize(18)
        .fontWeight(500)
        .fontColor('#182431')
        .margin({ top: 10 })
        .width('99%')
      Row() {
        Button() {
          Text($r('app.string.stop'))
            .fontColor($r('app.color.theme_color'))
            .fontSize(17)
            .fontWeight(500)
        }
        .layoutWeight(5)
        .height(50)
        .backgroundColor('#FFFFFF')
        .onClick(() => {
          this.isModeBol = true;
          this.videoRecodeTime = 0;
          this.controller.close();
        })
      }
      .justifyContent(FlexAlign.SpaceAround)
      .width('100%')
    }
    .justifyContent(FlexAlign.SpaceAround)
    .width(336)
    .height(155)
    .padding('2%')
    .borderRadius(32)
    .backgroundColor('#FFFFFF')
  }
}