/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import ConfigData from '../common/ConfigData';
import LogUtil from '../utils/LogUtil';
import { KeyCode } from '@kit.InputKit';
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { SourceListController } from '../controller/SourceListController';
import { SourcePlugStateEntity } from '../entity/SourcePlugStateEntity';
import { MultiPageListenerManager, MultiPageListenerType } from '../manager/MultiPageListenerManager';
import { SourceManager, SourcePlugState } from '../manager/SourceManager';
import displaySetting from '@ohos.tvservice.displaySetting';
import { promptAction } from '@kit.ArkUI';
import { InputSourceUtil } from '../utils/InputSourceUtil';
import { missionManager } from '@kit.AbilityKit';
import { power } from '@kit.BasicServicesKit';
import { PointerUtil } from '../common/PointerUtil';
import { EventUtil } from '../common/EventUtil';
import { SourceType } from '../utils/StyleConstants';
const TAG = 'InputSource--->';
const  sourceToolMouseClick: number = 7;
const HDMI_RELATED_SOURCE_LIST: number[] = [
  SourceType.SOURCE_HDMI1,
  SourceType.SOURCE_HDMI2,
  SourceType.SOURCE_HDMI3,
  SourceType.SOURCE_HDMI4,
  SourceType.SOURCE_CVBS1,
  SourceType.SOURCE_GRAPHIC
];
// 1. 定义常量，消除魔法值，统一配置（后续新增HDMI仅需修改该配置，无需改业务逻辑）
const HDMI_CONFIG_MAP = new Map<number, string>([
  [1, 'HDMI1'],
  [2, 'HDMI2'],
  [3, 'HDMI3'],
  [4, 'HDMI4']
]);
const SOURCE_ID_REBOOT_KEY = 'sourceId_reboot';
const DEFAULT_SOURCE_ID_VALUE = -1;
const HDMI_PAGE_URL = 'pages/HdmiPage';
export interface HDMIINInfo {
  name: string;
  status: boolean;
  visibility: boolean;
}

interface SourceRouteParams {
  sourceId: number;
}

export interface IndexNavigationDecision {
  action: 'navigateHdmi' | 'navigateDtv' | 'toast' | 'none';
  sourceId: number;
  withDelay: boolean;
  toastMessage: string;
}

export interface IndexFocusDecision {
  nextFocusIndex: number;
  shouldScroll: boolean;
  scrollTarget: number;
}

export interface IndexInitialFocusDecision {
  defaultSourceId: number;
  focusIndex: number;
  focusSourceId: number;
  shouldScroll: boolean;
  scrollTarget: number;
}

export interface HdmiInCapabilityProvider {
  getSupportSourceList: () => Promise<number[]>;
  isHdmiRxEnable: (portId: number) => Promise<boolean>;
}

/**
 * Resolves whether an index-page touch interaction should continue to selection.
 *
 * @param isTouchEvent Whether the event passed the generic touch-event filter.
 * @param sourceTool Touch source tool value.
 * @returns boolean `true` when the page should continue handling selection.
 */
export function shouldHandleIndexTouchSelection(isTouchEvent: boolean, sourceTool: number): boolean {
  if (!isTouchEvent) {
    return false;
  }
  return sourceTool === SourceTool.Pen || sourceTool === sourceToolMouseClick;
}

/**
 * Resolves where the input-source page should navigate for a selected source.
 *
 * @param sourceId Selected input source id.
 * @param hdmiInList HDMI capability list cached in AppStorage.
 * @param withDelay Whether the resulting navigation should be delayed.
 * @returns IndexNavigationDecision Page navigation or toast decision.
 */
