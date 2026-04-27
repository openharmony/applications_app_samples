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

/* 视频播放器 */

import { media } from '@kit.MediaKit';
import { getScreenSize, getVideoSize } from '../utils/Utils';
import { KeyCode } from '@kit.InputKit';
// import NoticeTemplate from '../common/NoticeTemplate'
import ProgramInfo from './ProgramInfo';
// TV 专有多媒体接口暂无等价 Kit 封装，保留现有业务实现方式。
import automatedSearch from '../common/AutomatedSearch';
import dtvnoChannel from '../common/DtvNoChannel';
import { insightIntent } from '@kit.AbilityKit';
import { ImageSettingIndex } from './menu/imagesetting/ImageSettingIndex';
import deletechannel from '../common/DeleteChannel';
import { BusinessError } from '@kit.BasicServicesKit';
import LogUtil from '../utils/LogUtil';
import { router } from '@kit.ArkUI';
import dvbSetting from '@ohos.tvservice.dvbSetting';
import { promptAction } from '@kit.ArkUI';
interface IMenu {
  id: number,
  name: string,
  leftIcon: Resource,
  defImg: Resource,
  onClick: () => void
}
interface IMenuList {
  id: number,
  name: string,
}

interface IVideo {
  id: string;
  url: string;
  channelName: string;
  serviceId: number;
}
interface VideoSize {
  width: number;
  height: number;
}

function log(str: string) {
  console.log(TAG + str);
}
const TAG = 'Indexdtv';

@Entry
@Component
struct Indexdtv {
  @State
  @Watch('aspectRatioTextChange')
  aspectRatioText: string = '自动'
  @State hasVideo: boolean = false; // 新增状态：是否有视频画面
  @State isPlaying: boolean = false; // 新增播放状态
  @State nums: number = -1;
  @State xComponentShow:boolean=true;
  private avPlayer: media.AVPlayer | null = null;
  @State playerState: string = 'idle';
  @State isEdit: boolean = false
  @State searchManually:boolean=false
  @State channelSorting:boolean=false
  @State channelSettings:boolean=false
  @State captionSettingSecond:boolean=false;
  @State captionSettingFirst:boolean=false;
  @State captionSettingLanguage:boolean=false;
  @State captionSettings:boolean=false
  @State soundMode:boolean=false;
  @State channel:boolean=false;
  @State audioLanguageSecond:boolean=false;
  @State audioLanguageFirst:boolean=false;
  @State audioLanguage:boolean=false;
  @State track:boolean=false;
  @State soundSettings:boolean=false
  @State imageMode:boolean=false;
  @State aspectRatioState:boolean=false;
  @State settingIndexSecond:boolean=false;
  @State settingIndexFirst:boolean=false;
  @State imageSettingIndexOn:boolean=false
  private listScroller1: Scroller = new Scroller();
  @State backNumberList:number=1;
  @State searchType1:number=1;
  @State searchType2:number=1;
  @State listFirstIndex: number = -1
  @State listSecondIndex: number = -1
  @State listSecondIndex2: number = -1
  @State listSearch:number=-1;
  @State searchType:number=-1;
  @State menuFirst:boolean=true;
  @State menuSmall:boolean=false;
  @State menuSearch:boolean=false;
  @State videoList: Array<IVideo> = []; // 视频列表
  @State videoIndex: number = 0; // 当前视频 index
  scroller: Scroller = new Scroller();
  dtvXComponentController: XComponentController = new XComponentController();
  streamTimeoutId: number = -1;
  barTimeoutId: number = -1;
  animationDuration : number = 200;
  @State surfaceId: string = '';
  @State screenW: number = 1920;
  @State screenH: number = 1080;
  @StorageLink('screen_px_w')
  pageW: number = AppStorage.get<number>('screen_px_w') || 1920;
  @StorageLink('screen_px_h')
  pageH: number = AppStorage.get<number>('screen_px_h') || 1080;
  @State dpi: number = 2;
  @State lpi: number = 1;
  @State firstOk: boolean = true; // 是否第一次 OK 键
  @State
  videoWidth: number = AppStorage.get<number>('screen_px_w') || 1920;
  @State
  videoHeight: number = AppStorage.get<number>('screen_px_h') || 1080;

  @State menuOffsetX: number = -740;
  @State isMenuShow: boolean = false;
  @State signal: number = 1;

