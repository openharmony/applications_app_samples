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

import { ActionBarProp } from '../common/ActionBarProp';
import { Action } from '../models/Action';
import { ActionBarButton } from './ActionBarButton';

// Large picture button for dynamic refresh
@Component
export struct DetailMenuPanel {
  @Link actionBarProp: ActionBarProp;
  onMenuClicked: Function | null = null;

  build() {
    Row() {
      ForEach(this.actionBarProp.getMenuList(), (menu: Action): void => {
        ActionBarButton({
          res: menu.iconRes,
          action: menu,
          onMenuClicked: (action: Action): void => this.onMenuClicked?.(action),
          isAutoTint: menu.isAutoTint,
          colorMode: this.actionBarProp.getColorMode()
        }).id(menu.actionID.toString())
      }, (menu: Action): string => { return JSON.stringify(menu.actionID) })
    }.alignItems(VerticalAlign.Center)
  }
}