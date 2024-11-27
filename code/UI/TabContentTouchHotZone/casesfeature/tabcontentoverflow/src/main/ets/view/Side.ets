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
import { CONFIGURATION, STRINGCONFIGURATION } from '../common/Constants';
import { promptAction } from '@kit.ArkUI';
import { Utils } from '../common/Utils';

// 展示视频播放界面右侧用户头像、视频评论数量、收藏数量、分享数量、作者是否被用户关注等信息
@Component
export struct Side {
  private head: Resource = $r('app.media.tabcontentoverflow_head_image'); // 头像
  @State likeCount: number = 1234; // 点赞数量
  @State commentCount: number = 2234; // 评论数量
  @State favoriteCount: number = 3234; // 收藏数量
  @State isFocus: boolean = false; // 是否关注
  @State isLike: boolean = false; // 是否点赞
  @State isFavorite: boolean = false; // 是否收藏
  private utils = new Utils();

  // 点击点赞按钮的回调函数
  private changeLikeCount() {
    if (!this.isLike) {
      this.likeCount++;
    } else {
      this.likeCount--;
    }
    animateTo({ duration: CONFIGURATION.TABCONTENT_OVERFLOW_DURATION, curve: Curve.EaseInOut }, () => {
      this.isLike = !this.isLike;
    })
  }

  // 点击收藏按钮的回调函数
  private changeFavoriteCount() {
    if (!this.isFavorite) {
      this.favoriteCount++;
    } else {
      this.favoriteCount--;
    }
    animateTo({ duration: CONFIGURATION.TABCONTENT_OVERFLOW_DURATION, curve: Curve.EaseInOut }, () => {
      this.isFavorite = !this.isFavorite;
    })
  }

