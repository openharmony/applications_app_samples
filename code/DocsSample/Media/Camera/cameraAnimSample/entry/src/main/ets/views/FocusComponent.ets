/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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

// 曝光选择
@Component
export struct FocusComponent {
  @Link focusPointBol: boolean;
  @Link focusPointVal: Array<number>;
  private mBorderWidth = 1.6;
  private mBorderRadius = 10;
  private mRowSize = 40;
  private mFocusPoint = 60;
  private focusFrameSize = 120;

  build() {
    if (this.focusPointBol) {
      Row() {
        // 对焦框
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Row() {
            }
            .border({
              width: {
                left: this.mBorderWidth,
                top: this.mBorderWidth
              },
              color: Color.White,
              radius: { topLeft: this.mBorderRadius }
            })
            .size({ width: this.mRowSize, height: this.mRowSize })

            Row() {
            }
            .border({
              width: {
                right: this.mBorderWidth,
                top: this.mBorderWidth
              },
              color: Color.White,
              radius: { topRight: this.mBorderRadius }
            })
            .size({ width: this.mRowSize, height: this.mRowSize })
          }

          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Row() {
            }
            .border({
              width: {
                left: this.mBorderWidth,
                bottom: this.mBorderWidth
              },
              color: Color.White,
              radius: { bottomLeft: this.mBorderRadius }
            })
            .size({ width: this.mRowSize, height: this.mRowSize })

            Row() {
            }
            .border({
              width: {
                right: this.mBorderWidth,
                bottom: this.mBorderWidth
              },
              color: Color.White,
              radius: { bottomRight: this.mBorderRadius }
            })
            .size({ width: this.mRowSize, height: this.mRowSize })
          }
        }
        .width(this.focusFrameSize)
        .height(this.focusFrameSize)
        .position({
          x: this.focusPointVal[0] - this.mFocusPoint,
          y: this.focusPointVal[1] - this.mFocusPoint
        })
      }
      .zIndex(1)
    }
  }
}
