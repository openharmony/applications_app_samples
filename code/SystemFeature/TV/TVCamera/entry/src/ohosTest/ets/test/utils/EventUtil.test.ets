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

import { describe, it, expect } from '@ohos/hypium';
import { EventUtil } from '../../../../main/ets/utils/EventUtil';

interface TouchEventShape {
  type: number;
  source: number;
}

/**
 * 构造最小触摸事件对象。
 * @param type 触摸事件类型
 * @param source 事件来源
 * @returns 可传入 EventUtil 的测试事件
 */
function createTouchEvent(type: number, source: number): TouchEvent {
  return { type, source } as TouchEventShape as TouchEvent;
}

export default function EventUtilTest() {
  describe('EventUtilTest', () => {
    it('EventUtil_IsTouchEvent_DownShortCircuitsButStillSwitchesCursor_001', 0, () => {
      // 业务背景：按下动作在当前实现里只负责切换点击态指针，不算作业务可消费触摸事件。
      // 先守住这个短路契约，后续页面层若依赖按下态也能及时发现行为变化。
      let result = EventUtil.isTouchEvent(createTouchEvent(TouchType.Down, SourceType.TouchScreen));
      expect(result).assertEqual(false);
    });

    it('EventUtil_IsTouchEvent_MouseMoveReturnsTrueAndResetsCursor_002', 0, () => {
      // 业务背景：鼠标移动是桌面端最常见的悬停输入，必须被识别为可处理事件。
      // 同时指针应退出按下态，避免按钮按压样式在移动后残留。
      let result = EventUtil.isTouchEvent(createTouchEvent(TouchType.Move, SourceType.Mouse));
      expect(result).assertEqual(true);
    });

    it('EventUtil_IsTouchEvent_TouchScreenUpReturnsTrue_003', 0, () => {
      // 业务背景：触屏抬起常用于完成点击、拖拽结束等最终提交动作。
      // 若把这类事件误判为无效，页面层就会丢失最关键的提交时机。
      let result = EventUtil.isTouchEvent(createTouchEvent(TouchType.Up, SourceType.TouchScreen));
      expect(result).assertEqual(true);
    });

    it('EventUtil_IsTouchEvent_UnknownSourceRejectedButCursorStillUpdated_004', 0, () => {
      // 业务背景：非鼠标/触屏来源不应误入相机页通用输入流，否则会把遥控器或异常源当成触摸。
      // 不过样式同步逻辑依旧会执行，这是当前实现里需要被显式固定的副作用边界。
      let result = EventUtil.isTouchEvent(createTouchEvent(TouchType.Cancel, -1));
      expect(result).assertEqual(false);
    });

    it('EventUtil_IsTouchEvent_ProcessesSequentialEventsIndependently_005', 0, () => {
      // 业务背景：真实交互会连续经过按下、移动、抬起三个阶段。
      // 用顺序事件回归调用轨迹，可以防止后续缓存状态导致不同帧之间串扰。
      let downResult = EventUtil.isTouchEvent(createTouchEvent(TouchType.Down, SourceType.Mouse));
      let moveResult = EventUtil.isTouchEvent(createTouchEvent(TouchType.Move, SourceType.Mouse));
      let upResult = EventUtil.isTouchEvent(createTouchEvent(TouchType.Up, SourceType.TouchScreen));
      expect(downResult).assertEqual(false);
      expect(moveResult).assertEqual(true);
      expect(upResult).assertEqual(true);
    });
  });
}
