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

import { Action } from '../models/Action'
import { ActionBarColorMode } from '../models/ActionBarMode'

@Component
export struct ToolBarButton {
  @State res: Resource | undefined = undefined;
  action: Action = Action.NONE;
  isLeft: boolean = true;
  isAutoTint: boolean = true;
  colorMode: ActionBarColorMode = ActionBarColorMode.NORMAL;

  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      if (this.isAutoTint) {
        Image(this.res)
          .commonButtonStyle()
          .fillColor(this.colorMode === ActionBarColorMode.TRANSPARENT
            ? Action.ICON_DEFAULT_COLOR_CONTRARY : this.action.fillColor)
      } else {
        Image(this.res)
          .commonButtonStyle()
      }
    }
    .height($r('app.float.icon_size'))
    .width($r('app.float.icon_size'))
  }
}

@Extend(Image) function commonButtonStyle () {
  .height($r('app.float.icon_size'))
  .width($r('app.float.icon_size'))
}