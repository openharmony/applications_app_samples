/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { Constants } from '../common/Constants';
import { EventUtil } from '../common/EventUtil';
import Logger from '../common/Logger';
import { ThirdSelectPhotoGridBase } from './components/ThirdSelectPhotoGridBase';

let localStorage = LocalStorage.getShared();
const TAG = 'ThirdSelectPhotoGridPage';

@Entry(localStorage)
@Component
struct ThirdSelectPhotoGridPage {
  @State isFirstEnter: boolean = false;
  @State pageStatus: boolean = false;

  onPageShow() {
    this.pageStatus = true;
  }

  onPageHide() {
    this.pageStatus = false;
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.Pop, duration: 300 })
      .opacity(1)
    PageTransitionExit({ type: RouteType.Push, duration: 300 })
      .opacity(1)
  }

  build() {
    Column() {
      ThirdSelectPhotoGridBase({
        pageStatus: this.pageStatus,
        isFirstEnter: this.isFirstEnter
      })
        .transition({ type: TransitionType.All, opacity: 0 })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.main_color'))
    .onTouch((event) => {
      if (event.type === TouchType.Down) {
        EventUtil.inputTab();
      }
      if (!EventUtil.isTouchEvent(event)) {
        return;
      }
      if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== Constants.SOURCE_TOOL_MOUSE_CLICK) {
        return;
      }
    })
  }
}