export function resolveIndexNavigationDecision(
  sourceId: number,
  hdmiInList: HDMIINInfo[],
  withDelay: boolean = false
): IndexNavigationDecision {
  if (sourceId === 6) {
    return {
      action: 'navigateDtv',
      sourceId,
      withDelay,
      toastMessage: ''
    };
  }

  if (!HDMI_RELATED_SOURCE_LIST.includes(sourceId)) {
    return {
      action: 'none',
      sourceId,
      withDelay,
      toastMessage: ''
    };
  }

  if (hdmiInList.length <= 0) {
    return {
      action: 'navigateHdmi',
      sourceId,
      withDelay,
      toastMessage: ''
    };
  }

  const hdmiName = HDMI_CONFIG_MAP.get(sourceId);
  if (!hdmiName) {
    return {
      action: 'navigateHdmi',
      sourceId,
      withDelay,
      toastMessage: ''
    };
  }

  const hdmiObj = hdmiInList.find(item => item.name === hdmiName);
  if (hdmiObj?.status === false) {
    return {
      action: 'toast',
      sourceId,
      withDelay,
      toastMessage: `请打开设置${hdmiName}输入开关!`
    };
  }

  return {
    action: 'navigateHdmi',
    sourceId,
    withDelay,
    toastMessage: ''
  };
}

/**
 * Computes the next focus index and scroll target for left or right navigation.
 *
 * @param currentFocusIndex Current focused item index.
 * @param centerIndex Current visible center index.
 * @param listLength Source list length.
 * @param direction Horizontal navigation direction.
 * @returns IndexFocusDecision Updated focus and scroll intent.
 */
export function resolveIndexFocusMove(
  currentFocusIndex: number,
  centerIndex: number,
  listLength: number,
  direction: 'left' | 'right'
): IndexFocusDecision {
  if (listLength <= 0) {
    return {
      nextFocusIndex: currentFocusIndex,
      shouldScroll: false,
      scrollTarget: currentFocusIndex
    };
  }

  let nextFocusIndex = currentFocusIndex;
  if (direction === 'left') {
    nextFocusIndex = currentFocusIndex > 0 ? currentFocusIndex - 1 : 0;
  } else {
    nextFocusIndex = currentFocusIndex < listLength - 1 ? currentFocusIndex + 1 : listLength - 1;
  }

  const shouldScroll = !(nextFocusIndex >= centerIndex - 2 && nextFocusIndex <= centerIndex + 2);
  return {
    nextFocusIndex,
    shouldScroll,
    scrollTarget: direction === 'left' ? nextFocusIndex : nextFocusIndex - 4
  };
}

/**
 * Resolves the initial focus and scroll position after loading the source list.
 *
 * @param sourceIds Ordered source ids rendered by the page.
 * @param defaultSourceId Stored default source id.
 * @param centerIndex Current center index reported by the list.
 * @returns IndexInitialFocusDecision Initial focus and scroll intent.
 */
export function resolveIndexInitialFocus(
  sourceIds: number[],
  defaultSourceId: number,
  centerIndex: number
): IndexInitialFocusDecision {
  const focusIndex = sourceIds.findIndex(item => item === defaultSourceId);
  const safeFocusIndex = focusIndex >= 0 ? focusIndex : 0;
  const focusSourceId = sourceIds.length > 0 ? sourceIds[safeFocusIndex] : defaultSourceId;
  const shouldScroll = !(safeFocusIndex >= centerIndex - 2 && safeFocusIndex <= centerIndex + 2);
  return {
    defaultSourceId,
    focusIndex: safeFocusIndex,
    focusSourceId,
    shouldScroll,
    scrollTarget: safeFocusIndex - 4
  };
}

/**
 * Builds the visible HDMI capability list from supported ports and status map.
 *
 * @param supportedSourceList Source ids reported as supported by display service.
 * @param statusMap HDMI enable status keyed by port id.
 * @returns HDMIINInfo[] Visible HDMI port list stored in AppStorage.
 */
export function buildVisibleHdmiInList(supportedSourceList: number[], statusMap: Map<number, boolean>): HDMIINInfo[] {
  const usbPortNames: string[] = ['HDMI1', 'HDMI2', 'HDMI3', 'HDMI4'];
  const keepThese: number[] = [1, 2, 3, 4];
  const filteredArray = supportedSourceList.filter(item => keepThese.includes(item));
  const usbPortList: HDMIINInfo[] = [];

  for (let i = 1; i <= 4; i++) {
    const isSupported = filteredArray.includes(i);
    usbPortList.push({
      name: usbPortNames[i - 1],
      status: isSupported ? (statusMap.get(i) ?? false) : false,
      visibility: isSupported
    });
  }

  return usbPortList.filter(port => port.visibility);
}

