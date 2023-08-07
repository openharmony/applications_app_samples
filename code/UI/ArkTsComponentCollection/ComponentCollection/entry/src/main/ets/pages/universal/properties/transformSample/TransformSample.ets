/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import matrix4 from '@ohos.matrix4';

@Extend(Row) function rowStyle() {
  .padding(8)
  .borderRadius(24)
  .width('100%')
  .backgroundColor(Color.White)
  .margin({ left: 12, right: 12 })
}

// 创建一个四阶矩阵
let matrix:matrix4.Matrix4Transit = matrix4.init([1.0, 0.0, 0.0, 0.0,
  0.0, 1.0, 0.0, 0.0,
  0.0, 0.0, 1.0, 0.0,
  0.0, 0.0, 0.0, 1.0]);

@Entry
@Component
struct TransformSample {
  private matrix1: matrix4.Matrix4Transit = matrix4.identity().translate({ x: 100 });
  private matrix2: matrix4.Matrix4Transit = this.matrix1.copy();
  private matrix3: matrix4.Matrix4Transit = matrix4.identity().translate({ x: 20 }).copy();
  private matrix4: matrix4.Matrix4Transit = matrix4.identity().scale({ x: 2 }).copy();
  private matrix5: matrix4.Matrix4Transit = matrix4.identity().scale({ x: 2 });
  private matrix6: matrix4.Matrix4Transit = this.matrix5.invert();
  private matrix7: matrix4.Matrix4Transit = matrix4.identity().translate({ x: 40, y: 40, z: 20 });
  private matrix8: matrix4.Matrix4Transit = matrix4.identity()
    .scale({
      x: 0.5,
      y: 0.5
    });
  private matrix9: matrix4.Matrix4Transit = matrix4.identity().rotate({ x: 1, y: 1, z: 2, angle: 30 });
  private originPoint: [number, number] = [50, 50];
  private matrix_1: matrix4.Matrix4Transit = matrix4.identity().translate({ x: 50, y: -50 });
  private transformPoint: [number, number] = this.matrix_1.transformPoint(this.originPoint);
  private matrix_2: matrix4.Matrix4Transit = matrix4.identity().translate({ x: this.transformPoint[0], y: this.transformPoint[1] });

  build() {
    Column() {
      TitleBar({ title: $r('app.string.transform') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.transform_init') })
          Row() {
            Image($r('app.media.ic_scenery1'))
              .width('40%')
              .height(100)
              .transform(matrix)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.transform_copy') })
          Row() {
            Column() {
              Image($r('app.media.ic_scenery1'))
                .width('40%')
                .height(100)
                .transform(this.matrix1)

              Image($r('app.media.ic_scenery1'))
                .width('40%')
                .height(100)
                .margin({ top: 20 })
                .transform(this.matrix2)
            }
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.transform_combine') })
          Row() {
            Column() {
              Row() {
                // 矩阵变换前
                Image($r('app.media.ic_scenery1'))
                  .width('40%')
                  .height(100)

                Text($r('app.string.transform_combine_text'))
                  .fontSize(16)
                  .margin({ left: 20 })
              }

              // 先平移x轴200px，再缩放两倍x轴，得到矩阵变换后的效果图
              Image($r('app.media.ic_scenery1'))
                .transform(this.matrix3.combine(this.matrix4))
                .width('40%')
                .height(100)
                .margin({ top: 20 })
            }
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.transform_invert') })
          Row() {
            Column() {
              Text($r('app.string.transform_translate_invert'))
                .fontSize(16)
              Image($r("app.media.ic_scenery1"))
                .width('40%')
                .height(100)
                .margin({ top: 20 })
                .transform(this.matrix6)
            }
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.transform_translate') })
          Row() {
            Image($r('app.media.ic_scenery1')).transform(this.matrix7)
              .width("40%")
              .height(100)
              .margin(50)
            Text($r('app.string.transform_translate_text'))
              .fontSize(16)
              .margin({ left: 20 })
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.transform_scale') })
          Row() {
            Image($r('app.media.ic_scenery1')).transform(this.matrix8)
              .width('40%')
              .height(100)
            Text($r('app.string.transform_scale_text'))
              .fontSize(16)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.transform_rotate') })
          Row() {
            Image($r('app.media.ic_scenery1'))
              .transform(this.matrix9)
              .width('40%')
              .height(100)
              .margin({ top: 20 })
            Text($r('app.string.transform_rotate_text'))
              .fontSize(16)
              .margin({ left: 40 })
          }
          .height(200)
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.transform_transformPoint') })
          Row() {
            Column() {
              Text($r('app.string.transform_transformPoint_before'))
                .fontSize(16)
              Image($r('app.media.ic_scenery1'))
                .width('40%')
                .height(100)
                .margin({ top: 20 })
              Text($r('app.string.transform_transformPoint_after'))
                .fontSize(16)
                .margin({ top: 20 })
              Image($r('app.media.ic_scenery1'))
                .width('40%')
                .height(100)
                .margin({ top: 50 })
                .transform(this.matrix_2)
            }.width('100%').padding(20)
          }
          .rowStyle()
        }
        .constraintSize({ minHeight: '100%' })
      }
      .width('100%')
      .margin({ bottom: 70 })
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}