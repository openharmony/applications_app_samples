import web_webview from '@ohos.web.webview'

@Entry
@Component
struct Index {
  @State gameLeft: string = "console.info('webgame gameLeft'); _main.paddle.moveLeft();"
  @State gameRight: string = "console.info('webgame gameRight'); _main.paddle.moveRight();"
  @State gameStart: string = "console.info('webgame gameStart'); if (_main.game.state !== _main.game.state_GAMEOVER) {_main.game.state = _main.game.state_RUNNING; _main.ball.fired = true;}"
  @State gameReset: string = "console.info('webgame gameReset'); if (_main.game.state === _main.game.state_GAMEOVER) {_main.game.state = _main.game.state_START; _main.start()}"
  @State removeDesc: string = "console.info('webgame removeDesc'); y=document.getElementsByTagName('div')[0]; y.parentNode.removeChild(y)"
  controller: web_webview.WebviewController = new web_webview.WebviewController()

  build() {
    Row() {
      Column() {
        Button('Start', { type: ButtonType.Capsule })
          .onClick(() => {
            try {
              this.controller.loadUrl("javascript:" + this.gameStart)
            } catch (error) {
              console.error("error: " + error);
            }
          })
        Button('L', { type: ButtonType.Capsule })
          .width(50).height(100).backgroundColor(Color.Red)
          .gesture(
          LongPressGesture({ repeat: true, duration: 20 })
            .onAction((event: GestureEvent) => {
              if (event.repeat) {
                try {
                  this.controller.loadUrl("javascript:" + this.gameLeft)
                } catch (error) {
                  console.error("error: " + error);
                }
              }
            })
          )
      }.width('10%')
      Column() {
        Web({ src: "https://yangyunhe369.github.io/h5-game-blockBreaker/", controller: this.controller })
          .webDebuggingAccess(true)
          .domStorageAccess(true)
          .onlineImageAccess(true)
          .imageAccess(true)
          .zoomAccess(false)
          .javaScriptAccess(true)
          .webDebuggingAccess(true)
          .backgroundColor(Color.Orange)
          .onPageEnd(e => {
            try {
              this.controller.loadUrl("javascript:" + this.removeDesc)
            } catch (error) {
              console.error("error: " + error);
            }
          })
      }.width('80%')
      Column() {
        Button('Reset', { type: ButtonType.Capsule })
          .onClick(() => {
            try {
              this.controller.loadUrl("javascript:" + this.gameReset)
            } catch (error) {
              console.error("error: " + error);
            }
          })
        Button('R', { type: ButtonType.Capsule })
          .width(50).height(100).backgroundColor(Color.Red)
          .gesture(
          LongPressGesture({ repeat: true, duration: 20 })
            .onAction((event: GestureEvent) => {
              if (event.repeat) {
                try {
                  this.controller.loadUrl("javascript:" + this.gameRight)
                } catch (error) {
                  console.error("error: " + error);
                }
              }
            })
          )
      }.width('10%')
    }
  }
}