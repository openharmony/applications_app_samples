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

import { BusinessError } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { logger } from '../utils/Logger';

// TODO：扁平化ID设置
const ID_TEXT_INPUT: string = 'id_text_input';
const ID_TEXT_PUSH: string = 'id_text_publish';

const typeVideo: string = 'video';
const typeImage: string = 'image';
const TAG: string = 'publishmultimediaupdates';

/** 输入评论弹窗，用于输入文字和图片评论
 * 实现步骤：
 * 1.点击预制图片、发布按钮
 * 2.点击预制图片时通过photoAccessHelper接口拉起图库
 * 3.选择图库资源后获取照片、视频返回地址，并显示在组件中
 * 4.点击发布按钮，将评论添加到列表中
 */

@CustomDialog
export struct CommentInputDialog {
  // 选择的照片
  @State selectedImages: ResourceStr = $r('app.media.add');
  // 选择的视频
  @State selectedVideo: ResourceStr = $r('app.media.add_video');
  // 输入的文字
  @State text: string = '';
  // 使用@Link将CustomDialog内的数据进行链接
  @Link textInComment: string;
  @Link imagesInComment: string;
  @Link videoInComment: string;
  // 设置自定义弹窗类型
  @Link dialogType: string;
  maxSelectMedia: number = 1;
  videoController: VideoController = new VideoController()
  controller?: CustomDialogController;
  // 发布接口，用于主页面更新评论数据
  publish: () => void = (): void => {
  }

  async getPictureFromAlbum() {
    // 拉起相册，选择图片
    let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    // 选择图库内媒体资源种类
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    // 设置最大媒体文件选择数量
    photoSelectOptions.maxSelectNumber = this.maxSelectMedia;
    // 创建photoPicker
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    // 使用photoAccessHelper获取媒体资源信息
    photoPicker.select(photoSelectOptions).then((photoSelectResult) => {
      if (photoSelectResult !== null && photoSelectResult !== undefined) {
        // 获取对应资源文件uri地址
        this.selectedImages = photoSelectResult.photoUris[0];
        this.imagesInComment = photoSelectResult.photoUris[0];
      }
    }).catch((err: BusinessError) => {
      logger.error(TAG,
        `getPictureFromAlbum PhotoViewPicker.select failed, error code: ${err.code}, message: ${err.message}.`);
    })
  }

  async getVideoFromAlbum() {
    // 拉起相册，选择视频
    let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE;
    photoSelectOptions.maxSelectNumber = this.maxSelectMedia;
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    photoPicker.select(photoSelectOptions).then((photoSelectResult) => {
      if (photoSelectResult !== null && photoSelectResult !== undefined) {
        // 获取对应资源文件uri地址
        this.selectedVideo = photoSelectResult.photoUris[0];
        this.videoInComment = photoSelectResult.photoUris[0];
      }
    }).catch((err: BusinessError) => {
      logger.error(TAG,
        `getVideoFromAlbum PhotoViewPicker.select failed, error code: ${err.code}, message: ${err.message}.`);
    })
  }

  build() {
    Column() {
      RelativeContainer() {
        TextInput()
          .height($r('app.integer.image_comment_text_input_height'))
          .padding({
            left: $r('app.integer.image_comment_text_input_padding_left'),
            right: $r('app.integer.image_comment_text_input_padding_right'),
            top: $r('app.integer.image_comment_text_input_padding_top'),
            bottom: $r('app.integer.image_comment_text_input_padding_bottom')
          })
          .margin({
            right: $r('app.integer.image_comment_text_input_margin_top')
          })
          .onChange((textInComment: string) => {
            this.text = textInComment;
          })
          .defaultFocus(true)
          .alignRules({
            // TODO：高性能知识点：使用相对布局组件RelativeContainer，子组件通过alignRules接口将父组件或者其他组件设为锚点，可使布局扁平化，有利于性能提升
            top: { anchor: '__container__', align: VerticalAlign.Top },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            right: { anchor: ID_TEXT_PUSH, align: HorizontalAlign.Start }
          })
          .id(ID_TEXT_INPUT)
        Button($r('app.string.image_comment_publish'))
          .width($r('app.integer.image_comment_button_publish_width'))
          .height($r('app.integer.image_comment_button_publish_height'))
          .borderRadius($r('app.integer.image_comment_button_publish_border_radius'))
          .backgroundColor($r('app.color.image_comment_button_publish_background'))
          .fontColor(Color.White)
          .onClick(() => {
            if (this.controller) {
              this.textInComment = this.text;
              this.publish();
              this.controller.close();
              this.textInComment = '';
              this.imagesInComment = '';
              this.videoInComment = '';
            }
          })
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            right: { anchor: '__container__', align: HorizontalAlign.End }
          })
          .id(ID_TEXT_PUSH)
      }
      .height($r('app.integer.image_comment_relative_container_input_height'))

      if (this.dialogType == typeImage) {
        Image(this.selectedImages)
          .width($r('app.integer.publish_multimedia_updates_single_image_width'))
          .height($r('app.integer.publish_multimedia_updates_single_image_height'))
          .borderRadius($r('app.integer.publish_multimedia_updates_single_image_radius'))
          .offset({ right: $r('app.integer.media_offset_to_right') })
          .onClick(() => {
            // 选取照片
            this.getPictureFromAlbum()
          })
          .id('select_picture_button')
      }

      if (this.dialogType == typeVideo) {
        Video({
          src: this.selectedVideo,
          previewUri: this.selectedImages,
          controller: this.videoController
        })
          .width($r('app.integer.publish_multimedia_updates_single_image_width'))
          .height($r('app.integer.publish_multimedia_updates_single_image_height'))
          .borderRadius($r('app.integer.publish_multimedia_updates_single_image_radius'))
          .controls(false)
          .offset({ right: $r('app.integer.media_offset_to_right') })
          .autoPlay(true)
          .objectFit(ImageFit.Cover)
          .muted(true)
          .onClick(() => {
            ///选取视频
            this.getVideoFromAlbum()
          })
          .id('select_video_button')

      }

    }
    .padding($r('app.integer.image_comment_column_input_padding'))
    .backgroundColor(Color.White)
    // 添加y轴偏移量，否则弹窗和输入法间会有空白
    .offset({
      y: $r('app.integer.image_comment_column_input_dialog_offset_y')
    })
  }
}