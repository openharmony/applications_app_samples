/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Eventproject]';
const DOMAIN = 0xF811;
const BUNDLE = 'Eventproject_';
// [Start key_event_intercept]
@Entry
@Component
export struct OnKeyPreImeCommit {
  @State content: string = '';
  @State text: string = '';
  controller: TextAreaController = new TextAreaController();

  build() {
    // [StartExclude key_event_intercept]
    NavDestination() {
      Column({ space: 12 }) {
        // [EndExclude key_event_intercept]
        Column() {
          Text('Submissions: ' + this.content)
          TextArea({ controller: this.controller, text: this.text })
            .onKeyPreIme((event: KeyEvent) => {
              hilog.info(DOMAIN, TAG, BUNDLE + JSON.stringify(event));
              if (event.keyCode === 2054 && event.type === KeyType.Down) { // 回车键物理码
                const hasCtrl = event?.getModifierKeyState?.(['Ctrl']);
                if (hasCtrl) {
                  hilog.info(DOMAIN, TAG, BUNDLE + 'Line break');
                } else {
                  hilog.info(DOMAIN, TAG, BUNDLE + 'Submissions：' + this.text);
                  this.content = this.text;
                  this.text = '';
                  event.stopPropagation();
                }
                return true;
              }
              return false;
            })
            .onChange((value: string) => {
              this.text = value
            })
        }
        // [StartExclude key_event_intercept]
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.OnKeyPreImeCommit_title'))
    // [EndExclude key_event_intercept]
  }
}
// [End key_event_intercept]