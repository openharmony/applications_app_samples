/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start movingphotoview_import_api21]
//import { MovingPhotoView, MovingPhotoViewController, MovingPhotoViewAttribute } from '@kit.MediaLibraryKit';
// [End movingphotoview_import_api21]

// [Start movingphotoview_import_api22]
import { MovingPhotoView, MovingPhotoViewController } from '@kit.MediaLibraryKit';
// [End movingphotoview_import_api22]

// [StartExclude movingphotoview_component]
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { fileIo } from '@kit.CoreFileKit';

const DOMAIN = 0x0000;
const TAG = 'MovingPhotoViewSample';
const IMAGE_FILE_NAME = 'moving_photo.jpg';
const VIDEO_FILE_NAME = 'moving_photo.mp4';
// [EndExclude movingphotoview_component]

// [Start movingphotoview_component]
// API version 21及之前版本导入方式：import { photoAccessHelper, MovingPhotoView, MovingPhotoViewController, MovingPhotoViewAttribute } from '@kit.MediaLibraryKit';
// API version 22及之后版本导入方式如下：
// import { photoAccessHelper, MovingPhotoView, MovingPhotoViewController } from '@kit.MediaLibraryKit';

@Entry
@Component
struct Index {
  // [Start movingphotoview_src]
  @State src: photoAccessHelper.MovingPhoto | undefined = undefined
  // [End movingphotoview_src]
  // [StartExclude movingphotoview_component]
  @State message: string = '正在加载动态照片...'
  // [EndExclude movingphotoview_component]
  @State isMuted: boolean = false
  // [Start movingphotoview_controller]
  controller: MovingPhotoViewController = new MovingPhotoViewController();
  // [End movingphotoview_controller]

  // [StartExclude movingphotoview_component]
  aboutToAppear(): void {
    this.loadMovingPhoto();
  }

  async loadMovingPhoto(): Promise<void> {
    try {
      let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      
      if (context === undefined) {
        hilog.error(DOMAIN, TAG, 'context is undefined');
        this.message = '获取上下文失败';
        return;
      }
      
      await this.copyRawFileToSandbox(context, IMAGE_FILE_NAME);
      await this.copyRawFileToSandbox(context, VIDEO_FILE_NAME);
      
      let imageFileUri = 'file://' + context.filesDir + '/' + IMAGE_FILE_NAME;
      let videoFileUri = 'file://' + context.filesDir + '/' + VIDEO_FILE_NAME;
      
      let movingPhoto = await photoAccessHelper.MediaAssetManager.loadMovingPhoto(context, imageFileUri, videoFileUri);
      this.src = movingPhoto;
      this.message = '动态照片已加载，长按可播放';
      hilog.info(DOMAIN, TAG, 'load moving photo successfully');
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'load moving photo failed: %{public}s', JSON.stringify(err));
      this.message = '加载动态照片失败';
    }
  }

  async copyRawFileToSandbox(context: Context, fileName: string): Promise<void> {
    let resourceMgr = context.resourceManager;
    let fileData = await resourceMgr.getRawFileContent(fileName);
    
    let sandboxPath = context.filesDir + '/' + fileName;
    let file = fileIo.openSync(sandboxPath, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);
    fileIo.writeSync(file.fd, fileData.buffer);
    fileIo.closeSync(file);
  }
  // [EndExclude movingphotoview_component]

  build() {
    Column() {
      // [StartExclude movingphotoview_component]
      Text(this.message)
        .fontSize(16)
        .margin({ top: 20, bottom: 10 })
      // [EndExclude movingphotoview_component]

      MovingPhotoView({
        movingPhoto: this.src,
        controller: this.controller
      })
        // 是否静音播放，此处由按钮控制，默认值为false非静音播放。
        .muted(this.isMuted)
        // 视频显示模式，默认值为Cover。
        .objectFit(ImageFit.Cover)
        // 播放时触发。
        .onStart(() => {
          console.info('onStart');
        })
        // 播放结束触发。
        .onFinish(() => {
          console.info('onFinish');
        })
        // 播放停止触发。
        .onStop(() => {
          console.info('onStop')
        })
        // 出现错误触发。
        .onError(() => {
          console.error('onError');
        })
      // [StartExclude movingphotoview_component]
      .width('100%')
      .height('70%')
      // [EndExclude movingphotoview_component]

      Row() {
        // 按钮：开始播放。
        Button('PLAY')
          .onClick(() => {
            this.controller.startPlayback()
          })
          .margin(5)
        // 按钮：停止播放。
        Button('STOP')
          .onClick(() => {
            this.controller.stopPlayback()
          })
          .margin(5)
        // [StartExclude movingphotoview_component]
        Button('静音')
          .onClick(() => {
            this.isMuted = !this.isMuted;
          })
          .margin(5)
        // [EndExclude movingphotoview_component]
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height('15%')
    }
    // [StartExclude movingphotoview_component]
    .width('100%')
    .height('100%')
    // [EndExclude movingphotoview_component]
  }
}
// [End movingphotoview_component]