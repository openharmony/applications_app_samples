/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

// [Start button_to_log_in_or_register]
@Entry
@Component
export struct SubmitForm {
  // [StartExclude button_to_log_in_or_register]
  @State username: string = ''
  @State password: string = ''
  pathStack: NavPathStack = new NavPathStack();

  resourceToString(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }
  // [EndExclude button_to_log_in_or_register]

  build() {
    // [StartExclude button_to_log_in_or_register]
    NavDestination() {
      // [EndExclude button_to_log_in_or_register]
      Column({ space: 12 }) {
        TextInput({ text: this.username, placeholder: 'input your username' })
          .id('username')
            // [StartExclude button_to_log_in_or_register]
          .onChange((value: string) => {
            this.username = value;
          })
        // [EndExclude button_to_log_in_or_register]
        TextInput({ text: this.password, placeholder: 'input your password' })
          .type(InputType.Password)
          .id('password')
            // [StartExclude button_to_log_in_or_register]
          .onChange((value: string) => {
            this.password = value;
          })
        // [EndExclude button_to_log_in_or_register]
        Button('Register')
          .width('100%')
          .id('register')
          .onClick(() => {
            // 需要执行的操作
            // [StartExclude button_to_log_in_or_register]
            this.username = 'your username';
            this.password = 'your password';
            // [EndExclude button_to_log_in_or_register]
          })
      }.padding(12)
      // [End button_to_log_in_or_register]
    }
    .backgroundColor('#f1f2f3')
    .title(this.resourceToString($r('app.string.SubmitForm_title')))
  }
}