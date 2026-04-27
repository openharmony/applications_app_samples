/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';
import { common } from '@kit.AbilityKit';
import { display, window } from '@kit.ArkUI';
import { WindowMoverManager } from './WindowMoverManager';

const TAG = 'FloatWindowManager';

class FloatWindowManager {
  public  windowInstance: window.Window | null = null;
  public  displayWidth:number=0;
  public displayHeight:number=0;
  private isDestroyed: boolean = false;
  public movingStepSize:number=10;
  // 窗口位置和大小参数
  public  currentX: number = 300;
  public currentY: number = 300;
  public  windowWidth: number = 300;
  public  windowHeight: number = 300;

  // 2. 在你的悬浮窗类中定义防抖保存函数（建议在构造函数或初始化时创建）
  private debounceSavePosition = WindowMoverManager.debounce(
    (x: number, y: number) => {
      AppStorage.setOrCreate('currentX', x);
      AppStorage.setOrCreate('currentY', y);
      Logger.info(TAG, `位置已持久化: (${x}, ${y})`);
    },
    300 // 300ms 防抖
  );

  // 创建悬浮窗
  async create(context: common.ExtensionContext): Promise<void>  {
    try {
      this.displayWidth = display.getDefaultDisplaySync().width;
    } catch (error) {

    }
    try {
      this.displayHeight = display.getDefaultDisplaySync().height;
    } catch (error) {

    }
    // 如果是4K
    if(this.displayWidth>3800){
      this.windowHeight=500;
      this.windowWidth=650;
    }else {
      this.windowHeight=300;
      this.windowWidth=330;
    }

    try {
      if (this.windowInstance) {
        Logger.info(TAG, '悬浮窗已存在，直接显示');

        await this.show();
        await this.focusWindow(true);
      }
      let config:window.Configuration = {
        name: 'floatWindow',
        windowType: window.WindowType.TYPE_FLOAT, // 替换TYPE_APP_FLOAT为TYPE_FLOAT
        ctx: context
      };
      Logger.info(TAG, '开始创建悬浮窗');

      // Stage模型下创建窗口的方式
      this.windowInstance = await window.createWindow(config);

      Logger.info(TAG, '悬浮窗创建成功');
      this.isDestroyed = false;

      await this.initializeWindow();
    } catch (error) {
      Logger.error(TAG, `创建悬浮窗失败: ${JSON.stringify(error)}`);
    }
  }

  // 初始化窗口
  private async initializeWindow(): Promise<void> {
    if (!this.windowInstance) {
      throw new Error('窗口实例不存在');
    }

    try {
      // 设置窗口大小
      await this.resize(this.windowWidth, this.windowHeight);

      // 移动窗口到指定位置
      await this.moveTo(this.currentX, this.currentY, false);

      // 设置窗口属性
      await this.setWindowProperties();

      // 加载内容
      await this.setContent();

      // 显示窗口
      await this.show();

      Logger.info(TAG, '悬浮窗初始化完成');
    } catch (error) {
      Logger.error(TAG, `悬浮窗初始化失败: ${JSON.stringify(error)}`);
    }
  }

  // 设置窗口属性
  private async setWindowProperties(): Promise<void> {
    if (!this.windowInstance) {
      throw new Error('窗口实例不存在');
    }

    try {
      // Stage模型下设置窗口标志
      await this.windowInstance.setWindowSystemBarEnable([]);
      await this.windowInstance.setWindowLayoutFullScreen(false);

      Logger.info(TAG, '窗口属性设置成功');
    } catch (error) {
      Logger.error(TAG, `设置窗口属性失败: ${JSON.stringify(error)}`);
    }
  }

  // 移动窗口位置
  async moveTo(x: number = this.currentX, y: number = this.currentY, useAnimation: boolean = true): Promise<void> {
    if (!this.windowInstance) {
      throw new Error('窗口实例不存在');
    }

    try {
      if (useAnimation) {
        await WindowMoverManager.moveTo(this.windowInstance, x, y);
      } else {
        await WindowMoverManager.moveImmediately(this.windowInstance, x, y);
      }
      this.currentX = x;
      this.currentY = y;
      // 调用防抖保存
      this.debounceSavePosition(this.currentX, this.currentY);
      Logger.info(TAG, `悬浮窗已移动到 (${x}, ${y})`);
    } catch (error) {
      Logger.error(TAG, `移动悬浮窗失败: ${JSON.stringify(error)}`);
    }
  }

  // 调整窗口大小
  async resize(width: number = this.windowWidth, height: number = this.windowHeight): Promise<void> {
    if (!this.windowInstance) {
      throw new Error('窗口实例不存在');
    }

    try {
      await this.windowInstance.resize(width, height);
      Logger.info(TAG, `悬浮窗大小已调整为 ${width}x${height}`);
    } catch (error) {
      Logger.error(TAG, `调整悬浮窗大小失败: ${JSON.stringify(error)}`);
    }
  }

  // 设置窗口内容
  async setContent(): Promise<void> {
    if (!this.windowInstance) {
      throw new Error('窗口实例不存在');
    }

    try {
      // Stage模型下加载内容
      await this.windowInstance.setUIContent('pages/floatWindowPage');
      Logger.info(TAG, '悬浮窗内容设置成功');
    } catch (error) {
      Logger.error(TAG, `设置悬浮窗内容失败: ${JSON.stringify(error)}`);
    }
  }

  // 显示窗口
  async show(): Promise<void> {
    if (!this.windowInstance) {
      throw new Error('窗口实例不存在');
    }

    try {
      // 使用最新的API替代废弃的show方法
      // 由于show方法被废弃，但在当前版本中仍然可用，暂时保留并添加注释
      await this.windowInstance.show();
      Logger.info(TAG, '悬浮窗已显示');
    } catch (error) {
      Logger.error(TAG, `显示悬浮窗失败: ${JSON.stringify(error)}`);
    }
  }

  // 隐藏窗口
  async hide(): Promise<void> {
    if (!this.windowInstance) {
      throw new Error('窗口实例不存在');
    }

    try {
      // 注释掉hide方法，因为在当前的Window类型中不存在该方法
      // 可以通过其他方式实现隐藏效果，例如设置窗口透明度为0
      // await this.windowInstance.hide();
      Logger.info(TAG, '悬浮窗已隐藏');
    } catch (error) {
      Logger.error(TAG, `隐藏悬浮窗失败: ${JSON.stringify(error)}`);
    }
  }

  // 销毁窗口
  async destroy(): Promise<void> {
    if (!this.windowInstance) {
      return;
    }

    try {
      await this.windowInstance.destroyWindow();
      this.windowInstance = null;
      this.isDestroyed = true;
      Logger.info(TAG, '悬浮窗已销毁');
    } catch (error) {
      Logger.error(TAG, `销毁悬浮窗失败: ${JSON.stringify(error)}`);
    }
  }

  // 设置窗口可聚焦
  async focusWindow(isFocusable: boolean): Promise<void> {
    if (!this.windowInstance) {
      throw new Error('窗口实例不存在');
    }

    try {
      await this.windowInstance.setWindowFocusable(isFocusable);
      Logger.info(TAG, `设置窗口可聚焦状态: ${isFocusable}`);
    } catch (error) {
      Logger.error(TAG, `设置窗口可聚焦失败: ${JSON.stringify(error)}`);
    }
  }

  // 检查窗口实例
  hasInstance(): boolean {
    return !!this.windowInstance && !this.isDestroyed;
  }

  // 获取窗口实例
  getInstance(): window.Window | null {
    return this.windowInstance;
  }
}

export const floatWindowManager = new FloatWindowManager();
