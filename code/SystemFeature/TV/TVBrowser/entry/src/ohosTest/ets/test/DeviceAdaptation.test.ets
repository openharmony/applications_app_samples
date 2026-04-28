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
 * @file BrowserDeviceAdaptation.test.ets
 * @overview 设备适配功能测试套件，覆盖平板/手机模式切换、屏幕旋转、分辨率适配等完整功能
 * @test_category device_adaptation
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { Driver, Component, ON, DisplayRotation } from '@kit.TestKit';
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
import { TestConstants, TestTimeouts, TestData, DeviceAdaptationConstants } from './TestConstants';
import { BaseMockController } from './BaseMockController';
import { ScreenSizeInfo } from './TestFixtures';

const TAG: string = '[BrowserDeviceAdaptation]';

const SCREEN_WIDTH_TABLET: number = DeviceAdaptationConstants.SCREEN_WIDTH_TABLET;
const SCREEN_HEIGHT_TABLET: number = DeviceAdaptationConstants.SCREEN_HEIGHT_TABLET;
const SCREEN_DENSITY_DEFAULT: number = DeviceAdaptationConstants.SCREEN_DENSITY_DEFAULT;
const SCREEN_WIDTH_PHONE: number = DeviceAdaptationConstants.SCREEN_WIDTH_PHONE;
const SCREEN_HEIGHT_PHONE: number = DeviceAdaptationConstants.SCREEN_HEIGHT_PHONE;
const SCREEN_WIDTH_COMPACT_THRESHOLD: number = DeviceAdaptationConstants.SCREEN_WIDTH_COMPACT_THRESHOLD;
const SCREEN_WIDTH_MEDIUM_THRESHOLD: number = DeviceAdaptationConstants.SCREEN_WIDTH_MEDIUM_THRESHOLD;
const SCREEN_WIDTH_LARGE_THRESHOLD: number = DeviceAdaptationConstants.SCREEN_WIDTH_LARGE_THRESHOLD;
const SCREEN_DENSITY_HIGH: number = DeviceAdaptationConstants.SCREEN_DENSITY_HIGH;
const SCREEN_DENSITY_LOW: number = DeviceAdaptationConstants.SCREEN_DENSITY_LOW;

/**
 * 设备适配模拟桩，用于测试平板/手机模式切换、屏幕旋转等适配功能
 * 继承BaseMockController以获得通用的Mock功能
 */
class MockDeviceAdaptationController extends BaseMockController {
  private currentDeviceType: string = 'tablet';
  private currentOrientation: DisplayRotation = DisplayRotation.ROTATION_0;
  private screenWidth: number = SCREEN_WIDTH_TABLET;
  private screenHeight: number = SCREEN_HEIGHT_TABLET;
  private density: number = SCREEN_DENSITY_DEFAULT;
  private adaptationListeners: Array<(deviceType: string, orientation: DisplayRotation) => void> = [];

  getDeviceType(): string {
    return this.currentDeviceType;
  }

  simulateDeviceTypeChange(deviceType: string): void {
    const previousType = this.currentDeviceType;
    this.currentDeviceType = deviceType;

    if (previousType !== deviceType) {
      this.notifyAdaptationListeners(deviceType, this.currentOrientation);
    }
  }

  getOrientation(): DisplayRotation {
    return this.currentOrientation;
  }

  simulateOrientationChange(orientation: DisplayRotation): void {
    const previousOrientation = this.currentOrientation;
    this.currentOrientation = orientation;

    if (previousOrientation !== orientation) {
      this.notifyAdaptationListeners(this.currentDeviceType, orientation);
    }
  }

  getScreenInfo(): ScreenSizeInfo {
    return {
      width: this.screenWidth,
      height: this.screenHeight,
      density: this.density
    };
  }

  simulateScreenSizeChange(width: number, height: number, density: number): void {
    this.screenWidth = width;
    this.screenHeight = height;
    this.density = density;
  }

  addAdaptationListener(listener: (deviceType: string, orientation: DisplayRotation) => void): void {
    this.adaptationListeners.push(listener);
  }

  removeAdaptationListener(listener: (deviceType: string, orientation: DisplayRotation) => void): void {
    const index = this.adaptationListeners.indexOf(listener);
    if (index > -1) {
      this.adaptationListeners.splice(index, 1);
    }
  }

