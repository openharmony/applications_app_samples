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

import { common, Want } from '@kit.AbilityKit';
import preferencesUtils from '../utils/Preferences';
import { rpc } from '@kit.IPCKit';
import KvStoreModel from '../model/KvStoreModel';
import logger from '../utils/Logger';
import { DistributedManager, DistributedManagerDeviceInfo } from '../model/RemoteDeviceModel';
import { DeviceDialog } from '../common/DeviceDialog';
import {
  APPLICATION_BUNDLE_NAME,
  APPLICATION_SERVICE_NAME,
  MusicSharedEventCode
} from '../common/MusicSharedDefinition';
import { KeyCode } from '@kit.InputKit';
import { defaultState, PlayStateType, PlayStateTypeModel } from '../model/PlayState';
import AVPlayerClass from '../model/MusicPlayer';
import { songItemType } from '../model/Music';
import { promptAction, window } from '@kit.ArkUI';
import { AuthParam, DeviceInfoType } from '../const/Type';
import { EventUtil } from '../common/EventUtil';
import { PointerUtil } from '../common/PointerUtil';

const TAG: string = 'Index';
const ONE_HUNDRED: number = 100;
const ONE_THOUSAND: number = 100;
const SIXTY: number = 60;
const REMOTE_ABILITY_STARTED: string = 'remoteAbilityStarted';
const PREVIOUS_CLICK = 2;
let transferManager: DistributedManager | null = null;



interface Params {
  uri: string,
  seekTo: number,
  isPlaying: boolean
};

@Entry
@Component
struct Index {
  @State zsj: boolean = true;
  @StorageLink('currentProgress') currentProgress: number = 0;
  @StorageLink('totalMs') totalMs: number = 0;
  @State deviceLists: DistributedManagerDeviceInfo[] = [];
  @State isDialogShowing: boolean = false;
  @StorageLink('title') title: string = '';
  albumSrc: Resource = $r('app.media.album1');
  albumSrc1: Resource = $r('app.media.album3');
  albumSrc4:Resource = $r('app.media.album4');
  albumBg: Resource = $r('app.media.album2');
  @StorageLink('focusIndex') focusIndex: number = 2;
  @State selectedIndex: number = 0;;
  @State isShow: boolean = false;
  @State musicPlayer: AVPlayerClass = new AVPlayerClass();
  @State showButtonArrays: Resource[] =
    [$r('app.media.ic_hop'), $r('app.media.ic_play_previous'), $r('app.media.ic_pause'), $r('app.media.ic_play_next'),
      $r('app.media.ic_play_add')];
  @StorageLink('exitMusicApp') @Watch('exitMusicApp') isExitMusicApp: boolean = false;
  @StorageLink('musicPlay') @Watch('musicPlay') isMusicPlay: boolean = false;
  @StorageLink('musicPause') @Watch('musicPause') isMusicPause: boolean = false;
  @StorageLink('changePlayFlag') @Watch('changePlay') changePlayFlag: string = '';
  @State playState: PlayStateType = new PlayStateTypeModel(defaultState);
  @State musicListFocusID: number = 0;
  @State musicList : songItemType[] = [];
  @State musicListDelete : boolean = false;
  private dialogController: CustomDialogController | null = null;
  private context: common.UIAbilityContext | null = null;
  private localExtensionRemote: rpc.IRemoteObject | null = null;
  @State isDevice: boolean = false;
  private isClick:boolean = false;
  private focusDef:boolean = true;

  // 初始化分布式设备管理，用于设备发现和流转功能
  // 只在首次调用时初始化，避免重复创建实例
  initTransferManager() {
    if (!transferManager) {
      transferManager = DistributedManager.getInstance();
      if (transferManager) {
        console.log('transferManager initTransferManager');
        // 注册设备列表变化监听，实时更新可用设备
        transferManager.onDeviceListChange((data: DistributedManagerDeviceInfo[]) => {
          this.deviceLists = data;
        })
        // 启动设备扫描，发现网络中的其他设备
        transferManager.startScan();
      }
    }
  }

  // 处理音乐暂停逻辑，同时通知远程设备
  // 防止重复触发暂停操作，通过zsj标记控制
  musicPause() {
    if (this.zsj) {
      this.zsj = false;
      this.isClick = true;
      logger.info(TAG, 'music pause recv');
      // 暂停本地播放器
      this.musicPlayer.pause();
      // 记录当前播放进度
      AppStorage.setOrCreate('nowtime', this.musicPlayer.time);
      // 通知远程设备暂停播放
      let option = new rpc.MessageOption();
      let data = new rpc.MessageSequence();
      let reply = new rpc.MessageSequence();
      this.localExtensionRemote?.sendMessageRequest(
        MusicSharedEventCode.PAUSE_MUSIC_SERVICE_REMOTE, data, reply, option)
      // 更新播放按钮状态
      let viewThis = AppStorage.get<Index>('viewThis');
      viewThis!.showButtonArrays[PREVIOUS_CLICK] = $r('app.media.ic_pause');
    }
  };

