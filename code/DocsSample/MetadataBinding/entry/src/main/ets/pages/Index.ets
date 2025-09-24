import { metadataBinding } from "@kit.MultimodalAwarenessKit";

@Entry
@Component
struct Index {
  //[Start boomerang]
  @State message: string = '系统截图进行编码操作';
  screenShotCallback: Callback<number> = (event: number) => {
    if (event == 1) {
      let appLink = this.getAppLink()
      console.info('appLink:' + appLink)
      metadataBinding.submitMetadata(appLink);
    }
  }

  build() {
    RelativeContainer() {
      //[startExclude boomerang]
      Column() {
        Text(this.message)
          .id('id1')
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
          })

        Text('方式一、同时按住电源键和音量下键')
          .id('id2')
          .fontSize($r('app.float.page_text_size_eighteen'))
          .fontWeight(FontWeight.Normal)
          .alignRules({
          })
          .margin({ top: 30 })

        Text('方式二、指关节双击截屏')
          .id('id2')
          .fontSize($r('app.float.page_text_size_eighteen'))
          .fontWeight(FontWeight.Normal)
          .alignRules({
          })
          .margin({ top: 30 })
      }.alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
      })
    }
    .height('100%')
    .width('100%')
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize(ImageSize.Cover)
    //[EndExclude boomerang]
  }

  getAppLink(): string {
    let appLink: string = 'test.link';
    return appLink;
  }

  aboutToDisappear(): void {
    metadataBinding.off('operationSubmitMetadata', 'com.example.boomerang');
  }

  onPageShow(): void {
    metadataBinding.on('operationSubmitMetadata', 'com.example.boomerang', this.screenShotCallback);
  }

  onPageHide(): void {
    metadataBinding.off('operationSubmitMetadata', 'com.example.boomerang', this.screenShotCallback);
  }
  //[End boomerang]
}