  @State encrypt:boolean=false;
  @State signalSearching: boolean = false;
  @State signalSearchingNo: boolean = false;

  menuList: IMenu[] = [
    {
      id: 1,
      name: '全部频道',
      leftIcon: $r('app.media.m_channelfous'),
      defImg: $r('app.media.m_channel'),
      onClick: () => {

      }
    },
    {
      id: 2,
      name: '搜索',
      leftIcon: $r('app.media.m_searchfous'),
      defImg: $r('app.media.m_search'),
      onClick: () => {

      }
    }
  ];
  menuList1: IMenuList[] = [
    {
      id: 1,
      name: '自动搜台',
    },
    {
      id: 2,
      name: '手动搜台',
    }
  ];
  @State videoFocusId: string = '';
  @State playingUrl: string = '';
  @State isIndexDialogShow: boolean = false;
  @State isIndexChannelInfoShow: boolean = false;
  @State isXComLoad: boolean = false;
  onPageShowTime: number = 0;
  setedDisplaySurface: boolean = false;

  private buildDefaultVideoList(): Array<IVideo> {
    return [
      { id: '1', url: 'local://dtv-cctv-1', channelName: 'cctv-1', serviceId: 88 },
      { id: '2', url: 'local://dtv-cctv-2', channelName: 'cctv-2', serviceId: 11 },
      { id: '3', url: 'local://dtv-cctv-3', channelName: 'cctv-3', serviceId: 2 },
    ];
  }

  @State programName : string = '100NBC'
  @State programDatetime : string = '2022年12月2日 星期一 09:47'
  @State programEpgCurrent : string = '朝闻天下'
  @State programEpgAfter : string = '新闻联播'
  @State message: string = '搜索电视频道后即可观看电视节目';
  @State title: string = '是否进行自动搜台?';

  @State dtvmessage: string = '请确认 TV 天线接入正常并重新搜台?';
  @State dtvtitle: string = '没有搜到任何频道';

  @State channelInformation: boolean = false;

  controller: CustomDialogController = new CustomDialogController({
    builder: automatedSearch({
      confirm: this.onConfirm,
      message: this.message,
      title: this.title,
    }),
    openAnimation: {
      duration: 500
    },
    gridCount: 12,
    alignment: DialogAlignment.Center,
    customStyle: true,
    autoCancel:false
  });
  controllerdtv: CustomDialogController = new CustomDialogController({
    builder: dtvnoChannel({
      dtvmessage: this.dtvmessage,
      dtvtitle: this.dtvtitle,
    }),
    openAnimation: {
      duration: 500
    },
    gridCount: 12,
    alignment: DialogAlignment.Center,
    customStyle: true,
    autoCancel:false
  });
  onConfirm() {
    router.pushUrl({ url: 'pages/SearchPage' }, router.RouterMode.Single);
  }
  // 播放/暂停切换方法
  togglePlayPause() {
    if (!this.avPlayer) {
      return;
    }
    if (this.isPlaying) {
      this.avPlayer.pause();
      this.isPlaying = false;
    } else {
      this.avPlayer.play();
      this.isPlaying = true;
    }
  }
  // 播放器初始化
  async initPlayer() {
    try {
      LogUtil.log(TAG + 'initPlayer'+JSON.stringify(this.surfaceId));
      // 创建播放器实例
      this.avPlayer = await media.createAVPlayer();
      LogUtil.log(TAG + 'initPlayer'+JSON.stringify(!this.avPlayer));
      this.playerState = 'created';
      // 设置状态监听
      this.avPlayer.on('stateChange', (state: string) => {
        LogUtil.log(TAG + 'initPlayer stateChange=='+JSON.stringify(state));
        this.playerState = state;
        switch (state) {
          case 'initialized':
            this.avPlayer!.surfaceId = this.surfaceId;
            this.avPlayer!.prepare();
            break;
          case 'prepared':
            this.avPlayer!.play();
            this.isPlaying = true; // 设置播放状态
            break;
          case 'playing':
            this.isPlaying = true; // 更新播放状态
            this.hasVideo = true; // 设置视频画面状态
            break;
          case 'paused':
            this.isPlaying = false; // 更新暂停状态
            break;
          case 'completed':
            this.isPlaying = false; // 播放完成
            break;
          case 'stopped':
            this.isPlaying = false; // 停止状态
            this.hasVideo = false;
            break;
          case 'error': // 新增：出错时隐藏视频
            this.hasVideo = false;
            break;
          case 'idle': // 新增：空闲时隐藏视频
            this.hasVideo = false;
            break;
        }
      });
      // 设置播放源
      this.setPlayUrl();
    } catch (err) {
      this.hasVideo = false; // 出错时隐藏视频
    }
  }
  restartPlayback() {
    if (this.avPlayer) {
      console.info(TAG, 'Restarting playback');
      // 重置播放位置到开头
      this.avPlayer.seek(0);
      // 重新开始播放
      this.avPlayer.play();
    }
  }
  setPlayUrl() {
    LogUtil.log(TAG + 'setPlayUrl'+JSON.stringify(!this.avPlayer));
    if (!this.avPlayer) {
      return;
    }
    try {
      const url = this.videoList[Number(this.nums)].url;
      this.avPlayer.url = url;
    } catch (err) {
    }
  }
  // 释放播放器资源
  async releasePlayer() {
    if (!this.avPlayer) {
      return;
    }
    try {
      // 移除所有监听器
      this.avPlayer.off('stateChange');
      this.avPlayer.off('error');
      this.avPlayer.off('timeUpdate');
      this.avPlayer.off('durationUpdate');
      this.avPlayer.off('bufferingUpdate');
      this.avPlayer.off('seekDone');
      // 停止并释放播放器
      await this.avPlayer.stop();
      await this.avPlayer.reset();
      await this.avPlayer.release();
    } catch (err) {

    } finally {
      this.avPlayer = null;
      this.playerState = 'released';
    }
  }

