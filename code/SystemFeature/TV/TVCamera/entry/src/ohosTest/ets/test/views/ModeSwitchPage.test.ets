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

interface FileAssetStub {
  uri: string;
}

interface ToastRecord {
  type: string;
  cameraId: string;
  scene: string;
}

/**
 * 创建简化版存储桩，模拟页面对 AppStorage 的使用。
 * @returns 可读写键值对
 */
function createStorageHost(): Map<string, Object> {
  return new Map<string, Object>();
}

class ModeSwitchPageHarness {
  storage: Map<string, Object>;
  currentCameraId: string = '';
  secondCameraId: string = '';
  camerasList: CameraDeviceStub[] = [];
  onShow: boolean = true;
  isModeBol: boolean = true;
  isPause: boolean = false;
  videoRecodeTime: number = 18;
  pauseVideoImage: string = 'custom-image';
  surfaceId: string = '';
  timerActive: boolean = false;
  stopVideoResult?: FileAssetStub;
  thumbnailCreatedFor: string[] = [];
  focusButtonClicks: string[] = [];
  disconnectToasts: ToastRecord[] = [];
  reconnectToasts: ToastRecord[] = [];
  switchRequests: string[] = [];
  cameraInitRequests: string[] = [];

  constructor(storage: Map<string, Object>, cameras: CameraDeviceStub[]) {
    this.storage = storage;
    this.camerasList = cameras.slice();
  }

  /**
   * 模拟源码对当前相机 ID 变化的持久化动作。
   */
  onCurrentCameraIdChanged(): void {
    if (this.currentCameraId.length > 0) {
      this.storage.set('cameraId', this.currentCameraId);
    }
  }

  /**
   * 模拟 ModeSwitchPage 读取当前相机 ID 的优先级。
   * @returns 页面后续真正使用的相机 ID
   */
  getCurrentCameraId(): string {
    if (this.currentCameraId.length > 0) {
      return this.currentCameraId;
    }

    let cachedCameraId = this.storage.get('cameraId') as string | undefined;
    if (cachedCameraId && cachedCameraId.length > 0) {
      this.currentCameraId = cachedCameraId;
      return cachedCameraId;
    }

    if (this.camerasList.length > 0) {
      let firstCameraId = this.camerasList[0].cameraId;
      this.currentCameraId = firstCameraId;
      this.storage.set('cameraId', firstCameraId);
      return firstCameraId;
    }
    return '';
  }

  /**
   * 模拟双录模式选择“非当前镜头”的第二路相机。
   * @returns 第二路相机 ID
   */
  getSecondCameraId(): string {
    if (this.camerasList.length > 1) {
      let secondCamera = this.camerasList.find((camera: CameraDeviceStub) => {
        return camera.cameraId !== this.currentCameraId;
      });
      if (secondCamera) {
        this.secondCameraId = secondCamera.cameraId;
        return secondCamera.cameraId;
      }
    }
    this.secondCameraId = this.currentCameraId;
    return this.currentCameraId;
  }

  /**
   * 模拟老逻辑仍在使用的索引兼容入口。
   * @param index 目标索引
   * @returns 命中的相机 ID 或空串
   */
  getCameraIdByIndex(index: number): string {
    if (index >= 0 && index < this.camerasList.length) {
      return this.camerasList[index].cameraId;
    }
    return '';
  }

  /**
   * 模拟录像中按返回键后的统一收口逻辑。
   */
  handleCameraRecordClickBack(): void {
    if (!this.timerActive) {
      return;
    }
    this.timerActive = false;
    this.videoRecodeTime = 0;
    this.isModeBol = true;
    if (this.stopVideoResult) {
      this.thumbnailCreatedFor.push(this.stopVideoResult.uri);
    }
    this.focusButtonClicks.push('5');
    this.isPause = false;
  }

