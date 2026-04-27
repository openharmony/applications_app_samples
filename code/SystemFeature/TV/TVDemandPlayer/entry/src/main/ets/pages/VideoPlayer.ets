/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/* eslint-disable */
/* 视频播放器 */
import { media } from '@kit.MediaKit';
import { fileIo as fileio } from '@kit.CoreFileKit';
import { router, promptAction as prompt } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import { getVideoSize, getTimeStr, setScreenOrientation } from '../utils/Utils';
import { initInfo, ComEvent, Logger } from '@ohos/utilslibrary';
import { UrlType, DeviceInfoType, PlayerBtnsType, VideoSettingBtnsType, ItemsType, VideoSize } from '../const/Type';
import { BusinessError } from '@kit.BasicServicesKit';
import {
  DistributedManagerDeviceInfo,
  DistributedManager,
  DeviceType,
  AuthParam
} from '@ohos/utilslibrary/src/main/ets/DistributedManager';
import { promptAction } from '@kit.ArkUI';
import { commonEventManager } from '@kit.BasicServicesKit';
import { VideoAVPlayerClass } from '../Model/AvPlayer';
import { emitter } from '@kit.BasicServicesKit';
import { settingButton } from '../const/SettingButton';
import { screen, window } from '@kit.ArkUI';
import dlnaServiceStub from '../DlnaService/DlnaServiceStub';
import dmrnapi from '@ohos.dmrnapi'
import { inputEventClient } from '@kit.InputKit';
import { VideoControllerVertical } from '../components/VideoControllerVertical'
import { VideoSettingVertical } from '../components/VideoSettingVertical';
import { drm } from '@kit.DrmKit';
import { DrmModel } from '../Model/DrmModel';
import { PointerUtil } from '../utils/PointerUtil';
import { rpc } from '@kit.IPCKit';
import { ability, common } from '@kit.AbilityKit';
import { DistributedEventCode } from '../const/DistributedEventCode';
import { EventUtil } from '../utils/EventUtil';
import { Constants } from '../const/Constants';

let log = initInfo('VideoPlayer.ets');
let transferManager: DistributedManager | null = null;
const BUNDLENAME = 'com.ohos.demandplayer';
const ABILITYNAME = 'MainAbility';
const CACHED_DURATION_MIN = 500;
const FOCUSECOLOR = 'rgba(255,255,255,0.2)'
const BORDERADIUS = 8
const ITEM_FONT_SIZE = '24lpx'
const FOCUS_FONT_COLOR = 'rgba(255,255,255,0.86)'
const UNFOCUS_FONT_COLOR = 'rgba(255,255,255,0.4)'
const FOCUS_ICON = '60lpx'
const UNFOCUS_ICON = '55lpx'
const START_MOVE_HEIGHT = 110
const END_MOVE_HEIGHT = 30
const SETTING_ITEM_HEIGHT = 30
const SETTING_ITEM_TOP_PADDING = 10
const SETTING_ITEM_LEFT_PADDING = 20
const SETTING_ITEM_SPACE = 4
const SETTING_ITEM_WIDTH = 80

interface Params {
  startBy: string,
  videoIndex: number,
  url: string | undefined,
  currentTime: number,
  videoList: string,
  stopTransfer: boolean,
  isPlay: boolean
};

interface CommonEventErr {
  code: number;
  message: string;
  name: string;
}

let events = [
  commonEventManager.Support.COMMON_EVENT_USB_DEVICE_DETACHED,
  'usual.event.data.VOLUME_REMOVED',
  'usual.event.data.VOLUME_UNMOUNTED',
  'usual.event.data.VOLUME_BAD_REMOVAL',
  'usual.event.data.VOLUME_EJECT'
]

let innerEventFalse: emitter.InnerEvent = {
  eventId: 1,
  priority: emitter.EventPriority.HIGH
};

let preparedStateEvent: emitter.InnerEvent = {
  eventId: 2,
  priority: emitter.EventPriority.HIGH
};

@Entry
@Component
struct VideoPlayer {
  @StorageLink('videoPlayFlag') @Watch('setVideoPlay') isVideoPlay: string = '';
  @StorageLink('videoPauseFlag') @Watch('setVideoPause') isVideoPause: string = '';
  @StorageLink('changePlayFlag') @Watch('changePlay') changePlayFlag: string = ''
  @StorageLink('getSeekTimeFlag') @Watch('getSeekTime') getSeekTimeFlag: string = ''
  @StorageLink('setSeekTimeFlag') @Watch('setSeekTime') setSeekTimeFlag: string = ''
  private timeForward: number = 0;
  private timeBackward: number = 0;
  private context: common.UIAbilityContext | null = null;
  subscriber: ComEvent | null = null;
  videoFileClosed: boolean = false;
  @State videoList: Array<UrlType> = [];
  isTV: boolean = globalThis.deviceType == 'tv' ? true : false;
  mXComponentController: XComponentController = new XComponentController();
  @State surfaceId: string = '';
  minBg: Resource = $rawfile('min_bg.png');
  private localExtensionRemote: rpc.IRemoteObject | null = null;
  private timeId: number | null = null
  // 播放器控制按钮
  @State playerBtns: Array<PlayerBtnsType> = [
    {
      id: 'id_1',
      defaultImg: $rawfile('ic_stop.svg'),
      activeImg: $rawfile('ic_stop_active.svg'),
      onclick: () => {
        this.videoStop();
      }
    },
    {
      id: 'id_2',
      defaultImg: $rawfile('ic_play_last.svg'),
      activeImg: $rawfile('ic_play_last_active.svg'),
      onclick: () => {
        this.prevVideo();
      }
    },
    {
      id: 'id_3',
      defaultImg: $rawfile('ic_pause.svg'),
      activeImg: $rawfile('ic_play.svg'),
      onclick: () => {
        this.play();
      }
    },
    {
      id: 'id_4',
      defaultImg: $rawfile('ic_play_next.svg'),
      activeImg: $rawfile('ic_play_next_active.svg'),
      onclick: () => {
        this.nextVideo();
      }
    }
  ];
  // 视频设置按钮
  videoSettingBtns: VideoSettingBtnsType[] = settingButton;
  // 选中视频设置弹窗按钮
  activeSettingBtns: ItemsType[] = [];
  @State isBackPress: boolean = false;
  @State activeSettingBtnIndex: number = -1;
  @State settingBtnsShow: boolean = false; // 设置视频属性弹窗是否显示隐藏
  @State keyPressStartTime: number = 0;
  @State timeNotOperated: number = 0; // 未操作时间
  @State leftDown: boolean = false; // 左键是否按下
  @State rightDown: boolean = false; // 右键是否按下
  @State isSeekEnd: boolean = false; // 是否跳转到最后
  @State videoIndex: number = globalThis.videoIndex ? globalThis.videoIndex : 0;
  @StorageLink('screen_lpx_w') screenW: number = AppStorage.get<number>('screen_lpx_w') || 1280;
  @StorageLink('screen_lpx_h') screenH: number = AppStorage.get<number>('screen_lpx_h') || 720;
  @StorageLink('screen_px_w') pageW: number = AppStorage.get<number>('screen_px_w') || 1920;
  @StorageLink('screen_px_h') pageH: number = AppStorage.get<number>('screen_px_h') || 1080;
  @StorageLink('screen_dpi') dpi: number = AppStorage.get<number>('screen_dpi') || 2;
  @StorageLink('screen_lpi') lpi: number = AppStorage.get<number>('screen_lpi') || 1.5;
  @State barOffsetY: number = this.screenH - 30;
  @State isBarShow: boolean = false; // 底部操作栏是否显示隐藏状态
  @State videoWidth: number = AppStorage.get<number>('screen_px_w') || 1920;
  @State videoHeight: number = AppStorage.get<number>('screen_px_h') || 1080;
  @State focusId: string = this.playerBtns[0].id;
  @State activeSettingBtnId: string = '';
  @State focusResolutionItemId: string = this.videoSettingBtns[0].items[0].id; // 分辨率
  @State focusSpeedItemId: string = this.videoSettingBtns[1].items[3].id; // 倍速
  @State focusChannelItemId: string = this.videoSettingBtns[2].items[0].id; // 声道
  @State focusLanguageItemId: string = ''; // 音轨切换
  @State focusRatioItemId: string = this.videoSettingBtns[4].items[2].id; // 画面尺寸
  @State totalTimeStr: string = '00:00';
  @State currentTimeStr: string = '00:00';
  @State videoSpeed: number = 1;
  @State shouldChangeSpeed: boolean = false;
  @State intervalId: string | number | null = '';
  @State intervalTime: number = 1000;
  @StorageLink('isPlaying') isPlaying: boolean = false;
  @State isSettingBtnsBack: boolean = false;
  @State isTransferDialogShow: boolean = false; // 流转窗口显示与否
  transferDialogOpenTime: number = 0; // 流转窗口打开时间戳（非 State，避免触发重渲染）
  private transferDialogCloseTime: number = 0; // 流转窗口关闭时间，防止关闭后误触发再次打开
  private focusBeforeTransferDialog: string = ''; // 进入流转窗口前的焦点
  // 流转按钮
  transferBtn: PlayerBtnsType = {
    id: 'id_5',
    defaultImg: $rawfile('ic_hop_on.svg'),
    activeImg: $rawfile('ic_hop_on_active.svg'),
    onclick: () => {
      log('this.openTransferDialog()');
      if (this.isTransferDialogShow) {
        this.closeTransferDialog()
      } else {
        // 对话框关闭后极短时间内忽略同次按键/点击导致的重入，避免“闪一下”
        if (Date.now() - this.transferDialogCloseTime < 250) {
          return;
        }
        this.openTransferDialog();
      }
    }
  };
  // rotation button
  rotationBtn: PlayerBtnsType = {
    id: 'id_6',
    defaultImg: $rawfile('rotation.svg'),
    activeImg: $rawfile('rotation_active.svg'),
    onclick: () => {
      log('rotationBtn onClick');
      this.handleRotationClick();
    }
  };
  @State deviceList: Array<DistributedManagerDeviceInfo> = []; // 设备列表
  @State transferFocusId: string = ''; // 流转窗口聚焦ID
  transferFocusInd: number = 0; // 流转窗口聚焦设备下标（非 State，避免 onFocus 每次触发重渲染）
  @State isTransferDialogBack: boolean = false;
  @State isPlayOnce: boolean = false;
  @State playRatio: number = 0;
  @State videoLoading: boolean = false; // 是否网络加载中
  @State videoLoadingPercent: number = 0; // 网络加载中百百分比
  @State videoLoadingTimer: (number | null) = null;
  @State videoType: string = 'local'; // 视频类型 默认是本地视频
  private transferScroller: Scroller = new Scroller();
  private focusRequestTimer: number = -1;
  private transferDialogReady: boolean = false;
  @StorageLink('avplayer') videoAVPlayerClass: VideoAVPlayerClass = AppStorage.get('avplayer') as VideoAVPlayerClass
  // @State videoAVPlayerClass: VideoAVPlayerClass  = AppStorage.get('avplayer') as VideoAVPlayerClass
  //-----------DLNA-----------------

