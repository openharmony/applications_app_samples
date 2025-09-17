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
import { curUser, mockData } from '../mock/NewsDetailData';
import { NewsCommentModel } from '../model/NewsCommentModel';
import { CommentPage } from '../components/CommentPage';
import { UIContext } from '@ohos.arkui.UIContext';
import hilog from '@ohos.hilog';
import util from '@ohos.util';
import {
  Row,
  FlexAlign,
  HorizontalAlign,
  Column,
  Stack,
  Alignment,
  Image,
  ImageFit,
  $r,
  Text,
  TextAlign,
  ImageSpan,
  ImageSpanAlignment,
  Span,
  Scroll,
  ScrollState,
  OnScrollFrameBeginHandlerResult,
  OnScrollFrameBeginCallback,
  Scroller,
  ScrollDirection,
  ScrollAlign,
  BarState,
  Search,
  List,
  ListItem,
  ListItemAlign,
  ForEach,
  Blank,
  Color,
  Margin,
  Padding,
  Builder,
  ClickEvent,
  Component,
  Entry,
  TextInput,
  EditableTextOnChangeCallback,
  Button
} from '@ohos.arkui.component';
import { AppStorage, StorageProp, State, MutableState, stateOf, observableProxy } from '@ohos.arkui.stateManagement';

const SEARCH_BUTTON: string = '搜索';

@Entry
@Component
struct MyStateSample {
  listScroller: Scroller = new Scroller();
  scroller: Scroller = new Scroller();
  @State commentList: NewsCommentModel[] = new Array<NewsCommentModel>();
  curUser: string = curUser;
  @State text: string = '';
  @State isVariable: boolean = true;

  aboutToAppear() {
    this.commentList = mockData();
  }

