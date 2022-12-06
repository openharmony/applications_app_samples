import web_webview from '@ohos.web.webview'

const phoneUserAgent: string = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36"
@Entry
@Component
struct Index {
  @State gameLeft: string = "console.info('webgame gameLeft'); _main.paddle.moveLeft();"
  @State gameRight: string = "console.info('webgame gameRight'); _main.paddle.moveRight();"
  @State gameStart: string = "console.info('webgame gameStart'); _main.game.state = _main.game.state_RUNNING; _main.ball.fired = true;"
  @State gameReset: string = "console.info('webgame gameReset'); if (_main.game.state === _main.game.state_GAMEOVER) {_main.game.state = _main.game.state_START; _main.start()}"
  @State removeDesc: string = "console.info('webgame removeDesc'); y=document.getElementsByTagName('div')[0]; y.parentNode.removeChild(y)"
  controller: web_webview.WebviewController = new web_webview.WebviewController()

  build() {
    Column() {
      Row() {
        Web({ src: "https://yangyunhe369.github.io/h5-game-blockBreaker/", controller: this.controller })
          .webDebuggingAccess(true)
          .backgroundColor(Color.Orange)
          .userAgent(phoneUserAgent)
          .domStorageAccess(true)
          .fileAccess(true)
          .onlineImageAccess(true)
          .imageAccess(true)
          .overviewModeAccess(true)
          .zoomAccess(true)
          .javaScriptAccess(true)
          .databaseAccess(true)
          .webDebuggingAccess(true)
          .backgroundColor(Color.Orange)
          .onPageEnd(e => {
            try {
              this.controller.loadUrl("javascript:" + this.removeDesc)
            } catch (error) {
              console.error("error: " + error);
            }
          })
      }
      .height('85%')
      Row() {
        Button('向左', { type: ButtonType.Normal })
          .width(100).height(50).backgroundColor(Color.Red)
          .gesture(
          LongPressGesture({ repeat: true, duration: 20 })
            .onAction((event: GestureEvent) => {
              console.log('czn999: --1');
              if (event.repeat) {
                try {
                  this.controller.loadUrl("javascript:" + this.gameLeft)
                } catch (error) {
                  console.error("error: " + error);
                }
              }
            })
          )
        Button('开始', { type: ButtonType.Circle })
          .onClick(() => {
            try {
              this.controller.loadUrl("javascript:" + this.gameStart)
            } catch (error) {
              console.error("error: " + error);
            }
          })
        Button('重来', { type: ButtonType.Circle })
          .onClick(() => {
            try {
              this.controller.loadUrl("javascript:" + this.gameReset)
            } catch (error) {
              console.error("error: " + error);
            }
          })
        Button('向右', { type: ButtonType.Normal })
          .width(100).height(50).backgroundColor(Color.Red)
          .gesture(
          LongPressGesture({ repeat: true, duration: 20 })
            .onAction((event: GestureEvent) => {
              console.log('czn999: --1');
              if (event.repeat) {
                try {
                  this.controller.loadUrl("javascript:" + this.gameRight)
                } catch (error) {
                  console.error("error: " + error);
                }
              }
            })
          )
      }
      .height('10%')
    }
  }
}