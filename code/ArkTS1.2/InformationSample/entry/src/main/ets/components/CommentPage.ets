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

import { NewsCommentModel } from '../model/NewsCommentModel';
import {
  Date,
  Column,
  Row,
  VerticalAlign,
  HorizontalAlign,
  Image,
  $r,
  Text,
  Span,
  ImageFit,
  Blank,
  Margin,
  Padding,
  Component
} from '@ohos.arkui.component';
import { State, MutableState, stateOf, observableProxy } from '@ohos.arkui.stateManagement';

@Component
export struct CommentPage {
  commonData: NewsCommentModel = new NewsCommentModel('', '', '', '', '');

  build() {
    Column() {
      Row() {
        Image(this.commonData.url)
          .objectFit(ImageFit.Contain)
          .width(30)
          .height(30)
          .borderRadius(30)
          .margin({ top: 10, left: 15 } as Margin)
        Column() {
          Text() {
            Span(this.commonData.user)
              .fontSize(14)
              .fontWeight(500)
              .fontColor('#000000')
          }
          .width('80%')
          .margin({ bottom: 6 } as Margin)
          Text(this.commonData.text)
            .fontSize(14)
            .fontWeight(400)
            .opacity(0.8)
            .fontColor('#000000')
            .lineHeight(20)
            .width('80%')
            .margin({ bottom: 6 } as Margin)
          Row() {
            Text(this.commonData.commentTime)
              .fontSize(14)
              .fontWeight(400)
              .fontColor('#A9A9A9')
              .margin({ right: 10 } as Margin)
          }
          .width('85%')
        }
        .padding({ left: 12, top: 10 } as Padding)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
  }
}