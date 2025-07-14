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

@Entry
@Component
export struct Test2 {
  @State message: string = 'Native module counter example';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            // [Start counter_example]
            import('./test1').then((ns: ESObject) => {
              // 动态加载无法获取ns对象
              // 如希望使用该方式加载Native模块，需将test1.ets中的导出变更为具名导出或默认导出
              let res: number = ns.add(2, 3);
              this.message = 'res: ' + res;
            }).catch((err: Error) => {
              this.message = '加载失败: ' + err.message;
            })
            // [End counter_example]
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}