/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@Component
export struct AlbumScrollBar {
  scroller: Scroller | null = null;
  @State isClickScrollBar: boolean = false;
  @Consume isHideScrollBar: boolean;
  hasSideBar: boolean = true;

  build() {
    if (this.scroller !== null && this.scroller !== undefined) {
      ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Vertical,
        state: this.isHideScrollBar ? BarState.Off : BarState.Auto }) {
        Row() {
        }
        .width(this.isClickScrollBar ?
        $r('app.float.album_scrollbar_select_size') : $r('app.float.album_scrollbar_normal_size'))
        .height($r('app.float.album_scrollbar_height_size'))
        .border({ radius: $r('app.float.album_scrollbar_radius') })
        .backgroundColor($r('app.color.album_scrollbar_color'))
      }
      .height('100%')
      .position({ x: '100%', y: 0 })
      .markAnchor({
        x: this.isClickScrollBar
          ? $r('app.float.album_scrollbar_select_size') : $r('app.float.album_scrollbar_normal_size'),
        y: 0
      })
      .onTouch((event: TouchEvent): void => {
        if (event.type === TouchType.Down) {
          this.isClickScrollBar = true;
        } else if (event.type === TouchType.Up) {
          this.isClickScrollBar = false;
        }
      })
    }

  }
}