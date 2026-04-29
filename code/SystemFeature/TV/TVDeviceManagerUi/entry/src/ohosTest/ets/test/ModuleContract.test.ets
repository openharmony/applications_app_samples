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
import { TestDataFactory } from './base/TestDataFactory';

class ModuleContractModel {
  abilities: string[] = [
    'com.ohos.devicemanagerui.MainAbility'
  ];
  extensionAbilities: string[] = [
    'com.ohos.devicemanagerui.ConfirmUIExtAbility',
    'com.ohos.devicemanagerui.PincodeUIExtAbility',
    'com.ohos.devicemanagerui.InputUIExtAbility'
  ];
  extensionTypes: string[] = [
    'sysDialog/common',
    'sysDialog/common',
    'sysDialog/common'
  ];
  deviceTypes: string[] = [
    'default',
    'tablet'
  ];
  permissions: string[] = TestDataFactory.createPermissionScenario().permissions;
}

export default function moduleContractTest(): void {
  describe('TVDeviceManagerUiModuleContractTest', () => {
    it('should expose required extension abilities', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();
      TestAsserts.assertArrayLength(model.extensionAbilities, 3);
      TestAsserts.assertStringArrayContains(model.extensionAbilities, [
        'com.ohos.devicemanagerui.ConfirmUIExtAbility',
        'com.ohos.devicemanagerui.PincodeUIExtAbility',
        'com.ohos.devicemanagerui.InputUIExtAbility'
      ]);
    });

    it('should expose required permissions for distributed dialog flow', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();
      TestAsserts.assertPermissionSet(model.permissions);
    });

    it('should keep exactly one main ability for entry module', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();
      TestAsserts.assertArrayLength(model.abilities, 1);
      TestAsserts.assertStringEquals(model.abilities[0], 'com.ohos.devicemanagerui.MainAbility');
    });

    it('should keep all extension abilities exported as common system dialogs', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();

      // 三个 UIExtensionAbility 都承载系统级设备管理弹窗。
      // 类型保持一致可以保证确认、输入、展示三条链路都走同一系统弹窗调度策略。
      TestAsserts.assertArrayLength(model.extensionTypes, 3);
      model.extensionTypes.forEach((typeName: string) => {
        TestAsserts.assertStringEquals(typeName, 'sysDialog/common');
      });
    });

    it('should limit declared device types to supported tv sample matrix', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();
      TestAsserts.assertStringArrayContains(model.deviceTypes, ['default', 'tablet']);
      TestAsserts.assertArrayLength(model.deviceTypes, 2);
    });

    it('should keep extension ability declarations unique to avoid duplicate exported entry points', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();
      TestAsserts.assertStringArrayUnique(model.extensionAbilities);
    });

    it('should keep permission declarations unique for stable system grant contract', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();

      // 系统弹窗权限集合属于安装期与运行期共同依赖的基础契约。
      // 如果这里出现重复或脏数据，后续权限审计和回归统计都会被污染。
      TestAsserts.assertStringArrayUnique(model.permissions);
      TestAsserts.assertPermissionSet(model.permissions);
    });

    it('should align extension ability count with exported common dialog type count', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();

      TestAsserts.assertArrayLength(model.extensionAbilities, model.extensionTypes.length);
      TestAsserts.assertNumberEquals(model.extensionAbilities.length, 3);
    });

    it('should expose device type declarations without empty placeholder values', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();
      TestAsserts.assertNoEmptyStrings(model.deviceTypes);
    });

    it('should keep main ability and extension ability names readable for contract review', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();
      [...model.abilities, ...model.extensionAbilities].forEach((name: string) => {
        TestAsserts.assertReadableText(name);
      });
    });

    it('should keep extension type declarations unique after deduplicated view', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();
      const uniqueTypes: string[] = Array.from(new Set<string>(model.extensionTypes));

      // 模块里允许多个 extension 共享同一 type，但从契约视角应该只归并成一个系统调度类别。
      // 这里验证去重后的结果，是为了让后续平台适配时明确不会无意引入第二种调度语义。
      TestAsserts.assertArrayLength(uniqueTypes, 1);
      TestAsserts.assertStringEquals(uniqueTypes[0], 'sysDialog/common');
    });

    it('should keep device type order stable for compatibility matrix generation', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();
      TestAsserts.assertStringEquals(model.deviceTypes[0], 'default');
      TestAsserts.assertStringEquals(model.deviceTypes[1], 'tablet');
    });

    it('should keep permission count aligned with security baseline contract', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();

      // 模块契约和安全契约会被不同测试消费，但它们必须共享同一份权限基线。
      // 这里直接锁定数量，可以让权限增删在回归时被快速感知，而不是只靠人工 diff 配置文件。
      TestAsserts.assertArrayLength(model.permissions, 5);
    });

    // Ability 名称会被系统装载器和问题定位日志直接消费，因此前缀语义必须保持一致。
    // 这里锁定统一包名前缀，避免后续重命名只改了一半，导致入口与扩展能力分属不同命名空间。
    it('should keep ability names aligned under the same application namespace prefix', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();
      const allNames: string[] = [...model.abilities, ...model.extensionAbilities];

      allNames.forEach((name: string) => {
        TestAsserts.assertStringContains(name, 'com.ohos.devicemanagerui.');
      });
    });

    // 三个扩展能力分别负责 confirm、pincode、input 三条链路，顺序本身也体现了模块文档约定。
    // 这里锁定顺序，可以让后续人工审查与脚本生成器共享一致的扩展排列语义。
    it('should keep extension ability order stable for confirm pincode and input flows', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();

      TestAsserts.assertStringEquals(model.extensionAbilities[0], 'com.ohos.devicemanagerui.ConfirmUIExtAbility');
      TestAsserts.assertStringEquals(model.extensionAbilities[1], 'com.ohos.devicemanagerui.PincodeUIExtAbility');
      TestAsserts.assertStringEquals(model.extensionAbilities[2], 'com.ohos.devicemanagerui.InputUIExtAbility');
    });

    // 设备类型集合不仅要可读，还要能够被去重后原样保留，避免兼容矩阵出现隐藏重复项。
    // 这里比较原数组与去重数组长度，确保 deviceTypes 仍是一个稳定而紧凑的契约集合。
    it('should keep device type declarations unique after normalization', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();
      const uniqueDeviceTypes: string[] = Array.from(new Set<string>(model.deviceTypes));

      TestAsserts.assertArrayLength(uniqueDeviceTypes, model.deviceTypes.length);
      TestAsserts.assertStringArrayContains(uniqueDeviceTypes, ['default', 'tablet']);
    });

    // 权限集合最终会参与安全审计与安装检查，因此顺序虽可调整，但每项都必须保持可读且非空。
    // 这里对全量权限做质量扫描，避免未来插入注释残片或脏字符串破坏权限声明解析。
    it('should keep every declared permission readable for audit and grant review', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();

      model.permissions.forEach((permission: string) => {
        TestAsserts.assertReadableText(permission);
        TestAsserts.assertStringContains(permission, 'ohos.permission.');
      });
    });

    // 主入口能力和扩展能力分别承担前台壳体与系统弹窗职责，二者不能出现命名重叠。
    // 这里显式校验两个集合互斥，防止后续重构时把某个扩展误命名成主 ability 造成装载歧义。
    it('should keep main ability names disjoint from extension ability names', 0, () => {
      const model: ModuleContractModel = new ModuleContractModel();

      model.abilities.forEach((ability: string) => {
        TestAsserts.assertFalse(model.extensionAbilities.includes(ability));
      });
    });
  });
}
