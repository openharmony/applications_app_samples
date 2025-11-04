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
// [Start textspan_onhover]
// xxx.ets
@Entry
@Component
export struct TextSpanOnHover {
  @State textStr1: string = '';
  @State textStr2: string = '';

  build() {
    // [StartExclude textspan_onhover]
    NavDestination() {
      // [EndExclude textspan_onhover]
      Row() {
        Column() {
          Text() {
            Span('I am Upper-span')
              .textCase(TextCase.UpperCase)
              .fontSize(30)
              .onClick(() => {
                console.info('Span onClick is triggering');
                this.textStr1 = 'Span onClick is triggering';
              })
              .onHover(() => {
                console.info('Span onHover is triggering');
                this.textStr2 = 'Span onHover is triggering';
              })
          }

          Text('onClick：' + this.textStr1)
            .fontSize(20)
          Text('onHover：' + this.textStr2)
            .fontSize(20)
        }.width('100%')
      }
      .height('100%')
      // [StartExclude textspan_onhover]
    }.backgroundColor('#f1f 2f3')
    .title($r('app.string.OnClick_onHover'))
    // [EndExclude textspan_onhover]
  }
}

// [End textspan_onhover]