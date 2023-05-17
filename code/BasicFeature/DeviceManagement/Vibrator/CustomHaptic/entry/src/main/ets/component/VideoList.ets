import router from '@ohos.router'
import {changeOrientation,hideTitleBar} from '../moudle/util'
@Component
export default struct VideoListLayout {
  @State playDis:boolean = false
  build(){
    Scroll(){
      Row({space:10}) {
        Stack(){
          Image($r("app.media.mate50Image")).width("100%").height("100%").borderRadius(10)
          Image($r("app.media.player2")).width("30%").height("30%")
            .visibility(this.playDis ? Visibility.Hidden:Visibility.Visible)
        }.width("95%").height("30%")
        .onClick(()=>{
          this.playDis = true
          router.pushUrl({
            url:"pages/VideoPage",
            params:{
              vibrateFileName:"mate50_audio_decomposition_ohos.json",
              videoName:'mate50',
              videoSrc: $r("app.media.mate50"),
              previewUri: $r("app.media.mate50Image"),
              pages:"Index"
            }
          })
        }).padding({left:10})
      }
    }.scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off)
  }
}