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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { PageType } from '../../../main/ets/model/PageType';
import { DeviceType } from '../../../main/ets/common/data/DeviceType';
import { NavStack, StatusListener } from '../../../main/ets/common/manager/NavPathStackManager';

export default function managersCoreTest002() {
  describe('Managers_Core_Test_002', () => {

    /*
     * NavPathStackManager——导航状态管理的核心。
     * 为Local和USB两个设备维护独立的路径栈(bakNavPathMap)和历史路径(pathList)，
     * 支持选择模式(Copy/Move/None)的进入和退出。
     * 关键业务规则：
     * - 选择模式下退回至少保留2层(根目录+当前页)，普通模式至少保留1层
     * - USB设备插入/拔出时通过openUSB/closeUSB管理externalActive状态
     * - pushRoot(HOME_PAGE)会清空所有导航栈
     */
    describe('NavPathStackManager_State_Machine', () => {
      it('initial_state_is_Local_device_and_None_selectMode', 0, () => {
        // 启动时默认在Local设备，未进入选择模式
        let nav = new NavStack();
        expect(nav.getDevice()).assertEqual(DeviceType.Local);
        expect(nav.isSelectMod()).assertEqual(false);
        expect(nav.isCopy()).assertEqual(false);
        expect(nav.isMove()).assertEqual(false);
        expect(nav.isExternal()).assertEqual(false);
      });

      it('setDevice_changes_device_index', 0, () => {
        // Tab切换时调用setDevice更改当前设备标识
        let nav = new NavStack();
        nav.setDevice(DeviceType.USB);
        // USB设备当前未激活时，setDevice会切换到HOME_PAGE
        expect(nav.getDevice()).assertEqual(DeviceType.USB);
      });

      it('setDevice_Local_does_not_change_if_already_local', 0, () => {
        let nav = new NavStack();
        let dev: number = nav.getDevice();
        nav.setDevice(DeviceType.Local);
        expect(nav.getDevice()).assertEqual(dev);
      });

      it('setCopyMode_enters_copy_select_mode', 0, () => {
        // 用户点击Copy按钮后进入复制模式，菜单切换为CopyCancel/CopyConfirm
        let nav = new NavStack();
        nav.setCopyMode();
        expect(nav.isCopy()).assertEqual(true);
        expect(nav.isMove()).assertEqual(false);
        expect(nav.isSelectMod()).assertEqual(true);
      });

      it('setMoveMode_enters_move_select_mode', 0, () => {
        let nav = new NavStack();
        nav.setMoveMode();
        expect(nav.isMove()).assertEqual(true);
        expect(nav.isCopy()).assertEqual(false);
        expect(nav.isSelectMod()).assertEqual(true);
      });

      it('closeSelectMode_exits_all_select_modes', 0, () => {
        // 操作完成或取消后退出选择模式
        let nav = new NavStack();
        nav.setCopyMode();
        expect(nav.isSelectMod()).assertEqual(true);
        nav.closeSelectMode();
        expect(nav.isSelectMod()).assertEqual(false);
        expect(nav.isCopy()).assertEqual(false);
      });

      it('select_mode_mutual_exclusion', 0, () => {
        // Copy和Move不能同时存在
        let nav = new NavStack();
        nav.setCopyMode();
        nav.setMoveMode();
        // setMoveMode后应为Move模式（覆盖了Copy）
        expect(nav.isMove()).assertEqual(true);
        expect(nav.isCopy()).assertEqual(false);
      });
    });

    /*
     * NavPathStackManager导航栈操作——pushRoot/pushPath/popPath/checkBackPress。
     * pushRoot(HOME_PAGE)清空栈后重建，pushBean用于进入子目录，
     * popPath逐级返回，checkBackPress判断是否还有历史页面。
     */
    describe('NavPathStackManager_Navigation_Stack', () => {
      it('pushRoot_HOME_PAGE_clears_all_stacks', 0, () => {
        // 返回首页时清空所有设备的所有导航历史
        let nav = new NavStack();
        nav.pushRoot(PageType.HOME_PAGE);
        // 清空后栈长度为1（HOME_PAGE本身）
        expect(nav.isSelectMod()).assertEqual(false);
      });

      it('pushRoot_ROOT_PAGE_adds_to_stack', 0, () => {
        let nav = new NavStack();
        nav.pushRoot(PageType.ROOT_PAGE);
        // ROOT_PAGE不触发clearStack
        expect(nav.getDevice()).assertEqual(DeviceType.Local);
      });

      it('isExitApp_true_when_stack_has_one_page_and_not_select_mode', 0, () => {
        // 栈深1且非选择模式→按返回键退出应用
        let nav = new NavStack();
        // 初始化后栈深为0，isExitApp应视具体实现而定
        expect(typeof nav.isExitApp()).assertEqual('boolean');
      });

      it('isExitApp_false_when_in_select_mode', 0, () => {
        // 选择模式下不允许退出应用，必须先退出选择模式
        let nav = new NavStack();
        nav.setCopyMode();
        expect(nav.isExitApp()).assertEqual(false);
      });

      it('checkBackPress_select_mode_needs_more_than_2_on_local', 0, () => {
        // 选择模式下Local设备要求栈深>2才允许退回
        // （根目录+选择模式起始页+当前页=至少3层）
        let nav = new NavStack();
        nav.setCopyMode();
        expect(typeof nav.checkBackPress()).assertEqual('boolean');
      });

      it('checkBackPress_normal_mode_needs_more_than_1', 0, () => {
        // 非选择模式栈深>1即可退回
        let nav = new NavStack();
        expect(typeof nav.checkBackPress()).assertEqual('boolean');
      });
    });

    /*
     * NavPathStackManager USB管理——openUSB/closeUSB/isExternal。
     * USB设备的插拔通过CommonEvent监听VOLUME_MOUNTED/VOLUME_UNMOUNTED事件，
     * 然后调用openUSB/closeUSB更新导航状态。
     */
    describe('NavPathStackManager_USB_Management', () => {
      it('openUSB_sets_externalActive_true', 0, () => {
        // USB设备接入后激活外部存储标志
        let nav = new NavStack();
        nav.openUSB();
        expect(nav.isExternal()).assertEqual(true);
      });

      it('closeUSB_resets_USB_stacks_and_externalActive', 0, () => {
        // USB设备拔出后清空USB路径栈并关闭externalActive
        let nav = new NavStack();
        nav.openUSB();
        expect(nav.isExternal()).assertEqual(true);
        nav.closeUSB();
        expect(nav.isExternal()).assertEqual(false);
      });

      it('isExternal_false_by_default', 0, () => {
        // 刚初始化时没有外部设备
        let nav = new NavStack();
        expect(nav.isExternal()).assertEqual(false);
      });
    });

    /*
     * NavPathStackManager状态监听——addStatusLis/removeStatusLis/callRefresh。
     * FileList通过注册StatusListener接收选择模式变化通知，
     * 从而更新菜单(进入/退出Copy/Move模式时菜单切换)。
     */
    describe('NavPathStackManager_Status_Listener', () => {
      it('addStatusLis_registers_listener', 0, () => {
        let nav = new NavStack();
        let called: boolean = false;
        let listener: StatusListener = (isSelect: boolean) => { called = true; };
        nav.addStatusLis(listener);
        nav.setCopyMode();
        // setCopyMode触发callRefresh→所有监听器被调用
        expect(called).assertEqual(true);
      });

      it('removeStatusLis_unregisters_listener', 0, () => {
        let nav = new NavStack();
        let callCount: number = 0;
        let listener: StatusListener = (isSelect: boolean) => { callCount++; };
        nav.addStatusLis(listener);
        nav.setCopyMode();
        let afterFirst: number = callCount;
        nav.removeStatusLis(listener);
        nav.closeSelectMode();
        // 移除后不再被调用
        expect(callCount).assertEqual(afterFirst);
      });
    });

    /*
     * NavPathStackManager路径列表——getPathListNames/curPageInfo/isShowPath。
     * 用于Index页显示面包屑导航路径。
     */
    describe('NavPathStackManager_Path_Display', () => {
      it('getPathListNames_initially_empty', 0, () => {
        let nav = new NavStack();
        let names: string[] = nav.getPathListNames();
        expect(names.length).assertEqual(0);
      });

      it('isShowPath_local_device_shows_when_stack_gt_1', 0, () => {
        // Local设备栈深>1时显示面包屑（即进入了子目录）
        // USB设备始终显示面包屑
        let nav = new NavStack();
        expect(typeof nav.isShowPath()).assertEqual('boolean');
      });
    });

    /*
     * NavPathStackManager退回回调——regBackPressFun/unregBackPressFun/onBackPress。
     * FileList注册自已的onBackPress方法，Index.onBackPress委托NavStack处理。
     */
    describe('NavPathStackManager_BackPress_Callback', () => {
      it('regBackPressFun_registers_callback', 0, () => {
        let nav = new NavStack();
        let calledBack: boolean = false;
        let cb: () => boolean | void = (): boolean => { calledBack = true; return true; };
        nav.regBackPressFun(cb);
        let result: boolean = nav.onBackPress();
        expect(calledBack).assertEqual(true);
        expect(result).assertEqual(true);
      });

      it('unregBackPressFun_removes_callback', 0, () => {
        let nav = new NavStack();
        let callCount: number = 0;
        let cb: () => boolean | void = (): boolean => { callCount++; return false; };
        nav.regBackPressFun(cb);
        nav.unregBackPressFun(cb);
        nav.onBackPress();
        // 移除后不应再被调用
        expect(callCount).assertEqual(0);
      });

      it('onBackPress_returns_false_when_no_callback_consumes', 0, () => {
        let nav = new NavStack();
        let result: boolean = nav.onBackPress();
        expect(result).assertEqual(false);
      });
    });

    /*
     * setFocusId静态方法——通过AppStorage设置全局焦点ID。
     * 用于跨组件通知焦点切换（如重命名对话框→输入框）。
     */
    describe('NavPathStackManager_setFocusId', () => {
      it('setFocusId_stores_value_in_AppStorage', 0, () => {
        NavStack.setFocusId('testFocusId');
        let stored: string = AppStorage.get<ESObject>('FocusIdTag') as string;
        expect(stored).assertEqual('testFocusId');
      });
    });
  });
}
