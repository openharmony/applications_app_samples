/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import display from '@ohos.display';
import common from '@ohos.app.ability.common';
import mediaQuery from '@ohos.mediaquery';
import rpc from '@ohos.rpc';
import Want from '@ohos.app.ability.Want';
import PermissionRequestResult from 'security/PermissionRequestResult';
import KvStoreModel from '../model/KvStoreModel';
import Logger from '../model/Logger';
import PlayerModel from '../model/PlayerModel';
import deviceManager from '@ohos.distributedDeviceManager';
import ability from '@ohos.ability.ability';
import { RemoteDeviceModel } from '../model/RemoteDeviceModel';
import { DeviceDialog } from '../common/DeviceDialog';
import {
  APPLICATION_BUNDLE_NAME,
  APPLICATION_SERVICE_NAME,
  MusicSharedEventCode,
  MusicSharedStatus,
  MusicConnectEvent
} from '../common/MusicSharedDefinition';

const TAG: string = 'Index';
const DESIGN_WIDTH: number = 720.0;
const SYSTEM_UI_HEIGHT: number = 134;
const DESIGN_RATIO: number = 16 / 9;
const ONE_HUNDRED: number = 100;
const ONE_THOUSAND: number = 1000;
const SIXTY: number = 60;
const REMOTE_ABILITY_STARTED: string = 'remoteAbilityStarted';
const ABILITY_SHARED_BUTTON = 0;
const DEFAULT_NUM = -1;
const PREVIOUS_CLICK = 2;

interface Params {
  uri: string,
  seekTo: number,
  isPlaying: boolean
};

