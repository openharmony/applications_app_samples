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

import mediaquery from '@ohos.mediaquery'
import HomeContent from './home/HomeContent'
import IndexTitleBar from './home/IndexTitleBar'
import SideContent from './home/SideContent'
import { CityListData, getBg, getCityListWeatherData, Logger } from '@ohos/common'

const TAG: string = 'Home'

@Entry
@Component
struct Home {
  @StorageLink('isRefresh') @Watch('refreshChange') isRefresh: boolean = false
  @StorageLink('swiperIndex') swiperIndex: number = 0
  @State curBp: string = 'md'
  @State cityListWeatherData: CityListData[] = getCityListWeatherData()
  @State popupState: boolean = false
  @State showSideBar: boolean = false
  private smListener: mediaquery.MediaQueryListener
  private mdListener: mediaquery.MediaQueryListener
  private lgListener: mediaquery.MediaQueryListener

  build() {
    SideBarContainer(SideBarContainerType.Embed) {
      SideContent({ showSideBar: $showSideBar })
        .height('100%')
      Column() {
        IndexTitleBar({ curBp: this.curBp, showSideBar: $showSideBar })
          .height(56)
        Swiper() {
          ForEach(this.cityListWeatherData, (item, index) => {
            HomeContent({ showSideBar: this.showSideBar, cityListData: item, index: index })
          }, item => item.city)
        }
        .indicatorStyle({
          selectedColor: Color.White
        })
        .onChange(index => {
          this.swiperIndex = index
          AppStorage.SetOrCreate('swiperIndex', this.swiperIndex)
        })
        .indicator(this.curBp !== 'lg')
        .index(this.swiperIndex)
        .loop(false)
        .width('100%')
        .layoutWeight(1)
      }
      .height('100%')
    }
    .height('100%')
    .sideBarWidth('33.3%')
    .minSideBarWidth('33.3%')
    .maxSideBarWidth('33.3%')
    .showControlButton(false)
    .showSideBar(this.showSideBar)
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImage(getBg(this.cityListWeatherData[this.swiperIndex].header.weatherType))
  }

  aboutToAppear() {
    this.smListener = mediaquery.matchMediaSync('(320vp<width<=520vp)')
    this.smListener.on("change", this.isBreakpointSM)
    this.mdListener = mediaquery.matchMediaSync('(520vp<width<=840vp)')
    this.mdListener.on("change", this.isBreakpointMD)
    this.lgListener = mediaquery.matchMediaSync('(840vp<width)')
    this.lgListener.on("change", this.isBreakpointLG)
  }

  aboutToDisappear() {
    this.smListener.off("change", this.isBreakpointSM)
    this.mdListener.off("change", this.isBreakpointMD)
    this.lgListener.off("change", this.isBreakpointLG)
  }

  isBreakpointSM = (mediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.curBp = 'sm'
      this.showSideBar = false
      AppStorage.SetOrCreate('curBp', this.curBp)
    }
    Logger.info(TAG, `this.curBp = ${this.curBp}`)
  }
  isBreakpointMD = (mediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.curBp = 'md'
      this.showSideBar = false
      AppStorage.SetOrCreate('curBp', this.curBp)
    }
    Logger.info(TAG, `this.curBp = ${this.curBp}`)
  }
  isBreakpointLG = (mediaQueryResult) => {
    if (mediaQueryResult.matches) {
      if (this.curBp !== 'lg') {
        this.showSideBar = true
      }
      this.curBp = 'lg'
      AppStorage.SetOrCreate('curBp', this.curBp)
    }
    Logger.info(TAG, `this.curBp = ${this.curBp}`)
  }

  refreshChange() {
    Logger.info(TAG, `refreshChange}`)
    if (this.isRefresh) {
      this.cityListWeatherData = getCityListWeatherData()
      AppStorage.SetOrCreate('isRefresh', false)
    }
    Logger.info(TAG, `refreshChange, this.cityListWeatherData.length = ${this.cityListWeatherData.length}`)
  }
}