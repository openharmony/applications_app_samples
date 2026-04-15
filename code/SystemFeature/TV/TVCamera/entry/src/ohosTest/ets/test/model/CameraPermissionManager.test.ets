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

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import CameraPermissionManager from '../../../../main/ets/model/CameraPermissionManager';

interface CameraPermissionManagerApi {
  checkCameraPermission(): boolean;
  checkStoragePermission(): boolean;
  checkLocationPermission(): boolean;
  requestCameraPermission(): boolean;
  requestStoragePermission(): boolean;
  requestLocationPermission(): boolean;
  requestAllPermissions(): boolean;
  showPermissionRationale(permission: string): boolean;
}

interface PermissionMethodPatch {
  requestCameraPermission?: () => boolean;
  requestStoragePermission?: () => boolean;
  requestLocationPermission?: () => boolean;
  checkCameraPermission?: () => boolean;
  checkStoragePermission?: () => boolean;
  checkLocationPermission?: () => boolean;
}

interface PermissionMatrixCase {
  permission: string;
  expected: boolean;
}

/**
 * 功能描述：获取可打桩的权限管理单例实例。
 * 参数说明：无。
 * 返回值：`CameraPermissionManagerApi`，用于覆盖真实对象上的组合逻辑。
 */
function getManager(): CameraPermissionManagerApi {
  return CameraPermissionManager as CameraPermissionManagerApi;
}

/**
 * 功能描述：对权限管理器方法进行临时打桩并返回恢复函数。
 * 参数说明：`patch` 为需要覆盖的方法集合。
 * 返回值：() => void，用于在每条用例结束时恢复默认实现。
 */
function patchPermissionMethods(patch: PermissionMethodPatch): () => void {
  let manager = getManager() as Object as Record<string, Object>;
  let originalRequestCameraPermission = manager.requestCameraPermission;
  let originalRequestStoragePermission = manager.requestStoragePermission;
  let originalRequestLocationPermission = manager.requestLocationPermission;
  let originalCheckCameraPermission = manager.checkCameraPermission;
  let originalCheckStoragePermission = manager.checkStoragePermission;
  let originalCheckLocationPermission = manager.checkLocationPermission;

  if (patch.requestCameraPermission !== undefined) {
    manager.requestCameraPermission = patch.requestCameraPermission as Object;
  }
  if (patch.requestStoragePermission !== undefined) {
    manager.requestStoragePermission = patch.requestStoragePermission as Object;
  }
  if (patch.requestLocationPermission !== undefined) {
    manager.requestLocationPermission = patch.requestLocationPermission as Object;
  }
  if (patch.checkCameraPermission !== undefined) {
    manager.checkCameraPermission = patch.checkCameraPermission as Object;
  }
  if (patch.checkStoragePermission !== undefined) {
    manager.checkStoragePermission = patch.checkStoragePermission as Object;
  }
  if (patch.checkLocationPermission !== undefined) {
    manager.checkLocationPermission = patch.checkLocationPermission as Object;
  }

  return (): void => {
    manager.requestCameraPermission = originalRequestCameraPermission;
    manager.requestStoragePermission = originalRequestStoragePermission;
    manager.requestLocationPermission = originalRequestLocationPermission;
    manager.checkCameraPermission = originalCheckCameraPermission;
    manager.checkStoragePermission = originalCheckStoragePermission;
    manager.checkLocationPermission = originalCheckLocationPermission;
  };
}

/**
 * 功能描述：注册 CameraPermissionManager 主测试集合。
 * 参数说明：无。
 * 返回值：void，用于向 Hypium 挂载权限组合逻辑与边界契约测试。
 */