  // 切换视频
  async changeVideo(index: number) {
    try {
      // 释放当前播放器
      await this.releasePlayer();
      // 更新当前视频索引
      this.nums = index;
      // 重新初始化播放器
      await this.initPlayer();
    } catch (err) {

    }
  }
  aspectRatioTextChange(){
    console.log('变化+++'+this.aspectRatioText);
  }
  setDisplayRatio() {
    if (this.avPlayer) {
      let originalWidth = this.avPlayer.width;
      let originalHeight = this.avPlayer.height;
      let videoWidth: number;
      let videoHeight: number;
      let optimalSize: VideoSize;
        if (this.aspectRatioText=='自动') {
          // 智能适配模式 - 长边适应屏幕
          optimalSize = this.calculateOptimalVideoSize(originalWidth, originalHeight);
        } else if (this.aspectRatioText == '4:3' || this.aspectRatioText == '16:9') {
          // 传统模式 - 使用 getVideoSize(4:3/16:9)
          let videoSize = getVideoSize(
            this.pageW,
            this.pageH,
            originalWidth,
            originalHeight,
            this.aspectRatioText
          );
          optimalSize = { width: videoSize.width, height: videoSize.height };
        } else {
          optimalSize = {
            width: AppStorage.get<number>('screen_px_w') || 1920,
            height: AppStorage.get<number>('screen_px_h') || 1080
          };
        }
        videoWidth = optimalSize.width;
        videoHeight = optimalSize.height;

      this.videoWidth = videoWidth;
      this.videoHeight = videoHeight;
      if (this.surfaceId) {
        this.dtvXComponentController.setXComponentSurfaceRect({
          surfaceWidth: videoWidth,
          surfaceHeight: videoHeight
        });
      }
    }
  }
  // 智能计算旋转后的视频尺寸 - 长边适应屏幕原则
  calculateOptimalVideoSize(videoWidth: number, videoHeight: number): VideoSize {
    // 计算视频和屏幕的宽高比
    let videoRatio = videoWidth / videoHeight;
    let screenRatio = this.pageW / this.pageH;

    let finalWidth: number;
    let finalHeight: number;

    // 智能适配：较长边总是占满，较短边按比例缩放
    if (videoRatio > screenRatio) {
      // 视频更宽，宽度占满屏幕
      finalWidth = this.pageW;
      finalHeight = this.pageW / videoRatio;
    } else {
      // 视频更高，高度占满屏幕
      finalHeight = this.pageH;
      finalWidth = this.pageH * videoRatio;
    }

    log(`[VIDEO_ROTATION] 智能适配: 视频${videoWidth}x${videoHeight}(${videoRatio.toFixed(2)}), 屏幕${this.pageW}x${this.pageH}(${screenRatio.toFixed(2)}), 结果${finalWidth}x${finalHeight}`);
    return { width: Math.round(finalWidth), height: Math.round(finalHeight) };
  }

