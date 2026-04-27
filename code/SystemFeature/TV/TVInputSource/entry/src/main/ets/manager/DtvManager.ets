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

import * as TvSdkDtv from '../sdk/DtvSdk';
import { KeyCode, KeyEvent } from '@kit.InputKit';

const TAG = 'DtvManager';
const languageKey: string = 'au8SystemLanguage';
const languageValue: string = 'zuo';
const MODE_KEY = 'u32defaultlcnmode';
const MODE_VALUE = 2;
const SPLIT_NUM = 10;
const SERVICE_TYPE_RADIO = 0X02;
const SERVICE_TYPE_FM_RADIO = 0X07;
const SERVICE_TYPE_ADVANCED_RADIO = 0X0A;
const ERROR = -1;

export class DtvManager {
  //DTV相关实例
  private static dtvComm: TvSdkDtv.DtvComm;
  private static dtvCfg: TvSdkDtv.DtvCfg;
  private static dtvFrontend: TvSdkDtv.DtvFrontend;
  private static dtvAv: TvSdkDtv.DtvAv;
  private static programManager: TvSdkDtv.ProgramManager;
  private static dtvEpg: TvSdkDtv.DtvEpg;

  private constructor() {
  }

  /**
   * DTV初始化
   */
  public static init(): void {
    DtvManager.prepare();
    DtvManager.dtvConfigSet();
  }

  /**
   * 获取DtvCfg实例
   */
  public static getDtvCfg(): TvSdkDtv.DtvCfg {
    if (!DtvManager.dtvCfg) {
      DtvManager.dtvCfg = TvSdkDtv.createDtvCfg();
    }
    return DtvManager.dtvCfg;
  }

  /**
   * 获取DtvComm实例
   */
  public static getDtvComm(): TvSdkDtv.DtvComm {
    if (!DtvManager.dtvComm) {
      DtvManager.dtvComm = TvSdkDtv.createDtvComm();
    }
    return DtvManager.dtvComm;
  }

  /**
   * 获取DtvFrontend实例
   */
  public static getDtvFrontend(): TvSdkDtv.DtvFrontend {
    if (!DtvManager.dtvFrontend) {
      DtvManager.dtvFrontend = TvSdkDtv.createDtvFrontend();
    }
    return DtvManager.dtvFrontend;
  }

  /**
   * 获取DtvAv实例
   */
  public static getDtvAv(): TvSdkDtv.DtvAv {
    if (!DtvManager.dtvAv) {
      DtvManager.dtvAv = TvSdkDtv.createDtvAv();
    }
    return DtvManager.dtvAv;
  }

  /**
   * 获取ProgramManager实例
   */
  public static getProgramManager(): TvSdkDtv.ProgramManager {
    if (!DtvManager.programManager) {
      DtvManager.programManager = TvSdkDtv.createDtvProgramManager();
    }
    return DtvManager.programManager;
  }

  /**
   * 获取DtvEpg实例
   */
  public static getDtvEpg(): TvSdkDtv.DtvEpg {
    if (!DtvManager.dtvEpg) {
      DtvManager.dtvEpg = TvSdkDtv.createDtvEpg();
    }
    return DtvManager.dtvEpg;
  }

  /**
   * 初始化DTV协议栈
   */
  public static prepare(): void {
    let result: number = DtvManager.getDtvComm().prepare();
    console.log(TAG, 'prepare , result :' + result);
  }

  /**
   * 执行自动搜台
   */
  public static channelAutoScan(): void {
    DtvManager.commonSetParam();
    let result: number = DtvManager.getDtvFrontend().autoScan();
    console.log(TAG, 'autoScan result: ' + result);
  }

  /**
   * 执行手动搜台
   */
  public static channelManualScan(): void {
    DtvManager.commonSetParam();
    let result: number = DtvManager.getDtvFrontend().manualScan();
    console.log(TAG, 'manualScan result: ' + result);
  }