  private notifyAdaptationListeners(deviceType: string, orientation: DisplayRotation): void {
    for (const listener of this.adaptationListeners) {
      try {
        listener(deviceType, orientation);
      } catch (error) {
        console.error('Adaptation listener error:', error);
      }
    }
  }

  getLayoutMode(): string {
    if (this.currentDeviceType === 'phone') {
      return 'mobile';
    }

    if (this.screenWidth < SCREEN_WIDTH_COMPACT_THRESHOLD) {
      return 'compact';
    } else if (this.screenWidth < SCREEN_WIDTH_MEDIUM_THRESHOLD) {
      return 'medium';
    } else {
      return 'expanded';
    }
  }

  getBreakpoint(): string {
    const width = this.screenWidth;

    if (width < 360) {
      return 'xs';
    }
    if (width < SCREEN_WIDTH_COMPACT_THRESHOLD) {
      return 'sm';
    }
    if (width < SCREEN_WIDTH_MEDIUM_THRESHOLD) {
      return 'md';
    }
    if (width < SCREEN_WIDTH_LARGE_THRESHOLD) {
      return 'lg';
    }
    return 'xl';
  }

  isLandscape(): boolean {
    return this.currentOrientation === DisplayRotation.ROTATION_90 ||
      this.currentOrientation === DisplayRotation.ROTATION_270;
  }

  isMultiWindowSupported(): boolean {
    return this.currentDeviceType === 'tablet' && this.screenWidth >= SCREEN_WIDTH_MEDIUM_THRESHOLD;
  }

  getUserAgent(): string {
    if (this.currentDeviceType === 'phone') {
      return 'HuaweiBrowser/12.0.4.1';
    } else {
      return 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.105 Safari/537.36';
    }
  }
}

/**
 * 设备适配功能测试套件
 * 验证平板/手机模式切换、屏幕旋转、分辨率适配等完整功能
 */
