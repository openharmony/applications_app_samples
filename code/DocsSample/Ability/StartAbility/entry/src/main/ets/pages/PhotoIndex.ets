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
// [Start photo_index_component]
// [Start photo_index_import]
import { common, wantConstant } from '@kit.AbilityKit';
import { fileUri, picker } from '@kit.CoreFileKit';
// [End photo_index_import]
import { hilog } from '@kit.PerformanceAnalysisKit';
import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

const TAG = 'PhotoEditorCaller';

@Entry
@Component
struct Index {
  @State message: string = 'selectImg';
  @State originalImage: ResourceStr = '';
  @State editedImage: PixelMap | null = null;
  private filePath: string = '';

  // 根据uri读取图片内容
  async readImage(uri: string): Promise < PixelMap | null > {
    hilog.info(0x0000, TAG, `image uri: ${uri}`);
    let file: fileIo.File | undefined;
    try {
      file = await fileIo.open(uri, fileIo.OpenMode.READ_ONLY);
      hilog.info(0x0000, TAG, `file: ${file.fd}`);

      let imageSourceApi: image.ImageSource = image.createImageSource(file.fd);
      if(!imageSourceApi) {
        hilog.info(0x0000, TAG, 'imageSourceApi failed');
        return null;
      }
      let pixmap: image.PixelMap = await imageSourceApi.createPixelMap();
      if(!pixmap) {
        hilog.info(0x0000, TAG, 'createPixelMap failed');
        return null;
      }
      this.editedImage = pixmap;
      return pixmap;
    } catch(e) {
      hilog.error(0x0000, TAG, `readImage failed:${e}`);
    } finally {
      fileIo.close(file);
    }
    return null;
  }

  // 图库中选取图片
  // [Start photo_index_picker]
  async photoPickerGetUri(): Promise<string> {
    try {
      let textInfo: photoAccessHelper.TextContextInfo = {
        text: 'photo'
      }
      let recommendOptions: photoAccessHelper.RecommendationOptions = {
        textContextInfo: textInfo
      }
      let options: photoAccessHelper.PhotoSelectOptions = {
        MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
        maxSelectNumber: 1,
        recommendationOptions: recommendOptions
      }
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      let photoSelectResult: photoAccessHelper.PhotoSelectResult = await photoPicker.select(options);
      return photoSelectResult.photoUris[0];
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      hilog.error(0x0000, TAG, 'PhotoViewPicker failed with err: ' + JSON.stringify(err));
    }
    return '';
  }
  // [End photo_index_picker]

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button('selectImg').onClick(event => {
          // 图库中选取图片
          this.photoPickerGetUri().then(uri => {
            hilog.info(0x0000, TAG, `uri: ${uri}`);
            // [Start photo_index_photo_select]
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let file: fileIo.File | undefined;
            try {
              file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
              hilog.info(0x0000, TAG, `file: ${file.fd}`);

              let timeStamp = Date.now();
              // 将用户图片拷贝到应用沙箱路径
              fileIo.copyFileSync(file.fd, context.filesDir + `/original-${timeStamp}.jpg`);

              this.filePath = context.filesDir + `/original-${timeStamp}.jpg`;
              this.originalImage = fileUri.getUriFromPath(this.filePath);
            } catch (e) {
              hilog.info(0x0000, TAG, `readImage failed:${e}`);
            } finally {
              fileIo.close(file);
            }
            // [End photo_index_photo_select]
          })

        }).width('200').margin({ top: 20 })

        Button('editImg').onClick(event => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          // [Start photo_index_ability_callback]
          let abilityStartCallback: common.AbilityStartCallback = {
            onError: (code, name, message) => {
              const tip: string = `code:` + code + ` name:` + name + ` message:` + message;
              hilog.error(0x0000, TAG, `startAbilityByType: fail, err: ${tip}`);
            },
            onResult: (result) => {
              // 获取到回调结果中编辑后的图片uri并做对应的处理
              let uri = result.want?.uri ?? '';
              hilog.info(0x0000, TAG, `PhotoEditorCaller result: ${JSON.stringify(result)}`);
              this.readImage(uri).then(imagePixMap => {
                this.editedImage = imagePixMap;
              });
            }
            // [End photo_index_ability_callback]
          }
          // 将图片转换为图片uri，并调用startAbilityByType拉起图片编辑应用面板
          // [Start photo_index_ability_start]
          let uri = fileUri.getUriFromPath(this.filePath);
          context.startAbilityByType('photoEditor', {
            'ability.params.stream': [uri], // 原始图片的uri,只支持传入一个uri
            'ability.want.params.uriPermissionFlag': wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION // 至少需要分享读权限给到图片编辑面板
          } as Record<string, Object>, abilityStartCallback, (err) => {
            let tip: string;
            if (err) {
              tip = `Start error: ${JSON.stringify(err)}`;
              hilog.error(0x0000, TAG, `startAbilityByType: fail, err: ${JSON.stringify(err)}`);
            } else {
              tip = `Start success`;
              hilog.info(0x0000, TAG, `startAbilityByType: ${tip}`);
            }
          });
          // [End photo_index_ability_start]
        }).width('200').margin({ top: 20 })

        Image(this.originalImage).width('100%').height(200).margin({ top: 20 }).objectFit(ImageFit.Contain)

        Image(this.editedImage).width('100%').height(200).margin({ top: 20 }).objectFit(ImageFit.Contain)
      }
      .width('100%')
    }
    .height('100%')
    .backgroundColor(Color.Orange)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}
// [End photo_index_component]