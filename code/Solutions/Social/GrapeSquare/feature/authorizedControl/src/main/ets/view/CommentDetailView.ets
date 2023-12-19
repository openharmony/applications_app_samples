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

import router from '@ohos.router';
import { TrendsItem } from '../commonComponent/TrendsItem';
import { CommentData } from '../model/TrendsDataSource';
import { makeCommentDataLocal, promptActionFn } from '../model/DataFactory';
import { Trends, UserInfo, ContentsType } from '../model/BaseMsg';
import { PasteControl } from '../authorizedControl/PasteControl';
import Constants from '../utils/Constants';

@Component
export struct CommentDetailView {
  // 初始化输入框value值
  @State textInputValue: string = '';
  @State isSelectionMenuHidden: boolean = false;
  // 初始化是否显示复制粘贴文本选择器
  @State isTextInputShow: boolean = false;
  // 初始化键盘高度
  @StorageLink('keyboardHeight') keyboardHeight: number = 0;
  // 评论数据属性
  @Provide commentDataSource: CommentData = new CommentData();
  // 获取动态信息
  private trendsItemData: Trends = (router.getParams() as Record<string, Object>)['trendsData'] as Trends;
  // Scroll控制器
  private scroller: Scroller = new Scroller();
  // 输入框控制器
  private controller: TextInputController = new TextInputController();

  /**
   * 自定义组件 评论 点赞
   * @param image 图片路径 text 文本内容 featureIndex 下标
   */
  @Builder
  FeatureBuilder(image: Resource, text: Resource, featureIndex: number) {
    Column() {
      Image(image)
        .width($r('app.integer.layout_size_28'))
        .height($r('app.integer.layout_size_28'))
        .objectFit(ImageFit.Contain)
      Text(text)
        .fontSize($r('app.integer.layout_size_12'))
        .id('commentButton')
    }
    .justifyContent(FlexAlign.Center)
    .height(56)
    .onClick(() => {
      if (featureIndex !== 1) {
        promptActionFn($r('app.string.feature_development'));
        return;
      }
      this.isTextInputShow = true;
    })
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Flex({ direction: FlexDirection.Column }) {
        // 标题
        TitleBar()
        Scroll(this.scroller) {
          Column() {
            // 动态详情信息
            TrendsItem({ trendsItemData: this.trendsItemData, isDetailPage: true, isVisible: false })
              .width('90%')
            // 评论区
            CommentArea()
          }
        }
      }.width('100%')
      .height('100%')

      // 输入框
      if (this.isTextInputShow) {
        Row() {
          if (this.isSelectionMenuHidden) {
            PasteControl({ isSelectionMenuHidden: $isSelectionMenuHidden, textInputValue: $textInputValue })
          }

          Image(this.trendsItemData.user.userImage)
            .width($r('app.integer.layout_size_40'))
            .height($r('app.integer.layout_size_40'))
            .borderRadius($r('app.integer.layout_size_20'))
          TextInput({
            text: this.textInputValue,
            placeholder: $r('app.string.add_comment'),
            controller: this.controller
          })
            .id('comment_add')
            .placeholderFont({ size: 14, weight: 400 })
            .backgroundColor(Color.White)
            .selectionMenuHidden(true)
            .enterKeyType(EnterKeyType.Send)
            .width($r('app.integer.layout_size_400'))
            .height($r('app.integer.layout_size_40'))
            .fontSize($r('app.integer.layout_size_14'))
            .fontColor(Color.Black)
            .onChange((value: string) => {
              this.textInputValue = value;
            })
            .onSubmit(async () => {
              this.trendsItemData.contents.text = this.textInputValue;
              this.trendsItemData.likeCount = 0;
              this.commentDataSource.pushData(this.trendsItemData);
              this.textInputValue = '';
              this.isTextInputShow = false;
            })
            .gesture(LongPressGesture({ repeat: true, duration: 300 })
              .onAction((event?: GestureEvent) => {
                this.isSelectionMenuHidden = true;
              }))

        }.width('100%')
        .backgroundColor(Color.White)
        .padding($r('app.integer.layout_size_10'))
        .border({
          width: { top: Constants.BORDERWIDTH },
          color: '#fffffbfb',
        })
      } else {
        Column() {
          Divider()
            .vertical(false)
            .strokeWidth('1')
            .color($r('app.color.font_color_182431'))
            .opacity(0.15)
          Row() {
            this.FeatureBuilder($r('app.media.ic_share'), $r('app.string.share'), Constants.TAB_INDEX_0)
            this.FeatureBuilder($r('app.media.ic_message'), $r('app.string.comment'), Constants.TAB_INDEX_1)
            this.FeatureBuilder($r('app.media.ic_thumbsup'), $r('app.string.like'), Constants.TAB_INDEX_2)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)
          .alignItems(VerticalAlign.Center)
          .backgroundColor('#F1F3F5')
        }

      }
    }.padding({ bottom: px2vp((this.keyboardHeight)) })
    .expandSafeArea([SafeAreaType.KEYBOARD])
  }
}

