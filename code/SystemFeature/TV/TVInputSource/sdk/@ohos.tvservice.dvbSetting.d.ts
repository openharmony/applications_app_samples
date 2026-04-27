/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { AsyncCallback , Callback } from './@ohos.base'

/**
 * @namespace dvbSetting
 * @syscap SystemCapability.Multimedia.TvService.Display
 * @atomicservice
 * @since 12
 */
declare namespace dvbSetting {

  enum DtvEnBaseScanType {
    SINGLE_MULTI,              /*单频点搜索，使用setScanMultiplexes方法设置的一个待搜索复用通道 多频点搜索，使用setScanMultiplexes方法设置的所有复用通道信息*/
    AUTO_FULL,                 /*自动搜索，使用底层保存配置好的数据进行搜索，通过enableNit设置是否为网络搜索(NIT搜索)*/
    BLIND,                     /*盲扫，DVBS中对单卫星进行步进式扫描*/
    ZONE,                      /*区段搜索，使用setScanMultiplexes方法设置的第一个复用通道为起点 第二个复用通道为终点，搜索该区间中配置好的复用通道数据*/
    DTV_STEP,                      /*步进搜索，使用setScanMultiplexes方法设置的第一个复用通道为起点 第二个复用通道为终点，使用setFrequencyStep设置频率步进值*/
    AUTO_FULL_FIRST,           /*自动搜索到第一个能锁定的频点后停止，使用底层保存配置好的数据进行搜索。只用于NIT搜索或SDT搜索没有指定频点的情况下*/
    ATV_MANUAL,                /*ATV手动搜索，通过SetAtvScanDirection设置搜索方向，可通过setScanMultiplexes方法设置的第一个复用通道为起点 第二个复用通道为终点*/
    ATV_FINE                   /*ATV微调，可通过setScanMultiplexes方法设置的一个复用通道为起点*/
  }

  /**
   * dtv开始扫描
   * @param enBaseScanType -DtvEnBaseScanType: 枚举类型，具体值见定义.
   * @return 设置成功返回true, 返回其他表示失败.
   */
  function startScan(enBaseScanType: DtvEnBaseScanType, callback: AsyncCallback<boolean>): void;

  /**
   * dtv开始扫描
   * @param enBaseScanType –DtvEnBaseScanType: 枚举类型，具体值见定义.
   * @return 设置成功返回true, 返回其他表示失败.
   */
  function startScan(enBaseScanType: DtvEnBaseScanType): Promise<boolean>;

  function stopScan(callback: AsyncCallback<boolean>): void;
  function stopScan(): Promise<boolean>;

  function getDefaultOpenChannel(callback: AsyncCallback<number>): void;
  function getDefaultOpenChannel(): Promise<number>;

  function avOpen(callback: AsyncCallback<boolean>): void;
  function avOpen(): Promise<boolean>;

  function avClose(callback: AsyncCallback<boolean>): void;
  function avClose(): Promise<boolean>;

  function avStart(channelId: number, isShow: boolean, callback: AsyncCallback<boolean>): void;
  function avStart(channelId: number, isShow: boolean): Promise<boolean>;

  function avStop(callback: AsyncCallback<boolean>): void;
  function avStop(): Promise<boolean>;

}

export default dvbSetting;
