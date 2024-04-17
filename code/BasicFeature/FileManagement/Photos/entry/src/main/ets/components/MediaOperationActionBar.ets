/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Action } from '../models/Action';
import { ActionBar } from './ActionBar';
import { ActionBarProp } from '../common/ActionBarProp';
import { ActionBarMode } from '../models/ActionBarMode';
import { screenManager } from '../common/ScreenManager';
import { MediaOperationType } from '../models/MediaOperationType';

@Component
export struct MediaOperationActionBar {
  @Consume pageType: string;
  @Consume @Watch('updateActionBar') loadingFinish: boolean;
  onMenuClicked: Function | undefined = undefined;
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @State actionBarProp: ActionBarProp = new ActionBarProp();

  updateActionBar(): void {
    this.actionBarProp = this.createActionBar();
  }

  private createActionBar(): ActionBarProp {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setHasTabBar(false)
      .setTitle((this.pageType === MediaOperationType.Move) ? $r('app.string.move_to') : $r('app.string.copy_to'))
      .setMode(ActionBarMode.STANDARD_MODE)
      .setMenuList(menuList)
      .setLeftAction(Action.CANCEL);
    return actionBarProp;
  }

  aboutToAppear(): void {
    this.actionBarProp = this.createActionBar();
  }

  build() {
    Column() {
      ActionBar({
        actionBarProp: $actionBarProp,
        onMenuClicked: (action: Action): void => this.onMenuClicked?.(action)
      })
    }
  }
}
