/*
 * Copyright (c) 2023-2024 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import curves from '@ohos.curves';
import display from '@ohos.display';
import inputMethod from '@ohos.inputMethod';
import { TitleBar } from '../../../../common/TitleBar'
import FloatingWindowComponent from './FloatingWindowComponent';
import Logger from '../../../../util/Logger';

const TAG = '[FloatingWindowPage]';

@Entry
@Component
struct FloatingWindowSample {
  private diameter: number = 120; // 触摸点相对偏移量
  @State positionX: number = 50; // 组件位置X
  @State positionY: number = 500; // 组件位置Y
  @State displayHalfWidth: number = 0; // 屏幕一半的宽
  @State displayHalfHeight: number = 0; // 屏幕一半的高
  @State moveStartX: number = 0; // X方向起始点
  @State moveStartY: number = 0; // Y方向起始点
  @State moveEndX: number = 0; // X方向终点
  @State moveEndY: number = 0; // Y方向终点
  @State moveSumLengthX: number = 0; // X方向移动距离总和
  @State moveSumLengthY: number = 0; // Y方向移动距离总和
  @State moveStartTime: number = 0; // 触摸开始时间
  @State moveEndTime: number = 0; // 触摸结束时间
  @State inputMethodSetting: inputMethod.InputMethodSetting = inputMethod.getSetting();

  aboutToAppear() {
    display.getAllDisplays((err, data) => {
      // 拿到屏幕宽高的一半，作为判断基准值
      this.displayHalfWidth = data[0].width / 2;
      this.displayHalfHeight = data[0].height / 2;
      // 将拿到的px转为vp
      Logger.info(TAG, `aboutToAppear getAllDisplays data 1 width:${this.displayHalfWidth}, height:${this.displayHalfHeight}`);
      this.displayHalfWidth = px2vp(this.displayHalfWidth);
      this.displayHalfHeight = px2vp(this.displayHalfHeight);
      Logger.info(TAG, `aboutToAppear getAllDisplays data 2 width:${this.displayHalfWidth}, height:${this.displayHalfHeight}`);
      this.inputMethodSetting.on('imeShow', (info: Array<inputMethod.InputWindowInfo>) => {
        Logger.info(TAG, `aboutToAppear InputWindowInfo:${JSON.stringify(info[0])}`);
        let keyboradTop: number = this.displayHalfHeight * 2 - info[0].top;
        if(keyboradTop < this.positionY) {
          animateTo({ curve: curves.responsiveSpringMotion() }, () => {
            this.positionY = this.displayHalfHeight * 2 - info[0].top;
            Logger.info(TAG, `aboutToAppear avoid inputkeyboard, animateTo x:${this.positionX}, y:${this.positionY}`);
          })
        }
      });
    })
  }

  aboutToDisappear() {
    this.inputMethodSetting.off('imeShow', () => {
      Logger.info(TAG, `aboutToDisappear off imeshow`);
    });
  }

  build() {
    Row() {
      Column() {
        TitleBar({ title: $r('app.string.Floating_window') })
          .id('target')
        TextInput({ placeholder: $r('app.string.avoiding_input_method_testing') })
          .width('95%').height(50)
          .enableKeyboardOnFocus(false)
          .id('test_input')
        Row() {
          Row() {
            FloatingWindowComponent()
          }
          .id('floatingWindowComponent')
          .width(80)
          .height(80)
          .position({ x: this.positionX, y: this.positionY })
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.moveStartX = event.touches[0].screenX; // 按下时获取X坐标初始值
              this.moveStartY = event.touches[0].screenY; // 按下时获取Y坐标初始值
              this.moveStartTime = Date.now(); // 按下时开始时间
              this.moveSumLengthX = 0; // 按下时初始化x方向移动距离
              this.moveSumLengthY = 0; // 按下时初始化y方向移动距离
            }
            if (event.type === TouchType.Move) {
              this.moveEndX = event.touches[0].screenX; // X方向移动的当前位置
              this.moveEndY = event.touches[0].screenY; // Y方向移动的当前位置
              this.moveSumLengthX += Math.abs(this.moveEndX - this.moveStartX); // 每一次移动计算相对于上一次X方向位置的距离
              this.moveSumLengthY += Math.abs(this.moveEndY - this.moveStartY); // 每一次移动计算相对于上一次Y方向位置的距离
              this.moveStartX = this.moveEndX;
              this.moveStartY = this.moveEndY;
              Logger.info(TAG, `move ing, moveSumLengthX:${this.moveSumLengthX}, moveSumLengthY:${this.moveSumLengthY}`);

              // 跟手过程，使用responsiveSpringMotion曲线
              animateTo({ curve: curves.responsiveSpringMotion() }, () => {
                // 减去半径，以使球的中心运动到手指位置
                this.positionX = event.touches[0].screenX - this.diameter / 2;
                this.positionY = event.touches[0].screenY - this.diameter / 2 - 120;
                Logger.info(TAG, `move end, animateTo x:${this.positionX}, y:${this.positionY}`);
              })
            } else if (event.type === TouchType.Up) {
              this.moveEndTime = Date.now();
              let moveDiffTime = this.moveEndTime - this.moveStartTime; // 最后一秒移动的距离
              // 距离
              let s = Math.sqrt((this.moveSumLengthX * this.moveSumLengthX) + (this.moveSumLengthY * this.moveSumLengthY));
              // 时间
              let t = moveDiffTime;
              // 速度
              let v = s / t;
              Logger.info(TAG, `moveEnd, moveSumLengthX:${this.moveSumLengthX}, moveSumLengthY:${this.moveSumLengthY}, moveDiffTime:${moveDiffTime}`);
              Logger.info(TAG, `moveEnd, s:${s}, t:${t}, v:${v}`);

              // 离手时，使用springMotion曲线，且将移动时速度赋值给离手时速度
              animateTo({ curve: curves.springMotion(), tempo: v }, () => {
                if (this.positionX >= this.displayHalfWidth) {
                  // 如果划到右边，则定位至屏幕右边减去自身宽度80，再减去10留出间隙
                  this.positionX = this.displayHalfWidth * 2 - 90;
                } else {
                  this.positionX = 10;
                }
                if (this.positionY >= this.displayHalfHeight * 2 - 300) {
                  this.positionY = this.displayHalfHeight * 2 - 300;
                } else if (this.positionY <= 0) {
                  this.positionY = 10;
                }
                Logger.info(TAG, `touchUp, animateTo x:${this.displayHalfWidth}, y:100`);
              })
            }
          })
        }
        .width('100%')
        .height('92%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_shallow_grey'))
    }
    .width('100%')
    .height('100%')
  }
}