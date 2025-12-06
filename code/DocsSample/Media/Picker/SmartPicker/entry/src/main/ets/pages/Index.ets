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
struct Index {
  @State content: string = '';
  @State recommendationType: number = 4;
  pathStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pathStack) {
      Column() {
        Button($r('app.string.Component_recommendation'))
          .width('100%')
          .margin({ bottom: 8 })
          .onClick(() => {
            this.pathStack.pushPathByName('ComponentImplPage', null);
          })
        Button($r('app.string.Interface_recommendation'))
          .width('100%')
          .margin({ bottom: 16 })
          .onClick(() => {
            this.pathStack.pushPathByName('InterfaceImplPage', null);
          })
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .height('100%')
      .padding({
        left: 16,
        right: 16
      })
    }
    .width('100%')
    .height('100%')
    .title($r('app.string.title'))
  }
}