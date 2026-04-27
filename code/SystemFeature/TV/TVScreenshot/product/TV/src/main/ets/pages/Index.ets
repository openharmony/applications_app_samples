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
import Log from '../common/Log';
import Constants from '../common/Constants';
import viewModel from '../vm/ViewModel';
import { sizeCalc } from '../common/SizeCalc';

const TAG = 'ScreenShot-Index';

/**
 * Index 页面是截屏预览的核心展示容器。
 * 它负责承载截屏图片的实时预览效果。
 * 这种全屏堆叠（Stack）布局设计，能够最大化展示截屏内容，提供沉浸式的用户体验。
 */
@Entry
@Component
struct Index {
  // 使用 StorageLink 实现双向状态同步，当 captureImage 变化时自动刷新 UI。
  @StorageLink('captureImage') captureImage: string = '';

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        // 使用 Image 组件展示截屏数据，并配置平滑的淡入淡出动画。
        Image(this.captureImage)
          .borderRadius(sizeCalc(32))
          .transition(TransitionEffect.OPACITY.animation({ duration: 400, curve: Curve.Ease }))
      }
      .width(Constants.FULL_CONTAINER_WIDTH)
      .height(Constants.FULL_CONTAINER_HEIGHT)
      .borderRadius(sizeCalc(32))
    }
    .padding(sizeCalc(4))
    .width(Constants.FULL_CONTAINER_WIDTH)
    .height(Constants.FULL_CONTAINER_HEIGHT)
    .backgroundColor("#FFFFFFFF")
    .borderRadius(sizeCalc(36))
  }

  /**
   * 页面挂载后的自动生命周期管理。
   * 业务背景：预览窗口不应一直驻留，需在指定时间后自动进入保存和关闭流程。
   * 原理：利用定时器在 Constants.interval 时间后触发 ViewModel 的关闭逻辑，
   * 这种自动化的闭环设计极大地降低了用户的交互成本。
   */
  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear');
    setTimeout(viewModel.CloseShotScreen, Constants.interval);
  }
}
