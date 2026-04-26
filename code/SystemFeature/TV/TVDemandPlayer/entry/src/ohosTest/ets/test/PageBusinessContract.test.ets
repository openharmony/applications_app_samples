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

/**
 * 页面业务规则测试合并文件
 *
 * 业务背景：本文件汇聚了 Index/HttpFolderList/LocalFolderList/LocalVideoList/VideoPlayer 等页面的核心业务规则测试。
 * 在点播场景中，页面间的跳转、焦点切换以及数据的标准化处理是保证 UI 一致性的关键。
 *
 * 测试策略：
 * - 网络与准入层：验证 TV 设备的网络发现能力以及进入不同播放模式的门槛逻辑
 * - 焦点管理层：验证 TV 遥控器操作下的焦点移动算法，确保不会出现焦点丢失或死循环
 * - 数据契约层：验证 HTTP 和本地视频列表的归一化过程，确保 UI 组件能处理统一的字段
 * - 播放态管理：验证上下集切换、倍速/比例重置以及投屏对话框的生命周期状态
 */

class IndexButtonLike {
  id: string;
  text: string;

  constructor(id: string, text: string) {
    this.id = id;
    this.text = text;
  }
}

class HttpVideoInputLike {
  uri?: string;
  url?: string;
  name?: string;
  licenseUri?: string;

  constructor(uri?: string, url?: string, name?: string, licenseUri?: string) {
    this.uri = uri;
    this.url = url;
    this.name = name;
    this.licenseUri = licenseUri;
  }
}

class StringArray extends Array<string> {
}

class HttpVideoOutputLike {
  uri: string;
  url: string;
  type: string;
  displayName: string;
  resolution: string;
  resolutions: Array<string>;
  licenseUri: string;

  constructor(uri: string, url: string, type: string, displayName: string, resolution: string,
    resolutions: Array<string>, licenseUri: string) {
    this.uri = uri;
    this.url = url;
    this.type = type;
    this.displayName = displayName;
    this.resolution = resolution;
    this.resolutions = resolutions;
    this.licenseUri = licenseUri;
  }
}

class FolderCardLike {
  id: string;
  name: string;
  num: number;

  constructor(id: string, name: string, num: number) {
    this.id = id;
    this.name = name;
    this.num = num;
  }
}

class FolderCardList extends Array<FolderCardLike> {
}

class LocalVideoLike {
  uri?: string;
  displayName?: string;
  deviceType?: number;

  constructor(uri?: string, displayName?: string, deviceType?: number) {
    this.uri = uri;
    this.displayName = displayName;
    this.deviceType = deviceType;
  }
}

class LocalVideoList extends Array<LocalVideoLike> {
}

class TransferDeviceLike {
  deviceId: string;
  networkId?: string;

  constructor(deviceId: string, networkId?: string) {
    this.deviceId = deviceId;
    this.networkId = networkId;
  }
}

class TransferDeviceList extends Array<TransferDeviceLike> {
}

class PlayerStateLike {
  videoIndex: number;
  videoCount: number;
  videoSpeed: number;
  focusSpeedItemId: string;
  rotationAngle: number;
  isTransferDialogShow: boolean;
  focusId: string;
  focusBeforeTransferDialog: string;
  transferFocusId: string;

  constructor(videoIndex: number, videoCount: number, videoSpeed: number, focusSpeedItemId: string,
    rotationAngle: number, isTransferDialogShow: boolean, focusId: string, focusBeforeTransferDialog: string,
    transferFocusId: string) {
    this.videoIndex = videoIndex;
    this.videoCount = videoCount;
    this.videoSpeed = videoSpeed;
    this.focusSpeedItemId = focusSpeedItemId;
    this.rotationAngle = rotationAngle;
    this.isTransferDialogShow = isTransferDialogShow;
    this.focusId = focusId;
    this.focusBeforeTransferDialog = focusBeforeTransferDialog;
    this.transferFocusId = transferFocusId;
  }
}

/**
 * 业务逻辑：网络发现判断
 * 为什么这么做：TV 设备可能处于复杂的内网环境，通过能力集（capabilities）判断网络可用性
 * 比单纯判断 IP 连接更可靠，可以区分以太网、WiFi 和分布式网络。
 */
