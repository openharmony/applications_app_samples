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

interface BottomBtnItem {
  text: Resource,
  icon: Resource
}

@Component
export struct BottomBtn {
  @Prop isMultiCheck: boolean
  @Prop isSelectedAll: boolean
  private bottomBtn: Array<BottomBtnItem> = [
    { icon: $r('app.media.select_all'), text: $r('app.string.select_all') },
    { icon: $r('app.media.delete'), text: $r('app.string.delete') },
    { icon: $r('app.media.close'), text: $r('app.string.quit') }]
  private handleBottomBtnClick: (index: number) => void = (index: number) => {}

  getIcon(item: BottomBtnItem, index: Number): Resource {
    if (index === 0 && this.isSelectedAll) {

      return $r('app.media.unselect_all')
    }
    return item.icon
  }

  getText(item: BottomBtnItem, index: Number): Resource {
    if (index === 0 && this.isSelectedAll) {
      return $r('app.string.cancel')
    }
    return item.text
  }

  build() {
    if (this.isMultiCheck) {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
        ForEach(this.bottomBtn, (item: BottomBtnItem, index) => {
          Column() {
            Image(this.getIcon(item, index))
              .size({ width: 40, height: 40 })
              .objectFit(ImageFit.Contain)
            Text(this.getText(item, index))
              .fontSize(16)
              .fontColor(Color.Black)
          }
          .flexShrink(1)
          .onClick(() => {
            this.handleBottomBtnClick(index)
          })
        }, (item: BottomBtnItem) => JSON.stringify(item))
      }
      .height('8%')
    }
  }
}