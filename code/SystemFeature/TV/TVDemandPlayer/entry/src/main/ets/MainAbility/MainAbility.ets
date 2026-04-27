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
import { UIAbility as Ability } from '@kit.AbilityKit';
import { window as Window } from '@kit.ArkUI';
import { deviceInfo } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import {
  initInfo,
  userGrantPermission,
  getAppWindowSize,
  getScreenOrientation,
  DistributedManager
} from '@ohos/utilslibrary';
import { Want } from '@kit.AbilityKit';
import { UrlType } from '../const/Type';
import { AbilityConstant } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { VideoAVPlayerClass } from '../Model/AvPlayer';
import { common } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { router } from '@kit.ArkUI';

let log = initInfo('MainAbility');
const BUNDLENAME = 'com.ohos.demandplayer';
const ABILITYNAME = 'MainAbility';
const FILE_MANAGER_ACTION = 'ohos.want.action.viewData';
let transferManager = DistributedManager.getInstance();
let AVPLAYER: VideoAVPlayerClass = new VideoAVPlayerClass()

export default class MainAbility extends Ability {
  changeWant(want: Want) {
    globalThis.abilityWant = want
    globalThis.isTransferData = false;
    globalThis.startByLauncher = false;
    globalThis.startByOther = false;
    globalThis.startByFileMgr = false;
    globalThis.isPlay = true
    let sessionId = ''
    let videoIndex = 0;
    let url = '';
    let currentTime = 0;
    let videoList: UrlType[] = [];
    let isPlay = true
    let sourceDeviceId = ''
    // 分布式流转
    if (want.parameters?.startBy && want.parameters?.startBy == BUNDLENAME) {
      globalThis.isTransferData = true;

      videoIndex = want.parameters?.videoIndex as number;
      currentTime = want.parameters?.currentTime as number;
      url = want.parameters?.url as string;
      isPlay = want.parameters?.isPlay as boolean
      sourceDeviceId = want.parameters?.sourceDeviceId as string
      videoList = JSON.parse(want.parameters?.videoList as string);
      globalThis.currentTime = currentTime;
      globalThis.videoIndex = videoIndex;
      globalThis.isPlay = isPlay
      globalThis.sourceDeviceId = sourceDeviceId
      console.log(`HmLog-->isPlay:${globalThis.isPlay},sourceId:${globalThis.sourceDeviceId}`);
      AppStorage.setOrCreate<Array<UrlType>>('video_list', videoList)
      this.establishmentConnections()
    }

    // 沉浸式点播
    if (want.parameters?.startByLauncher) {
      globalThis.startByLauncher = true;
      videoIndex = want.parameters?.videoIndex as number;
      globalThis.currentTime = 0;
      globalThis.videoIndex = videoIndex;

      videoList.push({
        uri: want.parameters?.uri as string || '',
        url: want.parameters?.url as string,
        type:want.parameters?.type as string || 'http',
        displayName: want.parameters?.name as string,
        resolution: '1080P',
        resolutions: []
      })
      url = videoList[videoIndex].url as string;

      AppStorage.setOrCreate<Array<UrlType>>('video_list', videoList)
    }
    AppStorage.setOrCreate('startByOtherApp', true)

    //其他应用拉起
    if (want.parameters?.startByOther) {
      globalThis.startByOther = true;
      videoIndex = want.parameters?.videoIndex as number;

      let urlList: UrlType[] = want.parameters?.videoList as UrlType[];

      globalThis.currentTime = 0;
      globalThis.videoIndex = videoIndex;

      urlList.forEach(t => {
        const filePath: string = typeof t.url === 'string' ? t.url : '';
        if (!filePath) {
          return;
        }
        const fd = fs.openSync(filePath, fs.OpenMode.READ_ONLY).fd;
        videoList.push({
          uri: 'fd://' + fd + '',
          url: 'fd://' + fd + '',
          displayName: t.name,
          resolution: '1080P',
          resolutions: [],
          createTime: '',
          type: 'local',
          deviceType: 1
        })
      })
      url = videoList[videoIndex].url as string;
      AppStorage.setOrCreate<Array<UrlType>>('video_list', videoList)
    }
    AppStorage.setOrCreate('sessionId', sessionId);

    let videoUri: string = want?.parameters?.uri as string;
    if (videoUri && want?.action === FILE_MANAGER_ACTION) {
      // from file manager
      let fdPath = 'fd://' + fs.openSync(videoUri)?.fd;
      log('changeWant from file manager, videoUri=' + videoUri + ' fdPath:' + fdPath);
      AppStorage.setOrCreate('fdPath',fdPath)
      AppStorage.setOrCreate('videoUri',videoUri)

      globalThis.startByFileMgr = true;
      globalThis.videoIndex = 0;
      videoList.push({
        uri: fdPath,
        url: fdPath,
        displayName: want?.parameters?.name as string,
        resolution: '1080P',
        resolutions: [],
        createTime: '',
        type: 'local'
      })
      AppStorage.setOrCreate<Array<UrlType>>('video_list', videoList);
    }
    let subtitleUrl:string[]= want?.parameters?.subtitles as string[]
    if(subtitleUrl){
      AppStorage.setOrCreate('subtitleUrl',subtitleUrl[0])
    }
  }

