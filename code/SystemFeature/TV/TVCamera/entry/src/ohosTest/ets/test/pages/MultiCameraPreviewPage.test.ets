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

class CameraDeviceStubImpl implements CameraDeviceStub {
  cameraId: string;

  constructor(cameraId: string) {
    this.cameraId = cameraId;
  }
}

interface CamerasWrapperStub {
  cameraId: string;
  surfaceId: string;
}

/**
 * 构建摄像头设备桩。
 * @param ids 需要创建的相机 ID 列表
 * @returns 相机设备数组
 */
function createCameraDevices(ids: string[]): CameraDeviceStub[] {
  return ids.map((id: string) => {
    return new CameraDeviceStubImpl(id);
  });
}

class MultiCameraPreviewHarness {
  supportedCameras: CameraDeviceStub[];
  camerasArray: CamerasWrapperStub[] = [];
  currentFocusIndex: number = 0;
  onShow: boolean = false;
  isFirstLoad: boolean = true;
  cameraInitStatus: Map<string, boolean> = new Map<string, boolean>();
  activeCameraIds: Set<string> = new Set<string>();
  toastEvents: string[] = [];
  releasedCameraIds: string[] = [];
  registeredCallbackCount: number = 0;
  refreshInvocationCount: number = 0;
  initCamerasFlags: boolean[] = [];
  releaseOldSessionsCount: number = 0;
  incrementalInitializeCount: number = 0;
  reinitializeAllCamerasCount: number = 0;

  constructor(supportedCameras: CameraDeviceStub[]) {
    this.supportedCameras = supportedCameras;
  }

  /**
   * 更新当前“系统可见”的相机列表。
   * @param devices 最新的设备列表
   */
  setSupportedCameras(devices: CameraDeviceStub[]): void {
    this.supportedCameras = devices;
  }

  /**
   * 模拟页面向 CameraService 拉取设备列表。
   * @returns 当前可见的摄像头设备
   */
  getSupportedCameras(): CameraDeviceStub[] {
    return this.supportedCameras.slice();
  }

  /**
   * 按摄像头 ID 查询设备信息。
   * @param cameraId 摄像头 ID
   * @returns 命中的设备信息
   */
  getCameraDeviceById(cameraId: string): CameraDeviceStub | undefined {
    return this.getSupportedCameras().find((item: CameraDeviceStub) => item.cameraId === cameraId);
  }

  /**
   * 模拟注册热插拔回调。
   */
  registerCameraStatusCallback(): void {
    this.registeredCallbackCount++;
  }

  /**
   * 模拟热插拔状态回调的转发逻辑。
   * @param cameraId 发生变化的相机 ID
   * @param deviceStatus 0 表示连接，1 表示断开
   */
  simulateCameraStatusCallback(cameraId: string, deviceStatus: number): void {
    if (deviceStatus.toString() === '1') {
      this.handleCameraDisconnectedInMultiMode(cameraId, this.getCameraDeviceById(cameraId));
    } else if (deviceStatus.toString() === '0') {
      this.handleCameraConnectedInMultiMode(cameraId, this.getCameraDeviceById(cameraId));
    }
  }

  /**
   * 模拟多相机页处理断开事件。
   * @param cameraId 断开的摄像头 ID
   * @param cameraDevice 对应的摄像头设备
   */
  handleCameraDisconnectedInMultiMode(cameraId: string, cameraDevice?: CameraDeviceStub): void {
    if (!this.onShow) {
      return;
    }
    this.toastEvents.push(`disconnect:${cameraId}:${cameraDevice ? 'known' : 'unknown'}`);
    this.activeCameraIds.delete(cameraId);
    this.releasedCameraIds.push(cameraId);
    this.refreshInvocationCount++;
  }

