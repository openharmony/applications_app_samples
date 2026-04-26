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
import { KeyCode } from '@kit.InputKit';
import { getTimeStr } from '../utils/Utils';
import { PlayerBtnsType } from '../const/Type';
import dlnaServiceStub from '../DlnaService/DlnaServiceStub';
import dmrnapi from '@ohos.dmrnapi'
import { inputConsumer, inputEventClient } from '@kit.InputKit';
import { appManager, common } from '@kit.AbilityKit';
import { missionManager } from '@kit.AbilityKit';
import { Constants } from '../const/Constants';
import { initInfo } from '@ohos/utilslibrary';


let log = initInfo('DlnaPlayer.ets');
const SYS_BUNDLENAME = 'com.ohos.systemui'
const SET_TIME_OUT = 150; //快进或快退计时器
const SET_DURATION_TIME = 10000; //快进或快退时长
const PRESS_TIME = 1000 //按下按键时长
const INIT_TIME = 0 //初始化时间
const END_MOVE_HEIGHT = 40 //进度条高度
const DELAY_TIME = 500
const BAR_SHOW_NUM = 4
const START_MOVE_HEIGHT = 110
const DEFAULT_MISSIONID = -1
const DELAY_INIT = 1000 //不涉及页面绘制的操作延迟
const DEFAULT_WIDTH = 3840
const DEFAULT_HEIGHT = 2160