@Component
struct TitleBar {
  build() {
    Row(){
      Row() {
        Image($r('app.media.ic_public_back'))
          .id('backBtn')
          .width($r('app.integer.layout_size_24'))
          .height($r('app.integer.layout_size_24'))
          .onClick(() => {
            router.back();
          })
        Row() {
          Image($r('app.media.ic_collect'))
            .width($r('app.integer.layout_size_24'))
            .height($r('app.integer.layout_size_24'))
            .onClick(() => {
              promptActionFn($r('app.string.feature_development'))
            })
          Image($r('app.media.ic_public_more'))
            .width($r('app.integer.layout_size_24'))
            .height($r('app.integer.layout_size_24'))
            .margin({ left: $r('app.integer.layout_size_24') })
            .onClick(() => {
              promptActionFn($r('app.string.feature_development'))
            })
        }
        .padding({ right: $r('app.integer.layout_size_12') })
      }
      .width('90%')
      .padding({ left: $r('app.integer.layout_size_12') })
      .margin({ top: $r('app.integer.layout_size_12'), bottom: $r('app.integer.layout_size_11') })
      .height($r('app.integer.layout_size_33'))
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')


  }
}

@Component
struct CommentArea {
  @State currentTabIndex: number = 1;
  @Consume commentDataSource: CommentData;

  async aboutToAppear() {
    await makeCommentDataLocal(this.commentDataSource);
  }

  // 设置tabBar样式的位置、未选中图片、选中图片及文字显示的参数
  @Builder
  TabBuilder(text: Resource, index: number) {
    Column() {
      Text(text)
        .fontSize($r('app.integer.layout_size_21'))
        .fontColor(this.currentTabIndex === index ? $r('app.color.font_color_blue') : $r('app.color.font_color_datetime'))
        .padding({ top: $r('app.integer.layout_size_10'), bottom: $r('app.integer.layout_size_10') })
        .border({
          width: { bottom: this.currentTabIndex === index ? $r('app.integer.layout_size_4') : 0 },
          color: { bottom: $r('app.color.font_color_blue') },
          radius: { bottomLeft: $r('app.integer.layout_size_2'), bottomRight: $r('app.integer.layout_size_2') }
        })
    }.margin({ right: $r('app.integer.layout_size_20') })
  }

  build() {
    Column() {
      Row() {
        Row() {
          this.TabBuilder($r('app.string.share_count'), Constants.TAB_INDEX_0)
          this.TabBuilder($r('app.string.comment_count'), Constants.TAB_INDEX_1)
        }

        Row() {
          Text($r('app.string.like_count'))
            .fontSize($r('app.integer.layout_size_21'))
            .fontColor($r('app.color.font_color_datetime'))
        }
      }
      .height(56)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Row() {
          Image($r('app.media.sequence'))
            .width($r('app.integer.layout_size_21'))
            .height($r('app.integer.layout_size_21'))
            .margin({ right: $r('app.integer.layout_size_12') })
          Text($r('app.string.hot'))
            .fontFamily('HarmonyHeiTi-Medium')
            .fontSize($r('app.integer.layout_size_16'))
            .fontColor($r('app.color.font_color_blue'))
        }
      }.width('100%')
      .margin({ top: $r('app.integer.layout_size_10'), bottom: $r('app.integer.layout_size_10') })
      .justifyContent(FlexAlign.End)
      .onClick(() => {
        promptActionFn($r('app.string.feature_development'));
      })

      List() {
        LazyForEach(this.commentDataSource, (item: Trends, index: number) => {
          ListItem() {
            CommentItem({ commentsData: item, itemIndex: index })
          }
        }, (item: Trends) => JSON.stringify(item))
      }.cachedCount(4)
      .width('100%')
    }.padding({ left: $r('app.integer.layout_size_20'), right: $r('app.integer.layout_size_20') })

  }
}

