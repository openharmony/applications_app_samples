/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

// DEFAULT_COLOR 默认字体颜色
// BACKGROUND_COLOR 默认背景色
// TITLE_BACKGROUND title背景色
// STATUS_COLOR 状态栏字体颜色
// CATEGORIES_BACKGROUND_COLOR title下边的导航字体颜色
// nav_* 导航图片
// NAV_SELECTED_COLOR 导航选中字体颜色
// MAIN_BACKGROUND_COLOR 主体背景色
// 自定义主题
export class CustomTheme {
  static DEFAULT_COLOR = $r('app.color.white')
  static BACKGROUND_COLOR = $r('app.color.custom_main_color')
  static TITLE_BACKGROUND = $r('app.color.custom_main_color')
  static STATUS_COLOR = $r('app.color.custom_status_color')
  static CATEGORIES_BACKGROUND_COLOR = $r('app.color.custom_main_color')
  static NAV_HOME = $r('app.media.nav_home_light')
  static NAV_PRODUCT = $r('app.media.nav_product_light')
  static NAV_CART = $r('app.media.nav_cart_light')
  static NAV_ME = $r('app.media.nav_me_light')
  static NAV_SELECTED_COLOR = $r('app.color.custom_status_color')
  static MAIN_BACKGROUND_COLOR = $r('app.color.custom_background_color')
}

// 系统主题 包括 深浅模式 通过dark目录实现
export class DefaultTheme {
  static DEFAULT_COLOR = $r('app.color.default_color')
  static BACKGROUND_COLOR = $r('app.color.default_bg_color')
  static TITLE_BACKGROUND = $r('app.color.title_bg_color')
  static STATUS_COLOR = $r('app.color.status_color')
  static CATEGORIES_BACKGROUND_COLOR = $r('app.color.top_nav_bg_color')
  static NAV_HOME = $r('app.media.nav_home')
  static NAV_PRODUCT = $r('app.media.nav_product')
  static NAV_CART = $r('app.media.nav_cart')
  static NAV_ME = $r('app.media.nav_me')
  static NAV_SELECTED_COLOR = Color.Red
  static MAIN_BACKGROUND_COLOR = $r('app.color.main_bg_color')
}
