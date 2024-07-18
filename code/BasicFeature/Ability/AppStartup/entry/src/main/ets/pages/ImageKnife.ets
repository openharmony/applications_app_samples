import { ImageKnifeComponent, ImageKnifeOption } from '@ohos/imageknife';

@Entry
@Component
struct ImageKnife {
  @State message: string = 'Hello World';
  @State option: ImageKnifeOption = {
    loadSrc: $r('app.media.startIcon')
  };

  build() {
    RelativeContainer() {
      ImageKnifeComponent({ imageKnifeOption: this.option }).width(300)
        .height(300).margin({ top: 30 })
    }
    .height('100%')
    .width('100%')
  }
}