@Entry
@Component
 struct Index {
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)');
  @State isLand: boolean = false;
  @State currentTimeText: string = '';
  @State currentProgress: number = 0;
  @State totalMs: number = 0;
  @State riscale: number = 1;
  @State risw: number = 720;
  @State rish: number = 1280;
  @State isSwitching: boolean = false;
  @State deviceLists: Array<deviceManager.DeviceBasicInfo> = [];
  @State isDialogShowing: boolean = false;
  @State isDistributed: boolean = false;
  @State title: string = '';
  @State totalTimeText: string = '00:00';
  @State albumSrc: Resource = $r('app.media.album');
  @State selectedIndex: number = 0;
  @State imageArrays: Array<Resource> = [$r('app.media.ic_hop'), $r('app.media.ic_play_previous'), $r('app.media.ic_play'), $r('app.media.ic_play_next')];
  private dialogController: CustomDialogController | null = null;
  @StorageLink('exitMusicApp') @Watch('exitMusicApp') isExitMusicApp: boolean = false;
  @StorageLink('remoteServiceExtensionConnectEvent') @Watch('remoteServiceExtensionConnectEvent') isRemoteServiceExtensionConnectEvent: boolean = false;
  @StorageLink('musicPlay') @Watch('musicPlay') isMusicPlay: boolean = false;
  @StorageLink('musicPause') @Watch('musicPause') isMusicPause: boolean = false;
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel();
  private context: common.UIAbilityContext | null = null;
  private deviceId: string | null = null;
  private clickFlag = MusicSharedStatus.MUSIC_SHARED;
  private localExtensionRemote: rpc.IRemoteObject | null = null;
  onLand = (mediaQueryResult: mediaQuery.MediaQueryResult) => {
    Logger.info(TAG, `onLand: mediaQueryResult.matches= ${mediaQueryResult.matches}`);
    if (mediaQueryResult.matches) {
      this.isLand = true;
    } else {
      this.isLand = false;
    };
  };

  showDialog() {
    this.remoteDeviceModel.registerDeviceListCallback(() => {
      Logger.info(TAG, 'registerDeviceListCallback, callback entered');
      this.deviceLists = [];
      this.deviceLists.push({
        deviceId: '0',
        deviceName: 'local device',
        deviceType: '0',
        networkId: ''
      });
      let deviceTempList = this.remoteDeviceModel.discoverLists.length > 0 ? this.remoteDeviceModel.discoverLists : this.remoteDeviceModel.deviceLists;
      for (let i = 0; i < deviceTempList.length; i++) {
        Logger.info(TAG, `device ${i}/${deviceTempList.length} deviceId= ${deviceTempList[i].deviceId},
         deviceName= ${deviceTempList[i].deviceName}, deviceType= ${deviceTempList[i].deviceType}`);
        this.deviceLists.push(deviceTempList[i]);
        Logger.info(TAG, `deviceLists:${JSON.stringify(this.deviceLists)}`);
        Logger.info(TAG, 'deviceLists push end');
      };
      Logger.info(TAG, 'CustomDialogController start');
      if (this.dialogController !== null) {
        this.dialogController.close();
        this.dialogController = null;
      }
      this.dialogController = new CustomDialogController({
        builder: DeviceDialog({
          deviceLists: this.deviceLists,
          selectedIndex: this.selectedIndex,
          selectedIndexChange: this.selectedIndexChange
        }),
        autoCancel: true,
        customStyle: true
      });
      this.dialogController.open();
      Logger.info(TAG, 'CustomDialogController end');
    })
  };

  showPromptDialog(title: ResourceStr, str: ResourceStr) {
    AlertDialog.show({
      title: title,
      message: str,
      confirm: {
        value: $r('app.string.cancel'),
        action: () => {
          Logger.info(TAG, `Button-clicking callback`);
        }
      },
      cancel: () => {
        Logger.info(TAG, `Closed callbacks`);
      }
    });
  };

  remoteServiceExtensionConnectEvent(event: string) {
    if (typeof (event) === 'string') {
      let viewThis = AppStorage.get<Index>('viewThis');
      if (viewThis !== undefined) {
        if (event === MusicConnectEvent.EVENT_CONNECT) {
          viewThis.clickFlag = MusicSharedStatus.MUSIC_STOP_SHARED;
          viewThis.imageArrays[ABILITY_SHARED_BUTTON] = $r('app.media.ic_hop');
          Logger.info(TAG, 'remote service on connect callbacked');
        } else if (event === MusicConnectEvent.EVENT_DISCONNECT) {
          viewThis.imageArrays[ABILITY_SHARED_BUTTON] = $r('app.media.ic_hop');
          viewThis.clickFlag = MusicSharedStatus.MUSIC_SHARED;
          viewThis.showPromptDialog($r('app.string.ConnectRemoteDevices'), $r('app.string.onDisconnectService'));
        } else if (event === MusicConnectEvent.EVENT_FAILED) {
          viewThis.imageArrays[ABILITY_SHARED_BUTTON] = $r('app.media.ic_hop');
          viewThis.clickFlag = MusicSharedStatus.MUSIC_SHARED;
          viewThis.showPromptDialog($r('app.string.ConnectRemoteDevices'), $r('app.string.onFailedService'));
        } else if (event === MusicConnectEvent.EVENT_TIMEOUT) {
          this.imageArrays[ABILITY_SHARED_BUTTON] = $r('app.media.ic_hop');
          viewThis.clickFlag = MusicSharedStatus.MUSIC_SHARED;
          viewThis.showPromptDialog($r('app.string.ConnectRemoteDevices'), $r('app.string.ConnectionTimeout'));
        }
      }
    } else {
      Logger.info(TAG, 'event is not a string');
    };
  };

  musicPause() {
    Logger.info(TAG, 'music pause recv');
    PlayerModel.pause();
    let viewThis = AppStorage.get<Index>('viewThis');
    viewThis!.imageArrays[PREVIOUS_CLICK] = $r('app.media.ic_play');
  };

  musicPlay() {
    Logger.info(TAG, 'music play recv');
    PlayerModel.play(DEFAULT_NUM, true);
    let viewThis = AppStorage.get<Index>('viewThis');
    viewThis!.imageArrays[PREVIOUS_CLICK] = $r('app.media.ic_pause');
  };

  exitMusicApp() {
    Logger.info(TAG, `exit music app called`);
    if (this.localExtensionRemote !== null && typeof (this.localExtensionRemote) === 'object') {
      let option = new rpc.MessageOption();
      let data = new rpc.MessageParcel();
      let reply = new rpc.MessageParcel();
      this.localExtensionRemote.sendRequest(
        MusicSharedEventCode.STOP_LOCAL_SERIVCE,
        data,
        reply,
        option);
    } else {
      Logger.info(TAG, `Remote start type is error or deviceID is empty, typeof= ${typeof (this.localExtensionRemote)}`);
    };
  };

  connectLocalExtension() {
    let localServiceWant: Want = {
      bundleName: APPLICATION_BUNDLE_NAME,
      abilityName: APPLICATION_SERVICE_NAME,
    };
    let connectOptions: ability.ConnectOptions = {
      onConnect: (elementName, remote) => {
        this.localExtensionRemote = remote;
        Logger.info(TAG, `onConnect called elementName is ${JSON.stringify(elementName)}`);
      },
      onDisconnect: (elementName) => {
        if (this.context !== null) {
          this.context.terminateSelf();
          Logger.info(TAG, `OnDisconnect called elementName is ${JSON.stringify(elementName)}`);
        };
      },
      onFailed: (code) => {
        if (this.context !== null) {
          this.context.terminateSelf();
          Logger.info(TAG, `OnFailed called code is ${JSON.stringify(code)}`);
        }
      }
    };
    if (this.context !== null) {
      this.context.connectServiceExtensionAbility(localServiceWant, connectOptions);
    };
  };

  startRemoteExtension(deviceId: string, params: object) {
    if (this.localExtensionRemote !== null && typeof (this.localExtensionRemote) === 'object' && typeof (deviceId) === 'string' && deviceId !== '') {
      let option = new rpc.MessageOption();
      let data = new rpc.MessageParcel();
      let reply = new rpc.MessageParcel();
      data.writeString(deviceId);
      data.writeString(JSON.stringify(params));
      this.localExtensionRemote.sendRequest(MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE, data, reply, option);
      this.deviceId = deviceId;
      this.imageArrays[ABILITY_SHARED_BUTTON] = $r('app.media.ic_hop');
    } else {
      Logger.info(TAG, `Remote start type is error or deviceID is empty, typeof= ${typeof (this.localExtensionRemote)}`);
    };
  };

  stopRemoteExtension() {
    if (this.localExtensionRemote !== null && typeof (this.localExtensionRemote) === 'object' && typeof (this.deviceId) === 'string' && this.deviceId !== '') {
      let option = new rpc.MessageOption();
      let data = new rpc.MessageParcel();
      let reply = new rpc.MessageParcel();
      data.writeString(this.deviceId);
      this.localExtensionRemote.sendRequest(MusicSharedEventCode.STOP_DISTRIBUTED_MUSIC_SERVICE, data, reply, option);
      this.deviceId = '';
    } else {
      Logger.info(TAG, `Remote stopped type is wrong or deviceID is empty, typeof= ${typeof (this.localExtensionRemote)}`);
    };
  };

  sendMessagePlay() {
    if (this.localExtensionRemote !== null) {
      let option = new rpc.MessageOption();
      let data = new rpc.MessageParcel();
      let reply = new rpc.MessageParcel();
      this.localExtensionRemote.sendRequest(MusicSharedEventCode.PLAY_MUSIC_SERVICE, data, reply, option);
      Logger.info(TAG, `onPlayClick send mssage success`);
    } else {
      Logger.info(TAG, `can not get proxy`);
      return;
    };
  };

  sendMessagePause() {
    if (this.localExtensionRemote === null) {
      Logger.info(TAG, `can not get proxy`);
      return;
    };
    let option = new rpc.MessageOption();
    let data = new rpc.MessageParcel();
    let reply = new rpc.MessageParcel();

    this.localExtensionRemote.sendRequest(MusicSharedEventCode.PAUSE_MUSIC_SERVICE, data, reply, option);
    Logger.info(TAG, `onPauseClick send mssage success`);
  };

  onBackPress() {
    if (this.isDialogShowing === true) {
      this.dismissDialog();
      return true;
    };
    return false;
  };

  onPageHide() {
    if (this.isDialogShowing === true) {
      this.dismissDialog();
      return true;
    };
    return false;
  };

  dismissDialog() {
    if (this.dialogController !== null) {
      this.dialogController.close();
    }
    this.remoteDeviceModel.unregisterDeviceListCallback();
    this.isDialogShowing = false;
  };

  startAbilityContinuation(deviceId: string) {
    let params: Params = {
      uri: '',
      seekTo: 0,
      isPlaying: false
    };
    Logger.info(TAG, `startAbilityContinuation PlayerModel.index= ${PlayerModel.index}/${PlayerModel.playlist.audioFiles.length}`);
    if (PlayerModel.index >= 0 && PlayerModel.index <= PlayerModel.playlist.audioFiles.length) {
      params = {
        uri: PlayerModel.playlist.audioFiles[PlayerModel.index].fileUri,
        seekTo: PlayerModel.getCurrentMs(),
        isPlaying: PlayerModel.isPlaying
      };
    };
    Logger.info(TAG, `context.startAbility deviceId= ${deviceId}`);
    if (this.context !== null) {
      KvStoreModel.setOnMessageReceivedListener(this.context, REMOTE_ABILITY_STARTED, () => {
        Logger.info(TAG, 'OnMessageReceived, terminateSelf');
      });
    };
    Logger.info(TAG, `context.startAbility start`);
    this.clickFlag = MusicSharedStatus.MUSIC_REMOTING;
    this.startRemoteExtension(deviceId, params);
    this.clearSelectState();
    Logger.info(TAG, 'context.startAbility end');
  };

  selectedIndexChange = (selectedIndex: number) => {
    Logger.info(TAG, `this.deviceLists[selectedIndex]:${JSON.stringify(this.deviceLists[selectedIndex])}`);
    Logger.info(TAG, `deviceId:${JSON.stringify(this.deviceLists[selectedIndex].deviceId)}`);
    if (this.context !== null && selectedIndex === 0) {
      this.context.startAbility({ bundleName: 'ohos.samples.distributedmusicplayer',
        abilityName: 'ohos.samples.distributedmusicplayer.MainAbility',
        deviceId: this.deviceLists[selectedIndex]!.deviceId,
        parameters: {
          isFA: 'EXIT'
        }
      }).then(() => {
        Logger.info(TAG, `startAbility finished`);
      }).catch((err: Error) => {
        Logger.info(TAG, `startAbility filed error = ${JSON.stringify(err)}`);
      });
      this.isDistributed = false;
      this.selectedIndex = 0;
      if (this.dialogController !== null) {
        this.dialogController.close();
      }
      this.deviceLists = [];
      return;
    };
    this.selectedIndex = selectedIndex;
    this.selectDevice();
  };

  selectDevice() {
    Logger.info(TAG, 'start ability ......');
    if (this.selectedIndex !== undefined && (this.remoteDeviceModel === null || this.remoteDeviceModel.discoverLists.length <= 0)) {
      Logger.info(TAG, `start ability device:${JSON.stringify(this.deviceLists)}`);
      this.startAbilityContinuation(this.deviceLists[this.selectedIndex].networkId as string);
      this.clearSelectState();
      return;
    };
    Logger.info(TAG, 'start ability, needAuth');
    if (this.selectedIndex !== undefined){
      this.remoteDeviceModel.authDevice(this.deviceLists[this.selectedIndex], (device: deviceManager.DeviceBasicInfo) => {
        Logger.info(TAG, 'auth and online finished');
        this.startAbilityContinuation(device.networkId);
      });
    }
    Logger.info(TAG, 'start ability2 ......');
    this.clearSelectState();
  };

  clearSelectState() {
    this.deviceLists = [];
    if (this.dialogController) {
      this.dialogController.close();
      this.dialogController = null;
    };
  };

  getShownTimer(ms: number) {
    let minStr: string;
    let secStr: string;
    let seconds = Math.floor(ms / ONE_THOUSAND);
    let sec = seconds % SIXTY;
    Logger.info(TAG, `getShownTimer sec = ${sec}`);
    let min = (seconds - sec) / SIXTY;
    Logger.info(TAG, `getShownTimer min = ${min}`);
    if (sec < 10) {
      secStr = '0' + sec;
    } else {
      secStr = sec.toString(10);
    };
    if (min < 10) {
      minStr = '0' + min;
    } else {
      minStr = min.toString(10);
    };
    Logger.warn(TAG, `getShownTimer = ${minStr}:${secStr}`);
    return minStr + ':' + secStr;
  };

  refreshSongInfo(index: number) {
    Logger.info(TAG, `refreshSongInfo ${index}/${PlayerModel.playlist.audioFiles.length}`);
    if (index >= PlayerModel.playlist.audioFiles.length) {
      Logger.warn(TAG, 'refreshSongInfo ignored');
      return;
    };
    // update song title
    this.title = PlayerModel.playlist.audioFiles[index].name;
    this.albumSrc = (index % 2 === 0) ? $r('app.media.album') : $r('app.media.album2');

    // update duration
    this.totalMs = PlayerModel.getDuration();
    this.totalTimeText = this.getShownTimer(this.totalMs);
    this.currentTimeText = this.getShownTimer(PlayerModel.getCurrentMs());
    Logger.info(TAG, `refreshSongInfo this.title= ${this.title}, this.totalMs= ${this.totalMs}, this.totalTimeText= ${this.totalTimeText},this.currentTimeText= ${this.currentTimeText}`);
  };

  onAppSharedClick() {
    if (this.clickFlag === MusicSharedStatus.MUSIC_SHARED) {
      Logger.info(TAG, `1start button is ${JSON.stringify(this.imageArrays[ABILITY_SHARED_BUTTON])}`);
      this.showDialog();
    } else if (this.clickFlag === MusicSharedStatus.MUSIC_STOP_SHARED) {
      Logger.info(TAG, `2start button is ${JSON.stringify(this.imageArrays[ABILITY_SHARED_BUTTON])}`);
      this.stopRemoteExtension();
      this.imageArrays[ABILITY_SHARED_BUTTON] = $r('app.media.ic_hop');
    };
  };

  onPreviousClick() {
    if (this.isSwitching) {
      Logger.info(TAG, 'onPreviousClick ignored, isSwitching');
      return;
    };
    Logger.info(TAG, 'onPreviousClick');
    PlayerModel.index--;
    if (PlayerModel.index < 0 && PlayerModel.playlist.audioFiles.length >= 1) {
      PlayerModel.index = PlayerModel.playlist.audioFiles.length - 1;
    };
    this.currentProgress = 0;
    this.isSwitching = true;

    PlayerModel.preLoad(PlayerModel.index, () => {
      this.refreshSongInfo(PlayerModel.index);
      PlayerModel.play(0, true);
      if (PlayerModel.isPlaying) {
        this.imageArrays[PREVIOUS_CLICK] = $r('app.media.ic_pause');
      };
      this.isSwitching = false;
    });
  };

  onNextClick() {
    if (this.isSwitching) {
      Logger.info(TAG, 'onNextClick ignored, isSwitching');
      return;
    };
    Logger.info(TAG, 'onNextClick');
    PlayerModel.index++;
    if (PlayerModel.index >= PlayerModel.playlist.audioFiles.length) {
      PlayerModel.index = 0;
    };
    this.currentProgress = 0;
    this.isSwitching = true;
    PlayerModel.preLoad(PlayerModel.index, () => {
      this.refreshSongInfo(PlayerModel.index);
      PlayerModel.play(0, true);
      if (PlayerModel.isPlaying) {
        this.imageArrays[PREVIOUS_CLICK] = $r('app.media.ic_pause');
      };
      this.isSwitching = false;
    });
  };

  onPlayClick() {
    if (this.isSwitching) {
      Logger.info(TAG, 'onPlayClick ignored, isSwitching');
      return;
    };
    Logger.info(TAG, `onPlayClick isPlaying= ${PlayerModel.isPlaying}`);
    if (PlayerModel.isPlaying) {
      PlayerModel.pause();
      this.imageArrays[PREVIOUS_CLICK] = $r('app.media.ic_play');
      this.sendMessagePause();
    } else {
      PlayerModel.preLoad(PlayerModel.index, () => {
        PlayerModel.play(DEFAULT_NUM, true);
        this.imageArrays[PREVIOUS_CLICK] = $r('app.media.ic_pause');
        this.sendMessagePlay();
      })
    };
  };

  restoreFromWant() {
    Logger.info(TAG, 'restoreFromWant');
    let status: Record<string, Object> | undefined = AppStorage.get('status');
    if (status !== undefined && status !== null && status.uri !== null) {
      KvStoreModel.broadcastMessage(this.context, REMOTE_ABILITY_STARTED);
      Logger.info(TAG, 'restorePlayingStatus');
      PlayerModel.restorePlayingStatus(status, (index: number) => {
        Logger.info(TAG, `restorePlayingStatus finished, index= ${index}`);
        if (index >= 0) {
          this.refreshSongInfo(index);
        } else {
          PlayerModel.preLoad(0, () => {
            this.refreshSongInfo(0);
          })
        }
        if (status !== undefined) {
          Logger.info(TAG, `Index PlayerModel.restorePlayingStatus this.totalMs = ${this.totalMs}, status.seekTo = ${status.seekTo}`);
          this.currentProgress = Math.floor(Number(status.seekTo) / this.totalMs * ONE_HUNDRED);
        }
      })
    } else {
      PlayerModel.preLoad(0, () => {
        this.refreshSongInfo(0);
      });
    }
  };

  aboutToAppear() {
    Logger.info(TAG, `begin`);
    Logger.info(TAG, 'grantPermission');
    this.context = getContext(this) as common.UIAbilityContext;
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let permission: Array<Permissions> = ['ohos.permission.DISTRIBUTED_DATASYNC'];
    try {
      atManager.requestPermissionsFromUser(this.context, permission).then((data: PermissionRequestResult) => {
        Logger.info(TAG, `data: ${JSON.stringify(data)}`);
      }).catch((err: object) => {
        Logger.info(TAG, `err: ${JSON.stringify(err)}`);
      })
    } catch (err) {
      Logger.info(TAG, `catch err->${JSON.stringify(err)}`);
    }
    display.getDefaultDisplay().then((dis: display.Display) => {
      Logger.info(TAG, `getDefaultDisplay dis= ${JSON.stringify(dis)}`);
      let proportion = DESIGN_WIDTH / dis.width;
      let screenWidth = DESIGN_WIDTH;
      let screenHeight = (dis.height - SYSTEM_UI_HEIGHT) * proportion;
      this.riscale = (screenHeight / screenWidth) / DESIGN_RATIO;
      if (this.riscale < 1) {
        // The screen ratio is shorter than design ratio
        this.risw = screenWidth * this.riscale;
        this.rish = screenHeight;
      } else {
        // The screen ratio is longer than design ratio
        this.risw = screenWidth;
        this.rish = screenHeight / this.riscale;
      }
      Logger.info(TAG, `proportion=${proportion} , screenWidth= ${screenWidth},
      screenHeight= ${screenHeight} , riscale= ${this.riscale} , risw= ${this.risw} , rish= ${this.rish}`);
    })
    Logger.info(TAG, 'getDefaultDisplay end');
    this.currentTimeText = this.getShownTimer(0);
    PlayerModel.setOnStatusChangedListener((isPlaying: string) => {
      Logger.info(TAG, `on player status changed, isPlaying= ${isPlaying} refresh ui`);
      PlayerModel.setOnPlayingProgressListener((currentTimeMs: number) => {
        this.currentTimeText = this.getShownTimer(currentTimeMs);
        this.currentProgress = Math.floor(currentTimeMs / this.totalMs * ONE_HUNDRED);
      });
      if (isPlaying) {
        this.imageArrays[PREVIOUS_CLICK] = $r('app.media.ic_pause');
      } else {
        this.imageArrays[PREVIOUS_CLICK] = $r('app.media.ic_play');
      }
    });

    PlayerModel.getPlaylist(() => {
      Logger.info(TAG, 'on playlist generated, refresh ui');
      this.restoreFromWant();
    });

    AppStorage.setOrCreate('viewThis', this);

    this.connectLocalExtension();
  };

  aboutToDisappear() {
    Logger.info(TAG, `aboutToDisappear begin`)
    if (PlayerModel === undefined) {
      return
    }
    PlayerModel.release()
    this.remoteDeviceModel.unregisterDeviceListCallback()
    this.dialogController = null
    KvStoreModel.deleteKvStore()
    Logger.info(TAG, `aboutToDisappear end`)
  };

  build() {
    Column() {
      Blank()
        .width('100%')
        .height(72)
      Text(this.title)
        .width('100%')
        .fontSize(28)
        .margin({ top: '10%' })
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
      Image(this.albumSrc)
        .width(this.isLand ? '60%' : '89%')
        .objectFit(ImageFit.Contain)
        .margin({ top: 50, left: 40, right: 40 })
      Row() {
        Text(this.currentTimeText)
          .fontSize(20)
          .fontColor(Color.White)
        Blank()
        Text(this.totalTimeText)
          .fontSize(20)
          .fontColor(Color.White)
      }
      .width('90%')
      .margin({ top: '12%' })

      Slider({ value: typeof (this.currentProgress) === 'number' ? this.currentProgress : 0 })
        .trackColor('#64CCE7FF')
        .width('90%')
        .selectedColor('#ff0c4ae7')
        .onChange((value: number, mode: SliderChangeMode) => {
          this.currentProgress = value;
          if (typeof (this.totalMs) !== 'number') {
            this.currentProgress = 0;
            Logger.info(TAG, `setProgress ignored, totalMs= ${this.totalMs}`);
            return;
          };
          let currentMs = this.currentProgress / ONE_HUNDRED * this.totalMs;
          this.currentTimeText = this.getShownTimer(currentMs);
          if (mode === SliderChangeMode.End || mode === 3) {
            Logger.info(TAG, `player.seek= ${currentMs}`);
            PlayerModel.seek(currentMs);
          };
        })

      Row() {
        ForEach(this.imageArrays, (item: Resource, index: number | undefined) => {
          Column() {
            Image(item)
              .size({ width: 74, height: 74 })
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                switch (index) {
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
                  default:
                    break;
                }
              })
          }
          .id('image' + (index !== undefined ? (index + 1) : 0))
          .width(100)
          .height(100)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
        })

      }
      .width('100%')
      .margin({ top: '4%' })
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.bg_blurry'))
    .backgroundImageSize({ width: '100%', height: '100%' })
  }
}