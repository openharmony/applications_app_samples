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
 
import { display, window as winApi } from '@kit.ArkUI';
import { settings } from '@kit.BasicServicesKit';
import {
  BusinessError,
  commonEventManager,
  deviceInfo,
  emitter,
  power,
  screenLock,
  systemParameterEnhance
} from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';
import { audio } from '@kit.AudioKit';
import { KeyCode } from '@kit.InputKit';
import Log from '@ohos/common/src/main/ets/default/Log';
import { inputConsumer } from '@kit.InputKit';
import NavigationBarEventModel from '../model/NavigationBarEventModel';
import initSystemUi from '@ohos/common/src/main/ets/default/InitSystemUi';
import { ServiceExtensionAbility } from '@kit.AbilityKit';
import { audioManager } from '@ohos/common/src/main/ets/util/GetAudioManager';
import WindowManager, { WindowType } from '@ohos/common/src/main/ets/default/WindowManager';
import AbilityManager from '@ohos/common/src/main/ets/default/abilitymanager/AbilityManager';
import { Rect } from '@ohos/common/src/main/ets/default/Constants';
import { appManager } from '@kit.AbilityKit';
import { Action, TouchEvent, MouseEvent } from '@kit.InputKit';
import { inputMonitor } from '@kit.InputKit';
import { KeyAction as TouchAction } from '@kit.InputKit';
import { BooleanPreferences } from '../model/UserStorageManager';
import displaySetting from '@ohos.tvservice.displaySetting';
import remoteControl from '@ohos.multimodalInput.remoteControl';


const TAG = 'SystemUI_ServiceExtAbility';

interface TouchPoint {
  x: number;
  y: number;
}

interface LeftPositionConfig {
  width: number;
  left: number;
}

type EventParameters = Record<string, string | boolean | number | undefined>;

const TOUCH_START_POINT: TouchPoint = { x: 0, y: 0 }; // 触摸起始点
const FLOAT_BALL_SWICH_EVENT: string = 'defaultFloatBall';
const FLOAT_BALL_SWICH_PREFERENCE_KEY: string = 'defaultFloatBall';
const SCREENSAVER_BOOLEAN: string = 'screensaverBoolean'; //屏保接收开关
const SCREENSAVER = 'screensaver'; //屏保接收数值
const SCREEN_SAVER_APP_ON = 'screenSaverAppOn';
const SCREEN_SAVER_SWITCH = 'SCREEN_SAVER_SWITCH'; //屏保数据库
const SCREEN_SAVER_START_TIME = 'SCREEN_SAVER_START_TIME'; //屏保数据库数值
const SCREEN_OFF_TIME_BOOLEAN = 'screenOffTimeBoolean'; // 熄屏接收开关
const SCREEN_OFF_TIME = 'screenOffTime'; // 熄屏数据库值 接收开关
const SCREEN_OFF_KEY_SWITCH = 'auto_screen_off_switch'; // 熄屏数据库开关
const POWER_BOOLEAN = 'powerBoolean'; // 主动熄屏
const SIXTY_THOUSAND = 60000;

let initFlag: boolean = false;
let mWindowHandler: winApi.Window | null = null;
let floatWindowHandler: winApi.Window | null = null
let isFloatBallShowFlag: boolean = false;
let dialogWindowHander: winApi.Window | null = null;
let screensaverBoolean: boolean = false
let screensaver: string = '-1';
let screenOffTimeBoolean: boolean = false;
let screenOffTime: string = '-1';
let isInScreensaverMode: boolean = false; // 是否正在屏保模式中
let isManualScreenOff: boolean = false; // 是否用户主动触发熄屏
const LEFT_POSITION_CONFIG: LeftPositionConfig[] = [
  { width: 7680, left: 500 },
  { width: 3840, left: 480 },
  { width: 2560, left: 150 },
  { width: 1920, left: 0 }
];
const watchKey: number = 3000;
let isCharge: boolean = false
const dis = display.getDefaultDisplaySync();
const zeroPointSixSix = 0.66;

//ServiceExtensionAbility是一种专门用于后台服务的ExtensionAbility类型，它不能直接显示在界面上，只能被拉起运行。
class ServiceExtAbility extends ServiceExtensionAbility {
  private preDataFlush: BooleanPreferences | null = null;
  private floatBallSubscriber: commonEventManager.CommonEventSubscriber | undefined;
  private lockScreenSubscriber: commonEventManager.CommonEventSubscriber | undefined;
  private touchScreenLastOpTime: number = 0; //上一次触摸屏幕时间
  private floatTouchTimerInterValId: number = 0; //

