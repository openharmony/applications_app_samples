/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
@Component
export struct cursorImage {
  @Prop arrowXPos: number;
  ifOpacity: boolean = false;
  image: string = 'app.media.left';
  rowOrColumn: boolean = true;
  ifForward: boolean = true;

  build() {
    Image($r(this.image))
      .width(this.rowOrColumn ? '24lpx' : '48lpx')
      .height(this.rowOrColumn ? '48lpx' : '24lpx')
      .zIndex(99)
      .onAppear(() => {
        this.arrowXPos = 10;
      })
      .translate({
        x: `${this.rowOrColumn ? (this.ifForward ? this.arrowXPos : -this.arrowXPos) : 0}lpx`,
        y: `${this.rowOrColumn ? 0 : (this.ifForward ? this.arrowXPos : -this.arrowXPos)}lpx`
      })
      .animation({
        duration: 1000,
        iterations: -1,

        playMode: PlayMode.AlternateReverse,
        curve: Curve.Linear
      })
      .autoResize(true)
      .visibility(this.ifOpacity ? Visibility.Visible : Visibility.Hidden);
  }
}