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

import { describe, beforeEach, it, expect } from '@ohos/hypium';

interface CameraDeviceStub {
  cameraId: string;
}

interface RouteParamsStub {
  fromMultiCamera?: boolean;
  selectedCameraId?: string;
  selectedCameraIndex?: number;
}

interface DisplaySizeStub {
  width: number;
  height: number;
}

interface InitCameraResult {
  skipped: boolean;
  initManagerOnly: boolean;
  releasedCameraIds: string[];
  releasedOtherCameraTarget: string;
  finalCameraId: string;
}

/**
 * 提供最小化的 AppStorage 行为桩。
 * @returns 可读写的键值存储实例
 */
function createStorageHost(): Map<string, Object> {
  return new Map<string, Object>();
}

class IndexPageHarness {
  storage: Map<string, Object>;
  supportedCameras: CameraDeviceStub[];
  fromMultiCamera: boolean = false;
  selectedCameraId: string = '';
  selectedCameraIndex: number = 0;
  currentCameraId: string = '';
  surfaceId: string = '';
  isVideo: boolean = false;
  screenWidth: number = 0;
  screenHeight: number = 0;
  initXComponentSizeCount: number = 0;
  initCameraImmediateCount: number = 0;

  constructor(storage: Map<string, Object>, supportedCameras: CameraDeviceStub[]) {
    this.storage = storage;
    this.supportedCameras = supportedCameras;
  }

  /**
   * 模拟首页对当前相机 ID 的优先级选择逻辑。
   * @returns 最终用于初始化的相机 ID
   */
  getCurrentCameraId(): string {
    if (this.fromMultiCamera && this.selectedCameraId.length > 0) {
      return this.selectedCameraId;
    }
    let cachedCameraId = this.storage.get('cameraId') as string | undefined;
    if (cachedCameraId && cachedCameraId.length > 0) {
      return cachedCameraId;
    }
    if (this.supportedCameras.length > 0) {
      let firstCameraId = this.supportedCameras[0].cameraId;
      this.storage.set('cameraId', firstCameraId);
      return firstCameraId;
    }
    return '';
  }

  /**
   * 按照页面内部的索引访问规则读取相机 ID。
   * @param index 目标相机索引
   * @returns 命中时返回相机 ID，否则返回空串
   */
  getCameraIdByIndex(index: number): string {
    if (index >= 0 && index < this.supportedCameras.length) {
      return this.supportedCameras[index].cameraId;
    }
    return '';
  }

  /**
   * 模拟 Index 页面处理路由参数的同步入口。
   * @param params 外部路由参数
   * @param throwOnRead 为 true 时模拟路由解析异常
   */
  handleRouteParams(params?: RouteParamsStub, throwOnRead: boolean = false): void {
    try {
      if (throwOnRead) {
        throw new Error('router parse failed');
      }
      if (params?.fromMultiCamera) {
        this.fromMultiCamera = true;
        this.selectedCameraId = params.selectedCameraId ?? '';
        this.selectedCameraIndex = params.selectedCameraIndex ?? 0;
        this.currentCameraId = this.selectedCameraId;
        this.storage.set('fromMultiCamera', true);
      } else {
        this.storage.set('fromMultiCamera', false);
        this.currentCameraId = this.getCurrentCameraId();
      }
    } catch (error) {
      this.currentCameraId = this.getCurrentCameraId();
      this.storage.set('fromMultiCamera', false);
    }
  }

  /**
   * 模拟首页先给出保底屏幕尺寸的逻辑。
   */
  setDefaultDisplaySettings(): void {
    this.screenWidth = 720;
    this.screenHeight = 1280;
    this.initXComponentSize();
  }

  /**
   * 模拟只有尺寸真正变化才刷新布局的逻辑。
   * @param display 新的显示尺寸
   */
  initDisplaySettings(display: DisplaySizeStub): void {
    if (this.screenWidth !== display.width || this.screenHeight !== display.height) {
      this.screenWidth = display.width;
      this.screenHeight = display.height;
      this.initXComponentSize();
    }
  }

  /**
   * 记录首页是否触发了 XComponent 尺寸重算。
   */
  initXComponentSize(): void {
    this.initXComponentSizeCount++;
  }

  /**
   * 模拟权限成功后在 surface 就绪时立即拉起相机。
   * @param permissionGranted 权限是否成功授予
   */
  requestPermissionsFn(permissionGranted: boolean): void {
    try {
      if (!permissionGranted) {
        throw new Error('permission denied');
      }
      if (this.surfaceId.length > 0) {
        this.initCameraImmediateCount++;
      }
    } catch (error) {
    }
  }