  async onCreate(want: Want): Promise<void> {
    AppStorage.setOrCreate('OUTPUT_STATE', audio.DeviceType.SPEAKER)
    Log.showInfo(TAG, `onCreate, want: ${JSON.stringify(want)}`);
    initSystemUi(this.context);
    audioManager.init()

    AbilityManager.setContext(AbilityManager.ABILITY_NAME_ENTRY, this.context);


    this.preDataFlush = new BooleanPreferences(this.context);
    await this.preDataFlush.initialize();

    const defaultFloatBallValue = await this.preDataFlush.getBoolean('defaultFloatBall');
    if (defaultFloatBallValue != undefined && defaultFloatBallValue != null) {
      isFloatBallShowFlag = defaultFloatBallValue;
    }

    console.log('init defaultFloatBall value:', isFloatBallShowFlag);
    this.showMeun();
    if (isFloatBallShowFlag) {
      console.log('init 初始化创建悬浮球');
      this.createFloatWindow();
    }


    let floatBallSubscriberInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [FLOAT_BALL_SWICH_EVENT]
    };
    this.floatBallSubscriber = commonEventManager.createSubscriberSync(floatBallSubscriberInfo);
    commonEventManager.subscribe(this.floatBallSubscriber,
      (error: BusinessError, data: commonEventManager.CommonEventData) => {
        if (error != null) {
          console.error(`floatBallSubscriber error is ${error}`)
          return;
        }
        ;

        console.log(TAG, 'floatBallSubscriber CommonEvent: ' + JSON.stringify(data))

        const params = data.parameters as EventParameters | undefined;
        if (!params) {
          return;
        }
        const isFloatBallShowFlagTmp = params.defaultFloatBall as boolean | undefined;

        if (isFloatBallShowFlagTmp) {
          console.log(TAG, 'floatBallSubscriber show');
          this.showFlatBall();

          return
        }

        console.log(TAG, 'floatBallSubscriber hide');

        this.hideFloatBall();

      });

    // 屏保
    setTimeout(() => {
      let screensaverBooleanSettingValue = settings.getValueSync(this.context, SCREEN_SAVER_SWITCH, '0');
      screensaverBoolean = screensaverBooleanSettingValue == '0' ? false : true;

      let screensaverSettingValue = settings.getValueSync(this.context, SCREEN_SAVER_START_TIME, '-1');
      screensaver =
        screensaverSettingValue == '-1' ? '-1' : (parseInt(screensaverSettingValue) * SIXTY_THOUSAND).toString();

      let screenOffTimeBooleanSettingValue = settings.getValueSync(this.context, SCREEN_OFF_KEY_SWITCH, '0');
      screenOffTimeBoolean = screenOffTimeBooleanSettingValue == '0' ? false : true;

      let screenOffTimeSettingValue = settings.getValueSync(this.context, SCREEN_OFF_TIME, '-1');
      screenOffTime = screenOffTimeSettingValue

      console.log(`onSystemEvent sql screensaverBoolean screensaver screenOffTimeBoolean screenOffTime`,
        screensaverBoolean, screensaver, screenOffTimeBoolean, screenOffTime);

      this.onSystemLockScreenEvent();
    }, 15000)