  // 处理音乐播放逻辑
  // 重置zsj标记，确保可以再次触发暂停操作
  musicPlay() {
    this.zsj = true;
    this.isClick = true;
    logger.info(TAG, 'music play recv:');
    // 开始本地播放
    this.musicPlayer.play();
    // 更新播放按钮状态为播放中
    let viewThis = AppStorage.get<Index>('viewThis');
    viewThis!.showButtonArrays[PREVIOUS_CLICK] = $r('app.media.ic_play');
  };

  // 处理播放状态变更，根据标志执行上一曲或下一曲
  // 执行完成后清空标志，避免重复处理
  changePlay(){
    if (this.changePlayFlag == 'PRE'){
      console.log('HMLog-->PRE index:',this.musicPlayer.playIndex);
      // 清空标志，防止重复触发
      this.changePlayFlag = '';
      // 播放上一曲
      this.musicPlayer.previous();
    }else if (this.changePlayFlag == 'NEXT'){
      console.log('HMLog-->NEXT index:',this.musicPlayer.playIndex);
      // 清空标志，防止重复触发
      this.changePlayFlag = '';
      // 播放下一曲
      this.musicPlayer.next();
    }
  }

  // 处理应用退出逻辑，停止本地服务
  // 确保在退出前通知服务端清理资源
  exitMusicApp() {
    logger.info(TAG, `exit music app called`);
    if (this.localExtensionRemote !== null && typeof (this.localExtensionRemote) === 'object') {
      let option = new rpc.MessageOption();
      let data = new rpc.MessageSequence();
      let reply = new rpc.MessageSequence();
      // 发送停止本地服务的消息
      this.localExtensionRemote.sendMessageRequest(
        MusicSharedEventCode.STOP_LOCAL_SERIVCE,
        data,
        reply,
        option);
    } else {
      logger.info(TAG,
        `Remote start type is error or deviceID is empty, typeof= ${typeof (this.localExtensionRemote)}`);
    }
    ;
  };

  // 连接本地服务扩展，建立与服务的通信通道
  // 服务连接成功后，才能进行音乐播放控制和设备流转
  connectLocalExtension() {
    let localServiceWant: Want = {
      bundleName: APPLICATION_BUNDLE_NAME,
      abilityName: APPLICATION_SERVICE_NAME,
    };
    let connectOptions: common.ConnectOptions = {
      onConnect: (elementName, remote) => {
        // 连接成功，获取远程对象
        this.localExtensionRemote = remote;
        logger.info(TAG, `onConnect called elementName is ${JSON.stringify(elementName)}`);
      },
      onDisconnect: (elementName) => {
        // 连接断开，终止自身
        if (this.context !== null) {
          this.context.terminateSelf();
          logger.info(TAG, `OnDisconnect called elementName is ${JSON.stringify(elementName)}`);
        }
        ;
      },
      onFailed: (code) => {
        // 连接失败，终止自身
        if (this.context !== null) {
          this.context.terminateSelf();
          logger.info(TAG, `OnFailed called code is ${JSON.stringify(code)}`);
        }
      }
    };
    if (this.context !== null) {
      // 发起服务连接
      this.context.connectServiceExtensionAbility(localServiceWant, connectOptions);
    }
    ;
  };
  // 开始设备流转，将音乐播放转移到远程设备
  // 传递当前播放状态和进度，确保远程设备无缝接管
  startRemoteExtension(device: DistributedManagerDeviceInfo, ind: number) {
    console.log(`startAbility`);
    if (!device.networkId) {
      return;
    }
    // 设置设备为加载状态
    device.transferLoading = true;
    (transferManager as DistributedManager).updateDeviceProp(device.deviceId, 'transferLoading', true);
    this.deviceLists[ind] = device;
    console.log(`device id:${device.deviceId} device trust id: ${device.trustDeviceId}`);
    console.log(`networkId:${device.networkId}`);
    // 准备流转参数，包含当前播放状态
    let params: Params = {
      uri: '',
      seekTo: 0,
      isPlaying: false
    };
    // 如果当前正在播放音乐，传递详细的播放信息
    if (this.musicPlayer.playIndex >= 0 && this.musicPlayer.playIndex <= this.musicPlayer.playList.length) {
      params = {
        uri: this.musicPlayer.playList[this.musicPlayer.playIndex].url || '',
        seekTo: this.musicPlayer.duration,
        isPlaying: this.musicPlayer.isPlay
      };
    }
    // 发送流转请求到服务端
    let data = new rpc.MessageSequence();
    let option = new rpc.MessageOption();
    let reply = new rpc.MessageSequence();
    data.writeString(device.networkId);
    data.writeString(JSON.stringify(params));
    try {
      this.localExtensionRemote?.sendMessageRequest(
        MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE, data, reply, option)
    } catch (e) {
      console.log(`try startAbility catch err:${e}`);
    } finally {
      // 更新设备状态为流转中
      device.transferLoading = false;
      device.isInTransfer = true;
      (transferManager as DistributedManager).updateDeviceProp(device.deviceId, 'transferLoading', false);
      (transferManager as DistributedManager).updateDeviceProp(device.deviceId, 'isInTransfer', true);
      this.deviceLists[ind] = device;
    }
  };
  // 结束设备流转，停止远程设备的音乐播放
  // 清理流转状态，确保设备可以重新进行流转操作
  stopRemoteExtension(device: DistributedManagerDeviceInfo, ind: number) {
    console.log(`stopTransfer`);
    if (!device.networkId) {
      return;
    }
    // 设置设备为加载状态
    device.transferLoading = true;
    (transferManager as DistributedManager).updateDeviceProp(device.deviceId, 'transferLoading', true);
    this.deviceLists[ind] = device;
    console.log(`device id:${device.deviceId} device trust id: ${device.trustDeviceId}`);
    console.log(`networkId:${device.networkId}`);
    // 发送停止流转请求到服务端
    let option = new rpc.MessageOption();
    let data = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();
    data.writeString(device.networkId);
    try {
      this.localExtensionRemote?.sendMessageRequest(
        MusicSharedEventCode.STOP_DISTRIBUTED_MUSIC_SERVICE, data, reply, option);
    } catch (e) {
      console.log(`try startAbility catch err:${e}`);
    } finally {
      // 更新设备状态为非流转中
      device.isInTransfer = false;
      device.transferLoading = false;
    }
  };

