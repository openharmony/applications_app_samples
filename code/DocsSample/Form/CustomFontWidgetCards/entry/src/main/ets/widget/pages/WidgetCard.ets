import { text } from '@kit.ArkGraphics2D';

@Entry
@Component
struct loadFontSyncCard {
  // 在这里使用getLocalInstance访问本地字体集实例
  private fc: text.FontCollection = text.FontCollection.getLocalInstance();
  @State content: string = "默认字体";

  build() {
    Column({ space: 10 }) {
      Text(this.content)
        .fontFamily("custom") // 在此处声明组件使用自定义字体
      Button("load font")
        .onClick(() => {
          // 在此处加载自定义字体文件
          this.fc.loadFontSync("custom", $rawfile("xxx.ttf"));
          this.content = "自定义字体";
        })
      Button("unload font")
        .onClick(() => {
          this.fc.unloadFontSync("custom");
          this.content = "默认字体";
        })
    }.width("100%")
    .height("100%")
    .justifyContent(FlexAlign.Center)
  }
}