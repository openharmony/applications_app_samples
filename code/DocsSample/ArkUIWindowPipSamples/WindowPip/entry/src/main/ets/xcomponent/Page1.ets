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

// [Start x_component_implement_page1]
// Page1.ets
// 该页面用于展示画中画功能的基本使用
import { AVPlayer } from '../model/AVPlayer';
import { BuilderNode, FrameNode, NodeController, UIContext, PiPWindow } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../util/LogUtil';

const TAG = 'Page1';

class Params {
  public text: string = '';

  constructor(text: string) {
    this.text = text;
  }
}

// 开发者可以通过@Builder装饰器实现布局构建
@Builder
function buildText(params: Params) {
  Column() {
    Text(params.text)
      .fontSize(20)
      .fontColor(Color.Red)
  }
  .width('100%') // 宽度方向充满画中画窗口
  .height('100%') // 高度方向充满画中画窗口
}

// 开发者可通过继承NodeController实现自定义UI控制器
class TextNodeController extends NodeController {
  private message: string;
  private textNode: BuilderNode<[Params]> | null = null;

  constructor(message: string) {
    super();
    this.message = message;
  }

  // 通过BuilderNode加载自定义布局
  makeNode(context: UIContext): FrameNode | null {
    this.textNode = new BuilderNode(context);
    this.textNode.build(wrapBuilder<[Params]>(buildText), new Params(this.message));
    return this.textNode.getFrameNode();
  }

  // 开发者可自定义该方法实现布局更新
  update(message: string) {
    Logger.info(`update message: ${message}`);
    if (this.textNode !== null) {
      this.textNode.update(new Params(message));
    }
  }
}

@Entry
@Component
export struct Page1 {
  @Consume('pageInfos') pageInfos: NavPathStack;
  private surfaceId: string = ''; // surfaceId，用于关联XComponent与视频播放器
  private mXComponentController: XComponentController = new XComponentController();
  private player?: AVPlayer = undefined;
  private pipController?: PiPWindow.PiPController = undefined;
  private nodeController: TextNodeController = new TextNodeController('this is custom UI');
  navId: string = '';
  private options: XComponentOptions = {
    type: XComponentType.SURFACE,
    controller: this.mXComponentController
  }

  build() {
    NavDestination() {
      Column() {
        // XComponent控件，用于播放视频流
        XComponent(this.options)
          .onLoad(() => {
            this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
            // 需要设置AVPlayer的surfaceId为XComponentController的surfaceId
            this.player = new AVPlayer();
            this.player.surfaceID = this.surfaceId;
            this.player.avPlayerFdSrc();
          })
          .onDestroy(() => {
            Logger.info(`[${TAG}] XComponent onDestroy`);
          })
          .size({ width: '100%', height: '800px' })
        Row({ space: 20 }) {
          Button('startPip') // 启动画中画
            .onClick(() => {
              this.startPip();
            })
            .stateStyles({
              pressed: {
                .backgroundColor(Color.Red);
              },
              normal: {
                .backgroundColor(Color.Blue);
              }
            })
          Button('stopPip') // 停止画中画
            .onClick(() => {
              this.stopPip();
            })
            .stateStyles({
              pressed: {
                .backgroundColor(Color.Red);
              },
              normal: {
                .backgroundColor(Color.Blue);
              }
            })
          Button('updateSize') // 更新视频尺寸
            .onClick(() => {
              // 此处设置的宽高应为媒体内容宽高，需要通过媒体相关接口或回调获取
              // 例如使用AVPlayer播放视频时，可通过videoSizeChange回调获取媒体源更新后的尺寸
              this.updateContentSize(900, 1600);
            })
            .stateStyles({
              pressed: {
                .backgroundColor(Color.Red);
              },
              normal: {
                .backgroundColor(Color.Blue);
              }
            })
        }
        .size({ width: '100%', height: 60 })
        .justifyContent(FlexAlign.SpaceAround)
      }
      .justifyContent(FlexAlign.Center)
      .height('100%')
      .width('100%')
    }
  }

