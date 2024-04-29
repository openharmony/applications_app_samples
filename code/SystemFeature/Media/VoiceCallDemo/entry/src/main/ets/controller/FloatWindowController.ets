/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Logger from '../utils/Logger';
import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import display from '@ohos.display';

const TAG = 'FloatWindowController';
const FLOAT_SIZE = vp2px(120);

/**
 * 悬浮窗控制类
 */
export default class FloatWindowController {

  // 创建单例模式
  private static mInstance: FloatWindowController | null = null;

  public static getInstance(): FloatWindowController {
    if (FloatWindowController.mInstance == null) {
      FloatWindowController.mInstance = new FloatWindowController();
    }
    return FloatWindowController.mInstance;
  }

  private constructor() {
    // 私有化构造函数
  }

  private floatWindow: window.Window | null = null;
  private windowStage: window.WindowStage | null = null;

  //ability调用，监听windowStage状态变化
  async initWindowStage(context: common.UIAbilityContext, windowStage: window.WindowStage) {
    this.windowStage = windowStage;
    let mainWin = await windowStage.getMainWindow();

    await mainWin.setWindowSystemBarProperties({
      statusBarColor: '#182431',
      navigationBarColor: '#182431'
    });

    windowStage.on('windowStageEvent', (event: window.WindowStageEventType) => {
      if (event === window.WindowStageEventType.SHOWN) {
        this.destroyFloatWindow();
      } else if (event === window.WindowStageEventType.HIDDEN) {
        this.createAndShowFloatWindow(context);
      }
    });
  }

  //此处有一个bug，当前ability调用windowStage.getMainWindow().hide()方法，会与上一个ability一起hide
  async hideMain() {
    if(this.windowStage){
      let mainWin: window.Window = await this.windowStage.getMainWindow();
      mainWin.hide();
    }
  }

  //创建悬浮窗
  private async createAndShowFloatWindow(context: common.UIAbilityContext) {
    if (context.isTerminating()) {
      return;
    }

    Logger.info(TAG,` createAndShowWindow`);
    try {
      let w = display.getDefaultDisplaySync().width;
      // 创建应用子窗口
      this.floatWindow = await window.createWindow({
        name: 'DemoFloatWindow',
        windowType: window.WindowType.TYPE_FLOAT,
        ctx: context
      });
      await this.floatWindow.moveWindowTo(w - FLOAT_SIZE, FLOAT_SIZE * 2);
      await this.floatWindow.resize(FLOAT_SIZE, FLOAT_SIZE);
      await this.floatWindow.setUIContent('pages/Float');
      this.floatWindow.setWindowBackgroundColor('#00000000');
      await this.floatWindow.showWindow();
    } catch (err) {
      Logger.error(TAG,`createSubWindow failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  // 销毁悬浮窗
  public async destroyFloatWindow() {
    Logger.info(TAG,` destroyWindow`);
    if (this.floatWindow) {
      await this.floatWindow.destroyWindow();
    }
  }
}