    let lockScreenSubscriberInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [
        SCREENSAVER_BOOLEAN, SCREENSAVER,
        SCREEN_OFF_TIME_BOOLEAN,
        SCREEN_OFF_TIME, POWER_BOOLEAN,
        SCREEN_SAVER_APP_ON
      ]
    };
    this.lockScreenSubscriber = commonEventManager.createSubscriberSync(lockScreenSubscriberInfo);
    commonEventManager.subscribe(this.lockScreenSubscriber,
      (error: BusinessError, data: commonEventManager.CommonEventData) => {
        const params = data.parameters as EventParameters | undefined;
        console.log(`onSystemEvent CommonEvent subscribe`, JSON.stringify(params));
        if (error != null) {
          console.error(`onSystemEvent error is ${error}`);
          return;
        }
        ;
        if (!data) {
          console.error(`onSystemEvent  receive data is null`);
          return;
        }
        if (!params) {
          return;
        }
        if (data.event === SCREENSAVER_BOOLEAN) {
          screensaverBoolean = Boolean(params[SCREENSAVER_BOOLEAN]);
          console.log(`onSystemEvent screensaverBoolean`, screensaverBoolean);
          this.onSystemLockScreenEvent();
        } else if (data.event === SCREENSAVER) {
          screensaver = String(params[SCREENSAVER] ?? '-1');
          console.log(`onSystemEvent screensaver`, screensaver);
          this.onSystemLockScreenEvent();
        } else if (data.event === SCREEN_OFF_TIME_BOOLEAN) {
          screenOffTimeBoolean = Boolean(params[SCREEN_OFF_TIME_BOOLEAN]);
          console.log(`onSystemEvent screenOffTimeBoolean`, screenOffTimeBoolean);
          this.onSystemLockScreenEvent();
        } else if (data.event === SCREEN_OFF_TIME) {
          screenOffTime = String(params[SCREEN_OFF_TIME] ?? '-1');
          console.log(`onSystemEvent screenOffTime`, screenOffTime);
          this.onSystemLockScreenEvent();
        } else if (data.event === POWER_BOOLEAN) {
          isManualScreenOff = Boolean(params[POWER_BOOLEAN]);
          setTimeout(() => {
            this.manualScreenOff();
          })
        } else if (data.event === SCREEN_SAVER_APP_ON) {
          isInScreensaverMode = Boolean(params['screenSaverAppOnBoolean']);
          this.HandleScreenSaverAppOnEvent();
        }
      });

    this.registerVolume();
    this.onControllerListener();
    setTimeout(() => {
      //3秒之后systemUI重新注册键值避免出现概率性键值不可用
      this.watchKey();
    }, watchKey)
  }

  private HandleScreenSaverAppOnEvent() {
    if (isInScreensaverMode) {
      // 屏保启动成功后，设置剩余的真正熄屏时间
      if (screenOffTimeBoolean) {
        const remainingTime = parseInt(screenOffTime) - parseInt(screensaver);
        power.setScreenOffTime(remainingTime);
        console.log(`onSystemEvent 屏保已启动，剩余${remainingTime}秒后进入真实熄屏`);
      } else {
        // 屏保启动之后，如果没有设置熄屏，则停留在屏保界面，不会熄屏
        power.setScreenOffTime(-1);
        console.log('onSystemEvent 屏保已启动, 未设置熄屏，设置永不熄屏');
      }
    } else {
      this.handleUserInteraction();
    }
  }

  showMeun() {
    inputMonitor.on('touch', this.touchChange.bind(this));
  }

  touchChange(touchEvent: TouchEvent) {
    if (TouchAction.DOWN === touchEvent.action) {
      // 记录触摸起始点
      TOUCH_START_POINT.x = touchEvent.touch.screenX;
      TOUCH_START_POINT.y = touchEvent.touch.screenY;
      return
    }
    //灵犀正常移动光标就会不停触发up事件，为了不导致一直进来计算位置导致主线程卡死，底层修改之前应用先找个变量进行规避
    if (TouchAction.UP === touchEvent.action && TOUCH_START_POINT.y != 0) {
      const currentY = touchEvent.touch.screenY;
      const slideDistance = Math.abs(currentY - TOUCH_START_POINT.y);
      // 判断滑动的区域在整个屏幕右侧2/3处
      const touchArea = TOUCH_START_POINT.x / dis.width;
      if (slideDistance > 300 && TOUCH_START_POINT.y < 300 && touchArea > zeroPointSixSix) {
        this.createControlCenter()
        TOUCH_START_POINT.y = 0;
      }
    }

  }

  createFloatWindow() {
    let dis = display.getDefaultDisplaySync();
    Log.showInfo(TAG, `dis.width: ${JSON.stringify(dis.width)}`)
    let rect: Rect = {
      left: 15,
      top: 15,
      width: 80 * dis.width / 1920,
      height: 80 * dis.width / 1920,
    }

    Log.showDebug('float touch', `创建悬浮球`);

    WindowManager.createWindow(this.context, WindowType.FLOAT_BALL, rect, 'pages/Float')
      .then((win: winApi.Window) => {
        floatWindowHandler = win
        floatWindowHandler!.showWindow().then(async () => {
          // 设置窗口背景色为透明
          floatWindowHandler!.setWindowBackgroundColor('#00000000')
          floatWindowHandler!.setWindowFocusable(false).then(() => {
          })
        })
        // 启动悬浮球后，监听触摸事件
        inputMonitor.on('touch', this.touchMonitorFloatCallback.bind(this));
        inputMonitor.on('mouse', this.mouseMonitorFloatCallback.bind(this));
      })
      .catch((err: BusinessError) => {
        Log.showError(TAG, `创建FLOAT_BALL窗口失败: ${JSON.stringify(err)}`)
      })

  }

  destroyFlotWindow() {
    if (floatWindowHandler) {
      Log.showDebug('float touch', `销毁悬浮球`);
      try {
        floatWindowHandler.destroy();
        floatWindowHandler = null;
      } catch (e) {
        console.log('Ttest', `destroy失败：${JSON.stringify(e)}`)
      }
    }
  }

  hideFloatBall() {
    isFloatBallShowFlag = false
    if (floatWindowHandler != null) {
      Log.showDebug('float touch', `隐藏悬浮球`);
      floatWindowHandler?.hide();
    }
    this.preDataFlush?.saveBoolean(FLOAT_BALL_SWICH_PREFERENCE_KEY, isFloatBallShowFlag);
    this.stopFloatCheckTimer();
  }

  showFlatBall() {
    isFloatBallShowFlag = true
    if (floatWindowHandler != null) {
      Log.showDebug('float touch', `显示悬浮球`);
      floatWindowHandler?.show();
    } else {
      Log.showDebug('float touch', `创建悬浮球并启动timer`);
      this.createFloatWindow();
    }
    this.preDataFlush?.saveBoolean(FLOAT_BALL_SWICH_PREFERENCE_KEY, isFloatBallShowFlag);
    this.startFloatCheckTimer();

  }

  touchMonitorFloatCallback(touchEvent: TouchEvent) {
    if (TouchAction.UP != touchEvent.action) {
      Log.showDebug('float touch', `没有抬起触摸`);
      return;
    }
    if (!isFloatBallShowFlag) {
      Log.showDebug('float touch', `隐藏状态不触发timer检查`);
      return;
    }
    Log.showDebug('float touch', `触摸回调`);
    this.touchScreenLastOpTime = Date.now();
    // 触摸过悬浮球，就会启动定时器
    this.startFloatCheckTimer()
  }

  mouseMonitorFloatCallback(mouseEvent: MouseEvent) {
    if (!isFloatBallShowFlag) {
      Log.showDebug('float click', `隐藏状态不触发timer检查`);
      return;
    }
    Log.showDebug('float click', `click回调`);
    this.touchScreenLastOpTime = Date.now();
    // 触摸过悬浮球，就会启动定时器
    this.startFloatCheckTimer()
  }

  startFloatCheckTimer() {
    Log.showDebug('float touch', `尝试启动定时器`)
    if (this.floatTouchTimerInterValId) {
      Log.showDebug('float touch', `进入定时器已启动，不需要重复启动`)
      return;
    }

    if (!isFloatBallShowFlag) {
      Log.showDebug('float touch', `startFloatCheckTimer 隐藏状态不触发timer检查`);
      return;
    }

    this.touchScreenLastOpTime = Date.now();

    this.floatTouchTimerInterValId = setInterval(() => {

      if (!isFloatBallShowFlag) {
        Log.showDebug('float touch', `startFloatCheckTimer 隐藏状态不触发timer检查`);
        this.stopFloatCheckTimer();
        return;
      }

      const now: number = Date.now()
      Log.showDebug('float touch', `进入定时器,检测时间未触摸 ${now - this.touchScreenLastOpTime} ms`)
      if (now - this.touchScreenLastOpTime >= 30000) {
        this.stopFloatCheckTimer();
        // 重建悬浮球
        this.recreateFloatBall();
        this.touchScreenLastOpTime = Date.now();
      }
    }, 1000);

    Log.showDebug('float touch', `启动定时器 ${this.floatTouchTimerInterValId}`)
  }

  stopFloatCheckTimer() {
    Log.showDebug('float touch', `清除定时器：${this.floatTouchTimerInterValId}`);
    clearInterval(this.floatTouchTimerInterValId);
    this.floatTouchTimerInterValId = 0;
  }

  /**
   * 重建悬浮球
   */
  recreateFloatBall() {
    this.destroyFlotWindow()
    isFloatBallShowFlag = true;
    this.createFloatWindow();
    this.preDataFlush?.saveBoolean(FLOAT_BALL_SWICH_PREFERENCE_KEY, isFloatBallShowFlag);
  }

  registerVolume() {
    // 监听音量加减
    audioManager.audioVolumeManager.on('volumeChange', async (volumeEvent: audio.VolumeEvent) => {
      const devices = await audioManager.audioRoutingManager.getDevices(audio.DeviceFlag.OUTPUT_DEVICES_FLAG)
      AppStorage.set<number>('OUTPUT_STATE', devices[0].deviceType)
      AppStorage.set('VolumePanelVolumeValue', volumeEvent.volume)
      Log.showInfo(TAG, `输出设备类型: ${devices[0].deviceType} ` +
        `当前音量: ${volumeEvent.volume} 音量类型：${volumeEvent.volumeType} initFlag标志: ${initFlag} updateUi: ${volumeEvent.updateUi}`);
      if (volumeEvent.volumeType === audio.AudioVolumeType.MEDIA && initFlag) {
        const ret = settings.setValueSync(this.context, 'settings.audio.media', `${volumeEvent.volume}`)
        Log.showInfo(TAG, `存储音量结果: ${ret} ${volumeEvent.volume}`)
      }
    })
    setTimeout(() => {
      initFlag = true;
    }, 10000)
  }

  /**
   * 主动熄屏方法（外部调用）
   */
  public async manualScreenOff(): Promise<void> {
    try {
      console.log('onSystemEvent 用户触发主动熄屏');
      // 标记为主动熄屏
      isManualScreenOff = true;
      // 如果正在屏保模式，先退出屏保
      if (isInScreensaverMode) {
        await this.exitScreensaver();
      }
      // 直接执行熄屏
      await this.executeRealScreenOff();
    } catch (error) {
      console.error('onSystemEvent 主动熄屏失败:', error);
      isManualScreenOff = false; // 重置状态
    }
  }

  /**
   * 执行真正的熄屏操作
   */
  private async executeRealScreenOff(): Promise<void> {
    try {
      console.log('onSystemEvent 执行真正熄屏...');
      power.suspend(); // 熄屏
      console.log('onSystemEvent 熄屏指令已发送');
    } catch (error) {
      console.error('onSystemEvent 熄屏执行失败:', error);
      throw new Error('executeRealScreenOff failed');
    }
  }

  /**
   * 退出屏保模式
   */
  private async exitScreensaver(): Promise<void> {
    try {
      console.log('onSystemEvent 正在退出屏保模式...');
      // 关闭屏保应用
      await this.closeScreensaverAbility();
      // 重置状态
      isInScreensaverMode = false;
      console.log('onSystemEvent 已退出屏保模式');
    } catch (error) {
      console.error('onSystemEvent 退出屏保失败:', error);
    }
  }

  /**
   * 关闭屏保应用
   */
  private async closeScreensaverAbility(): Promise<void> {
    try {
      console.log('onSystemEvent 屏保应用关闭指令已发送');
    } catch (error) {
      console.warn('onSystemEvent 关闭屏保应用失败:', error);
    }
  }

  onSystemLockScreenEvent() {
    try {
      // 重置状态
      isManualScreenOff = false;
      // 1. 初始化设置：根据配置决定首次触发时间
      if (screensaverBoolean) {
        // 开启屏保：首次触发时间设为屏保时间
        console.log(`onSystemEvent 设置屏保触发时间: ${screensaver}秒`);
        power.setScreenOffTime(parseInt(screensaver));
        // 重置状态
        isInScreensaverMode = false;
      } else if (screenOffTimeBoolean) {
        // 未开启屏保，只设置熄屏时间
        console.log(`onSystemEvent 设置熄屏时间: ${screenOffTime}秒`);
        power.setScreenOffTime(parseInt(screenOffTime));
        return; // 无需监听事件
      } else {
        // 两者都未开启，设为永不熄屏或默认值
        power.setScreenOffTime(-1);
        return;
      }
      // 2. 注册系统事件监听
      console.log(`onSystemEvent 注册屏幕事件监听`);
      let isSuccess = screenLock.onSystemEvent((event: screenLock.SystemEvent) => {
        console.log(`onSystemEvent 收到系统事件: ${event.eventType}`);
        switch (event.eventType) {
          case 'beginScreenOff':
            this.handleBeginScreenOffEvent();
            break;
          case 'beginScreenOn':
            // 屏幕被点亮（用户操作），重置所有状态
            if (isManualScreenOff) {
              this.handleUserInteraction();
            }
            break;
          case 'endScreenOn':
            // 屏幕完全关闭
            console.log('onSystemEvent 屏幕已完全关闭');
            break;
        }
      });
    } catch (err) {
      let error = err as BusinessError;
      console.error(`onSystemEvent 初始化失败: Code: ${error.code}, message: ${error.message}`);
    }
  }

  /**
   * 处理屏幕即将关闭事件
   */
  private handleBeginScreenOffEvent(): void {
    // 情况1: 主动熄屏流程中 → 直接跳过
    console.log('onSystemEvent isManualScreenOff', isManualScreenOff)
    if (isManualScreenOff) {
      console.log('onSystemEvent 主动熄屏流程中，跳过屏保逻辑');
      return;
    }
    // 情况2: 已经在屏保模式中 → 真实熄屏时间到
    if (isInScreensaverMode) {
      console.log('onSystemEvent 屏保模式中，真实熄屏时间到，允许系统熄屏');
      return;
    }
    // 情况3: 首次触发，且屏保功能开启 → 应该拉起屏保
    if (screensaverBoolean && !isInScreensaverMode) {
      console.log('onSystemEvent 屏保时间到，拉起屏保');
      // 阻止立即熄屏（唤醒屏幕）
      try {
        power.wakeup('screensaver_trigger');
      } catch (e) {
        console.warn('onSystemEvent 唤醒屏幕失败:', e);
      }
      // 拉起屏保应用
      this.startScreensaverAbility();
    }
  }

  /**
   * 处理用户交互
   */
  private handleUserInteraction(): void {
    console.log('onSystemEvent 用户操作点亮屏幕，重置状态');
    // 重置所有状态
    isInScreensaverMode = false;
    isManualScreenOff = false;
    // 重新应用初始设置
    this.applyScreenSettings();
  }

  /**
   * 重新应用屏幕设置（供用户交互后调用）
   */
  private applyScreenSettings(): void {
    if (screensaverBoolean) {
      console.log(`onSystemEvent 重新设置屏保触发时间: ${screensaver}秒`);
      power.setScreenOffTime(parseInt(screensaver));
    } else if (screenOffTimeBoolean) {
      console.log(`onSystemEvent 重新设置熄屏时间: ${screenOffTime}秒`);
      power.setScreenOffTime(parseInt(screenOffTime));
    } else {
      power.setScreenOffTime(-1);
    }
  }

  /**
   * 拉起屏保应用
   */
  private async startScreensaverAbility(): Promise<void> {
    try {
      let want: Want = {
        bundleName: 'com.ohos.screensaver',
        abilityName: 'EntryAbility',
        moduleName: 'entry',
        parameters: {
          uri: 'detail',
          pageUrl: 'PullUpDetail'
        }
      };
      console.log('onSystemEvent 启动屏保应用:', JSON.stringify(want));
      await this.context.startAbility(want);
      console.log('onSystemEvent 屏保启动成功');
    } catch (error) {
      console.error('onSystemEvent 启动屏保失败:', JSON.stringify(error));
      // 屏保启动失败，恢复原始设置
      isInScreensaverMode = false;
      if (screenOffTimeBoolean) {
        power.setScreenOffTime(parseInt(screenOffTime));
      }
    }
  }

  getLeftByScreenWidth(defaultLeft: number = 0): number {
    try {
      const dis = display.getDefaultDisplaySync();
      const currentWidth = dis.width;
      const matchedConfig: LeftPositionConfig | undefined = LEFT_POSITION_CONFIG.find(
        (config: LeftPositionConfig) => currentWidth === config.width
      );
      return matchedConfig?.left ?? defaultLeft;
    } catch (error) {
      Log.showError(TAG, `获取屏幕宽度失败: ${JSON.stringify(error)}`);
      return defaultLeft;
    }
  }

  createControlCenter() {
    const backKeyOption: inputConsumer.KeyOptions = {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_BACK,
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    };
    const backKeyCallback = (keyOptions: inputConsumer.KeyOptions) => {
      Log.showInfo(TAG, '按下KEYCODE_BACK键')
      setTimeout(() => {
        Log.showInfo(TAG, '按返回键关闭窗口')
        this.destroyControlCenter()
        inputConsumer.off('key', backKeyOption, backKeyCallback)
      }, 400)
    }

    // 获取屏幕尺寸
    let dis = display.getDefaultDisplaySync();
    // 设置控制中心窗口尺寸和位置
    let rect: Rect = {
      left: 0,
      top: 0,
      width: dis.width,
      height: dis.height,
    };

    // 创建控制中心窗口
    WindowManager.createWindow(this.context, WindowType.CONTROL_PANEL, rect, 'pages/Index')
      .then((win: winApi.Window) => {
        mWindowHandler = win
        // 长按菜单按钮后打开窗口
        mWindowHandler!.showWindow().then(async () => {
          // 设置窗口背景色为透明
          mWindowHandler!.setWindowBackgroundColor('#00000000')
          // 将焦点转移到当前窗口
          mWindowHandler!.setWindowFocusable(true).then(() => {
            // 控制中心展示时，监听返回按钮
            // inputConsumer.on('key', backKeyOption, backKeyCallback) 由于有二级页面，现在不直接按返回就销毁
            mWindowHandler!.showWindow()
            mWindowHandler?.on('windowEvent', (data: winApi.WindowEventType) => {
              if (data == winApi.WindowEventType.WINDOW_INACTIVE) {
                mWindowHandler?.destroyWindow()
              }
            })
          })
        })
      });
  }

  createControlDialog() {
    // 获取屏幕尺寸
    let dis = display.getDefaultDisplaySync();
    // 设置控制中心窗口尺寸和位置
    let rect: Rect = {
      left: 0,
      top: 0,
      width: dis.width,
      height: dis.height,
    };
    // 创建遥控器弹窗
    WindowManager.createWindow(this.context, WindowType.NOTIFICATION_PANEL, rect, 'pages/Dialog')
      .then((win: winApi.Window) => {
        console.log(TAG, 'createWindow NOTIFICATION_PANEL')
        dialogWindowHander = win
        dialogWindowHander!.showWindow().then(async () => {
          // 设置窗口背景色为透明
          console.log(TAG, 'showWindow NOTIFICATION_PANEL')
          dialogWindowHander!.setWindowBackgroundColor('#00000000');
          // 设置当前窗口无聚焦
          dialogWindowHander?.setWindowFocusable(false)
        })
      })
      .catch((err: BusinessError) => {
        console.log(TAG, 'createWindow NOTIFICATION_PANEL err: ' + JSON.stringify(err))
      })
  }

  destroyControlCenter() {
    console.log(TAG, 'destroyWindow')
    if (mWindowHandler) {
      console.log(TAG, 'destroyWindow begin')
      mWindowHandler!.destroyWindow()
      mWindowHandler = null
    }
  }

  destroyDialog() {
    if (dialogWindowHander) {
      dialogWindowHander!.destroyWindow()
      dialogWindowHander = null
    }
  }

  /**
   * 注册指向遥控器监听
   */
  onControllerListener() {
    console.debug(TAG, '注册指向遥控器监听事件');
    remoteControl.on('RemoteControlChange', (data: remoteControl.RemoteControlListener) => {

      if (data.type === 'UwbStatusChange') {
        if (data.changeVal === 0) {
          console.debug(TAG, 'uwb拨码开关关闭')
          if (dialogWindowHander === null) {
            AppStorage.setOrCreate('isOpenUwb', false)
            this.createControlDialog()
          } else {
            AppStorage.setOrCreate('isOpenUwb', false)
            dialogWindowHander?.showWindow()
          }
          setTimeout(() => {
            dialogWindowHander?.hide()
          }, 1000)
        } else {
          console.debug(TAG, 'uwb拨码开关打开')
          if (dialogWindowHander === null) {
            AppStorage.setOrCreate('isOpenUwb', true)
            this.createControlDialog()
          } else {
            AppStorage.setOrCreate('isOpenUwb', true)
            dialogWindowHander?.showWindow()
          }
          setTimeout(() => {
            dialogWindowHander?.hide()
          }, 1000)
        }
      } else if (data.type === 'BatteryValueChange') {
        if (data.changeVal == 20 || data.changeVal === 15 || data.changeVal === 10 || data.changeVal === 5) {
          if (!isCharge) {
            console.debug(TAG, 'system ui isCharge:' + isCharge + '当前电量为：' + data.changeVal)
            if (dialogWindowHander === null) {
              AppStorage.setOrCreate('lowCharge', data.changeVal)
              this.createControlDialog()
            } else {
              AppStorage.setOrCreate('lowCharge', data.changeVal)
              dialogWindowHander?.showWindow()
            }
            setTimeout(() => {
              dialogWindowHander?.hide()
            }, 2000)
          } else {
            console.debug(TAG, 'system ui isCharge:' + isCharge + '当前电量为：' + data.changeVal)
          }
        }
      } else if (data.type === 'ChargeStatusChange') {
        if (data.changeVal === 0) {
          isCharge = false
          AppStorage.setOrCreate('isCharge', false)
        } else {
          isCharge = true
          AppStorage.setOrCreate('isCharge', true)
        }
      }
    })
  }

  /**
   * 注销指向遥控器监听
   */
  offControllerListener() {
    remoteControl.off('RemoteControlChange')
    console.debug(TAG, '注销指向遥控器监听事件');
  }

  watchKey() {
    console.log('watchKeyInputConsumer');

    // 添加此监听为了修复开机后按键接收事件延迟问题，此为临时解决方案
    inputConsumer.on('key', {
      preKeys: [KeyCode.KEYCODE_VOLUME_DOWN],
      finalKey: KeyCode.KEYCODE_VOLUME_UP,
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    }, (t) => {
    })

    // 长按菜单按钮
    inputConsumer.on('key', {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_MENU,
      isFinalKeyDown: true,
      finalKeyDownDuration: 1000
    }, (t) => {
      Log.showInfo(TAG, '按下KEYCODE_MENU键')
      appManager.getForegroundApplications().then((res) => {
        console.log(TAG, 'now foreground application list:' + JSON.stringify(res))
        AppStorage.SetOrCreate('bundleName', res[0].bundleName)
      }).catch((err: BusinessError) => {
        console.log(TAG, 'getForegroundApplications failed ' + err)
      })
      this.createControlCenter()
    })
    // 接收控制中心的通知关闭窗口
    emitter.on('CONTROLLER_CENTER_EVENT', () => {
      Log.showInfo(TAG, '接收控制中心的通知关闭窗口')
      this.destroyControlCenter()
    })
    // 接收亮度条通知关闭窗口
    emitter.on('BRIGHTNESS_DIALOG_TIMER_EVENT', () => {
      Log.showInfo(TAG, '接收亮度条通知关闭窗口')
      this.destroyControlCenter()
    })

    // 监听红外模式的home按键，并返回主界面
    inputConsumer.on('key', {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_MOVE_HOME,
      isFinalKeyDown: false,
      finalKeyDownDuration: 1000
    }, (keyOptions: inputConsumer.KeyOptions) => {
      Log.showInfo(TAG, '按下KEYCODE_MOVE_HOME键')
      NavigationBarEventModel.homeEvent();
    })

    // 监听蓝牙模式的home按键，并返回主界面
    inputConsumer.on('key', {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_HOME,
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    }, (keyOptions: inputConsumer.KeyOptions) => {
      Log.showInfo(TAG, '按下KEYCODE_HOME键')
      NavigationBarEventModel.homeEvent();
    })

    //监听遥控器的设置键，拉起设置应用
    inputConsumer.on('key', {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_TAPE,
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    }, (keyOptions: inputConsumer.KeyOptions) => {
      Log.showInfo(TAG, '按下设置键KEYCODE_TAPE')
      this.context.startAbility({
        bundleName: 'com.ohos.settings',
        abilityName: 'com.ohos.settings.MainAbility'
      })
    })

    //监听红外遥控器的设置键，拉起设置应用
    inputConsumer.on('key', {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_SETUP,
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    }, (keyOptions: inputConsumer.KeyOptions) => {
      Log.showInfo(TAG, '按下设置键KEYCODE_SETUP')
      NavigationBarEventModel.setupEvent();
    })

    // 监听看电视键，拉起输入源应用, 并切入设置的直播源通道
    inputConsumer.on('key', {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_TV, //看电视键
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    }, (keyOptions: inputConsumer.KeyOptions) => {
      Log.showInfo(TAG, '按下KEYCODE_TV键')
      NavigationBarEventModel.tvEvent(this.getWatchTvSourceName());
      // 三模遥控器按看电视键后, 硬件直接切换到了机顶盒控制, 假如信源没信号的话, 就没法切通道了
      // 所以这里通知遥控器切回TV 控制, 等信号有变化了, 再切到机顶盒控制
      const want: Want = {
        bundleName: 'com.ohos.systemui',
        abilityName: 'com.ohos.systemui.pairservice.ServiceExtAbility',
        parameters: { command: 'set3ModeRemoteToTV' }
      };
      this.context.startServiceExtensionAbility(want);
    })

    // 监听信源键，拉起输入源应用
    inputConsumer.on('key', {
      preKeys: [],
      finalKey: 10250, // key_source 信源键
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    }, (keyOptions: inputConsumer.KeyOptions) => {
      Log.showInfo(TAG, '按下红外TV键：10250')
      NavigationBarEventModel.tvEvent('');
    })

    //截屏，录屏按键监听
    if (deviceInfo.productModel != 'Hi3751V352') {
      let keyOptionsScreenRecorder: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: KeyCode.KEYCODE_PC,
        isFinalKeyDown: false,
        finalKeyDownDuration: 0
      }
      let cbScreenRecorder = (keyOptions: inputConsumer.KeyOptions) => {
        Log.showInfo(TAG, '按下录屏组合键')
        this.context.startAbility({
          bundleName: 'ohos.samples.screenrecorder',
          abilityName: 'ScreenRecorderAbility'
        })
      }
      inputConsumer.on('key', keyOptionsScreenRecorder, cbScreenRecorder)
    }

    console.log('voice');
    //语音键
    let keyOptionsVoiceDown: inputConsumer.KeyOptions = {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_F24,
      isFinalKeyDown: true,
      finalKeyDownDuration: 100
    }
    let cbScreenshot1 = (keyOptions: inputConsumer.KeyOptions) => {
      console.log(TAG, 'voice down')
      this.context.startAbility({
        bundleName: 'com.qcode.edubox.voice_assistant',
        abilityName: 'VoiceServiceExtensionAbility',
        parameters: {
          voiceKeyDown: true
        }
      })
    }

    let keyOptionsVoiceUp: inputConsumer.KeyOptions = {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_F24,
      isFinalKeyDown: false,
      finalKeyDownDuration: 200
    }
    let cbVoiceUp = (keyOptions: inputConsumer.KeyOptions) => {
      console.log(TAG, 'voice up')
      this.context.startAbility({
        bundleName: 'com.qcode.edubox.voice_assistant',
        abilityName: 'VoiceServiceExtensionAbility',
        parameters: {
          voiceKeyDown: false
        }
      })
    }

    inputConsumer.on('key', keyOptionsVoiceDown, cbScreenshot1)
    inputConsumer.on('key', keyOptionsVoiceUp, cbVoiceUp)


    let keyOptionsScreenshot: inputConsumer.KeyOptions = {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_FN,
      isFinalKeyDown: false,
      finalKeyDownDuration: 0
    }
    let cbScreenshot = (keyOptions: inputConsumer.KeyOptions) => {
      Log.showInfo(TAG, '按下截屏组合键')
      this.context.startAbility({
        bundleName: 'com.ohos.screenshot',
        abilityName: 'com.ohos.screenshot.ServiceExtAbility'
      })
    }
    inputConsumer.on('key', keyOptionsScreenshot, cbScreenshot)

    //添加延时是开机时settingdata无法获取，需要等settingdata起来之后去调用改接口获取
    setTimeout(() => {
      let res = settings.getValueSync(this.context, 'miracastName', 'GK6320')
      systemParameterEnhance.setSync('persist.castengine.name', res)
    }, 10000)
  }

  onDestroy(): void {
    this.offControllerListener()
    this.destroyDialog()
    this.destroyControlCenter()
    this.destroyFlotWindow()
    this.stopFloatCheckTimer();
    this.preDataFlush?.deletePreferences();
    inputMonitor.off('touch', this.touchChange.bind(this));
    emitter.off('CONTROLLER_CENTER_EVENT')
    emitter.off('BRIGHTNESS_DIALOG_TIMER_EVENT')
    Log.showInfo(TAG, 'onDestroy')
  }

  onWindowStageCreate(windowStage: winApi.WindowStage) {
    // Main window is created, set main page for this ability
    Log.showInfo(TAG, '[Demo] MainAbility onWindowStageCreate');
    try {
      let promise = winApi.getLastWindow(this.context);
      promise.then((data: winApi.Window) => {
        let isLayoutFullScreen = true;
        try {
          data.setWindowLayoutFullScreen(isLayoutFullScreen, (err: BusinessError) => {
            if (err.code) {
              Log.showError(TAG, 'Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
              return;
            }
            Log.showInfo(TAG, 'Succeeded in setting the window layout to full-screen mode.');
          });
          data.setWindowSystemBarEnable(['navigation'])
        } catch (exception) {
          Log.showError(TAG, 'Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(exception));
        }
        Log.showInfo(TAG, 'Succeeded in obtaining the top window. Data: ' + JSON.stringify(data));
      }).catch((err: BusinessError) => {
        Log.showError(TAG, 'Failed to obtain the top window. Cause: ' + JSON.stringify(err));
      });
    } catch (exception) {
      Log.showError(TAG, 'Failed to obtain the top window. Cause: ' + JSON.stringify(exception));
    }
    // ServiceExtensionAbility 无 WindowStage UI 页面容器，不调用 setUIContent。
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Log.showInfo(TAG, '[Demo] MainAbility onWindowStageDestroy')
  }

  private getHdmiSourceName(source: displaySetting.SourceType): string {
    return 'HDMI' + source
  }

  private getWatchTvSourceName(): string {
    try {
      let stringIndex: string =
        settings.getValueSync(this.context, 'watchTvSource', '-1', settings.domainName.DEVICE_SHARED)
      let source: number = Number.parseInt(stringIndex)
      if (source >= displaySetting.SourceType.SOURCE_HDMI1 && source <= displaySetting.SourceType.SOURCE_HDMI4) {
        let sourceName = this.getHdmiSourceName(source)
        Log.showDebug(TAG, `getWatchTvSourceName = ${sourceName}`)
        return sourceName
      }
    } catch (error) {
    }
    // 如果未设置过看电视键绑定的信源, 则默认为 hdmi 1
    return 'HDMI1'
  }
}

export default ServiceExtAbility;
