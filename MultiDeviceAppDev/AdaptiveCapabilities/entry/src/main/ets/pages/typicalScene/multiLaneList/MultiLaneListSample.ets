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

type ListItemInfo = {
  name: string
  image: Resource
}

@Entry
@Component
struct MultiLaneList {
  private data: ListItemInfo[] = [
    { name: '歌单集合1', image: $r('app.media.1') },
    { name: '歌单集合2', image: $r('app.media.2') },
    { name: '歌单集合3', image: $r('app.media.3') },
    { name: '歌单集合4', image: $r('app.media.4') },
    { name: '歌单集合5', image: $r('app.media.5') },
    { name: '歌单集合6', image: $r('app.media.6') },
    { name: '歌单集合7', image: $r('app.media.7') },
    { name: '歌单集合8', image: $r('app.media.8') },
    { name: '歌单集合9', image: $r('app.media.9') },
    { name: '歌单集合10', image: $r('app.media.10') },
    { name: '歌单集合11', image: $r('app.media.11') },
    { name: '歌单集合12', image: $r('app.media.12') }
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
    List() {
      ForEach(this.data, (item: ListItemInfo) => {
        ListItem() {
          Column() {
            Image(item.image)
            Text(item.name)
              .margin({ top: 8 })
              .fontSize(20)
          }.padding(4)
        }
      })
    }
    .lanes(new BreakPointType({ sm: 2, md: 4, lg: 6 }).getValue(this.currentBreakpoint))
    .width('100%')
  }
}