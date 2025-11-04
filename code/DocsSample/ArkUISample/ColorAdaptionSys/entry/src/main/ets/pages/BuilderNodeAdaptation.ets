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

import { NodeController, BuilderNode, FrameNode, UIContext, FrameCallback } from '@kit.ArkUI';
import { AbilityConstant, Configuration, ConfigurationConstant, EnvironmentCallback } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';

const TAG = '[Sample_ColorAdaption_Sys]';
const DOMAIN = 0xFF00;

class Params {
  public text: string = '';

  constructor(text: string) {
    this.text = text;
  }
}

// 自定义组件
@Component
struct TextBuilder {
  // 作为自定义组件中需要更新的属性，数据类型为基础属性，定义为@Prop
  @Prop message: string = 'TextBuilder';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 36 })
      }
    }
  }
}

@Builder
function buildText(params: Params) {
  Column() {
    Text(params.text)
      .fontSize(50)
      .fontWeight(FontWeight.Bold)
      .margin({ bottom: 36 })
    TextBuilder({ message: params.text }) // 自定义组件
  }.backgroundColor($r('sys.color.ohos_id_color_background'))
}

// 继承NodeController实现自定义textNode控制器
class TextNodeController extends NodeController {
  private textNode: BuilderNode<[Params]> | null = null;
  private message: string = '';

  constructor(message: string) {
    super();
    this.message = message;
  }

  makeNode(context: UIContext): FrameNode | null {
    return this.textNode?.getFrameNode() ? this.textNode?.getFrameNode() : null;
  }

  createNode(context: UIContext) {
    this.textNode = new BuilderNode(context);
    this.textNode.build(wrapBuilder<[Params]>(buildText), new Params(this.message));
    builderNodeMap.push(this.textNode);
  }

  deleteNode() {
    let node = builderNodeMap.pop();
    node?.dispose();
  }

  update(message: string) {
    if (this.textNode !== null) {
      // 调用update进行更新
      this.textNode.update(new Params(message));
    }
  }
}

// [Start custom_node]
// 记录创建的自定义节点对象
const builderNodeMap: BuilderNode<[Params]>[] = [];

class MyFrameCallback extends FrameCallback {
  onFrame() {
    updateColorMode();
  }
}

function updateColorMode() {
  builderNodeMap.forEach((value, index) => {
    // 通知BuilderNode环境变量改变，触发深浅色切换
    value.updateConfiguration();
  })
}
// [StartExclude custom_node]
@Entry
@Component
struct Index {
  @State message: string = 'hello';
  @State colorText: string = 'light';
  private textNodeController: TextNodeController = new TextNodeController(this.message);
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentMode: number =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
// [EndExclude custom_node]
  aboutToAppear(): void {
    // [StartExclude custom_node]
    let environmentCallback: EnvironmentCallback = {
      onMemoryLevel: (level: AbilityConstant.MemoryLevel): void => {
        hilog.info(DOMAIN, TAG, 'onMemoryLevel');
      },
      onConfigurationUpdated: (config: Configuration): void => {
        hilog.info(DOMAIN, TAG, 'onConfigurationUpdated ' + JSON.stringify(config));
    // [EndExclude custom_node]
        this.getUIContext()?.postFrameCallback(new MyFrameCallback());
    // [StartExclude custom_node]
      }
    };
    // 注册监听回调
    this.getUIContext().getHostContext()?.getApplicationContext().on('environment', environmentCallback);
    // 设置应用深浅色跟随系统
    this.getUIContext()
      .getHostContext()?.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    // 创建自定义节点并添加至map
    this.textNodeController.createNode(this.getUIContext());
    // [EndExclude custom_node]
  }
// [End custom_node]
  onColorModeChange(): void {
    if (this.currentMode == ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      // 当前为浅色模式，资源初始化逻辑
      this.colorText = 'light';
    } else {
      // 当前为深色模式，资源初始化逻辑
      this.colorText = 'dark';
    }
  }

  aboutToDisappear(): void {
    // 移除map中的引用，并将自定义节点释放
    this.textNodeController.deleteNode();
  }

  build() {
    Row() {
      Column() {
        NodeContainer(this.textNodeController)
          .width('100%')
          .height(200)
          .backgroundColor('#FFF0F0F0')
        Button('Switch to Dark Mode')
          .onClick(() => {
            this.getUIContext()
              .getHostContext()?.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
          })
        Button('Switch to Light Mode')
          .onClick(() => {
            this.getUIContext()
              .getHostContext()?.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
          })
        Button('Switch to Color Not Set')
          .onClick(() => {
            this.getUIContext()
              .getHostContext()?.getApplicationContext()
              .setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
          })
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
  }
}