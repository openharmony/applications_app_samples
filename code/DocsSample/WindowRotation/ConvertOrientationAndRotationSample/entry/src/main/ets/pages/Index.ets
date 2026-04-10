import { display, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct SpecificSceneSetOrientationIndex {
  @State displayOrientation: number = 0;
  mainWindow: window.Window = AppStorage.get('mainWindow_SetOrientation') as window.Window;

  options: SelectOption[] = [
    { value: 'PORTRAIT', icon: '' },
    { value: 'LANDSCAPE', icon: '' },
    { value: 'PORTRAIT_INVERTED', icon: '' },
    { value: 'LANDSCAPE_INVERTED', icon: '' },
  ];
  setOrientation(displayOrientation: number) {
    try {
      let windowOrientation : number = this.mainWindow.convertOrientationAndRotation(window.RotationInfoType.DISPLAY_ORIENTATION,window.RotationInfoType.WINDOW_ORIENTATION,displayOrientation);
      let orientation: window.Orientation = window.Orientation.UNSPECIFIED; // 设置窗口方向旋转模式
      switch (windowOrientation) {
        case 0:
          orientation = window.Orientation.PORTRAIT;
          break;
        case 1:
          orientation = window.Orientation.LANDSCAPE_INVERTED;
          break;
        case 2:
          orientation = window.Orientation.PORTRAIT_INVERTED;
          break;
        case 3:
          orientation = window.Orientation.LANDSCAPE;
          break;
        default:
          throw new Error("Invalid input value");
      }
      try {
        this.mainWindow.setPreferredOrientation(orientation, (err) => {
          if (err.code) {
            return;
          }
        });
      } catch (exception) {
        // ...
      }
    } catch (exception) {
      // ...
    }
  }

  build() {
    Column() {
      Text("lock display Orientation")
        .fontSize(17)

      Row() {
        Select(this.options)
          .selected(0)
          .onSelect((_index: number, value: string) => {
            this.displayOrientation = _index;
          })
        Button('Set the display orientation')
          .onClick(() => {
            console.info('demo click Create and Show Specific Window');
            this.setOrientation(this.displayOrientation);
          })
      }
      .justifyContent(FlexAlign.Center)   // Row内部居中
      .alignItems(VerticalAlign.Center)
    }
    .justifyContent(FlexAlign.Center)     // Column内部垂直居中
    .alignItems(HorizontalAlign.Center)   // Column内部水平居中
    .height('100%')
    .width('100%')

  }
}