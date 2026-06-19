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

// [Start smartgesture_case3]
import {
  BaseGestureHandlingProposal,
  ClickActionProposal,
  GestureHandlingResolution,
  SelectActionProposal,
  TargetedGestureProposal,
} from '@kit.ArkUI';

@Entry
@Component
struct Demo3 {
  // 获取智慧手势控制器实例，用于启停手势、注册监听、控制选中态
  private controller = this.getUIContext().getSmartGestureController();
  @State hint: string = 'Demo3: 单页面+多组件\n划一划切换选中组件 → 敲一敲触发点击';
  @State btnCount: number = 0; // 按钮点击计数
  @State textClickCount: number = 0; // 文本点击计数
  @State toggleOn: boolean = false; // Toggle开关状态
  @State sliderVal: number = 30; // Slider滑块值

  // Monitor回调接收BaseGestureHandlingProposal参数，根据手势动作类型动态决策处理方案
  // BaseGestureHandlingProposal是基类，包含action(动作类型)和operateIntention(操作意图)
  // TargetedGestureProposal是子类，额外携带node属性指向目标组件节点，构造ActionProposal时需要该节点
  private callback = (proposal: BaseGestureHandlingProposal): GestureHandlingResolution => {
    // 将BaseGestureHandlingProposal转为TargetedGestureProposal，以获取目标组件节点信息
    let targetProposal = proposal as TargetedGestureProposal;
    // 获取目标组件的id标识，用于后续通过id查找FrameNode
    let nodeId = targetProposal.node ? targetProposal.node.getId() : '';
    this.hint = `意图=${proposal.operateIntention}, 动作=${proposal.action}, 目标=${nodeId}`;
    // 构造手势处理结果，参数true表示消费本次手势，后续回调不再执行
    const resolution = new GestureHandlingResolution(true);

    // 敲一敲手势意图，需执行点击操作
    if (proposal.action === SmartGestureAction.CLICK) {
      if (nodeId) {
        // 通过组件id获取对应的FrameNode，用于构造点击动作提案
        const node = this.getUIContext().getFrameNodeById(nodeId);
        if (node) {
          // 构造点击动作提案，指定目标节点执行点击
          resolution.selectedProposal = new ClickActionProposal(node);
        }
      }
    // 划一划手势意图，需切换选中组件
    } else if (proposal.action === SmartGestureAction.SELECT) {
      if (nodeId) {
        const node = this.getUIContext().getFrameNodeById(nodeId);
        if (node) {
          // 构造选中动作提案，指定目标节点切换选中态
          resolution.selectedProposal = new SelectActionProposal(node);
        }
      }
    }

    return resolution;
  };

  aboutToAppear(): void {
    // 开启敲一敲和划一划智慧手势识别
    this.controller.enableSmartTapAndSlideGestures(true);
    // 注册Monitor监听回调，回调按后注册先执行的顺序触发
    this.controller.registerMonitor(this.callback);
  }

  aboutToDisappear(): void {
    // 清空所有已注册的Monitor回调
    this.controller.clearMonitors();
    // 关闭智慧手势识别，组件侧smartGestureShortcut配置仍保留但不响应
    this.controller.enableSmartTapAndSlideGestures(false);
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text('Demo3: 单页面 + 多组件')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Center)

        Text(this.hint)
          .fontSize(13)
          .fontColor('#666')
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(8)
          .borderRadius(8)
          .backgroundColor('#e8e8e8')

        Text('可点击文本')
          .id('comp_text')
          .fontSize(18)
          .width('100%')
          .padding(16)
          .borderRadius(10)
          .borderWidth(1)
          .textAlign(TextAlign.Center)
          .backgroundColor('#e3f2fd')
          // 标记组件为智慧手势目标：action指定手势动作类型，enabled控制是否响应，selectable控制是否可被选中
          .smartGestureShortcut({ action: GestureShortcut.PRIMARY, enabled: true, selectable: true })
          .onClick(() => {
            this.textClickCount += 1;
            this.hint = `文本 onClick 触发, 点击=${this.textClickCount}`;
          })

        Row() {
          Text(`文本点击次数: ${this.textClickCount}`)
            .fontSize(14)
            .fontColor('#555')
        }.width('100%').justifyContent(FlexAlign.Center)

        Button(`按钮 / 点击=${this.btnCount}`)
          .id('comp_button')
          .width('100%')
          .backgroundColor('#1976d2')
          // 标记组件为智慧手势目标
          .smartGestureShortcut({ action: GestureShortcut.PRIMARY, enabled: true, selectable: true })
          .onClick(() => {
            this.btnCount += 1;
            this.hint = `按钮 onClick 触发, 点击=${this.btnCount}`;
          })

        Row() {
          Toggle({ type: ToggleType.Switch, isOn: this.toggleOn })
            .id('comp_toggle')
            .selectedColor('#4caf50')
            // 标记Toggle为智慧手势目标，敲一敲可触发onChange切换开关状态
            .smartGestureShortcut({ action: GestureShortcut.PRIMARY, enabled: true, selectable: true })
            .onChange((isOn: boolean) => {
              this.toggleOn = isOn;
              this.hint = `Toggle onChange → ${isOn ? '开' : '关'}`;
            })
          Text(`开关状态: ${this.toggleOn ? '开' : '关'}`)
            .fontSize(14)
            .margin({ left: 12 })
        }
        .width('100%')
        .padding(12)
        .borderRadius(10)
        .borderWidth(1)
        .justifyContent(FlexAlign.Start)

        // 通过requestSelected手动请求选中指定组件，组件需满足可见、可响应智慧手势、绑定onClick三个条件
        Row({ space: 8 }) {
          Button('选中按钮').layoutWeight(1)
            .onClick(() => this.controller.requestSelected('comp_button'))
          Button('选中文本').layoutWeight(1)
            .onClick(() => this.controller.requestSelected('comp_text'))
          Button('选中开关').layoutWeight(1)
            .onClick(() => this.controller.requestSelected('comp_toggle'))
        }.width('100%')

        // 通过clearSelected清空当前选中态
        Button('清空选中')
          .width('100%')
          .onClick(() => {
            this.controller.clearSelected();
            this.hint = '选中已清空';
          })
      }
      .width('100%')
      .padding(16)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f3f5')
  }
}
// [End smartgesture_case3]