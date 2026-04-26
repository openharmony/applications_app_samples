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
 

import { describe, it, expect } from '@ohos/hypium';
import Constants, { ServiceStubCode } from '../../../../../../product/default/dialog/src/main/ets/common/Constants';
import SystemDialogController, {
  SystemDialogContextBase
} from '../../../../../../product/default/dialog/src/main/ets/controller/Controller';
import type { IDialogParameters } from '../../../../../../product/default/dialog/src/main/ets/controller/Controller';

class MockContext extends SystemDialogContextBase {
  terminated: boolean = false;

  terminateSelf(): void {
    this.terminated = true;
  }
}

class DialogParameters implements IDialogParameters {
  bundleName: string;
  abilityName: string;
  constructor(bundleName: string, abilityName: string) {
    this.bundleName = bundleName;
    this.abilityName = abilityName;
  }
}

export default function dialogModuleTest() {
  describe('DialogModule_Test', () => {

    // SystemDialogController 管理系统弹窗的生命周期，
    // 以 windowName 为 key 存储每个 dialog 的数据和远程对象引用，
    // clear 时统一释放资源并终止 Ability，防止弹窗进程在后台常驻消耗内存。
    // ServiceStubCode 是 IDL 通信的命令分发依据，值的唯一性直接决定调用是否路由正确。
    it('constants_should_match_expected_values', 0, () => {
      expect(Constants.SYSTEM_DIALOG_CONTROLLER).assertEqual('SystemDialog_Controller');
      expect(ServiceStubCode.COMMAND_START_DIALOG).assertEqual(1);
      expect(ServiceStubCode.COMMAND_SEND_REMOTE_OBJECT).assertEqual(2);
    });

    it('controller_should_store_and_get_data_by_key', 0, () => {
      const context = new MockContext();
      const controller = new SystemDialogController(context);
      const params = new DialogParameters('bundle', 'ability');
      controller.addDataByKey('k1', 'DialogWindow1', params);

      expect(controller.getData().has('k1')).assertTrue();
      expect(controller.getData().get('k1')!.windowName).assertEqual('DialogWindow1');
    });

    it('clearRemoteObject_should_keep_entry_and_not_throw', 0, () => {
      const context = new MockContext();
      const controller = new SystemDialogController(context);
      const params = new DialogParameters('bundle', 'ability');
      controller.addDataByKey('k2', 'DialogWindow2', params);
      controller.clearRemoteObject('k2');

      expect(controller.getData().has('k2')).assertTrue();
    });

    it('clear_should_release_data_and_context', 0, () => {
      // clear 在弹窗关闭时调用，必须同时清空数据、释放 context 引用并终止 Ability，
      // 三步缺一都会导致内存泄漏或下次弹窗时状态残留。
      const context = new MockContext();
      const controller = new SystemDialogController(context);
      const params = new DialogParameters('bundle', 'ability');
      controller.addDataByKey('k3', 'DialogWindow3', params);
      controller.clear();

      expect(controller.getData().size).assertEqual(0);
      expect(context.terminated).assertTrue();
      expect(controller.getContext()).assertNull();
    });

    it('addDataByKey_multiple_keys_stored_independently', 0, () => {
      // 多个 dialog 实例各自维护独立的 key，不相互覆盖
      const controller = new SystemDialogController(new MockContext());
      controller.addDataByKey('win1', 'W1', new DialogParameters('b1', 'a1'));
      controller.addDataByKey('win2', 'W2', new DialogParameters('b2', 'a2'));
      expect(controller.getData().size).assertEqual(2);
      expect(controller.getData().get('win1')!.windowName).assertEqual('W1');
      expect(controller.getData().get('win2')!.windowName).assertEqual('W2');
    });

    it('addDataByKey_overwrites_existing_key', 0, () => {
      // 相同 key 再次添加应覆盖旧数据，保证 dialog 状态刷新正确
      const controller = new SystemDialogController(new MockContext());
      controller.addDataByKey('k', 'Old', new DialogParameters('b', 'a'));
      controller.addDataByKey('k', 'New', new DialogParameters('b', 'a'));
      expect(controller.getData().get('k')!.windowName).assertEqual('New');
    });

    it('getData_returns_empty_map_on_new_instance', 0, () => {
      const controller = new SystemDialogController(new MockContext());
      expect(controller.getData().size).assertEqual(0);
    });

    it('ServiceStubCode_values_are_unique', 0, () => {
      // 每个命令码必须唯一，否则 IDL stub 会分发到错误处理分支
      const codes: number[] = [
        ServiceStubCode.COMMAND_START_DIALOG,
        ServiceStubCode.COMMAND_SEND_REMOTE_OBJECT,
      ];
      const unique = new Set(codes);
      expect(unique.size).assertEqual(codes.length);
    });

    it('clearRemoteObject_on_multiple_keys_does_not_remove_others', 0, () => {
      const controller = new SystemDialogController(new MockContext());
      controller.addDataByKey('k1', 'W1', new DialogParameters('b', 'a'));
      controller.addDataByKey('k2', 'W2', new DialogParameters('b', 'a'));
      controller.clearRemoteObject('k1');
      // k2 应仍然存在
      expect(controller.getData().has('k2')).assertTrue();
    });

  });
}
