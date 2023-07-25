/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { Action } from '../models/Action'
import { ActionBarMode, ActionBarColorMode, ActionBarSelectionMode } from '../models/ActionBarMode'

// ActionBarProp
export class ActionBarProp {
  public static NORMAL_BACKGROUND_COLOR: Resource = $r('app.color.default_background_color');
  public static TRANSPARENT_BACKGROUND_COLOR: Resource = $r('app.color.transparent');
  public static NORMAL_TEXT_COLOR: Resource = $r('sys.color.ohos_id_color_titlebar_text');
  public static NORMAL_SUBTITLE_TEXT_COLOR: Resource = $r('sys.color.ohos_id_color_titlebar_subtitle_text');
  public static ICON_COLOR: Resource = $r('sys.color.ohos_id_color_primary');
  public static TRANSPARENT_TEXT_COLOR: Resource = $r('app.color.title_text_color_on_transparent_bg');
  public static TRANSPARENT_SUBTITLE_TEXT_COLOR: Resource = $r('app.color.subtitle_text_color_on_transparent_bg');
  public static HEAD_TITLE_TEXT_SIZE: Resource = $r('sys.float.ohos_id_text_size_headline6');
  public static HEAD_TITLE_ONE_LINE_TEXT_SIZE: Resource = $r('sys.float.ohos_id_text_size_headline7');
  public static TITLE_TEXT_SIZE: Resource = $r('sys.float.ohos_id_text_size_headline8');
  public static TITLE_FONT_WEIGHT = 500;
  public static SUBTITLE_TEXT_SIZE: Resource = $r('sys.float.ohos_id_text_size_body2');
  public static MEDIUM_FONT: Resource = $r('app.string.id_text_font_family_medium');
  public static REGULAR_FONT: Resource = $r('app.string.id_text_font_family_regular');
  public static SINGLE_UNSELECT_TITLE: Resource = $r('app.string.title_select_photos');
  public static SINGLE_SELECT_ALBUM_TITLE: Resource = $r('app.string.title_select_album');
  public static MULTI_UNSELECT_TITLE: Resource = $r('app.string.title_none_selected');
  public static PHOTO_BROWSER_ACTIONBAR_ALPHA = 0.95;
  private hasTabBar = false;
  private leftAction = Action.NONE;
  private isHeadTitle = false;
  private title: Object = null;
  private subTitle: Object = null;
  private menuList: Action[] = [];
  private backgroundColor: Resource = ActionBarProp.NORMAL_BACKGROUND_COLOR;
  private alpha = 1;
  private selectionMode: ActionBarSelectionMode = ActionBarSelectionMode.MULTI;
  private colorMode: ActionBarColorMode = ActionBarColorMode.NORMAL;
  private mode: ActionBarMode = ActionBarMode.STANDARD_MODE;
  private maxSelectCount = 0;

  constructor() {
  }

  public static getCountDetailSelectedTitle(count: number): Resource {
    return $r('app.plural.count_details_selected', count, count);
  }

  /**
   * External selection quantity display
   * @param count The selected quantity, same as the current count above
   * @param maxSelectCount Maximum number of options
   */
  public static getCountDetailExternalSelectedTitle(count: number, maxSelectCount: number): Resource {
    return $r('app.string.count_details_external_selected', count, maxSelectCount);
  }

  public setHasTabBar(hasTabBar: boolean): ActionBarProp {
    this.hasTabBar = hasTabBar;
    return this;
  }

  public getHasTabBar(): boolean {
    return this.hasTabBar;
  }

  public setLeftAction(leftAction: Action): ActionBarProp {
    this.leftAction = leftAction;
    return this;
  }

  public getLeftAction(): Action {
    return this.leftAction;
  }

  public setIsHeadTitle(isHeadTitle: boolean): ActionBarProp {
    this.isHeadTitle = isHeadTitle;
    return this;
  }

  public getIsHeadTitle(): boolean {
    return this.isHeadTitle;
  }

  public setTitle(title: Object): ActionBarProp {
    this.title = title;
    return this;
  }

  public getTitle(): Object {
    return this.title;
  }

  public setSubTitle(subTitle: Object): ActionBarProp {
    this.subTitle = subTitle;
    return this;
  }

  public getSubTitle(): Object {
    return this.subTitle;
  }

  public setMenuList(menuList: Action[]): ActionBarProp {
    this.menuList = menuList;
    return this;
  }

  public getMenuList(): Action[] {
    return this.menuList;
  }

  public setBackgroundColor(backgroundColor: Resource): ActionBarProp {
    this.backgroundColor = backgroundColor;
    return this;
  }

  public getBackgroundColor(): Resource {
    return this.colorMode === ActionBarColorMode.TRANSPARENT
      ? ActionBarProp.TRANSPARENT_BACKGROUND_COLOR : this.backgroundColor;
  }

  public setAlpha(alpha: number): ActionBarProp {
    this.alpha = alpha;
    return this;
  }

  public getAlpha(): number {
    return this.alpha;
  }

  public setMode(mode: ActionBarMode): ActionBarProp {
    this.mode = mode;
    return this;
  }

  public getMode(): ActionBarMode {
    return this.mode;
  }

  public setColorMode(colorMode: ActionBarColorMode): ActionBarProp {
    this.colorMode = colorMode;
    return this;
  }

  public getColorMode(): ActionBarColorMode {
    return this.colorMode;
  }

  public setSelectionMode(selectionMode: ActionBarSelectionMode): ActionBarProp {
    this.selectionMode = selectionMode;
    return this;
  }

  public getSelectionMode(): ActionBarSelectionMode {
    return this.selectionMode;
  }

  public setMaxSelectCount(maxSelectCount: number): ActionBarProp {
    this.maxSelectCount = maxSelectCount;
    return this;
  }

  public getMaxSelectCount(): number {
    return this.maxSelectCount;
  }
}