@Component
struct CommentItem {
  // 初始化断点
  @StorageLink('currentBreakpoint') currentBreakpoint: string = 'sm';
  // 初始化评论数据
  private commentsData: Trends = new Trends(new UserInfo(0, $r('app.media.photo115'), '', '', ''), new ContentsType('', [], []), '', 0, 0, 0) as Trends;
  private itemIndex: number = 0;

  /**
   * 加载聊天列表数据，到参数传入的懒加载数据列表中
   * @param count 数值
   */
  handleCount(count: number) {
    if (count > Constants.UNIT_10000) {
      return `${(count / Constants.UNIT_10000).toFixed(1)}w`;
    } else if (count > Constants.UNIT_1000 && count < Constants.UNIT_10000) {
      return `${(count / Constants.UNIT_1000).toFixed(1)}k`;
    } else {
      return count.toString()
    }
  }

  build() {
    Row() {
      Row() {
        Image(this.commentsData.user.userImage)
          .width($r('app.integer.layout_size_42'))
          .height($r('app.integer.layout_size_42'))
          .borderRadius($r('app.integer.layout_size_21'))
        Column() {
          Row() {
            Text(this.commentsData.user.userName)
              .fontSize($r('app.integer.layout_size_18'))
              .fontFamily('HarmonyHeiTi-Medium')
              .width(this.currentBreakpoint === 'sm' ? $r('app.integer.layout_size_236') : $r('app.integer.layout_size_260'))
            Row() {
              Image($r('app.media.ic_thumbsup'))
                .opacity($r('app.float.icon'))
                .width($r('app.integer.layout_size_28'))
                .height($r('app.integer.layout_size_26'))
                .margin({ left: $r('app.integer.layout_size_10') })
                .onClick(() => {
                  promptActionFn($r('app.string.feature_development'))
                })
              Text(this.handleCount(this.commentsData.likeCount))
                .margin({ right: $r('app.integer.layout_size_24') })
                .width($r('app.integer.layout_size_38'))
                .textAlign(TextAlign.Center)
                .opacity($r('app.float.opacity'))
              Image($r('app.media.ic_share'))
                .opacity($r('app.float.icon'))
                .width($r('app.integer.layout_size_24'))
                .height($r('app.integer.layout_size_24'))
                .margin({ right: $r('app.integer.layout_size_2') })
                .onClick(() => {
                  promptActionFn($r('app.string.feature_development'))
                })
            }.width($r('app.integer.layout_size_122')).alignItems(VerticalAlign.Center)
          }

          Row() {
            Text(this.commentsData.dateTime)
              .fontSize($r('app.integer.layout_size_16'))
              .fontColor($r('app.color.font_color_datetime'))

            Text(this.commentsData.user.userType)
              .fontSize($r('app.integer.layout_size_16'))
              .fontColor($r('app.color.font_color_datetime'))
              .margin({ left: $r('app.integer.layout_size_6') })
          }
          .margin({ top: $r('app.integer.layout_size_6') })

          Text(this.commentsData.contents.text)
            .fontSize($r('app.integer.layout_size_21'))
            .fontFamily('HarmonyHeiTi')
            .margin({ top: $r('app.integer.layout_size_6') })
          if (this.itemIndex === 1) {
            Text($r('app.string.comments'))
              .opacity($r('app.float.opacity'))
              .width('100%')
              .height($r('app.integer.layout_size_42'))
              .fontFamily('HarmonyHeiTi')
              .backgroundColor('#fff5f5f5')
              .borderRadius($r('app.integer.layout_size_6'))
              .padding({ left: $r('app.integer.layout_size_16') })
              .margin({ top: $r('app.integer.layout_size_12') })
          }
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
        .margin({ left: $r('app.integer.layout_size_10') })
        .padding({ bottom: $r('app.integer.layout_size_16') })
        .border({
          width: { bottom: Constants.BORDERWIDTH },
          color: { bottom: $r('app.color.border_color') },
        })
      }.alignItems(VerticalAlign.Top)
    }.width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: $r('app.integer.layout_size_10'), bottom: $r('app.integer.layout_size_10') })
  }
}
