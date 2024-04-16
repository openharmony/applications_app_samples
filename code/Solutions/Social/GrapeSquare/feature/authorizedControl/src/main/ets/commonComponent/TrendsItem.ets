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

import image from '@ohos.multimedia.image';
import { ContentsType, Trends, UserInfo } from '../model/BaseMsg';
import { SaveControl } from '../authorizedControl/SaveControl';
import { promptActionFn } from '../model/DataFactory';
import Constants from '../utils/Constants';

@Component
export struct TrendsItem {
  // 是否显示保存按钮
  @State isVisible: boolean = true;
  @State isShowSaveButton: boolean = false;
  // 多组图片下被选中的图片Index
  @State seletedImageIndex: number = -1;
  // 初始化PixelMap
  @State pixMapObject: image.PixelMap = {} as image.PixelMap;
  @StorageLink('currentBreakpoint') currentBreakpoint: string = 'sm';
  // 初始化动态信息
  private trendsItemData: Trends = new Trends(new UserInfo(0, $r('app.media.photo115'), '', '', ''), new ContentsType('', [], []), '', 0, 0, 0) as Trends;
  // 初始化是否是动态详情页面
  private isDetailPage: boolean = false;

  /**
   * 自定义组件 点赞 评论 分享
   * @param image 图片url count 数量
   */
  @Builder
  ButtonComp(image: Resource, count: number) {
    Row() {
      Image(image)
        .width($r('app.integer.layout_size_22'))
        .height($r('app.integer.layout_size_22'))
        .opacity($r('app.float.icon'))
        .objectFit(ImageFit.Contain)
      if (count) {
        Text(this.handleCount(count))
          .fontColor($r('app.color.font_color_datetime'))
          .fontSize($r('app.integer.layout_size_16'))
          .margin({ left: $r('app.integer.layout_size_4') })
      }
    }
    .id('comp')
    .onClick(() => {
      promptActionFn($r('app.string.feature_development'))
    })
  }

  /**
   * 加载聊天列表数据，到参数传入的懒加载数据列表中
   * @param count 数值
   */
  handleCount(count: number) {
    if (count > Constants.UNIT_10000) {
      // toFiexed(1)代表取小数点后一位
      return `${(count / Constants.UNIT_10000).toFixed(1)}w`;
    } else if (count > Constants.UNIT_1000 && count < Constants.UNIT_10000) {
      return `${(count / Constants.UNIT_1000).toFixed(1)}k`;
    } else {
      return count.toString()
    }
  }

  build() {
    Column() {
      Row() {
        Row() {
          Image(this.trendsItemData.user.userImage)
            .width($r('app.integer.layout_size_52'))
            .height($r('app.integer.layout_size_52'))
            .borderRadius($r('app.integer.layout_size_26'))
          Column() {
            Text(this.trendsItemData.user.userName)
              .fontSize($r('app.integer.layout_size_21'))
              .fontFamily('HarmonyHeiTi-Medium')
            Text(this.trendsItemData.user.userType)
              .fontSize($r('app.integer.layout_size_18'))
              .fontColor($r('app.color.font_color_datetime'))
              .margin({ top: $r('app.integer.layout_size_3') })
          }
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)
          .margin({ left: $r('app.integer.layout_size_10') })
        }

        Button() {
          Text($r('app.string.add_care'))
            .fontSize($r('app.integer.layout_size_16'))
            .fontColor($r('app.color.font_color_D94838'))
        }
        .backgroundColor('rgba(243, 236, 236, 0.50)')
        .width($r('app.integer.layout_size_96'))
        .height($r('app.integer.layout_size_37'))
        .borderRadius($r('app.integer.layout_size_18'))
        .onClick(() => {
          promptActionFn($r('app.string.feature_development'))
        })
      }.width('100%').justifyContent(FlexAlign.SpaceBetween)

      Column() {
        Text(this.trendsItemData.contents.text)
          .fontSize($r('app.integer.layout_size_18'))
          .margin({ top: $r('app.integer.layout_size_11'), bottom: $r('app.integer.layout_size_11') })
          .id('textDetail')
        if (this.trendsItemData.contents.imageList.length === 0) {
          // 媒体视频
          Stack({ alignContent: Alignment.Center }) {
            Image($r('app.media.photo120'))
              .draggable(false)
              .width($r('app.integer.layout_size_224'))
              .height($r('app.integer.layout_size_224'))
              .borderRadius($r('app.integer.layout_size_20'))
              .gesture(LongPressGesture({ repeat: true })
                .onAction((event?: GestureEvent) => {
                  if (!this.isDetailPage) {
                    return;
                  }
                  this.isShowSaveButton = true;
                }))
            Image($r('app.media.play'))
              .width($r('app.integer.layout_size_54'))
              .height($r('app.integer.layout_size_54'))
            if (this.isShowSaveButton) {
              SaveControl({ mediaUri: this.trendsItemData.contents.media[0], isShowSaveButton: $isShowSaveButton })
            }
          }
        } else if (this.trendsItemData.contents.imageList.length === 1) {
          // 单张图
          Stack({ alignContent: Alignment.Center }) {
            Image(this.trendsItemData.contents.imageList[0])
              .draggable(false)
              .width($r('app.integer.layout_size_245'))
              .height($r('app.integer.layout_size_150'))
              .borderRadius($r('app.integer.layout_size_20'))
              .gesture(LongPressGesture({ repeat: true })
                .onAction((event?: GestureEvent) => {
                  if (!this.isDetailPage) {
                    return;
                  }
                  this.isShowSaveButton = true;
                }))
            if (this.isShowSaveButton) {
              SaveControl({ imageUri: this.trendsItemData.contents.imageList[0], isShowSaveButton: $isShowSaveButton })
            }
          }
        } else {
          // 多列图
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
            ForEach(this.trendsItemData.contents.imageList, (image: Resource, index: number) => {
              Stack() {
                Image(image)
                  .draggable(false)
                  .width(this.currentBreakpoint === 'sm' ? $r('app.integer.layout_size_134') : $r('app.integer.layout_size_144'))
                  .height(this.currentBreakpoint === 'sm' ? $r('app.integer.layout_size_134') : $r('app.integer.layout_size_144'))
                  .margin({ top: $r('app.integer.layout_size_8') })
                  .borderRadius($r('app.integer.layout_size_16'))
                  .gesture(LongPressGesture({ repeat: true })
                    .onAction((event?: GestureEvent) => {
                      if (!this.isDetailPage) {
                        return;
                      }
                      this.seletedImageIndex = index;
                      this.isShowSaveButton = true;
                    }))
                if (this.isShowSaveButton && this.seletedImageIndex === index) {
                  SaveControl({ imageUri: image, isShowSaveButton: $isShowSaveButton })
                }
              }
            })
          }
          .width('100%')
        }
      }.width('100%').alignItems(HorizontalAlign.Start)

      if (this.isVisible) {
        Row() {
          this.ButtonComp($r('app.media.ic_share'), this.trendsItemData.shareCount);
          this.ButtonComp($r('app.media.ic_message'), this.trendsItemData.commentCount);
          this.ButtonComp($r('app.media.ic_thumbsup'), this.trendsItemData.likeCount);
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
        .margin({ top: $r('app.integer.layout_size_20') })
      }

    }.backgroundColor(Color.White)
    .border({
      width: { bottom: Constants.BORDERWIDTH },
      color: { bottom: $r('app.color.border_color') },
    })
    .padding({ top: $r('app.integer.layout_size_21'), bottom: $r('app.integer.layout_size_21') })
  }
}