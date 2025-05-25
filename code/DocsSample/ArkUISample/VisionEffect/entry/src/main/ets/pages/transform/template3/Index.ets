import { matrix4 } from '@kit.ArkUI';

@Entry
@Component
struct MatrixExample {
  build() {
    Column({ space: 100 }) {
      Text('Hello1')
        .textAlign(TextAlign.Center)
        .width(100)
        .height(60)
        .borderWidth(1)

      Text('Hello2')
        .textAlign(TextAlign.Center)
        .width(100)
        .height(60)
        .borderWidth(1)
        .rotate({
          // 绕(100vp,60vp)的锚点旋转90度，rotate或scale的centerX、centerY为组件锚点
          z: 1,
          angle: 90,
          centerX: 100,
          centerY: 60
        })

      Text('Hello3')
        .textAlign(TextAlign.Center)
        .width(100)
        .height(60)
        .borderWidth(1)
        .transform(matrix4.identity()
          .rotate({
            // 组件锚点(centerX,centerY)默认为(50%,50%)，即锚点在(50vp,30vp)
            // transform的rotate指定(centerX,centerY)为(50vp,30vp)，相对于在组件本身锚点基础上再额外偏移(50vp,30vp)
            // 此次变换相当于绕(100vp,60vp)旋转，和"Hello2"实现同样的旋转效果
            z: 1,
            angle: 90,
            centerX: this.getUIContext().vp2px(50),
            centerY: this.getUIContext().vp2px(30)
          }))

      Text('Hello4')
        .textAlign(TextAlign.Center)
        .width(100)
        .height(60)
        .borderWidth(1)
        .scale({
          // 当设置x或y时，centerX和centerY才能生效
          // 设置组件锚点为(100vp,60vp)
          x: 1,
          y: 1,
          centerX: 100,
          centerY: 60
        })// transform的rotate不指定centerX、centerY，此次旋转的中心相对于组件本身锚点没有额外偏移
        // 该组件通过scale设置的锚点，绕(100vp,60vp)进行旋转，和"Hello2"实现同样的旋转效果
        .transform(matrix4.identity().rotate({ z: 1, angle: 90 }))
    }.width('100%')
    .height('100%')
  }
}