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

@Component
export struct settingItem {
  private itemData: string; // The name of the selected mode
  @Prop settingMessageNum: number; // Incoming click settings
  private index: number; // Index value of the selected mode
  @Link @Watch('onChangeFn') isIndex: number; // Which icon is selected by default
  @State isBol: boolean = false; // Hide Display Icons
  // Corresponding to the selected setting parameters in the click mode setting
  selectMode() {
    switch (this.settingMessageNum) {
      case 2:
        globalThis.settingDataObj.videoStabilizationMode = this.index;
        cameraDemo.isVideoStabilizationModeSupported(globalThis.settingDataObj.videoStabilizationMode);
        break
      case 3:
        globalThis.settingDataObj.exposureMode = this.index;
        cameraDemo.isExposureModeSupported(globalThis.settingDataObj.exposureMode);
        break;
      case 4:
        globalThis.settingDataObj.focusMode = this.index;
        cameraDemo.isFocusModeSupported(globalThis.settingDataObj.focusMode);
        break;
      case 5:
        globalThis.settingDataObj.photoQuality = this.index;
        break;
      case 7:
        globalThis.settingDataObj.photoFormat = this.index;
        break;
      case 8:
        globalThis.settingDataObj.photoOrientation = this.index;
        break;
      case 9:
        // Photo resolution
        globalThis.settingDataObj.photoResolution = this.index;
        let ind = this.itemData.indexOf('*');
        globalThis.photoResolutionWidth = Number(this.itemData.substring(0, ind));
        globalThis.photoResolutionHeight = Number(this.itemData.substring(ind + 1));
        break;
      case 10:
        // Video resolution
        globalThis.settingDataObj.videoResolution = this.index;
        let index = this.itemData.indexOf('*');
        globalThis.videoResolutionWidth = Number(this.itemData.substring(0, index));
        globalThis.videoResolutionHeight = Number(this.itemData.substring(index + 1));
        break;
      case 11:
        globalThis.settingDataObj.videoFrame = this.index;
        globalThis.videoFrame = this.itemData;
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
          Image($r('app.media.ic_camera_set_Checked')).width(24).height(24);
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