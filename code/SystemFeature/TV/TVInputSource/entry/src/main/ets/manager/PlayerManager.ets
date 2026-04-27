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

import { InputSourceUtil } from '../utils/InputSourceUtil';
import { commonEventManager } from '@kit.BasicServicesKit';

export class PlayerManager {
  private static instance: PlayerManager;

  /**
   * 获取管理实例
   */
  public static getInstance() {
    if (!PlayerManager.instance) {
      PlayerManager.instance = new PlayerManager();
    }
    return PlayerManager.instance;
  }

  /**
   * 绑定输入源
   */
  public bindSource(sourceId: number, callback: () => void) {
    InputSourceUtil.selectSource(sourceId, () => {
      callback()
    });
  }

  /**
   * 取消输入源绑定
   */
  public unBindSource(sourceId: number, callback: () => void) {
    InputSourceUtil.deSelectSource(sourceId).then(() => {
    });

  }

  /**
   * 发布开始播放事件
   * 发布输入源开始播放事件
   */
  public publishSourcePlayStart(): void {
    commonEventManager.publish('sourcePlayStart', (err) => {
      if (err) {
        console.log('sourcePlayStart err');
      } else {
        console.log('sourcePlayStart success');
      }
    });
  }

  /**
   * 发布结束播放事件
   * 发布输入源结束播放事件
   */
  public publishSourcePlayEnd(): void {
    commonEventManager.publish('sourcePlayEnd', (err) => {
      if (err) {
        console.log('sourcePlayEnd err');
      } else {
        console.log('sourcePlayEnd success');
      }
    });
  }
}
