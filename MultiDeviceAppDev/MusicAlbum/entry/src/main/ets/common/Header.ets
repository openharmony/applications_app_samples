/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

@Component
export default struct Header {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm'
  @StorageProp('fontSize') fontSize: number = 0


  build() {
    GridRow() {
      GridCol({ span: { sm: 6, lg: 4 } }) {
        Row() {
          Image($r('app.media.ic_back'))
            .width(20)
            .height(20)
            .margin({ left: 16 })
          Text($r('app.string.play_list'))
            .fontSize(this.fontSize + 4)
            .fontWeight(500)
            .fontColor('#556B89')
            .opacity(0.9)
            .letterSpacing(2)
            .padding({ left: 10 })
        }
        .height('100%')
        .backgroundColor('#e4ecf7')
      }

      GridCol({ span: { sm: 6, lg: 8 } }) {
        Row() {
          Image($r("app.media.ic_more"))
            .width(20)
            .height(20)
            .margin({ right: 16 })
        }
        .height('100%')
        .justifyContent(FlexAlign.End)
        .backgroundColor(this.currentBreakpoint === 'sm' ? '#e4ecf7' : '#f6f9fc')
      }
    }
    .height(50)
  }
}