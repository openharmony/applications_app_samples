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

import { DirectoryItem, DirectoryList } from '../../common/DirectoryList'

@Entry
@Component
struct Index {
  private directory: DirectoryItem[] = [
    { title: $r('app.string.grid_layout1'), uri: 'pages/gridRow/gridRow/GridRowSample1' },
    { title: $r('app.string.grid_layout2'), uri: 'pages/gridRow/gridRow/GridRowSample2' },
    { title: $r('app.string.grid_layout3'), uri: 'pages/gridRow/gridRow/GridRowSample3' },
    { title: $r('app.string.grid_layout4'), uri: 'pages/gridRow/gridRow/GridRowSample4' },
    { title: $r('app.string.grid_layout5'), uri: 'pages/gridRow/gridRow/GridRowSample5' },
    { title: $r('app.string.grid_layout6'), uri: 'pages/gridRow/gridRow/GridRowSample6' },
    { title: $r('app.string.grid_layout7'), uri: 'pages/gridRow/gridRow/GridRowSample7' },
    { title: $r('app.string.grid_layout8'), uri: 'pages/gridRow/gridRow/GridRowSample8' },
    { title: $r('app.string.grid_layout9'), uri: 'pages/gridRow/gridRow/GridRowSample9' }
  ]

  build() {
    Column() {
      DirectoryList({ title: $r('app.string.grid_layout'), directory: this.directory })
    }
  }
}