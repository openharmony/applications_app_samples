/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import { PromptAction, UIContext } from '@kit.ArkUI';
import displayNapi from 'libnativedisplay.so';

interface GeneratedTypeLiteralInterface {
  text: string;
  action: () => void;
}

@Entry
@Component
struct Index {
  uiContext: UIContext = this.getUIContext();
  promptAction: PromptAction = this.uiContext.getPromptAction();

  private buttonList: Array<GeneratedTypeLiteralInterface> = [
    {
      text: '获取屏幕Rotation属性',
      action: () => this.callGetDisplayRotation()
    },
    {
      text: '获取挖孔信息',
      action: () => this.callGetCutoutInfo()
    },
    {
      text: '测试Display监听机制',
      action: () => this.callDealListenCallback()
    },
    {
      text: '折叠设备判断',
      action: () => this.callDealFoldableDevice()
    },
    {
      text: '测试折叠状态监听',
      action: () => this.callFoldableCallback()
    }
  ]

  // [Start call_display_function]
  private callGetDisplayRotation(): void {
    this.promptAction.openToast({ message: '调用getDisplayRotation方法' }).catch((error: Error) => {
      console.error(`callGetDisplayRotation error ${JSON.stringify(error)}`);
    }).then(() => {
      console.info(`get rotation value is: ${displayNapi.getDisplayRotation()}`);
    });
  }

  private callFoldableCallback(): void {
    this.promptAction.openToast({ message: '调用register displayMode方法' }).catch((error: Error) => {
      console.error(`callFoldableCallback error ${JSON.stringify(error)}`);
    }).then(() => {
      let registerIndex = displayNapi.registerFoldDisplayModeChange();
      console.info(`register foldable value is: ${registerIndex}`);
      console.info(`unregister foldable value is: ${displayNapi.unregisterFoldDisplayModeChange(registerIndex)}`);
    });
  }

  private callGetCutoutInfo(): void {
    this.promptAction.openToast({ message: '调用getCutoutInfo方法' }).catch((error: Error) => {
      console.error(`callGetCutoutInfo error ${JSON.stringify(error)}`);
    }).then(() => {
      console.info(`cutoutInfo length is: ${displayNapi.getCutoutInfo()}`);
    });
  }

  private callDealListenCallback(): void {
    this.promptAction.openToast({ message: '调用register change方法' }).catch((error: Error) => {
      console.error(`callDealListenCallback error ${JSON.stringify(error)}`);
    }).then(() => {
      let registerIndex = displayNapi.registerDisplayChange();
      console.info(`register display change value is: ${registerIndex}`);
      console.info(`unregister display change value is: ${displayNapi.unregisterDisplayChange(registerIndex)}`);
    });
  }

  private callDealFoldableDevice(): void {
    this.promptAction.openToast({ message: '调用dealFoldableDevice方法' }).catch((error: Error) => {
      console.error(`callDealFoldableDevice error ${JSON.stringify(error)}`);
    }).then(() => {
      console.info(`fold device is: ${displayNapi.checkIsFoldDevice()}`);
    });
  }
  // [End call_display_function]

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
