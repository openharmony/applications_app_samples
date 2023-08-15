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

import { ActionBarColorMode, ActionBarSelectionMode } from '../models/ActionBarMode';
import { Log } from '../utils/Log';
import { ActionBarProp } from '../common/ActionBarProp';

// Select the mode title, the content changes with the number of selections
@Component
export struct SelectionTitle {
  private TAG: string = 'SelectionTitle';
  @Link actionBarProp: ActionBarProp;
  @Consume('selectedCount') count: number;

  private onBuildDone(): void {
    Log.info(this.TAG, 'onBuildDone, count: ' + this.count);
  }

  build() {
    Row() {
      Text((this.actionBarProp.getSelectionMode() === ActionBarSelectionMode.MULTI ?
        (this.count === 0 ? ActionBarProp.MULTI_UNSELECT_TITLE :
          (this.actionBarProp.getMaxSelectCount() > 0 ?
          ActionBarProp.getCountDetailExternalSelectedTitle(this.count,
          this.actionBarProp.getMaxSelectCount()) :
          ActionBarProp.getCountDetailSelectedTitle(this.count))) :
        ActionBarProp.SINGLE_UNSELECT_TITLE))
        .fontSize(ActionBarProp.TITLE_TEXT_SIZE)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.actionBarProp.getColorMode() === ActionBarColorMode.TRANSPARENT ?
          ActionBarProp.TRANSPARENT_TEXT_COLOR : ActionBarProp.NORMAL_TEXT_COLOR)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .margin({ left: $r('app.float.actionbar_title_margin'),
      right: $r('app.float.actionbar_title_margin') })
    .alignItems(VerticalAlign.Center)
  }
}