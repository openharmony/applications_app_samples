import testNapi from 'libentry.so';
import { webview } from '@kit.ArkWeb';
import { resourceManager } from '@kit.LocalizationKit';


@Entry
@Component
struct Index {
  mycontroller: webview.WebviewController = new webview.WebviewController("scheme-handler");


  build() {
    Row() {
      Column() {
        Button("goback").onClick( event => {
          this.mycontroller.backward();
        })


        Web({ src: $rawfile("test.html"), controller: this.mycontroller})
          .javaScriptAccess(true)
          .width('100%')
          .height('100%')
          .databaseAccess(true)
          .fileAccess(false)
          .domStorageAccess(true)
          .cacheMode(CacheMode.Default)
          .onPageBegin( event => {
            testNapi.initResourceManager(getContext().resourceManager);
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}