  /**
   * 高性能布局策略: 界面深度的增加会提升渲染和计算影响性能。推荐使用扁平化设计，如RelativeContainer，以简化布局结构，降低组件层级，从而提升渲染效率。
   * 优化布局性能:https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/performance/reduce-view-nesting-levels.md
   */
  build() {
    RelativeContainer() {
      Image(this.head)
        .width($r('app.integer.tabcontentoverflow_head_image_width'))
        .height($r('app.integer.tabcontentoverflow_head_image_height'))
        .borderRadius(CONFIGURATION.TABCONTENT_OVERFLOW_HEADIMAGE_BORDER_RADIUS)
        .border({
          width: $r('app.integer.tabcontentoverflow_head_image_border_width'),
          color: Color.White
        })
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HEAD_IMAGE)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: VerticalAlign.Top },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
        })
        .margin({ left: CONFIGURATION.TABCONTENT_OVERFLOW_HEADIMAGE_MARGIN_LEFT })
        .onClick(() => {
          this.utils.showPromptAction();
        })
      Image(this.isFocus ? $r('app.media.tabcontentoverflow_follow') : $r('app.media.tabcontentoverflow_foucs_add'))
        .width($r('app.integer.tabcontentoverflow_focus_image_width'))
        .height($r('app.integer.tabcontentoverflow_focus_image_height'))
        .borderRadius($r('app.integer.tabcontentoverflow_focus_image_border_radius'))
        .margin({
          top: $r('app.integer.tabcontentoverflow_focus_image_margin'),
          left: $r('app.integer.tabcontentoverflow_focus_image_margin')
        })
        .onClick(() => {
          animateTo({ duration: CONFIGURATION.TABCONTENT_OVERFLOW_DURATION, curve: Curve.EaseInOut }, () => {
            this.isFocus = !this.isFocus;
          })
        })
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_FOCUS_IMAGE)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HEAD_IMAGE, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HEAD_IMAGE, align: HorizontalAlign.Center },
        })
      Image(this.isLike ? $r('app.media.tabcontentoverflow_fabulo') : $r('app.media.tabcontentoverflow_fabulous'))
        .width($r('app.integer.tabcontentoverflow_like_image_width'))
        .height($r('app.integer.tabcontentoverflow_like_image_height'))
        .objectFit(ImageFit.ScaleDown)
        .onClick(() => {
          this.changeLikeCount();
        })
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_LIKE_IMAGE)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_FOCUS_IMAGE, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.End },
        })
        .margin({ top: $r('app.integer.tabcontentoverflow_like_image_margin_top') })
      Text(this.likeCount.toString())
        .fontSize($r('app.integer.tabcontentoverflow_like_text_font_size'))
        .fontColor(Color.White)
        .opacity(CONFIGURATION.TABCONTENT_OVERFLOW_TEXT_OPACITY)
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_LIKE_TEXT)
        .textAlign(TextAlign.Center)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_LIKE_IMAGE, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.End },
        })
        .margin({ top: $r('app.integer.tabcontentoverflow_like_text_margin_top') })
      Image($r('app.media.tabcontentoverflow_comment'))
        .width($r('app.integer.tabcontentoverflow_like_image_width'))
        .height($r('app.integer.tabcontentoverflow_like_image_height'))
        .objectFit(ImageFit.ScaleDown)
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_COMMENT_IMAGE)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_LIKE_TEXT, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.End },
        })
        .margin({ top: $r('app.integer.tabcontentoverflow_like_image_margin_top') })
        .onClick(() => {
          this.utils.showPromptAction();
        })
      Text(this.commentCount.toString())
        .fontSize($r('app.integer.tabcontentoverflow_like_text_font_size'))
        .fontColor(Color.White)
        .opacity(CONFIGURATION.TABCONTENT_OVERFLOW_TEXT_OPACITY)
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_COMMENT_TEXT)
        .textAlign(TextAlign.Center)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_COMMENT_IMAGE, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.End },
        })
        .margin({ top: $r('app.integer.tabcontentoverflow_like_text_margin_top') })
      Image(this.isFavorite ? $r('app.media.tabcontentoverflow_highlightsed_yellow') : $r('app.media.tabcontentoverflow_highlightsed_white'))
        .width($r('app.integer.tabcontentoverflow_like_image_width'))
        .height($r('app.integer.tabcontentoverflow_like_image_height'))
        .onClick(() => {
          this.changeFavoriteCount();
        })
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_FAVORITE_IMAGE)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_COMMENT_TEXT, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.End },
        })
        .margin({ top: $r('app.integer.tabcontentoverflow_like_image_margin_top') })
      Text(this.favoriteCount.toString())
        .fontSize($r('app.integer.tabcontentoverflow_like_text_font_size'))
        .fontColor(Color.White)
        .opacity(CONFIGURATION.TABCONTENT_OVERFLOW_TEXT_OPACITY)
        .id(STRINGCONFIGURATION.TABCONTEN_TOVERFLOW_FAVORITE_TEXT)
        .textAlign(TextAlign.Center)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_FAVORITE_IMAGE, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.End },
        })
        .margin({ top: $r('app.integer.tabcontentoverflow_like_text_margin_top') })
      Image($r('app.media.tabcontentoverflow_share'))
        .width($r('app.integer.tabcontentoverflow_like_image_width'))
        .height($r('app.integer.tabcontentoverflow_like_image_height'))
        .objectFit(ImageFit.ScaleDown)
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_SHARE_IMAGE)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTEN_TOVERFLOW_FAVORITE_TEXT, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.End },
        })
        .margin({ top: $r('app.integer.tabcontentoverflow_like_image_margin_top') })
        .onClick(() => {
          this.utils.showPromptAction();
        })
      Text($r('app.string.tabcontentoverflow_share'))
        .fontSize($r('app.integer.tabcontentoverflow_like_text_font_size'))
        .fontColor(Color.White)
        .opacity(CONFIGURATION.TABCONTENT_OVERFLOW_TEXT_OPACITY)
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_SHARE_TEXT)
        .textAlign(TextAlign.Center)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_SHARE_IMAGE, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.End },
        })
        .margin({ top: $r('app.integer.tabcontentoverflow_like_text_margin_top') })
    }
    .height($r('app.integer.tabcontentoverflow_relativecontainer_height'))
    .width($r('app.integer.tabcontentoverflow_relativecontainer_width'))
  }
}

// 展示视频相关信息，比如视频作者的昵称、视频文案、搭配的音乐以及发布时间
@Component
export struct VideoDes {
  @State name: string = STRINGCONFIGURATION.TABCONTENT_OVERFLOW_VIDEO_DES_NAME; // 昵称
  @State description: string = STRINGCONFIGURATION.TABCONTENT_OVERFLOW_VIDEO_DES_DESCRIPTION; // 文案
  @State hotspot: string = STRINGCONFIGURATION.TABCONTENT_OVERFLOW_VIDEO_DES_HOTSPOT; // 上升热点
  @State time: string = STRINGCONFIGURATION.TABCONTENT_OVERFLOW_VIDEO_DES_TIME; // 发布时间

  // 点击未开发功能按钮弹出提示函数
  private showPromptAction() {
    promptAction.showToast({
      message: $r('app.string.tabcontentoverflow_toast_message'),
      duration: CONFIGURATION.TABCONTENT_OVERFLOW_DURATION
    });
  }

