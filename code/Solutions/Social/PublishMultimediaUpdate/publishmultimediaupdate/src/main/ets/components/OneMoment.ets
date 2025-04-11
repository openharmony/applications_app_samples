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

import { FriendMoment } from '../model/BasicDataSource';
import { ImageText } from './ImageText';
import { ListConstants } from '../constants/ListConstants';
import { promptAction } from '@kit.ArkUI';

/**
 * 列表子组件
 */
// TODO: 性能知识点：@Reusable复用组件优化，详情请见：https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/quick-start/arkts-reusable.md
@Reusable
@Component
export struct OneMoment {
  @Prop moment: FriendMoment;
  controller: VideoController = new VideoController()

  aboutToReuse(params: Record<string, Object>): void {
    this.moment = params.moment as FriendMoment;
  }

  build() {
    Column() {
      Row() {
        Image(this.moment.avatar)
          .autoResize(false)
          .width($r('app.integer.publish_multimedia_updates_user_image_width'))
          .height($r('app.integer.publish_multimedia_updates_user_image_height'))
          .borderRadius($r('app.integer.publish_multimedia_updates_user_image_border_radius'))
        Column() {
          Text(this.moment.userName)
            .fontSize($r('app.integer.publish_multimedia_updates_useName_fontSize'))
            .fontColor($r('app.color.publish_multimedia_updates_title_font_color'))
            .lineHeight($r('app.integer.publish_multimedia_updates_useName_line_height'))
            .fontFamily($r('app.string.publish_multimedia_updates_harmony_hei_ti'))
            .fontWeight(FontWeight.Medium)
          Text(this.moment.text)
            .fontSize($r('app.integer.publish_multimedia_updates_userText_fontSize'))
            .fontColor($r('app.color.publish_multimedia_updates_title_font_color'))
            .lineHeight($r('app.integer.publish_multimedia_updates_userText_line_height'))
            .opacity($r('app.float.publish_multimedia_updates_opacity'))
            .margin({ top: $r('app.integer.publish_multimedia_updates_userText_margin_top') })
        }
        .margin({ left: $r('app.integer.publish_multimedia_updates_user_col_margin_left') })
        .layoutWeight(ListConstants.LAYOUT_WEIGHT)
        .alignItems(HorizontalAlign.Start)
      }
      .width($r('app.string.publish_multimedia_updates_layout_100'))
      .constraintSize({ minHeight: $r('app.integer.publish_multimedia_updates_oneMoment_height') })
      .padding({
        left: $r('app.integer.publish_multimedia_updates_row_padding_left'),
        right: $r('app.integer.publish_multimedia_updates_row_padding_right'),
        top: $r('app.integer.publish_multimedia_updates_row_padding_top'),
        bottom: $r('app.integer.publish_multimedia_updates_row_padding_bottom')
      })

      Stack() {
        if (this.moment.image && JSON.stringify(this.moment.image) !== JSON.stringify($r('app.media.add'))) {
          Column() {
            Image(this.moment.image)
              .width($r('app.integer.publish_multimedia_updates_single_image_width'))
              .height($r('app.integer.publish_multimedia_updates_single_image_height'))
              .borderRadius($r('app.integer.publish_multimedia_updates_single_image_radius'))
          }
          .alignItems(HorizontalAlign.Start)
          .width($r('app.string.publish_multimedia_updates_layout_100'))
          .padding({
            left: $r('app.integer.publish_multimedia_updates_image_group_padding_left'),
            right: $r('app.integer.publish_multimedia_updates_image_group_padding_right')
          })
        }

        if (this.moment.video && JSON.stringify(this.moment.video) !== JSON.stringify($r('app.media.add_video'))) {
          Column() {
            Video({
              src: this.moment.video,
              controller: this.controller
            })
              .width($r('app.integer.publish_multimedia_updates_single_image_width'))
              .height($r('app.integer.publish_multimedia_updates_single_image_height'))
              .borderRadius($r('app.integer.publish_multimedia_updates_single_image_radius'))
              .autoPlay(true)
              .controls(false)
              .loop(true)
              .objectFit(ImageFit.Cover)
              .muted(true)

          }
          .alignItems(HorizontalAlign.Start)
          .width($r('app.string.publish_multimedia_updates_layout_100'))
          .padding({
            left: $r('app.integer.publish_multimedia_updates_image_group_padding_left'),
            right: $r('app.integer.publish_multimedia_updates_image_group_padding_right')
          })
        }
      }

      Row() {
        ImageText({
          imageStr: $r('app.media.publish_multimedia_updates_ic_share'),
          text: $r('app.string.publish_multimedia_updates_share')
        })
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.publish_multimedia_updates_other_function'),
            });
          })
        ImageText({
          imageStr: $r('app.media.publish_multimedia_updates_ic_thumbsup'),
          text: $r('app.string.publish_multimedia_updates_thumbs_up')
        })
          .margin({ left: $r('app.integer.publish_multimedia_updates_thumbsup_margin_left') })
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.publish_multimedia_updates_other_function'),
            });
          })
        ImageText({
          imageStr: $r('app.media.publish_multimedia_updates_ic_message'),
          text: $r('app.string.publish_multimedia_updates_message')
        })
          .margin({ left: $r('app.integer.publish_multimedia_updates_message_margin_left') })
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.publish_multimedia_updates_other_function'),
            });
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width($r('app.string.publish_multimedia_updates_layout_100'))
      .margin({
        top: $r('app.integer.publish_multimedia_updates_handler_margin_top'),
        bottom: $r('app.integer.publish_multimedia_updates_handler_margin_bottom')
      })
      .padding({
        left: $r('app.integer.publish_multimedia_updates_handler_padding_left'),
        right: $r('app.integer.publish_multimedia_updates_handler_padding_right')
      })
    }
    .width($r('app.string.publish_multimedia_updates_layout_100'))
  }
}
