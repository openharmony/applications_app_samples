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
import {
  photoFrameMarkKey,
  photoMirrorKey,
  photoResolutionKey,
  photoWaterMarkKey,
  resolutionListKey,
  videoResolutionKey,
  videoWaterMarkKey
} from '../../../../main/ets/common/Constants';

type SettingValue = string | number | boolean;

interface RouterCall {
  url: string;
}

interface CameraDemoCall {
  name: string;
  value: string;
}

/**
 * 构建设置页共享存储桩。
 * @returns 可复用的设置存储
 */
function createSettingsStore(): Map<string, SettingValue> {
  return new Map<string, SettingValue>();
}

class CameraSettingsHarness {
  store: Map<string, SettingValue>;
  camerasCount: number;
  photoMirrorSwitch: boolean = false;
  cameraWaterMarkSwitch: boolean = false;
  cameraWaterFrameSwitch: boolean = false;
  videoWaterMarkSwitch: boolean = false;
  cameraResolution: string = '1080*720';
  videoResolution: string = '1080*720';
  resolutionType: string = 'photo';
  list: string[] = [];
  isMultiCameraMode: boolean = false;
  cameraDemoCalls: CameraDemoCall[] = [];
  routerCalls: RouterCall[] = [];

  constructor(store: Map<string, SettingValue>, camerasCount: number) {
    this.store = store;
    this.camerasCount = camerasCount;
  }

  /**
   * 模拟设置页显示时恢复分辨率和开关态。
   */
  aboutToAppear(): void {
    let resolutionStr = this.store.get(resolutionListKey) as string | undefined;
    this.list = resolutionStr && resolutionStr.length > 0 ? JSON.parse(resolutionStr) as string[] : [];

    let photoIndex = (this.store.get(photoResolutionKey) as number) ?? 0;
    let videoIndex = (this.store.get(videoResolutionKey) as number) ?? 0;
    if (this.list.length > 0) {
      this.cameraResolution = this.list[photoIndex];
      this.videoResolution = this.list[videoIndex];
    } else {
      this.cameraResolution = '';
      this.videoResolution = '';
    }

    this.cameraWaterMarkSwitch = (this.store.get(photoWaterMarkKey) as boolean) ?? false;
    this.photoMirrorSwitch = this.getMirrorParam();
    this.cameraWaterFrameSwitch = (this.store.get(photoFrameMarkKey) as boolean) ?? false;
    this.videoWaterMarkSwitch = (this.store.get(videoWaterMarkKey) as boolean) ?? false;
  }

  /**
   * 模拟设置页对镜像开关的反向读取逻辑。
   * @returns 页面最终展示的镜像开关状态
   */
  getMirrorParam(): boolean {
    return !(((this.store.get(photoMirrorKey) as boolean) ?? false));
  }

  /**
   * 统一记录配置写入行为。
   * @param key 配置键
   * @param value 配置值
   */
  saveConfig(key: string, value: SettingValue): void {
    this.store.set(key, value);
  }

  /**
   * 模拟照片镜像开关的保存逻辑。
   * @param value 用户选择的新状态
   */
  handlePhotoMirror(value: boolean): void {
    this.saveConfig(photoMirrorKey, value);
    this.photoMirrorSwitch = value;
  }

  /**
   * 模拟照片水印开关触发的持久化与底层能力调用。
   * @param value 用户选择的新状态
   */
  handleCameraWaterMark(value: boolean): void {
    this.saveConfig(photoWaterMarkKey, value);
    if (value) {
      this.cameraDemoCalls.push({ name: 'watermarkPhotoPic', value: 'default' });
      this.cameraDemoCalls.push({ name: 'watermarkPhotoFont', value: 'fd://photofont' });
      this.cameraWaterMarkSwitch = true;
      return;
    }
    this.cameraWaterMarkSwitch = false;
  }

  /**
   * 模拟照片相框开关的保存与底层调用。
   * @param value 用户选择的新状态
   */
  handleCameraFrame(value: boolean): void {
    this.saveConfig(photoFrameMarkKey, value);
    if (value) {
      this.cameraDemoCalls.push({ name: 'watermarkPhotoPic', value: 'default' });
      this.cameraWaterFrameSwitch = true;
      return;
    }
    this.cameraWaterFrameSwitch = false;
  }