  // 发送播放音乐的消息到服务端
  // 确保服务端同步播放状态，实现多设备协同
  sendMessagePlay() {
    if (this.localExtensionRemote !== null) {
      let option = new rpc.MessageOption();
      let data = new rpc.MessageSequence();
      let reply = new rpc.MessageSequence();
      // 发送播放请求到服务端
      this.localExtensionRemote.sendMessageRequest(MusicSharedEventCode.PLAY_MUSIC_SERVICE, data, reply, option);
      logger.info(TAG, `onPlayClick send mssage success`);
    } else {
      logger.info(TAG, `can not get proxy`);
      return;
    }
    ;
  };

  // 发送暂停音乐的消息到服务端
  // 确保服务端同步暂停状态，实现多设备协同
  sendMessagePause() {
    if (this.localExtensionRemote === null) {
      logger.info(TAG, `can not get proxy`);
      return;
    }
    ;
    let option = new rpc.MessageOption();
    let data = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();

    // 发送暂停请求到服务端
    this.localExtensionRemote.sendMessageRequest(MusicSharedEventCode.PAUSE_MUSIC_SERVICE, data, reply, option);
    logger.info(TAG, `onPauseClick send mssage success`);
  };

  // 发送上一曲的消息到服务端
  // 确保服务端同步播放状态，实现多设备协同
  sendMessagePre() {
    if (this.localExtensionRemote === null) {
      logger.info(TAG, `can not get proxy`);
      return;
    }
    let option = new rpc.MessageOption();
    let data = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();
    // 发送上一曲请求到服务端
    this.localExtensionRemote.sendMessageRequest(MusicSharedEventCode.PRE_MUSIC_SERVICE, data, reply, option);
    console.log('HmLog-->sendMessagePre');
    logger.info(TAG, `onPreClick send mssage success`);
  }

  // 发送下一曲的消息到服务端
  // 确保服务端同步播放状态，实现多设备协同
  sendMessageNext() {
    if (this.localExtensionRemote === null) {
      logger.info(TAG, `can not get proxy`);
      return;
    }
    let option = new rpc.MessageOption();
    let data = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();
    // 发送下一曲请求到服务端
    this.localExtensionRemote.sendMessageRequest(MusicSharedEventCode.NEXT_MUSIC_SERVICE, data, reply, option);
    console.log('HmLog-->sendMessageNext');
    logger.info(TAG, `onNextClick send mssage success`);
  }