  build() {
    RelativeContainer() {
      Text(this.name)
        .fontSize($r('app.integer.tabcontentoverflow_name_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_NAME_TEXT)
        .padding({ left: $r('app.integer.tabcontentoverflow_name_text_margin_left') })
      Text(this.description)
        .fontSize($r('app.integer.tabcontentoverflow_des_text_font_size'))
        .fontColor(Color.White)
        .maxLines(CONFIGURATION.TABCONTENT_OVERFLOW_MAXLINE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_DESCRIPTION_TEXT)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_NAME_TEXT, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_NAME_TEXT, align: HorizontalAlign.Start },
        })
        .margin({ top: $r('app.integer.tabcontentoverflow_des_text_margin_top') })
        .padding({ left: $r('app.integer.tabcontentoverflow_des_text_padding_left') })
      Text(this.time)
        .fontSize($r('app.integer.tabcontentoverflow_time_text_font_size'))
        .fontColor($r('app.color.tabcontentoverflow_time_text_font_color'))
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TIME_TEXT)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_DESCRIPTION_TEXT, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_DESCRIPTION_TEXT, align: HorizontalAlign.Start },
        })
        .padding({ left: $r('app.integer.tabcontentoverflow_des_text_padding_left') })
      Text()
        .width($r('app.string.tabcontentoverflow_full_size'))
        .height($r('app.integer.tabcontentoverflow_upgrade_height'))
        .backgroundColor($r('app.color.tabcontentoverflow_gray_background_color'))
        .opacity(CONFIGURATION.TABCONTENT_OVERFLOW_OPACITY)
        .padding({
          left: $r('app.integer.tabcontentoverflow_upgrade_padding'),
          right: $r('app.integer.tabcontentoverflow_upgrade_padding')
        })
        .margin({ top: $r('app.integer.tabcontentoverflow_gray_background_margin_top') })
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_GRAY_BACKGROUND)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TIME_TEXT, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TIME_TEXT, align: HorizontalAlign.Start },
        })
        .onClick(() => {
          this.showPromptAction();
        })
      Image($r('app.media.tabcontentoverflow_upgrade_filled'))
        .height($r('app.integer.tabcontentoverflow_upgrade_icon_size'))
        .width($r('app.integer.tabcontentoverflow_upgrade_icon_size'))
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HOT_IMAGE)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_GRAY_BACKGROUND, align: VerticalAlign.Top },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_GRAY_BACKGROUND, align: HorizontalAlign.Start },
        })
        .margin({
          top: $r('app.integer.tabcontentoverflow_upgrade_filled_margin_top'),
          left: $r('app.integer.tabcontentoverflow_des_text_padding_left')
        })
        .onClick(() => {
          this.showPromptAction();
        })
      Text($r('app.string.tabcontentoverflow_upgrade_hot'))
        .fontSize($r('app.integer.tabcontentoverflow_upgrade_text_font_size'))
        .fontColor($r('app.color.tabcontentoverflow_up_color'))
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HOT_TEXT)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HOT_IMAGE, align: VerticalAlign.Top },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HOT_IMAGE, align: HorizontalAlign.End },
        })
        .onClick(() => {
          this.showPromptAction();
        })
      Text(this.hotspot)
        .fontSize($r('app.integer.tabcontentoverflow_mus_font_size'))
        .fontColor(Color.White)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HOT_SPOT)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HOT_TEXT, align: VerticalAlign.Top },
          bottom: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HOT_TEXT, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HOT_TEXT, align: HorizontalAlign.End },
        })
        .onClick(() => {
          this.showPromptAction();
        })
      Image($r('app.media.tabcontentoverflow_arrow_right'))
        .height($r('app.integer.tabcontentoverflow_upgrade_icon_size'))
        .width($r('app.integer.tabcontentoverflow_upgrade_icon_size'))
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_PEOPLE_NUMARROW)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HOT_TEXT, align: VerticalAlign.Top },
          bottom: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HOT_TEXT, align: VerticalAlign.Bottom },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.End },
        })
        .margin({ right: $r('app.integer.tabcontentoverflow_arrow_right_margin_right') })
        .onClick(() => {
          this.showPromptAction();
        })
      Text($r('app.string.tabcontentoverflow_online_people'))
        .fontSize($r('app.integer.tabcontentoverflow_mus_font_size'))
        .fontColor(Color.White)
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_PEOPLE_NUM)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_PEOPLE_NUMARROW, align: VerticalAlign.Top },
          bottom: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_PEOPLE_NUMARROW, align: VerticalAlign.Bottom },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_PEOPLE_NUMARROW, align: HorizontalAlign.Start },
        })
        .onClick(() => {
          this.showPromptAction();
        })
      Divider()
        .vertical(true)
        .color(Color.White)
        .strokeWidth(CONFIGURATION.TABCONTENT_OVERFLOW_ONE)
        .height($r('app.integer.tabcontentoverflow_upgrade_text_font_size'))
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_DIVIDER)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_PEOPLE_NUMARROW, align: VerticalAlign.Top },
          bottom: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_PEOPLE_NUMARROW, align: VerticalAlign.Bottom },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_PEOPLE_NUM, align: HorizontalAlign.Start },
        })
        .margin({ right: $r('app.integer.tabcontentoverflow_divider_margin_right') })
        .onClick(() => {
          this.showPromptAction();
        })
    }
    .height($r('app.integer.tabcontentoverflow_video_des_relativecontainer_height'))
  }
}