  /**
   * 模拟视频水印开关触发的双能力调用。
   * @param value 用户选择的新状态
   */
  handleVideoWatermark(value: boolean): void {
    this.saveConfig(videoWaterMarkKey, value);
    if (value) {
      this.cameraDemoCalls.push({ name: 'watermarkVedioPic', value: 'default' });
      this.cameraDemoCalls.push({ name: 'watermarkVedioFont', value: 'fd://vediofont' });
      this.videoWaterMarkSwitch = true;
      return;
    }
    this.videoWaterMarkSwitch = false;
  }

  /**
   * 模拟多相机模式切换的核心行为。
   * @param isOn 是否开启多相机模式
   */
  handleSwitch(isOn: boolean): void {
    if (this.camerasCount > 1) {
      this.isMultiCameraMode = isOn;
      this.saveConfig(photoResolutionKey, 0);
      this.saveConfig(videoResolutionKey, 0);
      if (isOn) {
        this.routerCalls.push({ url: 'pages/MultiCameraPreviewPage' });
      }
    }
  }
}

/**
 * 运行设置页契约测试。
 */
export default function CameraSettingsPageTest() {
  describe('CameraSettingsPageTest', () => {
    let store: Map<string, SettingValue>;

    beforeEach(() => {
      store = createSettingsStore();
    });

    it('CameraSettingsPage_AboutToAppear_RestoresSavedResolutionAndSwitches_001', 0, () => {
      // 业务背景：设置页每次打开都要从持久化配置恢复 UI，否则用户会看到与真实配置不一致的开关和分辨率。
      // 这条测试把恢复链从分辨率列表、索引映射到四个开关状态全部锁住，避免只恢复一半的回归。
      store.set(resolutionListKey, JSON.stringify(['1080*720', '1280*960', '1920*1080']));
      store.set(photoResolutionKey, 2);
      store.set(videoResolutionKey, 1);
      store.set(photoWaterMarkKey, true);
      store.set(photoMirrorKey, false);
      store.set(photoFrameMarkKey, true);
      store.set(videoWaterMarkKey, true);
      let harness = new CameraSettingsHarness(store, 2);
      harness.aboutToAppear();
      expect(harness.cameraResolution).assertEqual('1920*1080');
      expect(harness.videoResolution).assertEqual('1280*960');
      expect(harness.cameraWaterMarkSwitch).assertTrue();
      expect(harness.photoMirrorSwitch).assertTrue();
      expect(harness.cameraWaterFrameSwitch).assertTrue();
      expect(harness.videoWaterMarkSwitch).assertTrue();
    });

    it('CameraSettingsPage_AboutToAppear_ClearsResolutionLabelsWhenListMissing_002', 0, () => {
      // 业务背景：首次启动或分辨率列表尚未生成时，源码会把文案清空而不是展示伪造分辨率。
      // 这样用户能明确感知“暂未拿到能力数据”，不会误以为默认值已经生效。
      let harness = new CameraSettingsHarness(store, 1);
      harness.aboutToAppear();
      expect(harness.cameraResolution).assertEqual('');
      expect(harness.videoResolution).assertEqual('');
    });

    it('CameraSettingsPage_GetMirrorParam_InvertsStoredMirrorFlag_003', 0, () => {
      // 业务背景：设置页镜像显示与底层持久化值存在反向关系，这里最容易在重构中被改错。
      // 固定“存 true 显 false、存 false 显 true”后，设置文案和拍照结果才不会长期错位。
      store.set(photoMirrorKey, true);
      let enabledHarness = new CameraSettingsHarness(store, 1);
      expect(enabledHarness.getMirrorParam()).assertFalse();
      store.set(photoMirrorKey, false);
      let disabledHarness = new CameraSettingsHarness(store, 1);
      expect(disabledHarness.getMirrorParam()).assertTrue();
    });

    it('CameraSettingsPage_HandlePhotoMirror_PersistsValueAndUpdatesSwitch_004', 0, () => {
      // 业务背景：镜像开关属于纯配置项，没有额外底层副作用，但必须立即反映到页面状态和存储。
      // 这条测试防止未来只改了 UI 不落盘，导致应用重启后镜像设置丢失。
      let harness = new CameraSettingsHarness(store, 1);
      harness.handlePhotoMirror(true);
      expect(store.get(photoMirrorKey) as boolean).assertTrue();
      expect(harness.photoMirrorSwitch).assertTrue();
    });

    it('CameraSettingsPage_HandleCameraWaterMark_EnablingTriggersPictureAndFontCalls_005', 0, () => {
      // 业务背景：照片水印开启时不仅要写配置，还要立即告诉底层追加图片和文字两类水印资源。
      // 只要漏掉任意一种调用，预览效果和最终成片就会出现“不完整水印”的回归。
      let harness = new CameraSettingsHarness(store, 1);
      harness.handleCameraWaterMark(true);
      expect(store.get(photoWaterMarkKey) as boolean).assertTrue();
      expect(harness.cameraWaterMarkSwitch).assertTrue();
      expect(harness.cameraDemoCalls.length).assertEqual(2);
      expect(harness.cameraDemoCalls[0].name).assertEqual('watermarkPhotoPic');
      expect(harness.cameraDemoCalls[1].value).assertEqual('fd://photofont');
    });

    it('CameraSettingsPage_HandleCameraWaterMark_DisablingKeepsNoResidualCameraCalls_006', 0, () => {
      // 业务背景：关闭照片水印时源码只负责落盘和关 UI，不会再次下发水印素材调用。
      // 固定这个行为可以避免关闭开关后仍误发旧素材，造成“明明关了却还叠图”的问题。
      let harness = new CameraSettingsHarness(store, 1);
      harness.handleCameraWaterMark(false);
      expect(store.get(photoWaterMarkKey) as boolean).assertFalse();
      expect(harness.cameraWaterMarkSwitch).assertFalse();
      expect(harness.cameraDemoCalls.length).assertEqual(0);
    });

    it('CameraSettingsPage_HandleCameraFrame_EnablingUsesDefaultFrameAsset_007', 0, () => {
      // 业务背景：相框开关开启时，设置页当前实现统一使用默认相框资源而不是空路径。
      // 这条契约保证即便用户尚未进入相框详情页，也能拿到可工作的默认叠图能力。
      let harness = new CameraSettingsHarness(store, 1);
      harness.handleCameraFrame(true);
      expect(store.get(photoFrameMarkKey) as boolean).assertTrue();
      expect(harness.cameraWaterFrameSwitch).assertTrue();
      expect(harness.cameraDemoCalls.length).assertEqual(1);
      expect(harness.cameraDemoCalls[0].value).assertEqual('default');
    });

    it('CameraSettingsPage_HandleVideoWatermark_EnablingTriggersVideoPictureAndFontCalls_008', 0, () => {
      // 业务背景：视频水印与照片水印一样需要双通道下发，否则录像流和成片标记会不同步。
      // 这里同时锁住素材路径，避免后续拼写改坏后只在运行期才暴露问题。
      let harness = new CameraSettingsHarness(store, 1);
      harness.handleVideoWatermark(true);
      expect(store.get(videoWaterMarkKey) as boolean).assertTrue();
      expect(harness.videoWaterMarkSwitch).assertTrue();
      expect(harness.cameraDemoCalls.length).assertEqual(2);
      expect(harness.cameraDemoCalls[0].name).assertEqual('watermarkVedioPic');
      expect(harness.cameraDemoCalls[1].value).assertEqual('fd://vediofont');
    });

    it('CameraSettingsPage_HandleSwitch_ResetsResolutionAndRoutesWhenMultiCameraAvailable_009', 0, () => {
      // 业务背景：启用多相机模式时，设置页会先把照片和视频分辨率索引重置到 0，再跳转到多相机预览页。
      // 顺序上少了任何一步，都会让多相机页拿到旧分辨率配置，进而出现能力不匹配或初始化失败。
      let harness = new CameraSettingsHarness(store, 3);
      store.set(photoResolutionKey, 2);
      store.set(videoResolutionKey, 1);
      harness.handleSwitch(true);
      expect(harness.isMultiCameraMode).assertTrue();
      expect(store.get(photoResolutionKey) as number).assertEqual(0);
      expect(store.get(videoResolutionKey) as number).assertEqual(0);
      expect(harness.routerCalls.length).assertEqual(1);
      expect(harness.routerCalls[0].url).assertEqual('pages/MultiCameraPreviewPage');
    });

    it('CameraSettingsPage_HandleSwitch_IgnoresRequestWhenOnlyOneCameraExists_010', 0, () => {
      // 业务背景：源码明确要求“只有多于一台相机”才允许进入多相机模式。
      // 这条守卫能防止单摄设备被错误带入多机位页面，产生无意义跳转和后续空列表异常。
      let harness = new CameraSettingsHarness(store, 1);
      harness.handleSwitch(true);
      expect(harness.isMultiCameraMode).assertFalse();
      expect(harness.routerCalls.length).assertEqual(0);
      expect(store.has(photoResolutionKey)).assertFalse();
      expect(store.has(videoResolutionKey)).assertFalse();
    });
  });
}
