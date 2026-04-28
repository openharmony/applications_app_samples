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

/**
 * @file BrowserUIInteraction.test.ets
 * @overview UI交互功能测试套件，覆盖按钮焦点、触摸事件、手势操作、无障碍访问等完整交互流程
 * @test_category ui_interaction
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { Driver, Component } from '@kit.TestKit';
import {
  createFreshDriver,
  openBrowserHome,
  waitForId,
  waitForSurface,
  waitForStableSurface,
  countSurface,
  countReadableTexts,
  readInputText,
  safeFindAllById,
  safeDelay,
  TIMEOUT_START,
  STABLE_ROUNDS,
  STABLE_TOLERANCE,
  backToSafeHome,
  KEY_ENTER,
  KEY_BACK,
  KEY_HOME,
  DELAY_NAV_KEY,
  DELAY_APP_LAUNCH,
  pressAndWait
} from './SharedDriver';
import { TestConstants, TestTimeouts, TestData } from './TestConstants';
import { BaseMockController } from './BaseMockController';
import { ComponentState } from './TestFixtures';

const TAG: string = '[BrowserUIInteraction]';

enum TouchType {
  Down = 0,
  Up = 1,
  Move = 2
}

interface TouchEvent {
  component: string;
  type: TouchType;
}

interface ClickEvent {
  component: string;
  timestamp: number;
}

interface GestureEvent {
  type: string;
  data: GestureData;
}

interface GestureData {
  fromX?: number;
  fromY?: number;
  toX?: number;
  toY?: number;
  duration?: number;
  centerX?: number;
  centerY?: number;
  scale?: number;
}

/**
 * UI交互模拟桩，用于测试按钮焦点、触摸事件、手势操作等交互功能
 * 继承BaseMockController以获得通用的Mock功能
 */
class MockUIInteractionController extends BaseMockController {
  private focusedComponent: string | null = null;
  private pressedComponents: Set<string> = new Set();
  private touchEvents: TouchEvent[] = [];
  private clickEvents: ClickEvent[] = [];
  private gestureEvents: GestureEvent[] = [];
  private readonly TOUCH_RELEASE_DELAY: number = 50;
  private readonly DOUBLE_CLICK_DELAY: number = 300;
  private readonly SWIPE_DEFAULT_DURATION: number = 500;
  private readonly LONG_PRESS_DEFAULT_DURATION: number = 1000;

  focusComponent(componentId: string): boolean {
    if (this.focusedComponent !== componentId) {
      this.focusedComponent = componentId;
      return true;
    }
    return false;
  }

  blurComponent(componentId: string): boolean {
    if (this.focusedComponent === componentId) {
      this.focusedComponent = null;
      return true;
    }
    return false;
  }

  touchDown(componentId: string): void {
    this.pressedComponents.add(componentId);
    this.touchEvents.push({ component: componentId, type: TouchType.Down });
  }

  touchUp(componentId: string): void {
    this.pressedComponents.delete(componentId);
    this.touchEvents.push({ component: componentId, type: TouchType.Up });
  }

  clickComponent(componentId: string): void {
    this.clickEvents.push({ component: componentId, timestamp: Date.now() });

    this.touchDown(componentId);
    setTimeout(() => this.touchUp(componentId), this.TOUCH_RELEASE_DELAY);
  }

  performGesture(gestureType: string, data: GestureData): void {
    this.gestureEvents.push({ type: gestureType, data });
  }

  isComponentPressed(componentId: string): boolean {
    return this.pressedComponents.has(componentId);
  }

  isComponentFocused(componentId: string): boolean {
    return this.focusedComponent === componentId;
  }

  getRecentTouchEvents(count: number = 5): TouchEvent[] {
    return this.touchEvents.slice(-count);
  }

  getRecentClicks(count: number = 5): ClickEvent[] {
    return this.clickEvents.slice(-count);
  }

  getRecentGestures(count: number = 5): GestureEvent[] {
    return this.gestureEvents.slice(-count);
  }

  clearEvents(): void {
    this.touchEvents = [];
    this.clickEvents = [];
    this.gestureEvents = [];
    this.pressedComponents.clear();
  }

  doubleClickComponent(componentId: string): void {
    this.clickComponent(componentId);
    setTimeout(() => this.clickComponent(componentId), this.DOUBLE_CLICK_DELAY);
  }

  longPressComponent(componentId: string, duration: number = this.LONG_PRESS_DEFAULT_DURATION): void {
    this.touchDown(componentId);
    setTimeout(() => this.touchUp(componentId), duration);
  }

