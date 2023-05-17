import vibrator from '@ohos.vibrator';
import media from '@ohos.multimedia.media'
import router from '@ohos.router'
import {changeOrientation,showTitleBar,PlayVibrateCustom,hideTitleBar} from '../moudle/util'
export function setAVPlayerCallback(avPlayer,surfaceID:string){
  avPlayer.reset()
  avPlayer.on('stateChange', async (state, reason) => {
    switch (state) {
      case 'idle': // 成功调用reset接口后触发该状态机上报
        console.info('state idle called')
        break;
      case 'initialized': // avplayer 设置播放源后触发该状态上报
        console.info('state initialized called ')
        avPlayer.surfaceId = surfaceID // 设置显示画面，当播放的资源为纯音频时无需设置
        avPlayer.prepare().then(() => {
          console.info('prepare success');
        }, (err) => {
          console.error('prepare filed,error message is :' + err.message)
        })
        break;
      case 'prepared': // prepare调用成功后上报该状态机
        console.info('state prepared called')
        avPlayer.play() // 调用播放接口开始播放
        break;
      case 'playing': // play成功调用后触发该状态机上报
        console.info('state playing called')
        break;
      case 'completed': // 播放结束后触发该状态机上报
        console.info('state completed called')
        avPlayer.stop() //调用播放结束接口
        avPlayer.reset()
        break;
      case 'stopped': // stop接口成功调用后触发该状态机上报
        console.info('state stopped called')
        avPlayer.release() // 调用reset接口初始化avplayer状态
        break;
      case 'error':
        console.info('state error called')
        break;
      default:
        console.info('unkown state :' + state)
        break;
    }
  })
}

export async function videoPlayer(audioName:string,surfaceID:string){
  let avPlayer = await media.createAVPlayer()
  setAVPlayerCallback(avPlayer,surfaceID)
  let fileDescriptor = undefined
  await globalThis.getContext().resourceManager.getRawFd(audioName).then((value)=>{
    fileDescriptor = {fd: value.fd, offset: value.offset, length: value.length}
    console.info(fileDescriptor.fd.toString() + " " +  fileDescriptor.offset.toString() + " " +fileDescriptor.length.toString())

  }).catch((err)=>{
    console.info(err)
  })
  avPlayer.fdSrc = fileDescriptor
  /*  let fdPath = 'fd://'
    let pathDir = "/data/storage/el2/base/files/"
    let path = pathDir  + audioName
    let file = await fs.open(path)
    fdPath = fdPath + '' + file.fd
    console.info("6666"+fdPath)
    avPlayer.url = fdPath*/
}
@Entry
@Component
struct VideoPage {
  private surfaceId : string =''
  @State  videoName:string = router.getParams()['videoName']
  private  pages:string = router.getParams()['pages']
  @State videoSrc: Resource = router.getParams()['videoSrc']
  @State previewUri: Resource = router.getParams()['previewUri']
  private vibrateFileName:string = router.getParams()['vibrateFileName']
  @State  portrait:boolean = true
  videoController: VideoController = new VideoController()

  build(){
    Stack({alignContent: Alignment.TopStart}) {
      Video({
        src : this.videoSrc,
        previewUri: this.previewUri, // 设置封面图片
        controller: this.videoController, // 设置控制器
      }).height("100%")
        .width('100%')
        .objectFit(ImageFit.Auto)
        .controls(false)//控制条显隐
        .onStart(() => {
          changeOrientation(true)
          hideTitleBar()
          PlayVibrateCustom(this.vibrateFileName)
        })
        .onClick(()=>{
          this.portrait = !this.portrait
        })
        .autoPlay(true)
      Row() {
        Button('<').fontSize(20).backgroundColor("#00222222")
          .onClick(()=>{
            changeOrientation(false)
            showTitleBar()
            vibrator.stopVibration()
            if(this.pages === "Index"){
              router.back()
            } else if (this.pages === "VideoListPage") {
              router.pushUrl({
                url:'pages/VideoListPage',
              })
              router.clear()
            }
          })
        Text(this.videoName).fontSize(18).fontColor(Color.White)
      }.width("100%").height("10%").backgroundColor('#80191a32')
      .visibility(this.portrait ? Visibility.Visible : Visibility.Hidden)
    }.width('100%').height('100%').backgroundColor('#f2191a32')
  }
}