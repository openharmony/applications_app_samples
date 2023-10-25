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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import { ArgumentsControlPanel, PropertyControlPanel } from './SideBarContainerControlPanel';

@Extend(Column) function backgroundStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(16)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.SpaceAround)
}

@Extend(Text) function contentTextStyle() {
  .fontSize(20)
  .fontWeight(900)
  .textAlign(TextAlign.Start)
}

@Extend(Text) function sidebarTextStyle() {
  .fontSize(25)
  .fontColor($r('app.color.font_color_red'))
}

@Entry
@Component
struct SideBarContainerSample {
  @State sbcType: SideBarContainerType = SideBarContainerType.Overlay;
  @State isShowSidebar: boolean = false;
  @State leftMargin: number = 16;
  @State topMargin: number = 16;
  @State isShowButton: boolean = true;
  @State sidebarPosition: SideBarPosition = SideBarPosition.Start;
  @State minWidth: number = 100;
  @State maxWidth: number = 300;
  @State isAutoHidden: boolean = true;
  @State state: boolean = true;

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      TitleBar({ title: $r('app.string.sidebarcontainer_title') })
      IntroductionTitle({ introduction: $r('app.string.sidebarcontainer_drag_divider') })
      // 展示区
        Column() {
          SideBarContainer(this.sbcType) {
            // 侧边栏
            Column({ space: 20 }) {
              Button() {
                Text($r('app.string.sidebarcontainer_sidebar_text_one'))
                  .sidebarTextStyle()
              }
              Button() {
                Text($r('app.string.sidebarcontainer_sidebar_text_two'))
                  .sidebarTextStyle()
              }
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .backgroundColor($r('app.color.background_light_gray'))
            // 内容区
            Column() {
              Scroll(){
                Text(this.state == true ? $r('app.string.sidebarcontainer__is_show_true') : $r('app.string.sidebarcontainer__is_show_false'))
                  .contentTextStyle()
                  .textAlign(TextAlign.Center)
                  .fontColor($r('app.color.font_color_red'))
              }
              .scrollable(ScrollDirection.Vertical)
              .height("100%")
              .width('100%')
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          }
          .showSideBar(this.isShowSidebar)
          .controlButton({
            left: this.leftMargin,
            top: this.topMargin,
            icons: { shown: $r('app.media.ic_down_arrow'), hidden: $r('app.media.ic_right_arrow') }
          })
          .showControlButton(this.isShowButton)
          .sideBarPosition(this.sidebarPosition)
          .sideBarWidth(200)
          .minSideBarWidth(this.minWidth)
          .maxSideBarWidth(this.maxWidth)
          .autoHide(this.isAutoHidden)
          .onChange((bool) => {
            this.state = bool;
          })
        }
        .backgroundStyle()
        .height(400)

      // 控制面板
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.sidebarcontainer_argument') })
          Column() {
            ArgumentsControlPanel({ type: $sbcType })
          }
          .backgroundStyle()

          IntroductionTitle({ introduction: $r('app.string.sidebarcontainer_property') })
          Column() {
            PropertyControlPanel({
              isShowSidebar: $isShowSidebar,
              leftMargin: $leftMargin,
              topMargin: $topMargin,
              isShowButton: $isShowButton,
              sidebarPosition: $sidebarPosition,
              minWidth: $minWidth,
              maxWidth: $maxWidth,
              isAutoHidden: $isAutoHidden
            })
          }
          .justifyContent(FlexAlign.Start)
          .width('100%')
          .backgroundStyle()
        }
        .width('100%')
      }
      .id('sideBar_scroll_001')
      .width('100%')
      .layoutWeight(1)
      .padding({ bottom: 30 })
    }
    .width('100%')
    .height('100%')
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}
