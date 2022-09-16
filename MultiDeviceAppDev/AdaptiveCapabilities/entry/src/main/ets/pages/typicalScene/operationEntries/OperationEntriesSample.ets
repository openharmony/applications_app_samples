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

type OperationItem = {
  name: Resource,
  icon: Resource
}

@Entry
@Component
export default struct OperationEntries {
  private listData: Array<OperationItem> = [
    { name: $r('app.string.operation1'), icon: $r('app.media.self_fm') },
    { name: $r('app.string.operation2'), icon: $r('app.media.singer') },
    { name: $r('app.string.operation3'), icon: $r('app.media.song_list') },
    { name: $r('app.string.operation4'), icon: $r('app.media.rank') },
    { name: $r('app.string.operation5'), icon: $r('app.media.hot') },
    { name: $r('app.string.operation6'), icon: $r('app.media.sport') },
    { name: $r('app.string.operation7'), icon: $r('app.media.audio_fm') },
    { name: $r('app.string.operation8'), icon: $r('app.media.bonus') }
  ]

  build() {
    Scroll() {
      Row() {
        ForEach(this.listData, (item) => {
          Column() {
            Image(item.icon)
              .width(48)
              .aspectRatio(1)
            Text(item.name)
              .margin({ top: 8 })
              .fontSize(16)
          }
          .justifyContent(FlexAlign.Center)
          .height(104)
          .padding({ left: 12, right: 12 })
        })
      }
      .constraintSize({ minWidth: '100%' })
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width('100%')
    .scrollable(ScrollDirection.Horizontal)
  }
}