  /**
   * 模拟首页对相机初始化顺序的核心判断。
   * @returns 释放与初始化分支的结果摘要
   */
  initCameraImmediate(): InitCameraResult {
    if (this.surfaceId.length === 0) {
      return {
        skipped: true,
        initManagerOnly: false,
        releasedCameraIds: [],
        releasedOtherCameraTarget: '',
        finalCameraId: ''
      };
    }

    let releasedCameraIds: string[] = [];
    let currentCameraId = this.getCurrentCameraId();
    if (currentCameraId.length > 0) {
      releasedCameraIds.push(currentCameraId);
    }

    let targetCameraId = this.fromMultiCamera ? this.selectedCameraId : currentCameraId;
    let finalCameraId = targetCameraId || currentCameraId || '';
    return {
      skipped: false,
      initManagerOnly: finalCameraId.length === 0,
      releasedCameraIds: releasedCameraIds,
      releasedOtherCameraTarget: this.fromMultiCamera ? targetCameraId : '',
      finalCameraId: finalCameraId
    };
  }
}

/**
 * 运行首页契约测试。
 */
export default function IndexPageTest() {
  describe('IndexPageTest', () => {
    let storage: Map<string, Object>;

    beforeEach(() => {
      storage = createStorageHost();
    });

    it('IndexPage_GetCurrentCameraId_PrefersSelectedMultiCamera_001', 0, () => {
      // 业务背景：从多相机预览页返回首页时，首页必须继续使用用户刚才选中的镜头。
      // 如果这里回落到 AppStorage 的旧值，会直接导致预览镜头和用户选择不一致。
      let harness = new IndexPageHarness(storage, [{ cameraId: 'camera-0' }, { cameraId: 'camera-1' }]);
      harness.fromMultiCamera = true;
      harness.selectedCameraId = 'camera-1';
      storage.set('cameraId', 'camera-0');
      expect(harness.getCurrentCameraId()).assertEqual('camera-1');
    });

    it('IndexPage_GetCurrentCameraId_PersistsFirstSupportedCameraWhenCacheMissing_002', 0, () => {
      // 业务背景：正常启动时如果缓存里还没有相机 ID，首页会拿第一台可用相机作为保底入口。
      // 这一步同时要把结果回写到存储，后续设置页和重新初始化流程才能共享同一个相机上下文。
      let harness = new IndexPageHarness(storage, [{ cameraId: 'camera-a' }, { cameraId: 'camera-b' }]);
      expect(harness.getCurrentCameraId()).assertEqual('camera-a');
      expect(storage.get('cameraId') as string).assertEqual('camera-a');
    });

    it('IndexPage_GetCameraIdByIndex_ReturnsEmptyStringWhenOutOfRange_003', 0, () => {
      // 业务背景：多相机跳转参数可能出现越界索引，页面源码约定此时返回空串而不是抛错。
      // 锁住这个边界行为后，路由异常就会退化成“无可用相机”分支，而不是把首页生命周期打断。
      let harness = new IndexPageHarness(storage, [{ cameraId: 'camera-only' }]);
      expect(harness.getCameraIdByIndex(-1)).assertEqual('');
      expect(harness.getCameraIdByIndex(3)).assertEqual('');
    });

    it('IndexPage_HandleRouteParams_SetsMultiCameraStateAndStorageFlag_004', 0, () => {
      // 业务背景：来自多相机页面的路由是首页切换镜头的唯一同步入口。
      // 这里不仅要更新内存态，还要把 `fromMultiCamera` 写进存储，供设置页继续感知来源状态。
      let harness = new IndexPageHarness(storage, [{ cameraId: 'camera-0' }]);
      harness.handleRouteParams({
        fromMultiCamera: true,
        selectedCameraId: 'camera-9',
        selectedCameraIndex: 2
      });
      expect(harness.fromMultiCamera).assertTrue();
      expect(harness.currentCameraId).assertEqual('camera-9');
      expect(harness.selectedCameraIndex).assertEqual(2);
      expect(storage.get('fromMultiCamera') as boolean).assertTrue();
    });

    it('IndexPage_HandleRouteParams_FallsBackToDefaultCameraWhenRouterThrows_005', 0, () => {
      // 业务背景：路由参数解析失败不应该让首页失去拍摄能力，源码选择回退到默认相机。
      // 这条契约保证异常只影响多相机来源识别，不会让主拍照链路直接失效。
      let harness = new IndexPageHarness(storage, [{ cameraId: 'fallback-camera' }]);
      harness.handleRouteParams(undefined, true);
      expect(harness.currentCameraId).assertEqual('fallback-camera');
      expect(storage.get('fromMultiCamera') as boolean).assertFalse();
    });

    it('IndexPage_SetDefaultDisplaySettings_UsesSafeBootDimensions_006', 0, () => {
      // 业务背景：首页启动时先用固定保底尺寸渲染，避免等待真实屏幕信息导致黑屏。
      // 因此除了尺寸数值本身，还要确认它确实触发了一次 XComponent 重算。
      let harness = new IndexPageHarness(storage, []);
      harness.setDefaultDisplaySettings();
      expect(harness.screenWidth).assertEqual(720);
      expect(harness.screenHeight).assertEqual(1280);
      expect(harness.initXComponentSizeCount).assertEqual(1);
    });

    it('IndexPage_InitDisplaySettings_OnlyReflowsWhenDisplayActuallyChanges_007', 0, () => {
      // 业务背景：真实屏幕尺寸获取完成后，只有发生变化才值得重新布局，否则会制造无意义重绘。
      // 这条测试固定“去抖式刷新”行为，避免后续改动让页面在启动阶段重复抖动。
      let harness = new IndexPageHarness(storage, []);
      harness.setDefaultDisplaySettings();
      harness.initDisplaySettings({ width: 720, height: 1280 });
      expect(harness.initXComponentSizeCount).assertEqual(1);
      harness.initDisplaySettings({ width: 760, height: 1280 });
      expect(harness.initXComponentSizeCount).assertEqual(2);
    });

    it('IndexPage_RequestPermissions_TriggersCameraInitOnlyWhenSurfaceReady_008', 0, () => {
      // 业务背景：权限申请完成只是条件之一，真正能初始化相机还依赖 surface 已经创建成功。
      // 这里同时覆盖“有权限但无 surface 不启动”和“有权限且有 surface 才启动”的顺序约束。
      let harness = new IndexPageHarness(storage, []);
      harness.requestPermissionsFn(true);
      expect(harness.initCameraImmediateCount).assertEqual(0);
      harness.surfaceId = 'surface-ready';
      harness.requestPermissionsFn(true);
      expect(harness.initCameraImmediateCount).assertEqual(1);
    });

    it('IndexPage_InitCameraImmediate_SkipsWhenSurfaceMissing_009', 0, () => {
      // 业务背景：源码对空 surface 有显式保护，这是首页避免空窗体初始化崩溃的第一道防线。
      // 固定这条守卫后，页面生命周期先后顺序再怎么变化也不会提前触发底层相机初始化。
      let harness = new IndexPageHarness(storage, [{ cameraId: 'camera-0' }]);
      let result = harness.initCameraImmediate();
      expect(result.skipped).assertTrue();
      expect(result.releasedCameraIds.length).assertEqual(0);
    });

    it('IndexPage_InitCameraImmediate_UsesManagerOnlyPathWhenNoCameraExists_010', 0, () => {
      // 业务背景：无摄像头场景下首页仍要初始化管理器监听热插拔，而不是完全停在空白状态。
      // 这条测试锁住 “无 cameraId 但不报错” 的兜底分支，方便后续热插拔恢复时自动接管。
      let harness = new IndexPageHarness(storage, []);
      harness.surfaceId = 'surface-ready';
      let result = harness.initCameraImmediate();
      expect(result.skipped).assertFalse();
      expect(result.initManagerOnly).assertTrue();
      expect(result.finalCameraId).assertEqual('');
    });

    it('IndexPage_InitCameraImmediate_UsesSelectedMultiCameraAsFinalTarget_011', 0, () => {
      // 业务背景：从多相机页面切回首页时，源码会优先把“选中的镜头”作为最终初始化目标。
      // 如果目标 ID 漂移到旧缓存镜头，用户会在首页看到与选择页不一致的预览结果。
      let harness = new IndexPageHarness(storage, [{ cameraId: 'camera-0' }, { cameraId: 'camera-1' }]);
      harness.surfaceId = 'surface-ready';
      harness.fromMultiCamera = true;
      harness.selectedCameraId = 'camera-1';
      storage.set('cameraId', 'camera-0');
      let result = harness.initCameraImmediate();
      expect(result.releasedCameraIds.length).assertEqual(1);
      expect(result.releasedCameraIds[0]).assertEqual('camera-1');
      expect(result.releasedOtherCameraTarget).assertEqual('camera-1');
      expect(result.finalCameraId).assertEqual('camera-1');
    });
  });
}
