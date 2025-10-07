import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
const msg_tag = '[accessibilityCapi]';

@Entry(undefined)
@Component
struct Index {
  @LocalStorageLink('mainWindow') private mainWindow: window.Window | undefined = undefined;
  @State isMultiInstance: boolean = false;
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Button('SubWindow').onClick(()=>{
          try {
            this.mainWindow?.createSubWindowWithOptions('Modal',
              {title: 'SubWindow', decorEnabled: true, isModal:true})
          } catch (err) {
            console.error(`${msg_tag} code: ${err.code}, message: ${err.message}`);
          }
        })
        Button('XComponent单实例/多实例切换').onClick(()=>{
          this.isMultiInstance = !this.isMultiInstance;
          console.info(`${msg_tag}: current XComponent multiInstance is ${this.isMultiInstance}`);
        })
        if (this.isMultiInstance) {
          XComponent({
            id: 'xComponentId1',
            type: XComponentType.SURFACE,
            libraryname: 'nativerender'
          })
            .onDestroy(()=>{
              console.info(`${msg_tag} Destroy Sub Window`);
            })
            .id('xComponentId1')
            .focusable(true)
            .background(Color.Green)
            .width('100%')
            .height('50%')
          XComponent({
            id: 'xComponentId2',
            type: XComponentType.SURFACE,
            libraryname: 'nativerender'
          })
            .onDestroy(()=>{
              console.info(`${msg_tag} Destroy Sub Window`);
            })
            .id('xComponentId2')
            .focusable(true)
            .background(Color.Gray)
            .width('100%')
            .height('50%')
        } else {
          XComponent({
            id: 'xComponentIdSingle',
            type: XComponentType.SURFACE,
            libraryname: 'nativerender'
          })
            .onDestroy(()=>{
              console.info(`${msg_tag} Destroy Sub Window`);
            })
            .id('xComponentIdSingle')
            .focusable(true)
            .background(Color.Gray)
            .width('100%')
            .height('50%')
        }
      }
    }
    .width('100%')
    .height('100%')
    .focusable(true)
    .defaultFocus(true)
  }
}