function judgeHasNetByCaps(netId: number, capabilities: Array<number>, validatedValue: number): boolean {
  if (!netId) {
    return false;
  }
  return capabilities.includes(validatedValue);
}

/**
 * 业务逻辑：Index 页面焦点切换
 * 为什么这么做：TV 遥控器只有上下左右键，通过数组下标映射焦点能保证操作直观。
 * 边界保护：当到达首项或末项时，焦点应停留而不能回绕，避免用户操作困惑。
 */
function nextIndexFocus(current: number, keyCode: number, total: number): number {
  let next = current;
  if (keyCode === 1 && current > 0) {
    next--;
  }
  if (keyCode === 2 && current < total - 1) {
    next++;
  }
  return next;
}

/**
 * 业务逻辑：HTTP 视频列表归一化
 * 为什么这么做：后端 API 返回的字段名可能随版本波动，前端需要一个稳定的契约（OutputLike）。
 * 默认值填充：确保 displayName 和 licenseUri 永远不为 undefined，防止 UI 渲染 Crash。
 */
function normalizeHttpVideoList(videoList: Array<HttpVideoInputLike>): Array<HttpVideoOutputLike> {
  const result: Array<HttpVideoOutputLike> = [];
  for (let i = 0; i < videoList.length; i++) {
    const item = videoList[i];
    result.push(new HttpVideoOutputLike(
      item.uri || '',
      item.url || '',
      'http',
      item.name || '',
      '1080P',
      new StringArray(),
      item.licenseUri || ''
    ));
  }
  return result;
}

/**
 * 业务逻辑：DRM 播放准入校验
 * 为什么这么做：带许可证的视频必须在支持 DRM 的设备上播放，否则会产生解密错误。
 * 背景：如果视频本身没有 License，则不需要 DRM 支持即可播放。
 */
function shouldBlockHttpPlay(hasLicense: boolean, drmSupported: boolean): boolean {
  if (!hasLicense) {
    return false;
  }
  return !drmSupported;
}

/**
 * 业务逻辑：HTTP 列表焦点钳制
 * 为什么这么做：当剧集列表刷新或搜索结果变化时，旧焦点可能越界。
 * 安全性：将非法索引强制复位到 0，保证 UI 始终有可操作的焦点。
 */
function clampHttpFocus(currentFocus: number, total: number): number {
  if (total <= 0) {
    return currentFocus;
  }
  if (currentFocus < -1 || currentFocus > total - 1) {
    return 0;
  }
  return currentFocus;
}

/**
 * 业务逻辑：文件夹焦点保护
 * 为什么这么做：TV 上的文件夹可能因 USB 拔插而消失。
 * 联动逻辑：如果当前选中的文件夹内视频数为 0，应禁止进入并复位焦点。
 */
function clampFolderFocus(currentFocus: number, folderList: Array<FolderCardLike>): number {
  if (folderList.length === 0) {
    return 0;
  }
  if (currentFocus < 0 || currentFocus > folderList.length - 1) {
    return 0;
  }
  if (!folderList[currentFocus] || folderList[currentFocus].num === 0) {
    return 0;
  }
  return currentFocus;
}

/**
 * 业务逻辑：文件夹切换逻辑
 * 为什么这么做：支持横向排列的文件夹视图，通过 1/2 码值模拟遥控器左右键。
 */
function moveFolderFocus(currentFocus: number, keyCode: number, length: number): number {
  let next = currentFocus;
  if (keyCode === 1 && currentFocus > 0) {
    next--;
  }
  if (keyCode === 2 && currentFocus < length - 1) {
    next++;
  }
  return next;
}

/**
 * 业务逻辑：文件夹进入条件
 * 为什么这么做：USB 目录在未扫描完成前是 loading 态，此时进入会导致空列表。
 * 特殊限制：focusId 为 1 通常代表 USB 根目录，受 isUSBEnable 全局开关控制。
 */
function canEnterFolder(isLoading: boolean, folderNum: number, isUSBEnable: boolean, focusId: number): boolean {
  if (!isUSBEnable && focusId === 1) {
    return false;
  }
  if (isLoading) {
    return false;
  }
  return folderNum > 0;
}

