/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import PlayListCover from '../common/PlayListCover'
import PlayList from '../common/PlayList'

@Component
export default struct Content {
  @Provide coverHeight: number = 0

  build() {
    GridRow() {
      GridCol({ span: { xs: 12, sm: 12, md: 6, lg: 4 } }) {
        PlayListCover()
          .onAreaChange((oldArea: Area, newArea: Area) => {
            this.coverHeight = newArea.height as number
          })
      }
      .backgroundColor('#e4ecf7')

      GridCol({ span: { xs: 12, sm: 12, md: 6, lg: 8 } }) {
        PlayList()
      }
      .borderRadius(40)
    }
  }
}