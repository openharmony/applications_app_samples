/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { logger } from './Logger';
import { emitter } from '@kit.BasicServicesKit';
import { display, window } from '@kit.ArkUI';
import { DEFAULT_WINDOW_SIZE } from '../constants/Constants';

// 路由跳转延时
const DELAY_TIME: number = 20;

export class RouterUtils {
  public static pageStack: NavPathStack = new NavPathStack();
  // 全屏子路由
  private static fullScreenRouter: string[] = [];
  private static timer: number = 0;

  public static setFullScreenRouter(fullScreenRouter: string[]) {
    RouterUtils.fullScreenRouter = fullScreenRouter;
  }

  // 通过获取页面栈并pop
  public static popAppRouter(): void {

    if (RouterUtils.pageStack.getAllPathName().length > 1) {
      RouterUtils.pageStack.pop();
    } else {
      logger.info('RouterStack is only Home.');
    }
    // 定义emitter事件
    let innerEvent: emitter.InnerEvent = {
      eventId: 3
    };
    let eventData: emitter.EventData = {
      data: {
        navMode: NavMode.HomePageMode
      }
    };
    let allPathName: string[] = RouterUtils.pageStack.getAllPathName();
    // 查找到对应的路由栈进行pop
    if (!RouterUtils.fullScreenRouter.includes(allPathName[allPathName.length-1]) &&
      RouterUtils.pageStack.size() === 1) {
      // 非全屏子路由宽屏条件下回到首页，Navigation的mode属性修改默认动画会与过场动画冲突，需关闭过场动画
      if (display.getDefaultDisplaySync().width > DEFAULT_WINDOW_SIZE.width) {
        RouterUtils.pageStack.disableAnimation(true);
      }
      RouterUtils.timer = setTimeout(() => {
        // 触发EntryView下navMode改变
        emitter.emit(innerEvent, eventData);
      }, DELAY_TIME);
      RouterUtils.pageStack.pop();
    } else if (RouterUtils.fullScreenRouter.includes(allPathName[allPathName.length-1])) {
      // 全屏子路由返回逻辑
      RouterUtils.pageStack.pop();
      // 触发EntryView下navMode改变
      emitter.emit(innerEvent, eventData);
    } else {
      RouterUtils.pageStack.pop();
    }
  }

  /**
   * 兼容折叠屏下的路由跳转
   * @param uri 路由名称
   * @param param 路由参数
   */
  public static pushUri(uri: string, param?: ESObject) {
    // 记录当前进入路由名称
    AppStorage.setOrCreate('enterRouteName', uri);
    // 定义emitter事件
    let innerEvent: emitter.InnerEvent = {
      eventId: 3
    };
    let eventData: emitter.EventData = {
      data: {
        navMode: NavMode.ChildPageMode
      }
    };
    // 触发EntryView下navMode改变
    emitter.emit(innerEvent, eventData);
    // 获取当前窗口宽度
    let displayInfo: display.Display = display.getDefaultDisplaySync();
    let windowSize: window.Size | undefined =
      AppStorage.get<window.Size>('windowSize') !== undefined ? AppStorage.get<window.Size>('windowSize') : {
        width: displayInfo.width,
        height: displayInfo.height
      } as window.Size;
    // 宽屏条件下跳转
    if (windowSize!.width > DEFAULT_WINDOW_SIZE.width) {
      RouterUtils.pageStack.clear();
      if (RouterUtils.timer) {
        clearTimeout(RouterUtils.timer);
      }
      // Navigation的mode属性修改会有一段响应时间，需延时跳转
      RouterUtils.timer = setTimeout(() => {
        RouterUtils.pageStack.pushPathByName(uri, param);
      }, DELAY_TIME);
    } else {
      RouterUtils.pageStack.pushPathByName(uri, param);
    }
  }
}


// 设置导航栏显示改变模式枚举值
export enum NavMode {
  DefaultMode, // 默认模式
  FoldMode, // 折叠模式
  ChildPageMode, // 进入子页面模式
  HomePageMode // 返回首页模式
}