  establishmentConnections(){
    console.log('establishmentConnections in');
    let want: Want = {
      deviceId:globalThis.sourceDeviceId,
      bundleName: 'com.ohos.demandplayer',
      abilityName: 'ServiceAbility'
    };
    let options: common.ConnectOptions = {
      onConnect: (elementName, remote) => {
        console.info('establishmentConnections callback onConnect');
        globalThis.interactiveProxy = remote as rpc.RemoteProxy;
      },
      onDisconnect: (elementName) => {
        console.info('establishmentConnections callback onDisconnect');
      },
      onFailed: (code) => {
        console.info('establishmentConnections callback onFailed');
      }
    };
    try {
      this.context.connectServiceExtensionAbility(want, options);
    } catch (e) {
      console.info(`ConnectServiceExtensionAbility has failed,
        want= ${JSON.stringify(want)}, err= ${JSON.stringify(e)}`)
    }
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    console.log('Ability onCreate',JSON.stringify(want));
    AppStorage.setOrCreate('videoPlay', false);
    AppStorage.setOrCreate('videoPause', false);
    globalThis.abilityContext = this.context;
    globalThis.deviceType = 'default';
    AVPLAYER.init().then(()=>{
      AppStorage.setOrCreate('avplayer',AVPLAYER)
    })
    globalThis.PlayCounter = 0
    let softwareModel = deviceInfo.softwareModel.toLowerCase();
    if (softwareModel.startsWith('tv')) {
      globalThis.deviceType = 'tv';
    }

    globalThis.transferManager = transferManager;

    globalThis.videoIndex = 0;
    this.changeWant(want);
  }

  onDestroy() {
    log('Ability onDestroy');
    if (transferManager) {
      transferManager.release();
    }
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    console.log('onWindowStageCreate');
    globalThis.abilityContext = this.context;

    windowStage.getMainWindow().then((win) => {
      win.setWindowLayoutFullScreen(true)
      globalThis.mainWindow = win;
      win.setWindowKeepScreenOn(true).then(() => {
      })

      getScreenOrientation().then(res => {
        globalThis.orientation = res;
        console.log(`getScreenOrientation :${res}`)
      })

      getAppWindowSize(win).then((data) => {
        log('getAppWindowSize data:' + JSON.stringify(data));
        AppStorage.setOrCreate<number>('screen_px_w', data.pageW)
        AppStorage.setOrCreate<number>('screen_px_h', data.pageH)
        AppStorage.setOrCreate<number>('screen_lpx_w', data.width)
        AppStorage.setOrCreate<number>('screen_lpx_h', data.height)
        AppStorage.setOrCreate<number>('screen_dpi', data.dpi)
        AppStorage.setOrCreate<number>('screen_lpi', data.lpi)
        globalThis.lpi = data.lpi;
        globalThis.lpiPx = (num: number) => {
          return globalThis.lpi * num + 'px';
        };

        let loadContentUrl = 'pages/Index';
        if (
          globalThis.isTransferData ||
          globalThis.startByLauncher ||
          globalThis.startByOther ||
          globalThis.startByFileMgr
        ) {
          loadContentUrl = 'pages/VideoPlayer';
        }

        windowStage.loadContent(loadContentUrl, (err, data) => {
          if (err.code) {
            log('Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
            return;
          }
          if (transferManager) {
            transferManager.startScan();
          }
          if (globalThis.deviceType == 'default') {
            userGrantPermission(globalThis.abilityContext, {
              permissions: [
                {
                  "name": "ohos.permission.READ_MEDIA"
                },
                {
                  "name": "ohos.permission.WRITE_MEDIA"
                },
                {
                  "name": "ohos.permission.MEDIA_LOCATION"
                },
                {
                  "name": "ohos.permission.READ_IMAGEVIDEO"
                },
                {
                  "name": "ohos.permission.READ_AUDIO"
                },
                {
                  "name": "ohos.permission.READ_DOCUMENT"
                },
                {
                  "name": "ohos.permission.DISTRIBUTED_DATASYNC"
                },
                {
                  "name": "ohos.permission.MICROPHONE"
                }
              ]
            })
          }
        })
      })
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    log('Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    log('Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    log('Ability onBackground');
  }

  onNewWant(want: Want) {
    log('Ability onNewWant');
    if (want.parameters) {
      if (want.parameters.startBy && want.parameters.startBy == BUNDLENAME) {
        if (want.parameters.stopTransfer) {
          globalThis.abilityContext.terminateSelfWithResult({
            resultCode: 1, want: want
          }).then(() => {
            log('terminateSelfWithResult success');
          })
          return;
        }
        this.changeWant(want);
        if (globalThis.isTransferData) {
          globalThis.mainWindow.loadContent('pages/VideoPlayer', (err: BusinessError) => {
            if (err.code) {
              log('Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
              return;
            }
          });
        }
      } else {
        if (want.parameters.videoList || want.type === 'video/*'|| want.parameters.uri) {
          AppStorage.setOrCreate('isNewTransferVideo', true)
          this.changeWant(want);
          console.log('==== 播放视频 ===')
          try {
            // 播放视频
            router?.replaceUrl({
              url: 'pages/VideoPlayer'
            }, router.RouterMode.Standard)
          } catch (e) {
            console.log('router error', e)
          }
        }
      }
    }

  }
}
