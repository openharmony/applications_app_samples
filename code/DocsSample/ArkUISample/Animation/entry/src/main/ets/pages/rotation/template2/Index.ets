// xx.ets
import { display } from '@kit.ArkUI';

@Entry
@Component
struct rotation {

  // 获取通过监听窗口的windowsSizeChange事件得到的屏幕显示方向
  @StorageLink('orientation') myOrientation: display.Orientation = display.Orientation.PORTRAIT;

  build() {
    Stack() {

      // 当屏幕显示方向变化时，切换组件的视图效果
      if (this.myOrientation == display.Orientation.PORTRAIT || this.myOrientation == display.Orientation.PORTRAIT_INVERTED) {
        Image($r('app.media.sky'))
          .size({ width: 100, height: 100 })
          .id('image1')

        // 开发者也可以通过自行设置transition的TransitionEffect.OPACITY转场效果来实现旋转屏动画的透明度变化
        // .transition(TransitionEffect.OPACITY)
      } else {
        Image($r('app.media.tree'))
          .position({ x: 0, y: 0 })
          .size({ width: 200, height: 200 })
          .id('image2')

        // 开发者也可以通过自行设置transition的TransitionEffect.OPACITY来实现旋转屏动画的透明度变化
        // .transition(TransitionEffect.OPACITY)
      }
    }
    .backgroundColor(Color.White)
    .size({ width: '100%', height: '100%' })
  }
}