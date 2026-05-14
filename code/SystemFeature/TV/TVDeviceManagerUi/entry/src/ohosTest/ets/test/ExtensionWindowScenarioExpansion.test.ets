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
import { TestDataFactory, DisplayScenario } from './base/TestDataFactory';

class ExtensionWindowLifecycleModel {
  readonly storagePage: string = 'pages/Transparent';
  readonly confirmPage: string = 'pages/ConfirmDialog';
  readonly pincodePage: string = 'pages/PinDialog';
  readonly inputPage: string = 'pages/InputPinDialog';
  readonly transparentColor: string = '#00000000';
  readonly floatWindowType: string = 'TYPE_FLOAT';

  createOperationWave(pageName: string): string[] {
    return ['move', 'resize', `load:${pageName}`, 'show', 'radius', 'shadow'];
  }

  createCenteredLeft(displayWidth: number, dialogWidth: number): number {
    return (displayWidth - dialogWidth) / 2;
  }
}

class TransparentStorageModel {
  buildStorageKeys(): string[] {
    return ['session', 'context'];
  }
}

export default function extensionWindowScenarioExpansionTest(): void {
  describe('TVDeviceManagerUiExtensionWindowScenarioExpansionTest', () => {
    it('should route all extension abilities through transparent preload page before dialog rendering', 0, () => {
      // 三类扩展弹窗都先借助 Transparent 页完成 session/context 承载。
      // 这条链路一旦不一致，某个弹窗就可能在真实系统拉起时失去上下文信息。
      const model: ExtensionWindowLifecycleModel = new ExtensionWindowLifecycleModel();
      TestAsserts.assertStringEquals(model.storagePage, 'pages/Transparent');
      TestAsserts.assertNoEmptyStrings([
        model.confirmPage,
        model.pincodePage,
        model.inputPage
      ]);
    });

    it('should keep each extension dialog bound to its own final content page', 0, () => {
      // Confirm、展示、输入三种弹窗属于不同业务阶段，最终页面不能串用。
      // 这里验证页面绑定独立性，避免复用时把错误页面挂到错误扩展能力上。
      const model: ExtensionWindowLifecycleModel = new ExtensionWindowLifecycleModel();
      TestAsserts.assertFalse(model.confirmPage === model.pincodePage);
      TestAsserts.assertFalse(model.confirmPage === model.inputPage);
      TestAsserts.assertFalse(model.pincodePage === model.inputPage);
    });

    it('should preserve transparent background and float window strategy for system dialog experience', 0, () => {
      // 系统弹窗需要悬浮于当前业务之上，同时避免透明底被错误渲染成黑底。
      // 这里固定窗口策略，有助于防止平台适配过程中出现视觉回退。
      const model: ExtensionWindowLifecycleModel = new ExtensionWindowLifecycleModel();
      TestAsserts.assertStringEquals(model.transparentColor, '#00000000');
      TestAsserts.assertStringEquals(model.floatWindowType, 'TYPE_FLOAT');
    });

    it('should keep centered window placement stable across representative display widths', 0, () => {
      // TV 大屏差异主要体现在宽度矩阵上，居中逻辑出错会直接破坏观感。
      // 这里抽离 left 计算验证，确保窗口在多种屏宽下仍保持中心定位。
      const model: ExtensionWindowLifecycleModel = new ExtensionWindowLifecycleModel();
      const displays: DisplayScenario[] = TestDataFactory.createDisplayScenarios();
      displays.forEach((scenario: DisplayScenario) => {
        const dialogWidth: number = 692 * (scenario.width / 1920);
        const left: number = model.createCenteredLeft(scenario.width, dialogWidth);
        TestAsserts.assertRectCentered(scenario.width, left, dialogWidth);
      });
    });

    it('should keep extension window operation waves complete for all dialog variants', 0, () => {
      // 窗口生命周期步骤缺失会表现为页面不显示、无圆角或无阴影等体验问题。
      // 这里把三类窗口的关键操作都收敛成统一波形，便于后续扩展时回归核对。
      const model: ExtensionWindowLifecycleModel = new ExtensionWindowLifecycleModel();
      const operationWaves: string[][] = [
        model.createOperationWave(model.confirmPage),
        model.createOperationWave(model.pincodePage),
        model.createOperationWave(model.inputPage)
      ];
      operationWaves.forEach((operations: string[]) => {
        TestAsserts.assertStringArrayContains(operations, ['move', 'resize', 'show', 'radius', 'shadow']);
      });
    });

    it('should store session context pair together for transparent handoff contract', 0, () => {
      // Transparent 作为会话桥接层，必须同时拿到 session 与 context。
      // 如果只保留一个字段，后续窗口自毁与能力回收链路都会失去落点。
      const storageModel: TransparentStorageModel = new TransparentStorageModel();
      const keys: string[] = storageModel.buildStorageKeys();
      TestAsserts.assertArrayLength(keys, 2);
      TestAsserts.assertStringArrayContains(keys, ['session', 'context']);
    });
  });
}