  // 处理返回键逻辑，根据当前界面状态执行不同操作
  // 优先级：播放列表 > 设备列表 > 删除模式
  onBackPress() {
    if (this.isShow && !this.musicListDelete) {
      // 关闭播放列表
      this.isShow = false;
      return true;
    }
    if (this.isDevice) {
      // 关闭设备列表，恢复焦点
      console.log('requestFocus 1');
      focusControl.requestFocus('focusControl' + this.focusIndex);
      this.isDevice = false;
      return true;
    }

    if (this.musicListDelete) {
      // 退出删除模式
      this.musicListDelete = false;
      return true
    }
    // 其他情况，让系统处理返回
    return false;
  };

  onPageHide() {
    if (this.isDialogShowing === true) {
      this.dismissDialog();
      return true;
    }
    return false;
  };

  dismissDialog() {
    if (this.dialogController !== null) {
      this.dialogController.close();
    }
    this.isDialogShowing = false;
  };

  selectedIndexChange = (selectedIndex: number, device:DistributedManagerDeviceInfo) => {
    if(!device) {
      return;
    }
    if (device.isTrust) {
      if (device.isInTransfer) {
        this.stopRemoteExtension(device, selectedIndex);
      } else {
        this.startRemoteExtension(device, selectedIndex);
      }
    } else if (!device.isInAuth) {
      this.authenticateDevice(device, selectedIndex)
    }
  };

  // 设备认证
  authenticateDevice(data: DistributedManagerDeviceInfo, ind: number) {
    if (transferManager) {
      let deviceInfo: DistributedManagerDeviceInfo = {
        deviceId: data.deviceId,
        deviceName: data.deviceName,
        deviceType: data.deviceType,
        networkId: data.networkId,
        range: data.range
      };
      // 使用类型断言确保类型兼容
      let authParam: AuthParam = {
        authType: 1, // 认证类型： 1 - 无账号PIN码认证
        extraInfo: {}
      };
      data.isInAuth = true;
      transferManager.updateDeviceProp(data.deviceId, 'isInAuth', true);
      this.deviceLists[ind] = data;
      transferManager.authenticateDevice(deviceInfo, authParam);
      // 使用新的API替代showToast
      promptAction.showToast({
        message: '请在对端设备进行确认',
        duration: 3000,
        bottom: `20%`
      });
    }
  }

  clearSelectState() {
    this.deviceLists = [];
    console.log('focusControl 2');
    focusControl.requestFocus('focusControl' + this.focusIndex);
    if (this.dialogController) {
      this.dialogController.close();
      this.dialogController = null;
    }
  };

  getShownTimer(ms: number) {
    let minStr: string;
    let secStr: string;
    let seconds = Math.floor(ms / ONE_THOUSAND);
    let sec = seconds % SIXTY;
    logger.info(TAG, `getShownTimer sec = ${sec}`);
    let min = (seconds - sec) / SIXTY;
    logger.info(TAG, `getShownTimer min = ${min}`);
    if (sec < 10) {
      secStr = '0' + sec;
    } else {
      secStr = sec.toString(10);
    }
    if (min < 10) {
      minStr = '0' + min;
    } else {
      minStr = min.toString(10);
    }
    logger.warn(TAG, `getShownTimer = ${minStr}:${secStr}`);
    return minStr + ':' + secStr;
  };

  refreshSongInfo(index: number) {
    logger.info(TAG, `refreshSongInfo ${index}/${this.musicPlayer.playList.length}`);
    if (index >= this.musicPlayer.playList.length) {
      logger.warn(TAG, 'refreshSongInfo ignored');
      return;
    }
    this.title = this.musicPlayer.playList[index].name;
    this.albumSrc = $r('app.media.album1');
    this.totalMs = this.musicPlayer.duration;
  };

  onAppSharedClick() {
    if (this.deviceLists.length > 0) {
      this.isDevice = true;
    } else {
      // 使用新的API替代showToast
      promptAction.showToast({
        message: '分享设备列表为空!'
      })
    }
  };

  onPreviousClick() {
    console.log('HmLog-->onPreviousClick');
    this.musicPlayer.previous();
    setTimeout(() => {
      this.musicPlayer.playList[this.musicPlayer.playIndex].time = this.musicPlayer.duration
    }, 100)
    this.sendMessagePre();
  };

  onNextClick() {
    console.log('HmLog-->onNextClick');
    this.musicPlayer.next();
    setTimeout(() => {
      this.musicPlayer.playList[this.musicPlayer.playIndex].time = this.musicPlayer.duration
    }, 100)
    this.sendMessageNext();
  };

