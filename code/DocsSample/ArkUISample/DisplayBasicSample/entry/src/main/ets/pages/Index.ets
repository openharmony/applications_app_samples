/*

Copyright (c) 2025 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
import { display } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { PromptAction, UIContext } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

interface GeneratedTypeLiteralInterface {
  text: string;
  action: () => void;
}

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  uiContext: UIContext = this.getUIContext();
  promptAction: PromptAction = this.uiContext.getPromptAction();

  private buttonList: Array<GeneratedTypeLiteralInterface> = [
    {
      text: '获取Display对象',
      action: () => this.callGetDisplayClass()
    },
    {
      text: '获取Display对象属性',
      action: () => this.callGetDisplayInfo()
    },
    {
      text: '获取挖孔信息',
      action: () => this.callGetCutoutInfo()
    },
    {
      text: '获取截录屏状态',
      action: () => this.callGetDisplayCaptured()
    },
    {
      text: '测试Display监听机制',
      action: () => this.callDealListenCallback()
    },
    {
      text: '折叠设备判断',
      action: () => this.callDealFoldableDevice()
    }
  ]

  private callGetDisplayClass(): void {
    this.promptAction.openToast({ message: '调用getDisplayClass方法' }).catch((error: Error) => {
      hilog.error(DOMAIN, 'DisplayTest', `callGetDisplayClass error ${JSON.stringify(error)}`);
    }).then(() => {
      this.getDisplayClass();
    });
  }

  private callGetDisplayInfo(): void {
    this.promptAction.openToast({ message: '调用getDisplayInfo方法' }).catch((error: Error) => {
      hilog.error(DOMAIN, 'DisplayTest', `callGetDisplayInfo error ${JSON.stringify(error)}`);
    }).then(() => {
      this.getDisplayInfo();
    });
  }

  private callGetCutoutInfo(): void {
    this.promptAction.openToast({ message: '调用getCutoutInfo方法' }).catch((error: Error) => {
      hilog.error(DOMAIN, 'DisplayTest', `callGetCutoutInfo error ${JSON.stringify(error)}`);
    }).then(() => {
      this.getCutoutInfo();
    });
  }

  private callGetDisplayCaptured(): void {
    this.promptAction.openToast({ message: '调用getDisplayCaptured方法' }).catch((error: Error) => {
      hilog.error(DOMAIN, 'DisplayTest', `callGetDisplayCaptured error ${JSON.stringify(error)}`);
    }).then(() => {
      this.getDisplayCaptured();
    });
  }

  private callDealListenCallback(): void {
    this.promptAction.openToast({ message: '调用dealListenCallback方法' }).catch((error: Error) => {
      hilog.error(DOMAIN, 'DisplayTest', `callDealListenCallback error ${JSON.stringify(error)}`);
    }).then(() => {
      this.dealListenCallback();
    });
  }

  private callDealFoldableDevice(): void {
    this.promptAction.openToast({ message: '调用dealFoldableDevice方法' }).catch((error: Error) => {
      hilog.error(DOMAIN, 'DisplayTest', `callDealFoldableDevice error ${JSON.stringify(error)}`);
    }).then(() => {
      this.dealFoldableDevice();
    });
  }

  private getDisplayClass(): void {
    // [Start get_display_class]
    let displayClass: display.Display | null = null;
    try {
      displayClass = display.getDefaultDisplaySync();
      hilog.info(DOMAIN, 'DisplayTest', `The display info is: ${JSON.stringify(displayClass)}`);
    } catch (exception) {
      hilog.error(DOMAIN, 'DisplayTest',
        `Failed to get default display. Code: ${exception.code}, message: ${exception.message}`);
    }
    // [End get_display_class]
  }

  private getDisplayInfo(): void {
    // [Start get_display_info]
    let displayClass: display.Display | null = null;
    try {
      displayClass = display.getDefaultDisplaySync();
      // 获取屏幕Id
      hilog.info(DOMAIN, 'DisplayTest', `The screen Id is ${displayClass.id}.`);
      // 获取屏幕刷新率
      hilog.info(DOMAIN, 'DisplayTest', `The screen is ${displayClass.refreshRate}.`);
      // 获取屏幕宽度
      hilog.info(DOMAIN, 'DisplayTest', `The screen width is ${displayClass.width}.`);
      // 获取屏幕高度
      hilog.info(DOMAIN, 'DisplayTest', `The screen height is ${displayClass.height}.`);
      // ...
    } catch (exception) {
      hilog.error(DOMAIN, 'DisplayTest',
        `Failed to get default display. Code: ${exception.code}, message: ${exception.message}`);
    }
    // [End get_display_info]
  }

  private getCutoutInfo(): void {
    // [Start get_cutoutInfo]
    let displayClass: display.Display | null = null;
    try {
      displayClass = display.getDefaultDisplaySync();
      displayClass.getCutoutInfo().then((cutoutInfo: display.CutoutInfo) => {
        // 在有挖孔信息的时候进行处理
        if (cutoutInfo.boundingRects.length > 0) {
          hilog.info(DOMAIN, 'DisplayTest', `cutoutInfo boundingRects: ${JSON.stringify(cutoutInfo.boundingRects)}`);
        } else {
          hilog.info(DOMAIN, 'DisplayTest', 'There is no cutout info on the screen.');
        }
        // 处理瀑布屏的区域信息
        hilog.info(DOMAIN, 'DisplayTest',
          `cutoutInfo waterfallDisplayAreaRects: ${JSON.stringify(cutoutInfo.waterfallDisplayAreaRects)}`);
      }).catch((err: BusinessError) => {
        hilog.error(DOMAIN, 'DisplayTest',
          `Failed to obtain the cutout info object. Code: ${err.code}, message: ${err.message}`);
      });
    } catch (exception) {
      hilog.error(DOMAIN, 'DisplayTest',
        `Failed to get default display. Code: ${exception.code}, message: ${exception.message}`);
    }
    // [End get_cutoutInfo]
  }

  private getDisplayCaptured(): void {
    // [Start get_display_captured]
    try {
      hilog.info(DOMAIN, 'DisplayTest', `The screen is captured or not : ${display.isCaptured()}`);
    } catch (exception) {
      hilog.error(DOMAIN, 'DisplayTest',
        `Failed to get display isCaptured. Code: ${exception.code}, message: ${exception.message}`);
    }
    // [End get_display_captured]
  }

  private dealListenCallback(): void {
    // [Start add_listen_callback]
    /**
     * 注册监听的callback参数要采用对象传递.
     * 若使用匿名函数注册，每次调用会创建一个新的底层对象，引起内存泄漏问题。
     */
    let callback1: Callback<number> = (displayId: number) => {
      hilog.info(DOMAIN, 'DisplayTest', `Listening enabled. displayId: ${displayId}`);
    };
    try {
      // 此处以监听显示设备的增加为例
      display.on("add", callback1);
      hilog.info(DOMAIN, 'DisplayTest', `register add success`);

      // 关闭单个callback监听
      display.off('add', callback1);
      hilog.info(DOMAIN, 'DisplayTest', `unregister add success`);
      // 如果通过on注册多个callback，同时关闭所有callback监听
      display.off("add");
      hilog.info(DOMAIN, 'DisplayTest', `unregister all add success`);
    } catch (exception) {
      hilog.error(DOMAIN, 'DisplayTest',
        `Failed to register/unregister callback. Code: ${exception.code}, message: ${exception.message}`);
    }
    // [End add_listen_callback]
    // [Start capture_listen_callback]
    let callback2: Callback<boolean> = (captureStatus: boolean) => {
      // captureStatus为true表示显示设备开始截屏、投屏或录屏，false表示结束截屏、投屏或录屏
      hilog.info(DOMAIN, 'DisplayTest', 'Listening capture status: ' + captureStatus);
    };

    try {
      // 开启屏幕截屏、投屏、录屏状态变化的监听
      display.on('captureStatusChange', callback2);
      hilog.info(DOMAIN, 'DisplayTest', `register captureStatusChange success`);
      // 关闭屏幕截屏、投屏、录屏状态变化的监听
      display.off('captureStatusChange', callback2);
      hilog.info(DOMAIN, 'DisplayTest', `unregister captureStatusChange success`);
    } catch (exception) {
      hilog.error(DOMAIN, 'DisplayTest',
        `Failed to register/unregister callback. Code: ${exception.code}, message: ${exception.message}`);
    }
    // [End capture_listen_callback]
    // [Start available_listen_callback]
    /**
     * 注册监听的callback参数要采用对象传递.
     * 若使用匿名函数注册，每次调用会创建一个新的底层对象，引起内存泄漏问题。
     */
    let callback3: Callback<display.Rect> = (data: display.Rect) => {
      hilog.info(DOMAIN, 'DisplayTest', 'Listening enabled. Data: ' + JSON.stringify(data));
    };
    let displayClass: display.Display | null = null;
    try {
      displayClass = display.getDefaultDisplaySync();
      // 开启当前屏幕可用区域变化的监听
      displayClass.on('availableAreaChange', callback3);
      hilog.info(DOMAIN, 'DisplayTest', `register availableAreaChange success`);
      // 关闭当前屏幕可用区域变化的监听
      displayClass.off('availableAreaChange', callback3);
      hilog.info(DOMAIN, 'DisplayTest', `unregister availableAreaChange success`);
    } catch (exception) {
      hilog.error(DOMAIN, 'DisplayTest',
        `Failed to register/unregister callback. Code: ${exception.code}, message: ${exception.message}`);
    }
    // [End available_listen_callback]
  }

  private dealFoldableDevice(): void {
    // [Start get_fold_device]
    let isFoldableDevice: boolean = false;
    try {
      isFoldableDevice = display.isFoldable();
      // 打印此设备是否为折叠设备
      hilog.info(DOMAIN, 'DisplayTest', `This device is foldable: ${isFoldableDevice}`);
    } catch (exception) {
      hilog.error(DOMAIN, 'DisplayTest',
        `Failed to get foldable message. Code: ${exception.code}, message: ${exception.message}`);
    }
    // [End get_fold_device]

    if (isFoldableDevice) {
      // [Start fold_device_listen]
      /**
       * 注册监听的callback参数要采用对象传递.
       * 若使用匿名函数注册，每次调用会创建一个新的底层对象，引起内存泄漏问题。
       */
      let callback: Callback<display.FoldStatus> = (data: display.FoldStatus) => {
        hilog.info(DOMAIN, 'DisplayTest', 'Listening enabled. Data: ' + JSON.stringify(data));
      };
      try {
        display.on('foldStatusChange', callback);
        // 如果通过on注册多个callback，同时关闭所有callback监听
        hilog.info(DOMAIN, 'DisplayTest', `register foldStatusChange success`);

        // 关闭单个callback监听
        display.off('foldStatusChange', callback);
        hilog.info(DOMAIN, 'DisplayTest', `unregister all foldStatusChange success`);
        // 关闭所有callback监听
        display.off('foldStatusChange');
        hilog.info(DOMAIN, 'DisplayTest', `unregister foldStatusChange success`);
      } catch (exception) {
        hilog.error(DOMAIN, 'DisplayTest',
          `Failed to register/unregister callback. Code: ${exception.code}, message: ${exception.message}`);
      }
      // [End fold_device_listen]
    }
  }

  build() {
    Column() {
      // 页面标题
      Text('DMS示例功能')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin(20)

      // 网格布局：2行3列（无图标，仅文字）
      Grid() {
        ForEach(this.buttonList, (item: GeneratedTypeLiteralInterface) => {
          GridItem() {
            Button() {
              Text(item.text)
                .fontSize(16)
                .textAlign(TextAlign.Center) // 文字居中
                .maxLines(2) // 最多显示2行（避免文字过长占太多空间）
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .padding({ left: 5, right: 5 }) // 文字左右留边距
                .fontColor('#ffffffff')
            } // 直接使用文字作为按钮内容
            .type(ButtonType.Capsule)
            .backgroundColor('#007DFF') // 直接指定颜色（无需资源文件）
            .fontSize(16)
            .width('90%')
            .height(80)
            .onClick(() => {
              item.action() // 触发对应功能
            })
          }
        })
      }
      .columnsTemplate('1fr 1fr') // 2列等宽
      .rowsTemplate('1fr 1fr 1fr') // 3行等高
      .columnsGap(15) // 列间距
      .rowsGap(10) // 行间距
      .padding(15)
      .flexGrow(1) // 占满剩余空间
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5') // 背景色
  }
}