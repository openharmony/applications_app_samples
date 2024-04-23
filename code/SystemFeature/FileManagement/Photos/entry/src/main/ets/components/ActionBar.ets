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

import { Log } from '../utils/Log';
import { ActionBarProp } from '../common/ActionBarProp';
import { Action } from '../models/Action';
import { ActionBarMode } from '../models/ActionBarMode';
import { SingleTitle } from './SingleTitle';
import { DetailTitle } from './DetailTitle';
import { SelectionTitle } from './SelectionTitle';
import { DetailMenuPanel } from './DetailMenuPanel';
import { Constants } from '../constants/Constants';
import { ActionBarButton } from './ActionBarButton';

const TAG: string = 'ActionBar';

// ActionBar，It consists of action on the left, title in the middle and menu panel on the right
@Component
export struct ActionBar {
  @Link actionBarProp: ActionBarProp;
  onMenuClicked: Function | undefined = undefined;
  isVideoPage: boolean = false;
  @State hasTabBar: boolean = false;

  private onBuildDone(): void {
    Log.info(TAG, 'onBuildDone,actionBarProp:' + this.actionBarProp.getHasTabBar());
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.hasTabBar = this.actionBarProp.getHasTabBar();
  }

  createArray(): ActionBarProp[] {
    let actionBarProp: ActionBarProp[] = [];
    actionBarProp.push(this.actionBarProp);
    return actionBarProp;
  }

  build() {
    Row() {
      if (!this.actionBarProp.getLeftAction().equals(Action.NONE)) {
        ForEach(this.createArray(), (item: ActionBarProp): void => {
          ActionBarButton({
            res: item.getLeftAction().iconRes,
            action: item.getLeftAction(),
            onMenuClicked: (action: Action): void => this.onMenuClicked?.(action),
            isAutoTint: item.getLeftAction().isAutoTint,
            colorMode: item.getColorMode(),
            isFirst: true
          }).id('leftButton')
        }, (item: ActionBarProp): string => {return item.getLeftAction().actionID.toString()})
      }
      if (this.actionBarProp.getMode() === ActionBarMode.DETAIL_MODE) {
      } else if (this.actionBarProp.getMode() === ActionBarMode.SELECTION_MODE) {
        Stack({ alignContent: Alignment.Start }) {
          SelectionTitle({ actionBarProp: $actionBarProp })
        }.flexGrow(1)
      } else if (this.actionBarProp.getMode() === ActionBarMode.TOP_MODE) {
        Stack({ alignContent: Alignment.Start }) {
          DetailTitle({ isVideoPage: this.isVideoPage })
        }.flexGrow(1)
      } else {
        Stack({ alignContent: Alignment.Start }) {
          SingleTitle({ actionBarProp: $actionBarProp })
        }.flexGrow(1)
      }
      DetailMenuPanel({ actionBarProp: $actionBarProp, onMenuClicked: (action: Action): void => this.onMenuClicked?.(action) })
    }
    .margin({ top: $r('app.float.actionbar_margin_horizontal') })
    .height(Constants.ActionBarHeight)
    .alignItems(VerticalAlign.Center)
    .zIndex(3)
    .width('100%')
    .backgroundColor(this.actionBarProp.getBackgroundColor())
    .opacity(this.actionBarProp.getAlpha())
    .padding({ right: $r('app.float.default_actionbar_padding_right'),
      left: (this.hasTabBar ?
      $r('app.float.default_padding_start_with_tab_bar') :
      $r('app.float.default_actionbar_padding_start_without_tab_bar'))
    })
  }
}
