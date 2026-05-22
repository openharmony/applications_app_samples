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

import { globalIdle } from '../utils/GlobalScreenSaver';


@Entry
@Component
struct ScreenSaver {
  // 轮播图片列表（对应media目录下的图片）
  private screensaverImages: ResourceStr[] = [
    $r('app.media.ChildCare'),
    $r('app.media.SmartScreensaver'),
    $r('app.media.UniversalInterconnection')
  ];
  // 轮播自动切换间隔（单位：ms，建议≥3秒）
  private carouselInterval: number = 5000;

  build() {
    Swiper() {
      ForEach(this.screensaverImages, (imgPath: ResourceStr) => {
        // 单个轮播项：图片全屏铺满
        Image(imgPath)
          .width('100%')
          .height('100%')
          .focusable(true)
          .defaultFocus(true)
          .stateStyles({
            focused: {
              .border({
                color: Color.Transparent
              })
            }
          })
          .onHover(() => {
            this.exitSaver();
          })
          .onTouch((e: TouchEvent) => {
            this.exitSaver();
          })
          // 任意按键退出屏保（拦截系统按键）
          .onKeyEvent((e: KeyEvent) => {
            setTimeout(() => {
              if (e.type == KeyType.Down) {
                this.exitSaver()
              }
            }, 500)
            return true
          })
      })
    }
    .width('100%')
    .height('100%')
    .autoPlay(true) // 自动播放
    .interval(this.carouselInterval) // 5秒切换一张
    .loop(true) // 无限循环
    .indicator(false) // 隐藏轮播指示器（屏保无需显示）
    .curve(Curve.EaseInOut) // 切换动画线性过渡（更流畅）
  }

  // 退出屏保核心逻辑：返回原页面 + 重置检测器
  exitSaver() {
    // 重置全局闲置检测器状态
    globalIdle.resetScreensaver();
    // 精准返回触发屏保的原页面
    const triggerUrl = globalIdle.getTriggerPage();
    if (triggerUrl) {
      this.getUIContext().getRouter().back({ url: triggerUrl }); // 按URL返回，避免多级返回错误
    } else {
      this.getUIContext().getRouter().back(); // 兜底返回上一页
    }
  }
}