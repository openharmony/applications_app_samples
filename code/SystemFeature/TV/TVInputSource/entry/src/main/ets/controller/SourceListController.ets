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

import { common } from '@kit.AbilityKit';
import { settings } from '@kit.BasicServicesKit';
import { SourcePlugStateEntity } from '../entity/SourcePlugStateEntity';
import { SettingUtil } from '../utils/SettingUtil';
import displaySetting from '@ohos.tvservice.displaySetting';
import { SourceManager } from '../manager/SourceManager';
import { InputSourceUtil } from '../utils/InputSourceUtil';

const defaultInputSrc: string = 'hdmiSelect';

/**
 * 输入源列表控制器
 */
export class SourceListController {
  //cec设备名map
  private cecNames: Map<number, string> = new Map();
  /**
   * 支持HDMI1,2的接口列表
   */
  // private hdmiVerPorts:number[]=SourceManager.getSourceListByHdmirxEdidType();

  //存在osdName的cec设备输入源类型
  private hdmiSources: number[] = [
    1,
    2,
    3,
  ];

  /**
   * 获取输入源列表
   */
  public async getSourceList(): Promise<SourcePlugStateEntity[]> {
    let sourceList: SourcePlugStateEntity[] =
      (await SourceManager.getSourceList()).sort((a, b) => a.getDisplayOrder() - b.getDisplayOrder());
    console.log('get source list size');
    if (sourceList.length === 0) {
      // todo
      // return this.initDefaultSourceList();
    }
    return sourceList;
  }

  /**
   * 获取默认输入源
   */
  public getDefaultSource(): string {
    const value = SettingUtil.getValueSync(defaultInputSrc, 'HDMI1');
    return value;
  }

  /**
   * 获取预览输入源
   */
  public getPreviewSource(): string {
    return SettingUtil.getValueSync('persist.sys.preview.sourceid', '');
  }

  /**
   * 设置默认输入源
   */
  public setDefaultSource(name: string): boolean {
    SettingUtil.publishEvents(name);
    return SettingUtil.setValueSync(defaultInputSrc, name);
  }

  /**
   * 注册cec设备信息监听
   */
  public registerDeviceChange(sourceList: SourcePlugStateEntity[]): void {
    void sourceList;
  }

  /**
   * 更新设备信息
   */
  public updateSourceInfo(sourceList: SourcePlugStateEntity[]): void {
    //更新支持cec设备输入源osdname
    this.updateCecDeviceName();
    console.log('update source info start');
    for (let source of sourceList) {
      source.setSourceName(
        this.hdmiSources.includes(source.getSourceId()) ? this.getSourceName(source) : source.getSourceName()
      );
    }
  }

  /**
   * 注销cec设备信息监听
   */
  public unRegisterDeviceChange(): void {
  }

  /**
   * 更新cec设备信息
   */
  public async updateCecDeviceName(): Promise<void> {
    let cecList: displaySetting.CecDeviceInfo[] = await displaySetting.GetDeviceList();
    this.cecNames.clear();
    if (!cecList || cecList.length == 0) {
      //拔出所有输入源或者未开启cec开关，不处理
      return;
    }
    for (let cecInfo of cecList) {
      if (this.hdmiSources.includes(cecInfo.hdmiDevPort)) {
        this.cecNames.set(cecInfo.hdmiDevPort, cecInfo.osdName);
      }
    }
  }

  public getSourceName(source: SourcePlugStateEntity): string {
    let name: string | undefined = this.cecNames.get(source.getSourceId());
    if (name) {
      return name;
    }
    return InputSourceUtil.getSourceName(source.getSourceId());
  }

  /**
   * Replaces the internal CEC cache with a deterministic snapshot for tests.
   *
   * @param names HDMI port to OSD-name mapping.
   * @returns void.
   */
  public replaceCecNamesForTest(names: Map<number, string>): void {
    this.cecNames.clear();
    names.forEach((value: string, key: number) => {
      this.cecNames.set(key, value);
    });
  }

  /**
   * Exposes the current CEC cache for focused white-box assertions in tests.
   *
   * @returns Map<number, string> Mutable cache used by source-name resolution.
   */
  public getCecNamesForTest(): Map<number, string> {
    return this.cecNames;
  }
}