/**
 * 业务逻辑：本地视频焦点钳制
 * 为什么这么做：多视频列表滚动时，防止索引溢出导致 Array.get() 报错。
 */
function clampLocalVideoFocus(currentFocus: number, length: number): number {
  if (length > 0 && (currentFocus < -1 || currentFocus > length - 1)) {
    return 0;
  }
  return currentFocus;
}

/**
 * 业务逻辑：动态视频标题构建
 * 为什么这么做：UI 顶部需要显示当前选中视频的名称。
 * 背景：如果 displayName 缺失，需要返回空串而不是显示 "undefined"。
 */
function buildVideoName(videoList: Array<LocalVideoLike>, focusId: number): string {
  if (videoList.length === 0) {
    return '';
  }
  return String(videoList[focusId].displayName || '');
}

/**
 * 业务逻辑：播放操作节流
 * 为什么这么做：用户可能因为遥控器按键粘连导致快速触发多次播放请求。
 * 性能优化：800ms 的阈值能有效防止内核因频繁 start/stop 而崩溃。
 */
function canPlayLocalVideo(isNavigating: boolean, clickNow: number, now: number): boolean {
  if (isNavigating) {
    return false;
  }
  return now - clickNow >= 800;
}

/**
 * 业务逻辑：播放器状态快照创建
 * 为什么这么做：在切换视频时需要保留一部分 UI 状态（如旋转角度），但重置业务状态。
 */
function createPlayerState(): PlayerStateLike {
  return new PlayerStateLike(0, 3, 1, 's_2_4', 90, false, 'id_3', '', '');
}

/**
 * 业务逻辑：循环切集算法
 * 为什么这么做：点播播放器支持循环播放，首尾索引需要能够自动衔接。
 */
function prevVideoIndex(current: number, total: number): number {
  return current === 0 ? total - 1 : current - 1;
}

function nextVideoIndex(current: number, total: number): number {
  return current === total - 1 ? 0 : current + 1;
}

/**
 * 业务逻辑：切集状态重置
 * 为什么这么做：切换到新视频时，播放速度应恢复 1.0X，画面比例应恢复原始，避免旧视频设置干扰。
 */
function applyVideoSwitchReset(state: PlayerStateLike): PlayerStateLike {
  return new PlayerStateLike(
    state.videoIndex,
    state.videoCount,
    1,
    's_2_4',
    0,
    state.isTransferDialogShow,
    state.focusId,
    state.focusBeforeTransferDialog,
    state.transferFocusId
  );
}

/**
 * 业务逻辑：投屏对话框焦点捕获
 * 为什么这么做：弹出投屏框时，焦点必须强制转移到框内，否则背景页面仍可操作。
 * 背景：记录 focusBeforeTransferDialog 以便在关闭时恢复焦点。
 */
function openTransferDialog(state: PlayerStateLike, devices: Array<TransferDeviceLike>): PlayerStateLike {
  return new PlayerStateLike(
    state.videoIndex,
    state.videoCount,
    state.videoSpeed,
    state.focusSpeedItemId,
    state.rotationAngle,
    true,
    state.focusId,
    state.focusId,
    devices.length > 0 ? devices[0].deviceId : ''
  );
}

/**
 * 业务逻辑：投屏对话框关闭与焦点回退
 * 为什么这么做：如果之前的焦点是 id_5（投屏按钮），关闭后通常应停留在播放器主操作区（id_3）。
 */
function closeTransferDialog(state: PlayerStateLike, restoreFocus: boolean): PlayerStateLike {
  const restoreId = !state.focusBeforeTransferDialog || state.focusBeforeTransferDialog === 'id_5'
    ? 'id_3'
    : state.focusBeforeTransferDialog;
  return new PlayerStateLike(
    state.videoIndex,
    state.videoCount,
    state.videoSpeed,
    state.focusSpeedItemId,
    state.rotationAngle,
    false,
    restoreFocus ? restoreId : state.focusId,
    state.focusBeforeTransferDialog,
    state.transferFocusId
  );
}