  private static commonSetParam(): void {
    let result: number;
    result = DtvManager.getDtvComm().setSourceType(TvSdkDtv.FeAntennaType.FE_ANTENNA_DTMB);
    console.log(TAG, 'setSourceType result: ' + result);

    result = DtvManager.getDtvFrontend().setAntennaType(TvSdkDtv.FeAntennaType.FE_ANTENNA_DTMB);
    console.log(TAG, 'setAntennaType result: ' + result);

    result = DtvManager.getDtvFrontend()
      .setScanAttr(TvSdkDtv.FeScanCaType.FE_SCAN_CA_ALL, TvSdkDtv.FeScanProgType.FE_SCAN_PROG_ALL);
    console.log(TAG, 'setScanAttr result: ' + result);
  }

  /**
   *终止自动搜台
   */
  public static abortScan(): void {
    let result: number = DtvManager.getDtvFrontend().abortScan();
    console.log(TAG, 'abortScan result: ' + result);
  }

  /**
   * 打开AV实例 0-成功,-1-失败
   */
  public static dtvAvOpen(): number {
    let result: number = -1;
    result = DtvManager.getDtvAv().open();
    console.log(TAG, 'dtvAvOpen result: ' + result);
    return result;
  }

  /**
   * 关闭AV实例
   */
  public static dtvAvClose(): void {
    let result: number = DtvManager.getDtvAv().close();
    console.log(TAG, 'dtvAvClose result: ' + result);
  }

  /**
   * 播放AV实例
   * @param channelId 频道ID
   * @param isShow 是否展示音画
   * @returns 0-成功，-1-失败
   */
  public static dtvAvStart(channelId: number, isShow: boolean): number {
    let result: number = -1;
    result = DtvManager.getDtvAv().start(channelId, isShow);
    console.log(TAG, 'dtvAvStart result: ', result, channelId, '' + isShow);
    return result;
  }

  /**
   * 执行默认播放（从播放列表中选择第一个播放）
   * @returns 0-成功，-1-失败
   */
  public static dtvDefaultChannelPlay(): number {
    let result: number = -1;
    let channelList = DtvManager.getChannelList();
    if (!channelList || channelList.length === 0) {
      console.log(TAG, 'dtvDefaultChannelPlay channelList is null ');
      return result;
    }
    if (DtvManager.dtvAvOpen() !== 0) {
      return result;
    }
    return DtvManager.dtvAvStart(channelList[0].channelID, true);
  }

  /**
   * 执行频点默认播放（从播放列表中选择第一个播放）
   * @param channelId
   * @returns 0-成功，-1-失败
   */
  public static dtvFirstFreqChannelPlay(channelId: number): number {
    let result: number = -1;
    if (DtvManager.dtvAvOpen() !== 0) {
      return result;
    }
    return DtvManager.dtvAvStart(channelId, true);
  }

  /**
   * 播放上次的频道ID
   * @returns 0-成功，-1-失败
   */
  public static dtvLastChannelPlay(): number {
    let result: number = -1;
    let lastChannelID: number | undefined = DtvManager.getProgramManager().getLastChannelID();
    console.log(TAG, 'getLastChannelID: ' + lastChannelID);
    if (lastChannelID === undefined) {
      return result;
    }
    result = DtvManager.dtvAvOpen();
    if (result !== 0) {
      return result;
    }
    return DtvManager.dtvAvStart(lastChannelID, true);
  }

  /**
   * 根据按键播放上一个/下一个频道
   * @param event 按键事件
   */
  public static dtvNextChannelPlay(event: KeyEvent): void {
    let channelList: TvSdkDtv.PmChannel[] = DtvManager.getChannelList();
    if (!channelList || channelList.length === 0) {
      console.log(TAG, 'searchEndProcess channelList is null');
      return;
    }

    //获取切换频道ID
    let currentChannelId = DtvManager.getCurrentChannelId();
    let nextIndex = 0;
    for (let index = 0; index < channelList.length; index++) {
      if (currentChannelId === channelList[index].channelID) {
        if (event.key.code === KeyCode.KEYCODE_DPAD_DOWN) {
          nextIndex = (index + 1) % channelList.length;
        } else {
          nextIndex = ((index - 1) % channelList.length + channelList.length) % channelList.length;
        }
        console.log(TAG, 'index: ,nextIndex: ', index, nextIndex);
        break;
      }
    }
    if (nextIndex >= 0 && nextIndex < channelList.length) {
      let nextChannelId: number = channelList[nextIndex].channelID;
      console.log(TAG, 'nextChannelId: ', nextChannelId);
      DtvManager.dtvAvChannelChange(nextChannelId, true);
    }
  }

