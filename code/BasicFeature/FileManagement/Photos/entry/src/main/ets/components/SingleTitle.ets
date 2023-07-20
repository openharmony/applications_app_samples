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

// Single line title, fixed content
@Component
export struct SingleTitle {
  private TAG: string = 'SingleTitle';
  @Link actionBarProp: ActionBarProp;

  private onBuildDone(): void {
    Log.info(this.TAG, 'onBuildDone, title: ' + this.actionBarProp.getTitle());
  }

  build() {
    Row() {
      Text(this.actionBarProp.getTitle() as string)
        .fontSize(this.actionBarProp.getIsHeadTitle()
          ? ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE : ActionBarProp.TITLE_TEXT_SIZE)
        .fontWeight(FontWeight.Bold)
        .fontColor(ActionBarProp.NORMAL_TEXT_COLOR)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('80%')
    .alignItems(VerticalAlign.Center)
    .padding({
      left: this.actionBarProp.getLeftAction().equals(Action.NONE) ?
      $r('app.float.default_actionbar_padding_start_without_tab_bar') :
      $r('app.float.actionbar_title_margin')
    })
  }
}