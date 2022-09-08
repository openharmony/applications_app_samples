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
import { data } from '../../../model/Data'

type GridItemInfo = {
  name: string
  image: Resource
}

@Entry
@Component
export default struct ResponsiveGrid {
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
      ForEach(data, (item: GridItemInfo) => {
        GridItem() {
          Column() {
            Image(item.image)
              .aspectRatio(1.8)
            Text(item.name)
              .margin({ top: 8 })
              .fontSize(20)
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