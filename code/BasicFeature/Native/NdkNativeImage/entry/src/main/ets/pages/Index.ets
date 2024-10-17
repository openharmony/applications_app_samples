import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  xComponentContext: object | undefined = undefined;
  xComponentAttrs: XComponentAttrs = {
    id: 'xcomponentId',
    type: XComponentType.SURFACE,
    libraryname: 'entry'
  }

  build() {
    Row() {
      // ...
      // 在xxx.ets 中定义 XComponent
      XComponent(this.xComponentAttrs)
        .focusable(true) // 可响应键盘事件
        .onLoad((xComponentContext) => {
          this.xComponentContext = xComponentContext;
        })
        .onDestroy(() => {
          console.log("onDestroy");
        })
      // ...
    }
  }
}

interface XComponentAttrs {
  id: string;
  type: number;
  libraryname: string;
}