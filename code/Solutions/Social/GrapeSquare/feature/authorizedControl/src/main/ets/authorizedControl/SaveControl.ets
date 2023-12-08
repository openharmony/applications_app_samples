/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import common from '@ohos.app.ability.common';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import fs from '@ohos.file.fs';
import Logger from '../utils/Logger';
import { promptActionFn } from '../model/DataFactory';
import { Options } from '../model/BaseMsg';

let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

@Component
export struct SaveControl {
  private imageUri: Resource = $r('app.media.photo118');
  private mediaUri: string = '';
  @Link isShowSaveButton: boolean;

  // 点击保存图片
  saveImage() {
    try {
      context.resourceManager.getMediaContent(this.imageUri.id, async (error, value) => {
        if (error) {
          Logger.error(`error is ${error}`);
        } else {
          let media = value.buffer;
          let helper = photoAccessHelper.getPhotoAccessHelper(context);
          let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'png');
          // 通过uri打开媒体库文件
          let file = fs.openSync(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
          Logger.info(`openFile success, fd: ${file.fd}`);
          // 写到媒体库文件中
          fs.writeSync(file.fd, media);
          fs.closeSync(file.fd);
          promptActionFn($r('app.string.save_succeed'));
          this.isShowSaveButton = false;
        }
      });
    } catch (error) {
      this.isShowSaveButton = false;
      promptActionFn($r('app.string.save_failed'));
      Logger.error(`callback getMediaContent failed, error code: ${error.code}, message: ${error.message}.`);
    }
  }

  // 点击保存视频
  saveVideo() {
    try {
      context.resourceManager.getRawFd(this.mediaUri, async (error, value) => {
        if (error) {
          Logger.error(`error is ${JSON.stringify(error)}`);
        } else {
          let mediaFd = value.fd;
          let buffer = new ArrayBuffer(value.length);
          let options: Options = new Options(value.offset, value.length);
          let helper = photoAccessHelper.getPhotoAccessHelper(context);
          let videoUri = await helper.createAsset(photoAccessHelper.PhotoType.VIDEO, 'mp4');
          // 通过uri打开媒体库文件
          let file = fs.openSync(videoUri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
          fs.readSync(mediaFd, buffer, options);
          fs.writeSync(file.fd, buffer);
          fs.closeSync(file.fd);
          promptActionFn($r('app.string.save_succeed'));
          this.isShowSaveButton = false;
        }
      });
    } catch (error) {
      this.isShowSaveButton = false;
      promptActionFn($r('app.string.save_failed'));
      Logger.error(`callback getRawFileContent failed, error code: ${error.code}, message: ${error.message}.`);
    }
  }

  async saveMedia() {
    Logger.info(`saveMedia start`);
    if (this.mediaUri) {
      this.saveVideo();
    } else {
      this.saveImage()
    }
  }

  build() {
    SaveButton({ text: SaveDescription.SAVE, buttonType: ButtonType.Capsule })
      .fontColor(Color.Black)
      .fontSize($r('app.integer.layout_size_16'))
      .padding({
        left: $r('app.integer.layout_size_20'),
        right: $r('app.integer.layout_size_20'),
        top: $r('app.integer.layout_size_10'),
        bottom: $r('app.integer.layout_size_10')
      })
      .backgroundColor(Color.White)
      .onClick(async (event, result) => {
        if (result === SaveButtonOnClickResult.SUCCESS) {
          Logger.info('SUCCESS');
          this.saveMedia();
        }
        if (result === SaveButtonOnClickResult.TEMPORARY_AUTHORIZATION_FAILED) {
          Logger.info('TEMPORARY_AUTHORIZATION_FAILED');
        }
      })

  }
}

