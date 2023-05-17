import router from '@ohos.router'

@Entry
@Component
struct VideoListPage {


  build() {
    Column({space:20}) {
      Row(){
        Button({type:ButtonType.Normal}) {
          Text("<")
            .fontColor(Color.White)
            .fontSize(28)
        }.backgroundColor('#00191a32').padding({left:5}).layoutWeight(1)
        .onClick(()=>{
          router.pushUrl({
            url:'pages/Index'
          })
        })
        Text("触感效果视频").fontColor(Color.White).fontSize(24).layoutWeight(7)
          .padding({right:10})
      }.padding({top:5})
      Column({space:20}) {
        List({space:10}) {
          ListItem() {
            Row() {
              Image($r("app.media.mate50Image")).width("50%").height(100).borderRadius(10)
              Column() {
                Text("mate50").fontSize(18).fontColor(Color.White)
                Text("难以置信 Mate相信").fontSize(16).fontColor("#ff837979")
              }.alignItems(HorizontalAlign.Start).padding({ left: 5 }).height(100)
            }.width("95%").padding({ left: 10 }).backgroundColor("#00002222")
            .onClick(() => {
              router.pushUrl({
                url:"pages/VideoPage",
                params:{
                  vibrateFileName:"mate50_audio_decomposition_ohos.json",
                  videoName:'mate50',
                  videoSrc: $r("app.media.mate50"),
                  previewUri: $r("app.media.mate50Image"),
                  pages:"VideoListPage"
                }
              })
            })
          }
        } .listDirection(Axis.Vertical)
        .divider({ strokeWidth: 10, color: "#00f3f3f3", startMargin: 20, endMargin: 20 })
        .height("60%")
      }
    }.width('100%').height('100%').backgroundColor('#f2191a32')

  }
}