/**
 * Queries HDMI capability data and converts it into the visible AppStorage shape.
 *
 * @param provider Async provider used to read supported ports and enable states.
 * @returns Promise<HDMIINInfo[]> Visible HDMI capability list.
 */
export async function resolveVisibleHdmiInList(provider: HdmiInCapabilityProvider): Promise<HDMIINInfo[]> {
  const maxUsbPorts = 4;
  try {
    const supportedUsbList = await provider.getSupportSourceList();
    const keepThese: number[] = [1, 2, 3, 4];
    const filteredArray = supportedUsbList.filter(item => keepThese.includes(item));
    if (filteredArray.length <= 0) {
      return [];
    }

    const statusMap = new Map<number, boolean>();
    const checkPromises = filteredArray.map(async (portId: number) => {
      if (portId >= 1 && portId <= maxUsbPorts) {
        try {
          const status = await provider.isHdmiRxEnable(portId);
          statusMap.set(portId, status);
        } catch {
          statusMap.set(portId, false);
        }
      }
    });
    await Promise.all(checkPromises);
    return buildVisibleHdmiInList(supportedUsbList, statusMap);
  } catch {
    return [];
  }
}
@Entry
@Component
struct Index {
  private onceStandbyCallback?: () => void;
  private onceSelectSourceCallback?: (sourceType: displaySetting.SourceType) => void;
  @State focusIndex: number = -1;
  scroller: Scroller = new Scroller();
  controller: SourceListController = new SourceListController();
  @State sourceList: SourcePlugStateEntity[] = [];
  @State defaultSource: number = -1;
  @State focusSource: number = 1;
  @State CenterIndex:number=0
  private multiPageListener: MultiPageListenerType = {
    id: 'sourceSelectPage',
    onPlugChange: async (plugState: SourcePlugState): Promise<void> => {
      let sourcePlugState: SourcePlugState = plugState as SourcePlugState;
      // 更新列表接入状态
      for (let item of this.sourceList) {
        if (item.getSourceId() === sourcePlugState.source) {
          item.setIsPlugIn(sourcePlugState.isPluIn);
        }
      }
    }
  }
  missionId:number = -1;

  getSrcNameById(id: number): string {
    for (let item of this.sourceList) {
      if (item.getSourceId() === id) {
        return item.getSourceName();
      }
    }
    return 'hdmi1';
  }

  getSrcIdByName(name: string): number {
    for (let item of this.sourceList) {
      if (item.getSourceName() === name) {
        return item.getSourceId();
      }
    }
    return -1;
  }

  async aboutToAppear() {
    console.log(TAG, 'InputSourceComponent:  aboutToAppear in');
    this.sourceList = await this.controller.getSourceList();

    // 更新cec设备信息
    this.controller.updateSourceInfo(this.sourceList);
    // 注册输入源状态变化监听
    MultiPageListenerManager.getInStance().register(this.multiPageListener);
    // 输入源状态变化事件
    SourceManager.onEvent();
    this.controller.registerDeviceChange(this.sourceList);
    PointerUtil.changePointStyle(false);
    this.registerCecListeners();
    this.defaultSource = this.getSrcIdByName(this.controller.getDefaultSource());
    console.log(TAG, `defaultSource: ` + this.defaultSource);
    const focusDecision = resolveIndexInitialFocus(
      this.sourceList.map(item => item.getSourceId()),
      this.defaultSource,
      this.CenterIndex
    );
    this.focusIndex = focusDecision.focusIndex;
    this.focusSource = focusDecision.focusSourceId;
    if (focusDecision.shouldScroll) {
      this.scrollToIndex(focusDecision.scrollTarget);
    }
  }
  /**
   * 注册 CEC 待机与信源切换监听，统一处理外部设备唤起后的页面跳转。
   * @returns void 无返回值。
   */
  registerCecListeners(): void {
    // 待机事件
    try {
      this.onceStandbyCallback = () => {
        console.log(TAG, 'CEC standby received');
        try {
          power.suspend();
        console.log(TAG, 'onCecStandByCallback suspend succeeded');
        } catch {
          console.log(TAG, 'onCecStandByCallback suspend1 failed.');
        }
      };
      // 使用新的 on 接口注册
      displaySetting.on('CecStandBy', this.onceStandbyCallback);
    } catch {
      console.error(TAG, 'CEC standby registration failed');
    }

    // 源选择事件
    try {
      this.onceSelectSourceCallback = (sourceType: displaySetting.SourceType | SourceType) => {
        console.log(TAG, `CEC source select: ${sourceType}`);
          // 当接收到CEC选择源命令时，更新焦点到对应的输入源
          const index = this.sourceList.findIndex(item => item.getSourceId() == sourceType);
          if (index !== -1) {
            this.focusIndex = index;
            this.focusSource = sourceType;
            this.scrollToIndex(index);
            const usbList: HDMIINInfo[] = AppStorage.get<HDMIINInfo[]>('GetSupportHDMIINList') || [];
            const navigationDecision = resolveIndexNavigationDecision(sourceType, usbList, true);
            if (navigationDecision.action === 'navigateDtv') {
              setTimeout(() => {
                router.pushUrl(
                  { url: 'pages/IndexDtv', params: { sourceId: sourceType } },
                  router.RouterMode.Single
                );
              }, 2000);
            } else if (navigationDecision.action === 'navigateHdmi') {
              this.navigateToHdmiPage(sourceType, true);
            } else if (navigationDecision.action === 'toast') {
              this.showToastMessage(navigationDecision.toastMessage);
            }
          }
      };
      // 使用新的 on 接口注册
      displaySetting.on('CecSelectSource', this.onceSelectSourceCallback);
    } catch {
      console.error(TAG, 'CEC source select registration failed');
    }
  }

