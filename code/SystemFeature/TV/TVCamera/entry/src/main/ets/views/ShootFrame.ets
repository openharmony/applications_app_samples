/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
@Component
export struct ShootFrame {
  @State outsideWidth: string = '';
  @State outsideHeight: string = '';
  @State insideWidth: string = '';
  @State insideHeight: string = '';

  aboutToAppear(): void {
  }

  build() {
    Column() {
      Row() {
        Row()
          .backgroundColor('#00000000')
          .width(this.insideWidth)
          .height(this.insideHeight)
          .border({
            width: {
              left: '5lpx',
              top: '5lpx',
              right: '0lpx',
              bottom: '0lpx'
            },
            color: '#5C5C5C'
          });

        Row()
          .backgroundColor('#00000000')
          .width(this.insideWidth)
          .height(this.insideHeight)
          .border({
            width: {
              left: '0lpx',
              top: '5lpx',
              right: '5lpx',
              bottom: '0lpx'
            },
            color: '#5C5C5C'
          });
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Row()
          .backgroundColor('#00000000')
          .width(this.insideWidth)
          .height(this.insideHeight)
          .border({
            width: {
              left: '5lpx',
              top: '0lpx',
              right: '0lpx',
              bottom: '5lpx'
            },
            color: '#5C5C5C'
          });

        Row()
          .backgroundColor('#00000000')
          .width(this.insideWidth)
          .height(this.insideHeight)
          .border({
            width: {
              left: '0lpx',
              top: '0px',
              right: '5lpx',
              bottom: '5lpx'
            },
            color: '#5C5C5C'
          });
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width(this.outsideWidth)
    .height(this.outsideHeight)
    .padding('5lpx')
  }
}