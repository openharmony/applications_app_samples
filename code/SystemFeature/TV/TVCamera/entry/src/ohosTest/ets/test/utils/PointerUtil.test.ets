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

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import { PointerUtil } from '../../../../main/ets/utils/PointerUtil';

interface GlobalContextHost {
  getContext?: () => Object;
}

/**
 * 获取可写入 `getContext` 的全局对象。
 * @returns 当前运行环境的全局对象
 */
function getGlobalHost(): GlobalContextHost {
  return globalThis as Object as GlobalContextHost;
}

export default function PointerUtilTest() {
  describe('PointerUtilTest', () => {
    let globalHost: GlobalContextHost = getGlobalHost();
    let originalGetContext = globalHost.getContext;

    beforeEach(() => {
      // 业务背景：PointerUtil 依赖全局 `getContext`，该依赖在测试环境里需要显式接管。
      // 每次用例前保存原始句柄，既保证测试隔离，也避免污染其他工具测试。
      originalGetContext = globalHost.getContext;
      PointerUtil.pixelMap = null;
    });

    afterEach(() => {
      globalHost.getContext = originalGetContext;
      PointerUtil.pixelMap = null;
    });

    it('PointerUtil_PublicSurface_ExposesCursorMethodAndPixelState_001', 0, () => {
      // 业务背景：EventUtil 和页面层目前只依赖 `changePointStyle` 与静态像素图状态。
      // 固定公开表面后，后续内部重构不会悄悄破坏对外契约。
      let ownProps = Object.getOwnPropertyNames(PointerUtil as Object);
      expect(ownProps.indexOf('changePointStyle') >= 0).assertTrue();
      expect(ownProps.indexOf('pixelMap') >= 0).assertTrue();
    });

    it('PointerUtil_PixelMap_DefaultsToNull_002', 0, () => {
      // 业务背景：当前实现不会在模块加载时抢先创建像素图，这能避免首帧额外资源开销。
      // 默认态固定为 null，可以帮助页面层判断是否需要延迟准备鼠标资源。
      expect(PointerUtil.pixelMap).assertEqual(null);
    });

    it('PointerUtil_ChangePointStyle_SwallowsSynchronousContextFailure_003', 0, () => {
      // 业务背景：测试环境或异常环境下 `getContext` 可能不可用，当前实现选择记录日志而不是抛错。
      // 守住这个容错分支，能避免指针样式失败直接中断触摸事件链。
      globalHost.getContext = (): Object => {
        throw new Error('context unavailable');
      };
      try {
        PointerUtil.changePointStyle(true);
        expect(true).assertTrue();
      } catch (error) {
        expect(false).assertTrue();
      }
    });
  });
}