  /**
   * 查询最近任务列表并缓存拉起来源任务 ID，供返回逻辑复用。
   * @returns Promise<void> 异步完成任务 ID 查询。
   */
  async getMission(): Promise<void> {
    try {
      const missions = await missionManager.getMissionInfos('', 10);
      LogUtil.info(`HmLog missions = ${JSON.stringify(missions)}`);
      missions.forEach((item) => {
        if (item.want.abilityName === 'EntryAbility' && item.want.bundleName === 'com.ohos.inputsource') {
          return;
        }
        if (globalThis.pullBundleName == item.want.bundleName) {
          this.missionId = item.missionId;
          console.log(TAG, JSON.stringify(item));
        }
      });
      LogUtil.info(`HmLog missionId=${this.missionId}`);
    } catch {
      LogUtil.info('HmLog missions err');
    }
  }

  onPageShow(): void {
    void this.getMission();
    void this.getHDMIIN();
  }
  /**
   * 获取 HDMI 输入源开关与可见性列表，并写入 `AppStorage` 供页面跳转判断。
   * @returns Promise<void> 异步完成 HDMI 能力刷新。
   */
  async getHDMIIN(): Promise<void> {
    try {
      const visibleUsbPortList = await resolveVisibleHdmiInList({
        getSupportSourceList: async (): Promise<number[]> => {
          const supportedUsbList: number[] = await displaySetting.GetSupportSourceList();
          LogUtil.log(`${TAG} displaySetting GetSupportHDMIINList Success: ${JSON.stringify(supportedUsbList)}`);
          return supportedUsbList;
        },
        isHdmiRxEnable: async (portId: number): Promise<boolean> => {
          try {
            const status: boolean = await displaySetting.IsHDMIRXEnable(portId);
            LogUtil.log(`${TAG} displaySetting HDMI输入 IsHDMIRXEnable${portId} status: ${status}`);
            return status;
          } catch (error) {
            LogUtil.log(`${TAG} displaySetting HDMI输入 ${portId} check failed: ${JSON.stringify(error)}`);
            // ArkTS limits thrown values; wrap unknown native/JS errors into a standard Error.
            throw new Error(`${TAG} IsHDMIRXEnable(${portId}) failed: ${JSON.stringify(error)}`);
          }
        }
      });
      console.log(JSON.stringify(visibleUsbPortList),'displaySetting visibleUsbPortList aboutToAppear');
      this.setSupportHdmiInList(visibleUsbPortList);
    } catch {
      LogUtil.log(`${TAG} displaySetting.GetSupportSourceList failed`);
      this.setSupportHdmiInList([]);
    }
  }
  /**
   * 处理返回键，优先回到拉起方任务，否则执行页面返回。
   * @returns boolean | void 返回 `true` 表示拦截，其余场景直接回退。
   */
  onBackPress(): boolean | void {
    if (globalThis.pullBundleName) {
      if (globalThis.pullBundleName === 'com.ohos.launcher') {
        router.back();
      } else {
        console.log(TAG, `moveMissionToFront missionId:${this.missionId}`);
        void missionManager.moveMissionToFront(this.missionId)
          .then((): void => {
            console.info(TAG, 'moveMissionToFront successfully');
          })
          .catch((error: BusinessError): void => {
            console.error(TAG, `moveMissionToFront failed:${error.message}`);
          });
      }
    } else {
      router.back();
    }
    return true;
  }