  startPip() {
    if (!PiPWindow.isPiPEnabled()) {
      Logger.error(`picture in picture disabled for current OS`);
      return;
    }
    let config: PiPWindow.PiPConfiguration = {
      context: this.getUIContext().getHostContext() as Context,
      componentController: this.mXComponentController,
      // 当前page导航id
      // 1、UIAbility使用Navigation管理页面，需要设置Navigation控件的id属性，并将该id设置给画中画控制器，确保还原场景下能够从画中画窗口恢复到原页面
      // 2、UIAbility使用Router管理页面时（画中画场景不推荐该导航方式），无需设置navigationId。注意：该场景下启动画中画后，不要进行页面切换，否则还原场景可能出现异常
      // 3、UIAbility只有单页面时，无需设置navigationId，还原场景下也能够从画中画窗口恢复到原页面
      navigationId: this.navId,
      // 对于视频通话、视频会议等场景，需要设置相应的模板类型
      templateType: PiPWindow.PiPTemplateType.VIDEO_PLAY,
      // 可选，创建画中画控制器时系统可通过XComponent组件大小设置画中画窗口比例
      contentWidth: 1920,
      // 可选，创建画中画控制器时系统可通过XComponent组件大小设置画中画窗口比例
      contentHeight: 1080,
      // 可选，对于视频通话、视频会议和视频直播场景，可通过该属性选择对应模板类型下需显示的的控件组
      controlGroups: [PiPWindow.VideoPlayControlGroup.VIDEO_PREVIOUS_NEXT],
      // 可选，如果需要在画中画显示内容上方展示自定义UI，可设置该参数。
      customUIController: this.nodeController,
    };
    // 步骤1：创建画中画控制器，通过create接口创建画中画控制器实例
    PiPWindow.create(config).then((controller: PiPWindow.PiPController) => {
      this.pipController = controller;
      // 步骤1：初始化画中画控制器
      this.initPipController();
      // 步骤2：通过startPiP接口启动画中画
      this.pipController.startPiP().then(() => {
        Logger.info(`Succeeded in starting pip.`);
      }).catch((err: BusinessError) => {
        Logger.error(`Failed to start pip. Cause:${err.code}, message:${err.message}`);
      });
    }).catch((err: BusinessError) => {
      Logger.error(`Failed to create pip controller. Cause:${err.code}, message:${err.message}`);
    });
  }

  initPipController() {
    if (!this.pipController) {
      return;
    }
    // 步骤1：通过setAutoStartEnabled接口设置是否需要在应用返回桌面时自动启动画中画，注册stateChange和controlPanelActionEvent回调
    this.pipController.setAutoStartEnabled(false /*or true if necessary*/); // 默认为false
    this.pipController.on('stateChange', (state: PiPWindow.PiPState, reason: string) => {
      this.onStateChange(state, reason);
    });
    this.pipController.on('controlPanelActionEvent', (event: PiPWindow.PiPActionEventType, status?: number) => {
      this.onActionEvent(event, status);
    });
  }

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

  onActionEvent(event: PiPWindow.PiPActionEventType, status?: number) {
    switch (event) {
      case 'playbackStateChanged':
        // 开始或停止视频
        if (status === 0) {
          // 停止视频
        } else if (status === 1) {
          // 播放视频
        }
        break;
      case 'nextVideo':
        // 播放下一个视频
        break;
      case 'previousVideo':
        // 播放上一个视频
        break;
      default:
        break;
    }
  }

  // 步骤3：视频内容变化时，向画中画控制器更新视频尺寸信息，用于调整画中画窗口比例
  updateContentSize(width: number, height: number) {
    if (this.pipController) {
      this.pipController.updateContentSize(width, height);
    }
  }

  // 步骤4：当不再需要显示画中画时，通过stopPiP接口关闭画中画
  stopPip() {
    if (this.pipController) {
      let promise: Promise<void> = this.pipController.stopPiP();
      promise.then(() => {
        Logger.info(`Succeeded in stopping pip.`);
        this.pipController?.off('stateChange'); // 如果已注册stateChange回调，停止画中画时取消注册该回调
        this.pipController?.off('controlPanelActionEvent'); // 如果已注册controlPanelActionEvent回调，停止画中画时取消注册该回调
      }).catch((err: BusinessError) => {
        Logger.error(`Failed to stop pip. Cause:${err.code}, message:${err.message}`);
      });
    }
  }
}
// [End x_component_implement_page1]