export default function CameraPermissionManagerTest(): void {
  describe('CameraPermissionManagerTest', () => {
    let manager: CameraPermissionManagerApi;
    let restoreMethods: (() => void) | undefined = undefined;

    beforeEach(() => {
      // 业务背景：权限管理当前没有状态，但组合逻辑测试会动态打桩方法。
      // 每条用例前都从真实单例重新取引用，避免把桩函数误当成生产实现继续使用。
      manager = getManager();
      restoreMethods = undefined;
    });

    afterEach(() => {
      // 业务背景：打桩后的权限函数如果不恢复，会把后续默认契约测试全部污染。
      // afterEach 做集中回滚，比在每条测试里手工恢复更不容易遗漏。
      if (restoreMethods !== undefined) {
        restoreMethods();
        restoreMethods = undefined;
      }
    });

    it('CameraPermissionManager_SingletonReferenceIsStable_001', 0, () => {
      // 业务背景：所有页面共享同一个权限判定入口，否则权限状态会在不同模块间出现分裂。
      // 先验证单例契约，后续组合逻辑测试才有统一前提。
      expect(getManager() === getManager()).assertTrue();
    });

    it('CameraPermissionManager_DefaultCheckContract_002', 0, () => {
      // 业务背景：当前工程把相机和存储视作已授权，把位置视作未授权。
      // 这三个基础判定共同构成页面初始按钮可用性的默认行为。
      expect(manager.checkCameraPermission()).assertTrue();
      expect(manager.checkStoragePermission()).assertTrue();
      expect(manager.checkLocationPermission()).assertFalse();
    });

    it('CameraPermissionManager_DefaultRequestContract_003', 0, () => {
      // 业务背景：当前请求逻辑是同步占位实现，但页面流程已经依赖其真假结果。
      // 这里直接锁定三个请求函数的默认结果，防止后续改动时悄悄改变首启路径。
      expect(manager.requestCameraPermission()).assertTrue();
      expect(manager.requestStoragePermission()).assertTrue();
      expect(manager.requestLocationPermission()).assertFalse();
    });

    it('CameraPermissionManager_RequestAllPermissionsMatchesCurrentComposition_004', 0, () => {
      // 业务背景：全量权限请求是首启主链路入口，默认应与 camera && storage 保持一致。
      // 这条用例先固定当前成功分支，再单独测试异常分支和短路语义。
      expect(manager.requestAllPermissions()).assertTrue();
    });

    it('CameraPermissionManager_RequestAllPermissionsShortCircuitsOnCameraFailure_005', 0, () => {
      // 业务背景：相机权限失败后继续请求存储没有意义，短路可以避免额外弹窗和噪音日志。
      // 通过计数器验证 storage 根本没有被调用，而不是只看最终 false 结果。
      let cameraCalls = 0;
      let storageCalls = 0;

      restoreMethods = patchPermissionMethods({
        requestCameraPermission: (): boolean => {
          cameraCalls++;
          return false;
        },
        requestStoragePermission: (): boolean => {
          storageCalls++;
          return true;
        }
      });

      expect(manager.requestAllPermissions()).assertFalse();
      expect(cameraCalls).assertEqual(1);
      expect(storageCalls).assertEqual(0);
    });

    it('CameraPermissionManager_RequestAllPermissionsFailsWhenStorageFails_006', 0, () => {
      // 业务背景：相机授权成功并不代表保存能力可用，存储失败仍然应该中断主流程。
      // 这里单独锁定第二阶段失败分支，避免后续把 requestAll 错改成只看相机权限。
      let storageCalls = 0;

      restoreMethods = patchPermissionMethods({
        requestCameraPermission: (): boolean => {
          return true;
        },
        requestStoragePermission: (): boolean => {
          storageCalls++;
          return false;
        }
      });

      expect(manager.requestAllPermissions()).assertFalse();
      expect(storageCalls).assertEqual(1);
    });

    it('CameraPermissionManager_RequestAllPermissionsIgnoresLocationContract_007', 0, () => {
      // 业务背景：当前位置权限在现状实现中不是 requestAll 的组成部分。
      // 这条用例通过把 location 保持失败，验证首启主链路不会被可选权限拖死。
      restoreMethods = patchPermissionMethods({
        requestCameraPermission: (): boolean => {
          return true;
        },
        requestStoragePermission: (): boolean => {
          return true;
        },
        requestLocationPermission: (): boolean => {
          return false;
        }
      });

      expect(manager.requestAllPermissions()).assertTrue();
      expect(manager.requestLocationPermission()).assertFalse();
    });

    it('CameraPermissionManager_ShowPermissionRationale_EmptyStringIsRejected_008', 0, () => {
      // 业务背景：空权限名无法向用户解释业务原因，应该在边界处直接返回失败。
      // 这能防止页面把丢失的权限标识传进来后显示空白说明弹窗。
      expect(manager.showPermissionRationale('')).assertFalse();
    });

    it('CameraPermissionManager_ShowPermissionRationale_WhitespaceIsAcceptedByCurrentContract_009', 0, () => {
      // 业务背景：当前实现只判断长度，不会 trim 空白字符。
      // 这是一个值得保留观察的现状行为，先测试固化，后续再决定是否做收敛修复。
      expect(manager.showPermissionRationale(' ')).assertTrue();
    });

    it('CameraPermissionManager_ShowPermissionRationale_MatrixCoversTypicalPermissionNames_010', 0, () => {
      // 业务背景：不同权限名会驱动不同说明文案模板，至少需要保证非空输入都可进入展示链路。
      // 用矩阵而不是单点样例，可以避免后续对字符串处理做特殊分支时漏掉某一类权限。
      let cases: PermissionMatrixCase[] = [
        { permission: 'camera', expected: true },
        { permission: 'storage', expected: true },
        { permission: 'ohos.permission.CAMERA', expected: true },
        { permission: '定位权限', expected: true }
      ];

      for (let index = 0; index < cases.length; index++) {
        let currentCase = cases[index];
        expect(manager.showPermissionRationale(currentCase.permission)).assertEqual(currentCase.expected);
      }
    });

    it('CameraPermissionManager_RequestAndCheckCameraStayConsistent_011', 0, () => {
      // 业务背景：相机主链路最常见的前后动作就是先检查再请求。
      // 在当前占位实现里，两者都代表“可用”，测试可以防止语义突然相反。
      expect(manager.checkCameraPermission()).assertEqual(manager.requestCameraPermission());
    });

    it('CameraPermissionManager_RequestAndCheckStorageStayConsistent_012', 0, () => {
      // 业务背景：保存前的权限判断与授权结果如果相互矛盾，会造成按钮状态错乱。
      // 因此需要锁定存储权限的检查值与请求值当前保持一致。
      expect(manager.checkStoragePermission()).assertEqual(manager.requestStoragePermission());
    });

    it('CameraPermissionManager_LocationRemainsDeniedAcrossCheckAndRequest_013', 0, () => {
      // 业务背景：位置权限当前是可选能力，默认维持关闭有利于避免误采集地理信息。
      // 同时检查 check/request 两个入口，可以确保默认拒绝策略没有被局部改动破坏。
      expect(manager.checkLocationPermission()).assertFalse();
      expect(manager.requestLocationPermission()).assertFalse();
    });

    it('CameraPermissionManager_RepeatedCallsRemainStable_014', 0, () => {
      // 业务背景：权限入口会在页面显示、点击拍照、点击保存等多个节点被重复调用。
      // 稳定性比复杂逻辑更重要，因此这里通过高频重复读取锁定返回值不漂移。
      for (let index = 0; index < 50; index++) {
        expect(manager.checkCameraPermission()).assertTrue();
        expect(manager.checkStoragePermission()).assertTrue();
        expect(manager.checkLocationPermission()).assertFalse();
      }
    });

    it('CameraPermissionManager_PatchedCheckMethodsCanRepresentRevokedState_015', 0, () => {
      // 业务背景：真实系统中权限可能在设置页被撤回，测试需要模拟“曾经有权限但现在没有”的场景。
      // 打桩检查函数可以先把未来接入系统权限查询时的行为契约固定下来。
      restoreMethods = patchPermissionMethods({
        checkCameraPermission: (): boolean => {
          return false;
        },
        checkStoragePermission: (): boolean => {
          return false;
        },
        checkLocationPermission: (): boolean => {
          return false;
        }
      });

      expect(manager.checkCameraPermission()).assertFalse();
      expect(manager.checkStoragePermission()).assertFalse();
      expect(manager.checkLocationPermission()).assertFalse();
    });

    it('CameraPermissionManager_RequestAllPermissionsCanRepresentFullDenial_016', 0, () => {
      // 业务背景：灰度和异常流回归必须覆盖完全拒绝场景，而不仅仅是默认成功路径。
      // 这里通过组合打桩模拟“所有必要权限都失败”的极端首启场景。
      restoreMethods = patchPermissionMethods({
        requestCameraPermission: (): boolean => {
          return false;
        },
        requestStoragePermission: (): boolean => {
          return false;
        }
      });

      expect(manager.requestAllPermissions()).assertFalse();
    });

    it('CameraPermissionManager_RequestAllPermissionsCanRepresentRecoveryPath_017', 0, () => {
      // 业务背景：用户重新进入授权页后，先前失败的权限可能转为成功。
      // 这条用例用显式打桩表达“恢复后主链路重新可用”，确保组合逻辑可回到成功态。
      restoreMethods = patchPermissionMethods({
        requestCameraPermission: (): boolean => {
          return true;
        },
        requestStoragePermission: (): boolean => {
          return true;
        }
      });

      expect(manager.requestAllPermissions()).assertTrue();
    });

    it('CameraPermissionManager_HighFrequencyRationaleChecksHandleMixedInputs_018', 0, () => {
      // 业务背景：权限文案入口可能被不同页面和不同按钮重复触发。
      // 这里把空值、空白和值得展示的权限名混合调用，验证边界输入不会串扰后续结果。
      let inputs: PermissionMatrixCase[] = [
        { permission: '', expected: false },
        { permission: ' ', expected: true },
        { permission: 'camera', expected: true },
        { permission: 'storage', expected: true },
        { permission: '', expected: false }
      ];

      for (let index = 0; index < inputs.length; index++) {
        let currentCase = inputs[index];
        expect(manager.showPermissionRationale(currentCase.permission)).assertEqual(currentCase.expected);
      }
    });
  });
}