  /**
   * 模拟摄像头断开时的清理链。
   * @param cameraId 断开的相机 ID
   */
  handleCameraDisconnected(cameraId: string): void {
    if (!this.isModeBol && this.timerActive) {
      this.disconnectToasts.push({
        type: 'recordingInterrupted',
        cameraId: cameraId,
        scene: 'single'
      });
    }
    this.onShow = false;
    this.timerActive = false;
    this.videoRecodeTime = 0;
    this.isModeBol = true;
    if (this.stopVideoResult) {
      this.thumbnailCreatedFor.push(this.stopVideoResult.uri);
    }
    this.focusButtonClicks.push('5');
    this.switchRequests.push(cameraId);
    this.isPause = false;
    this.pauseVideoImage = 'app.media.camera_goon_default';
  }

  /**
   * 模拟摄像头重连后的提示与重建链。
   * @param cameraId 重连的相机 ID
   */
  handleCameraReconnected(cameraId: string): void {
    this.onShow = true;
    this.reconnectToasts.push({
      type: 'reconnected',
      cameraId: cameraId,
      scene: 'single'
    });
    if (this.surfaceId.length > 0) {
      this.cameraInitRequests.push(`${cameraId}@${this.surfaceId}`);
    }
  }
}

/**
 * 运行 ModeSwitchPage 契约测试。
 */