  /**
   * 删除频道
   */
  public static deleteCurChannel(): boolean {
    let channelList: TvSdkDtv.PmChannel[] = DtvManager.getChannelList();
    let curChannelId: number = DtvManager.getCurrentChannelId();
    let curChannel: TvSdkDtv.PmChannel | undefined = DtvManager.getProgramManager().getChannelByID(curChannelId);
    if (!curChannelId) {
      console.log(TAG, 'invalid channel');
      return true;
    }
    if (curChannel === undefined) {
      console.log(TAG, 'current channel is undefined');
      return true;
    }
    let nextChannel: TvSdkDtv.PmChannel | undefined = DtvManager.getNextChannel(channelList, curChannelId);
    if (nextChannel && (nextChannel.channelID !== curChannel.channelID)) {
      DtvManager.dtvAvChannelChange(nextChannel.channelID, true);
      DtvManager.getProgramManager().delChannelByID(curChannel.channelID);
      DtvManager.saveChannel();
      return false;
    } else {
      DtvManager.getProgramManager().delChannelByID(curChannel.channelID);
      DtvManager.saveChannel();
      DtvManager.getDtvAv().close();
    }
    return true;
  }

  public static getNextChannel(tempCurList: TvSdkDtv.PmChannel[] | undefined,
    currentChannelId: number): TvSdkDtv.PmChannel | undefined {
    if (!tempCurList || tempCurList.length === 0) {
      return undefined;
    }
    //获取切换频道的ID
    let nextIndex: number = 0;
    for (let index = 0; index < tempCurList.length; index++) {
      if (currentChannelId === tempCurList[index].channelID) {
        nextIndex = (index + 1) % tempCurList.length;
        console.log(TAG, 'getNextChannel index : ', index, nextIndex);
        break;
      }
    }
    if (nextIndex >= 0 && nextIndex < tempCurList.length) {
      return tempCurList[nextIndex];
    }
    return undefined;
  }

  /**
   * 变更播放频道
   * @param channelId 频道ID
   * @param isShow 是否展示音画
   */
  public static dtvAvChannelChange(channelId: number, isShow: boolean): void {
    //需要先关闭后打开
    DtvManager.dtvAvClose();
    DtvManager.dtvAvOpen();
    let result: number = DtvManager.getDtvAv().start(channelId, isShow);
    console.log(TAG, 'dtvAvChannelChange result: channelID,isShow,startResult ' + channelId, ' ' + isShow, result);
  }

  /**
   * 获取所有频道列表
   * @returns 列表
   */
  public static getChannelList(): Array<TvSdkDtv.PmChannel> {
    let channelList: TvSdkDtv.PmChannel[] =
      DtvManager.getChannelListByType(TvSdkDtv.ServiceModeType.PM_SERVICE_MODE_ALL);
    return channelList;
  }

  /**
   * 根据频道类型获取频道列表
   * @param type 频道类型
   * @returns 列表
   */
  public static getChannelListByType(type: TvSdkDtv.ServiceModeType): Array<TvSdkDtv.PmChannel> {
    if (type === TvSdkDtv.ServiceModeType.PM_SERVICE_MODE_DATA) {
      DtvManager.getProgramManager().setServiceMode(TvSdkDtv.ServiceModeType.PM_SERVICE_MODE_DATA);
    }
    let groupType = DtvManager.getChannelGroup(type);
    let channelNum: number = DtvManager.getProgramManager().getChannelNum(groupType);
    let channelList: TvSdkDtv.PmChannel[] = DtvManager.getChannelListBySplit(groupType, channelNum);
    console.log(TAG, 'getChannelListByType : ,list : ', type.toString(), JSON.stringify(channelList));
    if (type === TvSdkDtv.ServiceModeType.PM_SERVICE_MODE_DATA) {
      DtvManager.getProgramManager().setServiceMode(TvSdkDtv.ServiceModeType.PM_SERVICE_MODE_ALL);
    }
    return channelList;
  }

