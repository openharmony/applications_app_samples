/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Exposure selection
@Component
export struct focusPage {
  @Link focusPointBol: boolean;
  @Link focusPointVal: Array<number>;
  // Display where scale, focal length value, and focus box cannot coexist
  @Link exposureBol: boolean;
  // Exposure value
  @Link exposureNum: number;

  build() {
    Row() {
    if (this.focusPointBol) {
      Row() {
        if (this.exposureBol) {
          // Focus frame
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Row() {
              }.border({
                width: { left: 1.6, right: 0, top: 1.6, bottom: 0 },
                color: Color.White,
                radius: { topLeft: 10, topRight: 0, bottomLeft: 0, bottomRight: 0 }
              }).size({ width: 15, height: 15 });

              Row() {
              }.border({
                width: { left: 0, right: 1.6, top: 1.6, bottom: 0 },
                color: Color.White,
                radius: { topLeft: 0, topRight: 10, bottomLeft: 0, bottomRight: 0 }
              }).size({ width: 15, height: 15 });
            }

            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Row() {
              }.border({
                width: { left: 1.6, right: 0, top: 0, bottom: 1.6 },
                color: Color.White,
                radius: { topLeft: 0, topRight: 0, bottomLeft: 10, bottomRight: 0 }
              }).size({ width: 15, height: 15 });

              Row() {
              }.border({
                width: { left: 0, right: 1.6, top: 0, bottom: 1.6 },
                color: Color.White,
                radius: { topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 10 }
              }).size({ width: 15, height: 15 });
            }
          }
          .width(50)
          .height(50)
          .position({ x: this.focusPointVal[0] - 60, y: this.focusPointVal[1] - 60 });
        } else {
          // Focus value
          Text(this.exposureNum + '').fontSize(60).fontColor(Color.White).fontWeight(400).position({
            x: this.focusPointVal[0] - 58,
            y: this.focusPointVal[1] - 30
          });
          // Scale value
          Flex() {
            Column() {
              Text('+4').fontColor(Color.White);
              Text('0').margin({ top: 50, bottom: 50 }).fontColor(Color.White);
              Text('-4').fontColor(Color.White);
            }.margin({ right: 9 });
            // Scale
            Column() {
              Text('').height(67).border({
                width: { left: '0', right: 4, top: '0', bottom: '0' },
                color: Color.White,
                radius: 2,
                style: BorderStyle.Dotted
              });
              Text('').height(8).border({
                width: { left: '0', right: 8, top: '0', bottom: '0' },
                color: Color.White,
                radius: 4,
                style: BorderStyle.Solid
              }).margin({ top: 4 })
              Text('').height(67).border({
                width: { left: '0', right: 4, top: '0', bottom: '0' },
                color: Color.White,
                radius: 2,
                style: BorderStyle.Dotted
              }).margin({ top: 4 });
            }
          }.position({
            x: this.focusPointVal[0] + 56.6,
            y: this.focusPointVal[1] - 73
          });
        }
        // Exposure icon
        Image($r('app.media.ic_public_brightness')).size({ width: 24, height: 24 })
          .position({
            x: this.focusPointVal[0] + 10,
            y: this.focusPointVal[1] - 30
          });
      }.zIndex(99)
    }
    }.id('FocusPage')
  }
}