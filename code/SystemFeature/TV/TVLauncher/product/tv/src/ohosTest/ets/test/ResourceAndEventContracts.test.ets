/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect } from '@ohos/hypium';
import commonEventManager from '../../../../../../common/src/main/ets/default/manager/CommonEventManager';
import { ResourceManager } from '../../../../../../common/src/main/ets/default/manager/ResourceManager';

export default function resourceAndEventContractsTest() {
  describe('ResourceAndEventContracts_Test', () => {
    it('common_event_manager_should_expose_expected_event_names', 0, () => {
      expect(commonEventManager.RECENT_FULL_SCREEN).assertEqual('CREATE_RECENT_WINDOW_EVENT');
      expect(commonEventManager.RECENT_SPLIT_SCREEN).assertEqual('common.event.SPLIT_SCREEN');
    });

    it('common_event_manager_should_expose_register_and_unregister_methods', 0, () => {
      expect(typeof commonEventManager.registerCommonEvent).assertEqual('function');
      expect(typeof commonEventManager.unregisterCommonEvent).assertEqual('function');
    });

    it('resource_manager_should_expose_singleton_instance', 0, () => {
      const instance1 = ResourceManager.getInstance();
      const instance2 = ResourceManager.getInstance();
      expect(instance1 === instance2).assertTrue();
    });

    it('resource_manager_should_expose_core_public_methods', 0, () => {
      const manager = ResourceManager.getInstance();
      expect(typeof manager.getCachedAppIcon).assertEqual('function');
      expect(typeof manager.setAppResourceCache).assertEqual('function');
      expect(typeof manager.deleteAppResourceCache).assertEqual('function');
      expect(typeof manager.updateIconCache).assertEqual('function');
      expect(typeof manager.getAppIconWithCache).assertEqual('function');
      expect(typeof manager.getAppNameSync).assertEqual('function');
      expect(typeof manager.getAppNameWithCache).assertEqual('function');
      expect(typeof manager.getStringById).assertEqual('function');
      expect(typeof manager.getStringByIdSync).assertEqual('function');
      expect(typeof manager.getStringByResource).assertEqual('function');
    });

    it('resource_manager_getAppIconWithCache_should_return_default_when_icon_invalid', 0, () => {
      const manager = ResourceManager.getInstance();
      let received = '';

      manager.getAppIconWithCache(0, 'bundle.demo', 'entry', 'default-icon', (value: string) => {
        received = value;
      });

      expect(received).assertEqual('default-icon');
    });

    it('resource_manager_getAppNameSync_should_fallback_to_appName_when_label_invalid', 0, async () => {
      const manager = ResourceManager.getInstance();
      const result = await manager.getAppNameSync(0, 'bundle.demo', 'entry', 'FallbackApp');
      expect(result).assertEqual('FallbackApp');
    });

    it('resource_manager_getStringByIdSync_should_return_empty_for_invalid_id', 0, async () => {
      const manager = ResourceManager.getInstance();
      const result = await manager.getStringByIdSync(0);
      expect(result).assertEqual('');
    });
  });
}
