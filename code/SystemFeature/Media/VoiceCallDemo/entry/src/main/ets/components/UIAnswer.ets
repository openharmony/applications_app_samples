/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Caller from '../bean/Caller';
import IndexController from '../controller/IndexController';
import ComponentVoiceBg from '../components/ComponentVoiceBg';
import ComponentOption from '../components/ComponentOption';

/**
 * 被呼叫页
 * 提示语不同，头像相同
 * 按钮group： 拒绝,接听
 */
@Component
export default struct UIAnswer {
  private controller: IndexController | null = null;
  @Link mRemote: Caller;
  @State use: boolean = true;

  build() {
    Column() {
      ComponentVoiceBg({ tips: $r('app.string.tips_answer'), mPerson: $mRemote }) {
        Row() {
          //拒绝
          ComponentOption({
            btnId: 'option_hangup',
            use: $use,
            useResource: $r('app.media.icon_openvalley_hangup'),
            unUseResource: $r('app.media.icon_openvalley_hangup'),
            useBgColorResource: $r('app.color.color_red'),
            canChange: () => {
              return false;
            },
            callback: (use: boolean) => {
              if (this.controller == null) {
                return;
              }
              this.controller.hangUp();
            }
          })

          //接受
          ComponentOption({
            btnId: 'option_answer',
            use: $use,
            useResource: $r('app.media.icon_openvalley_call'),
            unUseResource: $r('app.media.icon_openvalley_call'),
            useBgColorResource: $r('app.color.color_green'),
            canChange: () => {
              return false;
            },
            callback: (use: boolean) => {
              if (this.controller == null) {
                return;
              }
              this.controller.answer();
            }
          })
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}