export default function ModeSwitchPageTest() {
  describe('ModeSwitchPageTest', () => {
    let storage: Map<string, Object>;

    beforeEach(() => {
      storage = createStorageHost();
    });

    it('ModeSwitchPage_OnCurrentCameraIdChanged_PersistsSelectedCamera_001', 0, () => {
      // 业务背景：页面内部相机切换后，后续拍照链和返回首页都依赖同一个已选 cameraId。
      // 因此只要当前 ID 非空，就必须立刻回写存储，避免跨页面状态漂移。
      let harness = new ModeSwitchPageHarness(storage, []);
      harness.currentCameraId = 'camera-main';
      harness.onCurrentCameraIdChanged();
      expect(storage.get('cameraId') as string).assertEqual('camera-main');
    });

    it('ModeSwitchPage_GetCurrentCameraId_PrefersStateThenCacheThenFirstCamera_002', 0, () => {
      // 业务背景：源码把“当前内存态、缓存、第一台可用相机”定义为三层回退顺序。
      // 锁住这条优先级后，页面在热切换和冷启动之间才不会频繁跳镜头。
      let harness = new ModeSwitchPageHarness(storage, [{ cameraId: 'camera-0' }, { cameraId: 'camera-1' }]);
      harness.currentCameraId = 'camera-1';
      expect(harness.getCurrentCameraId()).assertEqual('camera-1');
      harness.currentCameraId = '';
      storage.set('cameraId', 'camera-cache');
      expect(harness.getCurrentCameraId()).assertEqual('camera-cache');
      harness.currentCameraId = '';
      storage.delete('cameraId');
      expect(harness.getCurrentCameraId()).assertEqual('camera-0');
      expect(storage.get('cameraId') as string).assertEqual('camera-0');
    });

    it('ModeSwitchPage_GetSecondCameraId_ChoosesDifferentCameraWhenAvailable_003', 0, () => {
      // 业务背景：双录模式必须拿到一台不同于当前镜头的相机，否则双路画面会退化成同一路。
      // 所以只要设备列表里存在其他 cameraId，就应优先选它而不是重复当前镜头。
      let harness = new ModeSwitchPageHarness(storage, [{ cameraId: 'camera-0' }, { cameraId: 'camera-9' }]);
      harness.currentCameraId = 'camera-0';
      expect(harness.getSecondCameraId()).assertEqual('camera-9');
      expect(harness.secondCameraId).assertEqual('camera-9');
    });

    it('ModeSwitchPage_GetSecondCameraId_FallsBackToCurrentCameraOnSingleDevice_004', 0, () => {
      // 业务背景：只有一台相机时，页面源码不会返回空串，而是回退到当前镜头保持链路可继续运行。
      // 这能避免双录入口误触后直接把后续初始化带入“无 cameraId”异常分支。
      let harness = new ModeSwitchPageHarness(storage, [{ cameraId: 'camera-only' }]);
      harness.currentCameraId = 'camera-only';
      expect(harness.getSecondCameraId()).assertEqual('camera-only');
      expect(harness.secondCameraId).assertEqual('camera-only');
    });

    it('ModeSwitchPage_GetCameraIdByIndex_ReturnsEmptyStringOnOutOfRange_005', 0, () => {
      // 业务背景：索引接口主要用于兼容旧调用链，越界时源码选择返回空串而不是抛异常。
      // 这样错误会收敛为“无法选择镜头”，不会把整个拍摄页面生命周期打断。
      let harness = new ModeSwitchPageHarness(storage, [{ cameraId: 'camera-0' }]);
      expect(harness.getCameraIdByIndex(-1)).assertEqual('');
      expect(harness.getCameraIdByIndex(1)).assertEqual('');
    });

    it('ModeSwitchPage_HandleCameraRecordClickBack_ResetsRecordingStateAndCreatesThumbnail_006', 0, () => {
      // 业务背景：录像中按返回键属于强制收口场景，页面必须先把录像态和计时器全部归零。
      // 同时若 stopVideo 返回文件，还要补做缩略图与焦点按钮回位，保证 UI 不停留在半录制态。
      let harness = new ModeSwitchPageHarness(storage, []);
      harness.timerActive = true;
      harness.stopVideoResult = { uri: 'file://video.mp4' };
      harness.isPause = true;
      harness.handleCameraRecordClickBack();
      expect(harness.timerActive).assertFalse();
      expect(harness.videoRecodeTime).assertEqual(0);
      expect(harness.isModeBol).assertTrue();
      expect(harness.thumbnailCreatedFor[0]).assertEqual('file://video.mp4');
      expect(harness.focusButtonClicks[0]).assertEqual('5');
      expect(harness.isPause).assertFalse();
    });

    it('ModeSwitchPage_HandleCameraDisconnected_InterruptsRecordingAndSwitchesToFallbackCamera_007', 0, () => {
      // 业务背景：单路模式下正在录像时断开摄像头，是最容易导致页面僵死的异常场景。
      // 源码要求同时完成“中断提示、停止录像、回到拍照态、请求切其他镜头”这几步。
      let harness = new ModeSwitchPageHarness(storage, []);
      harness.isModeBol = false;
      harness.timerActive = true;
      harness.isPause = true;
      harness.stopVideoResult = { uri: 'file://recover.mp4' };
      harness.handleCameraDisconnected('camera-broken');
      expect(harness.disconnectToasts.length).assertEqual(1);
      expect(harness.disconnectToasts[0].type).assertEqual('recordingInterrupted');
      expect(harness.onShow).assertFalse();
      expect(harness.timerActive).assertFalse();
      expect(harness.videoRecodeTime).assertEqual(0);
      expect(harness.isModeBol).assertTrue();
      expect(harness.switchRequests[0]).assertEqual('camera-broken');
      expect(harness.pauseVideoImage).assertEqual('app.media.camera_goon_default');
    });

    it('ModeSwitchPage_HandleCameraDisconnected_SkipsInterruptedToastWhenNotRecording_008', 0, () => {
      // 业务背景：普通预览状态下断开摄像头只需要做资源切换，不应错误提示“录像被中断”。
      // 这条约束能避免用户在非录制状态下看到误导性提示文案。
      let harness = new ModeSwitchPageHarness(storage, []);
      harness.isModeBol = true;
      harness.timerActive = false;
      harness.handleCameraDisconnected('camera-preview');
      expect(harness.disconnectToasts.length).assertEqual(0);
      expect(harness.switchRequests[0]).assertEqual('camera-preview');
    });

    it('ModeSwitchPage_HandleCameraReconnected_ReinitializesOnlyWhenSurfaceReady_009', 0, () => {
      // 业务背景：摄像头重连并不代表页面一定已经拿到 surface，过早初始化会直接失败。
      // 因此源码先统一展示重连提示，再依据 surface 是否就绪决定是否真正发起初始化。
      let harness = new ModeSwitchPageHarness(storage, []);
      harness.handleCameraReconnected('camera-0');
      expect(harness.reconnectToasts.length).assertEqual(1);
      expect(harness.cameraInitRequests.length).assertEqual(0);
      harness.surfaceId = 'surface-ready';
      harness.handleCameraReconnected('camera-0');
      expect(harness.cameraInitRequests.length).assertEqual(1);
      expect(harness.cameraInitRequests[0]).assertEqual('camera-0@surface-ready');
    });
  });
}
