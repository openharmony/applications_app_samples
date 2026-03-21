import { router } from '@kit.ArkUI';
// import router from '@ohos.router';
import { BusinessError } from '@ohos.base';

@Entry
@Component
struct Index {
  scroll: Scroller = new Scroller();
  public buttonW: number = 200;
  public buttonH: number = 35;
  public buttonFontSize: number = 25;

  async routePage(options: router.RouterOptions) {
    this.getUIContext()
      .getRouter()
      .pushUrl(options)
      .then(() => {
        console.info(`pushUrl finish`);
      }).catch((err: BusinessError) => {
        console.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
    })
  }

  build() {
    Scroll(this.scroll) {
      Column( {space: 20} ) {
        // title
        Row() {
          Text('长时任务sample') {
          }.fontWeight(FontWeight.Bold).fontSize(50).textAlign(TextAlign.Center)
        }.justifyContent(FlexAlign.Center).margin({ top: 30 })

        // 播音
        Row() {
          Column() {
            Button({ type: ButtonType.Capsule, stateEffect: true }) {
              Text('后台播音').fontSize(this.buttonFontSize)
            }.width(this.buttonW).height(this.buttonH).onClick((event) => {
              let options1: router.RouterOptions = {
                url: 'pages/audioPlayback/AudioPlaybackIndex',
              }
              this.routePage(options1)
            })
          }.alignItems(HorizontalAlign.Center)
        }

        // 蓝牙
        Row() {
          Column() {
            Button({ type: ButtonType.Capsule, stateEffect: true }) {
              Text('蓝牙断开重连').fontSize(this.buttonFontSize)
            }.width(this.buttonW).height(this.buttonH).onClick((event) => {
              let options2: router.RouterOptions = {
                url: 'pages/bluetoothInteraction/BluetoothInteractionIndex',
              }
              this.routePage(options2)
            })
          }.alignItems(HorizontalAlign.Center)
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
  }

  pageTransition() {
    // 定义页面进入效果，从右侧划入，时长1000ms，页面栈push操作生效
    PageTransitionEnter({ type: RouteType.Push, duration: 800 })
      .slide(SlideEffect.Right)
      .translate({x: 1000, y: 100})
      .opacity(0)
    // 定义页面进入效果，从左侧划入，时长1000ms，页面栈pop操作生效
    PageTransitionEnter({ type: RouteType.Pop, duration: 800 })
      .slide(SlideEffect.Left)
      .translate({x: 1000, y: 100})
      .opacity(0)
    // 定义页面退出效果，从左侧划出，时长1000ms，页面栈pop操作生效
    PageTransitionExit({ type: RouteType.Push, duration: 800 })
      .slide(SlideEffect.Left)
      .translate({x: 1000, y: 100})
      .opacity(0)
    // 定义页面退出效果，从右侧划出，时长1000ms，页面栈pop操作生效
    PageTransitionExit({ type: RouteType.Push, duration: 800 })
      .slide(SlideEffect.Left)
      .translate({x: 1000, y: 100})
      .opacity(0)
  }
}