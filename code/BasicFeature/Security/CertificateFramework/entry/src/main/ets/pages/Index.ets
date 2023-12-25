/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { CertChain } from './CertChain'
import { CertFramework } from './CertFramework'

@Entry
@Component
struct Index {
  @State currentIndex: number = 0

  @Builder
  TabBuilder(index: number, name: Resource, id: string) {
    Text(name)
      .id(id)
      .fontColor('#182431')
      .fontSize(this.currentIndex === index ? 24 : 18)
      .fontWeight(this.currentIndex === index ? 700 : 500)
      .lineHeight(33)
      .margin({ left: index === 0 ? 24 : 16 })
      .opacity(this.currentIndex === index ? 1 : 0.6)
      .onClick(() => {
        this.currentIndex = index
      })
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        this.TabBuilder(0, $r('app.string.tab_certframework'), 'tab_certframework')
        this.TabBuilder(1, $r('app.string.tab_certchain'), 'tab_certchain')
      }
      .height(56)

      Row() {
        if (this.currentIndex === 0) {
          CertFramework()
        } else {
          CertChain()
        }
      }
    }.backgroundColor($r('app.color.homepage_bg_color'))
  }
}