  aboutToDisappear(): void {
    MultiPageListenerManager.getInStance().unregister(this.multiPageListener);
    this.controller.unRegisterDeviceChange();
    SourceManager.offEvent();
    this.unregisterCecListeners();
  }
  /**
   * 注销已注册的 CEC 监听，避免页面销毁后残留回调。
   * @returns void 无返回值。
   */
  unregisterCecListeners(): void {
    // 待机事件
    if (this.onceStandbyCallback) {
      try {
        // 使用新的 off 接口注销
        displaySetting.off('CecStandBy', this.onceStandbyCallback);
      } catch {
        console.error(TAG, 'CEC standby unregistration failed');
      } finally {
        this.onceStandbyCallback = undefined;
      }
    }

    // 源选择事件
    if (this.onceSelectSourceCallback) {
      try {
        // 使用新的 off 接口注销
        displaySetting.off('CecSelectSource', this.onceSelectSourceCallback);
      } catch {
        console.error(TAG, 'CEC source select unregistration failed');
      } finally {
        this.onceSelectSourceCallback = undefined;
      }
    }
  }

  /**
   * 设置默认源
   */
  setDefault() {
    const result = this.controller.setDefaultSource(this.getSrcNameById(this.focusSource));
    console.log(TAG, `name:` + this.getSrcNameById(this.focusSource));
    if (result) {
      this.defaultSource = this.focusSource;
      console.log(TAG, `defaultSource:` + this.defaultSource);
    }
  }

  /**
   * 构造带显式参数类型的路由配置，规避 ArkTS 未声明对象字面量报错。
   * @param url 页面路由地址。
   * @param sourceId 当前输入源 ID。
   * @returns router.RouterOptions 可直接用于 `router.pushUrl` 的配置对象。
   */
  private createRouteOptions(url: string, sourceId: number): router.RouterOptions {
    const params: SourceRouteParams = { sourceId };
    return { url, params };
  }

  /**
   * 统一显示提示文案，避免重复构造未声明的提示对象。
   * @param message 提示内容。
   * @returns void 无返回值。
   */
  private showToastMessage(message: string): void {
    const toastOptions: promptAction.ShowToastOptions = { message };
    try {
      promptAction.showToast(toastOptions);
    } catch (error) {
      const businessError = error as BusinessError;
      LogUtil.warn(`showToast failed: ${businessError.code}`);
    }
  }

  /**
   * 将 HDMI 列表按显式类型写入 `AppStorage`，供后续跳转逻辑读取。
   * @param list HDMI 输入源状态列表。
   * @returns void 无返回值。
   */
  private setSupportHdmiInList(list: HDMIINInfo[]): void {
    AppStorage.setOrCreate<HDMIINInfo[]>('GetSupportHDMIINList', list);
  }

  /**
   * 安全执行页面跳转，避免路由异常中断当前输入源页面逻辑。
   * @param options 路由参数。
   * @returns void 无返回值。
   */
  private pushRouteSafely(options: router.RouterOptions): void {
    try {
      router.pushUrl(options, router.RouterMode.Single);
    } catch (error) {
      const businessError = error as BusinessError;
      LogUtil.warn(`router.pushUrl failed: ${businessError.code}`);
    }
  }

