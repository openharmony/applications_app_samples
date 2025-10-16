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

// [Start animatable_extend_example]
class Point {
  x: number;
  y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }

  plus(rhs: Point): Point {
    return new Point(this.x + rhs.x, this.y + rhs.y);
  }

  subtract(rhs: Point): Point {
    return new Point(this.x - rhs.x, this.y - rhs.y);
  }

  multiply(scale: number): Point {
    return new Point(this.x * scale, this.y * scale);
  }

  equals(rhs: Point): boolean {
    return this.x === rhs.x && this.y === rhs.y;
  }
}

// PointVector实现了AnimatableArithmetic<T>接口
class PointVector extends Array<Point> implements AnimatableArithmetic<PointVector> {
  constructor(value: Array<Point>) {
    super();
    value.forEach(p => this.push(p));
  }

  plus(rhs: PointVector): PointVector {
    let result = new PointVector([]);
    const len = Math.min(this.length, rhs.length);
    for (let i = 0; i < len; i++) {
      result.push((this as Array<Point>)[i].plus((rhs as Array<Point>)[i]));
    }
    return result;
  }

  subtract(rhs: PointVector): PointVector {
    let result = new PointVector([]);
    const len = Math.min(this.length, rhs.length);
    for (let i = 0; i < len; i++) {
      result.push((this as Array<Point>)[i].subtract((rhs as Array<Point>)[i]));
    }
    return result;
  }

  multiply(scale: number): PointVector {
    let result = new PointVector([]);
    for (let i = 0; i < this.length; i++) {
      result.push((this as Array<Point>)[i].multiply(scale));
    }
    return result;
  }

  equals(rhs: PointVector): boolean {
    if (this.length != rhs.length) {
      return false;
    }
    for (let i = 0; i < this.length; i++) {
      if (!(this as Array<Point>)[i].equals((rhs as Array<Point>)[i])) {
        return false;
      }
    }
    return true;
  }

  get(): Array<Object[]> {
    let result: Array<Object[]> = [];
    this.forEach(p => result.push([p.x, p.y]));
    return result;
  }
}

@AnimatableExtend(Polyline)
function animatablePoints(points: PointVector) {
  .points(points.get())
}

@Entry
@Component
struct  AnimatablePropertyExample {
  @State points: PointVector = new PointVector([
    new Point(50, Math.random() * 200),
    new Point(100, Math.random() * 200),
    new Point(150, Math.random() * 200),
    new Point(200, Math.random() * 200),
    new Point(250, Math.random() * 200),
  ])

  build() {
    Column() {
      Polyline()
        .animatablePoints(this.points)
        .animation({ duration: 1000, curve: Curve.Ease })// 设置动画参数
        .size({ height: 220, width: 300 })
        .fill(Color.Green)
        .stroke(Color.Red)
        .backgroundColor('#eeaacc')
      Button('Play')
        .onClick(() => {
          // points是实现了可动画协议的数据类型，points在动画过程中可按照定义的运算规则、动画参数从之前的PointVector变为新的PointVector数据，产生每一帧的PointVector数据，进而产生动画
          this.points = new PointVector([
            new Point(50, Math.random() * 200),
            new Point(100, Math.random() * 200),
            new Point(150, Math.random() * 200),
            new Point(200, Math.random() * 200),
            new Point(250, Math.random() * 200),
          ]);
        })
    }.width('100%')
    .padding(10)
  }
}
// [End animatable_extend_example]