/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

// 曝光选择
@Component
export struct FocusPage {
  @Link focusPointBol: boolean;
  @Link focusPointVal: Array<number>;
  // 刻度、焦距值 和 对焦框不能共存的显示
  @Link exposureBol: boolean;
  // 曝光值
  @Link exposureNum: number;

  build() {
    if (this.focusPointBol) {
      Row() {
        if (this.exposureBol) {
          // 对焦框
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Row() {
              }
              .border({
                width: { left: 1.6, right: 0, top: 1.6, bottom: 0 },
                color: Color.White,
                radius: { topLeft: 10, topRight: 0, bottomLeft: 0, bottomRight: 0 }
              })
              .size({ width: 40, height: 40 })

              Row() {
              }
              .border({
                width: { left: 0, right: 1.6, top: 1.6, bottom: 0 },
                color: Color.White,
                radius: { topLeft: 0, topRight: 10, bottomLeft: 0, bottomRight: 0 }
              })
              .size({ width: 40, height: 40 })
            }

            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Row() {
              }
              .border({
                width: { left: 1.6, right: 0, top: 0, bottom: 1.6 },
                color: Color.White,
                radius: { topLeft: 0, topRight: 0, bottomLeft: 10, bottomRight: 0 }
              })
              .size({ width: 40, height: 40 })

              Row() {
              }
              .border({
                width: { left: 0, right: 1.6, top: 0, bottom: 1.6 },
                color: Color.White,
                radius: { topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 10 }
              })
              .size({ width: 40, height: 40 })
            }
          }
          .width(120)
          .height(120)
          .position({ x: this.focusPointVal[0] - 60, y: this.focusPointVal[1] - 60 })
        } else {
          // 焦距值
          Text(this.exposureNum + '')
            .fontSize(60)
            .fontColor(Color.White)
            .fontWeight(400)
            .position({
              x: this.focusPointVal[0] - 58,
              y: this.focusPointVal[1] - 30
            })
          // 刻度值
          Flex() {
            Column() {
              Text('+4')
                .fontColor(Color.White)
              Text('0')
                .margin({ top: 50, bottom: 50 })
                .fontColor(Color.White)
              Text('-4')
                .fontColor(Color.White)
            }.margin({ right: 9 })
            // 刻度
            Column() {
              Text('')
                .height(67)
                .border({
                  width: { left: '0', right: 4, top: '0', bottom: '0' },
                  color: Color.White,
                  radius: 2,
                  style: BorderStyle.Dotted
                })
              Text('')
                .height(8)
                .border({
                  width: { left: '0', right: 8, top: '0', bottom: '0' },
                  color: Color.White,
                  radius: 4,
                  style: BorderStyle.Solid
                })
                .margin({ top: 4 })
              Text('')
                .height(67)
                .border({
                  width: { left: '0', right: 4, top: '0', bottom: '0' },
                  color: Color.White,
                  radius: 2,
                  style: BorderStyle.Dotted
                })
                .margin({ top: 4 })
            }
          }
          .position({
            x: this.focusPointVal[0] + 56.6,
            y: this.focusPointVal[1] - 73
          })
        }
        // 曝光图标
        Image($r('app.media.ic_public_brightness'))
          .size({ width: 24, height: 24 })
          .position({
            x: this.focusPointVal[0] + 75,
            y: this.focusPointVal[1] - 10 - (this.exposureNum * 18)
          })
      }
      .zIndex(99)
    }
  }
}