  /**
   * 跳转到 HDMI 页面，并根据场景决定是否延迟执行。
   * @param sourceId 当前输入源 ID。
   * @param withDelay 是否延迟跳转。
   * @returns void 无返回值。
   */
  navigateToHdmiPage(sourceId: number, withDelay: boolean = false): void {
    // 提取公共跳转逻辑为内部函数，消除重复代码
    const coreNavigateLogic = (): void => {
      AppStorage.setOrCreate<number>(SOURCE_ID_REBOOT_KEY, DEFAULT_SOURCE_ID_VALUE);
      this.pushRouteSafely(this.createRouteOptions(HDMI_PAGE_URL, sourceId));
    };

    // 根据是否需要延迟，执行对应的逻辑
    if (withDelay) {
      // 延迟 2000ms 执行公共逻辑（对应原 navigateToHdmiPageType 方法）
      setTimeout(coreNavigateLogic, 2000);
    } else {
      // 立即执行公共逻辑（对应原 navigateToHdmiPage 方法）
      coreNavigateLogic();
    }
  }

  /**
   * 按输入源类型跳转到目标页面，并在 HDMI 场景下校验开关状态。
   * @param sourceId 当前输入源 ID。
   * @returns void 无返回值。
   */
  jumpToPlayerPage(sourceId: number): void {
    const usbList: HDMIINInfo[] = AppStorage.get<HDMIINInfo[]>('GetSupportHDMIINList') || [];
    const navigationDecision = resolveIndexNavigationDecision(sourceId, usbList);
    if (navigationDecision.action === 'navigateDtv') {
      this.pushRouteSafely(this.createRouteOptions('pages/IndexDtv', sourceId));
      return;
    }
    if (navigationDecision.action === 'navigateHdmi') {
      this.navigateToHdmiPage(sourceId);
      return;
    }
    if (navigationDecision.action === 'toast') {
      this.showToastMessage(navigationDecision.toastMessage);
    }
  }
  scrollToIndex(index: number): void {
    // 在实际应用中，这里需要实现滚动逻辑
    // 可以使用ScrollController的scrollToIndex方法
    console.log(TAG, `滚动到索引: ${index}`);
    this.scroller.scrollToIndex(index);
  }