  build() {
    Column() {
      this.title();
      if (this.isVariable) {
        Column() {
          Scroll(this.scroller) {
            Column() {
              this.newsBuilder();
              this.CommentTitle();
              this.listBuilder();
            }
            .width('100%')
          }
          .width('100%')
          .layoutWeight(1)
          .scrollBar(BarState.Off)

          Column() {
            Text($r('app.string.publish_comment'))
              .width('100%')
              .height(40)
              .borderRadius(30)
              .backgroundColor(Color.White)
              .border({ width: 1, color: '#eeeeee' })
              .padding({ left: 15 } as Padding)
              .onClick((e: ClickEvent) => {
                this.isVariable = false;
              })
            PublishView()
          }
          .width('100%')
          .padding({ left: 10, right: 10, top: 10 } as Padding)
          .height(100)
        }
        .height('95%')
        .width('100%')
      } else {
        Row() {
          TextInput({ placeholder: '@', text: this.text })
            .layoutWeight(1)
            .height(40)
            .padding({
              left: 10,
              right: 50,
              top: 3,
              bottom: 3
            } as Padding)
            .onChange((textInComment: string) => {
              this.text = textInComment;
            } as EditableTextOnChangeCallback)

          Button($r('app.string.publish'))
            .width(60)
            .height(30)
            .borderRadius(15)
            .backgroundColor('#ed394b')
            .fontColor('#ffffff')
            .margin({ left: 10 } as Margin)
            .onClick((e: ClickEvent) => {
              if (this.text !== '') {
                const uuid: string = util.generateRandomUUID();
                const comment: NewsCommentModel = new NewsCommentModel(
                  uuid, $r('app.media.news_user_select'), this.curUser, '', '', this.text, '2024-11-01 23:00:00');
                this.commentList = [...this.commentList, comment];
                this.text = '';
                this.isVariable = true;
              }
            })
        }
        .width('100%')
        .padding(10)
        .height(50)
      }
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  title() {
    Row() {
      Stack({ alignContent: Alignment.Bottom }) {
        Image($r('app.media.news_batman'))
          .width(55)
          .height(55)
          .borderRadius(30)
        Text($r('app.string.follow_button'))
          .fontColor('#ff3d36')
          .fontSize(11)
          .borderRadius(3)
          .height(16)
          .width(55)
          .backgroundColor('#ffeeee')
          .textAlign(TextAlign.Center)
      }

      Search({
        placeholder: $r('app.string.search_hint')
      })
        .enableKeyboardOnFocus(false)
        .searchButton(SEARCH_BUTTON)
        .layoutWeight(1)
        .height('75%')
        .backgroundColor('#ffffff')
        .placeholderColor(Color.Grey)
        .placeholderFont({
          size: 14,
          weight: 400
        })
        .margin({ left: 15 } as Margin)
      Row() {
        Text($r('app.string.listen_button'))
          .fontSize(22)
          .margin({ left: 15 } as Margin)
        Image($r('app.media.news_more'))
          .width(30)
          .height(30)
          .margin({ left: 15 } as Margin)
      }
    }
    .width('100%')
    .height(55)
    .padding({ left: 10, right: 10 } as Padding)
  }

  @Builder
  newsBuilder() {
    Column() {
      Text($r('app.string.news_title'))
        .width('100%')
        .fontSize(20)
        .fontWeight(600)
        .margin({ top: 10, bottom: 10 } as Margin)
      Row() {
        Image($r('app.media.bar'))
          .width(40)
          .height(40)
        Column() {
          Text($r('app.string.media_name'))
            .fontSize(14)
          Text($r('app.string.post_info'))
            .fontSize(12)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
        .height('100%')
        .margin({ left: 10 } as Margin)

        Text($r('app.string.follow_button'))
          .fontSize(13)
          .fontColor('#ffffff')
          .backgroundColor('#ff3f3a')
          .borderRadius(3)
          .textAlign(TextAlign.Center)
          .width(50)
          .height(25)
          .margin({ left: 10 } as Margin)
      }
      .width('100%')
      .height(40)
      .margin({ top: 10, bottom: 10 } as Margin)

      Image($r('app.media.ball'))
        .width('100%')
        .objectFit(ImageFit.Contain)
        .borderRadius(6)
        .margin({ top: 10, bottom: 10 } as Margin)
      Text($r('app.string.tabs_content'))
        .fontSize(18)
        .lineHeight(20)
        .margin({ top: 10, bottom: 20 } as Margin)
      Text($r('app.string.disclaimer'))
        .width('100%')
        .fontSize(14)
      Row() {
        Image($r('app.media.icon_circle'))
          .width(40)
          .height(40)
          .margin({ right: 5 } as Margin)
        Text($r('app.string.report_action'))
      }
      .width('100%')
      .margin({ top: 10, bottom: 10 } as Margin)
    }
    .width('100%')
    .padding({ left: 10, right: 10 } as Padding)
  }

  @Builder
  CommentTitle() {
    Row() {
      Text($r('app.string.comment_number'))
        .fontSize(20)
        .fontWeight(700)
      Blank()
      Text($r('app.string.like_share_action'))
        .fontSize(14)
        .fontWeight(700)
    }
    .width('95%')
    .height(30)
  }

  @Builder
  listBuilder() {
    List({ scroller: this.listScroller }) {
      ForEach(this.commentList, (item: NewsCommentModel) => {
        ListItem() {
          CommentPage({ commonData: item })
        }
      }, (item: NewsCommentModel) => item.id)
    }
    .alignListItem(ListItemAlign.Center)
    .scrollBar(BarState.Off)
    .enableScrollInteraction(false)
    .width('100%')
  }
}

@Component
struct PublishView {
  build() {
    Row() {
      Text() {
        ImageSpan($r('app.media.news_share'))
          .width(20)
          .height(20)
          .objectFit(ImageFit.Fill)
          .verticalAlign(ImageSpanAlignment.CENTER)
          .margin({ left: 5, right: 8 } as Margin)
        Span($r('app.string.share_action'))
      }.width('25%')

      Text() {
        ImageSpan($r('app.media.news_comment'))
          .width(20)
          .height(20)
          .objectFit(ImageFit.Fill)
          .verticalAlign(ImageSpanAlignment.CENTER)
          .margin({ left: 5, right: 8 } as Margin)
        Span($r('app.string.comment_action'))
      }.width('25%')

      Text() {
        ImageSpan($r('app.media.news_follow'))
          .width(20)
          .height(20)
          .objectFit(ImageFit.Fill)
          .verticalAlign(ImageSpanAlignment.CENTER)
          .margin({ left: 5, right: 8 } as Margin)
        Span($r('app.string.like_action'))
      }.width('25%')

      Text() {
        ImageSpan($r('app.media.news_star'))
          .width(20)
          .height(20)
          .objectFit(ImageFit.Fill)
          .verticalAlign(ImageSpanAlignment.CENTER)
          .margin({ left: 5, right: 8 } as Margin)
        Span($r('app.string.favorite_action'))
      }.width('25%')
    }
    .width('100%')
    .height(60)
  }
}
