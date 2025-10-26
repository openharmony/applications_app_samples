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

// [Start precise_control_positive_cases]
@Observed
class PageTranslate {
  // The translation distance of the control component is 20.
  public translateX: number = 20;
}
@Component
struct PageTitle {
  build() {
    Row() {
      // $r('app.media.background')需要替换为开发者所需的图像资源文件。
      Image($r('app.media.background'))
        .width(50)
        .height(50)
      Text('Title')
        .fontSize(20)
    }
  }
}
@Entry
@Component
struct Page1 {
  @State translateObj: PageTranslate = new PageTranslate();

  build() {
    Column() {
      PageTitle()
      Stack() {
      }
      .backgroundColor('black')
      .width(200)
      .height(400)
      Button('move')
        .onClick(() => {
          this.getUIContext().animateTo({
            duration: 50
          },()=>{
            this.translateObj.translateX = (this.translateObj.translateX + 50) % 150
          })
        })
    }
    .translate({ // 子组件Stack和Button设置了同一个translate属性，可以统一到Column上设置。
      x: this.translateObj.translateX
    })
  }
}
// [End precise_control_positive_cases]