  async onPlayClick() {
    this.isClick = true;
    if (this.musicPlayer.isPlay) {
      this.sendMessagePause();
    } else {
      this.sendMessagePlay();
    };
    this.musicPlayer.isPlay
      ? await this.musicPlayer.pause()
      : await this.musicPlayer.playAndPause();
    logger.info('hmlog==>', `onPlayClick isPlay= ${this.musicPlayer.isPlay}`);
    let viewThis = AppStorage.get<Index>('viewThis');
    this.musicPlayer.isPlay
    ? viewThis!.showButtonArrays[PREVIOUS_CLICK] = $r('app.media.ic_play')
    : viewThis!.showButtonArrays[PREVIOUS_CLICK] = $r('app.media.ic_pause');

    if (this.musicPlayer.playList[this.musicPlayer.playIndex]?.time){
      return;
    }
  };

  async deleteMusic(index : number){
    console.info('deleteDemo');
    try {
      this.musicList.splice(index,1);
      if (this.musicListFocusID == this.musicList.length) {
        this.musicListFocusID = this.musicList.length-1;
        if (this.musicList.length == 0 ){
          this.musicListFocusID = 0;
          this.isShow = false;
        }
      }
      this.musicPlayer.playList = this.musicList;
      preferencesUtils.changeData('musicList',this.musicPlayer.playList);

      console.info('111113==>',preferencesUtils.readData('musicList'));
      console.log('hmlog==>','musicList:',this.musicPlayer.playList);
      console.info('delete successfully');
    } catch (err) {
      console.error('delete failed with error: ' + err);
    }
  }
  restoreFromWant() {
    logger.info(TAG, 'restoreFromWant');
    let status: Record<string, string | number | boolean | object> | undefined = AppStorage.get('status') as Record<string, string | number | boolean | object> | undefined;
    if (status !== undefined && status !== null && status.uri !== null && this.context !== null) {
      KvStoreModel.broadcastMessage(this.context, REMOTE_ABILITY_STARTED);
      logger.info(TAG, 'restorePlayingStatus');
      this.musicPlayer.restorePlayingStatus(status, (index: number) => {
        logger.info(TAG, `restorePlayingStatus finished, index= ${index}`);
        if (index >= 0) {
          this.refreshSongInfo(index);
        } else {
          this.musicPlayer.preLoad(0, () => {
            this.refreshSongInfo(0);
          })
        }
        if (status !== undefined) {
          logger.info(TAG, 
            `Index PlayerModel.restorePlayingStatus this.totalMs = ${this.totalMs}, status.seekTo = ${status.seekTo}`);
          this.currentProgress = Math.floor(Number(status.seekTo) / this.totalMs * ONE_HUNDRED);
        }
      })
    } else {
      this.musicPlayer.preLoad(0, () => {
        this.refreshSongInfo(0);
      });
    }
  };

  number2time(number: number) {
    const ms: number = number % 100;
    const second = (number - ms) / 100;
    const s: number = second % 60;
    if (second > 60) {
      const m: number = (second - s) / 60 % 60;
        return m.toString().padStart(2, '0') + ':' + s.toString().padStart(2, '0');
    }
    return '00:' + s.toString().padStart(2, '0');
  }

  async aboutToAppear() {
    this.musicPlayer.init().then(() => {
        this.musicPlayer.player?.pause();
        this.musicPlayer.isPlay = false;
        this.musicList = this.musicPlayer.playList;
        preferencesUtils.writeData('isFirst','false');
    })
    AppStorage.setOrCreate('viewThis', this);
  };

  transferInit(){
    // 使用AppStorage替代globalThis
    let videoIndex = AppStorage.get<number>('videoIndex') || 0;
    this.musicPlayer.playIndex = videoIndex;
  }

  async aboutToDisappear() {
    logger.info(TAG, `aboutToDisappear begin`);
    if (this.musicPlayer === undefined) {
      return;
    }
    this.musicPlayer.player?.release();
    if (transferManager) {
      transferManager.stopScan();
    }
    this.dialogController = null;
    KvStoreModel.deleteKvStore();
    logger.info(TAG, `aboutToDisappear end`);
  };

  onDidBuild(): void {
    setTimeout(async ()=>{
      focusControl.requestFocus('focusControl'+this.focusIndex);
      // 使用this.context替代getContext()
      if (this.context) {
        let win = await window.getLastWindow(this.context);
        win.on('windowEvent',(data)=>{
          if (data == window.WindowEventType.WINDOW_INACTIVE) {
            console.log('WINDOW_INACTIVE窗口失焦');
            this.focusDef = false;
          }
        })
      }
      this.initTransferManager();
      this.connectLocalExtension();
      PointerUtil.changePointStyle(false);
    },100)
  }

