import { window } from '@kit.ArkUI';

@Entry
@Component
struct DialogWindow {
  @State message: string = 'DialogWindow';

  destroyDialogWindow() {
    let dialog_windowClass: window.Window | undefined = undefined;
    dialog_windowClass = window.findWindow("DialogWindow");
    if (!dialog_windowClass) {
      console.error('dailog_windowClass is null');
      return;
    }
    // [Start destroy_dialog_window]
    // 4.销毁子窗口。当不再需要子窗口时，可根据具体实现逻辑，使用destroy对其进行销毁。
    dialog_windowClass.destroyWindow((err: BusinessError) => {
      let errCode: number = err.code;
      if (errCode) {
        console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in destroying the window.');
    });
    // [End destroy_dialog_window]
  }

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('DialogWindowHelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })

      Button("销毁模态窗")
        .onClick(async () => {
          this.destroyDialogWindow();
        }).margin(5)
    }
    .height('100%')
    .width('100%')
  }
}