/*
* Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start navigation_implement_pip_manager]
// navigation/PipManager.ets
import { PiPWindow, typeNode } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { XCNodeController } from './XCNodeController';
import { AVPlayer } from '../model/AVPlayer';
import { Logger } from '../util/LogUtil';

export class CustomXComponentController extends XComponentController {
  onSurfaceCreated(surfaceId: string): void {
    Logger.info(TAG, `onSurfaceCreated surfaceId: ${surfaceId}`);
    if (PipManager.getInstance().player.surfaceID === surfaceId) {
      return;
    }
    // 将surfaceId设置给媒体源
    PipManager.getInstance().player.surfaceID = surfaceId;
    PipManager.getInstance().player.avPlayerFdSrc();
  }

  onSurfaceDestroyed(surfaceId: string): void {
    Logger.info(TAG, `onSurfaceDestroyed surfaceId: ${surfaceId}`);
  }
}

const TAG = 'PipManager';

export class PipManager {
  private static instance: PipManager = new PipManager();
  private pipController?: PiPWindow.PiPController = undefined;
  private xcNodeController: XCNodeController;
  private mXComponentController: XComponentController;
  private lifeCycleCallback: Set<Function> = new Set();
  public player: AVPlayer;

  public static getInstance(): PipManager {
    return PipManager.instance;
  }

  constructor() {
    this.xcNodeController = new XCNodeController();
    this.player = new AVPlayer();
    this.mXComponentController = new CustomXComponentController();
  }

  public registerLifecycleCallback(callBack: Function) {
    this.lifeCycleCallback.add(callBack);
  }

  public unRegisterLifecycleCallback(callBack: Function): void {
    this.lifeCycleCallback.delete(callBack);
  }

  getNode(): typeNode.XComponent | null {
    return this.xcNodeController.getNode();
  }

  onActionEvent(control: PiPWindow.ControlEventParam) {
    switch (control.controlType) {
      case PiPWindow.PiPControlType.VIDEO_PLAY_PAUSE:
        if (control.status === PiPWindow.PiPControlStatus.PAUSE) {
          //停止视频
        } else if (control.status === PiPWindow.PiPControlStatus.PLAY) {
          //播放视频
        }
        break;
      case PiPWindow.PiPControlType.VIDEO_NEXT:
        // 切换到下一个视频
        break;
      case PiPWindow.PiPControlType.VIDEO_PREVIOUS:
        // 切换到上一个视频
        break;
      case PiPWindow.PiPControlType.FAST_FORWARD:
        // 视频进度快进
        break;
      case PiPWindow.PiPControlType.FAST_BACKWARD:
        // 视频进度后退
        break;
      default:
        break;
    }
    Logger.info('onActionEvent, controlType:' + control.controlType + ', status' + control.status);
  }

  onStateChange(state: PiPWindow.PiPState, reason: string) {
    let curState: string = '';
    this.xcNodeController.setCanAddNode(
      state === PiPWindow.PiPState.ABOUT_TO_STOP || state === PiPWindow.PiPState.STOPPED)
    if (this.lifeCycleCallback !== null) {
      this.lifeCycleCallback.forEach((fun) => {
        fun(state);
      });
    }
    switch (state) {
      case PiPWindow.PiPState.ABOUT_TO_START:
        curState = 'ABOUT_TO_START';
        // 将typeNode节点从布局移除
        this.xcNodeController.removeNode();
        break;
      case PiPWindow.PiPState.STARTED:
        curState = 'STARTED';
        break;
      case PiPWindow.PiPState.ABOUT_TO_STOP:
        curState = 'ABOUT_TO_STOP';
        break;
      case PiPWindow.PiPState.STOPPED:
        curState = 'STOPPED';
        break;
      case PiPWindow.PiPState.ABOUT_TO_RESTORE:
        curState = 'ABOUT_TO_RESTORE';
        break;
      case PiPWindow.PiPState.ERROR:
        curState = 'ERROR';
        break;
      default:
        break;
    }
    Logger.info(`[${TAG}] onStateChange: ${curState}, reason: ${reason}`);
  }

  unregisterPipStateChangeListener() {
    Logger.info(`${TAG} aboutToDisappear`);
    this.pipController?.off('stateChange');
    this.pipController?.off('controlEvent');
    this.pipController = undefined;
  }

  getXComponentController(): CustomXComponentController {
    return this.mXComponentController;
  }

  // 步骤1：创建画中画控制器，注册生命周期事件以及控制事件回调
  init(ctx: Context) {
    if (this.pipController !== null && this.pipController != undefined) {
      return;
    }
    Logger.info(`${TAG} onPageShow`)
    if (!PiPWindow.isPiPEnabled()) {
      Logger.error(TAG, `picture in picture disabled for current OS`);
      return;
    }

    let config: PiPWindow.PiPConfiguration = {
      context: ctx,
      componentController: this.getXComponentController(),
      templateType: PiPWindow.PiPTemplateType.VIDEO_PLAY,
      contentWidth: 1920, // 使用typeNode启动画中画时，contentWidth需设置为大于0的值，否则创建画中画失败
      contentHeight: 1080, // 使用typeNode启动画中画时，contentHeight需设置为大于0的值，否则创建画中画失败
    };
    // 通过create接口创建画中画控制器实例

    PiPWindow.create(config, this.xcNodeController.getNode()).then((controller: PiPWindow.PiPController) => {
      this.pipController = controller;
      // 通过画中画控制器实例的setAutoStartEnabled接口设置是否需要在应用返回桌面时自动启动画中画
      this.pipController?.setAutoStartEnabled(true);
      // 通过画中画控制器实例的on('stateChange')接口注册生命周期事件回调
      this.pipController.on('stateChange', (state: PiPWindow.PiPState, reason: string) => {
        this.onStateChange(state, reason);
      });
      // 通过画中画控制器实例的on('controlEvent')接口注册控制事件回调
      this.pipController.on('controlEvent', (control: PiPWindow.ControlEventParam) => {
        this.onActionEvent(control);
      });
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to create pip controller. Cause:${err.code}, message:${err.message}`);
    });
  }

  // 步骤2：启动画中画
  startPip() {
    this.pipController?.startPiP().then(() => {
      Logger.info(TAG, `Succeeded in starting pip.`);
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to start pip. Cause:${err.code}, message:${err.message}`);
    });
  }

  // 步骤3：更新媒体源尺寸信息
  updateContentSize(width: number, height: number) {
    if (this.pipController) {
      this.pipController.updateContentSize(width, height);
    }
  }

  // 步骤4：关闭画中画
  stopPip() {
    if (this.pipController === null || this.pipController === undefined) {
      return;
    }
    let promise: Promise<void> = this.pipController.stopPiP();
    promise.then(() => {
      Logger.info(TAG, `Succeeded in stopping pip.`);
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to stop pip. Cause:${err.code}, message:${err.message}`);
    });
  }

  getNodeController(): XCNodeController {
    Logger.info(TAG, `getNodeController.`);
    return this.xcNodeController;
  }

  setAutoStart(autoStart: boolean): void {
    this.pipController?.setAutoStartEnabled(autoStart);
  }

  removeNode() {
    this.xcNodeController.removeNode();
  }

  addNode(): void {
    this.xcNodeController.addNode();
  }
}
// [End navigation_implement_pip_manager]