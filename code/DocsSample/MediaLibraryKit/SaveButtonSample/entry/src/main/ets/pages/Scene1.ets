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

// [Start Supported_Resource_Formats]
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { common } from '@kit.AbilityKit';

@Entry({ routeName : 'Scene1' })
@Component
export struct Scene1 {
  @State outputText: string = 'Supported formats:\n';

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        // [StartExclude Supported_Resource_Formats]
        Text('Get Supported Photo Formats')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 })

        Text('This example shows how to query supported image formats')
          .fontSize(14)
          .fontColor('#666666')
          .textAlign(TextAlign.Center)
          .width('90%')

        // [EndExclude Supported_Resource_Formats]

        Button('example')
          .width('80%')
          .height(50)
          .fontSize(16)
          .onClick(async () => {
            let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
            this.outputText = await example(phAccessHelper);
          })

        // [StartExclude Supported_Resource_Formats]
        Scroll() {
          Text(this.outputText)
            .fontSize(14)
            .width('90%')
            .padding(15)
            .backgroundColor('#F5F5F5')
            .borderRadius(8)
        }
        .width('100%')
        .layoutWeight(1)
        .margin({ top: 10 })
        // [EndExclude Supported_Resource_Formats]
      }
      .width('100%')
      .height('100%')
    }
    .title('Supported Formats')
  }
}

async function example(phAccessHelper: photoAccessHelper.PhotoAccessHelper): Promise<string> {
  try {
    let outputText = 'Supported formats:\n';
    // The value 1 means the supported image formats, and 2 means the supported video formats.
    let imageFormat = await phAccessHelper.getSupportedPhotoFormats(1);
    let result = '';
    for (let i = 0; i < imageFormat.length; i++) {
      result += imageFormat[i];
      if (i !== imageFormat.length - 1) {
        result += ', ';
      }
    }
    outputText += result;
    console.info('getSupportedPhotoFormats success, data is ' + outputText);
    return 'getSupportedPhotoFormats success, data is\n' + outputText;
  } catch (error) {
    console.error('getSupportedPhotoFormats failed, errCode is', error);
    return 'getSupportedPhotoFormats failed, errCode is\n' + JSON.stringify(error);
  }
}
// [End Supported_Resource_Formats]
