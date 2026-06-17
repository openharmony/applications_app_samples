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

// [Start smartgesture_case4]
import {
  BaseGestureHandlingProposal,
  ClickActionProposal,
  GestureHandlingResolution,
  PageSwitchActionProposal,
  SelectActionProposal,
  TargetedGestureProposal,
} from '@kit.ArkUI';

@Entry
@Component
struct Demo4 {
  // 获取智慧手势控制器实例，用于启停手势、注册监听、控制选中态
  private controller = this.getUIContext().getSmartGestureController();
  @State hint: string = 'Demo4: Swiper + Button\n划一划翻页 → 敲一敲触发按钮点击';
  @State page0Btn: number = 0; // 首页按钮点击计数
  @State page1Btn: number = 0; // 设置页按钮点击计数
  @State page2Btn: number = 0; // 关于页按钮点击计数
  @State swiperIndex: number = 0; // 当前Swiper页面索引

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
    // 划一划手势意图，需翻页切换Swiper页面，步长为1表示翻到下一页
    } else if (proposal.action === SmartGestureAction.PAGE_FORWARD) {
      // PageSwitchActionProposal的目标节点为Swiper容器而非按钮，此处通过容器id获取Swiper的FrameNode
      const node = this.getUIContext().getFrameNodeById('demo_swiper');
      if (node) {
        // 构造翻页动作提案，指定Swiper节点和翻页步长(1表示向前翻一页)
        resolution.selectedProposal = new PageSwitchActionProposal(node, 1);
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
    Column({ space: 12 }) {
      Text('Demo4: Swiper + Button')
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

      Swiper() {
        Column({ space: 16 }) {
          Text('第0页 - 首页')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Button(`首页按钮 / 点击=${this.page0Btn}`)
            .id('page0_btn')
            .width('80%')
            .backgroundColor('#4caf50')
            // 标记组件为智慧手势目标：action指定手势动作类型，enabled控制是否响应，selectable控制是否可被选中
            .smartGestureShortcut({ action: GestureShortcut.PRIMARY, enabled: true, selectable: true })
            .onClick(() => {
              this.page0Btn += 1;
              this.hint = `第0页按钮 onClick → 点击=${this.page0Btn}`;
            })
          Text('划一划 → 翻到下一页')
            .fontSize(13)
            .fontColor('#888')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#e3f2fd')

        Column({ space: 16 }) {
          Text('第1页 - 设置')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Button(`设置按钮 / 点击=${this.page1Btn}`)
            .id('page1_btn')
            .width('80%')
            .backgroundColor('#ff9800')
            // 标记组件为智慧手势目标
            .smartGestureShortcut({ action: GestureShortcut.PRIMARY, enabled: true, selectable: true })
            .onClick(() => {
              this.page1Btn += 1;
              this.hint = `第1页按钮 onClick → 点击=${this.page1Btn}`;
            })
          Text('划一划 → 翻到下一页')
            .fontSize(13)
            .fontColor('#888')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#fce4ec')

        Column({ space: 16 }) {
          Text('第2页 - 关于')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Button(`关于按钮 / 点击=${this.page2Btn}`)
            .id('page2_btn')
            .width('80%')
            .backgroundColor('#2196f3')
            // 标记组件为智慧手势目标
            .smartGestureShortcut({ action: GestureShortcut.PRIMARY, enabled: true, selectable: true })
            .onClick(() => {
              this.page2Btn += 1;
              this.hint = `第2页按钮 onClick → 点击=${this.page2Btn}`;
            })
          Text('划一划 → 翻到下一页')
            .fontSize(13)
            .fontColor('#888')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#e8f5e9')
      }
      .id('demo_swiper')
      .width('100%')
      .layoutWeight(1)
      .loop(false)
      .index(0)
      .onChange((index: number) => {
        this.swiperIndex = index;
        this.hint = `Swiper onChange → 第${index}页`;
      })
      .borderRadius(12)
      .borderWidth(1)
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#f1f3f5')
  }
}
// [End smartgesture_case4]