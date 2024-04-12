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

import CameraService from '../model/CameraService';
import Logger from '../model/Logger';
import { BusinessError } from '@ohos.base';
import { CameraConfig } from './CameraConfig';
import { GlobalContext } from './GlobalContext';
import { PromptAction } from '@ohos.arkui.UIContext';

const TAG: string = "SettingItem";

@Component
export struct SettingItem {
  private itemData: string = ''; // 所选模式的名称
  @Prop settingMessageNum: number; // 传进来的点击设置
  private index: number = -1; // 所选模式的索引值
  @Link @Watch('onChangeFn') isIndex: number; // 默认图标选在第几个
  @State isBol: boolean = false; // 隐藏显示图标

  /**
   * 对应点击模式设置下所选的设置参数
   */
  selectMode(): void {
    Logger.info(TAG, `selectMode settingMessageNum: ${this.settingMessageNum}`);
    let globalContext: GlobalContext = GlobalContext.get();
    let cameraConfig: CameraConfig = globalContext.getObject('cameraConfig') as CameraConfig;
    switch (this.settingMessageNum) {
      case 2:
        cameraConfig.videoStabilizationMode = this.index;
        let isVideoStabSupported = CameraService.isVideoStabilizationModeSupportedFn(cameraConfig.videoStabilizationMode);
        try {
          (globalContext.getPromptAction() as PromptAction).showToast({
            message: isVideoStabSupported ? '支持此模式' : '不支持此模式',
            duration: 2000,
            bottom: '50%'
          });
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `showToast err: ${JSON.stringify(err)}`);
        }
        if (isVideoStabSupported) {
          CameraService.setVideoStabilizationMode(cameraConfig.videoStabilizationMode);
        }
        break;
      case 3:
        cameraConfig.exposureMode = this.index;
        let isExposureModeSupported = CameraService.isExposureModeSupportedFn(cameraConfig.exposureMode);
        try {
          (globalContext.getPromptAction() as PromptAction).showToast({
            message: isExposureModeSupported ? '支持此模式' : '不支持此模式',
            duration: 2000,
            bottom: '50%'
          });
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `showToast err: ${JSON.stringify(err)}`);
        }
        if (isExposureModeSupported) {
          CameraService.setExposureMode(cameraConfig.exposureMode)
        }
        break;
      case 4:
        cameraConfig.focusMode = this.index;
        let isFocusModeSupported = CameraService.isFocusModeSupported(cameraConfig.focusMode);
        try {
          (globalContext.getPromptAction() as PromptAction).showToast({
            message: isFocusModeSupported ? '支持此模式' : '不支持此模式',
            duration: 2000,
            bottom: '50%'
          });
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `showToast err: ${JSON.stringify(err)}`);
        }
        break;
      case 5:
        cameraConfig.photoQuality = this.index;
        break;
      case 7:
        cameraConfig.photoFormat = this.index;
        break;
      case 8:
        cameraConfig.photoOrientation = this.index;
        break;
      case 9:
      // 照片分辨率
        cameraConfig.photoResolution = this.index;
        let ind = this.itemData.indexOf('*');
        let photoResolutionWidth = Number(this.itemData.substring(0, ind));
        let photoResolutionHeight = Number(this.itemData.substring(ind + 1));
        globalContext.setObject('photoResolutionWidth', photoResolutionWidth);
        globalContext.setObject('photoResolutionHeight', photoResolutionHeight);
        AppStorage.set<number>('defaultAspectRatio', photoResolutionWidth / photoResolutionHeight);
        break;
      case 10:
      // 视频分辨率
        cameraConfig.videoResolution = this.index;
        let index = this.itemData.indexOf('*');
        let videoResolutionWidth = Number(this.itemData.substring(0, index));
        let videoResolutionHeight = Number(this.itemData.substring(index + 1));
        globalContext.setObject('photoResolutionWidth', videoResolutionWidth);
        globalContext.setObject('photoResolutionHeight', videoResolutionHeight);
        break;
      case 11:
        let isSupported = CameraService.isVideoFrameSupportedFn(Number(this.itemData));
        if (isSupported) {
          cameraConfig.videoFrame = this.index;
          globalContext.setObject('videoFrame', this.itemData);
        }
        try {
          (globalContext.getPromptAction() as PromptAction).showToast({
            message: isSupported ? '支持此模式' : '不支持此模式',
            duration: 2000,
            bottom: '50%'
          });
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `showToast err: ${JSON.stringify(err)}`);
        }
        break;
    }
    GlobalContext.get().setObject('cameraConfig', cameraConfig);
  }

  async resetSession(): Promise<void> {
    await CameraService.releaseCamera().then((): void => {
      Logger.debug(TAG, 'releaseCamera success');
    });
    await CameraService.initCamera(GlobalContext.get().getObject('surfaceId') as string, GlobalContext.get()
      .getObject('cameraDeviceIndex') as number).then((): void => {
      Logger.debug(TAG, 'initCamera success');
    });
  }

  onChangeFn(): void {
    if (this.index === this.isIndex) {
      this.isBol = true;
    } else {
      this.isBol = false;
    }
  }

  aboutToAppear(): void {
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
          Image($r('app.media.ic_camera_set_Checked'))
            .width(24)
            .height(24)
        } else {
          Image('')
            .width(24)
            .height(24)
            .backgroundColor(Color.White)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .height(65)
      .onClick(async () => {
        if (this.isIndex === this.index) {
          return;
        }
        this.isIndex = this.index;
        this.selectMode();
        await this.resetSession();
      })

      Divider()
        .width('100%')
        .margin({ left: 10 })
    }

  }
}