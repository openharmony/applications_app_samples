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

@Entry
@Component
export struct TextInputAddEvent {
  @State eventText: ResourceStr = $r('app.string.TextInputAddEvent_textContent_1');
  @State inputValue: ResourceStr = $r('app.string.TextInputAddEvent_textContent_2');
  controller: TextInputController = new TextInputController();
  passwordState: boolean = false;

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.TextInputAddEvent_title_1') }) {
          Column({ space: 8 }) {
            Text(this.eventText)
            Text(this.inputValue)
            // [Start add_text_input_event]
            TextInput({
              text: $r('app.string.TextInputAddEvent_textContent_2'),
              placeholder: 'input your word...',
              controller: this.controller
            })
              .type(InputType.Password)
              .showPassword(this.passwordState)
              .onChange((value: string) => {
                // 文本内容发生变化时触发该回调
                this.inputValue = 'onChange is triggering: ' + value;
              })
              .onSubmit((enterKey: EnterKeyType, event: SubmitEvent) => {
                // 按下输入法回车键时触发该回调
                this.eventText = 'onSubmit is triggering: ' + enterKey + ' ' + event.text;
              })
              .onTextSelectionChange((selectionStart: number, selectionEnd: number) => {
                // 文本选择的位置发生变化或编辑状态下光标位置发生变化时，触发该回调
                this.eventText = 'onTextSelectionChange is triggering: ' + selectionStart + ' ' + selectionEnd;
              })
              .onSecurityStateChange((isShowPassword: boolean) => {
                // 密码显隐状态切换时，触发该回调
                this.eventText = 'onSecurityStateChange is triggering: ' + isShowPassword
                this.passwordState = isShowPassword;
              })
              .onWillInsert((info: InsertValue) => {
                // 在将要输入时，触发该回调
                this.eventText = 'onWillInsert is triggering: ' + info.insertValue + ' ' + info.insertOffset;
                return true;
              })
              .onDidInsert((info: InsertValue) => {
                // 在输入完成时，触发该回调
                this.eventText = 'onDidInsert is triggering: ' + info.insertValue + ' ' + info.insertOffset
              })
              .onWillDelete((info: DeleteValue) => {
                // 在将要删除时，触发该回调
                this.eventText = 'onWillDelete is triggering: ' + info.deleteValue + ' ' + info.deleteOffset
                return true;
              })
              .onDidDelete((info: DeleteValue) => {
                // 在删除完成时，触发该回调
                this.eventText = 'onDidDelete is triggering: ' + info.deleteValue + ' ' + info.deleteOffset
              })
              .onFocus(() => {
                this.eventText = $r('app.string.TextInputAddEvent_textContent_3');
              })
            // [End add_text_input_event]
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.TextInputAddEvent_title'))
  }
}