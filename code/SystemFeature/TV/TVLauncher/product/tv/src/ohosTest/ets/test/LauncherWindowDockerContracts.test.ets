/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect } from '@ohos/hypium';
import { AppItemInfo as CommonAppItemInfo } from '../../../../../../common/src/main/ets/default/bean/AppItemInfo';
import { launcherAbilityManager } from '../../../../../../common/src/main/ets/default/manager/LauncherAbilityManager';
import { windowManager } from '../../../../../../common/src/main/ets/default/manager/WindowManager';
import { DockerAppStorage } from '../../../main/ets/common/baseUtil/dockerAppStorage';
import { AppItemInfo } from '../../../main/ets/common/bean/AppItemInfo';

function makeCommonApp(bundleName: string, appName: string): CommonAppItemInfo {
  const app = new CommonAppItemInfo();
  app.bundleName = bundleName;
  app.appName = appName;
  app.appIconId = 1;
  app.abilityName = 'EntryAbility';
  app.moduleName = 'entry';
  return app;
}

export default function launcherWindowDockerContractsTest() {
  describe('LauncherWindowDockerContracts_Test', () => {
    it('docker_storage_should_expose_core_policy_lists', 0, () => {
      expect(DockerAppStorage.defaultOrderBundleNames.length > 0).assertTrue();
      expect(DockerAppStorage.canNotMoveBundleNames.length > 0).assertTrue();
      expect(DockerAppStorage.canNotRemoveBundleNames.length > 0).assertTrue();
    });

    it('docker_storage_constructor_should_create_instance', 0, () => {
      const storage = new DockerAppStorage();
      expect(typeof storage.getDockerAppItemInfos).assertEqual('function');
      expect(typeof storage.setOrderBundleNames).assertEqual('function');
    });

    it('docker_appInit_should_apply_fixed_policy_for_known_bundle', 0, () => {
      const app = new AppItemInfo();
      app.bundleName = 'com.ohos.inputsource';
      DockerAppStorage.appInit(app);
      expect(app.canMove).assertFalse();
      expect(app.canRemove).assertFalse();
      expect(app.icon).assertEqual('/common/pics/appList/icon_dtv.png');
    });

    it('docker_appInit_should_keep_unknown_bundle_mutable', 0, () => {
      const app = new AppItemInfo();
      app.bundleName = 'com.demo.unknown';
      DockerAppStorage.appInit(app);
      expect(app.canMove).assertTrue();
      expect(app.canRemove).assertTrue();
    });

    it('launcher_ability_manager_should_expose_expected_public_methods', 0, () => {
      expect(typeof launcherAbilityManager.getAppInfoWithBundleNames).assertEqual('function');
      expect(typeof launcherAbilityManager.getAppInfoByBundleName).assertEqual('function');
      expect(typeof launcherAbilityManager.startLauncherAbility).assertEqual('function');
      expect(typeof launcherAbilityManager.startAbilityFormEdit).assertEqual('function');
      expect(typeof launcherAbilityManager.startLauncherAbilityByUri).assertEqual('function');
      expect(typeof launcherAbilityManager.getShortcutInfo).assertEqual('function');
    });

    it('launcher_ability_manager_should_expose_numeric_user_id', 0, () => {
      expect(typeof launcherAbilityManager.getUserId()).assertEqual('number');
    });

    it('window_manager_should_expose_create_and_destroy_methods', 0, () => {
      expect(typeof windowManager.createWindowWithName).assertEqual('function');
      expect(typeof windowManager.createRecentWindow).assertEqual('function');
      expect(typeof windowManager.destroyWindow).assertEqual('function');
      expect(typeof windowManager.minimizeAllApps).assertEqual('function');
    });

    it('window_manager_should_expose_expected_window_names', 0, () => {
      expect(windowManager.RECENT_WINDOW_NAME).assertEqual('RecentView');
      expect(windowManager.FORM_MANAGER_WINDOW_NAME).assertEqual('FormManagerView');
      expect(windowManager.DESKTOP_WINDOW_NAME).assertEqual('EntryView');
    });

    it('common_app_item_builder_helper_should_build_entry_ability_app', 0, () => {
      const app = makeCommonApp('com.demo.bundle', 'Demo');
      expect(app.bundleName).assertEqual('com.demo.bundle');
      expect(app.appName).assertEqual('Demo');
      expect(app.abilityName).assertEqual('EntryAbility');
      expect(app.moduleName).assertEqual('entry');
    });
  });
}