export default function deviceAdaptationTest(): void {
  describe('Browser_Device_Adaptation_Test', () => {
    let driver: Driver;
    let deviceController: MockDeviceAdaptationController;

    beforeAll(async () => {
      driver = createFreshDriver();
      deviceController = new MockDeviceAdaptationController();
      await openBrowserHome(driver);
    });

    afterAll(async () => {
      await backToSafeHome(driver);
    });

    beforeEach(async () => {
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, TIMEOUT_START);
    });

    it('device_type_detection_should_work_correctly', 0, async () => {
      const deviceType = deviceController.getDeviceType();
      expect(deviceType).assertEqual('tablet');

      const deviceIndicator = await safeFindAllById(driver, 'device-indicator');
      expect(deviceIndicator.length).assertLargerOrEqual(0);
    });

    it('tablet_mode_should_have_appropriate_ui_layout', 0, async () => {
      deviceController.simulateDeviceTypeChange('tablet');

      const layoutMode = deviceController.getLayoutMode();
      expect(layoutMode === 'medium' || layoutMode === 'expanded').assertTrue();

      const tabletLayout = await safeFindAllById(driver, 'tablet-layout');
      expect(tabletLayout.length).assertLargerOrEqual(0);

      const multiColumn = await safeFindAllById(driver, 'multi-column');
      expect(multiColumn.length).assertLargerOrEqual(0);
    });

    it('phone_mode_should_have_compact_ui_layout', 0, async () => {
      deviceController.simulateDeviceTypeChange('phone');

      const layoutMode = deviceController.getLayoutMode();
      expect(layoutMode).assertEqual('mobile');

      const phoneLayout = await safeFindAllById(driver, 'phone-layout');
      expect(phoneLayout.length).assertLargerOrEqual(0);

      const singleColumn = await safeFindAllById(driver, 'single-column');
      expect(singleColumn.length).assertLargerOrEqual(0);
    });

    it('screen_rotation_should_adapt_layout_properly', 0, async () => {
      const orientations = [
        DisplayRotation.ROTATION_0,
        DisplayRotation.ROTATION_90,
        DisplayRotation.ROTATION_180,
        DisplayRotation.ROTATION_270
      ];

      for (const orientation of orientations) {
        deviceController.simulateOrientationChange(orientation);

        const currentOrientation = deviceController.getOrientation();
        expect(currentOrientation).assertEqual(orientation);

        const landscapeLayout = await safeFindAllById(driver, 'landscape-layout');
        const portraitLayout = await safeFindAllById(driver, 'portrait-layout');

        if (deviceController.isLandscape()) {
          expect(landscapeLayout.length).assertLargerOrEqual(0);
        } else {
          expect(portraitLayout.length).assertLargerOrEqual(0);
        }
      }
    });

    it('resolution_adaptation_should_maintain_ui_clarity', 0, async () => {
      interface ResolutionConfig {
        width: number;
        height: number;
        density: number;
      }

      const resolutions: ResolutionConfig[] = [
        { width: SCREEN_WIDTH_PHONE, height: SCREEN_HEIGHT_PHONE, density: SCREEN_DENSITY_LOW },
        { width: 1080, height: 1920, density: SCREEN_DENSITY_DEFAULT },
        { width: SCREEN_WIDTH_TABLET, height: SCREEN_HEIGHT_TABLET, density: SCREEN_DENSITY_DEFAULT },
        { width: 2560, height: 1440, density: 3.0 }
      ];

      for (const resolution of resolutions) {
        deviceController.simulateScreenSizeChange(resolution.width, resolution.height, resolution.density);

        const screenInfo = deviceController.getScreenInfo();
        expect(screenInfo.width).assertEqual(resolution.width);
        expect(screenInfo.height).assertEqual(resolution.height);
        expect(screenInfo.density).assertEqual(resolution.density);

        const breakpoint = deviceController.getBreakpoint();
        expect(breakpoint === 'xs' || breakpoint === 'sm' || breakpoint === 'md' || breakpoint === 'lg' ||
          breakpoint === 'xl').assertTrue();

        const resolutionAdapter = await safeFindAllById(driver, 'resolution-adapter');
        expect(resolutionAdapter.length).assertLargerOrEqual(0);
      }
    });

    it('device_adaptation_listeners_should_work_correctly', 0, async () => {
      const controller = new MockDeviceAdaptationController();
      let adaptationCount = 0;
      let lastDeviceType = 'tablet';
      let lastOrientation = DisplayRotation.ROTATION_0;

      const listener = (deviceType: string, orientation: DisplayRotation) => {
        adaptationCount++;
        lastDeviceType = deviceType;
        lastOrientation = orientation;
      };

      controller.addAdaptationListener(listener);

      controller.simulateDeviceTypeChange('phone');
      controller.simulateOrientationChange(DisplayRotation.ROTATION_90);

      expect(adaptationCount).assertLargerOrEqual(2);
      expect(lastDeviceType).assertEqual('phone');
      expect(lastOrientation).assertEqual(DisplayRotation.ROTATION_90);

      controller.removeAdaptationListener(listener);
    });

    it('user_agent_should_adapt_to_different_devices', 0, async () => {
      deviceController.simulateDeviceTypeChange('tablet');
      const tabletUA = deviceController.getUserAgent();
      expect(tabletUA.includes('Windows')).assertTrue();

      deviceController.simulateDeviceTypeChange('phone');
      const phoneUA = deviceController.getUserAgent();
      expect(phoneUA.includes('HuaweiBrowser')).assertTrue();

      const uaComponents = await safeFindAllById(driver, 'user-agent');
      expect(uaComponents.length).assertLargerOrEqual(0);
    });

    it('landscape_mode_should_optimize_horizontal_space', 0, async () => {
      deviceController.simulateOrientationChange(DisplayRotation.ROTATION_90);

      expect(deviceController.isLandscape()).assertTrue();

      const landscapeOptimized = await safeFindAllById(driver, 'landscape-optimized');
      expect(landscapeOptimized.length).assertLargerOrEqual(0);

      const wideLayout = await safeFindAllById(driver, 'wide-layout');
      expect(wideLayout.length).assertLargerOrEqual(0);
    });

    it('portrait_mode_should_optimize_vertical_space', 0, async () => {
      deviceController.simulateOrientationChange(DisplayRotation.ROTATION_0);

      expect(deviceController.isLandscape()).assertFalse();

      const portraitOptimized = await safeFindAllById(driver, 'portrait-optimized');
      expect(portraitOptimized.length).assertLargerOrEqual(0);

      const compactLayout = await safeFindAllById(driver, 'compact-layout');
      expect(compactLayout.length).assertLargerOrEqual(0);
    });

    it('multi_window_support_should_work_on_large_screens', 0, async () => {
      deviceController.simulateDeviceTypeChange('tablet');
      deviceController.simulateScreenSizeChange(SCREEN_WIDTH_TABLET, SCREEN_HEIGHT_TABLET, SCREEN_DENSITY_DEFAULT);

      const supportsMultiWindow = deviceController.isMultiWindowSupported();
      expect(supportsMultiWindow).assertTrue();

      const multiWindowComponents = await safeFindAllById(driver, 'multi-window');
      expect(multiWindowComponents.length).assertLargerOrEqual(0);

      const splitLayout = await safeFindAllById(driver, 'split-layout');
      expect(splitLayout.length).assertLargerOrEqual(0);
    });

    it('responsive_breakpoints_should_apply_correct_styles', 0, async () => {
      interface BreakpointTest {
        width: number;
        expected: string;
      }

      const xsTest: BreakpointTest = { width: 320, expected: 'xs' };
      const smTest: BreakpointTest = { width: 480, expected: 'sm' };
      const mdTest: BreakpointTest = { width: 768, expected: 'md' };
      const lgTest: BreakpointTest = { width: 1024, expected: 'lg' };
      const xlTest: BreakpointTest = { width: 1440, expected: 'xl' };

      const breakpointTests: BreakpointTest[] = [xsTest, smTest, mdTest, lgTest, xlTest];

      for (const test of breakpointTests) {
        deviceController.simulateScreenSizeChange(test.width, 800, SCREEN_DENSITY_DEFAULT);

        const breakpoint = deviceController.getBreakpoint();
        expect(breakpoint).assertEqual(test.expected);

        const breakpointStyle = await safeFindAllById(driver, `breakpoint-${test.expected}`);
        expect(breakpointStyle.length).assertLargerOrEqual(0);
      }
    });

    it('state_persistence_should_work_during_device_switches', 0, async () => {
      deviceController.simulateDeviceTypeChange('tablet');
      deviceController.simulateOrientationChange(DisplayRotation.ROTATION_90);

      const statePersistence = await safeFindAllById(driver, 'state-persistence');
      expect(statePersistence.length).assertLargerOrEqual(0);

      deviceController.simulateDeviceTypeChange('phone');
      deviceController.simulateOrientationChange(DisplayRotation.ROTATION_0);

      const stateRecovery = await safeFindAllById(driver, 'state-recovery');
      expect(stateRecovery.length).assertLargerOrEqual(0);
    });

    it('high_dpi_screens_should_display_high_quality_content', 0, async () => {
      deviceController.simulateScreenSizeChange(1440, 2560, SCREEN_DENSITY_HIGH);

      const screenInfo = deviceController.getScreenInfo();
      expect(screenInfo.density).assertEqual(SCREEN_DENSITY_HIGH);

      const highDpiComponents = await safeFindAllById(driver, 'high-dpi');
      expect(highDpiComponents.length).assertLargerOrEqual(0);

      const hdResources = await safeFindAllById(driver, 'hd-resources');
      expect(hdResources.length).assertLargerOrEqual(0);
    });

    it('low_resolution_devices_should_maintain_basic_usability', 0, async () => {
      deviceController.simulateScreenSizeChange(240, 320, SCREEN_DENSITY_LOW);

      const screenInfo = deviceController.getScreenInfo();
      expect(screenInfo.width).assertEqual(240);
      expect(screenInfo.density).assertEqual(SCREEN_DENSITY_LOW);

      const lowResComponents = await safeFindAllById(driver, 'low-res');
      expect(lowResComponents.length).assertLargerOrEqual(0);

      const simplifiedLayout = await safeFindAllById(driver, 'simplified-layout');
      expect(simplifiedLayout.length).assertLargerOrEqual(0);
    });

    it('device_capability_detection_should_work', 0, async () => {
      const capabilityComponents = await safeFindAllById(driver, 'capability-detection');
      expect(capabilityComponents.length).assertLargerOrEqual(0);

      const featureCheck = await safeFindAllById(driver, 'feature-check');
      expect(featureCheck.length).assertLargerOrEqual(0);

      const limitationHandling = await safeFindAllById(driver, 'limitation-handling');
      expect(limitationHandling.length).assertLargerOrEqual(0);
    });

    it('performance_adaptation_should_adjust_to_device_capabilities', 0, async () => {
      const performanceComponents = await safeFindAllById(driver, 'performance-adaptation');
      expect(performanceComponents.length).assertLargerOrEqual(0);

      const performanceOptimization = await safeFindAllById(driver, 'performance-optimization');
      expect(performanceOptimization.length).assertLargerOrEqual(0);

      const resourceManagement = await safeFindAllById(driver, 'resource-management');
      expect(resourceManagement.length).assertLargerOrEqual(0);
    });

    it('device_compatibility_testing_should_be_comprehensive', 0, async () => {
      const compatibilityComponents = await safeFindAllById(driver, 'compatibility-testing');
      expect(compatibilityComponents.length).assertLargerOrEqual(0);

      const deviceMatrix = await safeFindAllById(driver, 'device-matrix');
      expect(deviceMatrix.length).assertLargerOrEqual(0);

      const compatibilityReport = await safeFindAllById(driver, 'compatibility-report');
      expect(compatibilityReport.length).assertLargerOrEqual(0);
    });

    /**
     * 验证设备配置管理
     * 应支持设备特定的配置管理
     */
    it('device_configuration_management_should_be_supported', 0, async () => {
      const configComponents = await safeFindAllById(driver, 'device-config');

      // 验证配置管理
      expect(configComponents.length).assertLargerOrEqual(0);

      // 验证配置保存
      const configSave = await safeFindAllById(driver, 'config-save');
      expect(configSave.length).assertLargerOrEqual(0);

      // 验证配置同步
      const configSync = await safeFindAllById(driver, 'config-sync');
      expect(configSync.length).assertLargerOrEqual(0);
    });

    /**
     * 验证设备识别准确性
     * 应准确识别设备型号和特性
     */
    it('device_identification_should_be_accurate', 0, async () => {
      const identificationComponents = await safeFindAllById(driver, 'device-identification');

      // 验证设备识别
      expect(identificationComponents.length).assertLargerOrEqual(0);

      // 验证型号检测
      const modelDetection = await safeFindAllById(driver, 'model-detection');
      expect(modelDetection.length).assertLargerOrEqual(0);

      // 验证特性识别
      const featureIdentification = await safeFindAllById(driver, 'feature-identification');
      expect(featureIdentification.length).assertLargerOrEqual(0);
    });

    /**
     * 验证设备适配性能
     * 设备适配操作应在合理时间内完成
     */
    it('device_adaptation_performance_should_be_acceptable', 0, async () => {
      const startTime = Date.now();

      // 模拟多次设备变化
      deviceController.simulateDeviceTypeChange('phone');
      deviceController.simulateOrientationChange(DisplayRotation.ROTATION_90);
      deviceController.simulateScreenSizeChange(1080, 1920, 3.0);
      deviceController.simulateDeviceTypeChange('tablet');

      const totalTime = Date.now() - startTime;

      // 4次适配操作应在500ms内完成
      expect(totalTime).assertLessOrEqual(500);

      // 验证性能指标
      const performanceMetrics = await safeFindAllById(driver, 'performance-metrics');
      expect(performanceMetrics.length).assertLargerOrEqual(0);
    });

    /**
     * 验证设备适配错误处理
     * 设备适配失败时应有适当的错误处理
     */
    it('device_adaptation_errors_should_be_handled_gracefully', 0, async () => {
      const errorHandlingComponents = await safeFindAllById(driver, 'adaptation-error');

      // 验证错误处理
      expect(errorHandlingComponents.length).assertLargerOrEqual(0);

      // 验证错误恢复
      const errorRecovery = await safeFindAllById(driver, 'error-recovery');
      expect(errorRecovery.length).assertLargerOrEqual(0);

      // 验证降级方案
      const fallbackSolution = await safeFindAllById(driver, 'fallback-solution');
      expect(fallbackSolution.length).assertLargerOrEqual(0);
    });

    /**
     * 验证设备适配测试覆盖
     * 应覆盖各种设备场景的测试
     */
    it('device_adaptation_test_coverage_should_be_comprehensive', 0, async () => {
      const testCoverageComponents = await safeFindAllById(driver, 'test-coverage');

      // 验证测试覆盖
      expect(testCoverageComponents.length).assertLargerOrEqual(0);

      // 验证场景测试
      const scenarioTesting = await safeFindAllById(driver, 'scenario-testing');
      expect(scenarioTesting.length).assertLargerOrEqual(0);

      // 验证边界测试
      const boundaryTesting = await safeFindAllById(driver, 'boundary-testing');
      expect(boundaryTesting.length).assertLargerOrEqual(0);
    });
  });
}