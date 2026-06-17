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

// [Start smartgesture_case1]
// [Start smartgesture_case1_proposal]
import {
  BaseGestureHandlingProposal,
  ClickActionProposal,
  GestureHandlingResolution,
  ScrollActionProposal,
  SelectActionProposal,
  TargetedGestureProposal,
} from '@kit.ArkUI';
// [StartExclude smartgesture_case1_proposal]

@Entry
@Component
struct Demo1 {
  // [Start smartgesture_case1_controller]
  // 获取智慧手势控制器实例，用于启停手势、注册监听、控制选中态
  private controller = this.getUIContext().getSmartGestureController();
  // [StartExclude smartgesture_case1_controller]
  @State hint: string = 'Demo1: 长页面Scroll + Button\n划一划滚动至按钮区域 → 划一划切换选中按钮 → 敲一敲触发点击';
  @State btn0Count: number = 0; // 按钮A点击计数
  @State btn1Count: number = 0; // 按钮B点击计数
  @State btn2Count: number = 0; // 按钮C点击计数
  @State btn3Count: number = 0; // 按钮D点击计数

  // [EndExclude smartgesture_case1_proposal]
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
    // 划一划手势意图，需滚动容器内容，滚动距离200px
    } else if (proposal.action === SmartGestureAction.SCROLL_FORWARD) {
      // ScrollActionProposal的目标节点为滚动容器而非按钮，此处通过容器id获取Scroll的FrameNode
      const node = this.getUIContext().getFrameNodeById('long_scroll');
      if (node) {
        // 构造滚动动作提案，指定目标容器节点和滚动距离(200px)
        resolution.selectedProposal = new ScrollActionProposal(node, 200);
      }
    }

    return resolution;
  };
  // [End smartgesture_case1_proposal]

  // [EndExclude smartgesture_case1_controller]
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
  // [End smartgesture_case1_controller]

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text('Demo1: 长页面Scroll + Button')
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

        ForEach([0, 1, 2, 3, 4, 5, 6], (item: number) => {
          Column() {
            Text()
              .fontSize(15)
              .width('100%')
              .padding(16)
              .borderRadius(8)
              .backgroundColor('#f0f4f8')
          }
        })

        Text('按钮操作区域 (下方)')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Center)
          .margin({ top: 8 })

        // [Start smartgesture_case1_button]
        Button(`按钮A / 点击=${this.btn0Count}`)
          .id('btn_a')
          .width('100%')
          // 标记组件为智慧手势目标：action指定手势动作类型，enabled控制是否响应，selectable控制是否可被选中
          .smartGestureShortcut({ action: GestureShortcut.PRIMARY, enabled: true, selectable: true })
          .onClick(() => {
            this.btn0Count += 1;
            this.hint = '按钮A onClick 触发';
          })
        // [End smartgesture_case1_button]

        Button(`按钮B / 点击=${this.btn1Count}`)
          .id('btn_b')
          .width('100%')
          .smartGestureShortcut({ action: GestureShortcut.PRIMARY, enabled: true, selectable: true })
          .onClick(() => {
            this.btn1Count += 1;
            this.hint = '按钮B onClick 触发';
          })

        Button(`按钮C / 点击=${this.btn2Count}`)
          .id('btn_c')
          .width('100%')
          .smartGestureShortcut({ action: GestureShortcut.PRIMARY, enabled: true, selectable: true })
          .onClick(() => {
            this.btn2Count += 1;
            this.hint = '按钮C onClick 触发';
          })

        Button(`按钮D / 点击=${this.btn3Count}`)
          .id('btn_d')
          .width('100%')
          .smartGestureShortcut({ action: GestureShortcut.PRIMARY, enabled: true, selectable: true })
          .onClick(() => {
            this.btn3Count += 1;
            this.hint = '按钮D onClick 触发';
          })
      }
      .width('100%')
      .padding(16)
    }
    .id('long_scroll')
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f3f5')
  }
}
// [End smartgesture_case1]