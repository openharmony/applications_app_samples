import DisplayPage from '../moudle/DisplayPage'
import SelectorIndex from '../moudle/MyPage'



@Entry
@Component
struct Index {
  private controller: TabsController = new TabsController();
  @State barIndex:number = 0
  @State vibrationIntensity:string = 'ohos'
  @Builder My(){
    Column({space:5}) {
      Image(this.barIndex === 1? $r("app.media.my1"): $r("app.media.my")).size({width:25,height:25})
      Text('我').fontSize(16).fontColor(this.barIndex === 1?"#2AEFCC":Color.White)
    }.height('100%')
    .width("100%")
    .onClick(()=>{
      this.barIndex = 1
      this.controller.changeIndex(this.barIndex);
    })
  }
  @Builder Discover(){
    Column({space:5}) {
      Image(this.barIndex === 0 ? $r("app.media.discover1"): $r("app.media.discover")).size({width:25,height:25})
      Text('发现').fontSize(16).fontColor(this.barIndex === 0?"#2AEFCC":Color.White)
    }.height('100%')
    .width("100%")
    .onClick(()=>{
      this.barIndex = 0
      this.controller.changeIndex(this.barIndex);
    })
  }
  build() {
    Tabs({
      barPosition: BarPosition.End, // 设置Tab在下方
      controller: this.controller
    }) {
      TabContent() {
        DisplayPage({
          vibrationIntensity:$vibrationIntensity
        })
      }.tabBar(this.Discover())
      TabContent() {
        Column({space:100}){
          Column({space:50}) {
            Image($r("app.media.icon5")).objectFit(ImageFit.ScaleDown).height("50%").width("50%")
            Text("欢迎使用OHOS触觉反馈").fontColor(Color.White).fontSize(20).width("100%").height("10%")
              .textAlign(TextAlign.Center)
          }.height("30%").width("100%").justifyContent(FlexAlign.Center)
         Column({space:20}) {
           SelectorIndex({
             vibrationIntensity:$vibrationIntensity
           })
          }.height("5%").alignItems(HorizontalAlign.Center)
        }
          .width('100%')
          .height('100%')
          .backgroundColor('#f2191a32')
      }.tabBar(this.My())
    }.backgroundColor('#e6191a32')
    .onChange((index: number) => {  // 页面切换回调
      this.barIndex = index;
    })
  }
}