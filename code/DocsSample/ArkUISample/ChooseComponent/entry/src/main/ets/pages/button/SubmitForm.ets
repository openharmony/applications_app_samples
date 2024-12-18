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

@Entry
@Component
export struct SubmitForm {
  @State username: string = ''
  @State password: string = ''
  pathStack: NavPathStack = new NavPathStack();

  resourceToString(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        TextInput({ text: this.username, placeholder: 'input your username' })
          .id('username')
          .onChange((value: string) => {
            this.username = value;
          })
        TextInput({ text: this.password, placeholder: 'input your password' })
          .type(InputType.Password)
          .id('password')
          .onChange((value: string) => {
            this.password = value;
          })
        Button('Register')
          .width('100%')
          .id('register')
          .onClick(() => {
            // 需要执行的操作
            this.username = 'your username';
            this.password = 'your password';
          })
      }.padding(12)
    }
    .backgroundColor('#f1f2f3')
    .title(this.resourceToString($r('app.string.SubmitForm_title')))
  }
}