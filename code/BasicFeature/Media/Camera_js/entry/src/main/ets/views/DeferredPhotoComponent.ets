/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import CameraService from '../model/CameraService';
import Logger from '../model/Logger';

const TAG = 'DeferredPhotoComponent';

@Component
export struct DeferredPhotoComponent {
  // 相机摄像头
  @Prop cameraDeviceIndex: number;
  // surfaceID值
  @Prop surfaceId: string;
  @StorageLink('deferredPhotoComponentIsShow') isShow: boolean = true;
  @StorageLink('deferredPhotoComponentIsHidden') isHidden: boolean = true;
  @State targetName: string = '老拍照';
  colorEffectList: Array<Record<string, Object>> = [
    { 'colorEffect': 0, 'name': '老拍照' },
    { 'colorEffect': 1, 'name': '普通拍照' },
    { 'colorEffect': 2, 'name': '分段式拍照' }
  ];

  build() {
    Row() {
      if (this.isShow) {
        Row() {
          Button() {
            Text(this.targetName)
              .fontColor('#FFFFFF').fontSize(10)
          }
          .backgroundColor('rgba(255,255,255,0.20)')
          .width('45vp')
          .height('45vp')
          .borderRadius('50px')
          .onClick(() => {
            AppStorage.setOrCreate<boolean>('countdownBol', true);
            this.isShow = false;
          })
        }
      } else {
        Flex({ justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center, direction: FlexDirection.Column }) {
          ForEach(this.colorEffectList, (item: Record<string, Object>, index: number) => {
            Text(item.name as string)
              .fontSize(10)
              .height('50vp')
              .onClick(() => {
                Logger.debug(TAG, 'onClick');
                this.targetName = item.name as string;
                this.isShow = true;
                CameraService.setCaptureMode(index);
                CameraService.initCamera(this.surfaceId, this.cameraDeviceIndex);
              })
          })
        }
        .backgroundColor('#FFFFFF')
        .borderRadius('45vp')
        .width('45vp')
        .height('150vp')
        .zIndex(1)
      }
    }
    .onClick(() => {
      this.isShow = true;
    })
    .visibility(this.isHidden ? Visibility.Hidden : Visibility.Visible)
  }
}