/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { Constants } from '../common/Constants';
import { promptAction, window } from '@kit.ArkUI';
import { CommentDataSource } from '../model/CommentDataSource';

@Component
export struct Comment {
  close: () => void = () => {
  };
  private data: CommentDataSource = new CommentDataSource([]);
  private scroller: Scroller = new Scroller();
  @State bottomHeight: number = 0;

  aboutToAppear(): void {
    // 获取导航条高度，手动进行避让
    window.getLastWindow(getContext(), (err, data) => {
      const avoidAreaBottom = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      this.bottomHeight = avoidAreaBottom.bottomRect.height;
    })
    // 加载示例评论
    for (let i = 0; i < Constants.TEST_COMMENTS_COUNT; i++) {
      this.data.pushItem(i);
    }
  }

  build() {
    Column() {
      // title
      Row() {
        Blank()
          .width($r('app.integer.immersive_comment_title_blank_width'))
        Text($r('app.string.immersive_comment_title_label'))
          .fontSize($r('app.integer.immersive_comment_title_font_size'))
          .fontWeight(FontWeight.Bold)
          .width($r('app.integer.immersive_comment_title_font_width'))
          .textAlign(TextAlign.Center)
        Row() {
          Image($r('app.media.immersive_close'))
            .width($r('app.integer.immersive_comment_title_close_img_size'))
            .height($r('app.integer.immersive_comment_title_close_img_size'))
        }
        .width($r('app.integer.immersive_comment_title_close_button_width'))
        .height($r('app.integer.immersive_comment_title_close_button_height'))
        .justifyContent(FlexAlign.Center)
        .onClick(this.close)
        .id('close_button')
      }
      .width($r('app.string.immersive_full_size'))
      .height($r('app.integer.immersive_comment_title_height'))
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: $r('app.integer.immersive_comment_padding'),
        right: $r('app.integer.immersive_comment_padding')
      })

      // commets list
      List({ space: Constants.COMMENT_SPACE, scroller: this.scroller }) {
        // TODO: 高性能知识点: LazyForEach按需加载，提高加载性能。
        LazyForEach(this.data, (item: number, index: number) => {
          ListItem() {
            this.commentItem(index + 1) // index from 1
          }
          .margin({ bottom: index === this.data.totalCount() - 1 ? px2vp(this.bottomHeight) : 0 })
        }, (item: number) => item.toString())
      }
      .width($r('app.string.immersive_full_size'))
      // TODO: 高性能知识点: 使用了cachedCount设置预加载的评论，提高快速滑动时的性能。
      .cachedCount(Constants.COMMENTS_LIST_CACHE)
      .padding({
        left: $r('app.integer.immersive_comment_padding'),
        right: $r('app.integer.immersive_comment_padding')
      })
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1) // 自适应布局
    }
    .width($r('app.string.immersive_full_size'))
    .height($r('app.string.immersive_full_size'))
  }

  @Builder
  commentItem(index: number) {
    Row({ space: Constants.COMMENT_ITEM_SPACE }) {
      Image($r('app.media.immersive_portrait_1'))
        .width($r('app.integer.immersive_comment_portrait_size'))
        .height($r('app.integer.immersive_comment_portrait_size'))
        .borderRadius($r('app.integer.immersive_comment_portrait_radius'))

      Column({ space: Constants.COMMENT_CONTENT_SPACE }) {
        // id
        Text(Constants.COMMENTS_DEFAULT_USERNAME + index.toString())
          .fontSize($r('app.integer.immersive_comment_username_font_size'))
          .fontColor(Color.Gray)
        // comment
        Text($r('app.string.immersive_comment_example'))
        // comment image
        Image($r('app.media.immersive_comment_pic'))
          .width($r('app.integer.immersive_comment_image_size'))
          .height($r('app.integer.immersive_comment_image_size'))
          .borderRadius($r('app.integer.immersive_comment_image_radius'))
        Row() {
          Text($r('app.string.immersive_comment_time'))
            .fontSize($r('app.integer.immersive_comment_time_font_size'))
            .fontColor(Color.Gray)
          Blank()
            .width($r('app.integer.immersive_comment_info_blank_width'))
          Text($r('app.string.immersive_comment_reply_label'))
            .fontSize($r('app.integer.immersive_comment_reply_font_size'))
            .fontColor($r('app.color.immersive_comment_reply_font_color'))
            .onClick(() => {
              promptAction.showToast({ message: $r('app.string.immersive_mode_other_function') });
            })
          Blank()
          Image($r('app.media.immersive_like'))
            .width($r('app.integer.immersive_comment_like_icon_size'))
            .height($r('app.integer.immersive_comment_like_icon_size'))
            .onClick(() => {
              promptAction.showToast({ message: $r('app.string.immersive_mode_other_function') });
            })
        }
        .width($r('app.string.immersive_full_size'))

      }
      .layoutWeight(1) // 自适应布局
      .alignItems(HorizontalAlign.Start)
    }
    .alignItems(VerticalAlign.Top)
    .width($r('app.string.immersive_full_size'))
  }
}