  build() {
    Stack() {
      Column() {
        // 顶部空白区域
        Blank()
          .width('100%')
          .height('100lpx')
        Stack() {
          Image(this.albumBg)
            .width('418lpx')
            .height('418lpx')
            .margin({
              top: '40lpx',
              left: '185lpx',
              bottom: '40lpx',
              right: 0
            })
          Image(this.musicPlayer.playIndex==0?this.albumSrc4:this.musicPlayer.playIndex==1?this.albumSrc1:this.albumSrc)
            .width('490lpx')
            .height('490lpx')
            .margin({ right: '105lpx' })
        }
        .width('584lpx')
        .height('490lpx')
        .margin({ left: '705lpx', right: '566lpx', bottom: '20lpx' })

        Row() {
          Text(this.musicList[this.musicPlayer.playIndex]?.name) //歌名
            .textAlign(TextAlign.Center)
            .width('432lpx')
            .height('42lpx')
            .fontSize('36lpx')
            .fontWeight(100)
            .fontColor('rgba(255,255,255,0.86)')
            .maxLines(1)
            .textOverflow({
              overflow: this.musicList[this.musicPlayer.playIndex]?.name.length > 12 ? TextOverflow.Ellipsis :
              TextOverflow.None
            })
        }
        .width('480lpx')
        .height('58lpx')
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .padding({top:'8lpx',left:'24lpx',bottom:'8lpx',right:'24lpx'})
        .margin({bottom:'16lpx'})
        Row() {
          Text(this.musicList[this.musicPlayer.playIndex]?.author)
            .textAlign(TextAlign.Center)
            .width('432lpx')
            .height('35lpx')
            .fontSize('30lpx')
            .fontWeight(400)
            .fontColor('rgba(255,255,255,0.6)')
            .maxLines(1)
            .textOverflow({
              overflow: this.musicList[this.musicPlayer.playIndex]?.author.length > 12 ? TextOverflow.Ellipsis :
              TextOverflow.None
            })
        }
        .width('480lpx')
        .height('51lpx')
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .padding({top:'8lpx',left:'24lpx',bottom:'8lpx',right:'24lpx'})

        Column() {
          // 时间显示行
          Row() {
            Text(this.number2time(this.musicPlayer.time))
              .fontSize('24lpx')
              .fontColor(Color.White)
              .width('63lpx')
            Blank()
            Text(this.number2time(this.musicPlayer.duration))
              .fontSize('24lpx')
              .fontColor(Color.White)
              .width('63lpx')
          }
          .width('1728lpx')
          .height('28lpx')
          .margin({ bottom: '20lpx' })
          // 进度滑块
          Slider({
            value: this.musicPlayer.time,
            min: 0,
            max: this.musicPlayer.duration
          })
            .trackColor('rgba(255, 255, 255, 0.2)')
            .blockSize({ width: '24lpx', height: '24lpx' })
            .width('1728lpx')
            .height('8lpx')
            .selectedColor('#ff0c4ae7')
            .margin({ bottom: '72lpx' })
            .onChange((value: number, mode: SliderChangeMode) => {
              this.musicPlayer.time = value;
              this.musicPlayer.player?.seek(value);
              if (typeof (this.musicPlayer.duration) !== 'number') {
                this.musicPlayer.time = 0;
                logger.info(TAG, `setProgress ignored, totalMs= ${this.totalMs}`);
                return;
              }
            })

          Row() {
            // 控制按钮行
            ForEach(this.showButtonArrays, (item: Resource, index: number) => {
              Column() {
                Row(){
                  Image(this.musicPlayer.isPlay && index === 2 ? $r('app.media.ic_play') : item)
                    .focusable(true)
                    .onFocus(() => {
                      if (this.isDevice) {
                        transferManager?.publishDeviceDiscovery();
                        this.focusIndex = 0;
                        focusControl.requestFocus(this.selectedIndex.toString());
                      }else {
                        if (this.isClick) {
                          return;
                        }
                        const keyValue = 'focusControl' + index; // 在事件处理函数中生成或获取
                        if (this.focusDef === false) {
                          console.log('WINDOW_INACTIVE窗口获焦状态,keyValue:',keyValue);
                          focusControl.requestFocus(keyValue);
                          this.focusDef = true;
                          return;
                        }
                        this.focusIndex = index;
                      }
                    })
                    .onBlur(() => {
                      if (this.isClick) {
                        setTimeout(()=>{
                          this.isClick = false;
                        },10)
                      }
                      console.log('HmLog--> focus onBlur', `${this.focusIndex}`);
                    })
                    .width('96lpx')
                    .fillColor(this.focusIndex == index ? 'rgba(0,0,0,0.86)' : 'rgba(255,255,255,0.86)')
                    .height('96lpx')
                    .objectFit(ImageFit.Contain)
                    .onKeyEvent((e) => {
                      if (e == null) {
                        return;
                      }
                      if (this.isShow == false) {
                        if (e.keyCode === KeyCode.KEYCODE_DPAD_LEFT && e.type === KeyType.Down) {
                          console.log('HmLog-->', index);
                          if (this.focusIndex != 0) {
                            this.focusIndex--;
                          }
                        }
                        if (e.keyCode === KeyCode.KEYCODE_DPAD_RIGHT && e.type === KeyType.Down) {
                          if (this.focusIndex != 4) {
                            this.focusIndex++;
                          }
                        }
                        if (e.keyCode === KeyCode.KEYCODE_DPAD_CENTER && e.type === KeyType.Down) {
                          console.log('hmlog-->', 'onKeyEvent focusIndex:', this.focusIndex);
                          switch (this.focusIndex) {
                            case 0:
                              this.onAppSharedClick();
                              break;
                            case 1:
                              this.onPreviousClick();
                              break;
                            case 2:
                              this.onPlayClick();
                              break;
                            case 3:
                              this.onNextClick();
                              break;
                            case 4:
                              this.musicListFocusID = this.musicPlayer.playIndex;
                              this.isShow = true;
                              break;
                            default:
                              break;
                          }
                        }
                        if (e.keyCode === KeyCode.KEYCODE_ENTER && e.type === KeyType.Down) {
                          console.log('hmlog-->', 'onKeyEvent focusIndex:', this.focusIndex);
                          switch (this.focusIndex) {
                            case 0:
                              this.onAppSharedClick();
                              break;
                            case 1:
                              this.onPreviousClick();
                              break;
                            case 2:
                              this.onPlayClick();
                              break;
                            case 3:
                              this.onNextClick();
                              break;
                            case 4:
                              this.musicListFocusID = this.musicPlayer.playIndex;
                              this.isShow = true;
                              break;
                            default:
                              break;
                          }
                        }
                      } else {
                        if (e.keyCode === KeyCode.KEYCODE_DPAD_DOWN && e.type === KeyType.Down) {
                          if (this.musicListFocusID < this.musicPlayer.playList.length-1) {
                            this.musicListFocusID++;
                          }
                        }
                        if (e.keyCode === KeyCode.KEYCODE_DPAD_UP && e.type === KeyType.Down) {
                          if (this.musicListFocusID > 0) {
                            this.musicListFocusID--;
                          }
                        }
                        if (e.keyCode === KeyCode.KEYCODE_DPAD_CENTER && e.type === KeyType.Down) {
                          console.log('1111');
                          this.musicPlayer.playIndex = this.musicListFocusID;
                          this.musicPlayer.singlePlay(this.musicPlayer.playList[this.musicPlayer.playIndex]);
                          this.isShow = false;
                        }
                        if (e.keyCode === KeyCode.KEYCODE_ENTER && e.type === KeyType.Down) {
                          if (this.musicListDelete) {
                            this.deleteMusic(this.musicListFocusID);
                            this.musicListDelete = false;
                          }else {
                            console.log('1111', this.musicListFocusID);
                            this.musicPlayer.playIndex = this.musicListFocusID;
                            this.musicPlayer.singlePlay(this.musicPlayer.playList[this.musicPlayer.playIndex]);
                            this.isShow = false;
                          }
                        }
                        if (e.keyCode === KeyCode.KEYCODE_A && e.type === KeyType.Down) {
                          this.isShow = false;
                        }
                        if ((e.keyCode === KeyCode.KEYCODE_MENU || e.keyCode === KeyCode.KEYCODE_D )&& e.type === KeyType.Down) {
                          this.musicListDelete = !this.musicListDelete;
                        }
                      }
                    })
                    .onHover(() => {
                      this.focusIndex = index;
                      focusControl.requestFocus(`controller_${this.focusIndex}`);
                    })
                    .onTouch((event) => {
                      if (event == null) {
                        return;
                      }
                      if (!EventUtil.isTouchEvent(event as TouchEvent)) {
                        return;
                      }

                      if (this.isShow) {
                        return;
                      }

                      this.focusIndex = index;
                      focusControl.requestFocus(`controller_${this.focusIndex}`);

                      switch (this.focusIndex) {
                        case 0:
                          this.onAppSharedClick();
                          break;
                        case 1:
                          this.onPreviousClick();
                          break;
                        case 2:
                          this.onPlayClick();
                          break;
                        case 3:
                          this.onNextClick();
                          break;
                        case 4:
                          this.musicListFocusID = this.musicPlayer.playIndex;
                          this.isShow = true;
                          break;
                        default:
                          break;
                      }
                    })
                }.backgroundColor(this.focusIndex == index ? 'rgba(255,255,255,0.86)' : Color.Transparent)
                .width('96lpx')
                .height('96lpx')
                .borderRadius('48lpx')
              }
              .width('112lpx')
              .height('112lpx')
              .border({
                width: this.focusIndex === index ? '4lpx' : 0,
                color: Color.White,
                radius: '56lpx'
              })
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.SpaceEvenly)
            })
          }
          .width('1024lpx')
          .height('112lpx')
          .justifyContent(FlexAlign.SpaceBetween)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundImage($r('app.media.bg_blurry'))
      .backgroundImageSize({ width: '100%', height: '100%' })
      .onTouch((event) => {
        if (event == null) {
          return;
        }
        EventUtil.isTouchEvent(event as TouchEvent);
      })

      if(this.isDevice) {
        DeviceDialog({
          deviceLists: $deviceLists,
          selectedIndex: $selectedIndex,
          selectedIndexChange: this.selectedIndexChange,
          isDevice: $isDevice
        });
      }

      /**
       * 播放列表
       */

      if (this.isShow) {
        Row() {
          Column()
            .width('66%')
            .height('100%')
            .onClick(() => {
              this.isShow = false;
            })
          Column() {
            Row() {
              Text('播放列表')
                .fontSize('36lpx')
                .fontColor('#fff')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .margin({ left: '140lpx', top: '32lpx', bottom: '24lpx' })

            Row() {
              Text('').backgroundColor('rgb(10, 89, 247)').width('144lpx').height(1)
            }
            .width('100%')
            .margin({ left: '140lpx', bottom: -1 })

            Divider()
              .color('rgba(255, 255, 255, 0.2)')
              .strokeWidth(1)
              .margin({ bottom: '38lpx' })

            List({ space: 5 }) {
              ForEach(this.musicList, (item: songItemType, index: number) => {
                ListItem() {
                  Row() {
                    Text(item.name)
                      .fontSize('30lpx')
                      .fontColor('rgba(255, 255, 255, 0.86)')
                      .fontWeight(100)
                      .lineHeight('35lpx')
                      .margin({ left: '70lpx' })
                      .width('230lpx')
                      .textAlign(TextAlign.Start)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Row() {
                      Text(item.author)
                        .fontSize('30lpx')
                        .fontColor('rgba(255, 255, 255, 0.86)')
                        .fontWeight(100)
                        .lineHeight('35lpx')
                        .textAlign(TextAlign.Start)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .maxLines(1)
                        .width('210lpx')

                      Text(item.time ? this.number2time(item.time) : '--:--')
                        .fontSize('30lpx')
                        .fontColor('rgba(255, 255, 255, 0.86)')
                        .fontWeight(100)
                        .lineHeight('35lpx')
                        .textAlign(TextAlign.Start)
                        .margin({ right: '28lpx' })
                        .width('100lpx')
                    }
                    if (this.musicListDelete && this.musicListFocusID == index){
                      Image($r('app.media.delete'))
                        .width('50lpx')
                        .aspectRatio(1)
                        .fillColor(Color.Red)
                        .margin({right:'48lpx'})
                     .animation({
                       duration:300
                     })
                    }
                  }
                  .defaultFocus(index == 0)
                  .padding({ top: '20lpx', bottom: '21lpx' })
                  .width('100%')
                  .backgroundColor(index == this.musicListFocusID ? 'rgb(8, 28, 67)' : '')
                  .focusable(true)
                  .onTouch((event) => {

                    this.musicListFocusID = index;
                    this.musicPlayer.playIndex = this.musicListFocusID;
                    if (this.musicListDelete) {
                      this.deleteMusic(this.musicListFocusID);
                      this.musicListDelete = false;
                    } else {
                      this.musicPlayer.playIndex = this.musicListFocusID;
                      this.musicPlayer.singlePlay(this.musicPlayer.playList[this.musicPlayer.playIndex]);
                      this.isShow = false;
                    }
                  })
                  .onHover(()=>{
                    this.musicListFocusID = index;
                  })
                }
                .height('76lpx')
              })
            }

          }
          .width('100%')
          .height('100%')
          .backgroundColor('#e6000000')
          .borderRadius({ topLeft: '16lpx', bottomLeft: '16lpx' })
          .focusable(true)
          .onFocus(() => {
            console.log('HmLog--> onFocus', `videoList`)
          })
          .onBlur(() => {
            console.log('HmLog--> onBlur', `videoList`)
          })
        }
        .height('100%')
        .align(Alignment.End)
        .zIndex(10)
      }
    }
  }
}