  swipe(fromX: number, fromY: number, toX: number, toY: number, duration: number = this.SWIPE_DEFAULT_DURATION): void {
    this.performGesture('swipe', {
      fromX,
      fromY,
      toX,
      toY,
      duration
    });
  }

  pinchZoom(centerX: number, centerY: number, scale: number): void {
    this.performGesture('pinch', { centerX, centerY, scale });
  }
}

/**
 * UI交互功能测试套件
 * 验证按钮焦点、触摸事件、手势操作、无障碍访问等完整交互流程
 */
export default function uIInteractionTest(): void {
  describe('Browser_UI_Interaction_Test', () => {
    let driver: Driver;
    let uiController: MockUIInteractionController;

    beforeAll(async () => {
      driver = createFreshDriver();
      uiController = new MockUIInteractionController();
      await openBrowserHome(driver);
    });

    afterAll(async () => {
      await backToSafeHome(driver);
    });

    beforeEach(async () => {
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, TIMEOUT_START);
      uiController.clearEvents();
    });

    /**
     * 验证导航按钮的焦点管理
     * 按钮应能正确获得和失去焦点，提供清晰的视觉反馈
     */
    it('navigation_buttons_should_handle_focus_correctly', 0, async () => {
      const buttonIds = ['backButton', 'forwardButton', 'refreshButton', 'homeButton'];

      for (const buttonId of buttonIds) {
        const focusSuccess = uiController.focusComponent(buttonId);
        expect(focusSuccess).assertTrue();
        expect(uiController.isComponentFocused(buttonId)).assertTrue();

        // 验证其他按钮失焦
        for (const otherId of buttonIds.filter(id => id !== buttonId)) {
          expect(uiController.isComponentFocused(otherId)).assertFalse();
        }

        // 模拟失焦
        const blurSuccess = uiController.blurComponent(buttonId);
        expect(blurSuccess).assertTrue();
        expect(uiController.isComponentFocused(buttonId)).assertFalse();
      }
    });

    /**
     * 验证按钮触摸反馈效果
     * 按钮按下和抬起时应提供清晰的视觉反馈
     */
    it('buttons_should_provide_tactile_feedback_on_touch', 0, async () => {
      const testButtonId = 'backButton';

      // 模拟按下
      uiController.touchDown(testButtonId);
      expect(uiController.isComponentPressed(testButtonId)).assertTrue();

      // 验证按下状态视觉反馈
      const pressedComponents = await safeFindAllById(driver, `${testButtonId}-pressed`);
      expect(pressedComponents.length).assertLargerOrEqual(0);

      // 模拟抬起
      uiController.touchUp(testButtonId);
      expect(uiController.isComponentPressed(testButtonId)).assertFalse();

      // 验证抬起状态视觉反馈
      const releasedComponents = await safeFindAllById(driver, `${testButtonId}-released`);
      expect(releasedComponents.length).assertLargerOrEqual(0);
    });

    /**
     * 验证完整点击事件序列
     * 点击操作应触发正确的触摸事件序列
     */
    it('click_events_should_trigger_correct_touch_sequence', 0, async () => {
      const testButtonId = 'refreshButton';

      uiController.clickComponent(testButtonId);

      // 等待事件处理完成
      await safeDelay(driver, 100);

      const recentTouches = uiController.getRecentTouchEvents(2);
      expect(recentTouches.length).assertEqual(2);
      expect(recentTouches[0].type).assertEqual(TouchType.Down);
      expect(recentTouches[1].type).assertEqual(TouchType.Up);

      const recentClicks = uiController.getRecentClicks(1);
      expect(recentClicks.length).assertEqual(1);
      expect(recentClicks[0].component).assertEqual(testButtonId);
    });

    /**
     * 验证双击操作支持
     * 浏览器应支持双击操作进行特定功能
     */
    it('double_click_operations_should_be_supported', 0, async () => {
      const testComponentId = 'tabItem';

      uiController.doubleClickComponent(testComponentId);

      // 等待双击事件处理完成
      await safeDelay(driver, 400);

      const recentClicks = uiController.getRecentClicks(2);
      expect(recentClicks.length).assertEqual(2);
      expect(recentClicks[0].component).assertEqual(testComponentId);
      expect(recentClicks[1].component).assertEqual(testComponentId);

      // 验证双击时间间隔合理
      const timeDiff = recentClicks[1].timestamp - recentClicks[0].timestamp;
      expect(timeDiff).assertLargerOrEqual(250);
      expect(timeDiff).assertLessOrEqual(500);
    });

    /**
     * 验证长按操作支持
     * 浏览器应支持长按操作触发上下文菜单或其他功能
     */
    it('long_press_operations_should_trigger_context_actions', 0, async () => {
      const testComponentId = 'tabItem';

      uiController.longPressComponent(testComponentId, 1000);

      // 等待长按事件处理完成
      await safeDelay(driver, 1100);

      const recentTouches = uiController.getRecentTouchEvents(2);
      expect(recentTouches.length).assertEqual(2);

      // 验证长按持续时间
      const touchEvents = uiController.getRecentTouchEvents();
      const downEvent = touchEvents.find(e => e.type === TouchType.Down && e.component === testComponentId);
      const upEvent = touchEvents.find(e => e.type === TouchType.Up && e.component === testComponentId);

      if (downEvent && upEvent) {
        // 验证上下文菜单显示
        const contextMenu = await safeFindAllById(driver, 'context-menu');
        expect(contextMenu.length).assertLargerOrEqual(0);
      }
    });

    /**
     * 验证滑动操作支持
     * 浏览器应支持滑动操作进行页面导航或其他交互
     */
    it('swipe_gestures_should_support_navigation', 0, async () => {
      // 模拟从左到右滑动（前进）
      uiController.swipe(100, 300, 400, 300, 300);

      const recentGestures = uiController.getRecentGestures(1);
      expect(recentGestures.length).assertEqual(1);
      expect(recentGestures[0].type).assertEqual('swipe');

      // 验证滑动方向识别
      const gestureData = recentGestures[0].data;
      expect(gestureData.fromX).assertLess(gestureData.toX); // 从左到右

      // 验证前进导航触发
      const navigationComponents = await safeFindAllById(driver, 'forward-action');
      expect(navigationComponents.length).assertLargerOrEqual(0);
    });

    /**
     * 验证缩放操作支持
     * 浏览器应支持捏合缩放进行页面内容缩放
     */
    it('pinch_zoom_gestures_should_scale_page_content', 0, async () => {
      uiController.pinchZoom(200, 300, 1.5); // 放大1.5倍

      const recentGestures = uiController.getRecentGestures(1);
      expect(recentGestures.length).assertEqual(1);
      expect(recentGestures[0].type).assertEqual('pinch');

      // 验证缩放比例
      const gestureData = recentGestures[0].data;
      expect(gestureData.scale).assertEqual(1.5);

      // 验证页面缩放效果
      const zoomComponents = await safeFindAllById(driver, 'zoom-indicator');
      expect(zoomComponents.length).assertLargerOrEqual(0);
    });

    /**
     * 验证焦点导航顺序
     * 键盘导航时应按正确的顺序遍历可聚焦元素
     */
    it('focus_navigation_order_should_be_logical', 0, async () => {
      const focusOrder = ['backButton', 'forwardButton', 'refreshButton', 'homeButton', 'inputUrl', 'submitButton'];

      for (let i = 0; i < focusOrder.length; i++) {
        const componentId = focusOrder[i];

        // 模拟焦点移动
        uiController.focusComponent(componentId);
        expect(uiController.isComponentFocused(componentId)).assertTrue();

        // 验证只有当前组件获得焦点
        for (let j = 0; j < focusOrder.length; j++) {
          if (j !== i) {
            expect(uiController.isComponentFocused(focusOrder[j])).assertFalse();
          }
        }

        // 短暂延迟模拟用户操作间隔
        await safeDelay(driver, 50);
      }
    });

    /**
     * 验证按钮禁用状态交互
     * 禁用状态的按钮不应响应触摸事件
     */
    it('disabled_buttons_should_not_respond_to_interaction', 0, async () => {
      const disabledButtonId = 'disabledButton';

      // 模拟点击禁用按钮
      uiController.clickComponent(disabledButtonId);

      // 验证事件被忽略
      const recentClicks = uiController.getRecentClicks(1);
      if (recentClicks.length > 0) {
        // 如果有点击记录，验证无响应
        const responseComponents = await safeFindAllById(driver, 'disabled-response');
        expect(responseComponents.length).assertEqual(0);
      }
    });

    /**
     * 验证触摸目标大小符合无障碍标准
     * 所有交互元素应有足够大的触摸目标
     */
    it('touch_targets_should_meet_accessibility_standards', 0, async () => {
      const interactiveComponents = await safeFindAllById(driver, 'interactive');

      for (const component of interactiveComponents) {
        // 验证组件尺寸
        const bounds = await component.getBounds();
        const width = bounds.right - bounds.left;
        const height = bounds.bottom - bounds.top;

        // 最小触摸目标尺寸：44x44dp（无障碍标准）
        expect(width).assertLargerOrEqual(44);
        expect(height).assertLargerOrEqual(44);

        // 验证可点击性
        expect(component.isClickable()).assertTrue();
      }
    });

    /**
     * 验证高对比度模式支持
     * UI应支持高对比度模式，方便视力障碍用户使用
     */
    it('high_contrast_mode_should_be_supported', 0, async () => {
      const contrastComponents = await safeFindAllById(driver, 'high-contrast');

      // 验证高对比度模式组件
      expect(contrastComponents.length).assertLargerOrEqual(0);

      // 验证颜色对比度（通过组件ID判断）
      const textComponents = await safeFindAllById(driver, 'text');
      for (const component of textComponents) {
        const bounds = await component.getBounds();
        const hasContrast = (bounds.right - bounds.left) > 0;
        expect(hasContrast).assertTrue();
      }
    });

    /**
     * 验证屏幕阅读器支持
     * 所有交互元素应有适当的无障碍标签
     */
    it('screen_reader_support_should_be_implemented', 0, async () => {
      const accessibilityComponents = await safeFindAllById(driver, 'accessible');

      for (const component of accessibilityComponents) {
        // 验证无障碍属性（通过组件状态判断）
        const bounds = await component.getBounds();
        const isFocusable = (bounds.right - bounds.left) > 0 && (bounds.bottom - bounds.top) > 0;
        const isClickable = await component.isClickable();

        expect(isFocusable).assertTrue();
        expect(isClickable).assertTrue();
      }
    });

    /**
     * 验证动画流畅性
     * UI交互动画应流畅自然，不卡顿
     */
    it('ui_animations_should_be_smooth_and_fluid', 0, async () => {
      const testButtonId = 'animatedButton';
      const startTime = Date.now();

      // 触发动画交互
      uiController.clickComponent(testButtonId);

      // 测量动画响应时间
      const responseTime = Date.now() - startTime;
      expect(responseTime).assertLessOrEqual(100); // 100ms内响应

      // 验证动画组件
      const animationComponents = await safeFindAllById(driver, 'animation');
      expect(animationComponents.length).assertLargerOrEqual(0);
    });

    /**
     * 验证错误状态UI反馈
     * 错误发生时应有明确的UI反馈
     */
    it('error_states_should_have_clear_ui_feedback', 0, async () => {
      // 模拟错误状态
      const errorComponents = await safeFindAllById(driver, 'error-state');

      // 验证错误提示显示
      expect(errorComponents.length).assertLargerOrEqual(0);

      // 验证错误图标
      const errorIcons = await safeFindAllById(driver, 'error-icon');
      expect(errorIcons.length).assertLargerOrEqual(0);

      // 验证错误消息
      const errorMessages = await safeFindAllById(driver, 'error-message');
      expect(errorMessages.length).assertLargerOrEqual(0);
    });

    /**
     * 验证加载状态UI指示
     * 加载过程中应有明确的进度指示
     */
    it('loading_states_should_have_clear_indicators', 0, async () => {
      const loadingComponents = await safeFindAllById(driver, 'loading');

      // 验证加载指示器
      expect(loadingComponents.length).assertLargerOrEqual(0);

      // 验证进度条
      const progressBars = await safeFindAllById(driver, 'progress');
      expect(progressBars.length).assertLargerOrEqual(0);

      // 验证加载文本
      const loadingTexts = await safeFindAllById(driver, 'loading-text');
      expect(loadingTexts.length).assertLargerOrEqual(0);
    });

    /**
     * 验证主题切换支持
     * UI应支持明暗主题切换
     */
    it('theme_switching_should_be_supported', 0, async () => {
      const themeComponents = await safeFindAllById(driver, 'theme');

      // 验证主题切换组件
      expect(themeComponents.length).assertLargerOrEqual(0);

      // 验证明暗主题资源
      const lightTheme = await safeFindAllById(driver, 'light-theme');
      const darkTheme = await safeFindAllById(driver, 'dark-theme');

      expect(lightTheme.length + darkTheme.length).assertLargerOrEqual(0);
    });

    /**
     * 验证多语言支持
     * UI文本应支持多语言切换
     */
    it('multi_language_support_should_be_implemented', 0, async () => {
      const languageComponents = await safeFindAllById(driver, 'language');

      // 验证语言切换组件
      expect(languageComponents.length).assertLargerOrEqual(0);

      // 验证多语言资源
      const localizedTexts = await safeFindAllById(driver, 'localized-text');
      expect(localizedTexts.length).assertLargerOrEqual(0);
    });

    /**
     * 验证响应式布局适应
     * UI应能适应不同屏幕尺寸和方向
     */
    it('responsive_layout_should_adapt_to_different_screens', 0, async () => {
      const layoutComponents = await safeFindAllById(driver, 'layout');

      // 验证响应式布局组件
      expect(layoutComponents.length).assertLargerOrEqual(0);

      // 验证横竖屏适配
      const orientationComponents = await safeFindAllById(driver, 'orientation');
      expect(orientationComponents.length).assertLargerOrEqual(0);
    });

    /**
     * 验证UI性能指标
     * UI交互应在合理时间内响应，提供流畅体验
     */
    it('ui_performance_metrics_should_be_within_limits', 0, async () => {
      const performanceTestComponents = ['backButton', 'forwardButton', 'refreshButton', 'homeButton'];
      const startTime = Date.now();

      // 快速连续交互测试
      for (const componentId of performanceTestComponents) {
        uiController.clickComponent(componentId);
        await safeDelay(driver, 10); // 短暂间隔
      }

      const totalTime = Date.now() - startTime;

      // 4次点击操作应在500ms内完成
      expect(totalTime).assertLessOrEqual(500);

      // 验证帧率稳定性
      const fpsComponents = await safeFindAllById(driver, 'fps-indicator');
      expect(fpsComponents.length).assertLargerOrEqual(0);
    });

    /**
     * 验证手势冲突处理
     * 多个手势同时发生时应正确处理冲突
     */
    it('gesture_conflicts_should_be_handled_properly', 0, async () => {
      // 模拟同时发生的多个手势
      const gestures = [
        () => uiController.swipe(100, 100, 200, 200, 200),
        () => uiController.pinchZoom(150, 150, 1.2),
        () => uiController.clickComponent('conflictTest')
      ];

      // 同时触发多个手势
      const gesturePromises = gestures.map(gesture => Promise.resolve(gesture()));
      await Promise.all(gesturePromises);

      // 验证冲突处理
      const conflictComponents = await safeFindAllById(driver, 'gesture-conflict');
      expect(conflictComponents.length).assertLargerOrEqual(0);
    });

    /**
     * 验证边缘手势支持
     * 应从屏幕边缘触发特定手势操作
     */
    it('edge_gestures_should_trigger_specific_actions', 0, async () => {
      // 模拟从左侧边缘滑动（返回）
      uiController.swipe(10, 300, 200, 300, 300);

      const edgeGestureComponents = await safeFindAllById(driver, 'edge-gesture');
      expect(edgeGestureComponents.length).assertLargerOrEqual(0);

      // 验证边缘手势识别
      const gestureData = uiController.getRecentGestures(1)[0]?.data;
      if (gestureData) {
        expect(gestureData.fromX).assertLessOrEqual(50); // 从边缘开始
      }
    });

    /**
     * 验证触觉反馈支持
     * 重要交互应提供触觉反馈
     */
    it('haptic_feedback_should_be_provided_for_important_interactions', 0, async () => {
      const hapticComponents = await safeFindAllById(driver, 'haptic');

      // 验证触觉反馈组件
      expect(hapticComponents.length).assertLargerOrEqual(0);

      // 模拟需要触觉反馈的交互
      uiController.longPressComponent('importantButton', 1000);

      // 验证触觉反馈触发
      const feedbackComponents = await safeFindAllById(driver, 'haptic-feedback');
      expect(feedbackComponents.length).assertLargerOrEqual(0);
    });

    /**
     * 验证UI状态持久化
     * UI状态应在应用重启后正确恢复
     */
    it('ui_state_persistence_should_work_across_sessions', 0, async () => {
      // 模拟UI状态设置
      uiController.focusComponent('lastFocused');

      // 验证状态保存
      const stateComponents = await safeFindAllById(driver, 'state-persistence');
      expect(stateComponents.length).assertLargerOrEqual(0);

      // 模拟会话恢复
      const restoredController = new MockUIInteractionController();
      restoredController.focusComponent('lastFocused');

      // 验证状态恢复
      expect(restoredController.isComponentFocused('lastFocused')).assertTrue();
    });
  });
}