  /**
   * 分批获取频道列表（避免双机通信数据量过大）
   * @param groupType 频道类型
   * @param total 查询到的频道总数
   * @returns 列表
   */
  private static getChannelListBySplit(groupType: number, total: number): Array<TvSdkDtv.PmChannel> {
    console.log(TAG, 'getChannelListBySplit ,groupType : ,total : ', groupType, total);
    let channelList: TvSdkDtv.PmChannel[] = [];
    for (let offset = 0; offset < total; offset += SPLIT_NUM) {
      let list: TvSdkDtv.PmChannel[] = DtvManager.getProgramManager().getChannelList(groupType, offset, SPLIT_NUM);
      console.log(TAG, 'getChannelListBySplit offset : ,list.length : ', offset, list.length);
      if (list !== undefined && list.length > 0) {
        for (let index = 0; index < list.length; index++) {
          channelList.push(list[index]);
        }
      }
    }
    return channelList;
  }

  /**
   * 获取当前播放的频道ID
   * @returns
   */
  public static getCurrentChannelId(): number {
    let currentChannelId: number = DtvManager.getDtvAv().getAvStatus(TvSdkDtv.AvCmdType.AV_GET_CUR_PROGINFO) as number;
    console.log(TAG, 'getCurrentChannelId : ', currentChannelId);
    return currentChannelId ?? 0;
  }

  /**
   * 获取当前的播放状态
   * @returns 播放状态
   */
  public static getPlayStatus(): TvSdkDtv.AvPlayStatus {
    let status: TvSdkDtv.AvPlayStatus =
      DtvManager.getDtvAv().getAvStatus(TvSdkDtv.AvCmdType.AV_GET_PLAY_STATUS) as TvSdkDtv.AvPlayStatus;
    console.log(TAG, 'getPlayStatus : ', status);
    return status;
  }

  /**
   * 获取频道组序号
   * @param tvRadioFilter
   * @returns 序号
   */
  public static getChannelGroup(tvRadioFilter: TvSdkDtv.ServiceModeType): number {
    let filter: TvSdkDtv.PmChannelFilter = {
      baseGroupType: 0,
      tvRadioFilter: TvSdkDtv.ServiceModeType.PM_SERVICE_MODE_ALL,
      isSkipHideChannel: false,
      caFilter: 0,
      favTag: 0,
      signalType: TvSdkDtv.FeAntennaType.FE_ANTENNA_DTMB,
      deliverySystemRowID: 0,
      firstChar: '',
      firstNumber: '',
      otherFirstChar: '',
      letters: '',
      tunerID: 0,
      tpRowID: 0,
      networkID: 0,
      ciType: 0,
      ciOpRowId: 0
    }
    filter.tvRadioFilter = tvRadioFilter;
    let groupType: number = DtvManager.getProgramManager().getChannelGroup(filter);
    console.log(TAG, 'getChannelGroup ： ', groupType);
    return groupType;
  }

  /**
   * 判断是否有频道
   * @returns true-有,false-没有
   */
  public static hasChannel(): boolean {
    let groupTypeAll = DtvManager.getChannelGroup(TvSdkDtv.ServiceModeType.PM_SERVICE_MODE_ALL);
    let channelNum: number = DtvManager.getProgramManager().getChannelNum(groupTypeAll);
    console.log(TAG, 'hasChannel getChannelNum : ', channelNum);
    return channelNum > 0;
  }

  /**
   * 删除所有频道
   */
  public static delChannelBySignalType(): void {
    let result1: number = DtvManager.getProgramManager().delChannelBySignalType(TvSdkDtv.FeAntennaType.FE_ANTENNA_DTMB);
    console.log(TAG, 'delChannelBySignalType : ', result1);
    let result2: number = DtvManager.getProgramManager().saveTable(TvSdkDtv.PmTableType.PM_TABLE_TYPE_ALL, 0);
    console.log(TAG, 'saveTable : ', result2);
  }

  /**
   * 配置dtv相关参数
   */
  public static dtvConfigSet(): void {
    let result1: number = DtvManager.getDtvCfg().setStringValue(languageKey, languageValue);
    let result2: number = DtvManager.getDtvCfg().setIntValue(MODE_KEY, MODE_VALUE);
    console.log(TAG, 'dtvConfigSet result1 : ,result2 : ', result1, result2);
  }

  /**
   * 频道移动编辑
   * @param groupType 类型分组
   * @param channelID 频道ID
   * @param dstPos 目标位置
   */
  public static moveChannel(groupType: number, channelID: number, dstPos: number): void {
    let result: number = DtvManager.getProgramManager().moveChannel(groupType, channelID, dstPos);
    console.log(TAG, 'moveChannel : ', result);
  }

