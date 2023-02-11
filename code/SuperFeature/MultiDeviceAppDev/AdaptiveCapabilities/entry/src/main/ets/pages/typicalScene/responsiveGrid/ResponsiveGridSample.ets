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

import { BreakpointSystem, BreakPointType } from 'common/BreakpointSystem'

type GridItemInfo = {
  name: Resource
  image: Resource
}

@Entry
@Component
export default struct ResponsiveGrid {
  private data: Array<GridItemInfo> = [
    { name: $r('app.string.playlist_collection'), image: $r('app.media.1') },
    { name: $r('app.string.playlist_collection'), image: $r('app.media.2') },
    { name: $r('app.string.playlist_collection'), image: $r('app.media.3') },
    { name: $r('app.string.playlist_collection'), image: $r('app.media.4') },
    { name: $r('app.string.playlist_collection'), image: $r('app.media.5') },
    { name: $r('app.string.playlist_collection'), image: $r('app.media.6') },
    { name: $r('app.string.playlist_collection'), image: $r('app.media.7') },
    { name: $r('app.string.playlist_collection'), image: $r('app.media.8') },
    { name: $r('app.string.playlist_collection'), image: $r('app.media.9') },
    { name: $r('app.string.playlist_collection'), image: $r('app.media.10') },
    { name: $r('app.string.playlist_collection'), image: $r('app.media.11') },
    { name: $r('app.string.playlist_collection'), image: $r('app.media.12') }
  ]
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'md'

  aboutToAppear() {
    this.breakpointSystem.register()
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister()
  }

  build() {
    Grid() {
      ForEach(this.data, (item: GridItemInfo, index: number) => {
        GridItem() {
          Column() {
            Image(item.image)
              .aspectRatio(1.8)
            Row() {
              Text(item.name)
                .margin({ top: 8 })
                .fontSize(20)
              Text(`${index}`)
                .margin({ top: 8 })
                .fontSize(20)
            }
          }.padding(4)
        }
      })
    }
    .columnsTemplate(new BreakPointType({
      sm: '1fr 1fr',
      md: '1fr 1fr 1fr 1fr',
      lg: '1fr 1fr 1fr 1fr 1fr 1fr'
    }).getValue(this.currentBreakpoint))
  }
}