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

import { GridSceneView } from '../view/GridSceneView';
import { ListSceneView } from '../view/ListSceneView';

/**
 * 功能描述: 本示例使用position绝对定位实现应用内悬浮窗，并且通过animateTo结合curves动画曲线实现悬浮窗拖拽跟手和松手吸附边缘的弹性动画效果
 *
 * 推荐场景: 悬浮窗显示场景
 *
 * 核心组件:
 * 1. FloatWindowView
 *
 * 实现步骤：
 *  1. 悬浮窗组件使用Stack嵌套video布局，使用属性position绝对定位使组件悬浮，position使用Edges类型控制悬浮窗到父组件四条边的距离
 *  2. 初始化时悬浮窗的position属性设置top和right，让悬浮窗靠右
 *  3. 父组件添加onAreaChange回调，获取父组件的宽高
 *  4. 悬浮窗组件添加onTouchEvent回调，在手指按下时保存触摸点在窗口中的坐标，用于移动时悬浮窗位置的计算
 *  5. 手指移动时，获取触摸点相对于应用窗口左上角的X和Y坐标，通过计算设置悬浮窗的position坐标实现拖拽，
 *     使用默认参数的弹性跟手动画曲线curves.responsiveSpringMotion结合animateTo实现跟手动画效果。
 *  6. 手指抬起时，通过判断悬浮窗中心在水平方向位于父组件中心的左侧或右侧设置悬浮窗靠左或靠右，如果悬浮窗超出内容区上下边界，
 *     则将悬浮窗设置在边界位置，使用curves.springMotion弹性动画曲线实现吸附边界时的弹性动画效果。
 */
@Component
export struct Launcher {
  build() {
    Column() {
      GridSceneView() // 实现Grid拖拽场景
      ListSceneView() // 实现List拖拽场景
    }
    .width($r('app.string.drag_and_exchange_layout_100_percent'))
    .height($r('app.string.drag_and_exchange_layout_100_percent'))
    .justifyContent(FlexAlign.Center)
    .backgroundImage($r('app.media.drag_and_exchange_wallpaper_default'))
    .backgroundImageSize(ImageSize.Cover)
  }
}
