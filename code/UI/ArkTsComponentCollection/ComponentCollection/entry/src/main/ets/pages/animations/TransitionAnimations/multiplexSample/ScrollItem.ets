/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import { MultiplexModel } from './MultiplexModel';

@Component
export struct ScrollItem {
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Vertical, fingers: 1 });
  private resource!: MultiplexModel;
  private onDelete: (id: string) => void = (id: string) => {
  };
  @StorageProp('windowHeight') windowHeight: number = 720;
  @State offsetX: number = 0; // X轴滑动距离
  @State offsetY: number = 0; // Y轴滑动距离
  @State scaleX: number = 1; // 缩放比例
  @State angle: number = 0; // 旋转角度
  @State translateY: number = 0; // Y轴移动距离
  @State sx: number = 1; // 滑动系数


  build() {
    Column() {
      Stack() {
        Image(this.resource.getImg())
          .width('100%')
          .height('100%')
          .borderRadius(20)
          .shadow({
            radius: 20,
            color: $r('app.color.btn_border_color')
          })
      }
      .width('100%')
      .height('100%')
      .scale({
        x: this.scaleX,
        y: this.scaleX,
        z: this.scaleX,
      })
      .rotate({
        x: 1,
        y: 0,
        z: 0,
        centerX: '50%',
        centerY: '100%',
        angle: this.angle
      })
      .translate({
        x: 0,
        y: this.translateY,
        z: this.translateY
      })
      .opacity(this.sx)
    }
    .borderRadius(20)
    .justifyContent(FlexAlign.Center)
    .gesture(
      PanGesture(this.panOption)
        .onActionStart((event: GestureEvent) => {
          console.info('Pan start');
        })
        .onActionUpdate((event: GestureEvent) => {
          let sx: number;
          if (event.offsetY - this.offsetY <= 0) {
            sx = (this.sx - Math.abs(event.offsetY - this.offsetY) / this.windowHeight);
          } else {
            sx = (this.sx + Math.abs(event.offsetY - this.offsetY) / this.windowHeight);
          }
          this.move(sx);
          this.offsetX = event.offsetX;
          this.offsetY = event.offsetY;
        })
        .onActionEnd(() => {
          this.offsetX = 0;
          this.offsetY = 0;
          console.info('Pan end');
          if (this.scaleX >= 0.15 && this.scaleX < 1) {
            this.restore();
          } else if (this.scaleX < 0.15) {
            this.delete();
          }
        })
    )
  }

  move(sx: number) {
    this.sx = sx > 1 ? 1 : sx < 0 ? 0 : sx;
    this.scaleX = Math.pow(sx, 7) > 1 ? 1 : sx < 0 ? 0 : Math.pow(sx, 7);
    let an = Math.pow((1 - sx) * 30, 2);
    this.angle = an > 90 ? 90 : an;
    let y = Math.log((2 - sx)) * -(this.windowHeight * 2);
    this.translateY = y > 0 ? 0 : y;
    console.info('Pan sx:' + this.sx);
    console.info('Pan scaleX:' + this.scaleX);
    console.info('Pan translateY:' + this.translateY);
    console.info('Pan angle:' + this.angle);
  }


  /**
   * 还原
   */
  restore() {
    let that = this;
    let intervalID = setInterval(() => {
      that.move(that.sx += 0.01);
      if (that.sx >= 1) {
        clearInterval(intervalID);
      }
    }, 10);
  }

  /**
   * 删除
   */
  delete() {
    let that = this;
    let intervalID = setInterval(() => {
      that.move(that.sx -= 0.01);
      if (that.sx < 0.2) {
        clearInterval(intervalID);
        that.onDelete(that.resource.getId());
      }
    }, 10);
  }
}