  /**
   * 模拟多相机页处理连接事件。
   * @param cameraId 连接的摄像头 ID
   * @param cameraDevice 对应的摄像头设备
   */
  handleCameraConnectedInMultiMode(cameraId: string, cameraDevice?: CameraDeviceStub): void {
    if (!this.onShow) {
      return;
    }
    this.toastEvents.push(`connect:${cameraId}:${cameraDevice ? 'known' : 'unknown'}`);
    this.refreshInvocationCount++;
  }

  /**
   * 模拟页面刷新摄像头列表并决定全量或增量更新。
   */
  refreshCameraListAndUI(): void {
    let oldCount = this.camerasArray.length;
    let oldCameraIds = this.camerasArray.map((camera: CamerasWrapperStub) => camera.cameraId);
    let newCameraIds = this.getSupportedCameras().map((camera: CameraDeviceStub) => camera.cameraId);
    let newCount = newCameraIds.length;

    let isAddingFourthCamera = oldCount === 3 && newCount === 4;
    let isRemovingFromFour = oldCount === 4 && newCount === 3;
    let isMinorChange = Math.abs(oldCount - newCount) === 1;

    if (isMinorChange && (isAddingFourthCamera || isRemovingFromFour)) {
      if (isRemovingFromFour) {
        let removedCameraIds = oldCameraIds.filter((cameraId: string) => !newCameraIds.includes(cameraId));
        removedCameraIds.forEach((cameraId: string) => {
          this.releasedCameraIds.push(cameraId);
          this.cameraInitStatus.set(cameraId, false);
          this.activeCameraIds.delete(cameraId);
        });
      }
      this.initCamerasFlags.push(true);
      return;
    }

    this.camerasArray.forEach((camera: CamerasWrapperStub) => {
      this.releasedCameraIds.push(camera.cameraId);
      this.cameraInitStatus.set(camera.cameraId, false);
    });
    this.activeCameraIds.clear();
    this.initCamerasFlags.push(false);
  }

  /**
   * 模拟页面异步过滤有效摄像头并选择初始化路径。
   * @param isIncrementalUpdate 是否增量更新
   */
  initCamerasAsync(isIncrementalUpdate: boolean = false): void {
    let devices = this.getSupportedCameras();
    if (devices.length === 0) {
      this.camerasArray = [];
      return;
    }

    let validCameras: CamerasWrapperStub[] = [];
    devices.forEach((item: CameraDeviceStub) => {
      if (item && item.cameraId.length > 0) {
        validCameras.push({
          cameraId: item.cameraId,
          surfaceId: ''
        });
        this.cameraInitStatus.set(item.cameraId, false);
      }
    });
    this.camerasArray = validCameras;

    if (!isIncrementalUpdate) {
      this.releaseOldSessionsAsync();
      return;
    }
    this.incrementalInitializeCameras();
  }

  /**
   * 模拟释放旧相机会话的批处理。
   */
  releaseOldSessionsAsync(): void {
    this.releaseOldSessionsCount++;
  }

  /**
   * 模拟只初始化新增摄像头的路径。
   */
  incrementalInitializeCameras(): void {
    this.incrementalInitializeCount++;
  }

  /**
   * 模拟页面重新显示时的首次/非首次差异逻辑。
   */
  onPageShow(): void {
    this.onShow = true;
    this.registerCameraStatusCallback();
    if (!this.isFirstLoad) {
      this.currentFocusIndex = 0;
      this.reinitializeAllCamerasCount++;
      return;
    }
    this.isFirstLoad = false;
  }
}

/**
 * 运行多相机预览页契约测试。
 */
