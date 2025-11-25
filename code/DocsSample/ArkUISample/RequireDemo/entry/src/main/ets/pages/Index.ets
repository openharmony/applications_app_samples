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
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Column(){
        Button('usage scene')
          .width('50%')
          .height('50vp')
          .margin({ top: '40vp' })
          .id('SceneRequire')
          .onClick(() => {
            router.pushUrl({
              url:'pages/SceneRequire'
            })
          })

        Button('usage ComponentV2')
          .width('50%')
          .height('50vp')
          .margin({ top: '40vp' })
          .id('ParentPage')
          .onClick(() => {
            router.pushUrl({
              url:'pages/ParentPage'
            })
          })
        Button('page one')
          .width('50%')
          .height('50vp')
          .margin({ top: '40vp' })
          .id('PageOne')
          .onClick(() => {
            router.pushUrl({
              url:'pages/PageOne'
            })
          })
        Button('ask')
          .width('50%')
          .height('50vp')
          .margin({ top: '40vp' })
          .id('Example')
          .onClick(() => {
            router.pushUrl({
              url:'pages/Example'
            })
          })
      }
    }
    .height('100%')
    .width('100%')
  }
}