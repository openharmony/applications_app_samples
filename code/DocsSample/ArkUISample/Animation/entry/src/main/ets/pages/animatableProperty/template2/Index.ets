/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start Animation_AnimatableProperty]
declare type Point = number[];

// 定义可动画属性接口的参数类型，实现AnimatableArithmetic<T>接口中加法、减法、乘法和判断相等函数
class PointClass extends Array<number> {
  constructor(value: Point) {
    super(value[0], value[1]);
  }

  add(rhs: PointClass): PointClass {
    let result: Point = new Array<number>() as Point;
    for (let i = 0; i < 2; i++) { // 2: 二维坐标点
      result.push(rhs[i] + this[i]);
    }
    return new PointClass(result);
  }

  subtract(rhs: PointClass): PointClass {
    let result: Point = new Array<number>() as Point;
    for (let i = 0; i < 2; i++) { // 2: 二维坐标点
      result.push(this[i] - rhs[i]);
    }
    return new PointClass(result);
  }

  multiply(scale: number): PointClass {
    let result: Point = new Array<number>() as Point;
    for (let i = 0; i < 2; i++) { // 2: 二维坐标点
      result.push(this[i] * scale);
    }
    return new PointClass(result);
  }
}

// 定义可动画属性接口的参数类型，实现AnimatableArithmetic<T>接口中加法、减法、乘法和判断相等函数
// 模板T支持嵌套实现AnimatableArithmetic<T>的类型
class PointVector extends Array<PointClass> implements AnimatableArithmetic<Array<Point>> {
  constructor(initialValue: Array<Point>) {
    super();
    if (initialValue.length) {
      initialValue.forEach((p: Point) => this.push(new PointClass(p)));
    }
  }

  // implement the IAnimatableArithmetic interface
  plus(rhs: PointVector): PointVector {
    let result = new PointVector([]);
    const len = Math.min(this.length, rhs.length);
    for (let i = 0; i < len; i++) {
      result.push(this[i].add(rhs[i]));
    }
    return result;
  }

  subtract(rhs: PointVector): PointVector {
    let result = new PointVector([]);
    const len = Math.min(this.length, rhs.length);
    for (let i = 0; i < len; i++) {
      result.push(this[i].subtract(rhs[i]));
    }
    return result;
  }

  multiply(scale: number): PointVector {
    let result = new PointVector([]);
    for (let i = 0; i < this.length; i++) {
      result.push(this[i].multiply(scale));
    }
    return result;
  }

  equals(rhs: PointVector): boolean {
    if (this.length !== rhs.length) {
      return false;
    }
    for (let index = 0, size = this.length; index < size; ++index) {
      if (this[index][0] !== rhs[index][0] || this[index][1] !== rhs[index][1]) {
        return false;
      }
    }
    return true;
  }
}

// 自定义可动画属性接口
@AnimatableExtend(Polyline)
function animatablePoints(points: PointVector) {
  .points(points);
}

@Entry
@Component
struct AnimatedShape {
  squareStartPointX: number = 75; // 75: 正方形起始点X坐标
  squareStartPointY: number = 25; // 25: 正方形起始点Y坐标
  squareWidth: number = 150; // 150: 正方形宽度
  squareEndTranslateX: number = 50; // 50: 正方形结束位置X轴平移量
  squareEndTranslateY: number = 50; // 50: 正方形结束位置Y轴平移量
  @State pointVec1: PointVector = new PointVector([
    [this.squareStartPointX, this.squareStartPointY],
    [this.squareStartPointX + this.squareWidth, this.squareStartPointY],
    [this.squareStartPointX + this.squareWidth, this.squareStartPointY + this.squareWidth],
    [this.squareStartPointX, this.squareStartPointY + this.squareWidth]
  ]);
  @State pointVec2: PointVector = new PointVector([
    [this.squareStartPointX + this.squareEndTranslateX, this.squareStartPointY + this.squareStartPointY],
    [this.squareStartPointX + this.squareWidth + this.squareEndTranslateX,
      this.squareStartPointY + this.squareStartPointY],
    [this.squareStartPointX + this.squareWidth, this.squareStartPointY + this.squareWidth],
    [this.squareStartPointX, this.squareStartPointY + this.squareWidth]
  ]);
  @State color: Color = Color.Green;
  @State fontSize: number = 20.0; // 20.0: 字体大小
  @State polyline1Vec: PointVector = this.pointVec1;
  @State polyline2Vec: PointVector = this.pointVec2;

  build() {
    Row() {
      Polyline()
        .width(300) // 300: 折线宽度
        .height(200) // 200: 折线高度
        .backgroundColor('#0C000000') // 0C000000: 背景颜色（黑色带透明度）
        .fill('#317AF7') // 317AF7: 填充颜色（蓝色）
        .animatablePoints(this.polyline1Vec)
        .animation({ duration: 2000, delay: 0, curve: Curve.Ease }) // 2000: 动画持续时间（毫秒），0: 动画延迟时间
        .onClick(() => {
          if (this.polyline1Vec.equals(this.pointVec1)) {
            this.polyline1Vec = this.pointVec2;
          } else {
            this.polyline1Vec = this.pointVec1;
          }
        });
    }
    .width('100%').height('100%').justifyContent(FlexAlign.Center);
  }
}
// [End Animation_AnimatableProperty]