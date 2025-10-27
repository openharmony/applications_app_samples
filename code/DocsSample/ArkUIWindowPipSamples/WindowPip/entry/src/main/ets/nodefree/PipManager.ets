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

// [Start typenode_free_implement_pip_manager]
// nodeFree/PipManager.ets
// 画中画控制器单例
import { PiPWindow, typeNode } from '@kit.ArkUI'; // 引入PiPWindow模块
import { BusinessError } from '@kit.BasicServicesKit';
import { AVPlayer} from '../model/AVPlayer';
import { Logger } from '../util/LogUtil';

// 自定义XComponentController
class CustomXComponentController extends XComponentController {
  // 监听onSurfaceCreated，并将surfaceId设置给播放器
  onSurfaceCreated(surfaceId: string): void {
    Logger.info(TAG, `onSurfaceCreated surfaceId: ${surfaceId}`);
    if (PipManager.getInstance().player.surfaceID === surfaceId) {
      return;
    }
    PipManager.getInstance().player.surfaceID = surfaceId;
    PipManager.getInstance().player.avPlayerFdSrc();
  }

  onSurfaceDestroyed(surfaceId: string): void {
    Logger.info(TAG, `onSurfaceDestroyed surfaceId: ${surfaceId}`);
  }
}

const TAG = 'PipManager';

export class PipManager {
  public player: AVPlayer;
  private static instance: PipManager = new PipManager();
  private pipController?: PiPWindow.PiPController = undefined;
  private mXComponentController: XComponentController;
  private xComponent: typeNode.XComponent| null = null; // typeNode节点

  public static getInstance(): PipManager {
    return PipManager.instance;
  }

  constructor() {
    this.player = new AVPlayer();
    this.mXComponentController = new CustomXComponentController();
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

  // 监听画中画生命周期
  onStateChange(state: PiPWindow.PiPState, reason: string) {
    let curState: string = '';
    switch (state) {
      case PiPWindow.PiPState.ABOUT_TO_START:
        curState = 'ABOUT_TO_START';
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

  // 解注册监听
  unregisterPipStateChangeListener() {
    Logger.info(TAG, 'aboutToDisappear');
    this.pipController?.off('stateChange');
    this.pipController?.off('controlEvent');
  }

  getXComponentController(): CustomXComponentController {
    return this.mXComponentController;
  }

  // 步骤1：创建画中画控制器，注册生命周期事件以及控制事件回调
  init(ctx: Context) {
    if (this.pipController !== null && this.pipController != undefined) {
      return;
    }
    Logger.info(TAG, 'onPageShow');
    if (!PiPWindow.isPiPEnabled()) {
      Logger.error(TAG, `picture in picture disabled for current OS`);
      return;
    }

    let config: PiPWindow.PiPConfiguration = {
      context: ctx,
      componentController: this.getXComponentController(),
      templateType: PiPWindow.PiPTemplateType.VIDEO_PLAY,
      contentWidth: 1920, // 使用typeNode启动画中画时，contentWidth需设置为大于0的值，否则将设置为16:9默认比例
      contentHeight: 1080, // 使用typeNode启动画中画时，contentHeight需设置为大于0的值，否则将设置为16:9默认比例
    };
    // 通过create接口创建画中画控制器实例

    PiPWindow.create(config, this.xComponent).then((controller: PiPWindow.PiPController) => {
      this.pipController = controller;
      // 通过画中画控制器实例的setAutoStartEnabled接口设置是否需要在应用返回桌面时自动启动画中画
      this.pipController.setAutoStartEnabled(true);
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

  // 步骤2：创建画中画控制器实例后，通过startPiP接口启动画中画
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

  setAutoStart(autoStart: boolean): void {
    this.pipController?.setAutoStartEnabled(autoStart);
  }

  // 创建typeNode节点
  makeTypeNode(ctx: UIContext) {
    if (this.xComponent === null || this.xComponent === undefined) {
      // 创建XComponent类型的typeNode
      this.xComponent = typeNode.createNode(ctx, 'XComponent', {
        // 类型设置为SURFACE
        type: XComponentType.SURFACE,
        // 设置XComponentController
        controller: PipManager.getInstance().getXComponentController(),
      });
    }
  }
}
// [End typenode_free_implement_pip_manager]