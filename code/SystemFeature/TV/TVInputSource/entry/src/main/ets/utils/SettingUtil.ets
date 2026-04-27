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

/**
 * settings工具类
 */
import { common } from '@kit.AbilityKit';
import { BusinessError, commonEventManager, settings } from '@kit.BasicServicesKit';

export class SettingUtil {
  /**
   * 同步写入 settings 配置。
   * @param key 配置项名称。
   * @param value 需要持久化的配置值。
   * @returns boolean 返回写入是否成功，异常或上下文缺失时返回 false。
   */
  public static setValueSync(key: string, value: string): boolean {
    let pageContext: common.Context = globalThis.AbilityContext;
    if (!pageContext) {
      console.log('setValueSync context is null');
      return false;
    }
    let result = false;
    try {
      result = settings.setValueSync(pageContext, key, value);
    } catch (e) {
      console.log('setValueSync errcode', JSON.stringify(e));
    }
    console.log('setValueSync global name');
    return result;
  }

  /**
   * 获取settings数据
   * @param name 配置项名称。
   * @param defValue 读取失败或未命中时返回的默认值。
   * @returns string 返回读取到的配置值，异常或上下文缺失时回落到默认值。
   */
  public static getValueSync(name: string, defValue: string): string {
    let pageContext: common.Context = globalThis.AbilityContext;
    if (!pageContext) {
      console.log('getValueSync context is null');
      return defValue;
    }
    let result = defValue;
    try {
      result = settings.getValueSync(pageContext, name, defValue);
    } catch (e) {
      console.log('getValueSync errcode', JSON.stringify(e));
    }
    return result;
  }

  /**
   * 发布设置默认输入源事件
   * @param inputSourceType 默认输入源名称。
   * @returns void 无返回值，发布失败时仅记录日志。
   */
  public static publishEvents(inputSourceType: string): void {
    let commonEvents: commonEventManager.CommonEventPublishData = {
      parameters: {
        InputSourceType: inputSourceType,
      }
    };
    try {
      commonEventManager.publish('InputSourceType', commonEvents, (err: BusinessError) => {
        console.log('InputSourceType publishEvents: ' + inputSourceType);
      });
    } catch (err) {
      console.log('InputSourceType publishEvents failed: ' + JSON.stringify(err));
    }
  }
}
