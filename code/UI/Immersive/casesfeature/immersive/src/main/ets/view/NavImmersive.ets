/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { promptAction } from '@kit.ArkUI';
import { WebImmersive } from '../../../../Index';
import { GoodsList } from '../components/GoodsList';
import { GoodsDetails } from './GoodsDetails';

/**
 * 功能描述：开发应用沉浸式效果主要指通过调整状态栏、应用界面和导航条的显示效果来减少状态栏导航条等系统界面的突兀感，从而使用户获得最佳的UI体验。
 *         本模块分别针对Navigation、滚动、Web页、底部弹框等场景实现了沉浸式适配。
 *
 * 核心组件:
 * 1. NavImmersive: Navigation场景沉浸式适配和滚动场景沉浸式适配
 * 2. WebImmersive: Web场景沉浸式适配
 * 3. ImmersiveDialog: 底部弹框沉浸式适配
 *
 * 实现步骤:
 * 1. 通过组件属性expandSafeArea设置需要沉浸式的组件绘制延伸至状态栏和导航条
 * 2. 使用NavImmersive组件展示Navigation场景沉浸式和滚动场景沉浸式
 * 3. 使用WebImmersive组件展示Web场景沉浸式
 * 4. 使用ImmersiveDialog展示底部弹框场景沉浸式
 */
const COLUM_SPACE: number = 10; // 各组件间的间隔
const IMAGE_ASPECT_RATIO: number = 1; // 图片的宽高比
const LAYOUT_WEIGHT: number = 1; // 自适应占满父容器Column剩余空间
const OPACITY: number = 0.6; // 字体设置透明度

@Component
export struct NavImmersive {
  @Provide navPathStack: NavPathStack = new NavPathStack();
  @StorageLink('avoidAreaTopToModule') avoidAreaTop: number = 0;

  @Builder
  pageMap(name: string) {
    NavDestination() {
      if (name === 'goodsDetail') {
        GoodsDetails()
      } else if (name === 'WebImmersive') {
        WebImmersive()
      }
    }
    .hideTitleBar(true)
  }

  build() {
    Column() {
      Navigation(this.navPathStack) {
        Column({ space: COLUM_SPACE }) {

          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Image($r('app.media.immersive_logo'))
              .width($r('app.integer.immersive_image_width'))
              .aspectRatio(IMAGE_ASPECT_RATIO)

            Image($r('app.media.immersive_scan'))
              .width($r('app.integer.immersive_image_width'))
              .aspectRatio(IMAGE_ASPECT_RATIO)
              .onClick(() => {
                promptAction.showToast({ message: $r('app.string.immersive_mode_other_function') });
              })
          }
          .width('100%')
          .height($r('app.integer.immersive_flex_height'))
          .margin({ top: $r('app.integer.immersive_flex_margin_top') })

          Row() {
            Image($r('app.media.immersive_search'))
              .width($r('app.integer.immersive_search_image_width'))
              .aspectRatio(IMAGE_ASPECT_RATIO)
              .margin({ left: $r('app.integer.immersive_search_image_margin_left') })

            Text($r('app.string.immersive_search_text'))
              .opacity(OPACITY)
              .fontColor($r('app.color.immersive_black_font_color'))
              .margin({ left: $r('app.integer.immersive_text_margin_left') })
          }
          .width('100%')
          .height($r('app.integer.immersive_row_height'))
          .backgroundColor($r('app.color.immersive_search_bg_color'))
          .borderRadius($r('app.integer.immersive_row_border_radius'))
          .onClick(() => {
            promptAction.showToast({ message: $r('app.string.immersive_mode_other_function') });
          })

        }
        .padding({
          top: px2vp(this.avoidAreaTop),
          left: $r('app.integer.immersive_column_padding'),
          right: $r('app.integer.immersive_column_padding'),
          bottom: $r('app.integer.immersive_column_padding')
        })
        .backgroundColor($r('app.color.immersive_column_bg_color'))
        .width('100%')
        // 设置顶部绘制延伸至状态栏
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

        Scroll() {
          Column() {
            Column() {
              Image($r('app.media.immersive_light_mode_banner'))
                .width('100%')
                .height($r('app.integer.immersive_banner_height'))
                .borderRadius($r('app.integer.immersive_banner_border_radius'))
                .id('banner')
                .onClick(() => {
                  this.navPathStack.pushPathByName('WebImmersive', false);
                })

              Text($r('app.string.immersive_new_product_text'))
                .fontColor($r('app.color.immersive_white_font_color'))
                .fontSize($r('app.integer.immersive_new_goods_font'))
                .fontWeight(FontWeight.Bold)
                .height($r('app.integer.immersive_new_goods_height'))
                .width('100%')
                .textAlign(TextAlign.Center)
                .padding({ top: $r('app.integer.immersive_ew_goods_padding_top') })
            }
            .backgroundColor($r('app.color.immersive_column_bg_color'))
            .padding({
              left: $r('app.integer.immersive_column_padding'),
              right: $r('app.integer.immersive_column_padding')
            })
            .borderRadius({
              bottomLeft: $r('app.integer.immersive_column_border_radius'),
              bottomRight: $r('app.integer.immersive_column_border_radius')
            })

            // 引用产品列表组件
            GoodsList()
          }
        }
        .backgroundColor($r('app.color.immersive_list_bg_color'))
        .padding({ bottom: $r('app.integer.immersive_column_padding_bottom') })
        .width('100%')
        .layoutWeight(LAYOUT_WEIGHT)
        .scrollBar(BarState.Off)
        .align(Alignment.Top)
        // 将底部绘制延伸至导航条
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      }
      .hideTitleBar(true)
      .navDestination(this.pageMap)
      .width('100%')
      .height('100%')
      .mode(NavigationMode.Stack)
    }.width('100%')
    .height('100%')
  }
}