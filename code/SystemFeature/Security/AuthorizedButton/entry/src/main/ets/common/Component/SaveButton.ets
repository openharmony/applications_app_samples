/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import promptAction from '@ohos.promptAction';
import Logger from '../../utils/Logger';
import dataSharePredicates from '@ohos.data.dataSharePredicates';


@Component
export struct SecSaveButton {
  @State backColor: Resource = $r('app.color.button_default_bg_color1');
  @State textColor: Resource = $r('app.color.button_default_bg_color');
  @State image: Resource = $r('app.media.save');
  @Link saveImage: Resource;
  private screenDensity: number = 0;

  promptAction(message: string | Resource) {
    try {
      promptAction.showToast({
        message: message,
        duration: 6000,
      });
    } catch (error) {
      Logger.error(`showToast args error code is ${error.code}, message is ${error.message}`);
    }
  }

  async saveMedia() {
    try {
      const context = getContext(this);
      // 得到图片内容
      try {
        context.resourceManager.getMediaContent($r('app.media.banner').id, async (error, value) => {
          if (error != null) {
            Logger.error("error is " + error);
          } else {
            let media = value.buffer;
            let helper = photoAccessHelper.getPhotoAccessHelper(context);
            let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'png');
            // 通过uri打开媒体库文件
            let file = await fs.open(uri,  fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
            Logger.info('openFile success, fd: ' + file.fd);
            // 写到媒体库文件中
            await fs.write(file.fd, media);
            await fs.close(file.fd);
            this.promptAction($r('app.string.Save_succeed'));
          }
        });
      } catch (error) {
        Logger.error(`callback getMediaContent failed, error code: ${error.code}, message: ${error.message}.`);
      }

    } catch (err) {
      this.promptAction($r('app.string.Save_failed'));
      Logger.error(`promiseerror code: ${err.code}, message: ${err.message}.`);
    }
  }
  build() {
    Column() {
      SaveButton()
        .onClick(async (event, result) => {
          if (result === SaveButtonOnClickResult.SUCCESS) {
            Logger.info("SUCCESS");
            this.saveMedia();
          }
          if(result === SaveButtonOnClickResult.TEMPORARY_AUTHORIZATION_FAILED){
            Logger.info("TEMPORARY_AUTHORIZATION_FAILED");
          }
        })
    }
    .id('saveButton')
  }
}