/**
 * 业务逻辑：投屏停止判定
 * 为什么这么做：networkId 存在说明正在投屏中，此时执行操作会中断当前流。
 */
function shouldStopTransfer(networkId?: string): boolean {
  return !!networkId;
}

/**
 * 业务逻辑：物理返回键拦截规则
 * 为什么这么做：TV 交互中，返回键应先关闭弹窗（设置、投屏），最后才是退出页面。
 */
function shouldBackIntercept(isBackPress: boolean, isSettingVisible: boolean, isTransferVisible: boolean): boolean {
  if (!isBackPress) {
    return true;
  }
  if (isSettingVisible || isTransferVisible) {
    return true;
  }
  return false;
}

export default function PageBusinessContractTest() {
  const casePrefix = 'DemandPlayer_PageBusinessContract_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  /**
   * ========== 第一部分：Index/HttpFolderList 业务规则 ==========
   * 背景：验证网络准入、基础导航与列表契约
   */
  describe('PageBusinessContract_IndexHttpRules', () => {
    it(addCase(casePrefix + 'IndexNetJudge_InvalidNetRejected_001'), 0, () => {
      // 业务逻辑：netId 为 0 代表无网络，此时无论能力集如何都应拒绝
      expect(judgeHasNetByCaps(0, [1, 2, 3], 9)).assertEqual(false);
    });

    it(addCase(casePrefix + 'IndexNetJudge_ValidatedAccepted_002'), 0, () => {
      // 业务逻辑：能力集中包含指定值（9）时才认为具备该类型的网络能力
      expect(judgeHasNetByCaps(10, [1, 9, 12], 9)).assertEqual(true);
      expect(judgeHasNetByCaps(10, [1, 2, 3], 9)).assertEqual(false);
    });

    it(addCase(casePrefix + 'IndexFocus_LeftRightBoundary_003'), 0, () => {
      // 业务逻辑：左右边界焦点不回绕
      expect(nextIndexFocus(0, 1, 2)).assertEqual(0);
      expect(nextIndexFocus(0, 2, 2)).assertEqual(1);
      expect(nextIndexFocus(1, 2, 2)).assertEqual(1);
      expect(nextIndexFocus(1, 1, 2)).assertEqual(0);
    });

    it(addCase(casePrefix + 'HttpList_NormalizationContract_004'), 0, () => {
      // 业务逻辑：验证输入到输出的字段投影正确性
      const result = normalizeHttpVideoList([
        new HttpVideoInputLike('1', 'https://a.mp4', 'A', 'https://license')
      ]);
      expect(result.length).assertEqual(1);
      expect(result[0].type).assertEqual('http');
      expect(result[0].displayName).assertEqual('A');
      expect(result[0].resolution).assertEqual('1080P');
      expect(result[0].licenseUri).assertEqual('https://license');
    });

    it(addCase(casePrefix + 'HttpPlay_DrmGateRule_005'), 0, () => {
      // 业务逻辑：有 License 但设备不支持 DRM 时必须拦截播放
      expect(shouldBlockHttpPlay(false, false)).assertEqual(false);
      expect(shouldBlockHttpPlay(true, false)).assertEqual(true);
      expect(shouldBlockHttpPlay(true, true)).assertEqual(false);
    });

    it(addCase(casePrefix + 'HttpFocus_ClampRule_006'), 0, () => {
      // 业务逻辑：越界焦点强制复位到 0
      expect(clampHttpFocus(-2, 4)).assertEqual(0);
      expect(clampHttpFocus(8, 4)).assertEqual(0);
      expect(clampHttpFocus(2, 4)).assertEqual(2);
    });

    it(addCase(casePrefix + 'IndexButtonCountContract_007'), 0, () => {
      // 业务逻辑：验证主页按钮的基础静态配置
      const buttons = new Array<IndexButtonLike>(
        new IndexButtonLike('id_1', '网络视频'),
        new IndexButtonLike('id_2', '本地视频')
      );
      expect(buttons.length).assertEqual(2);
      expect(buttons[0].text).assertEqual('网络视频');
      expect(buttons[1].text).assertEqual('本地视频');
    });

    it(addCase(casePrefix + 'HttpNormalize_DefaultFallback_008'), 0, () => {
      // 业务逻辑：空对象输入时应填充默认安全值
      const result = normalizeHttpVideoList([new HttpVideoInputLike()]);
      expect(result[0].uri).assertEqual('');
      expect(result[0].url).assertEqual('');
      expect(result[0].displayName).assertEqual('');
      expect(result[0].resolutions.length).assertEqual(0);
    });

    /**
     * ========== 第二部分：LocalFolder/LocalVideo 业务规则 ==========
     * 背景：验证 USB 拔插场景、本地列表刷新与点击防御
     */
    it(addCase(casePrefix + 'FolderFocus_InvalidReset_009'), 0, () => {
      // 业务逻辑：文件夹列表变化后，非法焦点索引需重置
      const folderList = new FolderCardList(
        new FolderCardLike('f_1', '本地视频', 3),
        new FolderCardLike('f_3', 'USB设备', 1)
      );
      expect(clampFolderFocus(-1, folderList)).assertEqual(0);
      expect(clampFolderFocus(5, folderList)).assertEqual(0);
    });

    it(addCase(casePrefix + 'FolderFocus_EmptyCurrentReset_010'), 0, () => {
      // 业务逻辑：如果当前文件夹变为空（num=0），也应重置焦点
      const folderList = new FolderCardList(
        new FolderCardLike('f_1', '本地视频', 0),
        new FolderCardLike('f_3', 'USB设备', 2)
      );
      expect(clampFolderFocus(0, folderList)).assertEqual(0);
    });

    it(addCase(casePrefix + 'FolderFocus_LeftRightRule_011'), 0, () => {
      // 业务逻辑：模拟左右键切换文件夹分类
      expect(moveFolderFocus(0, 1, 2)).assertEqual(0);
      expect(moveFolderFocus(0, 2, 2)).assertEqual(1);
      expect(moveFolderFocus(1, 2, 2)).assertEqual(1);
      expect(moveFolderFocus(1, 1, 2)).assertEqual(0);
    });

    it(addCase(casePrefix + 'FolderEnter_GuardRule_012'), 0, () => {
      // 业务逻辑：USB 禁用、加载中、数量为 0 时均禁止进入
      expect(canEnterFolder(true, 2, true, 0)).assertEqual(false);
      expect(canEnterFolder(false, 0, true, 0)).assertEqual(false);
      expect(canEnterFolder(false, 2, false, 1)).assertEqual(false);
      expect(canEnterFolder(false, 2, true, 0)).assertEqual(true);
    });

    it(addCase(casePrefix + 'LocalVideoFocus_ClampRule_013'), 0, () => {
      // 业务逻辑：本地列表滚动索引保护
      expect(clampLocalVideoFocus(-2, 4)).assertEqual(0);
      expect(clampLocalVideoFocus(8, 4)).assertEqual(0);
      expect(clampLocalVideoFocus(2, 4)).assertEqual(2);
    });

    it(addCase(casePrefix + 'LocalVideoName_FollowsFocus_014'), 0, () => {
      // 业务逻辑：验证 UI 标题与当前选中项的名称联动
      const videoList = new LocalVideoList(
        new LocalVideoLike(undefined, 'movie-a.mp4'),
        new LocalVideoLike(undefined, 'movie-b.mp4')
      );
      expect(buildVideoName(videoList, 0)).assertEqual('movie-a.mp4');
      expect(buildVideoName(videoList, 1)).assertEqual('movie-b.mp4');
    });

    it(addCase(casePrefix + 'LocalVideoName_EmptyListFallback_015'), 0, () => {
      // 业务逻辑：空列表不应产生 displayName
      expect(buildVideoName(new LocalVideoList(), 0)).assertEqual('');
    });

    it(addCase(casePrefix + 'LocalVideoPlay_ThrottleRule_016'), 0, () => {
      // 业务逻辑：播放操作必须满足 800ms 间隔，防止 UI 响应过载
      expect(canPlayLocalVideo(true, 0, 1000)).assertEqual(false);
      expect(canPlayLocalVideo(false, 1000, 1500)).assertEqual(false);
      expect(canPlayLocalVideo(false, 1000, 1800)).assertEqual(true);
    });

    /**
     * ========== 第三部分：VideoPlayer 播放态与投屏规则 ==========
     * 背景：验证切集逻辑、投屏焦点管理与返回拦截
     */
    it(addCase(casePrefix + 'PrevVideo_WrapAround_017'), 0, () => {
      // 业务逻辑：切到上一集，若当前是第一集则跳到最后一集
      expect(prevVideoIndex(0, 3)).assertEqual(2);
      expect(prevVideoIndex(2, 3)).assertEqual(1);
    });

    it(addCase(casePrefix + 'NextVideo_WrapAround_018'), 0, () => {
      // 业务逻辑：切到下一集，若当前是最后一集则回第一集
      expect(nextVideoIndex(2, 3)).assertEqual(0);
      expect(nextVideoIndex(0, 3)).assertEqual(1);
    });

    it(addCase(casePrefix + 'VideoSwitch_ResetSpeedAndRotation_019'), 0, () => {
      // 业务逻辑：新视频开始时必须清理旧视频的倍速和旋转状态
      const state = createPlayerState();
      state.videoSpeed = 2;
      state.focusSpeedItemId = 's_2_1';
      state.rotationAngle = 270;
      const next = applyVideoSwitchReset(state);
      expect(next.videoSpeed).assertEqual(1);
      expect(next.focusSpeedItemId).assertEqual('s_2_4');
      expect(next.rotationAngle).assertEqual(0);
    });

    it(addCase(casePrefix + 'OpenTransferDialog_DefaultFocus_020'), 0, () => {
      // 业务逻辑：投屏框弹出后，默认焦点应落在第一个可用设备上
      const state = createPlayerState();
      const next = openTransferDialog(state, new TransferDeviceList(
        new TransferDeviceLike('dev-1'),
        new TransferDeviceLike('dev-2')
      ));
      expect(next.isTransferDialogShow).assertEqual(true);
      expect(next.focusBeforeTransferDialog).assertEqual('id_3');
      expect(next.transferFocusId).assertEqual('dev-1');
    });

    it(addCase(casePrefix + 'OpenTransferDialog_EmptyDeviceList_021'), 0, () => {
      // 业务逻辑：即使无设备，对话框也应能正常弹出并保持空焦点
      const next = openTransferDialog(createPlayerState(), new TransferDeviceList());
      expect(next.transferFocusId).assertEqual('');
      expect(next.isTransferDialogShow).assertEqual(true);
    });

    it(addCase(casePrefix + 'CloseTransferDialog_RestoreFocus_022'), 0, () => {
      // 业务逻辑：关闭对话框后应能正确恢复之前的页面焦点
      const state = openTransferDialog(createPlayerState(), new TransferDeviceList(new TransferDeviceLike('dev-1')));
      const next = closeTransferDialog(state, true);
      expect(next.isTransferDialogShow).assertEqual(false);
      expect(next.focusId).assertEqual('id_3');
    });

    it(addCase(casePrefix + 'CloseTransferDialog_FallbackFocus_023'), 0, () => {
      // 业务逻辑：如果之前的焦点不合法，复位到播放器安全区域（id_3）
      const state = createPlayerState();
      state.focusBeforeTransferDialog = 'id_5';
      const next = closeTransferDialog(state, true);
      expect(next.focusId).assertEqual('id_3');
    });

    it(addCase(casePrefix + 'StopTransferAndBackIntercept_Rules_024'), 0, () => {
      // 业务逻辑：物理键返回拦截逻辑
      expect(shouldStopTransfer('network-1')).assertEqual(true);
      expect(shouldStopTransfer('')).assertEqual(false);
      expect(shouldBackIntercept(false, false, false)).assertEqual(true);
      expect(shouldBackIntercept(true, true, false)).assertEqual(true);
      expect(shouldBackIntercept(true, false, false)).assertEqual(false);
    });

    it(addCase(casePrefix + 'CaseNamePattern_025'), 0, () => {
      // 业务逻辑：验证用例名称是否符合自动化流水线契约
      expect(allCaseNames.length).assertEqual(25);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_PageBusinessContract_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
