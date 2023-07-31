/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { IntentionCode } from '@ohos.multimodalInput.intentionCode';
import Logger from '../../model/Logger';

@Entry
@Component
struct InteractionNormCapability {
  @State message: Resource = $r('app.string.interaction_norm_capability_tips');

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .focusable(true)
          .fontWeight(FontWeight.Bold)
          .onKeyEvent((event) => {
            Logger.info(`intentionCode: ${event.intentionCode}`)
            switch (event.intentionCode) {
              case IntentionCode.INTENTION_UNKNOWN:
                break;
              case IntentionCode.INTENTION_UP:
                this.message = $r('app.string.up');
                break;
              case IntentionCode.INTENTION_DOWN:
                this.message = $r('app.string.down');
                break;
              case IntentionCode.INTENTION_LEFT:
                this.message = $r('app.string.left');
                break;
              case IntentionCode.INTENTION_RIGHT:
                this.message = $r('app.string.right');
                break;
              case IntentionCode.INTENTION_SELECT:
                this.message = $r('app.string.select');
                break;
              case IntentionCode.INTENTION_ESCAPE:
                this.message = $r('app.string.escape');
                break;
              case IntentionCode.INTENTION_BACK:
                this.message = $r('app.string.back');
                break;
              case IntentionCode.INTENTION_MENU:
                this.message = $r('app.string.menu');
                break;
              case IntentionCode.INTENTION_PAGE_UP:
                this.message = $r('app.string.page_up');
                break;
              case IntentionCode.INTENTION_PAGE_DOWN:
                this.message = $r('app.string.page_down');
                break;
              case IntentionCode.INTENTION_ZOOM_OUT:
                this.message = $r('app.string.zoom_in');
                break;
              case IntentionCode.INTENTION_ZOOM_IN:
                this.message = $r('app.string.zoom_out');
                break;
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}