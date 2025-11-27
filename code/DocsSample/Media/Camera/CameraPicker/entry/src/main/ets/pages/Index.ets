/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { camera, cameraPicker as picker } from '@kit.CameraKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';

@Entry
@Component
struct Index {
  @State imgSrc: string = '';
  @State videoSrc: string = '';
  createPickerProfile(context: Context): picker.PickerProfile {
    let pathDir = context.filesDir;
    let fileName = `${new Date().getTime()}`;
    let filePath = pathDir + `/${fileName}.tmp`;
    fileIo.createRandomAccessFileSync(filePath, fileIo.OpenMode.CREATE);

    let uri = fileUri.getUriFromPath(filePath);
    let pickerProfile: picker.PickerProfile = {
      cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK,
      saveUri: uri
    };
    return pickerProfile;
  }

  async getPickerResult(context: Context, pickerProfile: picker.PickerProfile): Promise<picker.PickerResult> {
    let result: picker.PickerResult =
      await picker.pick(context, [picker.PickerMediaType.PHOTO, picker.PickerMediaType.VIDEO],
        pickerProfile);
    console.info(`picker resultCode: ${result.resultCode},resultUri: ${result.resultUri},mediaType: ${result.mediaType}`);
    return result;
  }

  getContext(): Context | undefined {
    let uiContext: UIContext = this.getUIContext();
    let context: Context | undefined = uiContext.getHostContext();
    return context;
  }

  build() {
    RelativeContainer() {
      Column() {
        Image(this.imgSrc).width(200).height(200).backgroundColor(Color.Black).margin(5);
        Video({ src: this.videoSrc}).width(200).height(200).autoPlay(true);
        Button("Test Picker Photo&Video").fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            let context = this.getContext();
            if (context === undefined) {
              return;
            }
            let pickerProfile = this.createPickerProfile(context);
            let result = await this.getPickerResult(context, pickerProfile);
            if (result.resultCode == 0) {
              if (result.mediaType === picker.PickerMediaType.PHOTO) {
                this.imgSrc = result.resultUri;
              } else {
                this.videoSrc = result.resultUri;
              }
            }
          }).margin(5);

      }.alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .id('CaptureOrVideoButton')
    }
    .height('100%')
    .width('100%')
  }
}