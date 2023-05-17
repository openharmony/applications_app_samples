import vibrator from '@ohos.vibrator';
import media from '@ohos.multimedia.media'
import Window from '@ohos.window'




export function getDynamicStates(dis:boolean[],id:number):boolean[]{
  for(let i = 0; i<dis.length;i++){
      i == id ?dis[i] = true : dis[i] = false
  }
  let display = dis
  for(let i in display) {
    console.info(display[i].toString())
  }
  return display
}

export  class VibrateCustom {
  type:"custom";
  fd:number;
  offset:number;
  length:number;
}

export async function PlayVibrateCustom(fileName:string) {
  var vibrateCustom : VibrateCustom = new VibrateCustom();
  await getContext().resourceManager.getRawFd(fileName).then((value)=>{
    vibrateCustom.type = "custom";
    vibrateCustom.fd = value.fd;
    vibrateCustom.offset = value.offset;
    vibrateCustom.length = value.length;
    console.info("VibrateCustom:"+ " Type: "+vibrateCustom.type +" Fd: "+ vibrateCustom.fd + " Offset: " +
    vibrateCustom.offset + " length: " + vibrateCustom.length)
  })
  try {
    vibrator.startVibration(
                            {type:"custom", fd: vibrateCustom.fd,
                            offset:vibrateCustom.offset, length:vibrateCustom.length},
                            {usage:"unknown"},
                            (error) => {
                                        if(error) {
                                            console.info('The following custom vibration file failed');
                                        }
                                        console.info('The following custom vibration file  successful');
                            });
      } catch(error) {
                      console.info('The following custom vibration file failed' + error.code + error.message)
                      }
}
export function setAVPlayerCallback(avPlayer){
  avPlayer.reset()
  avPlayer.on('stateChange', async (state, reason) => {
    switch (state) {
      case 'idle': // 成功调用reset接口后触发该状态机上报
        console.info('state idle called')
        break;
      case 'initialized': // avplayer 设置播放源后触发该状态上报
        console.info('state initialized called ')
       /* avPlayer.surfaceId = this.surfaceID // 设置显示画面，当播放的资源为纯音频时无需设置*/
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

export async function avPlayer(audioName:string){
  let avPlayer = await media.createAVPlayer()
  setAVPlayerCallback(avPlayer)
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


export function changeOrientationInternal(lastWindow: Window.Window,portrait:boolean) {
  if (portrait) {
    // 切换成横屏
    lastWindow.setPreferredOrientation(Window.Orientation.LANDSCAPE).then(() => {
      console.log("setPreferredOrientation success")
    }).catch((error) => {
      console.log("setPreferredOrientation failure" + JSON.stringify(error))
    })
  } else {
    // 切换成竖屏
    lastWindow.setPreferredOrientation(Window.Orientation.PORTRAIT).then(() => {
      console.log("setPreferredOrientation success")
    }).catch((error) => {
      console.log("setPreferredOrientation failure: " + JSON.stringify(error))
    })
  }
}

export function changeOrientation(portrait:boolean) {
  Window.getLastWindow(getContext()).then((lastWindow) => {
    changeOrientationInternal(lastWindow,portrait)
  }).catch((error) => {
    console.log("getLastWindow error: " + JSON.stringify(error))
  })
}
export  function hideTitleBar () {
  Window.getLastWindow(getContext()).then((lastWindow)=>{
    if (lastWindow) {
      lastWindow.setWindowSystemBarEnable([],(err)=>{
        if(err){
          console.info("隐藏失败")
        }
      })
    }
  })
}

export  function showTitleBar() {
  Window.getLastWindow(getContext()).then((lastWindow)=>{
    if (lastWindow) {
      lastWindow.setWindowSystemBarEnable(['status','navigation'],(err)=>{
        if(err){
          console.info("显示失败")
        }
      })
    }
  })
}