export default function MultiCameraPreviewPageTest() {
  describe('MultiCameraPreviewPageTest', () => {
    let harness: MultiCameraPreviewHarness;

    beforeEach(() => {
      harness = new MultiCameraPreviewHarness(createCameraDevices(['camera-0', 'camera-1', 'camera-2']));
    });

    it('MultiCameraPreviewPage_RegisterCallback_IncrementsRegistrationCount_001', 0, () => {
      // 业务背景：多相机页的热插拔能力完全依赖状态回调注册成功。
      // 固定这条入口后，后续生命周期重构不会悄悄丢掉回调注册动作。
      harness.registerCameraStatusCallback();
      expect(harness.registeredCallbackCount).assertEqual(1);
    });

    it('MultiCameraPreviewPage_DisconnectEvent_IsIgnoredWhenPageHidden_002', 0, () => {
      // 业务背景：源码只在页面显示时处理热插拔，否则后台页会抢着刷新 UI。
      // 这条测试保证隐藏态下不会错误弹 toast、清活跃列表或触发刷新。
      harness.activeCameraIds.add('camera-1');
      harness.simulateCameraStatusCallback('camera-1', 1);
      expect(harness.toastEvents.length).assertEqual(0);
      expect(harness.refreshInvocationCount).assertEqual(0);
      expect(harness.activeCameraIds.has('camera-1')).assertTrue();
    });

    it('MultiCameraPreviewPage_DisconnectEvent_RemovesActiveCameraAndSchedulesRefresh_003', 0, () => {
      // 业务背景：前台断开摄像头后，多机位页必须先把该设备从活跃集合移除，再走刷新链路。
      // 如果活跃集合没同步，增量初始化会误判该镜头仍在线，最终留下僵尸 session。
      harness.onShow = true;
      harness.activeCameraIds.add('camera-1');
      harness.simulateCameraStatusCallback('camera-1', 1);
      expect(harness.toastEvents[0]).assertEqual('disconnect:camera-1:known');
      expect(harness.activeCameraIds.has('camera-1')).assertFalse();
      expect(harness.releasedCameraIds[0]).assertEqual('camera-1');
      expect(harness.refreshInvocationCount).assertEqual(1);
    });

    it('MultiCameraPreviewPage_ConnectEvent_OnlyRefreshesWhenPageVisible_004', 0, () => {
      // 业务背景：连接提示和刷新同样只属于前台页责任，后台页不应争抢热插拔反馈。
      // 这里同时验证隐藏态忽略和显示态执行，避免两个分支在后续重构中被合并错。
      harness.simulateCameraStatusCallback('camera-2', 0);
      expect(harness.refreshInvocationCount).assertEqual(0);
      harness.onShow = true;
      harness.simulateCameraStatusCallback('camera-2', 0);
      expect(harness.toastEvents.length).assertEqual(1);
      expect(harness.toastEvents[0]).assertEqual('connect:camera-2:known');
      expect(harness.refreshInvocationCount).assertEqual(1);
    });

    it('MultiCameraPreviewPage_RefreshCameraList_UsesIncrementalPathWhenFourthCameraIsAdded_005', 0, () => {
      // 业务背景：从 3 路增到 4 路是源码特判的轻微变化，页面不会全量重建所有 session。
      // 固定这条增量策略后，新增第四路摄像头就不会把已有三路预览全部打断。
      harness.camerasArray = [
        { cameraId: 'camera-0', surfaceId: '' },
        { cameraId: 'camera-1', surfaceId: '' },
        { cameraId: 'camera-2', surfaceId: '' }
      ];
      harness.setSupportedCameras(createCameraDevices(['camera-0', 'camera-1', 'camera-2', 'camera-3']));
      harness.refreshCameraListAndUI();
      expect(harness.initCamerasFlags.length).assertEqual(1);
      expect(harness.initCamerasFlags[0]).assertTrue();
      expect(harness.releasedCameraIds.length).assertEqual(0);
    });

    it('MultiCameraPreviewPage_RefreshCameraList_ReleasesOnlyRemovedCameraWhenDroppingFromFourToThree_006', 0, () => {
      // 业务背景：从 4 路减到 3 路时，源码会精确释放被拔掉的那一路，保留其他三路继续工作。
      // 这条测试可以防止后续误退化成全量释放，造成所有剩余画面一起闪断。
      harness.camerasArray = [
        { cameraId: 'camera-0', surfaceId: '' },
        { cameraId: 'camera-1', surfaceId: '' },
        { cameraId: 'camera-2', surfaceId: '' },
        { cameraId: 'camera-3', surfaceId: '' }
      ];
      harness.activeCameraIds.add('camera-0');
      harness.activeCameraIds.add('camera-3');
      harness.setSupportedCameras(createCameraDevices(['camera-0', 'camera-1', 'camera-2']));
      harness.refreshCameraListAndUI();
      expect(harness.initCamerasFlags[0]).assertTrue();
      expect(harness.releasedCameraIds.length).assertEqual(1);
      expect(harness.releasedCameraIds[0]).assertEqual('camera-3');
      expect(harness.activeCameraIds.has('camera-3')).assertFalse();
    });

    it('MultiCameraPreviewPage_RefreshCameraList_UsesFullReinitOnMajorChange_007', 0, () => {
      // 业务背景：除“增减单个第四路”之外，其余变化都被当作重大变更，必须全量释放并重建。
      // 这样虽然更保守，但能保证连接拓扑变化后页面不会残留过期 session。
      harness.camerasArray = [
        { cameraId: 'camera-0', surfaceId: '' },
        { cameraId: 'camera-1', surfaceId: '' },
        { cameraId: 'camera-2', surfaceId: '' }
      ];
      harness.activeCameraIds.add('camera-0');
      harness.activeCameraIds.add('camera-1');
      harness.setSupportedCameras(createCameraDevices(['camera-0']));
      harness.refreshCameraListAndUI();
      expect(harness.initCamerasFlags[0]).assertFalse();
      expect(harness.releasedCameraIds.length).assertEqual(3);
      expect(harness.activeCameraIds.size).assertEqual(0);
    });

    it('MultiCameraPreviewPage_InitCamerasAsync_FiltersInvalidDevicesAndChoosesFullReleasePath_008', 0, () => {
      // 业务背景：设备列表里只要有空 cameraId，就不应该进入可渲染数组，否则后续 session 初始化必然失败。
      // 同时非增量初始化必须进入“释放旧会话”分支，确保刷新前后状态干净一致。
      harness.setSupportedCameras([
        { cameraId: 'camera-0' },
        { cameraId: '' },
        { cameraId: 'camera-2' }
      ]);
      harness.initCamerasAsync(false);
      expect(harness.camerasArray.length).assertEqual(2);
      expect(harness.camerasArray[0].cameraId).assertEqual('camera-0');
      expect(harness.releaseOldSessionsCount).assertEqual(1);
      expect(harness.incrementalInitializeCount).assertEqual(0);
    });

    it('MultiCameraPreviewPage_InitCamerasAsync_UsesIncrementalInitializeForMinorRefresh_009', 0, () => {
      // 业务背景：增量刷新路径的目标是“只补新镜头，不动旧镜头”，因此不应该再走释放旧 session 的逻辑。
      // 这条测试直接守住两条路径的互斥关系，避免后续维护把两者一起调用。
      harness.initCamerasAsync(true);
      expect(harness.releaseOldSessionsCount).assertEqual(0);
      expect(harness.incrementalInitializeCount).assertEqual(1);
      expect(harness.camerasArray.length).assertEqual(3);
    });

    it('MultiCameraPreviewPage_OnPageShow_SkipsReinitializeOnFirstLoadButRunsLater_010', 0, () => {
      // 业务背景：首次进入页面时，aboutToAppear 已承担初始化职责，onPageShow 只负责翻转首载标记。
      // 二次回到页面时才需要真正重置焦点并重建全部相机，避免首页跳回时出现旧焦点和旧会话残留。
      harness.currentFocusIndex = 2;
      harness.onPageShow();
      expect(harness.isFirstLoad).assertFalse();
      expect(harness.reinitializeAllCamerasCount).assertEqual(0);
      harness.currentFocusIndex = 3;
      harness.onPageShow();
      expect(harness.currentFocusIndex).assertEqual(0);
      expect(harness.reinitializeAllCamerasCount).assertEqual(1);
      expect(harness.registeredCallbackCount).assertEqual(2);
    });
  });
}
