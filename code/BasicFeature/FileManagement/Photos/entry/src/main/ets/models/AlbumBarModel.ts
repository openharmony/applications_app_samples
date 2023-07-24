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

import { Action } from './Action'
import { ActionBarProp } from '../common/ActionBarProp'
import { ActionBarMode, ActionBarSelectionMode } from './ActionBarMode'
import { screenManager } from '../common/ScreenManager'

export class AlbumBarModel {
  createActionBar(isAlbumSetSelectedMode: boolean, selectedAlbumsCount: number,
                  isDisableRename: boolean, isDisableDelete: boolean): ActionBarProp {
    let actionBarProp: ActionBarProp = new ActionBarProp();
    let isHorizontal = screenManager.isHorizontal();
    if (isHorizontal) {
      this.updateHorizontalActionBar(actionBarProp, isAlbumSetSelectedMode,
        selectedAlbumsCount, isDisableRename, isDisableDelete);
    } else {
      this.updateVerticalActionBar(actionBarProp, isAlbumSetSelectedMode);
    }
    return actionBarProp;
  }

  updateActionBar(actionBarProp: ActionBarProp, isAlbumSetSelectedMode: boolean,
                  selectedAlbumsCount: number, isDisableRename: boolean, isDisableDelete: boolean): void {
    let isHorizontal = screenManager.isHorizontal();
    if (isHorizontal) {
      this.updateHorizontalActionBar(actionBarProp, isAlbumSetSelectedMode,
        selectedAlbumsCount, isDisableRename, isDisableDelete);
    } else {
      this.updateVerticalActionBar(actionBarProp, isAlbumSetSelectedMode);
    }
  }

  private updateHorizontalActionBar(actionBarProp: ActionBarProp, isAlbumSetSelectedMode: boolean, selectedAlbumsCount: number,
                                    isDisableRename: boolean, isDisableDelete: boolean): ActionBarProp {
    let isSidebar: boolean = screenManager.isSidebar();
    actionBarProp
      .setHasTabBar(isSidebar)
      .setTitle($r('app.string.tab_albums'))
      .setIsHeadTitle(true);
    let menuList: Action[] = this.getMenuList(isAlbumSetSelectedMode, selectedAlbumsCount, isDisableRename, isDisableDelete);
    if (isAlbumSetSelectedMode) {
      actionBarProp
        .setLeftAction(Action.CANCEL)
        .setMenuList(menuList)
        .setMode(ActionBarMode.SELECTION_MODE)
        .setSelectionMode(ActionBarSelectionMode.MULTI);
    } else {
      menuList.push(Action.NEW)
      actionBarProp
        .setMenuList(menuList)
        .setMode(ActionBarMode.STANDARD_MODE);
    }
    return actionBarProp;
  }

  private updateVerticalActionBar(actionBarProp: ActionBarProp, isAlbumSetSelectedMode: boolean): ActionBarProp {
    let menuList: Action[] = [];
    menuList.push(Action.NEW);
    let isSidebar: boolean = screenManager.isSidebar();
    actionBarProp
      .setHasTabBar(isSidebar)
      .setTitle($r('app.string.tab_albums'))
      .setIsHeadTitle(true);

    if (isAlbumSetSelectedMode) {
      actionBarProp
        .setLeftAction(Action.CANCEL)
        .setMode(ActionBarMode.SELECTION_MODE)
        .setSelectionMode(ActionBarSelectionMode.MULTI);
    } else {
      actionBarProp
        .setMenuList(menuList)
        .setMode(ActionBarMode.STANDARD_MODE);
    }

    return actionBarProp;
  }

  getMenuList(isAlbumSetSelectedMode: boolean, selectedAlbumsCount: number, isDisableRename: boolean, isDisableDelete: boolean): Action[] {
    let menuList: Action[] = [];
    if (isAlbumSetSelectedMode) {
      menuList.push((!isDisableRename && selectedAlbumsCount === 1) ? Action.RENAME : Action.RENAME_INVALID);
      menuList.push((!isDisableDelete && selectedAlbumsCount > 0) ? Action.DELETE : Action.DELETE_INVALID);
    }
    return menuList;
  }
}
