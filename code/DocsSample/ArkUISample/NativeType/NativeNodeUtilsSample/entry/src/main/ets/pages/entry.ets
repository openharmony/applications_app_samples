import { NodeContent } from '@kit.ArkUI';
import entry from 'libentry.so';

@Component
struct CAPIComponent {
  private rootSlot = new NodeContent();

  aboutToAppear(): void {
    // 页面显示前多线程创建Native组件。
    entry.createNodeTreeOnMultiThread(this.rootSlot, this.getUIContext())
  }

  aboutToDisappear(): void {
    // 页面销毁前释放已创建的Native组件。
    entry.disposeNodeTreeOnMultiThread(this.rootSlot)
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
        Text('CreateNodeTreeOnMultiThread')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
        Button(this.message)
          .id('Button')
          .onClick(() => {
            this.isShow = !this.isShow;
            if (this.isShow) {
              this.message = 'DisposeNodeTree'
            } else {
              this.message = 'CreateNodeTree'
            }
          })
        if (this.isShow) {
          CAPIComponent()
        }
      }.width('100%')
    }.width('100%')
  }
}