  @State dlnaServiceStub: dlnaServiceStub = new dlnaServiceStub('OHOS.DlnaService');
  @State @Watch('sliderShow') playFlag: boolean = this.dlnaServiceStub.playFlag;
  @State durationTime: number = this.dlnaServiceStub.duration; // 视频总时长
  @State maxVolume: number = 0; // 最大音量
  @State minVolume: number = 0; // 最小音量:
  @State alterVolumeStatus: boolean = false;
  @State videoVolume: number = 0;
  @State currentTime: number = globalThis.fromDlnaAbility ? this.dlnaServiceStub.position : 0;
  @State totalTime: number = globalThis.fromDlnaAbility ? this.dlnaServiceStub.duration : 0;
  private jiazaiTime: number = 0
  @State isScreenClick: boolean = false;
  positionCallback = (durationTime: number, currentTime: number) => {
    this.totalTime = durationTime
    this.currentTime = currentTime
  }
  statusCallback = (playFlag: boolean) => {
    this.playFlag = playFlag
  }
  volumeCallback = (volume: number, maxVolume: number) => {
    this.videoVolume = volume
    this.maxVolume = maxVolume
  }
  @StorageLink('IP') IP: string | null = null
  @State pageHide: boolean = true
  @State screenOrientation: screen.Orientation = screen.Orientation.HORIZONTAL;
  @State isScreenVertical: boolean = false;
  @State isBarFirstAppear: boolean = true;
  @State videoRotationAngle: number = 0; // 添加视频旋转角度状态变量
  drmModel: DrmModel = new DrmModel();
  @State displayName: string | Resource = '';
  @StorageLink('subtitles') subtitle: string = '';
  @State isBackQuitPlay: boolean = false;
  private lastPlayActionTime: number = 0;

  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
  }

  existApp() {
    console.info('Click the callback in the blank area')
  }

  //播放界面
  pop() {
  }

  sliderShow(): void {
    this.isPlaying = this.playFlag;
  }

  connectLocalExtension() {
    console.log('666666appera')
    let localServiceWant: Want = {
      bundleName: 'com.ohos.demandplayer',
      abilityName: 'ServiceAbility',
    };
    let connectOptions: ability.ConnectOptions = {
      onConnect: (elementName, remote) => {
        this.localExtensionRemote = remote;
        globalThis.localExtensionRemote = remote
        Logger.info(`onConnect called elementName is ${JSON.stringify(elementName)}`);
      },
      onDisconnect: (elementName) => {
        if (this.context !== null) {
          Logger.info(`OnDisconnect called elementName is ${JSON.stringify(elementName)}`);
        }
      },
      onFailed: (code) => {
        Logger.info(`666666OnFailed called code is ${JSON.stringify(code)}`);
        if (this.context !== null) {
          Logger.info(`OnFailed called code is ${JSON.stringify(code)}`);
        }
      }
    };
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext; // UIAbilityContext
    context.connectServiceExtensionAbility(localServiceWant, connectOptions);
  };

  async aboutToAppear() {

    if (globalThis.fromDlnaAbility) {

      dmrnapi.ResgisterDlnaPlayerAsync(this.dlnaServiceStub)
      dmrnapi.RegisterRemoteDiedListener()
      this.dlnaServiceStub.setStatusCallback(this.statusCallback, this.positionCallback, this.volumeCallback)
      this.isPlaying = true
      this.tabStartClick()
    } else {

      this.isTV = globalThis.deviceType == 'tv' ? true : false;
      this.videoIndex = globalThis.videoIndex;
      this.videoList = AppStorage.get('video_list') as UrlType[] | [];
      this.isPlaying = globalThis.isPlay
      if (this.videoList && this.videoList[0] && this.videoList[0].type == 'http') {
        if (this.playerBtns.length == 4) {
          this.playerBtns.push(this.transferBtn);
        }
        this.initTransferManager();
      }
      this.playerBtns.push(this.rotationBtn);
      log('aboutToAppear isTransferData:' + globalThis.isTransferData);
      if (globalThis.isTransferData || globalThis.startByOther || globalThis.startByLauncher) {
        this.initStateData();
      }

      this.subscriber = new ComEvent(events, (err: CommonEventErr, data: Record<string, string>) => {
        this.closeFile('usbout');
        this.videoAVPlayerClass.avPlayer?.release().then(() => {
          log(`avPlayer release success`)
        });
        promptAction.showToast({
          message: 'U盘被移除',
          duration: 2000,
          bottom: `${px2vp(this.pageH - 300) / 2}`
        })
      })
    }
    // 循环监测操作间隔时间
    this.timeId = setInterval(() => {
      if (this.isPlaying) {
        this.timeNotOperated++
      } else {
        this.timeNotOperated = 0
      }
      if (this.isTransferDialogShow || this.settingBtnsShow) {
        this.timeNotOperated = 0
      }
      if (this.timeNotOperated == 4) {
        this.timeNotOperated = 0;
        if (this.settingBtnsShow) {
          this.settingBtnsShow = false;
        }
        if (this.barOffsetY != this.screenH) {
          this.barOffsetY = this.screenH;
          PointerUtil.changePointVisible(false);
        }
        if (this.isBarShow) {
          this.isBarShow = false;
          focusControl.requestFocus(this.focusId)
        }
      }
    }, 1000)
    this.connectLocalExtension()
    log('aboutToAppear')
  }

  tabStartClick() {
    let keyDown: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyUp: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };

    try {
      // 触发tab点击，使默认焦点组件多态样式生效
      inputEventClient.injectEvent({ KeyEvent: keyDown });
      inputEventClient.injectEvent({ KeyEvent: keyUp });
    } catch (e) {
      console.log('tab key event click false')
    }
  }

  aboutToDisappear() {
    if (!globalThis.fromDlnaAbility) {
      this.clearVideoPlayer();
      this.subscriber?.unsubscribe(() => {
        this.subscriber = null;
      })
      try {
        this.closeFile('pageout');
      } catch (err) {
        err('closeFile err: ' + JSON.stringify(err))
      }
      this.initStateData();
      if (transferManager) {
        transferManager.stopScan()
      }
      log('aboutToDisappear')
    }
  }

  closeFile(type: string) {
    let deviceType: number | undefined
    try {
      deviceType = this.videoList[this.videoIndex]?.deviceType;
    } catch (err) {
      err('catch videoList deviceType err: ' + JSON.stringify(err))
    }
    if (deviceType == 6 && !this.videoFileClosed) {
      let fd: string = ''
      if (this.videoAVPlayerClass.avPlayer?.url) {
        fd = this.videoAVPlayerClass.avPlayer?.url.replace('fd://', '');
      }
      try {
        log(`closeFile file try`)
        fileio.close(Number(fd), () => {
          this.videoFileClosed = true;
          log(`closeFile file end`);
        })
        if (type == 'usbout') {
          router.back({
            url: 'pages/LocalFolderList'
          })
        }
      } catch (e) {
        log(`close file catch:${JSON.stringify(e)}`);
      }
    }
  }

  initStateData() {
    this.videoLoading = false;

    this.totalTime = 0;
    this.totalTimeStr = '00:00';
    this.currentTimeStr = '00:00';

    this.activeSettingBtns = [];
    this.activeSettingBtnIndex = -1;

    this.settingBtnsShow = false;
    this.isSettingBtnsBack = false;

    this.barOffsetY = this.screenH - END_MOVE_HEIGHT;
    this.isBarShow = false;

    this.activeSettingBtnId = '';
    this.focusResolutionItemId = this.videoSettingBtns[0].items[0].id; // 分辨率
    this.focusSpeedItemId = this.videoSettingBtns[1].items[3].id; // 倍速
    this.focusChannelItemId = this.videoSettingBtns[2].items[0].id; // 声道
    this.focusLanguageItemId = ''; // 音轨切换
    this.focusRatioItemId = this.videoSettingBtns[4].items[2].id; // 画面尺寸

    this.keyPressStartTime = 0;
    this.timeNotOperated = 0;
    this.leftDown = false;
    this.rightDown = false;
    this.isSeekEnd = false;
  }

  // 单独处理返回按键
  onBackPress() {
    if (!this.isBackPress) {
      return true;
    }
    log(`onBackPress this.isSettingBtnsBack1:${this.isSettingBtnsBack}`);
    // 设置弹窗返回播放界面
    if (this.isSettingBtnsBack || this.settingBtnsShow) {
      this.isSettingBtnsBack = false;
      this.settingBtnsShow = false;
      focusControl.requestFocus(this.focusId);
      return true;
    }
    log(`onBackPress this.isTransferDialogBack:${this.isTransferDialogBack}`);
    // 分布式设备弹窗返回播放界面
    if (this.isTransferDialogBack || this.isTransferDialogShow) {
      this.isTransferDialogBack = false;
      this.closeTransferDialog(true);
      return true;
    }
    this.isBackQuitPlay = true;
    // 返回的时候立即停止播放
    this.quitPlay();
    return false;
  }

  initTransferManager() {
    if (!transferManager) {
      transferManager = globalThis.transferManager;
      if (transferManager) {
        this.deviceList = transferManager.deviceList as DistributedManagerDeviceInfo[];
        transferManager.onDeviceListChange((data: DistributedManagerDeviceInfo[]) => {
          log('transferManager.onDeviceListChange deviceList:' + JSON.stringify(data));
          this.deviceList = data;
          this.updateTransferFocusId()
        });
      }
    }
  }

  onPageShow() {
    setTimeout(() => {
      this.isBackPress = true
    }, 500)
    this.isBackQuitPlay = false;
    this.startRenderFrame()
    if (this.videoList && this.videoList[0] && this.videoList[0].type == 'http') {
      this.initTransferManager();
    }
    emitter.on(innerEventFalse, (res: emitter.EventData) => {

      if (res.data && res.data.flag) {
        this.nextVideo()
      }
      ;
    });
    log(`onPageShow`)

    emitter.on(preparedStateEvent, () => {
      if (this.videoList && this.videoIndex >= 0 && this.videoIndex < this.videoList.length) {
        this.displayName = this.videoList[this.videoIndex].displayName || '';
      } else {
        this.displayName = '';
      }

      this.timeNotOperated = 0;

      this.videoLoading = false; // 视频准备就绪时隐藏加载动画
      // 视频准备就绪后，重新计算视频尺寸
      log(`[VIDEO_ROTATION] === 视频准备就绪，重新计算尺寸 ===`, Date.now());
      if (this.videoAVPlayerClass.avPlayer) {
        let originalWidth = this.videoAVPlayerClass.avPlayer.width;
        let originalHeight = this.videoAVPlayerClass.avPlayer.height;
        log(`[VIDEO_ROTATION] 新视频原始尺寸: ${originalWidth}x${originalHeight}`);
        log(`[VIDEO_ROTATION] 当前旋转角度: ${this.videoRotationAngle}`);

        // 重新计算视频尺寸
        let newSize = this.calculateRotatedVideoSize();
        log(`[VIDEO_ROTATION] 重新计算后的尺寸: ${newSize.width}x${newSize.height}`);

        this.videoWidth = newSize.width;
        this.videoHeight = newSize.height;

        // 更新Surface尺寸
        if (this.surfaceId) {
          log(`[VIDEO_ROTATION] 更新Surface尺寸: ${newSize.width}x${newSize.height}`);
          this.mXComponentController.setXComponentSurfaceRect({
            surfaceWidth: newSize.width,
            surfaceHeight: newSize.height
          });
        }
      }
      this.showPlayerBtns();
    })

    // 恢复默认倍速
    let t = this.videoSettingBtns[1].items[3]
    this.focusSpeedItemId = t.id
    this.videoAVPlayerClass.setSpeed(t)
    let startByOtherApp =
      AppStorage.get('startByOtherApp') ? AppStorage.get('startByOtherApp') as boolean : false
    if (startByOtherApp) {
      this.tabClick()
    }

  }

  tabClick() {
    let keyDownOpt: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyUpOpt: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };

    class KeyEventWrapper {
      public keyEvent: inputEventClient.KeyEvent | null = null
    }

    let eventDown: KeyEventWrapper = { keyEvent: keyDownOpt }
    let eventUp: KeyEventWrapper = { keyEvent: keyUpOpt }

    try {
      // 触发tab点击，使默认焦点组件多态样式生效
      inputEventClient.injectEvent({ KeyEvent: eventDown });
      inputEventClient.injectEvent({ KeyEvent: eventUp });
    } catch (err) {
      console.error('settingList inputEventClient' + err)
    }
  }

  onPageHide() {
    if (this.timeId) {
      clearInterval(this.timeId)
      this.timeId = null
    }
    PointerUtil.changePointVisible(true);
    log(`onPageHide this.isPlaying:${this.isPlaying}`)
    if (!this.isBackQuitPlay) {
      this.quitPlay();
    }
    // 字幕置空
    this.subtitle = ''
  }

  async quitPlay() {
    const avPlayer = this.videoAVPlayerClass.avPlayer;
    if (this.isPlaying) {
      if (avPlayer) {
        await avPlayer.pause();
      }
      if (this.isVideoPause == '') {
        this.sendMessagePause();
      }
      this.isPlaying = false;
      this.isVideoPlay = ''
      this.isVideoPause = ''
    }
  }

  // 释放播放器
  clearVideoPlayer() {
    if (this.videoAVPlayerClass.avPlayer) {
      this.videoAVPlayerClass.avPlayer.pause();
      this.drmModel.releaseDrm();
    }
  }

  getSeekTime() {
    if (this.getSeekTimeFlag == 'get') {
      this.getSeekTimeFlag = ''
      let sendOption = new rpc.MessageOption()
      let sendData = new rpc.MessageSequence()
      let sendReply = new rpc.MessageSequence()
      let seekTime = this.videoAVPlayerClass.avPlayer?.currentTime
      sendData.writeString(`${seekTime}`)
      this.localExtensionRemote?.sendMessageRequest(
        DistributedEventCode.SYNC_PLAYER_TIME_SERVICE_REPLAY, sendData, sendReply, sendOption
      )
    }
  }

  setSeekTime() {
    if (this.setSeekTimeFlag != '') {
      let seekTime = Number(this.setSeekTimeFlag)
      this.setSeekTimeFlag = ''
      this.videoAVPlayerClass.seekVideo(seekTime)
      console.log('HmLog--> end');
    }
  }

  async setVideoPlay() {
    console.log('HmLog-->videoPlayer in');
    if (this.isVideoPlay == 'play') {
      this.play()
    }
  }

  async setVideoPause() {
    console.log('HmLog-->videoPause in');
    if (this.isVideoPause == 'pause') {
      this.play()
    }
  }

  changePlay() {
    if (this.changePlayFlag == 'PRE') {
      console.log('HMLog-->PRE')
      this.prevVideo()
    } else if (this.changePlayFlag == 'NEXT') {
      console.log('HMLog-->NEXT')
      this.nextVideo()
    }
  }

  sendMessagePlay() {
    let data = new rpc.MessageSequence();
    let option = new rpc.MessageOption();
    let reply = new rpc.MessageSequence();
    this.localExtensionRemote?.sendMessageRequest(DistributedEventCode.PLAY_PLAYER_SERVICE, data, reply, option)
  }

  sendMessagePause() {
    let data = new rpc.MessageSequence();
    let option = new rpc.MessageOption();
    let reply = new rpc.MessageSequence();
    this.localExtensionRemote?.sendMessageRequest(DistributedEventCode.PAUSE_PLAYER_SERVICE, data, reply, option)
  }

  // 播放
  async play() {
    let now: number = Date.now();
    if (now - this.lastPlayActionTime < 200) {
      return;
    }
    this.lastPlayActionTime = now;
    log('===play this.isPlaying:' + this.isPlaying, Date.now());
    this.videoLoading = false;
    if (!this.isPlaying) {
      if (this.isVideoPlay == '') {
        this.sendMessagePlay();
      }
      if (this.videoAVPlayerClass.avPlayer) {
        await this.videoAVPlayerClass.avPlayer.play();
      }
      this.isPlaying = true;
    } else {
      if (this.isVideoPause == '') {
        this.sendMessagePause();
      }
      if (this.videoAVPlayerClass.avPlayer) {
        await this.videoAVPlayerClass.avPlayer.pause();
      }
      this.isPlaying = false;
      this.showPlayerBtns();
    }
    this.isVideoPlay = ''
    this.isVideoPause = ''
  }

  mediaKeySystemInfoUpdate() {
    this.videoAVPlayerClass?.avPlayer?.on('mediaKeySystemInfoUpdate',
      async (mediaKeySystemInfo: drm.MediaKeySystemInfo[]) => {
        log('mediaKeySystemInfoUpdate start');
        let ret = await this.drmModel.handleMediaKeySystemInfo(this.videoAVPlayerClass?.avPlayer!,
          mediaKeySystemInfo, this.videoList[this.videoIndex]);
        log('mediaKeySystemInfoUpdate end, ret:' + ret);
        if (!ret) {
          promptAction.showToast({ message: $r('app.string.drm_play_failed') })
          this.videoStop();
        }
      })
  }

  // 播放加载中
  bufferingUpdate() {
    if (this.videoAVPlayerClass.avPlayer) {
      this.videoAVPlayerClass.avPlayer.on('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
        switch (infoType) {
          case media.BufferingInfoType.CACHED_DURATION:
            if (!this.isPlaying || this.videoLoading) {
              return;
            }
            let avPlayer = this.videoAVPlayerClass.avPlayer;
            if (!avPlayer) {
              log(`no avplayer`);
              return;
            }
            if (value < CACHED_DURATION_MIN && avPlayer.state === 'playing') {
              avPlayer.pause();
              this.videoLoadingPercent = 0;
              this.videoLoading = true;
              log('bufferingUpdate pause, value:' + value + ' time:' + avPlayer.currentTime + '/' + avPlayer.duration);
              setTimeout(() => {
                if (!this.isPlaying) {
                  return
                }
                this.videoLoading = false;
                avPlayer?.play();
                log('bufferingUpdate play');
              }, CACHED_DURATION_MIN + 1000);
            }
            break;
        }
      })
    }
  }

  // 首帧渲染时取消加载动画
  startRenderFrame() {
    if (this.videoAVPlayerClass?.avPlayer) {
      this.videoAVPlayerClass.avPlayer.off('startRenderFrame');
      this.videoAVPlayerClass.avPlayer.on('startRenderFrame', () => {
        this.videoLoading = false
      })
    }
  }

  // 视频播放器监听事件
  error() {
    if (this.videoAVPlayerClass.avPlayer) {
      this.videoAVPlayerClass.avPlayer.off('error');
      this.videoAVPlayerClass.avPlayer.on('error', (error: BusinessError) => {
        console.log('yjy 111111111 videoPlayer:', JSON.stringify(error));
        console.error('hmlog==>', `avPlayer encountered an error:`, error.message);
        if (error.message.includes('IO Error')) {
          promptAction.showToast({ message: '视频播放错误' })
          this.videoAVPlayerClass.avPlayer!.reset((err: BusinessError) => {
            if (err == null) {
              console.info('yjy 111111111 reset success');
              setTimeout(() => {
                router.back()
              }, 1000)
            } else {
              console.error('yjy 111111111 reset filed,error message is :' + err.message)
            }
          })
        } else if (error.code == 5400106) {
          promptAction.showToast({ message: '播放错误' })
          this.videoAVPlayerClass.avPlayer!.reset((err: BusinessError) => {
            if (err == null) {
              console.info('yjy 111111111 reset success');
              setTimeout(() => {
                router.back()
              }, 1000)
            } else {
              console.error('yjy 111111111 reset filed,error message is :' + err.message)
            }
          })
        }
      });
    }
  }

  // 切换视频
  changePlayVideo(resetRotation: boolean = true) {
    console.log('====11changePlayVideo', this.videoLoading, Date.now())
    log(`[VIDEO_ROTATION] === 切换视频 ===`);
    log(`[VIDEO_ROTATION] 视频索引: ${this.videoIndex}`);
    log(`[VIDEO_ROTATION] 当前旋转角度: ${this.videoRotationAngle}`);
    log(`[VIDEO_ROTATION] 是否重置旋转: ${resetRotation}`);
    log(`[VIDEO_ROTATION] 当前videoWidth: ${this.videoWidth}, videoHeight: ${this.videoHeight}`);
    log(`[VIDEO_ROTATION] 屏幕尺寸 pageW: ${this.pageW}, pageH: ${this.pageH}`);

    this.initStateData();
    this.timeForward = 0;
    this.timeBackward = 0;
    this.videoLoading = true;
    this.totalTime = 0;
    this.currentTime = 0;
    this.totalTimeStr = '00:00';
    this.currentTimeStr = '00:00';
    this.isPlaying = true;
    this.playFlag = true;
    this.playRatio = 6;
    this.videoSpeed = 1;
    if (
      this.videoList && this.videoList.length > 0 && this.videoIndex >= 0 && this.videoIndex < this.videoList.length
    ) {
      this.displayName = this.videoList[this.videoIndex].displayName || this.videoList[this.videoIndex].name || '';
    } else {
      this.displayName = ''; // 或者默认值
    }


    if (resetRotation) {
      this.videoRotationAngle = 0;
      log(`[VIDEO_ROTATION] 重置旋转角度为0`);

      // 重置旋转角度时，先重置视频尺寸为默认值
      // 实际尺寸会在preparedStateEvent中重新计算
      this.videoWidth = this.pageW;
      this.videoHeight = this.pageH;
      log(`[VIDEO_ROTATION] 重置视频尺寸为默认值: ${this.videoWidth}x${this.videoHeight}`);
    } else {
      log(`[VIDEO_ROTATION] 保持当前旋转角度: ${this.videoRotationAngle}`);
    }

    log(`[VIDEO_ROTATION] === 视频重置后 ===`);
    log(`[VIDEO_ROTATION] 重置后旋转角度: ${this.videoRotationAngle}`);
    log(`[VIDEO_ROTATION] 重置后videoWidth: ${this.videoWidth}, videoHeight: ${this.videoHeight}`);

    if (this.videoList && this.videoList[this.videoIndex] && this.videoList[this.videoIndex].type == '') {
      this.bufferingUpdate();
      this.mediaKeySystemInfoUpdate();
    }
    this.error();
    this.timeUpdate();
    this.getTotalTime();

    this.focusResolutionItemId = this.videoSettingBtns[0].items[2].id


    // }

    log(`[VIDEO_ROTATION] === 开始播放视频 ===`);
    if (this.videoList && this.videoList[this.videoIndex] && this.videoList[this.videoIndex].url) {
      this.videoAVPlayerClass?.play(this.videoList[this.videoIndex].url as string);
    } else {
      promptAction.showToast({ message: $r('app.string.list_error') })
    }


    this.isPlaying = true;
    this.changePlayFlag = ''

    log(`[VIDEO_ROTATION] === 切换视频完成 ===`, Date.now());
  }

  // 上一个视频
  prevVideo() {
    if (this.videoIndex == 0) {
      this.videoIndex = this.videoList.length - 1;
    } else {
      this.videoIndex -= 1;
    }
    // 重置播放速度到1倍速
    this.videoSpeed = 1;
    // 重置播放器中的播放速度
    if (this.videoAVPlayerClass?.avPlayer) {
      this.videoAVPlayerClass.avPlayer.setSpeed(1.0);
    }
    // 重置UI中的倍速选择
    let speedItem = this.videoSettingBtns[1].items.find(item => item.param === 1);
    if (speedItem) {
      this.focusSpeedItemId = speedItem.id;
    }
    let data = new rpc.MessageSequence();
    let option = new rpc.MessageOption();
    let reply = new rpc.MessageSequence();
    if (this.changePlayFlag == '') {
      this.localExtensionRemote?.sendMessageRequest(DistributedEventCode.PRE_PLAYER_SERVICE, data, reply, option)
    }
    this.changePlayVideo(true); // 切换视频时重置旋转角度
  }

  // 下一个视频
  nextVideo() {
    if (this.videoIndex == (this.videoList.length - 1)) {
      this.videoIndex = 0;
    } else {
      this.videoIndex += 1;
    }
    // 重置播放速度到1倍速
    this.videoSpeed = 1;
    // 重置播放器中的播放速度
    if (this.videoAVPlayerClass?.avPlayer) {
      this.videoAVPlayerClass.avPlayer.setSpeed(1.0);
    }
    // 重置UI中的倍速选择
    let speedItem = this.videoSettingBtns[1].items.find(item => item.param === 1);
    if (speedItem) {
      this.focusSpeedItemId = speedItem.id;
    }
    if (this.changePlayFlag == '') {
      let data = new rpc.MessageSequence();
      let option = new rpc.MessageOption();
      let reply = new rpc.MessageSequence();
      this.localExtensionRemote?.sendMessageRequest(DistributedEventCode.NEXT_PLAYER_SERVICE, data, reply, option)
    }
    this.changePlayVideo(true); // 切换视频时重置旋转角度
  }

  timeUpdate() {
    this.videoAVPlayerClass?.avPlayer?.off('timeUpdate');
    this.videoAVPlayerClass?.avPlayer?.on('timeUpdate', (time: number) => {
      this.currentTime = time;
    })
  }

  getTotalTime() {
    this.videoAVPlayerClass?.avPlayer?.off('durationUpdate');
    this.videoAVPlayerClass?.avPlayer?.on('durationUpdate', (duration: number) => {
      this.totalTime = duration
    })
  }

  //http网络播放
  async onLoadXComponent() {
    this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
    this.videoAVPlayerClass.setAVPlayerCallback(this.surfaceId, (audioTrackList: ItemsType[]) => {
      this.videoSettingBtns[3].items = audioTrackList
      this.focusLanguageItemId = audioTrackList[0]?.id || ''
    })
  }

  //停止播放
  videoStop() {
    if (this.videoAVPlayerClass.avPlayer) {
      let data = new rpc.MessageSequence();
      let option = new rpc.MessageOption();
      let reply = new rpc.MessageSequence();
      this.localExtensionRemote?.sendMessageRequest(
        DistributedEventCode.STOP_DISTRIBUTED_PLAYER_SERVICE, data, reply, option
      )
      router.back()
    }
  }

  // 设置画面尺寸
  setDisplayRatio(data: Partial<ItemsType>) {
    if (this.videoAVPlayerClass.avPlayer) {
      let param: number = data.param ?? 6;
      this.playRatio = param as number; // 保存当前的播放比例
      let originalWidth = this.videoAVPlayerClass.avPlayer.width;
      let originalHeight = this.videoAVPlayerClass.avPlayer.height;

      let videoWidth: number;
      let videoHeight: number;

      if (this.videoRotationAngle === 90 || this.videoRotationAngle === 270) {
        // 旋转90度或270度时，原始宽高交换
        let rotatedWidth = originalHeight; // 旋转后的逻辑宽度
        let rotatedHeight = originalWidth; // 旋转后的逻辑高度

        // 计算尺寸
        let optimalSize: VideoSize;
        if (param === 6) {
          // 智能适配模式 - 较长边适应屏幕
          optimalSize = this.calculateOptimalVideoSize(rotatedWidth, rotatedHeight);
        } else {
          // 传统模式 - 使用getVideoSize
          let videoSize = getVideoSize(this.pageW, this.pageH, rotatedWidth, rotatedHeight, param, true);

          optimalSize = { width: videoSize.width, height: videoSize.height };
        }
        if (param === 6) {
          // 由于rotate(90度)会交换显示宽高，所以XComponent尺寸需要反向设置
          videoWidth = optimalSize.height; // XComponent宽度 = 计算出的高度
          videoHeight = optimalSize.width; // XComponent高度 = 计算出的宽度
        } else {
          //旋转时，XComponent尺寸不需要反向设置，直接使用计算出的尺寸
          videoWidth = optimalSize.width; // 使用计算出的宽度作为XComponent宽度
          videoHeight = optimalSize.height; // 使用计算出的高度作为XComponent高度
        }


        log(`[VIDEO_ROTATION] setDisplayRatio 旋转${this.videoRotationAngle}度: 原始${originalWidth}x${originalHeight},
          旋转后逻辑${rotatedWidth}x${rotatedHeight}, 模式${param}, 适配${optimalSize.width}x${optimalSize.height}, XComponent${videoWidth}x${videoHeight}`);
      } else {
        // 0度/180度时
        let optimalSize: VideoSize;
        if (param === 6) {
          // 智能适配模式 - 较长边适应屏幕
          optimalSize = this.calculateOptimalVideoSize(originalWidth, originalHeight);
        } else {
          // 传统模式 - 使用getVideoSize
          let videoSize = getVideoSize(this.pageW, this.pageH, originalWidth, originalHeight, param);
          optimalSize = { width: videoSize.width, height: videoSize.height };
        }
        videoWidth = optimalSize.width;
        videoHeight = optimalSize.height;
        log(`[VIDEO_ROTATION] setDisplayRatio 旋转${this.videoRotationAngle}度: 原始${originalWidth}x${originalHeight},
          模式${param}, 适配${videoWidth}x${videoHeight}`);
      }

      this.videoWidth = videoWidth;
      this.videoHeight = videoHeight;
      if (this.surfaceId) {
        this.mXComponentController.setXComponentSurfaceRect({
          surfaceWidth: videoWidth,
          surfaceHeight: videoHeight
        })
      }
    }
  }

  // 智能计算旋转后的视频尺寸 - 较长边适应屏幕原则
  calculateOptimalVideoSize(videoWidth: number, videoHeight: number): VideoSize {
    // 计算视频和屏幕的宽高比
    let videoRatio = videoWidth / videoHeight;
    let screenRatio = this.pageW / this.pageH;

    let finalWidth: number;
    let finalHeight: number;

    // 智能适配：较长边总是占满，较短边按比例缩放
    if (videoRatio > screenRatio) {
      // 视频更'宽'，宽度占满屏幕
      finalWidth = this.pageW;
      finalHeight = this.pageW / videoRatio;
    } else {
      // 视频更'高'，高度占满屏幕  
      finalHeight = this.pageH;
      finalWidth = this.pageH * videoRatio;
    }

    log(`[VIDEO_ROTATION] 智能适配: 视频${videoWidth}x${videoHeight}(${videoRatio.toFixed(2)}),
      屏幕${this.pageW}x${this.pageH}(${screenRatio.toFixed(2)}), 结果${finalWidth}x${finalHeight}`);
    return { width: Math.round(finalWidth), height: Math.round(finalHeight) };
  }

  // 计算旋转后的视频尺寸
  calculateRotatedVideoSize(): VideoSize {
    if (this.videoAVPlayerClass.avPlayer) {
      let originalWidth = this.videoAVPlayerClass.avPlayer.width;
      let originalHeight = this.videoAVPlayerClass.avPlayer.height;

      if (this.videoRotationAngle === 90 || this.videoRotationAngle === 270) {
        // 旋转90度或270度时，原始宽高交换
        let rotatedWidth = originalHeight; // 旋转后的逻辑宽度
        let rotatedHeight = originalWidth; // 旋转后的逻辑高度

        // 使用智能适配算法
        let optimalSize = this.calculateOptimalVideoSize(rotatedWidth, rotatedHeight);

        // 由于rotate(90度)会交换显示宽高，所以XComponent尺寸需要反向设置
        let displayWidth = optimalSize.height; // XComponent宽度 = 计算出的高度
        let displayHeight = optimalSize.width; // XComponent高度 = 计算出的宽度

        log(`[VIDEO_ROTATION] 旋转${this.videoRotationAngle}度: 原始${originalWidth}x${originalHeight},
          旋转后逻辑${rotatedWidth}x${rotatedHeight}, 智能适配${optimalSize.width}x${optimalSize.height}, XComponent${displayWidth}x${displayHeight}`);
        return { width: displayWidth, height: displayHeight };
      } else {
        // 0度/180度时，使用智能适配
        let optimalSize = this.calculateOptimalVideoSize(originalWidth, originalHeight);
        log(`[VIDEO_ROTATION] 旋转${this.videoRotationAngle}度: 原始${originalWidth}x${originalHeight},
          智能适配${optimalSize.width}x${optimalSize.height}`);
        return { width: optimalSize.width, height: optimalSize.height };
      }
    }
    return { width: this.videoWidth, height: this.videoHeight };
  }

  // 更新分布式设备焦点
  updateTransferFocusId() {
    if (!this.transferFocusId) {
      this.transferFocusId = this.deviceList[0] ? this.deviceList[0].deviceId : '';
      this.transferFocusInd = 0;
      this.requestTransferFocusLater(this.transferFocusId, 100);
    } else {
      let found = false;
      let newInd = 0;
      this.deviceList.forEach((t, ind) => {
        if (t.deviceId == this.transferFocusId) {
          found = true;
          newInd = ind;
        }
      });
      if (!found) {
        this.transferFocusId = this.deviceList[0] ? this.deviceList[0].deviceId : '';
        this.transferFocusInd = 0;
        this.requestTransferFocusLater(this.transferFocusId, 100);
      } else {
        this.transferFocusInd = newInd;
        // 设备仍在列表中，ForEach key 保证组件不会被重建，ArkUI 会保持焦点。
        // 此处不调用 requestFocusLater，避免定时器在用户正在 DPAD 导航时触发、
        // 将焦点拽回旧位置。
      }
    }
  }

  // 打开流转窗口
  openTransferDialog() {
    this.focusBeforeTransferDialog = this.focusId;
    this.transferFocusId = '';
    if (this.deviceList.length > 0) {
      this.transferFocusId = this.deviceList[0].deviceId;
    } else {
      this.transferFocusId = '';
    }
    this.transferFocusInd = 0;
    this.transferDialogReady = false;
    this.isTransferDialogShow = true;
    this.transferDialogOpenTime = Date.now();
    this.settingBtnsShow = false;
  }

  // 关闭流转窗口
  closeTransferDialog(restoreFocus: boolean = true) {
    // 取消所有待执行的焦点请求，避免对话框关闭后仍然触发
    if (this.focusRequestTimer !== -1) {
      clearTimeout(this.focusRequestTimer);
      this.focusRequestTimer = -1;
    }
    this.transferDialogReady = false;
    this.isTransferDialogShow = false;
    this.transferDialogCloseTime = Date.now();
    if (restoreFocus) {
      let restoreId = this.focusBeforeTransferDialog;
      if (!restoreId || restoreId == this.transferBtn.id) {
        restoreId = this.playerBtns[2].id;
      }
      this.focusId = restoreId;
      focusControl.requestFocus(restoreId);
    }
  }

  // 设备认证
  authenticateDevice(data: DistributedManagerDeviceInfo, ind: number) {
    if (transferManager) {
      let deviceInfo: DeviceInfoType = {
        deviceId: data.deviceId,
        deviceName: data.deviceName,
        deviceType: data.deviceType,
        networkId: data.networkId,
        range: data.range
      };
      let authParam: AuthParam = new AuthParam();
      authParam.authType = 1; // 认证类型：1 - 无账号PIN码认证
      data.isInAuth = true;
      transferManager.updateDeviceProp(data.deviceId, 'isInAuth', true);
      this.deviceList[ind] = data;
      transferManager.authenticateDevice(deviceInfo as Object, authParam);
      promptAction.showToast({
        message: '请在对端设备进行确认',
        duration: 3000,
        bottom: `${px2vp(this.pageH + 30) / 2}`
      })
    }
  }

  // 开始流转
  startAbility(device: DistributedManagerDeviceInfo, ind: number) {
    log(`startAbility`);
    if (!device.networkId) {
      return;
    }
    device.transferLoading = true;
    (transferManager as DistributedManager).updateDeviceProp(device.deviceId, 'transferLoading', true);
    this.deviceList[ind] = device;
    (transferManager as DistributedManager).getLocalDeviceInfo();
    let localDevice = (transferManager as DistributedManager).localDeviceInfo
    log(`device id:${device.deviceId} device trust id: ${device.trustDeviceId}`)
    log(`networkId:${device.networkId}`)
    try {
      let currentTime = 0;
      if (this.videoAVPlayerClass.avPlayer) {
        currentTime = this.videoAVPlayerClass.avPlayer.currentTime;
      }
      let urlRaw = this.videoList[this.videoIndex].url;
      let url: string | undefined = typeof urlRaw === 'string' ? urlRaw : undefined;

      let data = new rpc.MessageSequence();
      let option = new rpc.MessageOption();
      let reply = new rpc.MessageSequence();
      let params: Params = {
        startBy: 'com.ohos.demandplayer',
        videoIndex: this.videoIndex,
        url: url,
        currentTime: currentTime,
        videoList: JSON.stringify(this.videoList),
        stopTransfer: false,
        isPlay: this.isPlaying
      };
      data.writeString(localDevice?.networkId)
      data.writeString(device.networkId);
      data.writeString(JSON.stringify(params));
      try {
        console.log('6666666try')
        this.localExtensionRemote?.sendMessageRequest(
          DistributedEventCode.START_DISTRIBUTED_PLAYER_SERVICE, data, reply, option
        )
      } catch (e) {
        console.log(`try startAbility catch err:${e}`);
      } finally {
        (transferManager as DistributedManager).updateDeviceProp(device.deviceId, 'transferLoading', false);
        this.deviceList[ind] = device;
        device.isInTransfer = true;
        (transferManager as DistributedManager).updateDeviceProp(device.deviceId, 'isInTransfer', true);
      }
    } catch (e) {
      log(`try startAbility catch err:${e}`);
    }
  }

  // 结束流转
  stopTransfer(device: DistributedManagerDeviceInfo, ind: number) {
    log(`stopTransfer`);
    if (!device.networkId) {
      return;
    }
    device.transferLoading = true;
    (transferManager as DistributedManager).updateDeviceProp(device.deviceId, 'transferLoading', true);
    this.deviceList[ind] = device;
    log(`device id:${device.deviceId} device trust id: ${device.trustDeviceId}`)
    log(`networkId:${device.networkId}`)

    let data = new rpc.MessageSequence();
    let option = new rpc.MessageOption();
    let reply = new rpc.MessageSequence();
    try {
      this.localExtensionRemote?.sendMessageRequest(
        DistributedEventCode.STOP_DISTRIBUTED_PLAYER_SERVICE, data, reply, option
      )
    } catch (e) {
      console.log(`try stopTransfer catch err:${e}`);
    } finally {
      (transferManager as DistributedManager).updateDeviceProp(device.deviceId, 'transferLoading', false);
      (transferManager as DistributedManager).updateDeviceProp(device.deviceId, 'isInTransfer', false);
      this.deviceList[ind] = device;
    }

  }

  /**
   * 防抖版焦点请求：所有对流转列表的 requestFocus 都经过此方法。
   * 每次调用先取消上一次未执行的定时器，确保 ArkUI 中不会堆积多个并发的
   * requestFocus 调用。只有在对话框已渲染（transferDialogReady）后才真正执行。
   */
  requestTransferFocusLater(id: string, delay: number = 100) {
    if (this.focusRequestTimer !== -1) {
      clearTimeout(this.focusRequestTimer);
      this.focusRequestTimer = -1;
    }
    if (!id || !this.isTransferDialogShow || !this.transferDialogReady) {
      return;
    }
    this.focusRequestTimer = setTimeout(() => {
      this.focusRequestTimer = -1;
      if (this.isTransferDialogShow && id) {
        focusControl.requestFocus(id);
      }
    }, delay);
  }

  deviceOnFocus(ind: number) {
    if (!this.transferScroller) {
      return
    }
    let len = this.deviceList.length
    if (len <= 0) {
      return
    }
    // 与当前 UI 实际尺寸保持一致，避免索引越往下滚动误差累计。
    const viewHeight = 260
    const itemHeight = 65 // Stack 高度（外层 padding 不计入行高步进）
    const itemSpace = 10 // Column space
    const itemStride = itemHeight + itemSpace
    const topPadding = 10
    const bottomPadding = 10
    const contentHeight = topPadding + len * itemHeight + (len - 1) * itemSpace + bottomPadding
    const maxScrollY = Math.max(0, contentHeight - viewHeight)
    const scrollY = this.transferScroller.currentOffset().yOffset * this.dpi / this.lpi
    let yOffset = scrollY

    const focusTop = topPadding + ind * itemStride
    // 目标：让焦点条目尽量保持在可视区域中间
    const targetCenterOffset = (viewHeight - itemHeight) / 2
    yOffset = focusTop - targetCenterOffset

    yOffset = Math.max(0, Math.min(maxScrollY, yOffset))

    if (Math.abs(yOffset - scrollY) > 1) {
      this.transferScroller.scrollTo({
        xOffset: 0,
        yOffset: px2vp(lpx2px(yOffset)),
        // 快速连按时避免滚动动画叠加导致的“闪烁感”
        animation: false
      })
    }
  }

  // 拉起操作栏
  showPlayerBtns() {
    PointerUtil.changePointVisible(true);
    if (this.barOffsetY != (this.screenH - START_MOVE_HEIGHT) || !this.isBarShow) {
      focusControl.requestFocus(this.focusId)
      this.barOffsetY = this.screenH - START_MOVE_HEIGHT;
      // 延时200ms是由于操作栏显示动画为200ms
      setTimeout(() => {
        this.isBarShow = true;
      }, 200)
    }
  }

  // Dlna左右按键快进快退
  public async dlnaKeyEventLeftRight(e: KeyEvent) {
    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT || e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT) {
      e.stopPropagation();
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) { // left Down
      clearTimeout(this.timeBackward)
      dmrnapi.Pause();
      this.currentTime = Math.min(this.durationTime, this.currentTime - 10000);
      dmrnapi.Seek(this.currentTime);
      this.timeBackward = setTimeout(() => {
        dmrnapi.Play();
      }, 2000)
    } else if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) { // right Down
      clearTimeout(this.timeForward);
      dmrnapi.Pause();
      this.currentTime = Math.min(this.durationTime, this.currentTime + 10000);
      dmrnapi.Seek(this.currentTime);
      this.timeForward = setTimeout(() => {
        dmrnapi.Play();
      }, 2000)
    }
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        // 视频播放
        Row() {
          XComponent({
            id: 'componentId',
            type: XComponentType.SURFACE,
            controller: this.mXComponentController
          })
            .focusable(false)
            .zIndex(1)
            .onDestroy(() => {
              emitter.off(1)
            })
            .width(`${this.videoWidth}px`)
            .height(`${this.videoHeight}px`)
            .rotate({ angle: this.videoRotationAngle })
            .onAreaChange((oldArea, newArea) => {
              log(`[VIDEO_ROTATION] === XComponent区域变化 ===`);
              log(`[VIDEO_ROTATION] 旋转角度: ${this.videoRotationAngle}`);
              log(`[VIDEO_ROTATION] 设置尺寸: ${this.videoWidth}x${this.videoHeight}`);
              log(`[VIDEO_ROTATION] 实际区域: ${newArea.width}x${newArea.height}`);
            })
            .onLoad(() => {
              log(`[VIDEO_ROTATION] === XComponent onLoad ===`);
              log(`[VIDEO_ROTATION] XComponent尺寸: ${this.videoWidth}x${this.videoHeight}`);
              log(`[VIDEO_ROTATION] 旋转角度: ${this.videoRotationAngle}`);
              this.onLoadXComponent();
              AppStorage.setOrCreate('XComponent', this.mXComponentController)
              if (globalThis.fromDlnaAbility) {
                dmrnapi.SetSurfaceId(this.surfaceId);
                dmrnapi.Play()
              } else {
                this.changePlayVideo(false) // 重播时不重置旋转角度
              }
            })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#ff000000')
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          this.play()
        }, 10)

        // 字幕
        Flex({
          direction: FlexDirection.Row,
          wrap: FlexWrap.Wrap,
          justifyContent: FlexAlign.Center,
          alignItems: ItemAlign.End
        }) {
          Text(this.subtitle)
            .fontSize('20lpx')
            .fontColor(Color.White)
            .fontWeight(FontWeight.Regular)
            .textAlign(TextAlign.Center)
            .zIndex(100)
        }.width('100%')
        .position({ y: '92%' })

        // 加载中
        Column() {
          LoadingProgress().color('#ffffff').width('120lpx').height('100lpx')
          if (this.videoLoadingPercent > 0) {
            Text(`加载中... ${this.videoLoadingPercent}%`)
              .fontSize('16lpx')
              .fontColor('#aaffffff')
          } else {
            Text(`加载中...`)
              .fontSize('16lpx')
              .fontColor('#aaffffff')
          }
        }
        .zIndex(1)
        .width('100%')
        .height('100%')
        .backgroundColor('#4d000000')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .visibility((this.videoLoading) ? Visibility.Visible : Visibility.Hidden)

        // 暂停图标
        Column() {
          if (!this.isPlaying) {
            Image($rawfile('ic_pause.svg')).width('120lpx').height('120lpx')
          } else {
            LoadingProgress().color('#ffffff').width('120lpx').height('100lpx')
            Text(`加载中...`)
              .fontSize('16lpx')
              .fontColor('#ffffff')
          }
        }
        .zIndex(2)
        .width('100%')
        .height('100%')
        .backgroundColor('#4d000000')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .visibility(this.isPlaying ? Visibility.Hidden : Visibility.Visible)
        .onClick(() => {
          this.play()
        }, 10)

        // 视频标题
        Row() {
          Text(this.displayName)
            .textOverflow({ overflow: TextOverflow.MARQUEE })
            .maxLines(1)
            .fontColor('#ffffff')
            .fontSize('32lpx')
            .padding({ left: '30lpx' })
            .stateStyles({
              focused: {
                .border({
                  color: Color.Transparent
                })
              }
            })
        }
        .position({
          x: '0lpx',
          y: `${this.isBarShow ? 0 : -90}lpx`
        })
        .height('90lpx')
        .width(`${this.screenW}lpx`)
        .animation({
          duration: 200,
          curve: Curve.Linear
        })
        .zIndex(3)
        .backgroundColor('#c9000000')

        // 底部操作栏
        Stack({ alignContent: Alignment.Center }) {
          if (this.isScreenVertical) {
            VideoControllerVertical({
              playerBtns: this.playerBtns,
              videoSettingBtns: this.videoSettingBtns,
              currentTime: this.currentTime,
              totalTime: this.totalTime,
              screenW: this.screenW,
              isPlaying: this.isPlaying,
              focusId: this.focusId,
              isTransferDialogShow: this.isTransferDialogShow,
              settingBtnsShow: this.settingBtnsShow,
              isBarShow: this.isBarShow,
              handleControlKeyEvent: (e: KeyEvent, item: PlayerBtnsType) => {
                this.handleControlKeyEvent(e, item);
              },
              handleSettingKeyEvent: (e: KeyEvent, item: VideoSettingBtnsType, ind: number) => {
                this.handleSettingKeyEvent(e, item, ind);
              },
              handleSettingTouchEvent: (e: TouchEvent, ind: number) => {
                this.handleSettingTouchEvent(e, ind);
              }
            }).zIndex(1)
          } else {
            Column() {
              // 进度条
              Row() {
                // 当前播放时间
                Text(getTimeStr(this.currentTime || 0))
                  .fontSize('14lpx')
                  .fontColor(Color.White)
                  .width('70lpx')
                  .textAlign(TextAlign.End)
                  .padding({ right: '5lpx' })
                // 进度条
                Slider({
                  value: this.currentTime || 0,
                  min: 0,
                  max: this.totalTime,
                  style: SliderStyle.OutSet
                })
                  .focusable(false)
                  .blockSize({ width: '12lpx', height: '12lpx' })
                  .showTips(true)
                  .trackColor('#ff646a6e')
                  .selectedColor('#FFFFFF')
                  .width(`${this.screenW - 140}lpx`)
                  .height('30lpx')
                  .borderRadius('2lpx')
                  .zIndex(1)
                  .onChange((val: number) => {
                    this.showPlayerBtns()
                    this.videoAVPlayerClass.avPlayer?.seek(val)
                  })
                  .onClick((event: ClickEvent) => {
                    const sliderWidth = this.screenW - 140;
                    const clickRatio = event.x / sliderWidth;
                    const targetTime = clickRatio * this.totalTime;
                    if (targetTime >= 0 && targetTime <= this.totalTime) {
                      this.currentTime = targetTime;
                      this.videoAVPlayerClass.avPlayer?.seek(targetTime);
                    }
                  })
                // 视频总时间
                Text(getTimeStr(this.totalTime || 0))
                  .fontSize('14lpx')
                  .fontColor(Color.White)
                  .width('70lpx')
                  .textAlign(TextAlign.Start)
                  .padding({ left: '5lpx' })
              }
              .width(`${this.screenW}lpx`)
              .height('30lpx')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .margin({
                top: '10lpx'
              })

              // 操作栏和设置按钮
              Row() {
                // 停止、播放、暂停、上一个、下一个、分布式流转
                ForEach(this.playerBtns, (item: PlayerBtnsType, ind) => {
                  Stack() {
                    Row() {
                      if (ind == 2) {
                        Image(this.isPlaying
                          ?
                          item.id == this.focusId ? $rawfile('ic_pause_active.svg') : item.activeImg
                          :
                          item.id == this.focusId ? $rawfile('ic_play_active.svg') : item.defaultImg)
                          .width(item.id == this.focusId ? '60lpx' : '50lpx')
                          .height(item.id == this.focusId ? '60lpx' : '50lpx')

                      } else {
                        Image(item.id == this.focusId ? item.activeImg : item.defaultImg)
                          .width(item.id == this.focusId ? '60lpx' : '50lpx')
                          .height(item.id == this.focusId ? '60lpx' : '50lpx')

                      }
                    }
                    .zIndex(1)
                    .width('60lpx')
                    .height('60lpx')
                    .justifyContent(FlexAlign.Center)

                    Text('')
                      .zIndex(2)
                      .width('60lpx')
                      .height('60lpx')
                      .defaultFocus(item.id === this.focusId)
                      .focusable(true)
                      .focusOnTouch(true)
                      .key(item.id)
                      .id(item.id)
                      .onFocus(() => {
                        // 流转弹窗打开时，底层按钮的 onFocus 不应改变焦点状态，
                        // 否则会出现弹窗闪烁关闭和焦点落到流转按钮的问题。
                        if (this.isTransferDialogShow) {
                          return;
                        }
                        this.focusId = item.id;
                      })
                      .onKeyEvent(e => {
                        this.handleControlKeyEvent(e, item);
                      })
                      .onClick(() => {
                        item.onclick()
                      })
                  }
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
                  .width('75lpx')
                  .height('50lpx')
                  .margin({ right: '20lpx' })
                }, (item: PlayerBtnsType, ind) => {
                  return item.id + ind;
                })
                Blank()
                // 分辨率、倍速、声道、音轨切换、画面尺寸
                ForEach(this.videoSettingBtns, (item: VideoSettingBtnsType, ind) => {
                  Stack() {
                    Row() {
                      Text(`${item.name}`)
                        .fontSize(ITEM_FONT_SIZE)
                        .textAlign(TextAlign.Center)
                        .fontColor(item.id == this.focusId ? FOCUS_FONT_COLOR : UNFOCUS_FONT_COLOR)
                        .width('100lpx')
                        .height('30lpx')
                        .stateStyles({
                          focused: {
                            .border({
                              color: Color.Transparent
                            })
                          }
                        })
                    }
                    .border({
                      color: Color.Transparent,
                      radius: BORDERADIUS,
                    })
                    .zIndex(1)
                    .width('100lpx')
                    .height('38lpx')
                    .stateStyles({
                      focused: {
                        .border({
                          color: Color.Transparent
                        })
                      }
                    })
                    .alignItems(VerticalAlign.Center)
                    .justifyContent(FlexAlign.Center)


                    Text('')
                      .zIndex(2)
                      .width('100lpx')
                      .height('40lpx')
                      .focusable(true)
                      .focusOnTouch(true)
                      .defaultFocus(item.id == this.focusId)
                      .key(item.id)
                      .id(item.id)
                      .onFocus(() => {
                        this.focusId = item.id;
                        this.settingBtnsShow = false;
                      })
                      .onKeyEvent(e => {
                        this.handleSettingKeyEvent(e, item, ind);
                      })
                      .onTouch((e) => {
                        // if (e.sourceTool !== SourceTool.Pen && e.sourceTool !== Constants.SOURCE_TOOL_MOUSE_CLICK) {
                        //   return;
                        // }
                        this.handleSettingTouchEvent(e, ind);
                      })
                  }
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
                  .width('100lpx')
                  .height('40lpx')
                  .margin({
                    left: '0lpx',
                    right: '10lpx',
                    top: '5lpx',
                    bottom: '5lpx'
                  })
                }, (item: VideoSettingBtnsType, ind) => {
                  return item.id + ind;
                })
              }
              .width(`${this.screenW}lpx`)
              .padding({ left: '30lpx', right: '30lpx', bottom: '10lpx' })
              .margin({ top: '5lpx' })
              .height('60lpx')
            }
            .zIndex(1)
            .height('200lpx')
            .backgroundColor('#c9000000')
            .width(`${this.screenW}lpx`)
            .alignItems(HorizontalAlign.Start)
          }
        }
        .position({
          x: '0lpx',
          y: `${this.isScreenVertical ? 0 : this.barOffsetY}lpx`
        })
        .zIndex(3)
        .width(`${this.screenW}lpx`)
        .onAppear(() => {
          this.focusId = this.playerBtns[2].id
        })
        .animation({
          duration: 200,
          curve: Curve.Linear,
          onFinish: () => {
            if (this.barOffsetY == (this.screenH - START_MOVE_HEIGHT)) {
              this.isBarShow = true;
              if ((globalThis.startByOther && this.isBarFirstAppear) || this.isScreenVertical) {
                this.tabStartClick();
                this.isBarFirstAppear = false;
              }
              // 流转对话框打开时不抢占焦点，避免触发播放按钮 onFocus 关闭对话框
              if (!this.isTransferDialogShow) {
                this.focusId = this.playerBtns[2].id;
                let ret = focusControl.requestFocus(this.focusId);
                log('requestFocus bar, ret:' + ret);
              }
            } else {
              this.isBarShow = false;
            }
          }
        })

        if (this.settingBtnsShow) {
          // 视频设置选择栏
          if (this.isScreenVertical) {
            Column() {
              VideoSettingVertical({
                activeSettingBtns: this.activeSettingBtns || [],
                activeSettingBtnId: this.activeSettingBtnId,
                settingBtnsShow: this.settingBtnsShow,
                activeSettingBtnIndex: this.activeSettingBtnIndex,
                handleSubSettingKeyEvent: (e: KeyEvent, t: ItemsType, i: number) => {
                  this.handleSubSettingKeyEvent(e, t, i);
                },
                handleSubSettingTouchEvent: (e: TouchEvent, t: ItemsType) => {
                  this.handleSubSettingTouchEvent(e, t);
                }
              })
            }
            .zIndex(4)
            .width('100%')
            .height('100%')
            .backgroundColor('#0d000000')
            .justifyContent(FlexAlign.Start)
            .alignItems(HorizontalAlign.Center)


            .onClick(() => {
              this.settingBtnsShow = false;
            })
          } else {
            Column() {
              Column({ space: SETTING_ITEM_SPACE }) {
                ForEach(this.activeSettingBtns, (t: ItemsType, i) => {
                  Stack({ alignContent: Alignment.Center }) {
                    Row() {
                      Text(`${t.name}`)
                        .fontSize('20lpx')
                        .textAlign(TextAlign.Center)
                        // 只有一个或没有，字体直接置灰
                        .fontColor(
                          t.id == this.activeSettingBtnId && this.activeSettingBtns.length >= 2
                            ? FOCUS_FONT_COLOR
                            : UNFOCUS_FONT_COLOR
                        )
                        .width(`${SETTING_ITEM_WIDTH}lpx`)
                        .height(`${SETTING_ITEM_HEIGHT}lpx`)
                        .borderRadius(globalThis.lpiPx(6))
                    }
                    .zIndex(1)
                    .width(`${SETTING_ITEM_WIDTH}lpx`)
                    .height(`${SETTING_ITEM_HEIGHT}lpx`)
                    .alignItems(VerticalAlign.Center)
                    .justifyContent(FlexAlign.Center)

                    Text('')
                      .zIndex(2)
                      .width(`${SETTING_ITEM_WIDTH}lpx`)
                      .height(`${SETTING_ITEM_HEIGHT}lpx`)
                      .focusable(true)
                      .focusOnTouch(true)
                      .defaultFocus(t.id == this.activeSettingBtnId)
                      .key(t.id)
                      .id(t.id)
                      .onFocus(() => {
                        log(`settingBtns Text onFocus`);
                        this.activeSettingBtnId = t.id;
                      })
                      .onKeyEvent(e => {
                        this.handleSubSettingKeyEvent(e, t, i);
                      })
                      .onTouch(e => {
                        // if (e.sourceTool !== SourceTool.Pen && e.sourceTool !== Constants.SOURCE_TOOL_MOUSE_CLICK) {
                        //   return;
                        // }
                        this.handleSubSettingTouchEvent(e, t);
                      })
                  }
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
                  .width(`${SETTING_ITEM_WIDTH}lpx`)
                  .height(`${SETTING_ITEM_HEIGHT}lpx`)
                  .alignContent(Alignment.Center)
                })
              }
              .padding({
                top: `${SETTING_ITEM_TOP_PADDING}lpx`,
                bottom: `${SETTING_ITEM_TOP_PADDING}lpx`,
                left: `${SETTING_ITEM_LEFT_PADDING}lpx`,
                right: `${SETTING_ITEM_LEFT_PADDING}lpx`
              })
              .width(`${SETTING_ITEM_WIDTH + SETTING_ITEM_LEFT_PADDING * 2}lpx`)
              .height(`${this.activeSettingBtns.length * SETTING_ITEM_HEIGHT + SETTING_ITEM_TOP_PADDING * 2 +
                (this.activeSettingBtns.length - 1) * SETTING_ITEM_SPACE}lpx`)
              .backgroundColor('rgba(0,0,0,0.8)')
              .focusable(true)
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .borderRadius('8lpx')
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
              .onAppear(() => {
                focusControl.requestFocus(this.activeSettingBtnId)
              })
              .onFocus(() => {
              })
              .position({
                x: `${this.screenW - (110 * (5 - this.activeSettingBtnIndex)) - 40}lpx`,
                y: `${this.screenH - this.activeSettingBtns.length * 30 - 105}lpx`
              })
              .onTouch((e) => {
                e.stopPropagation();
              })
              .justifyContent(FlexAlign.Start)
              .alignItems(HorizontalAlign.Center)
            }
            .zIndex(4)
            .width('100%')
            .height('100%')
            .backgroundColor('#0d000000')
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)


            .onClick(() => {
              this.settingBtnsShow = false;
            })
          }
        }

        if (this.isTransferDialogShow) {
          // 视频流转窗口
          Column() {
            Column() {
              Text('分布式视频流转设备列表')
                .fontSize('24lpx')
                .width('100%')
                .fontColor('#ffd6d6d6')
                .padding({
                  left: '20lpx',
                  right: '20lpx',
                  top: '20lpx',
                  bottom: '15lpx'
                })
                .focusable(false)
                .textAlign(TextAlign.Center)
              Divider().strokeWidth(1).color('#ff47515d')
              Scroll(this.transferScroller) {
                Column({ space: '10lpx' }) {
                  ForEach(this.deviceList, (t: DistributedManagerDeviceInfo, ind) => {
                    Stack({ alignContent: Alignment.Center }) {
                      Row() {
                        Row() {
                          Text(`${ind + 1}`)
                            .fontSize(t.deviceId == this.transferFocusId ? '22lpx' : '20lpx')
                            .textAlign(TextAlign.Center)
                            .fontColor(t.deviceId == this.transferFocusId ? 'rgba(0,0,0,0.86)' :
                              'rgba(255,255,255,0.86)')
                            .width('40lpx')
                            .height('46lpx')
                          Text(t.deviceName)
                            .fontSize(t.deviceId == this.transferFocusId ? '22lpx' : '20lpx')
                            .textAlign(TextAlign.Start)
                            .fontColor(t.deviceId == this.transferFocusId ? 'rgba(0,0,0,0.86)' :
                              'rgba(255,255,255,0.86)')
                            .width('270lpx')
                            .height('46lpx')
                            .maxLines(1)
                          Blank()
                        }
                        .width(t.deviceId == this.transferFocusId ? '540lpx' : '530lpx')
                        .height('55lpx')
                        .backgroundColor(t.deviceId == this.transferFocusId ? 'rgba(255,255,255,0.86)' :
                          'rgba(255,255,255,0.2)')
                        .borderRadius(globalThis.lpiPx(12))
                      }
                      .width(t.deviceId == this.transferFocusId ? '550lpx' : '540lpx')
                      .height('65lpx')
                      .borderWidth('2lpx')
                      .borderRadius(globalThis.lpiPx(12))
                      .borderStyle(BorderStyle.Solid)
                      .borderColor(t.deviceId == this.transferFocusId ? '#ffffff' : '#0054575d')
                      .alignItems(VerticalAlign.Center)
                      .justifyContent(FlexAlign.Center)
                      .zIndex(1)


                      Row() {
                        Blank()
                        if (t.isTrust) {
                          if (t.isInTransfer) {
                            Text('流转中，点击停止流转')
                              .fontSize('16lpx')
                              .textAlign(TextAlign.Start)
                              .fontColor(t.deviceId == this.transferFocusId ? 'rgba(0,0,0,0.86)' :
                                'rgba(255,255,255,0.86)')
                              .width('200lpx')
                              .height('46lpx')
                              .padding({ right: '10lpx' })
                              .textAlign(TextAlign.End)
                              .maxLines(1)
                          } else {
                            Text('点击进行视频流转')
                              .fontSize('16lpx')
                              .textAlign(TextAlign.Start)
                              .fontColor(t.deviceId == this.transferFocusId ? 'rgba(0,0,0,0.86)' :
                                'rgba(255,255,255,0.86)')
                              .width('180lpx')
                              .height('46lpx')
                              .padding({ right: '10lpx' })
                              .textAlign(TextAlign.End)
                              .maxLines(1)
                          }
                          if (t.transferLoading) {
                            LoadingProgress()
                              .color(t.deviceId == this.transferFocusId ? 'rgba(0,0,0,0.86)' : 'rgba(255,255,255,0.86)')
                              .width('40lpx')
                              .height('40lpx')
                              .margin({ right: '10lpx' })
                          }
                        } else if (t.isInAuth) {
                          Text('设备互信中...')
                            .fontSize('16lpx')
                            .textAlign(TextAlign.Start)
                            .fontColor(t.deviceId == this.transferFocusId ? 'rgba(0,0,0,0.86)' :
                              'rgba(255,255,255,0.86)')
                            .width('180lpx')
                            .height('46lpx')
                            .padding({ right: '10lpx' })
                            .textAlign(TextAlign.End)
                            .maxLines(1)
                          LoadingProgress()
                            .color(t.deviceId == this.transferFocusId ? 'rgba(0,0,0,0.86)' : 'rgba(255,255,255,0.86)')
                            .width('40lpx')
                            .height('40lpx')
                            .margin({ right: '10lpx' })
                        } else {
                          Text('点击进行设备互信')
                            .fontSize('16lpx')
                            .textAlign(TextAlign.Start)
                            .fontColor(t.deviceId == this.transferFocusId ? 'rgba(0,0,0,0.86)' :
                              'rgba(255,255,255,0.86)')
                            .width('200lpx')
                            .height('46lpx')
                            .padding({ right: '10lpx' })
                            .textAlign(TextAlign.End)
                            .maxLines(1)
                        }
                      }
                      .width('540lpx')
                      .height('65lpx')
                      .borderRadius(globalThis.lpiPx(12))
                      .borderStyle(BorderStyle.Solid)
                      .borderColor('#00ffffff')
                      .alignItems(VerticalAlign.Center)
                      .justifyContent(FlexAlign.Center)
                      .zIndex(2)

                      Text('')
                        .zIndex(3)
                        .textAlign(TextAlign.Center)
                        .width('542lpx')
                        .height('65lpx')
                        .focusable(true)
                        .focusOnTouch(true)
                        .key(t.deviceId)
                        .id(t.deviceId)
                        .onFocus(() => {
                          log(`deviceList onFocus id:${t.deviceId}`);
                          this.transferFocusInd = ind;
                          if (this.transferFocusId !== t.deviceId) {
                            this.transferFocusId = t.deviceId;
                          }
                          this.deviceOnFocus(ind);
                        })
                        .onKeyEvent(e => {
                          let keycode = e.keyCode
                          let isStop = false;
                          // 列表边界防穿透：首项按上、末项按下时不允许把焦点弹出到播放器层
                          if (ind == 0 && keycode == KeyCode.KEYCODE_DPAD_UP) {
                            isStop = true;
                          }
                          if (ind == (this.deviceList.length - 1) && keycode == KeyCode.KEYCODE_DPAD_DOWN) {
                            isStop = true;
                          }
                          // 弹窗内左右键不应穿透到播放器层
                          if (keycode == KeyCode.KEYCODE_DPAD_LEFT || keycode == KeyCode.KEYCODE_DPAD_RIGHT) {
                            isStop = true;
                          }
                          if (isStop) {
                            e.stopPropagation();
                          }
                        })
                        .onClick(() => {
                          log(`onKeyEvent deviceList onClick`);
                          if (this.transferFocusId) {
                            let device: DistributedManagerDeviceInfo = {
                              deviceId: '',
                              deviceName: '',
                              deviceType: DeviceType.UNKNOWN_TYPE,
                              networkId: '',
                              range: -1
                            }
                            let ind = 0;
                            this.deviceList.forEach((t, i) => {
                              if (t.deviceId == this.transferFocusId) {
                                device = t;
                                ind = i;
                              }
                            });
                            if (device?.isTrust) {
                              if (device?.isInTransfer) {
                                this.stopTransfer(device, ind)
                              } else {
                                this.startAbility(device, ind)
                              }
                            } else if (!device.isInAuth) {
                              this.authenticateDevice(device, ind)
                            }
                          }
                        })
                    }
                    .width('542lpx')
                    .height('65lpx')
                    .padding('6lpx')
                    .borderRadius(globalThis.lpiPx(12))
                    .stateStyles({
                      focused: {
                        .border({
                          color: Color.Transparent
                        })
                      }
                    })
                  }, (t: DistributedManagerDeviceInfo) => t.deviceId)
                }
                .width('580lpx')
                .padding({
                  left: '20lpx',
                  right: '20lpx',
                  top: '10lpx',
                  bottom: '10lpx'
                })
              }
              .scrollBar(BarState.Off)
              .align(Alignment.Top)
              .height('260lpx')
              .width('580lpx')
              .align(Alignment.Top)

              Divider().strokeWidth(1).color('#ff47515d')
              Text('按返回键退出')
                .fontSize('16lpx')
                .width('100%')
                .fontColor('#ffcacaca')
                .padding('10lpx')
                .textAlign(TextAlign.Center)
            }
            .width('580lpx')
            .height(`370lpx`)
            .backgroundColor('#404040')
            .backgroundImageSize({ width: '100%', height: '100%' })
            .borderRadius(globalThis.lpiPx(16))
            .focusable(true)
            .onKeyEvent((e) => {
              if (e.keyCode == KeyCode.KEYCODE_F24) {
                e.stopPropagation();
                return;
              }
              log(`TransferDialog :${e.keyCode}, keyType:${e.type}`);
            })
            .onAppear(() => {
              log(`onAppear this.transferFocusId:${this.transferFocusId}`);
              // 标记对话框已渲染完成，允许 requestTransferFocusLater 发起 requestFocus
              this.transferDialogReady = true;
              // 使用防抖机制请求焦点，200ms 延迟确保子组件挂载完成
              // 若此后有 updateTransferFocusId 调用，会取消此定时器并以最新设备为准
              this.requestTransferFocusLater(this.transferFocusId, 200);
            })
            .onTouch((e) => {
              e.stopPropagation();
            })
          }
          .zIndex(5)
          .width('100%')
          .height('100%')
          .backgroundColor('#0d000000')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(() => {
            this.closeTransferDialog(true);
          })
        }
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundImage($rawfile('page_bg.png'))
    .backgroundImageSize({ width: '100%', height: '100%' })
    .focusable(true)
    .onAppear(() => {
      log(`page onAppear`);
    })
    .onFocus(() => {
      log(`page onFocus`);

    })
    .onKeyEvent((e) => {
      if (e.keyCode == KeyCode.KEYCODE_F24) {
        return
      }

      log(`page keyCode:${e.keyCode}, keyType:${e.type}`);

      this.timeNotOperated = 0;

      if (this.keyPressStartTime == 0 && e.type == KeyType.Down) {
        this.keyPressStartTime = new Date().getTime();
      }

      log(`page this.isBarShow:${this.isBarShow}`);

      if (this.isBarShow) {

      } else {
        // 流转对话框打开时，不响应操作栏和播放快捷键，避免干扰设备列表导航
        if (!this.isTransferDialogShow) {
          // 菜单键 小于1.5s拉起操作栏
          if (e.keyCode == KeyCode.KEYCODE_MENU && e.type == KeyType.Up) {
            let t = new Date().getTime();
            log(`KEYCODE_MENU press time:${t - this.keyPressStartTime}`)
            t = t - this.keyPressStartTime
            if (t < 1500) {
              this.showPlayerBtns();
            }
          }

          if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
            this.showPlayerBtns();
          }

          if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
            this.showPlayerBtns();
          }


          if (e.keyCode == KeyCode.KEYCODE_ENTER && e.type == KeyType.Up) {
            this.focusId = this.playerBtns[2].id

          }
        }
      }

      if (this.isTransferDialogShow) {
        if (e.keyCode == KeyCode.KEYCODE_BACK) {
          this.isTransferDialogBack = true;
          this.closeTransferDialog();
          e.stopPropagation();
        }
        // DPAD_UP/DOWN 由 ArkUI 自然焦点导航处理，onFocus 回调直接接受焦点变化。
        // 用户按 DPAD 时，取消 updateTransferFocusId 可能设置的待执行 requestFocus，
        // 避免设备列表更新的焦点纠正与用户导航冲突。
        if ((e.keyCode == KeyCode.KEYCODE_DPAD_UP || e.keyCode == KeyCode.KEYCODE_DPAD_DOWN) &&
          e.type == KeyType.Up) {
          if (this.focusRequestTimer !== -1) {
            clearTimeout(this.focusRequestTimer);
            this.focusRequestTimer = -1;
          }
        }

        if (e.keyCode == KeyCode.KEYCODE_ENTER && e.type == KeyType.Up) {
          // 对话框刚打开时（500ms 内）忽略 ENTER，防止打开对话框的同一次按键事件被
          // ArkUI 焦点切换后重新分发到对话框，导致误触选中第一个设备
          if (this.transferFocusId && Date.now() - this.transferDialogOpenTime >= 500) {
            let device: DistributedManagerDeviceInfo = {
              deviceId: '',
              deviceName: '',
              deviceType: DeviceType.UNKNOWN_TYPE,
              networkId: '',
              range: -1
            };
            let ind = 0;
            this.deviceList.forEach((t, i) => {
              if (t.deviceId == this.transferFocusId) {
                device = t;
                ind = i;
              }
            });
            if (device.isTrust) {
              if (device.isInTransfer) {
                this.stopTransfer(device, ind)
              } else {
                this.startAbility(device, ind)
              }
            } else if (!device.isInAuth) {
              this.authenticateDevice(device, ind)
            }
          }
          e.stopPropagation();
        }
      }

      if (this.keyPressStartTime != 0 && e.type == KeyType.Up) {
        this.keyPressStartTime = 0;
      }
    })
    .onClick(() => {
      this.timeNotOperated = 0;
      this.showPlayerBtns();
    })
    .stateStyles({
      focused: {
        .border({
          color: Color.Transparent
        })
      }
    })
  }

  handleControlKeyEvent(e: KeyEvent, item: PlayerBtnsType) {
    console.log('HmLog-->keyEvent2', `${e.keyCode} ${e.type}`)
    if (e.keyCode == KeyCode.KEYCODE_F24) {
      e.stopPropagation();
      return;
    }
    if (this.isTransferDialogShow || this.settingBtnsShow) {
      if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT || e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT) {
        e.stopPropagation();
        return;
      }
    }

    if (this.isBarShow && item.id == this.focusId && !this.settingBtnsShow &&
      !this.isTransferDialogShow) {


      if (this.leftDown || this.rightDown) {
        e.stopPropagation();
      }
    } else if (!this.isBarShow && item.id == this.focusId && !this.settingBtnsShow &&
      !this.isTransferDialogShow) {
      if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT || e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT) {
        this.barOffsetY = this.screenH - END_MOVE_HEIGHT;
      }
      if (globalThis.fromDlnaAbility) {
        this.dlnaKeyEventLeftRight(e)
      } else {
        this.videoAVPlayerClass.keyEventLeftRight(e)
      }
    }
  }

  handleSettingKeyEvent(e: KeyEvent, item: VideoSettingBtnsType, ind: number) {
    if (e.keyCode == KeyCode.KEYCODE_F24) {
      e.stopPropagation();
      return;
    }
    if (this.isTransferDialogShow || this.settingBtnsShow) {
      if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT || e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT) {
        e.stopPropagation();
        return;
      }
    }

    if (this.isBarShow && item.id == this.focusId && !this.settingBtnsShow &&
      !this.isTransferDialogShow) {
      if (e.keyCode == KeyCode.KEYCODE_ENTER && e.type == KeyType.Down) {
        if (!item.disable) {
          this.closeTransferDialog(false);
          this.settingBtnsShow = false;
          this.activeSettingBtnIndex = ind;
          this.activeSettingBtns = this.videoSettingBtns[ind].items;
          switch (ind) {
            case 0:
              this.activeSettingBtnId = this.focusResolutionItemId;
              break;

            case 1:
              this.activeSettingBtnId = this.focusSpeedItemId;
              break;

            case 2:
              this.activeSettingBtnId = this.focusChannelItemId;
              break;

            case 3:
              this.activeSettingBtnId = this.focusLanguageItemId;
              break;

            case 4:
              this.activeSettingBtnId = this.focusRatioItemId;
              break;
          }
          this.settingBtnsShow = true;
        }
        e.stopPropagation();
      }

      if (this.leftDown || this.rightDown) {
        e.stopPropagation();
      }
    } else if (!this.isBarShow && item.id == this.focusId && !this.settingBtnsShow &&
      !this.isTransferDialogShow) {
      if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT || e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT) {
        this.barOffsetY = this.screenH - END_MOVE_HEIGHT;
      }
      this.videoAVPlayerClass.keyEventLeftRight(e)
    }
  }

  handleSettingTouchEvent(e: TouchEvent, ind: number) {
    if (e.type == TouchType.Up) {
      log(`videoSettingBtns onTouch`);
      this.settingBtnsShow = false;
      this.activeSettingBtnIndex = ind;
      this.activeSettingBtns = this.videoSettingBtns[ind].items;
      this.closeTransferDialog(false);
      switch (this.activeSettingBtnIndex) {
        case 0:
          this.activeSettingBtnId = this.focusResolutionItemId;
          break;

        case 1:
          this.activeSettingBtnId = this.focusSpeedItemId;
          break;

        case 2:
          this.activeSettingBtnId = this.focusChannelItemId;
          break;

        case 3:
          this.activeSettingBtnId = this.focusLanguageItemId;
          break;

        case 4:
          this.activeSettingBtnId = this.focusRatioItemId;
          break;
      }
      setTimeout(() => {
        this.settingBtnsShow = true;
      }, 100)
    }
  }

  handleSubSettingTouchEvent(e: TouchEvent, t: ItemsType) {
    // 只有长度大于等于2时，才执行有关操作
    if (e.type == TouchType.Up) {
      log(`activeSettingBtns onTouch`);
      this.activeSettingBtnId = t.id;

      switch (this.activeSettingBtnIndex) {
        case 0:
          if (this.activeSettingBtns.length >= 2) {
            this.videoAVPlayerClass.setResolution(t);
          }
          this.focusResolutionItemId = t.id; // 分辨率
          break;

        case 1:
          if (this.activeSettingBtns.length >= 2) {
            this.videoAVPlayerClass.setSpeed(t);
          }
          this.focusSpeedItemId = t.id; // 倍速
          break;

        case 2:
          if (this.activeSettingBtns.length >= 2) {
            this.videoAVPlayerClass.setAudioChannelMode(t)
          }
          this.focusChannelItemId = t.id; // 声道
          break;


        case 3:
          if (this.activeSettingBtns.length >= 2) {
            this.videoAVPlayerClass.setAudioTracks(t, this.currentTime, this.isPlaying)
          }
          this.focusLanguageItemId = t.id; // 音轨切换
          break;

        case 4:
          this.playRatio = t.param as number;
          if (this.activeSettingBtns.length >= 2) {
            this.setDisplayRatio(t)
          }
          this.focusRatioItemId = t.id; // 画面尺寸
          break;
      }
      this.settingBtnsShow = false;
      focusControl.requestFocus(this.focusId)
    }
    e.stopPropagation();
  }

  handleSubSettingKeyEvent(e: KeyEvent, t: ItemsType, i: number) {
    if (e.keyCode == KeyCode.KEYCODE_F24) {
      e.stopPropagation();
      return;
    }
    log(`settingBtns onKeyEvent keyCode:${e.keyCode}, keyType:${e.type}`);
    let isStop = false;
    if (this.isBarShow && t.id == this.activeSettingBtnId) {
      if (e.keyCode == KeyCode.KEYCODE_ENTER && e.type == KeyType.Down) {
        isStop = true
        // 只有长度大于等于2时，才执行有关操作
        switch (this.activeSettingBtnIndex) {
          case 0:
            if (this.activeSettingBtns.length >= 2) {
              this.videoAVPlayerClass.setResolution(t);
            }
            this.focusResolutionItemId = t.id; // 分辨率
            break;

          case 1:
            if (this.activeSettingBtns.length >= 2) {
              this.videoAVPlayerClass.setSpeed(t);
            }
            this.focusSpeedItemId = t.id; // 倍速
            break;

          case 2:
            if (this.activeSettingBtns.length >= 2) {
              this.videoAVPlayerClass.setAudioChannelMode(t)
            }
            this.focusChannelItemId = t.id; // 声道
            break;

          case 3:
            if (this.activeSettingBtns.length >= 2) {
              this.videoAVPlayerClass.setAudioTracks(t, this.currentTime, this.isPlaying)
            }
            this.focusLanguageItemId = t.id; // 音轨切换
            break;

          case 4:
            this.playRatio = t.param as number;
            if (this.activeSettingBtns.length >= 2) {
              this.setDisplayRatio(t)
            }
            this.focusRatioItemId = t.id; // 画面尺寸
            break;

        }
        this.settingBtnsShow = false;
        focusControl.requestFocus(this.focusId)
        e.stopPropagation();
        return;
      }
    }
    if (i == 0 && e.keyCode == KeyCode.KEYCODE_DPAD_UP) {
      isStop = true;
    }
    if (i == (this.activeSettingBtns.length - 1) && e.keyCode == KeyCode.KEYCODE_DPAD_DOWN) {
      isStop = true;
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT || e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT) {
      isStop = true;
    }
    if (isStop) {
      e.stopPropagation();
    }
    if (e.keyCode == KeyCode.KEYCODE_BACK) {
      this.settingBtnsShow = false;
      this.isSettingBtnsBack = true;
      e.stopPropagation();
      focusControl.requestFocus(this.focusId)
      return;
    }
  }

  async handleRotationClick() {
    // 记录旋转前的状态
    log(`[VIDEO_ROTATION] === 旋转前状态 ===`);
    log(`[VIDEO_ROTATION] 当前旋转角度: ${this.videoRotationAngle}`);
    log(`[VIDEO_ROTATION] 当前videoWidth: ${this.videoWidth}, videoHeight: ${this.videoHeight}`);
    log(`[VIDEO_ROTATION] 屏幕尺寸 pageW: ${this.pageW}, pageH: ${this.pageH}`);
    if (this.videoAVPlayerClass.avPlayer) {
      log(`[VIDEO_ROTATION] 原始视频尺寸: ${this.videoAVPlayerClass.avPlayer.width}x${this.videoAVPlayerClass.avPlayer.height}`);
    }

    // 旋转视频内容
    let oldAngle = this.videoRotationAngle;
    this.videoRotationAngle = (this.videoRotationAngle + 90) % 360;

    log(`[VIDEO_ROTATION] === 旋转操作 ===`);
    log(`[VIDEO_ROTATION] 旋转角度从 ${oldAngle} 变为 ${this.videoRotationAngle}`);

    /*    // 更新视频尺寸
        let rotatedSize = this.calculateRotatedVideoSize();
        log(`[VIDEO_ROTATION] calculateRotatedVideoSize返回: ${rotatedSize.width}x${rotatedSize.height}`);

        this.videoWidth = rotatedSize.width;
        this.videoHeight = rotatedSize.height;

        log(`[VIDEO_ROTATION] === 旋转后状态 ===`);
        log(`[VIDEO_ROTATION] 新的videoWidth: ${this.videoWidth}, videoHeight: ${this.videoHeight}`);

        // 更新视频表面尺寸
        if (this.surfaceId) {
          log(`[VIDEO_ROTATION] === 更新Surface尺寸 ===`);
          log(`[VIDEO_ROTATION] 设置Surface尺寸: ${rotatedSize.width}x${rotatedSize.height}`);
          this.mXComponentController.setXComponentSurfaceRect({
            surfaceWidth: rotatedSize.width,
            surfaceHeight: rotatedSize.height
          })
        } else {
          log(`[VIDEO_ROTATION] Surface ID不存在，无法更新Surface尺寸`);
        }*/

    this.setDisplayRatio({ param: this.playRatio })
    log(`[VIDEO_ROTATION] === 旋转完成 ===`);
  }
}
