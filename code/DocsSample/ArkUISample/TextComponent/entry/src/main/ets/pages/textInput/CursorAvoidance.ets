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

import { ComponentCard } from '../../common/Card';

// [Start cursor_avoid]
@Entry
@Component
export struct CursorAvoidance {
  @State caretPosition: number = 600;
  areaController: TextAreaController = new TextAreaController();
  text = 'Most of us compare ourselves with anyone we think is happier — a relative, someone we know a lot,' +
    ' or someone we hardly know. As a result, what we do remember is anything that makes others happy, ' +
    'anything that makes ourselves unhappy,' +
    ' totally forgetting that there is something happy in our own life.\
    So the best way to destroy happiness is to look at something and focus on even the smallest flaw. ' +
    'It is the smallest flaw that would make us complain. And it is the complaint that leads to us becoming unhappy.\
    If one chooses to be happy, he will be blessed; if he chooses to be unhappy, he will be cursed. ' +
    'Happiness is just what you think will make you happy.' +
    'Most of us compare ourselves with anyone we think is happier — a relative, someone we know a lot, ' +
    'or someone we hardly know. As a result, what we do remember is anything that makes others happy, ' +
    'anything that makes ourselves unhappy, totally forgetting that there is something happy in our own life.\
  ';
  //  : string = getResourceString($r('app.string.CursorAvoidance_Button_1'));
  @State str1 : string = getContext(this).resourceManager.getStringSync($r('app.string.CursorAvoidance_Button_1'));
  @State str2 : string = getContext(this).resourceManager.getStringSync($r('app.string.CursorAvoidance_Button_2'));

  build() {
    NavDestination() {
      ComponentCard({ title: $r('app.string.CursorAvoidance_title') }) {
        Scroll() {
          Column() {
            Row() {

              Button(this.str1 + this.caretPosition).onClick(() => {
                this.caretPosition += 1;
              }).fontSize(10)
              Button(this.str2 + this.caretPosition).onClick(() => {
                this.caretPosition -= 1;
              }).fontSize(10)
              Button($r('app.string.CursorAvoidance_Button_3')).onClick(() => {
                this.areaController.caretPosition(this.caretPosition);
              }).fontSize(10)
            }

            TextArea({ text: this.text, controller: this.areaController })
              .width('100%')
              .fontSize('20fp')
          }
        }.width('100%').height('100%')
      }
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CursorAvoidance_title'))
  }
}
// [End cursor_avoid]