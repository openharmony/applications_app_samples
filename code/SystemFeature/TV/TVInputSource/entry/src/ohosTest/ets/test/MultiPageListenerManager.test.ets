/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeEach, it, expect } from '@ohos/hypium';
import { MultiPageListenerManager, MultiPageListenerType } from '../../../main/ets/manager/MultiPageListenerManager';
import { SourcePlugState } from '../../../main/ets/manager/SourceManager';

/**
 * Registers tests for listener registration, replacement and fan-out semantics.
 *
 * @returns void.
 */
export default function MultiPageListenerManagerTest(): void {
  describe('MultiPageListenerManager_real', () => {
    let manager: MultiPageListenerManager;
    let notifications: string[];

    beforeEach(() => {
      manager = new MultiPageListenerManager();
      notifications = [];
    });

    it('should_notify_all_registered_pages_about_plug_change', 0, () => {
      const first = new MultiPageListenerType();
      first.id = 'pageA';
      first.onPlugChange = (plugState: SourcePlugState): void => {
        notifications.push(`${first.id}:${plugState.source}:${plugState.isPluIn}`);
      };

      const second = new MultiPageListenerType();
      second.id = 'pageB';
      second.onPlugChange = (plugState: SourcePlugState): void => {
        notifications.push(`${second.id}:${plugState.source}:${plugState.isPluIn}`);
      };

      // Shared fan-out is the core contract of this manager. Every active page
      // must hear the same event so hidden routes remain visually consistent.
      manager.register(first);
      manager.register(second);
      manager.onPlugChange({ source: 2, isPluIn: true });

      expect(notifications.join(',')).assertEqual('pageA:2:true,pageB:2:true');
    });

    it('should_replace_listener_when_same_page_registers_again', 0, () => {
      const stale = new MultiPageListenerType();
      stale.id = 'pageA';
      stale.onPlugChange = (): void => {
        notifications.push('stale');
      };

      const fresh = new MultiPageListenerType();
      fresh.id = 'pageA';
      fresh.onPlugChange = (): void => {
        notifications.push('fresh');
      };

      // Re-registration happens after page recreation. Replacing by id avoids
      // duplicate callbacks and keeps the newest page instance authoritative.
      manager.register(stale);
      manager.register(fresh);
      manager.onPlugChange({ source: 1, isPluIn: false });

      expect(notifications.join(',')).assertEqual('fresh');
    });

    it('should_stop_notifying_listener_after_unregister', 0, () => {
      const listener = new MultiPageListenerType();
      listener.id = 'pageA';
      listener.onPlugChange = (): void => {
        notifications.push('active');
      };

      manager.register(listener);
      manager.unregister(listener);
      manager.onPlugChange({ source: 5, isPluIn: false });

      expect(notifications.length).assertEqual(0);
    });
  });
}

