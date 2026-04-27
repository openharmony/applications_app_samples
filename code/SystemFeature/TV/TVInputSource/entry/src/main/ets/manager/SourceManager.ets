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

import { TimingInfoEntity } from '../entity/TimingInfoEntity';
import { MultiPageListenerManager } from './MultiPageListenerManager';
import displaySetting from '@ohos.tvservice.displaySetting';
import { SourcePlugStateEntity } from '../entity/SourcePlugStateEntity';
import { InputSourceUtil } from '../utils/InputSourceUtil';
import { SourceType } from '../utils/StyleConstants';

const TAG = 'SOURCE_MANAGER';

// 展示输入源顺序
const DISPLAY_INPUT_SOURCES: number[] = [
  SourceType.SOURCE_HDMI1,
  SourceType.SOURCE_HDMI2,
  SourceType.SOURCE_HDMI3,
  SourceType.SOURCE_HDMI4,
  SourceType.SOURCE_CVBS1,
  SourceType.SOURCE_DTMB,
  SourceType.SOURCE_GRAPHIC
];

export interface SourcePlugState {
  source: displaySetting.SourceType | SourceType;
  isPluIn: boolean;
}

//信号源管理
export class SourceManager {
  /**
   * 获取节目信息（接口只支持当前源）
   */
  public static getTimingInfo(): TimingInfoEntity {
    // todo
    displaySetting.GetTiming((err, timingInfo: displaySetting.ScreenTiming) => {
      return SourceManager.transferTimingInfo(timingInfo);
    });
    return new TimingInfoEntity();
  }

  private static transferTimingInfo(timingInfo: displaySetting.ScreenTiming) {
    let entity: TimingInfoEntity = new TimingInfoEntity();
    if (!timingInfo) {
      return entity;
    }
    entity.setWidth(timingInfo.width);
    entity.setHeight(timingInfo.height);
    entity.setFrameRate(timingInfo.frameRate);
    entity.setIsInterlace(timingInfo.interlace ? true : false);
    return entity;
  }

  /**
   * 获取输入源列表
   */
  public static async getSourceList(): Promise<SourcePlugStateEntity[]> {
    let results: SourcePlugStateEntity[] = [];
    // 支持的源列表
    let supportSourceList: displaySetting.SourceType[] = [];
    // 已插入状态的源列表
    let plugInSourceList: displaySetting.SourceType[] = [];
    try {
      supportSourceList = await displaySetting.GetSupportSourceList();
      // 过滤掉MEDIA
      supportSourceList = supportSourceList.filter(sourceType => sourceType != 0);
      console.debug('GetSupportSourceList=='+JSON.stringify(supportSourceList));
    } catch (err) {
      console.error('GetSupportSourceList err', JSON.stringify(err));
    }

    try {
      plugInSourceList = await displaySetting.GetAvailSourceList();
      console.debug('GetAvailSourceList=='+JSON.stringify(plugInSourceList));
    } catch (err) {
      console.error('GetAvailSourceList err', JSON.stringify(err));
    }

    if (!supportSourceList || supportSourceList.length === 0) {
      return results;
    }
    supportSourceList.forEach((sourceType: displaySetting.SourceType) => {
      const sourcePlugState: SourcePlugState = {
        source: sourceType,
        isPluIn: false
      }
      if (plugInSourceList.length !== 0 && plugInSourceList.indexOf(sourceType) !== -1) {
        sourcePlugState.isPluIn = true;
      }
      results.push(SourceManager.transferSourcePlugState(sourcePlugState));
    });
    return results;
  }

  private static transferSourcePlugState(sourcePlugState: SourcePlugState): SourcePlugStateEntity {
    let entity: SourcePlugStateEntity =
      new SourcePlugStateEntity(
        sourcePlugState.source,
        sourcePlugState.isPluIn ? true : false,
        DISPLAY_INPUT_SOURCES.indexOf(sourcePlugState.source as SourceType),
        InputSourceUtil.getSourceName(sourcePlugState.source)
      );
    return entity;
  }

  /**
   * 输入源状态事件变化监听
   */
  public static onEvent(): void {
    console.log(TAG,'sourcePlugIn onEvent开始');
    displaySetting.on('sourcePlugIn', (sourceBit: number[]) => {
      console.log(TAG, 'sourcePlugIn onnnn');
      for (let index = 0; index < sourceBit.length; index++) {
        const sourceType = sourceBit[index];
        const plugState: SourcePlugState = {
          source: sourceType,
          isPluIn: true
        };
        MultiPageListenerManager.getInStance().onPlugChange(plugState);
        console.log(TAG, 'sourcePlugIn监听输入源状态变化事件');
        console.debug(TAG, 'source :' + plugState.source + 'change plugState: ' + plugState.isPluIn);
      }
    });
    displaySetting.on('sourcePlugOut', (sourceBit: number[]) => {
      console.log(TAG, 'sourcePlugOut监听输入源状态变化事件');
      for (let index = 0; index < sourceBit.length; index++) {
        const sourceType = sourceBit[index];
        const plugState: SourcePlugState = {
          source: sourceType,
          isPluIn: false
        };
        MultiPageListenerManager.getInStance().onPlugChange(plugState);
        console.debug(TAG, 'source :' + plugState.source + 'change plugState: ' + plugState.isPluIn);
      }
    });
  }

  /**
   * 注销输入源状态变化事件
   */
  public static offEvent(): void {
    try {
      displaySetting.off('sourcePlugIn', (sourceBit: number[]) => {
        console.log(TAG, 'sourcePlugIn注销输入源状态变化事件');
      });
      displaySetting.off('sourcePlugOut', (sourceBit: number[]) => {
        console.log(TAG, 'sourcePlugOut注销输入源状态变化事件');
      });
    }catch (err) {
      console.error(`displaySetting offEvent failed: ${JSON.stringify(err)}`);
    }
  }

  public static getSourceListByHdmirxEdidType() {
  }
}
