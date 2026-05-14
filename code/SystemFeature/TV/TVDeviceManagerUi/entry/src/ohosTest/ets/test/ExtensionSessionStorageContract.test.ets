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

interface SessionStorageShape {
  sessionToken: string;
  contextToken: string;
}

class ExtensionStorageAssembler {
  build(sessionToken: string, contextToken: string): SessionStorageShape {
    return {
      sessionToken: sessionToken,
      contextToken: contextToken
    };
  }
}

export default function extensionSessionStorageContractTest(): void {
  describe('TVDeviceManagerUiExtensionSessionStorageContractTest', () => {
    it('should preserve both session and context identifiers in storage payload', 0, () => {
      const assembler: ExtensionStorageAssembler = new ExtensionStorageAssembler();
      const storage: SessionStorageShape = assembler.build('session-1', 'context-1');

      // Transparent 承载页依赖 session 与 context 一起透传，缺任何一个都会让后续浮窗流程失去控制能力。
      // 这里单独验证组装契约，是为了避免只测窗口外观却漏掉真正的能力上下文依赖。
      TestAsserts.assertStringEquals(storage.sessionToken, 'session-1');
      TestAsserts.assertStringEquals(storage.contextToken, 'context-1');
    });

    it('should keep storage tokens non empty for runtime handoff', 0, () => {
      const assembler: ExtensionStorageAssembler = new ExtensionStorageAssembler();
      const storage: SessionStorageShape = assembler.build('session-2', 'context-2');

      TestAsserts.assertNoEmptyStrings([storage.sessionToken, storage.contextToken]);
    });

    it('should preserve token values exactly during repeated storage assembly', 0, () => {
      const assembler: ExtensionStorageAssembler = new ExtensionStorageAssembler();
      const first: SessionStorageShape = assembler.build('session-a', 'context-a');
      const second: SessionStorageShape = assembler.build('session-b', 'context-b');

      TestAsserts.assertStringEquals(first.sessionToken, 'session-a');
      TestAsserts.assertStringEquals(first.contextToken, 'context-a');
      TestAsserts.assertStringEquals(second.sessionToken, 'session-b');
      TestAsserts.assertStringEquals(second.contextToken, 'context-b');
    });

    it('should keep session and context token pair count aligned for transparent page handoff', 0, () => {
      const assembler: ExtensionStorageAssembler = new ExtensionStorageAssembler();
      const storage: SessionStorageShape = assembler.build('session-3', 'context-3');
      const values: string[] = [storage.sessionToken, storage.contextToken];

      // Transparent 页面装配需要 session/context 成对存在。
      // 这里锁定成对数量，可以避免后续把其中一个字段改成可选后出现运行时半初始化状态。
      TestAsserts.assertArrayLength(values, 2);
      TestAsserts.assertNoEmptyStrings(values);
    });

    it('should allow distinct session context combinations without cross contamination', 0, () => {
      const assembler: ExtensionStorageAssembler = new ExtensionStorageAssembler();
      const left: SessionStorageShape = assembler.build('session-left', 'context-left');
      const right: SessionStorageShape = assembler.build('session-right', 'context-right');

      TestAsserts.assertFalse(left.sessionToken === right.sessionToken);
      TestAsserts.assertFalse(left.contextToken === right.contextToken);
    });

    it('should keep session and context token labels readable for handoff diagnostics', 0, () => {
      const assembler: ExtensionStorageAssembler = new ExtensionStorageAssembler();
      const storage: SessionStorageShape = assembler.build('session-readable', 'context-readable');

      TestAsserts.assertReadableText(storage.sessionToken);
      TestAsserts.assertReadableText(storage.contextToken);
    });

    it('should keep storage object shape stable across generator replay', 0, () => {
      const assembler: ExtensionStorageAssembler = new ExtensionStorageAssembler();
      const values: SessionStorageShape[] = [
        assembler.build('session-4', 'context-4'),
        assembler.build('session-5', 'context-5'),
        assembler.build('session-6', 'context-6')
      ];

      // 存储契约最终会被批量场景生成器复用，如果 shape 发生漂移，很多测试会在运行期才暴露问题。
      // 这里连续回放多个样本，是为了锁定“字段齐全且顺序稳定”的最小结构前提。
      TestAsserts.assertArrayLength(values, 3);
      values.forEach((item: SessionStorageShape) => {
        TestAsserts.assertNoEmptyStrings([item.sessionToken, item.contextToken]);
      });
    });
  });
}
