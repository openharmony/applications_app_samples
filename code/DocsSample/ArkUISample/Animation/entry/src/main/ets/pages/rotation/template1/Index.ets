// xx.ets
import { display } from '@kit.ArkUI';

@Entry
@Component
struct rotation {

  build() {
    Stack() {
      Image($r('app.media.tree'))
        .position({ x: 0, y: 0 })
        .size({ width: 100, height: 100 })
        .id('image1')
    }
    .backgroundColor(Color.White)
    .size({ width: '100%', height: '100%' })
  }
}