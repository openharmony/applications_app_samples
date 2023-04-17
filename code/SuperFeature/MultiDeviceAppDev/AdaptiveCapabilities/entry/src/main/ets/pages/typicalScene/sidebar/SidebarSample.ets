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

import { BreakpointSystem } from 'common/BreakpointSystem'

type ImageData = {
  label: string,
  imageSrc: Resource
}

const images: ImageData[] = [
  { label: 'moon', imageSrc: $r("app.media.my_image_moon") },
  { label: 'sun', imageSrc: $r("app.media.my_image") }
]

@Entry
@Component
struct SideBarSample {
  @StorageLink('currentBreakpoint')
  private currentBreakpoint: string = "md"
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()
  @State showSideBar: boolean = false
  @State selectIndex: number = 0

  aboutToAppear() {
    this.breakpointSystem.register()
    if (this.currentBreakpoint === 'sm') {
      this.showSideBar = false
    } else {
      this.showSideBar = true
    }
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister()
  }

  @Builder itemBuilder(index: number) {
    Text(images[index].label)
      .width('100%')
      .fontSize(24)
      .fontWeight(FontWeight.Bold)
      .borderRadius(5)
      .margin(20)
      .backgroundColor('#ffffff')
      .textAlign(TextAlign.Center)
      .width(180)
      .height(36)
      .onClick(() => {
        this.selectIndex = index
        if (this.currentBreakpoint === 'sm') {
          this.showSideBar = false
        }
      })
  }

  build() {
    SideBarContainer(this.currentBreakpoint === 'sm' ? SideBarContainerType.Overlay : SideBarContainerType.Embed) {
      Column() {
        this.itemBuilder(0)
        this.itemBuilder(1)
      }.backgroundColor('#F1F3F5')
      .justifyContent(FlexAlign.Center)

      Column() {
        Image(images[this.selectIndex].imageSrc)
          .objectFit(ImageFit.Contain)
          .height(300)
          .width(300)
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .height('100%')
    .width('100%')
    .sideBarWidth(this.currentBreakpoint === 'sm' ? '100%' : '33.33%')
    .minSideBarWidth(this.currentBreakpoint === 'sm' ? '100%' : '33.33%')
    .maxSideBarWidth(this.currentBreakpoint === 'sm' ? '100%' : '33.33%')
    .autoHide(false)
    .showControlButton(this.currentBreakpoint === 'sm')
    .showSideBar(this.showSideBar)
    .onChange((isBarShow: boolean) => {
      this.showSideBar = isBarShow
    })
  }
}