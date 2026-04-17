/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect } from '@ohos/hypium';
import { AbilityConstant } from '@kit.AbilityKit';
import { Log } from '../../../../../../common/src/main/ets/default/utils/Log';
import { launcherAbilityManager } from '../../../../../../common/src/main/ets/default/manager/LauncherAbilityManager';
import { windowManager } from '../../../../../../common/src/main/ets/default/manager/WindowManager';
import { StyleConstants } from '../../../../../../common/src/main/ets/default/constants/StyleConstants';

interface LauncherListenerRecord {
  event: string;
  bundleName: string;
  userId: number;
}

interface LauncherAbilityManagerPrivate {
  mLauncherAbilityChangeListeners: ((event: string, bundleName: string, userId: number) => void)[];
  notifyLauncherAbilityChange: (event: string, bundleName: string, userId: number) => void;
}

export default function managerAndLoggingContractsTest() {
  describe('ManagerAndLoggingContracts_Test', () => {
    it('log_should_expose_all_standard_methods', 0, () => {
      expect(typeof Log.showInfo).assertEqual('function');
      expect(typeof Log.showDebug).assertEqual('function');
      expect(typeof Log.showWarn).assertEqual('function');
      expect(typeof Log.showError).assertEqual('function');
      expect(typeof Log.showFatal).assertEqual('function');
    });

    it('launcher_ability_manager_should_expose_core_public_api', 0, () => {
      expect(typeof launcherAbilityManager.getUserId).assertEqual('function');
      expect(typeof launcherAbilityManager.registerLauncherAbilityChangeListener).assertEqual('function');
      expect(typeof launcherAbilityManager.unregisterLauncherAbilityChangeListener).assertEqual('function');
      expect(typeof launcherAbilityManager.getLauncherAbilityList).assertEqual('function');
      expect(typeof launcherAbilityManager.getAppInfoByBundleName).assertEqual('function');
      expect(typeof launcherAbilityManager.startLauncherAbility).assertEqual('function');
      expect(typeof launcherAbilityManager.startLauncherAbilityByUri).assertEqual('function');
    });

    it('launcher_ability_manager_should_dispatch_internal_listener_notification', 0, () => {
      const manager = launcherAbilityManager as Object as LauncherAbilityManagerPrivate;
      const listenerList = manager.mLauncherAbilityChangeListeners;
      const originalListeners = listenerList.slice();
      const received: LauncherListenerRecord[] = [];

      listenerList.length = 0;
      listenerList.push((event: string, bundleName: string, userId: number) => {
        received.push({ event, bundleName, userId });
      });

      manager.notifyLauncherAbilityChange('launcher.event.TEST', 'com.demo.bundle', 100);

      expect(received.length).assertEqual(1);
      expect(received[0].event).assertEqual('launcher.event.TEST');
      expect(received[0].bundleName).assertEqual('com.demo.bundle');
      expect(received[0].userId).assertEqual(100);

      listenerList.length = 0;
      for (let i = 0; i < originalListeners.length; i++) {
        listenerList.push(originalListeners[i]);
      }
    });

    it('launcher_ability_manager_user_id_should_be_numeric', 0, () => {
      expect(typeof launcherAbilityManager.getUserId()).assertEqual('number');
    });

    it('window_manager_should_expose_core_window_names_and_ranks', 0, () => {
      expect(windowManager.DESKTOP_WINDOW_NAME).assertEqual('EntryView');
      expect(windowManager.RECENT_WINDOW_NAME).assertEqual('RecentView');
      expect(windowManager.APP_CENTER_WINDOW_NAME).assertEqual('AppCenterView');
      expect(windowManager.FORM_MANAGER_WINDOW_NAME).assertEqual('FormManagerView');
      expect(windowManager.DESKTOP_RANK > 0).assertTrue();
      expect(windowManager.RECENT_RANK > 0).assertTrue();
      expect(windowManager.DOCK_RANK > 0).assertTrue();
    });

    it('window_manager_should_use_desktop_background_for_desktop_window', 0, () => {
      expect(windowManager.getBackgroundColor(windowManager.DESKTOP_WINDOW_NAME))
        .assertEqual(StyleConstants.DEFAULT_DESKTOP_BG_COLOR);
    });

    it('window_manager_should_use_system_ui_background_for_non_desktop_window', 0, () => {
      expect(windowManager.getBackgroundColor(windowManager.RECENT_WINDOW_NAME))
        .assertEqual(StyleConstants.DEFAULT_SYSTEM_UI_COLOR);
      expect(windowManager.getBackgroundColor('UnknownWindow'))
        .assertEqual(StyleConstants.DEFAULT_SYSTEM_UI_COLOR);
    });

    it('window_manager_split_mode_check_should_match_window_modes', 0, () => {
      expect(windowManager.isSplitWindowMode(AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_PRIMARY)).assertTrue();
      expect(windowManager.isSplitWindowMode(AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_SECONDARY)).assertTrue();
      expect(windowManager.isSplitWindowMode(AbilityConstant.WindowMode.WINDOW_MODE_FULLSCREEN)).assertFalse();
    });
  });
}