  aboutToAppear() {
    log('aboutToAppear');
    log('aboutToAppear end');
    LogUtil.log(TAG + 'aboutToAppear');
    this.signalSearching = true;
    setTimeout(()=>{
      this.signalSearching = false;
      this.controller.open();
    },5000);
  }

  async aboutToDisappear() {
    LogUtil.log(TAG + 'aboutToDisappear-----');
    await this.releasePlayer();
  }

  // 单独处理返回按键
  onBackPress() {
    if(this.isIndexDialogShow&&this.menuFirst){
      if(this.listSecondIndex==1||this.listSecondIndex==2){
        this.isIndexDialogShow=false;
        return true;
      }
    }
    if(this.isIndexDialogShow&&!this.menuFirst&&this.menuSmall&&this.listSecondIndex2==1){
      this.backNumberList=this.listFirstIndex;
      this.listSecondIndex2=-1;
      this.menuSmall=false;
      focusControl.requestFocus('listSecond1');
      this.menuFirst=true;
      return true;
    }
    if (
      this.isIndexDialogShow &&
      !this.menuFirst &&
      this.menuSmall &&
      this.listSecondIndex2 == 2 &&
      this.menuSearch &&
      this.searchType == -1
    ) {
      this.listSecondIndex2=-1;
      this.menuSmall=false;
      this.menuSearch=false;
      focusControl.requestFocus('listSecond2');
      this.menuFirst=true;
      return true;
    }
    if (
      this.isIndexDialogShow &&
      !this.menuFirst &&
      this.menuSmall &&
      this.listSecondIndex2 == 2 &&
      this.menuSearch &&
      this.searchType == 1
    ) {
      this.searchType1=this.listFirstIndex;
      focusControl.requestFocus('listSearch1');
      this.searchType=-1;
      return true;
    }
    if (
      this.isIndexDialogShow &&
      !this.menuFirst &&
      this.menuSmall &&
      this.listSecondIndex2 == 2 &&
      this.menuSearch &&
      this.searchType == 2
    ) {
      this.searchType2=this.listFirstIndex;
      focusControl.requestFocus('listSearch2');
      this.searchType=-1;
      return true;
    }
    if(this.imageSettingIndexOn&&this.settingIndexFirst){
      this.imageSettingIndexOn=false;
      return true;
    }
    if(this.imageSettingIndexOn){
      if(this.settingIndexSecond){
        this.settingIndexFirst=true;
        focusControl.requestFocus('settingindex1');
        return true;
      }else if(this.aspectRatioState){
        this.settingIndexSecond=true;
        focusControl.requestFocus('settingSecondindex1');
        return true;
      }else if(this.imageMode){
        this.settingIndexSecond=true;
        focusControl.requestFocus('settingSecondindex3');
        return true;
      }else if(this.soundSettings){
        this.settingIndexFirst=true;
        focusControl.requestFocus('settingindex2');
        return true;
      }else if(this.track){
        this.soundSettings=true;
        focusControl.requestFocus('Soundsettings1');
        return true;
      }else if(this.audioLanguage){
        this.soundSettings=true;
        focusControl.requestFocus('Soundsettings2');
        return true;
      }else if(this.audioLanguageFirst){
        this.audioLanguage=true;
        focusControl.requestFocus('Audiolanguage1');
        return true;
      }else if(this.audioLanguageSecond){
        this.audioLanguage=true;
        focusControl.requestFocus('Audiolanguage2');
        return true;
      }else if(this.channel){
        this.soundSettings=true;
        focusControl.requestFocus('Soundsettings3');
        return true;
      }else if(this.soundMode){
        this.soundSettings=true;
        focusControl.requestFocus('Soundsettings4');
        return true;
      }else if(this.captionSettings){
        this.settingIndexFirst=true;
        focusControl.requestFocus('settingindex3');
        return true;
      }else if(this.captionSettingLanguage){
        this.captionSettings=true;
        focusControl.requestFocus('captionsettings1');
        return true;
      }else if(this.captionSettingFirst){
        this.captionSettings=true;
        focusControl.requestFocus('captionsettings2');
        return true;
      }else if(this.captionSettingSecond){
        this.captionSettings=true;
        focusControl.requestFocus('captionsettings3');
        return true;
      }else if(this.channelSettings){
        this.settingIndexFirst=true;
        focusControl.requestFocus('settingindex4');
        return true;
      }else if(this.channelInformation){
        this.channelInformation=false;
        this.channelSettings=true;
        focusControl.requestFocus('Channelsettings5');
        return true;
      }else if(this.searchManually){
        this.channelSettings=true;
        focusControl.requestFocus('Channelsettings4');
        return true;
      }else if(this.channelSorting){
        this.isEdit=false;
        this.channelSettings=true;
        focusControl.requestFocus('Channelsettings1');
        return true;
      }
    }
    return false;
  }

