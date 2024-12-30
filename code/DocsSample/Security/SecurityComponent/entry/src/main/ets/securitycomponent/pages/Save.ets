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

import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

async function savePhotoToGallery(context: common.UIAbilityContext) {
  let helper = photoAccessHelper.getPhotoAccessHelper(context);
  try {
    // onClick触发后5秒内通过createAsset接口创建图片文件，5秒后createAsset权限收回。
    let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');
    // 使用uri打开文件，可以持续写入内容，写入过程不受时间限制
    let file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    // $r('app.media.test')可以替换为开发者所需的图像资源文件
    context.resourceManager.getMediaContent($r('app.media.test').id, 0)
      .then(async value => {
        let media = value.buffer;
        // 写到媒体库文件中
        await fileIo.write(file.fd, media);
        await fileIo.close(file.fd);
        promptAction.showToast({ message: $r('app.string.saved_in_photo') });
      });
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to save photo. Code is ${err.code}, message is ${err.message}`);
  }
}

@Entry
@Component
struct Index {
  build() {
    Row() {
      Column({ space: 10 }) {
        // $r('app.media.startIcon')需要替换为开发者所需的图像资源文件
        Image($r('app.media.test'))
          .height(400)
          .width('100%')

        SaveButton()
          .padding({
            top: 12,
            bottom: 12,
            left: 24,
            right: 24
          })
          .onClick(async (event: ClickEvent, result: SaveButtonOnClickResult) => {
            if (result === SaveButtonOnClickResult.SUCCESS) {
              const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
              // 免去权限申请和权限请求等环节，获得临时授权，保存对应图片
              savePhotoToGallery(context);
            } else {
              promptAction.showToast({ message: $r('app.string.set_permission_failed') });
            }
          })
      }
      .width('100%')
    }
    .height('100%')
    .backgroundColor(0xF1F3F5)
  }
}