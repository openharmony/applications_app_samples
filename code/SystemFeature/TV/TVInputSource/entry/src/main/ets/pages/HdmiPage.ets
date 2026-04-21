/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { PlayerManager } from '../manager/PlayerManager';
import { promptAction, router, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { InputSourceUtil } from '../utils/InputSourceUtil';
import { MultiPageListenerManager, MultiPageListenerType } from '../manager/MultiPageListenerManager';
import displaySetting from '@ohos.tvservice.displaySetting';
import { SourcePlugState } from '../manager/SourceManager';
import { missionManager } from '@kit.AbilityKit';
import LogUtil from '../utils/LogUtil';
import { inputEventClient, KeyCode } from '@kit.InputKit';
import { power } from '@kit.BasicServicesKit';
import audioSetting from '@ohos.tvservice.audioSetting';
import nativeRender from 'libnativerender.so';

const TAG = 'HdmiPage';
class HdmiXComponentController extends  XComponentController{
  onSurfaceCreated(surfaceId: string): void {
    console.info(`onSurfaceCreated surfaceId: ${surfaceId}`);
    nativeRender.setSurfaceId1(BigInt(surfaceId),BigInt(1));
  }

  onSurfaceChanged(surfaceId: string, rect: SurfaceRect): void {
    console.info(`onSurfaceChanged surfaceId: ${surfaceId}, rect: ${JSON.stringify(rect)}}`);
    nativeRender.changeSurface(BigInt(surfaceId), rect.surfaceWidth, rect.surfaceHeight);
    nativeRender.drawTransparentBuffer(BigInt(surfaceId));
  }

  onSurfaceDestroyed(surfaceId: string): void {
    console.info(`onSurfaceDestroyed surfaceId: ${surfaceId}`);
    nativeRender.destroySurface(BigInt(surfaceId));
  }
}
@Entry
@Component
struct HdmiPage {
  private cecStandbyCallback?: () => void;
  private cecSelectSourceCallback?: (sourceType: displaySetting.SourceType) => void;
  @State surfaceId: string = '';
  @State sourceName: string = ''
  @State isSearch: boolean = true; // 搜索态
  @State isPlay: boolean = false; // 播放态
  @State isPlaying: boolean = true; // 新增：播放/暂停状态
  searchTimeout: number = 20000; // 搜索时间20s;
  searchTimerId: number = -1;
  missionId: number = -1;
  sourcePlay: PlayerManager = PlayerManager.getInstance();
  storage: LocalStorage = LocalStorage.getShared();
  sourceId: number = 0;
  playerListener: MultiPageListenerType = {
    id: 'HdmiPage',
    onPlugChange: (plugState: SourcePlugState) => {
      if (plugState.source === this.sourceId) {
        this.startCheckSignalStatus();
      }
    }
  }
  xComponentController: XComponentController = new HdmiXComponentController();
  aboutToAppear(): void {
    console.log('_+_+_+_+_+_+_wantDataonload');
    if(AppStorage.get('sourceId_reboot')==-1){
      console.log('_+_+_+_+_+_+_wantDataonload跳转');
      const params = router.getParams() as object;
      this.sourceId =params['sourceId'];
    }else{
      console.log('_+_+_+_+_+_+_wantDataonload开机');
      this.sourceId = AppStorage.get('sourceId_reboot') as number;
    }
    console.log('_+_+_+_+_+_+_wantDataonload3'+JSON.stringify(this.sourceId));
    this.sourceName = InputSourceUtil.getSourceName(this.sourceId);
    this.startSearch();
  }

  tabClick() {
    LogUtil.debug(`tabClick`);
    let tabDown: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 1,
      isIntercepted: false
    };
    inputEventClient.injectKeyEvent({ keyEvent: tabDown });
    let tabUp: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    inputEventClient.injectKeyEvent({ keyEvent: tabUp });
  }

  aboutToDisappear(): void {
    this.closeSearch();
  }

  getMission() {
    try {
      missionManager.getMissionInfos('', 10, (err, missions) => {

        LogUtil.info(`HmLog missions = ${JSON.stringify(missions)}`);
        missions.forEach((item) => {
          if (item.want.abilityName === 'EntryAbility' && item.want.bundleName === 'com.ohos.inputsource') {
            return;
          }
          if (globalThis.pullBundleName == item.want.bundleName) {
            this.missionId = item.missionId;
            console.log('1111111111', JSON.stringify(item));
          }
        });
        LogUtil.info(`HmLog missionId=${this.missionId}`);
      });
    } catch (err) {
      LogUtil.info(`HmLog missions err:${err.message}`);
    }
  }

  onBackPress(): boolean | void {
    if(!this.isPlay){
      setTimeout(()=>{
        router.back();
      },300);
      return true;
    }else{
      console.log('aquefh');
      this.setCecMenuCtrlCmd(5);
      return true;
    }
  }

  onPageShow(): void {
    this.missionId = -1;
    this.getMission();
    // 开启常亮
    this.keepScreenOn(true);
    // 绑定源
    console.log('this.sourceId ', this.sourceId);
    this.sourcePlay.bindSource(this.sourceId, () => {
      console.log('bindSource');
      this.startCheckSignalStatus();
    });

    this.startCheckSignalStatus();

    // 发布开始播放事件
    this.sourcePlay.publishSourcePlayStart();

    // 注册监听器
    this.registerListener();
    this.registerCecListeners();
  }
  registerCecListeners() {
    // 待机事件
    try {
      this.cecStandbyCallback = () => {
        console.log('CEC standby received');
          try {
            power.suspend();
            console.log(TAG, 'onCecStandByCallback suspend succeeded');
          } catch (err) {
            console.log(TAG, 'onCecStandByCallback suspend1 failed. info:'+JSON.stringify(err));
          }
      };
      // 使用新的 on 接口注册
      displaySetting.on('CecStandBy', this.cecStandbyCallback);
    } catch (err) {
      console.error(`CEC standby registration failed: ${JSON.stringify(err)}`);
    }

    // 源选择事件
    try {
      this.cecSelectSourceCallback = (sourceType: displaySetting.SourceType) => {
        console.log(`CEC source select: ${sourceType}`);
        if (sourceType !== this.sourceId) {
          this.sourceId = sourceType;
          this.sourcePlay.bindSource(this.sourceId, () => {
            console.log('bindSource');
            this.startCheckSignalStatus();
          });
          // 发布开始播放事件
          this.sourcePlay.publishSourcePlayStart();
        }
      };
      // 使用新的 on 接口注册
      displaySetting.on('CecSelectSource', this.cecSelectSourceCallback);
    } catch (err) {
      console.error(`CEC source select registration failed: ${JSON.stringify(err)}`);
    }
  }

  onPageHide(): void {
    // 取消常亮
    this.keepScreenOn(false);
    // 取消输入源绑定
    this.sourcePlay.unBindSource(this.sourceId, () => {

    });
    // 发布结束播放事件
    this.sourcePlay.publishSourcePlayEnd();

    // 注销监听器
    this.unRegisterListener();
    this.unregisterCecListeners();
  }
  unregisterCecListeners() {
    // 待机事件
    if (this.cecStandbyCallback) {
      try {
        // 使用新的 off 接口注销
        displaySetting.off('CecStandBy', this.cecStandbyCallback);
      } catch (err) {
        console.error(`CEC standby unregistration failed: ${JSON.stringify(err)}`);
      } finally {
        this.cecStandbyCallback = undefined;
      }
    }

    // 源选择事件
    if (this.cecSelectSourceCallback) {
      try {
        // 使用新的 off 接口注销
        displaySetting.off('CecSelectSource', this.cecSelectSourceCallback);
      } catch (err) {
        console.error(`CEC source select unregistration failed: ${JSON.stringify(err)}`);
      } finally {
        this.cecSelectSourceCallback = undefined;
      }
    }
  }

  // 开始检查信号源状态
  async startCheckSignalStatus() {
    const isAvailable = await InputSourceUtil.isSourceAvailable();
    console.log('isAvailable ', isAvailable);
    if (isAvailable) {
      this.startPlayer();
      this.isPlay = true;
      this.isPlaying = true; // 默认播放状态;
      if (this.searchTimerId != -1) {
        clearTimeout(this.searchTimerId);
      }
      // todo 设置预览源
    } else {
      this.stopPlayer();
      this.isPlay = false;
      this.isPlaying = false; // 无信号时暂停状态;
      if (this.searchTimerId === -1) {
        this.startSearch();
      }
    }
  }

  startPlayer() {
    if (this.sourcePlay) {
      this.sourcePlay.publishSourcePlayStart();
    }
  }

  stopPlayer() {
    if (this.sourcePlay) {
      this.sourcePlay.publishSourcePlayEnd();
    }
  }

  // 注册监听器
  registerListener() {
    MultiPageListenerManager.getInStance().register(this.playerListener);
    InputSourceUtil.registerSignalListener((signalStatus: displaySetting.SignalStatus) => {
      console.log('registerSignalListener');
      console.log('registerSignalListener signalStatus ' + JSON.stringify(signalStatus));
      this.startCheckSignalStatus();
    });
  }

  // 注销监听器
  unRegisterListener() {
    InputSourceUtil.unregisterSignalListener();
    MultiPageListenerManager.getInStance().unregister(this.playerListener);
  }

  // 设置常亮
  keepScreenOn(isKeepScreenOn: boolean) {
    window.getLastWindow(getContext(this)).then((windowClass: window.Window) => {
      try {
        windowClass.setWindowKeepScreenOn(isKeepScreenOn, (err: BusinessError) => {
          const errCode: number = err.code;
          if (errCode) {
            console.error(`Failed to set the screen to be always on. Cause code: ${err.code}, message: ${err.message}`);
            return;
          }
          console.info('Succeeded in setting the screen to be always on.');
        });
      } catch (exception) {
        console.error(`Failed to set the screen to be always on. Cause code: ${exception.code}, message: ${exception.message}`);
      }
    });
  }

  // 杀死自身进程
  killProcess() {
    let applicationContext = getContext(this).getApplicationContext();
    applicationContext.killAllProcesses();
  }

  // 开启搜索
  startSearch() {
    this.isSearch = true;
    this.searchTimerId = setTimeout(() => {
      // 搜索超时，关闭搜索
      this.isSearch = false;
    }, this.searchTimeout);
  }

  // 关闭搜索
  closeSearch() {
    clearTimeout(this.searchTimerId);
    this.searchTimerId = -1;
    this.isSearch = false;
  }

  // 新增：播放/暂停切换
  async togglePlayback() {
    console.log(TAG, 'onClick=this.isPlay=='+JSON.stringify(this.isPlay));
    if (!this.isPlay) {
      return; // 确保有信号
    }
    try {
      // 切换播放状态
      this.isPlaying = !this.isPlaying;
      console.log(TAG, 'onClick=this.isPlaying=='+JSON.stringify(this.isPlaying));
      // 冻结/解冻画面
      // await displaySetting.freezeSurface(!this.isPlaying);
    } catch (e) {
      console.log(TAG, `onClick=Toggle playback failed: ${JSON.stringify(e)}`);
    }
  }

  async setCecMenuCtrlCmd(setCecMenuCtrlCmdNumber: number) {
    try {
      LogUtil.log(TAG + 'setSetCecMenuCtrlCmdNumber==:' + JSON.stringify(setCecMenuCtrlCmdNumber));
      let setCecMenuCtrlCmdSuccess: boolean = await audioSetting.SetCecMenuCtrlCmd(setCecMenuCtrlCmdNumber);
      LogUtil.log(TAG + 'setSetCecMenuCtrlCmd SuccessBoolean==:' + JSON.stringify(setCecMenuCtrlCmdSuccess));
      if (!setCecMenuCtrlCmdSuccess) {
        promptAction.showToast({ message: '设置menu cmd失败' });
      }
    } catch (error) {
      LogUtil.log(TAG + 'setCecMenuCtrlCmd fail=' + JSON.stringify(error));
      promptAction.showToast({ message: '接口报错' });
    }
  }

  build() {
    Column() {
      if (!this.isPlay) {
        LoadingProgress()
          .color('rgba(255, 255, 255, 0.6)')
          .width('128lpx')
          .height('128lpx')
          .margin({ bottom: '48lpx' });
        Column() {
          if (this.isSearch) {
            Text(`${this.sourceName} 信号检索中...`)
              .fontColor('rgba(255, 255, 255, 0.86)')
              .fontSize('36lpx')
              .fontWeight(500)
              .margin({ bottom: '12lpx' });
          }
          if (!this.isSearch) {
            Text(`${this.sourceName} 未检测到信号，点击←返回输入源列表`)
              .fontColor('rgba(255, 255, 255, 0.86)')
              .fontSize('36lpx')
              .fontWeight(500)
              .margin({ bottom: '12lpx' });
          }
          Text('请确保机顶盒等输入源设备已连接，且处于开启状态')
            .fontColor('rgba(255, 255, 255, 0.86)')
            .fontSize('36lpx')
            .fontWeight(400);
        }
      } else {
          XComponent({
          id: 'xComponent',
          type: XComponentType.SURFACE,
          controller: this.xComponentController
        }).onLoad(async () => {
          console.log(TAG, 'setSurfaceId onLoadXComponent');
          this.tabClick();
        }).height('100%').width('100%').backgroundColor(Color.Transparent).focusable(true).defaultFocus(true)
          .onKeyEvent((e?: KeyEvent) => {
            if (!e) {
              return;
            }
            if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
              e.type == KeyType.Down) {
              // console.log('aque')
              this.SetCecMenuCtrlCmd(6);
            }else if(e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down){
              console.log('aques');
              this.SetCecMenuCtrlCmd(1);
            }else if(e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down){
              console.log('aquex');
              this.SetCecMenuCtrlCmd(2);
            }else if(e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down){
              console.log('aquez');
              this.SetCecMenuCtrlCmd(3);
            }else if(e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down){
              console.log('aquey');
              this.SetCecMenuCtrlCmd(4);
            }else if(e.keyCode == KeyCode.KEYCODE_BACK && e.type == KeyType.Down){
              console.log('aquey返回');
              this.SetCecMenuCtrlCmd(5);
            }
          });
      }
    }
    .width('100%')
    .height('100%')
    .focusable(true)
    .backgroundColor('#000000')
    .justifyContent(FlexAlign.Center);
  }
}
