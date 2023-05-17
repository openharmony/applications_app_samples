import router from '@ohos.router'
import VideoListLayout from '../component/VideoList'
import TabLayout from '../moudle/TabBar'
import InteractionLayout from '../component/Interaction'
import RacingLayout from '../component/Racing'
import BattleLayout from '../component/Battle'
import ShootLayout from "../component/Shooting"
import InstrumentLayout from '../component/Instrument'
import RealisticLayout from '../component/Realistic'
import FootstepLayout from '../component/Footstep'
import EnvironmentLayout from '../component/Environment'
import ExerciseLayout from '../component/Exercise'

export enum tabIndex {
  INTERACTION = 0,
  RACING,
  BATTLE,
  SHOOT,
  INSTRUMENT,
  REALISTIC,
  FOOTSTEP,
  ENVIRONMENT,
  EXERCISE,
}
@Component
export  default struct DisplayPage {
  @State titleArr: string[] = ['互动','竞速','战斗','枪击','乐器','拟真','脚步','环境','运动']
  @State currentIndex: number  = 1//当前页面索引初始值为1
  private swiperController: SwiperController = new SwiperController()//创建翻页控制器
  private tabHeight = 50
  @State playDis:boolean = false
  @Link vibrationIntensity:string
  private controller: TabsController = new TabsController();
  build(){
    Column({ space: 10 }) {
      Row() {
        Text('触感效果视频')
          .width('50%')
          .fontSize(24)
          .fontColor('#ffffffff')
          .fontWeight(FontWeight.Normal)
          .textAlign(TextAlign.Start)
          .layoutWeight(7)
          .padding({ left: 10 })
        Button('显示更多')
          .backgroundColor("#00d613ca")
          .layoutWeight(3)
          .height(35)
          .fontColor('#919191')
          .onClick(() => {
            console.info('显示更多按下')
            router.pushUrl({
              url: 'pages/VideoListPage'
            })
          })
      }.padding({ top: 5 })

      VideoListLayout()
      Text("振效库")
        .width('100%')
        .fontSize(24)
        .fontColor('#ffffffff')
        .fontWeight(FontWeight.Normal)
        .textAlign(TextAlign.Start)
        .padding({ left: 10 })
      Row() {
        TabLayout({
          titleArr: $titleArr,
          currentIndex: $currentIndex,
          tabSelected: (position: number, title: string) => {
            this.currentIndex = position
            console.log('onTabSelected position = ' + position + ', title = ' + title)
            this.swiperController.showNext()
          },
        })
      }.width('100%')
      .height(this.tabHeight)
      .zIndex(10)

      Scroll() {
        Column() {
          Swiper(this.swiperController) {
            ForEach(this.titleArr, (item) => {
              Column() {
                if (this.currentIndex === tabIndex.INTERACTION) {
                  InteractionLayout()
                } else if (this.currentIndex === tabIndex.RACING) {
                  RacingLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.BATTLE) {
                  BattleLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.SHOOT) {
                  ShootLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.INSTRUMENT) {
                  InstrumentLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.REALISTIC) {
                  RealisticLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.FOOTSTEP) {
                  FootstepLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.ENVIRONMENT) {
                  EnvironmentLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else if (this.currentIndex === tabIndex.EXERCISE) {
                  ExerciseLayout({
                    vibrationIntensity:$vibrationIntensity
                  })
                } else {
                  Text('敬请期待').fontSize(48).fontColor(Color.Black).width("100%").height("100%")
                }
              }
            }, item => item)

          }
          .index(0) //设置当前在容器中显示的子组件的索引值
          .autoPlay(false) //子组件是否自动播放，自动播放状态下，导航点不可操作。
          .indicator(false) // 是否启用导航点指示器。
          .loop(true) // 是否开启循环。
          .vertical(false) // 是否为纵向滑动。
          .itemSpace(0) //设置子组件与子组件之间间隙。
          .index(this.currentIndex)
          .flexGrow(1)
          .width('100%')
          .onChange((index: number) => {
            console.info(index.toString())
            this.currentIndex = index
          })
        }
      }.scrollBar(BarState.Off).scrollBar(BarState.Off)
    }.width('100%').height('100%').backgroundColor('#f2191a32')
  }
}