// 顶部视图
@Component
export struct TopView {
  private utils = new Utils();

  build() {
    RelativeContainer() {
      Image($r('app.media.tabcontentoverflow_search_icon'))
        .width($r('app.integer.tabcontentoverflow_search_icon_width'))
        .height($r('app.integer.tabcontentoverflow_search_icon_height'))
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_SEARCH_IMAGE)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: VerticalAlign.Top },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
        })
        .margin({
          top: $r('app.integer.tabcontentoverflow_search_image_margin'),
          left: $r('app.integer.tabcontentoverflow_search_image_margin')
        })
        .onClick(() => {
          this.utils.showPromptAction();
        })
      Text($r('app.string.tabcontentoverflow_focus'))
        .fontColor($r('app.color.tabcontentoverflow_font_color'))
        .fontSize($r('app.integer.tabcontentoverflow_tab_font_size'))
        .width($r('app.string.tabcontentoverflow_focus_width'))
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_FOLLOW_TEXT)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_SEARCH_IMAGE, align: VerticalAlign.Top },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_SEARCH_IMAGE, align: HorizontalAlign.End },
        })
        .textAlign(TextAlign.Center)
        .margin({ left: $r('app.integer.tabcontentoverflow_search_image_margin') })
        .onClick(() => {
          this.utils.showPromptAction();
        })
      Text($r('app.string.tabcontentoverflow_selected'))
        .fontColor(Color.White)
        .fontSize($r('app.integer.tabcontentoverflow_tab_font_size'))
        .width($r('app.string.tabcontentoverflow_focus_width'))
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_SELECTED_TEXT)
        .textAlign(TextAlign.Center)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_FOLLOW_TEXT, align: VerticalAlign.Top },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_FOLLOW_TEXT, align: HorizontalAlign.End },
        })
        .onClick(() => {
          this.utils.showPromptAction();
        })
      Text($r('app.string.tabcontentoverflow_recommendation'))
        .fontColor($r('app.color.tabcontentoverflow_font_color'))
        .fontSize($r('app.integer.tabcontentoverflow_tab_font_size'))
        .width($r('app.string.tabcontentoverflow_focus_width'))
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_RECOMMENDATION_TEXT)
        .textAlign(TextAlign.Center)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_SELECTED_TEXT, align: VerticalAlign.Top },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_SELECTED_TEXT, align: HorizontalAlign.End },
        })
        .onClick(() => {
          this.utils.showPromptAction();
        })
      Text($r('app.string.tabcontentoverflow_screeninghall'))
        .fontColor($r('app.color.tabcontentoverflow_font_color'))
        .fontSize($r('app.integer.tabcontentoverflow_tab_font_size'))
        .width($r('app.string.tabcontentoverflow_focus_width'))
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_SCREENINGHALL_TEXT)
        .textAlign(TextAlign.Center)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_RECOMMENDATION_TEXT, align: VerticalAlign.Top },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_RECOMMENDATION_TEXT, align: HorizontalAlign.End },
        })
        .margin({ right: $r('app.integer.tabcontentoverflow_search_image_margin') })
        .onClick(() => {
          this.utils.showPromptAction();
        })
      Divider()
        .width($r('app.integer.tabcontentoverflow_tab_divider_width'))
        .strokeWidth(CONFIGURATION.TABCONTENT_OVERFLOW_TWO)
        .color(Color.White)
        .margin({
          top: $r('app.integer.tabcontentoverflow_divider_margin_top')
        })
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TOPVIEW_DIVIDER)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_SELECTED_TEXT, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_SELECTED_TEXT, align: HorizontalAlign.Center },
        })
        .margin({
          top: $r('app.integer.tabcontentoverflow_top_view_divider_margin_top'),
          left: $r('app.integer.tabcontentoverflow_top_view_divider_margin_left')
        })
      Image($r('app.media.tabcontentoverflow_add'))
        .width($r('app.integer.tabcontentoverflow_search_icon_width'))
        .height($r('app.integer.tabcontentoverflow_search_icon_height'))
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_ADD_IMAGE)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: VerticalAlign.Top },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.End },
        })
        .margin({
          top: $r('app.integer.tabcontentoverflow_search_image_margin'),
          right: $r('app.integer.tabcontentoverflow_search_image_margin')
        })
        .onClick(() => {
          this.utils.showPromptAction();
        })
    }
    .height($r('app.integer.tabcontentoverflow_top_view_relativecontainer_height'))
  }
}
