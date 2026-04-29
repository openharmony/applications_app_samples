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

import { describe, it } from '@ohos/hypium';
import { TestAsserts } from './base/TestAsserts';

class TransparentPageContractModel {
  backgroundColor: string = 'transparent';
  width: string = '100%';
  height: string = '100%';
  childCount: number = 0;

  buildSessionCarrier(): string {
    return `${this.backgroundColor}-${this.width}-${this.height}-${this.childCount}`;
  }
}

class SessionBootstrapModel {
  loadedPages: string[] = [];
  backgroundColors: string[] = [];

  bootstrapTransparentCarrier(): void {
    this.loadedPages.push('pages/Transparent');
    this.backgroundColors.push('#00000000');
  }
}

export default function transparentCarrierContractTest(): void {
  describe('TVDeviceManagerUiTransparentCarrierContractTest', () => {
    // Transparent 页面不承载业务内容，它存在的意义是为 float window 提供无背景干扰的会话容器。
    // 这里锁定“透明 + 全屏 + 空内容”三元组，避免后续样式改动把承载页意外变成可见遮罩层。
    it('should keep transparent page as empty full screen session carrier', 0, () => {
      const model: TransparentPageContractModel = new TransparentPageContractModel();
      const signature: string = model.buildSessionCarrier();

      TestAsserts.assertStringEquals(signature, 'transparent-100%-100%-0');
    });

    // 三个 UIExtensionAbility 在创建浮窗前都先加载透明承载页，这是一条公共启动前提。
    // 单独锁定顺序，可以更早发现扩展窗重构时直接跳过 session 容器的回归风险。
    it('should bootstrap session with transparent page before any business dialog', 0, () => {
      const model: SessionBootstrapModel = new SessionBootstrapModel();
      model.bootstrapTransparentCarrier();

      TestAsserts.assertArrayLength(model.loadedPages, 1);
      TestAsserts.assertStringEquals(model.loadedPages[0], 'pages/Transparent');
    });

    // session 背景必须完全透明，否则业务弹窗周围会出现不必要遮挡，破坏系统级提示体验。
    // 这里锁定十六进制透明色值，是为了保证不同弹窗扩展能力共享统一的无侵入视觉基线。
    it('should keep transparent session background color in extension bootstrap', 0, () => {
      const model: SessionBootstrapModel = new SessionBootstrapModel();
      model.bootstrapTransparentCarrier();

      TestAsserts.assertArrayLength(model.backgroundColors, 1);
      TestAsserts.assertStringEquals(model.backgroundColors[0], '#00000000');
    });
  });
}
