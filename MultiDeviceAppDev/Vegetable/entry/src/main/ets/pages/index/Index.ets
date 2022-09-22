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

import { Menus } from './Menus'
import { Content } from './Content'
import { Related } from './Related'
import { Sidebar } from './Sidebar'
import { Contact } from './Contact'

@Entry
@Component
struct Index {
  @State contentH: number = 50
  @State currBp: string = 'sm'

  build() {
    Scroll() {
      Column() {
        // part1:menus
        Menus()
        GridRow() {
          // part2:content area which includes introduction for vegetables
          GridCol({ span: { xs: 12, sm: 12, md: 9, lg: 6 } }) {
            Content()
              .onAreaChange((oldValue: Area, newValue: Area) => {
                this.contentH = newValue.height as number
              })
          }
          // part3:Relevant description
          GridCol({ span: { xs: 12, sm: 12, md: 3, lg: 2 } }) {
            Related({ relatedCurrBp: this.currBp })
              .height((this.currBp !== 'xs' && this.currBp !== 'sm') ? this.contentH : 50)
          }
          // part4:external links
          GridCol({ span: { xs: 12, sm: 12, md: 12, lg: 4 } }) {
            Sidebar({ sidebarCurrBp: this.currBp })
              .height((this.currBp !== 'lg') ? 100 : this.contentH)
          }
          // part5:contact us
          GridCol({ span: { xs: 12, sm: 12, md: 12, lg: 12 } }) {
            Contact().height(80)
          }
        }.onBreakpointChange((breakpoint) => {
          this.currBp = breakpoint
        })
      }.margin(10)
    }
  }
}