@Entry
@Component
struct DlnaPlayer {
  mXComponentController: XComponentController = new XComponentController();
  @State surfaceId: string = '';
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
      id: 'id_3',
      defaultImg: $rawfile('ic_pause.svg'),
      activeImg: $rawfile('ic_play.svg'),
      onclick: () => {
        this.play();
      }
    },
  ];
  @State keyPressStartTime: number = 0;
  @State timeNotOperated: number = 0; // 未操作时间
  @State leftDown: boolean = false; // 左键是否按下
  @State rightDown: boolean = false; // 右键是否按下
  @StorageLink('screen_lpx_w') screenW: number = AppStorage.get<number>('screen_lpx_w') || 1280;
  @StorageLink('screen_lpx_h') screenH: number = AppStorage.get<number>('screen_lpx_h') || 720;
  @State barOffsetY: number = this.screenH - 30;
  @State @Watch('barShow') isBarShow: boolean = false; // 底部操作栏是否显示隐藏状态
  @State videoWidth: number = AppStorage.get<number>('screen_px_w') || DEFAULT_WIDTH;
  @State videoHeight: number = AppStorage.get<number>('screen_px_h') || DEFAULT_HEIGHT;
  @State focusId: string = this.playerBtns[0].id;
  @State isPlaying: boolean = false;
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
  private isLauncher: boolean = false

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
  missionId: number = -1
  @State @Watch('seekTimeLog') seekTime: number = -1
  @State isPress: boolean = false
  timer: number = -1

  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
  }

  existApp() {
    console.info('Click the callback in the blank area')
  }

  seekTimeLog() {
    console.log('HmLog--> seek:', this.seekTime);
    if (this.seekTime < 0) {
      this.seekTime = 0
    } else if (this.seekTime > this.totalTime) {
      this.seekTime = this.totalTime
    }
  }

  sliderShow(): void {
    this.isPlaying = this.playFlag;
  }

  //-----------DLNA-----------------

  async aboutToAppear() {
    this.initStateData();
    setTimeout(()=>{
      dmrnapi.ResgisterDlnaPlayerAsync(this.dlnaServiceStub)
      dmrnapi.RegisterRemoteDiedListener()
      this.dlnaServiceStub.setStatusCallback(this.statusCallback, this.positionCallback, this.volumeCallback)
      this.isPlaying = true
      this.tabStartClick()
      // 循环监测操作间隔时间
      setInterval(() => {
        if (this.isPlaying) {
          this.timeNotOperated++
        } else {
          this.timeNotOperated = 0
        }
        console.log('this.timeNotOperated : ' + this.timeNotOperated);
        if (this.timeNotOperated >= BAR_SHOW_NUM && !this.isPress) {
          this.timeNotOperated = 0;
          if (this.barOffsetY != this.screenH) {
            this.barOffsetY = this.screenH;
          }
          if (this.isBarShow) {
            this.isBarShow = false;
            focusControl.requestFocus(this.focusId)
          }
        }
      }, 1000)
      this.subscriberKeyEvent()
    },DELAY_INIT)
    log('aboutToAppear')
  }

  subscriberKeyEvent() {
    //左键长按
    inputConsumer.on('key', {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_DPAD_RIGHT,
      isFinalKeyDown: true,
      finalKeyDownDuration: PRESS_TIME
    }, () => {
      this.isPress = true
      clearInterval(this.timer)
      this.seekTime = this.currentTime
      this.barOffsetY = this.screenH - END_MOVE_HEIGHT
      this.timer = setInterval(() => {
        this.seekTime += SET_DURATION_TIME
        this.barOffsetY = this.screenH - END_MOVE_HEIGHT
      }, SET_TIME_OUT)
      //左键松开
      inputConsumer.on('key', {
        preKeys: [],
        finalKey: KeyCode.KEYCODE_DPAD_RIGHT,
        isFinalKeyDown: false,
        finalKeyDownDuration: INIT_TIME
      }, () => {
        this.barOffsetY = this.screenH - END_MOVE_HEIGHT
        clearInterval(this.timer)
        dmrnapi.Seek(this.seekTime);
        dmrnapi.Play();
        setTimeout(() => {
          this.isPress = false
        }, DELAY_TIME)
        inputConsumer.off('key', {
          preKeys: [],
          finalKey: KeyCode.KEYCODE_DPAD_RIGHT,
          isFinalKeyDown: false,
          finalKeyDownDuration: INIT_TIME
        })
      })
    })
    //右键长按
    inputConsumer.on('key', {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_DPAD_LEFT,
      isFinalKeyDown: true,
      finalKeyDownDuration: PRESS_TIME
    }, () => {
      this.isPress = true
      clearInterval(this.timer)
      this.seekTime = this.currentTime
      this.barOffsetY = this.screenH - END_MOVE_HEIGHT
      this.timer = setInterval(() => {
        this.seekTime -= SET_DURATION_TIME
        this.barOffsetY = this.screenH - END_MOVE_HEIGHT
      }, SET_TIME_OUT)
      //右键松开
      inputConsumer.on('key', {
        preKeys: [],
        finalKey: KeyCode.KEYCODE_DPAD_LEFT,
        isFinalKeyDown: false,
        finalKeyDownDuration: INIT_TIME
      }, () => {
        this.barOffsetY = this.screenH - END_MOVE_HEIGHT
        clearInterval(this.timer)
        dmrnapi.Seek(this.seekTime);
        dmrnapi.Play();
        setTimeout(() => {
          this.isPress = false
        }, DELAY_TIME)
        inputConsumer.off('key', {
          preKeys: [],
          finalKey: KeyCode.KEYCODE_DPAD_LEFT,
          isFinalKeyDown: false,
          finalKeyDownDuration: INIT_TIME
        })
      })
    })
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

  initStateData() {
    this.totalTime = 0;
    this.isPlaying = false;
    this.barOffsetY = this.screenH - END_MOVE_HEIGHT;
    this.isBarShow = false;
    this.keyPressStartTime = 0;
    this.timeNotOperated = 0;
    this.leftDown = false;
    this.rightDown = false;
  }

  // 单独处理返回按键
  onBackPress() {
    //切换对应应用到前台
    if (this.missionId != DEFAULT_MISSIONID) {
      this.moveMission()
      setTimeout(() => {
        (getContext(this) as common.UIAbilityContext).terminateSelf()
      }, 2000)
    } else {
      (getContext(this) as common.UIAbilityContext).terminateSelf()
    }
    return true;
  }

  async getMission() {
    try {
      const forGroundApps = await new Promise<string[]>((resolve, reject) => {
        appManager.getForegroundApplications((err, data) => {
          if (err) {
            reject(new Error(`getForegroundApplications error: ${err.code} - ${err.message}`));
            return;
          }
          const apps: string[] = [];
          data.forEach((item) => {
            if (item.bundleName !== SYS_BUNDLENAME) {
              apps.push(item.bundleName);
            }
          });
          resolve(apps);
        });
      });
      log(`forGroundApps：${JSON.stringify(forGroundApps)}`)
      this.isLauncher = forGroundApps.includes('com.ohos.launcher')
      log(`isLauncher: ${this.isLauncher}`)
      if (this.isLauncher) {
        return
      }
      const missions = await new Promise<missionManager.MissionInfo[]>((resolve, reject) => {
        missionManager.getMissionInfos('', 10, (err, missions) => {
          if (err) {
            reject(new Error(`getMissionInfos error: ${err.code} - ${err.message}`))
          } else {
            resolve(missions)
          }
        })
      })
      // 过滤不需要的任务并找到最新的任务
      const filteredMissions = missions.filter(
        item => item.want.abilityName !== 'DlnaAbility'
      );

      if (filteredMissions.length > 0) {
        const latestMission = filteredMissions.reduce((prev, current) =>
        Number(prev.timestamp) > Number(current.timestamp) ? prev : current
        );
        this.missionId = latestMission.missionId;
        log(`missionID: ${this.missionId}`);
        log(`latestMission: ${JSON.stringify(latestMission)}`)
      } else {
        log('can find mission');
      }
    } catch (err) {
      console.error(`getMissionInfos error: ${err.message}`);
      this.missionId = DEFAULT_MISSIONID;
    }
  }

  moveMission() {
    try {
      console.log(`moveMissionToFront missionId:${this.missionId}`);
      missionManager.moveMissionToFront(this.missionId, (err, data) => {
        if (err) {
          console.error(`moveMissionToFront1 failed:${err.message}`);
        } else {
          console.info(`moveMissionToFront successfully:${JSON.stringify(data)}`);
        }
      })
    } catch (err) {
      console.error(`moveMissionToFront2 failed:${err.message}`);
    }
  }

  onPageShow() {
    this.getMission()
    log(`onPageShow`)
  }

  onPageHide() {
    log(`onPageHide this.isPlaying:${this.isPlaying}`)
    this.unSubscriberKeyEvent()
    if (this.isPlaying) {
      this.play();
    }
  }

  unSubscriberKeyEvent() {
    inputConsumer.off('key', {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_DPAD_LEFT,
      isFinalKeyDown: true,
      finalKeyDownDuration: PRESS_TIME
    })
    inputConsumer.off('key', {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_DPAD_RIGHT,
      isFinalKeyDown: true,
      finalKeyDownDuration: PRESS_TIME
    })
  }

  barShow() {
    console.log('HmLog-->barShow:', this.isBarShow)
    if (!this.isBarShow) {
      this.subscriberKeyEvent()
    } else {
      this.unSubscriberKeyEvent()
    }
  }

  // 播放
  async play() {
    log('play this.isPlaying:' + this.isPlaying);
    if (!this.isPlaying) {
      dmrnapi.Play();
      this.isPlaying = true;
    } else {
      dmrnapi.Pause();
      this.isPlaying = false;
      this.showPlayerBtns();
    }
  }


  // 切换视频
  async changePlayVideo() {
    this.initStateData();
    this.isPlaying = true;
  }

  //http网络播放
  async onLoadXComponent() {
    this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
  }

  //停止播放
  videoStop() {
    dmrnapi.Stop();
    if (this.missionId != DEFAULT_MISSIONID) {
      this.moveMission()
      setTimeout(() => {
        (getContext(this) as common.UIAbilityContext).terminateSelf()
      }, 2000)
    } else {
      (getContext(this) as common.UIAbilityContext).terminateSelf()
    }
  }

  // 拉起操作栏
  showPlayerBtns() {
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
  public async DlnaKeyEventLeftRight(e: KeyEvent) {
    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT || e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT) {
      e.stopPropagation();
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Up) {
      this.currentTime -= 10000;
      if (this.currentTime < 0) {
        this.currentTime = 0
      }
      dmrnapi.Seek(this.currentTime);
      dmrnapi.Play();
    } else if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Up) {
      this.currentTime += 10000;
      if (this.currentTime >= this.totalTime) {
        this.currentTime = this.totalTime - 500
      }
      dmrnapi.Seek(this.currentTime);
      dmrnapi.Play();
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
            .zIndex(1)
            .width(`${this.videoWidth}px`)
            .height(`${this.videoHeight}px`)
            .onLoad(() => {
              this.onLoadXComponent();
              AppStorage.setOrCreate('XComponent', this.mXComponentController)
              dmrnapi.SetSurfaceId(this.surfaceId);
              dmrnapi.Play()
            })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#ff000000')
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)


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

        // 视频标题
        Row() {
          Text('')
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

          Column() {
            // 进度条
            Row() {
              // 当前播放时间
              Text(getTimeStr(this.isPress ? this.seekTime : (this.currentTime || 0)))
                .fontSize('14lpx')
                .fontColor(Color.White)
                .width('70lpx')
                .textAlign(TextAlign.End)
                .padding({ right: '5lpx' })
              // 进度条
              Slider({
                value: this.isPress ? this.seekTime : (this.currentTime || 0),
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
                    if (ind == 1) {
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
                      this.focusId = item.id;
                    })
                    .onKeyEvent(e => {
                      console.log('HmLog-->keyEvent', `${e.keyCode} ${e.type}`)
                      if (e.keyCode == KeyCode.KEYCODE_F24) {
                        e.stopPropagation();
                        return;
                      }
                      if (this.isBarShow && item.id == this.focusId) {
                        if (this.leftDown || this.rightDown) {
                          e.stopPropagation();
                        }
                      } else if (!this.isBarShow && item.id == this.focusId) {
                        if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT || e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT) {
                          this.barOffsetY = this.screenH - 30;
                        }
                        this.DlnaKeyEventLeftRight(e)
                      }
                    })
                    .onClick(()=>{
                      item.onclick();
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
        .position({
          x: '0lpx',
          y: `${this.barOffsetY}lpx`
        })
        .zIndex(3)
        .width(`${this.screenW}lpx`)
        .onAppear(() => {
          this.focusId = this.playerBtns[1].id
        })
        .animation({
          duration: 200,
          curve: Curve.Linear,
          onFinish: () => {
            if (this.barOffsetY == (this.screenH - START_MOVE_HEIGHT)) {
              this.isBarShow = true;
            } else {
              this.isBarShow = false;
            }
          }
        })
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
        // 菜单键 小于1.5s拉起操作栏
        if (e.keyCode == KeyCode.KEYCODE_MENU && e.type == KeyType.Up) {
          let t = new Date().getTime();
          log(`KEYCODE_MENU press time:${t - this.keyPressStartTime}`)
          t = t - this.keyPressStartTime
          if (t < 1500) {
            this.showPlayerBtns();
          }
          e.stopPropagation();
        }

        // 上
        if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
          this.showPlayerBtns();
          e.stopPropagation();
        }

        // 下
        if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
          this.showPlayerBtns();
          e.stopPropagation();
        }

        // OK
        if (e.keyCode == KeyCode.KEYCODE_ENTER && e.type == KeyType.Down) {
          this.focusId = this.playerBtns[1].id
          this.play();
          e.stopPropagation();
        }
      }

      if (this.keyPressStartTime != 0 && e.type == KeyType.Up) {
        this.keyPressStartTime = 0;
      }
    })
    .onClick(()=>{
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
}
