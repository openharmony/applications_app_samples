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
import {
  Entry,
  Column,
  Component,
  ClickEvent,
  Builder,
  SwiperNestedScrollMode,
  Swiper,
  ForEach,
  Image,
  Resource,
  $r,
  SafeAreaType,
  SafeAreaEdge,
  Scroll,
  Scroller,
  List,
  ListItemAlign,
  BarState,
  ListItem,
  Margin
} from '@ohos.arkui.component';
import { NewsCommentModel } from '../model/NewsCommentModel';
import { CommentPage } from '../components/CommentPage';
import { State } from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';

@Entry
@Component
struct MyStateSample {
  scroller: Scroller = new Scroller();
  @State images: Resource[] = new Array<Resource>();
  @State commentList: NewsCommentModel[] = new Array<NewsCommentModel>();

  aboutToAppear(): void {
    this.images = [
      $r('app.media.custom_reusable_text_expand_img1'),
      $r('app.media.custom_reusable_text_expand_img2'),
      $r('app.media.custom_reusable_text_expand_img3'),
      $r('app.media.custom_reusable_text_expand_img4')
    ];
    this.commentList = [
      new NewsCommentModel(
        '1', $r('app.media.news_user_select'), '你若安好便是晴天', '国足加油！国足必胜！', '昨天23:24·杭州'),
      new NewsCommentModel(
        '2', $r('app.media.news_user_select'), '天要下雨娘要嫁人', '来点信心，加油加油~', '昨天23:24·杭州'),
      new NewsCommentModel(
        '3', $r('app.media.news_user_select'), '太阳打北边出来了', '下一场什么时候，有直播吗', '昨天23:24·杭州'),
      new NewsCommentModel(
        '4', $r('app.media.news_user_select'), '西红柿炒鸡蛋卷', '教练组的战术调整值得肯定，尤其是在中场控制方面有所改善。', '昨天23:24·杭州'),
      new NewsCommentModel(
        '5', $r('app.media.news_user_select'), '东边有个塔玛，西边有个喇嘛', '期待他们在未来的比赛中继续进步！', '昨天23:24·杭州'),
      new NewsCommentModel(
        '6', $r('app.media.news_user_select'), '等烟雨而我在等你', '希望接下来的比赛中继续发挥，成为球队的中坚力量。', '昨天23:24·杭州'),
      new NewsCommentModel(
        '7', $r('app.media.news_user_select'), '大事不妙了', '与世界强队的差距依然显著，继续努力吧。', '昨天23:24·杭州'),
      new NewsCommentModel(
        '8', $r('app.media.news_user_select'), '小猫带耳机', '国足必胜，加油加油。', '昨天23:24·杭州')
    ];
  }

  build() {
    Column() {
      Column() {
        Swiper() {
          ForEach(this.images, (item: Resource, index: number) => {
            Image(item)
              .width('100%')
              .height('100%')
              .padding(5)
              .borderRadius(5)
          },(item: Resource, index: number) => index.toString())
        }
        .loop(true)
        .width('100%')
        .height(200)

        List() {
          ForEach(this.commentList, (item: NewsCommentModel) => {
            ListItem() {
              CommentPage({ commonData: item })
            }.margin({ top: 8 } as Margin)
          }, (item: NewsCommentModel) => item.id)
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}