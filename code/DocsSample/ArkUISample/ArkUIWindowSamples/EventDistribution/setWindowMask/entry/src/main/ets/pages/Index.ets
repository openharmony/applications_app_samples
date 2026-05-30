import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

// [Start index_component]
@Entry
@Component
struct Index {
  // [StartExclude index_component]
  @State message: string = 'set windowMask test';
  private storage: LocalStorage | undefined = this.getUIContext()?.getSharedLocalStorage();
  private windowStage: window.WindowStage | undefined = this.storage?.get<window.WindowStage>('windowStage');
  private testWindow: window.Window | undefined = undefined;
  // [EndExclude index_component]
  private windowMaskSub: window.Window | undefined = undefined;
  // [End index_component]

  private winWidth: number = 800;
  private winHeight: number = 800;

  createSubWindowForWindowMask() {
    const subWindowOpts: window.SubWindowOptions = {
      title: 'This is a subwindow',
      decorEnabled: true
    };
    this.windowStage?.createSubWindowWithOptions("subWindowForWindowMask", subWindowOpts).then((subwindow: window.Window) => {
      this.windowMaskSub = subwindow;
      let storage: LocalStorage = new LocalStorage();
      storage.setOrCreate("windowName", "Sub Window");
      subwindow.loadContent('pages/Page_EmptyWindow', storage);
      subwindow.resize(this.winWidth, this.winHeight);
      subwindow.moveWindowTo(200, 220);
      subwindow.showWindow();
      subwindow.enableDrag(true);
      setTimeout(() => {
        subwindow?.setWindowBackgroundColor('#ff4d4dcf');
        subwindow.setWindowCornerRadius(30);
        subwindow.setWindowShadowRadius(60);
      }, 500);
    });
  }

  createSubWindow() {
    const subWindowOpts: window.SubWindowOptions = {
      title: 'This is a subwindow',
      decorEnabled: true
    };

    this.windowStage?.createSubWindowWithOptions("subWindowTest", subWindowOpts).then((curWindow: window.Window) => {
      this.testWindow = curWindow;
      let storage: LocalStorage = new LocalStorage();
      storage.setOrCreate("windowName", "Test Window");
      curWindow.loadContent('pages/Page_EmptyWindow', storage);
      curWindow.resize(this.winWidth, this.winHeight);
      curWindow.moveWindowTo(200, 1050);
      curWindow.showWindow();
      curWindow.enableDrag(true);
      setTimeout(() => {
        curWindow?.setWindowBackgroundColor('#ff73ef73');
      }, 500);
    });
  }

  // [Start setWindowMask_func]
  setWindowMask(window: window.Window) {
    let windowMask: Uint8Array = new Uint8Array(this.winWidth * this.winHeight);
    for (let i = 0; i < this.winHeight; i++) {
      for (let k = 0; k < this.winWidth; k++) {
        if ((i + k) < (this.winHeight + this.winWidth) / 2) {
          windowMask[i * this.winWidth + k] = 0;
        } else {
          windowMask[i * this.winWidth + k] = 255;
        }
      }
    }
    window.setWindowMaskWithAlpha(windowMask, this.winWidth, this.winHeight);
  }
  // [End setWindowMask_func]

  // [Start setWindowMask_build]
  build() {
    Row() {
      Scroll(){
        Column() {
          // [StartExclude setWindowMask_build]
          Button("Create Test Window")
            .type(ButtonType.Capsule)
            .margin({
              bottom: 50
            }).fontSize(18)
            .onClick(() => {
              if (this.testWindow) {
                return;
              }
              this.createSubWindow();
            })
          Button("Destroy Test Window")
            .type(ButtonType.Capsule)
            .margin({
              top: 10,
              bottom: 200
            }).fontSize(18)
            .onClick(() => {
              if (this.testWindow) {
                this.testWindow.destroyWindow();
                this.testWindow = undefined;
              }
            })

          Text(this.message)
            .fontSize(20)
            .size({ width: '100%', height: '50' })
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
          Row() {
            Button("Create Sub Window")
              .type(ButtonType.Capsule)
              .margin({
                top: 10
              }).fontSize(16)
              .onClick(() => {
                if (this.windowMaskSub) {
                  return;
                }
                this.createSubWindowForWindowMask();
              })
            Button("Destroy Sub Window")
              .type(ButtonType.Capsule)
              .margin({
                top: 10
              }).fontSize(16)
              .onClick(() => {
                if (this.windowMaskSub) {
                  this.windowMaskSub.destroyWindow();
                  this.windowMaskSub = undefined;
                }
              })
          }
          // [EndExclude setWindowMask_build]
          Row() {
            Button("setWindowMask for Sub Window")
              .width('90%')
              .type(ButtonType.Capsule)
              .margin({
                top: 10
              }).fontSize(18)
              .onClick(() => {
                if(this.windowMaskSub) {
                  this.setWindowMask(this.windowMaskSub);
                }
              })
          }
        }
        .width('100%')
      }
    }
    .height('100%')
  }

}
// [End setWindowMask_build]