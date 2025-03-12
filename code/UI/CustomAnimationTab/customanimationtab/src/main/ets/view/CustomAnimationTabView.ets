/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { BaseInterface } from '../model/BaseInterface';
import { baseBuilder } from './BasePage';
import { CustomAnimationTabController } from '../model/CustomAniamtionTabController';
import { CustomAnimationTabConfigure } from './CustomAnimationTabConfigure'
import { dyEffectBuilder } from './DyEffectPage';
import { IndicatorBarAttribute } from '../model/IndicatorBarAttribute';
import { nativeBuilder } from './NativePage';
import { otherBuilder } from './OtherPage';
import { thirdPartyBuilder } from './ThirdPartyPage';
import { TabBarItemInterface } from '../model/TabBarItemInterface';
import { TabBarAttribute } from '../model/TabBarAttribute';
import { TabInfo } from '../model/TabInfo';
import { uiBuilder } from './UIPage';
import { MyAnimationAttribute } from './MyAnimationAttribute';
import { SizeMode } from '../model/SizeMode';
import { CustomAnimationTab } from '../utils/CustomAnimationTab';
import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';

/**
 * 功能说明: 本示例介绍使用List、Text等组件，以及animateTo等接口实现自定义Tab效果
 *
 * 推荐场景: 需要自定义动效的tab场景
 *
 * 核心组件:
 * 1. CustomAnimationTab: 自定义动效tab构建组件
 * 2. AnimationAttribute: 动效属性，可通过继承扩展动效属性
 * 3. TabInfo: 设置TabBar的标题、TabContent以及TabBar样式的类
 * 4. CustomAnimationTabController: 自定义动效Tab控制器，用于控制自定义动效Tab组件进行页签切换
 * 5. IndicatorBarAttribute: 设置背景条属性
 * 6. TabBarAttribute: 设置页签条属性
 * 7. Scroller: 页签条滚动控制器
 *
 * 实现步骤:
 * 1. 数据准备: 首先构建一个TabInfo数组，然后向其中传入对应的内容
 * @example
 * this.tabsInfo = [
 new TabInfo(CustomAnimationTabConfigure.DEFAULT_BASE_TAB, wrapBuilder(baseBuilder), wrapBuilder(tabBar)),
 new TabInfo(CustomAnimationTabConfigure.DEFAULT_UI_TAB, wrapBuilder(uiBuilder), wrapBuilder(tabBar)),
 new TabInfo(CustomAnimationTabConfigure.DEFAULT_DYEFFECT_TAB, wrapBuilder(dyEffectBuilder), wrapBuilder(tabBar)),
 new TabInfo(CustomAnimationTabConfigure.DEFAULT_THIRTYPARTY_TAB, wrapBuilder(thirdPartyBuilder),
 wrapBuilder(tabBar)),
 new TabInfo(CustomAnimationTabConfigure.DEFAULT_NATIVE_TAB, wrapBuilder(nativeBuilder), wrapBuilder(tabBar)),
 new TabInfo(CustomAnimationTabConfigure.DEFAULT_OTHER_TAB, wrapBuilder(otherBuilder), wrapBuilder(tabBar))
 ]
 * 2. 动效属性准备: 创建动效属性AnimationAttribute对象，可以通过继承添加额外动效属性
 * @example
 * @State animationAttribute: MyAnimationAttribute = new MyAnimationAttribute(
 *    CustomAnimationTabConfigure.INDICATOR_WIDTH, $r('app.color.custom_animation_tab_indicator_color'));
 * 3. 背景条配置: 背景条可以自行new IndicatorBarAttribute配置，也可以使用已有的背景条配置（目前支持两种:
 *    IndicatorBarAttribute.BACKGROUNDBAR和IndicatorBarAttribute.THINSTRIP）
 * @example
 * indicatorBarAttribute: IndicatorBarAttribute = new IndicatorBarAttribute(this.indicatorBar);
 * 4. 页签条配置
 * @example
 * tabBarAttribute: TabBarAttribute = new TabBarAttribute(CustomAnimationTabConfigure.LIST_ITEM_WIDTH);
 * 5. 自定义动效tab控制器配置
 * @example
 * tabController: CustomAnimationTabController = new CustomAnimationTabController();
 * 6. 页签条滑动配置
 * @example
 * scroller: Scroller = new Scroller();
 * 7. 构建自定义动效tab
 * @example
 * CustomAnimationTab({
     animationAttribute: this.animationAttribute,
     tabsInfo: this.tabsInfo,
     indicatorBarAttribute: this.indicatorBarAttribute,
     tabBarAttribute: this.tabBarAttribute,
     tabController: this.tabController,
     scroller: this.scroller
   })
 */
@Builder
function testBuilder() {
  Column() {
  }
  .height('100%')
  .width('100%')
  .backgroundColor(Color.Gray)
}

