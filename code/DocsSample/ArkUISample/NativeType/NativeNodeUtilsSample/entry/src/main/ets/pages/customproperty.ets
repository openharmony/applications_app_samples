// index.ets
import { NodeContent } from '@kit.ArkUI';
import entry from 'libentry.so';

@Component
struct CAPIComponent {
  private rootSlot = new NodeContent();

  aboutToAppear(): void {
    // 页面显示前多线程创建Native组件。
    entry.createCustomPropertyDemo(this.rootSlot)
  }

  aboutToDisappear(): void {
    // 页面销毁前释放已创建的Native组件。
    entry.disposeNodeTree(this.rootSlot)
  }

  build() {
    Column() {
      // Native组件挂载点。
      ContentSlot(this.rootSlot)
    }
  }
}

@Entry
@Component
struct Index {
  @State isShow: boolean = false;
  @State message: string = 'CreateNodeTree';

  build() {
    Flex() {
      Column() {
        Text('通用类接口测试')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)

        CAPIComponent()
      }.width('100%')
    }.width('100%')
  }
}