  build() {
    Column() {
      Stack() {
          Row() {
            List({ scroller: this.scroller }){
              ForEach(this.sourceList, (item: SourcePlugStateEntity, index: number) => {
                ListItem(){
                  SourceItem({
                    item: item,
                    index: index,
                    focusIndex: this.focusIndex,
                    defaultSource: this.defaultSource
                  });
                }
                .height('330lpx')
                .onHover(() => {
                  this.focusIndex = index;
                  this.focusSource = this.sourceList[this.focusIndex].getSourceId();
                  this.scrollToIndex(this.focusIndex);
                })
                .onTouch((event?: TouchEvent) => {
                  if (!event) {
                    return;
                  }
                  this.focusIndex = index;
                  this.focusSource = this.sourceList[this.focusIndex].getSourceId();
                  if (!EventUtil.isTouchEvent(event)) {
                    return;
                  }
                  if (!shouldHandleIndexTouchSelection(true, event.sourceTool)) {
                    return;
                  }
                })
                .gesture(
                  // 长按1s设置默认输入源
                  LongPressGesture({ duration: 1000 })
                  // 由于repeat设置为true，长按动作存在时会连续触发，触发间隔为duration（默认值500ms）
                    .onAction((event: GestureEvent) => {
                      if (event) {
                        if (this.focusSource) {
                          this.showToastMessage('设置为默认输入源' + this.focusSource);
                          this.setDefault();
                        }
                      }
                    })
                )
                .onClick(()=>{
                  this.focusIndex=index;
                  this.focusSource = this.sourceList[this.focusIndex].getSourceId();
                  focusControl.requestFocus(`${this.focusIndex}`);
                  if (this.focusSource) {
                    // todo 是否持久化
                    this.jumpToPlayerPage(this.focusSource);
                  }
                });
              },(item: SourcePlugStateEntity) => JSON.stringify(item));
            }.width('95%').height('100%').focusable(true).scrollBar(BarState.Off).listDirection(Axis.Horizontal)
            .onScrollIndex((startIndex: number, endIndex: number, centerIndex: number): void => {
              void startIndex;
              void endIndex;
              this.CenterIndex = centerIndex;
            });
          }
          .width('100%')
          .height(ConfigData.WH_100_100)
          .margin({ top: '366lpx' });

        Text('按菜单键或触控长按可将所选项设为开机默认输入源')
          .fontSize('36lpx')
          .lineHeight('42lpx')
          .fontColor('#dbffffff')
          .margin({
            top: '60lpx',
            right: '96lpx'
          });
      }
      .alignContent(Alignment.TopEnd);
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
    .backgroundColor('#18181A')
    .onKeyEvent((event?: KeyEvent) => {
      if (!event) {
        return;
      }
      if (this.sourceList.length === 0) {
        return;
      }
      if (event.keyCode == KeyCode.KEYCODE_DPAD_LEFT && event.type == KeyType.Up) {
        if (this.focusIndex !== 0) {
          const focusDecision = resolveIndexFocusMove(this.focusIndex, this.CenterIndex, this.sourceList.length, 'left');
          this.focusIndex = focusDecision.nextFocusIndex;
          this.focusSource = this.sourceList[this.focusIndex].getSourceId();
          focusControl.requestFocus(`${this.focusIndex}`);
          if (focusDecision.shouldScroll) {
            this.scrollToIndex(focusDecision.scrollTarget);
          }
        }
      }
      if (event.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && event.type == KeyType.Up) {
        if (this.focusIndex !== this.sourceList.length - 1) {
          const focusDecision = resolveIndexFocusMove(this.focusIndex, this.CenterIndex, this.sourceList.length, 'right');
          this.focusIndex = focusDecision.nextFocusIndex;
          this.focusSource = this.sourceList[this.focusIndex].getSourceId();
          focusControl.requestFocus(`${this.focusIndex}`);
          if (focusDecision.shouldScroll) {
            this.scrollToIndex(focusDecision.scrollTarget);
          }
        }
      }

      // 确认键进入选中源页面
      if (event.keyCode == KeyCode.KEYCODE_ENTER && event.type == KeyType.Down) {
        if (this.focusSource) {
          // todo 是否持久化
          this.jumpToPlayerPage(this.focusSource);
        }
      }

      // 按菜单键设置为默认输入源
      if (event.keyCode === KeyCode.KEYCODE_MENU && event.type == KeyType.Up) {
        if (this.focusSource) {
          this.showToastMessage('设置为默认输入源' + this.focusSource);
          this.setDefault();
        }
      }

    });
  }
}

@Component
struct SourceItem {
  @ObjectLink item: SourcePlugStateEntity
  index: number = -1;
  @Prop focusIndex: number = -1
  @Prop defaultSource: number = -1

  build() {
    Column({ space: '12lpx' }) {
      Row() {
        if (this.focusIndex === this.index) {
          Image(InputSourceUtil.getSourceIcon(this.item.getSourceId(), true))
            .width('184lpx')
            .height('184lpx');
        } else {
          Image(InputSourceUtil.getSourceIcon(this.item.getSourceId(), false))
            .width('160lpx')
            .height('160lpx');
        }
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .width('184lpx')
      .height('184lpx');

      Column({ space: '12lpx' }) {
        Text(this.item.getSourceName())
          .fontSize('36lpx')
          .lineHeight('42lpx')
          .fontColor(this.item.getIsPlugIn() ? '#dbffffff' : '#99FFFFFF');

        Text(this.item.getIsPlugIn() ? '已接入' : '未接入')
          .fontSize('24lpx')
          .lineHeight('28lpx')
          .fontColor(this.item.getIsPlugIn() ? '#dbffffff' : '#99FFFFFF');

        if (this.defaultSource && this.defaultSource === this.item.getSourceId()) {
          Text('默认')
            .fontSize('24lpx')
            .lineHeight('28lpx')
            .fontColor('#DBFFFFFF')
            .padding({
              top: '6lpx',
              bottom: '6lpx',
              left: '24lpx',
              right: '24lpx'
            })
            .backgroundColor('#66FFFFFF')
            .borderRadius('100lpx');
        }
      }
    }
    .width('200lpx')
    .height('330lpx')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .margin({ left: '80lpx', right: '80lpx' });
  }
}