@Component
export struct CustomAnimationTabView {
  // 自定义动效属性，添加了背景条颜色变化
  @State animationAttribute: MyAnimationAttribute =
    new MyAnimationAttribute($r('app.color.custom_animation_tab_indicator_color'));
  // tab数据
  tabsInfo: TabInfo[] = [];
  // tabController
  tabController: CustomAnimationTabController = new CustomAnimationTabController();
  // indicatorBar
  indicatorBarAttribute: IndicatorBarAttribute = new IndicatorBarAttribute(this.indicatorBar, SizeMode.Normal, 0, 0,
    CustomAnimationTabConfigure.INDICATOR_MAX_LEFT, CustomAnimationTabConfigure.DEFAULT_INDICATOR_EXPAND);
  // tabBar
  tabBarAttribute: TabBarAttribute =
    new TabBarAttribute(CustomAnimationTabConfigure.LIST_ITEM_WIDTH, CustomAnimationTabConfigure.TABBAR_HEIGHT,
      true, EdgeEffect.Spring, BarPosition.Start);
  // scroller
  scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.tabsInfo = [
      new TabInfo(CustomAnimationTabConfigure.DEFAULT_BASE_TAB, wrapBuilder(baseBuilder), wrapBuilder(tabBar)),
      new TabInfo(CustomAnimationTabConfigure.DEFAULT_UI_TAB, wrapBuilder(uiBuilder), wrapBuilder(tabBar)),
      new TabInfo(CustomAnimationTabConfigure.DEFAULT_DYEFFECT_TAB, wrapBuilder(dyEffectBuilder), wrapBuilder(tabBar)),
      new TabInfo(CustomAnimationTabConfigure.DEFAULT_THIRTYPARTY_TAB, wrapBuilder(thirdPartyBuilder),
        wrapBuilder(tabBar)),
      new TabInfo(CustomAnimationTabConfigure.DEFAULT_NATIVE_TAB, wrapBuilder(nativeBuilder), wrapBuilder(tabBar)),
      new TabInfo(CustomAnimationTabConfigure.DEFAULT_OTHER_TAB, wrapBuilder(otherBuilder), wrapBuilder(tabBar))
    ]
  }

  build() {
    RelativeContainer() {
      this.body();
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  body() {
    Column() {
      /**
       * 构建自定义动效Tab
       * indicatorBarAttribute: 背景条属性
       * tabsInfo: tab数据源
       * tabBarAttribute: 页签条属性
       * animationAttribute: 动效属性
       * tabController: 自定义动效tab控制器
       * scroller: 页签条滚动控制器
       */
      CustomAnimationTab({
        animationAttribute: this.animationAttribute,
        tabsInfo: this.tabsInfo,
        indicatorBarAttribute: this.indicatorBarAttribute,
        tabBarAttribute: this.tabBarAttribute,
        tabController: this.tabController,
        scroller: this.scroller
      })
        .height($r('app.string.custom_animation_tab_ninety_percent'))
      // 更新自定义动效变量——背景条颜色
      Column() {
        Button($r('app.string.custom_animation_tab_button_text'))
          .height($r('app.string.custom_animation_tab_sixty_percent'))
          .onClick(() => {
            if ((this.animationAttribute.indicatorBarColor as Resource).id ===
            $r('app.color.custom_animation_tab_indicator_color').id) {
              this.animationAttribute.indicatorBarColor = Color.Yellow;
            } else if (this.animationAttribute.indicatorBarColor === Color.Yellow) {
              this.animationAttribute.indicatorBarColor = $r('app.color.custom_animation_tab_indicator_color');
            }
          })
      }
      .justifyContent(FlexAlign.Center)
      .height($r('app.string.custom_animation_tab_ten_percent'))
      .width($r('app.string.custom_animation_tab_one_hundred_percent'))
    }
    .height($r('app.string.custom_animation_tab_one_hundred_percent'))
    .width($r('app.string.custom_animation_tab_one_hundred_percent'))
  }

  @Builder
  indicatorBar($$: BaseInterface) {
    Column()
      .height($r('app.string.custom_animation_tab_one_hundred_percent'))
      .width($r('app.string.custom_animation_tab_one_hundred_percent'))// 绑定自定义动效属性
      .backgroundColor(this.animationAttribute.indicatorBarColor)
      .borderRadius($r('app.float.custom_animation_tab_indicator_border_radius'))
  }
}

// tabBar样式
@Builder
function tabBar($$: TabBarItemInterface) {
  Column() {
    Image($r('app.media.return_home_fill'))
      .height(20)
      .width(20)
      .objectFit(ImageFit.Contain)
    Text($$.title)
      .fontSize($$.curIndex === $$.index ? $r('app.float.custom_animation_tab_list_select_font_size') :
      $r('app.float.custom_animation_tab_list_unselect_font_size'))
      .fontColor($r('app.color.custom_animation_tab_list_font_color'))
      .fontWeight($$.curIndex === $$.index ? FontWeight.Bold : FontWeight.Medium)
      .textAlign(TextAlign.Center)
  }
}