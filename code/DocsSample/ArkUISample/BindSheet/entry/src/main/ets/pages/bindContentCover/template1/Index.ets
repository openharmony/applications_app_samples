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
struct ModalTransitionExample {
  @State isShow: boolean = false;
  @State isShow2: boolean = false;

  @Builder
  myBuilder2() {
    Column() {
      Button("close modal 2")
        .margin(10)
        .fontSize(20)
        .onClick(() => {
          this.isShow2 = false;
        })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  myBuilder() {
    Column() {
      Button("transition modal 2")
        .margin(10)
        .fontSize(20)
        .onClick(() => {
          this.isShow2 = true;
        }).bindContentCover(this.isShow2, this.myBuilder2(), {
        modalTransition: ModalTransition.NONE,
        backgroundColor: Color.Orange,
        onWillAppear: () => {
          console.log('BindContentCover onWillAppear.');
        },
        onAppear: () => {
          console.log('BindContentCover onAppear.');
        },
        onWillDisappear: () => {
          console.log('BindContentCover onWillDisappear.');
        },
        onDisappear: () => {
          console.log('BindContentCover onDisappear.');
        }
      })

      Button("close modal 1")
        .margin(10)
        .fontSize(20)
        .onClick(() => {
          this.isShow = false;
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Button("transition modal 1")
        .onClick(() => {
          this.isShow = true;
        })
        .fontSize(20)
        .margin(10)
        .bindContentCover(this.isShow, this.myBuilder(), {
          modalTransition: ModalTransition.NONE,
          backgroundColor: Color.Pink,
          onWillAppear: () => {
            console.log('BindContentCover onWillAppear.');
          },
          onAppear: () => {
            console.log('BindContentCover onAppear.');
          },
          onWillDisappear: () => {
            console.log('BindContentCover onWillDisappear.');
          },
          onDisappear: () => {
            console.log('BindContentCover onDisappear.');
          }
        })
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor("#ff49c8ab")
    .width('100%')
    .height('100%')
  }
}