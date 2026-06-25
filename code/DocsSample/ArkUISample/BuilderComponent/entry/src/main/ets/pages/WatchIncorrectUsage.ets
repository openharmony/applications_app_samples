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
// [Start executing_builder_function_watch_incorrect_usage]
@Entry
@Component
struct Child1 {
  // 使用@Provide和@Watch装饰器，当content变化时触发provideWatch回调
  @Provide @Watch('provideWatch') content: string = 'Index: hello world';

  @Builder
  watchBuilder(content: string) {
    Row() {
      Text(`${content}`)
    }
  }

  // @Watch回调函数
  provideWatch() {
    this.watchBuilder(this.content); // 错误写法，在@Watch函数中使用@Builder函数
  }

  build() {
    Column() {
      Button(`content value: ${this.content}`)
        .onClick(() => {
          // 点击按钮修改content，触发@Watch回调
          this.content += '_world';
        })
      this.watchBuilder(this.content);
    }
  }
}
// [End executing_builder_function_watch_incorrect_usage]