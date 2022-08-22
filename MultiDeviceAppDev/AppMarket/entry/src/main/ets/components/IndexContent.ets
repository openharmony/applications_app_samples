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

import IndexSwiper from "./indexswiper"
import IndexEntrance from "./indexentrance"
import IndexApps from "./IndexApps"
import { appList,gameList } from '../Module/AppList'

@Component
export default struct IndexContent {
  @Prop currentBreakpoint: string

  build() {
    List() {
      ListItem() {
        IndexSwiper({ currentBreakpoint: this.currentBreakpoint })
      }

      ListItem() {
        IndexEntrance({ currentBreakpoint: this.currentBreakpoint })
      }

      ListItem() {
        IndexApps({ title: $r('app.string.boutique_application'), currentBreakpoint: this.currentBreakpoint,
          apps: appList })
      }

      ListItem() {
        IndexApps({ title: $r('app.string.boutique_game'), currentBreakpoint: this.currentBreakpoint,
          apps: gameList })
      }

      ListItem() {
        IndexApps({ title: $r('app.string.boutique_game'), currentBreakpoint: this.currentBreakpoint,
          apps: gameList })
      }
    }
    .width("100%")
  }
}