'use static';
/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { memo, __memo_context_type, __memo_id_type } from '@ohos.arkui.stateManagement';
import { Text, TextAttribute, Column, Component, Button, ButtonAttribute, ClickEvent,
  VerticalAlign, HorizontalAlign,FlexAlign, Color, Padding, Margin, Builder, Row, $r, Length
} from '@ohos.arkui.component';
import { State, MutableState, stateOf, observableProxy } from '@ohos.arkui.stateManagement';

@Component
export struct SkeletonLayout {
  isMine: boolean = false;

  build() {
    Row() {
      Column() {
        Column() {
          // 标题
          textArea($r('app.float.custom_animation_tab_ske_card_title_height'))

          Text('').height(4)

          // 内容
          textArea($r('app.float.custom_animation_tab_ske_card_text_height'))
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        // 判断是否自己作品来适配不同骨架布局
        if (!this.isMine) {
          Row() {
            // 浏览量
            actionArea()
            // 点赞数
            actionArea()
            // 收藏量
            actionArea()
          }
          .padding({ top: $r('app.float.custom_animation_tab_ske_md_padding_margin') } as Padding)
          .height($r('app.float.custom_animation_tab_ske_row_height'))
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        } else {
          Row() {
            // 摄影作品标签
            Row()
              .width('58vp')
              .height($r('app.float.custom_animation_tab_ske_topic_height'))
              .backgroundColor($r('app.color.custom_animation_tab_skeleton_color_medium'))
              .borderRadius($r('app.float.custom_animation_tab_ske_xs_border_radius'))
              .margin({ bottom: 12 } as Margin)
            // 自然风光标签
            Row()
              .width($r('app.float.custom_animation_tab_ske_lg_topic_width'))
              .height($r('app.float.custom_animation_tab_ske_topic_height'))
              .backgroundColor($r('app.color.custom_animation_tab_skeleton_color_medium'))
              .borderRadius($r('app.float.custom_animation_tab_ske_xs_border_radius'))
          }
          .padding({ top: $r('app.float.custom_animation_tab_ske_md_padding_margin') } as Padding)
          .height($r('app.float.custom_animation_tab_ske_row_height'))
          .width('100%')
          .justifyContent(FlexAlign.Start)
        }
      }
      .layoutWeight(1)
      .height('100%')
      Row()
        .backgroundColor($r('app.color.custom_animation_tab_skeleton_color_light'))
        .borderRadius($r('app.float.custom_animation_tab_ske_small_border_radius'))
        .width('128vp')
        .height($r('app.float.custom_animation_tab_ske_image_height'))
        .margin({ left: $r('app.float.custom_animation_tab_ske_md_padding_margin') } as Margin)
    }
    .padding($r('app.float.custom_animation_tab_ske_md_padding_margin'))
    .borderRadius($r('app.float.custom_animation_tab_ske_large_border_radius'))
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.SpaceAround)
    .width('100%')
    .height($r('app.float.custom_animation_tab_ske_card_height'))
  }
}

@Builder
function actionArea() {
  Row()
    .width('58vp')
    .height($r('app.float.custom_animation_tab_ske_action_area_height'))
    .backgroundColor($r('app.color.custom_animation_tab_skeleton_color_medium'))
}

@Builder
function textArea(height: Length) {
  Row()
    .width('100%')
    .height(height)
    .backgroundColor($r('app.color.custom_animation_tab_skeleton_color_medium'))
}