  async onPageShow() {
    LogUtil.log(TAG + 'onPageShow');
    log('onPageShow came in');
    this.xComponentShow = true;
    if (this.nums !== -1 && this.surfaceId) {
      this.initPlayer();
    }
  }

  async onPageHide() {
    LogUtil.log(TAG + 'onPageHide');
    log('onPageHide');
    await this.releasePlayer();
    this.xComponentShow = false;
  }
  build() {
    Stack({ alignContent: Alignment.Center }) {

      Row() {
        //视频播放
        if(this.xComponentShow){
          XComponent({
            id: 'dtv_componentId',
            type: XComponentType.SURFACE,
            controller: this.dtvXComponentController
          }).zIndex(0)
            .width(`${this.videoWidth}px`)
            .height(`${this.videoHeight}px`)
            .onLoad(() => {
              LogUtil.log(TAG + 'onLoad');
              this.surfaceId = this.dtvXComponentController.getXComponentSurfaceId();
              LogUtil.log(TAG + 'this.surfaceId'+JSON.stringify(this.surfaceId));
            });
        }
      }
      .zIndex(0)
      .width('100%')
      .height('100%')
      .backgroundColor('#ff000000')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center);

      //播放列表
      Row(){
        //全部频道/搜索
        Column(){
          ForEach(this.menuList, (m: IMenu, i) => {
            Row(){
              Row() {
                Row(){
                  Image(this.listSecondIndex == m.id ? m.leftIcon :m.defImg)
                    .width('36lpx')
                    .height('36lpx')
                    .focusable(true);
                } .width('60lpx')
                .focusable(true)
                .justifyContent(FlexAlign.Center)
                .alignItems(VerticalAlign.Center)
                .height('60lpx')
                .backgroundColor('#33ffffff')
                .borderRadius('50%')
                .margin({
                  right:'18lpx',
                  left:'24lpx'
                });
                Text(m.name)
                  .height('60lpx')
                  .fontSize('36lpx')
                  .fontWeight(500)
                  .fontColor(this.listSecondIndex == m.id ? '#db000000' :'#dbffffff')
                  .focusable(true);
              }.width('296lpx').height('96lpx').alignItems(VerticalAlign.Center).focusable(true)
              .borderRadius('16lpx').backgroundColor(this.listSecondIndex == m.id ?'#dbffffff':'#1affffff');
            }
            .border({
              width: '2lpx',
              color: this.listSecondIndex == m.id ?'#e6ffffff':'transparent'
            })
            .margin({
              bottom:'40lpx'
            })
            .borderRadius('22lpx').padding('4lpx')
            .focusable(true)
            .id('listSecond' + m.id)
            .onFocus(() => {
              this.listSecondIndex = m.id;
            })
            .onBlur(() => {
              this.listSecondIndex = -1;
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (m.id > 1) {
                  this.listSecondIndex--
                  focusControl.requestFocus(`${'listSecond' + this.listSecondIndex.toString()}`);
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (m.id < this.menuList.length) {
                  this.listSecondIndex++
                  focusControl.requestFocus(`${'listSecond' + this.listSecondIndex.toString()}`);
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Up) {
                if(m.name=='全部频道'){
                  this.menuFirst=false;
                  this.menuSmall=true;
                  this.listSecondIndex2=1;
                  this.videoList = this.buildDefaultVideoList();
                  this.listScroller1.scrollToIndex(0);
                  focusControl.requestFocus('listFirst1');
                }else if(m.name=='搜索'){
                  this.menuFirst=false;
                  this.menuSmall=true;
                  this.menuSearch=true;
                  this.listSecondIndex2=2;
                  focusControl.requestFocus('listSearch1');
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU && e.type == KeyType.Up) {
                e.stopPropagation?.();
              } else if (
                (e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up
              ) {
                e.stopPropagation?.();
              }

            });
          });
        }
        .width('352lpx')
        .height('100%')
        .padding({
          top:'405lpx'
        })
        .margin({
          right:'40lpx',
        })
        .focusable(true)
        .visibility(this.menuFirst?Visibility.Visible:Visibility.None);

        //小图标
        Column() {
          ForEach(this.menuList, (m: IMenu, i) => {
            Row() {
              Image(this.listSecondIndex2 == m.id ? m.leftIcon : m.defImg)
                .width('36lpx')
                .height('36lpx')
                .focusable(true);
            }
            .width('60lpx')
            .focusable(true)
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .height('60lpx')
            .backgroundColor('#33ffffff')
            .borderRadius('50%')
            .margin({
              bottom: '96lpx'
            });
          });
        }
        .height('100%')
        .padding({
          left: '48lpx',
          top: '405lpx'
        })
        .margin({
          right: '48lpx'
        })
        .focusable(true)
        .visibility(this.menuSmall?Visibility.Visible:Visibility.None);

        //自动搜台/手动搜台
        Column(){
          ForEach(this.menuList1, (m: IMenu, i) => {
            Row(){
              Row() {
                Text(m.name)
                  .height('60lpx')
                  .fontSize('36lpx')
                  .fontWeight(500)
                  .fontColor(this.listSearch == m.id ? '#db000000' :'#dbffffff')
                  .focusable(true);
              }.width('296lpx').height('96lpx').alignItems(VerticalAlign.Center).focusable(true).justifyContent(FlexAlign.Center)
              .borderRadius('16lpx').backgroundColor(this.listSearch == m.id ?'#dbffffff':'#1affffff');
            }
            .border({
              width: '2lpx',
              color: this.listSearch == m.id ?'#e6ffffff':'transparent'
            })
            .margin({
              bottom:'40lpx'
            })
            .borderRadius('22lpx').padding('4lpx')
            .focusable(true)
            .id('listSearch' + m.id)
            .onFocus(() => {
              this.listSearch = m.id;
            })
            .onBlur(() => {
              this.listSearch = -1;
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (m.id > 1) {
                  this.listSearch--
                  focusControl.requestFocus(`${'listSearch' + this.listSearch.toString()}`);
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (m.id < this.menuList.length) {
                  this.listSearch++
                  focusControl.requestFocus(`${'listSearch' + this.listSearch.toString()}`);
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Up) {
                if(this.listSecondIndex2==2){
                  this.listSecondIndex2=-1;
                  this.menuSmall=false;
                  this.menuSearch=false;
                  focusControl.requestFocus('listSecond2');
                  this.menuFirst=true;
                }
              }
              if (
                (e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up
              ) {
                if (m.name == '自动搜台') {
                  this.searchType=1;
                  this.videoList = this.buildDefaultVideoList();
                  this.listScroller1.scrollToIndex(0);
                  focusControl.requestFocus('listFirst1');
                } else if (m.name == '手动搜台') {
                  this.searchType=2;
                  this.videoList = this.buildDefaultVideoList();
                  this.listScroller1.scrollToIndex(0);
                  focusControl.requestFocus('listFirst1');
                }
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU && e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            });
          });
        }
        .height('100%')
        .margin({
          right:'48lpx',
        })
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .focusable(true)
        .visibility(this.menuSearch?Visibility.Visible:Visibility.None);

        //电视列表
        Column(){
          List({ scroller: this.listScroller1 }) {
            ForEach(this.videoList, (item: IVideo, index: number) => {
              ListItem() {
                Column() {
                  Row(){
                    Column(){
                      Text(index.toString()).fontSize('36lpx').fontWeight(500).fontColor('#db000000').focusable(true);
                    } .focusable(true);
                    Column(){
                      Text('HNSTVFF').fontSize('36lpx').fontWeight(500).fontColor('#db000000') .focusable(true);
                      Text('暂时无法获取节目信息').fontSize('24lpx').fontWeight(500).fontColor('#99000000') .focusable(true);
                    }.margin({ left:'48lpx'}).justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Start) .focusable(true);
                  }
                  .focusable(true)
                  .padding({
                    left:'48lpx'
                  })
                  .width('544lpx')
                  .height('122lpx')
                  .backgroundColor('#ffffff')
                  .border({
                    radius: '16lpx',
                  });
                }
                .focusable(true)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .width('560lpx')
                .height('138lpx')
                .border({
                  radius: '22lpx',
                  color: this.listFirstIndex == Number(item.id) ?'#e6ffffff':'transparent',
                  width: '2lpx',
                });
              }
              .margin({ bottom: '11lpx' })
              .height('138lpx')
              .focusable(true)
              .id('listFirst' + item.id)
              .onFocus(() => {
                this.listFirstIndex = Number(item.id);
              })
              .onBlur(() => {
                this.listFirstIndex = -1;
              })
              .onKeyEvent((e?: KeyEvent) => {
                if (!e) {
                  return;
                }
                if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                  if (Number(item.id) > 1) {
                    this.listFirstIndex--
                    this.listScroller1.scrollToIndex(Number(this.listFirstIndex) - 1);
                    focusControl.requestFocus(`${'listFirst' + this.listFirstIndex.toString()}`);
                  }
                }
                if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                  if (Number(item.id) < this.videoList.length) {
                    this.listFirstIndex++
                    this.listScroller1.scrollToIndex(Number(this.listFirstIndex) - 1);
                    focusControl.requestFocus(`${'listFirst' + this.listFirstIndex.toString()}`);
                  }
                }
                if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Up) {
                  if(this.listSecondIndex2==1){
                    this.backNumberList=this.listFirstIndex;
                    this.listSecondIndex2=-1;
                    this.menuSmall=false;
                    focusControl.requestFocus('listSecond1');
                    this.menuFirst=true;
                  }else if (this.listSecondIndex2==2) {
                    if(this.searchType==1){
                      this.searchType1=this.listFirstIndex;
                      focusControl.requestFocus('listSearch1');
                      this.searchType=-1;
                    }else if(this.searchType==2){
                      this.searchType2=this.listFirstIndex;
                      focusControl.requestFocus('listSearch2');
                      this.searchType=-1;
                    }
                  }
                }
                if (e.keyCode == KeyCode.KEYCODE_MENU && e.type == KeyType.Up) {
                  e.stopPropagation?.();
                } else if (
                  (e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                  e.type == KeyType.Up
                ) {
                  this.changeVideo(index);
                  e.stopPropagation?.();
                }
              });
            }, (item: IVideo) => JSON.stringify(item));
          }
          .width('100%')
          .margin({ top: '40lpx'})
          .height('1030lpx')
          .focusable(true)
          .scrollBar(BarState.Off);
        }
        .focusable(true)
        .width('560lpx')
        .height('100%');
      }
      .padding({
        right:'40lpx'
      })
      .height('100%')
      .backgroundColor('#99000000')
      .position({
        x: '0lpx',
        y: '0lpx',
      })
      .zIndex(3)
      .visibility(this.isIndexDialogShow?Visibility.Visible:Visibility.None);

      // 节目信息栏
      Column() {
        Column(){
          Text('88')
            .fontSize('64lpx')
            .fontWeight(500)
            .fontColor('#e6ffffff');
        }.width('100lpx')
        .height('100lpx')
        .margin({ top:'70lpx', right: '80lpx' })
        .backgroundColor('#99000000')
        .borderRadius('16lpx')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center);
        ProgramInfo({
          name: this.programName,
          datetime: this.programDatetime,
          epgCurrent: this.programEpgCurrent,
          epgAfter: this.programEpgAfter
        });
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .height('100%')
      .position({ x: 0, y: 0 })
      .zIndex(1)
      .visibility(this.hasVideo ? Visibility.Visible : Visibility.None) // 根据视频状态控制显示

      //图像设置菜单
      Row() {
        ImageSettingIndex({
          channelInformation: this.channelInformation,
          settingIndexFirst: this.settingIndexFirst,
          searchManually: this.searchManually,
          channelSettings: this.channelSettings,
          captionSettingSecond: this.captionSettingSecond,
          captionSettingFirst: this.captionSettingFirst,
          captionSettingLanguage: this.captionSettingLanguage,
          captionSettings: this.captionSettings,
          soundMode: this.soundMode,
          channel: this.channel,
          audioLanguageSecond: this.audioLanguageSecond,
          audioLanguageFirst: this.audioLanguageFirst,
          audioLanguage: this.audioLanguage,
          track: this.track,
          soundSettings: this.soundSettings,
          imageMode: this.imageMode,
          aspectRatioPanel: this.aspectRatioState,
          settingIndexSecond: this.settingIndexSecond,
          channelSorting: this.channelSorting,
          isEdit: this.isEdit,
          aspectRatioText: this.aspectRatioText
        });
      }
      .position({ x: this.channelInformation? '984lpx':0, y: 0 })
      .height('100%')
      .focusable(true)
      .zIndex(4)
      .margin({ left: this.channelInformation? '0lpx' :'84lpx' })
      .backgroundColor(this.channelInformation? '#99000000' :'transparent')
      .visibility(this.imageSettingIndexOn?Visibility.Visible:Visibility.None);

      //dtv信号强弱
      Stack({alignContent:Alignment.Center}){
        Column(){
          Image($r('app.media.icon_dtv'))
            .width('160lpx')
            .height('160lpx');
          Text(this.signal==1?'DTV':this.signal==2?'当前信号弱，无法正常观看':'正常')
            .fontSize('36lpx')
            .fontColor('#99FFFFFF')
            .margin({
              top:'24lpx'
            });
          Text('未接入')
            .fontSize('24lpx')
            .fontColor('#99FFFFFF')
            .margin({
              top:'12lpx'
            }).visibility(this.signal==1 ? Visibility.Visible : Visibility.None);
        }
        Column({space: '24lpx'}){
          Text('没有检测到信号')
            .fontSize('40lpx')
            .fontWeight(500)
            .fontColor('#FFFFFF');
          Text('请确认您的设备是否开启')
            .fontSize('24lpx')
            .fontColor('#FFFFFF');
        }
        .width('100%')
        .margin({ bottom: '170lpx' })
        .visibility(this.signal==1 ? Visibility.Visible : Visibility.None);
      }
      .zIndex(6)
      .width('100%')
      .height('100%')
      .backgroundColor('#18181A')
      .backgroundImageSize({ width: '100%', height: '100%' })
      .visibility(this.signalSearchingNo ? Visibility.Visible : Visibility.None);

      //dtv搜索信号
      Stack({alignContent:Alignment.Center}){
        Column(){
          LoadingProgress()
            .width('136lpx')
            .height('136lpx')
            .color('#FFFFFF');
          Text('DTV信号搜索中...')
            .fontSize('40lpx')
            .fontColor('#FFFFFF')
            .margin({
              top:'24lpx'
            });
        }
      }
      .zIndex(7)
      .width('100%')
      .height('100%')
      .backgroundColor('#18181A')
      .backgroundImageSize({ width: '100%', height: '100%' })
      .visibility(this.signalSearching ? Visibility.Visible : Visibility.None);

      //加密频道
      Stack({alignContent:Alignment.Center}){
        Column(){
          Image($r('app.media.clock'))
            .width('100lpx')
            .height('124lpx');
          Text('加密频道，无法观看')
            .fontSize('36lpx')
            .fontColor('#99FFFFFF')
            .margin({
              top:'24lpx'
            });
        }
      }
      .zIndex(8)
      .width('100%')
      .height('100%')
      .backgroundColor('#18181A')
      .backgroundImageSize({ width: '100%', height: '100%' })
      .visibility(this.encrypt?Visibility.Visible:Visibility.None);
    }
    .backgroundImage($r('app.media.page_bg'))
    .backgroundImageSize({ width: '100%', height: '100%' })
    .focusable(true)
    .onKeyEvent((e?: KeyEvent) => {
      if (!e) {
        return;
      }
      log('index page onKeyEvent keyCode: ' + e.keyCode + ' KeyType:' + e.type);
      if (e.keyCode == KeyCode.KEYCODE_MENU && e.type == KeyType.Up) {
        if (
          this.isIndexDialogShow == false &&
          this.signalSearchingNo == false &&
          this.signalSearching == false &&
          this.encrypt == false &&
          this.imageSettingIndexOn == false
        ) {
          this.imageSettingIndexOn = true;
          this.settingIndexFirst = true;
          focusControl.requestFocus('settingindex1');
        }
      } else if (
        (e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
        e.type == KeyType.Up
      ) {
        if (
          this.imageSettingIndexOn == false &&
          this.signalSearchingNo == false &&
          this.signalSearching == false &&
          this.encrypt == false &&
          this.isIndexDialogShow == false
        ) {
          this.isIndexDialogShow=true;
          this.videoList = this.buildDefaultVideoList();
          focusControl.requestFocus('listSecond1');
        }
      }else if(e.keyCode == 2001&& e.type == KeyType.Up){
        this.togglePlayPause();
      }
    });
  }
}