  /**
   * 频道编辑保存
   */
  public static saveChannel(): void {
    let result: number = DtvManager.getProgramManager().saveTable(TvSdkDtv.PmTableType.PM_TABLE_TYPE_ALL, 0);
    console.log(TAG, 'saveChannel : ', result);
  }

  /**
   * 获取当前频道信息
   * @returns 当前频道信息
   */
  public static getCurrentOpenChannel(): TvSdkDtv.PmChannel | undefined {
    let channelId = DtvManager.getCurrentChannelId();
    return DtvManager.getProgramManager().getChannelByID(channelId);
  }

  /**
   * 获取频点信息
   * @returns 频点列表
   */
  public static getFrequencyList(): TvSdkDtv.FeConnectParam[] {
    let freqNum: number = DtvManager.getProgramManager().getPressFreqNum(TvSdkDtv.FeAntennaType.FE_ANTENNA_DTMB) ?? 0;
    return DtvManager.getProgramManager().getPressFreList(TvSdkDtv.FeAntennaType.FE_ANTENNA_DTMB, 0, freqNum) ?? [];
  }

  /**
   * 设置频点信息freq
   * @param freq
   * @returns 成功0 或者失败-1
   */
  public static setConnectParam(freq?: TvSdkDtv.FeConnectParam): number {
    if (!freq) {
      console.log(TAG, 'setConnectParam error');
      return ERROR;
    }
    return DtvManager.getDtvFrontend().SetConnectParam(freq);
  }

  /**
   * 判断当前频道是否是广播
   * @returns true-是,false-不是
   */
  public static checkChannelIsRadio(): boolean {
    let pmChannel: TvSdkDtv.PmChannel | undefined = DtvManager.getCurrentOpenChannel();
    if (pmChannel === undefined) {
      return false;
    }
    return pmChannel.serviceType === SERVICE_TYPE_RADIO || pmChannel.serviceType === SERVICE_TYPE_FM_RADIO ||
      pmChannel.serviceType === SERVICE_TYPE_ADVANCED_RADIO;
  }

  /**
   * 删除当前频率下频道
   * @param freq
   */
  public static delChannelByFreq(freq: number): void {
    let deliverNum: number = DtvManager.getProgramManager().getDeliverSystemNum(TvSdkDtv.FeAntennaType.FE_ANTENNA_DTMB);
    let deliveryInfos: TvSdkDtv.DeliveryInfo[] =
      DtvManager.getProgramManager().getDeliverSystemList(TvSdkDtv.FeAntennaType.FE_ANTENNA_DTMB, 0, deliverNum);
    for (let index = 0; index < deliveryInfos.length; index++) {
      let deliveryID: number = deliveryInfos[index].deliverID;
      let tpNum: number = DtvManager.getProgramManager().getStatelliteTpNum(deliveryID);
      console.log(TAG, 'delChannelByFreq tpNum is  : ', tpNum, deliveryID);
      let pmTransponders: TvSdkDtv.PmTransponder[] = DtvManager.getSatelliteTpListBySplit(deliveryID, tpNum);
      for (let idx = 0; idx < pmTransponders.length; idx++) {
        let pmTransponder: TvSdkDtv.PmTransponder = pmTransponders[idx];
        if (pmTransponder.connParam.freq === freq) {
          console.log(TAG, 'delChannelByFreq freq is : ', freq, pmTransponder.tpID);
          DtvManager.getProgramManager().delChannelByID(pmTransponder.tpID);
        }
      }

    }
  }

  private static getSatelliteTpListBySplit(deliveryID: number, tpNum: number): Array<TvSdkDtv.PmTransponder> {
    let pmTranspinder: TvSdkDtv.PmTransponder[] = [];
    for (let offset = 0; offset < tpNum; offset += SPLIT_NUM) {
      let list: TvSdkDtv.PmTransponder[] = DtvManager.getProgramManager()
        .getStatelliteTpList(deliveryID, offset, SPLIT_NUM);
      if (list !== undefined && list.length > 0) {
        for (let index = 0; index < list.length; index++) {
          pmTranspinder.push(list[index]);
        }
      }
    }
    return pmTranspinder;
  }
}
