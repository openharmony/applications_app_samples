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

import { describe, it, expect, beforeEach, afterEach } from '@ohos/hypium';
import { KeyCode } from '@kit.InputKit';

const TAG = '[AutomatedSearch.Flow.test]';

enum KeyType {
  Down = 'Down',
  Up = 'Up'
}

export interface AutomatedSearchConfig {
  message: string;
  title: string;
  confirmCallback: () => void;
}

export interface AutomatedSearchFocusState {
  focusId: string;
  selectedFontColor: string;
  unSelectedFontColor: string;
  selectedBgColor: string;
  unselectedBgColor: string;
}

class AutomatedSearchLifecycle {
  public config: AutomatedSearchConfig | null = null;
  public focusState: AutomatedSearchFocusState | null = null;
  public isConfirmCalled: boolean = false;
  public isDialogClosed: boolean = false;
  public lastKeyEvent: string = '';

  public reset(): void {
    this.config = null;
    this.focusState = null;
    this.isConfirmCalled = false;
    this.isDialogClosed = false;
    this.lastKeyEvent = '';
  }

  public initializeConfig(title: string = 'Default title', message: string = 'Default message'): void {
    this.config = {
      message: message,
      title: title,
      confirmCallback: () => {
        this.isConfirmCalled = true;
      }
    };
  }

  public initializeFocusState(initialFocusId: string = 'cancel'): void {
    this.focusState = {
      focusId: initialFocusId,
      selectedFontColor: '#DB000000',
      unSelectedFontColor: '#DBFFFFFF',
      selectedBgColor: '#DBFFFFFF',
      unselectedBgColor: '#33FFFFFF'
    };
  }

  public getButtonColor(buttonId: string): string {
    if (!this.focusState) {
      return '';
    }
    return this.focusState.focusId === buttonId ?
      this.focusState.selectedBgColor : this.focusState.unselectedBgColor;
  }

  public getButtonFontColor(buttonId: string): string {
    if (!this.focusState) {
      return '';
    }
    return this.focusState.focusId === buttonId ?
      this.focusState.selectedFontColor : this.focusState.unSelectedFontColor;
  }

  public handleKeyEvent(keyCode: number, keyType: KeyType): void {
    if (!this.focusState) {
      return;
    }
    this.lastKeyEvent = `keyCode=${keyCode},type=${keyType}`;

    if (keyType === KeyType.Up) {
      if (keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
        this.focusState.focusId = 'cancel';
      } else if (keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
        this.focusState.focusId = 'sure';
      }
    }

    if (keyType === KeyType.Down && keyCode === KeyCode.KEYCODE_ENTER) {
      if (this.focusState.focusId === 'cancel') {
        this.isDialogClosed = true;
      } else if (this.focusState.focusId === 'sure') {
        this.isConfirmCalled = true;
        this.isDialogClosed = true;
      }
    }
  }

  public handleHover(buttonId: string): void {
    if (!this.focusState) {
      return;
    }
    this.focusState.focusId = buttonId;
  }

  public handleTouch(buttonId: string): void {
    if (!this.focusState) {
      return;
    }
    this.focusState.focusId = buttonId;
  }
}

const lifecycle = new AutomatedSearchLifecycle();

function runAutomatedSearchInitializationTests(): void {
  describe('AutomatedSearch_initialization', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_initialize_with_default_title_and_message', 0, () => {
      lifecycle.initializeConfig();

      expect(lifecycle.config).assertInstanceOf('Object');
      expect(lifecycle.config?.title).assertEqual('Default title');
      expect(lifecycle.config?.message).assertEqual('Default message');
    });

    it('should_initialize_with_custom_title', 0, () => {
      lifecycle.initializeConfig('Auto search confirmation');

      expect(lifecycle.config?.title).assertEqual('Auto search confirmation');
    });

    it('should_initialize_with_custom_message', 0, () => {
      lifecycle.initializeConfig('default title', 'Please confirm the TV antenna connection.');

      expect(lifecycle.config?.message).assertEqual('Please confirm the TV antenna connection.');
    });

    it('should_initialize_confirm_callback', 0, () => {
      lifecycle.initializeConfig();

      expect(lifecycle.config?.confirmCallback).assertInstanceOf('Function');
      lifecycle.config?.confirmCallback();
      expect(lifecycle.isConfirmCalled).assertEqual(true);
    });

    it('should_initialize_focus_state_with_cancel_focused', 0, () => {
      lifecycle.initializeFocusState('cancel');

      expect(lifecycle.focusState).assertInstanceOf('Object');
      expect(lifecycle.focusState?.focusId).assertEqual('cancel');
    });

    it('should_initialize_focus_state_with_sure_focused', 0, () => {
      lifecycle.initializeFocusState('sure');

      expect(lifecycle.focusState?.focusId).assertEqual('sure');
    });

    it('should_have_correct_color_scheme_in_focus_state', 0, () => {
      lifecycle.initializeFocusState();

      expect(lifecycle.focusState?.selectedFontColor).assertEqual('#DB000000');
      expect(lifecycle.focusState?.unSelectedFontColor).assertEqual('#DBFFFFFF');
      expect(lifecycle.focusState?.selectedBgColor).assertEqual('#DBFFFFFF');
      expect(lifecycle.focusState?.unselectedBgColor).assertEqual('#33FFFFFF');
    });
  });
}

function runAutomatedSearchFocusNavigationTests(): void {
  describe('AutomatedSearch_focus_navigation', () => {
    beforeEach(() => {
      lifecycle.reset();
      lifecycle.initializeConfig();
      lifecycle.initializeFocusState();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_start_with_cancel_button_focused', 0, () => {
      expect(lifecycle.focusState?.focusId).assertEqual('cancel');
    });

    it('should_move_focus_to_sure_on_DPAD_RIGHT', 0, () => {
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_RIGHT, KeyType.Up);

      expect(lifecycle.focusState?.focusId).assertEqual('sure');
    });

    it('should_move_focus_to_cancel_on_DPAD_LEFT', 0, () => {
      lifecycle.initializeFocusState('sure');

      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_LEFT, KeyType.Up);

      expect(lifecycle.focusState?.focusId).assertEqual('cancel');
    });

    it('should_not_change_focus_on_key_down', 0, () => {
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_RIGHT, KeyType.Down);

      expect(lifecycle.focusState?.focusId).assertEqual('cancel');
    });

    it('should_maintain_focus_after_DPAD_LEFT_from_cancel', 0, (done: () => void) => {
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_LEFT, KeyType.Up);

      expect(lifecycle.focusState?.focusId).assertEqual('cancel');
      done();
    });

    it('should_maintain_focus_after_DPAD_RIGHT_from_sure', 0, (done: () => void) => {
      lifecycle.initializeFocusState('sure');

      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_RIGHT, KeyType.Up);

      expect(lifecycle.focusState?.focusId).assertEqual('sure');
      done();
    });

    it('should_change_focus_on_hover_cancel', 0, () => {
      lifecycle.initializeFocusState('sure');

      lifecycle.handleHover('cancel');

      expect(lifecycle.focusState?.focusId).assertEqual('cancel');
    });

    it('should_change_focus_on_hover_sure', 0, () => {
      lifecycle.handleHover('sure');

      expect(lifecycle.focusState?.focusId).assertEqual('sure');
    });

    it('should_change_focus_on_touch_cancel', 0, () => {
      lifecycle.initializeFocusState('sure');

      lifecycle.handleTouch('cancel');

      expect(lifecycle.focusState?.focusId).assertEqual('cancel');
    });

    it('should_change_focus_on_touch_sure', 0, () => {
      lifecycle.handleTouch('sure');

      expect(lifecycle.focusState?.focusId).assertEqual('sure');
    });

    it('should_calculate_correct_button_background_color_when_cancel_focused', 0, () => {
      expect(lifecycle.getButtonColor('cancel')).assertEqual('#DBFFFFFF');
      expect(lifecycle.getButtonColor('sure')).assertEqual('#33FFFFFF');
    });

    it('should_calculate_correct_button_background_color_when_sure_focused', 0, () => {
      lifecycle.initializeFocusState('sure');

      expect(lifecycle.getButtonColor('cancel')).assertEqual('#33FFFFFF');
      expect(lifecycle.getButtonColor('sure')).assertEqual('#DBFFFFFF');
    });

    it('should_calculate_correct_button_font_color_when_cancel_focused', 0, () => {
      expect(lifecycle.getButtonFontColor('cancel')).assertEqual('#DB000000');
      expect(lifecycle.getButtonFontColor('sure')).assertEqual('#DBFFFFFF');
    });

    it('should_calculate_correct_button_font_color_when_sure_focused', 0, () => {
      lifecycle.initializeFocusState('sure');

      expect(lifecycle.getButtonFontColor('cancel')).assertEqual('#DBFFFFFF');
      expect(lifecycle.getButtonFontColor('sure')).assertEqual('#DB000000');
    });
  });
}

function runAutomatedSearchKeyEventHandlingTests(): void {
  describe('AutomatedSearch_key_event_handling', () => {
    beforeEach(() => {
      lifecycle.reset();
      lifecycle.initializeConfig();
      lifecycle.initializeFocusState();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_close_dialog_when_ENTER_on_cancel', 0, () => {
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);

      expect(lifecycle.isDialogClosed).assertEqual(true);
      expect(lifecycle.isConfirmCalled).assertEqual(false);
    });

    it('should_trigger_confirm_and_close_when_ENTER_on_sure', 0, () => {
      lifecycle.initializeFocusState('sure');

      lifecycle.handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);

      expect(lifecycle.isConfirmCalled).assertEqual(true);
      expect(lifecycle.isDialogClosed).assertEqual(true);
    });

    it('should_not_close_dialog_on_key_up', 0, () => {
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Up);

      expect(lifecycle.isDialogClosed).assertEqual(false);
    });

    it('should_record_key_event_info', 0, () => {
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);

      expect(lifecycle.lastKeyEvent).assertEqual('keyCode=0,type=1');
    });

    it('should_not_trigger_confirm_on_DPAD_LEFT', 0, (done: () => void) => {
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_LEFT, KeyType.Up);

      expect(lifecycle.isConfirmCalled).assertEqual(false);
      done();
    });

    it('should_not_trigger_confirm_on_DPAD_RIGHT', 0, (done: () => void) => {
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_RIGHT, KeyType.Up);

      expect(lifecycle.isConfirmCalled).assertEqual(false);
      done();
    });
  });
}

function runAutomatedSearchButtonInteractionTests(): void {
  describe('AutomatedSearch_button_interaction', () => {
    beforeEach(() => {
      lifecycle.reset();
      lifecycle.initializeConfig();
      lifecycle.initializeFocusState();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_close_dialog_on_cancel_click', 0, () => {
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);

      expect(lifecycle.isDialogClosed).assertEqual(true);
    });

    it('should_close_dialog_on_cancel_hover_then_enter', 0, () => {
      lifecycle.handleHover('cancel');

      lifecycle.handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);

      expect(lifecycle.isDialogClosed).assertEqual(true);
    });

    it('should_trigger_confirm_on_sure_hover_then_enter', 0, () => {
      lifecycle.handleHover('sure');

      lifecycle.handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);

      expect(lifecycle.isConfirmCalled).assertEqual(true);
      expect(lifecycle.isDialogClosed).assertEqual(true);
    });

    it('should_handle_rapid_button_switching', 0, (done: () => void) => {
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_RIGHT, KeyType.Up);
      expect(lifecycle.focusState?.focusId).assertEqual('sure');

      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_LEFT, KeyType.Up);
      expect(lifecycle.focusState?.focusId).assertEqual('cancel');

      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_RIGHT, KeyType.Up);
      expect(lifecycle.focusState?.focusId).assertEqual('sure');

      done();
    });

    it('should_maintain_state_across_multiple_key_events', 0, (done: () => void) => {
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_RIGHT, KeyType.Up);
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_LEFT, KeyType.Up);
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_RIGHT, KeyType.Up);
      lifecycle.handleKeyEvent(KeyCode.KEYCODE_DPAD_RIGHT, KeyType.Up);

      expect(lifecycle.focusState?.focusId).assertEqual('sure');
      done();
    });
  });
}

function runAutomatedSearchResultBranchingTests(): void {
  describe('AutomatedSearch_result_branching', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_close_dialog_without_confirm_on_cancel_path', 0, () => {
      lifecycle.initializeConfig('Search confirmation', 'Start auto search now?');
      lifecycle.initializeFocusState('cancel');

      lifecycle.handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);

      expect(lifecycle.isDialogClosed).assertEqual(true);
      expect(lifecycle.isConfirmCalled).assertEqual(false);
    });

    it('should_close_dialog_with_confirm_on_sure_path', 0, () => {
      lifecycle.initializeConfig('Search confirmation', 'Start auto search now?');
      lifecycle.initializeFocusState('sure');

      lifecycle.handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);

      expect(lifecycle.isDialogClosed).assertEqual(true);
      expect(lifecycle.isConfirmCalled).assertEqual(true);
    });

    it('should_support_multiple_dialog_instances_independently', 0, (done: () => void) => {
      const dialog1 = new AutomatedSearchLifecycle();
      const dialog2 = new AutomatedSearchLifecycle();

      dialog1.initializeConfig('Dialog A');
      dialog2.initializeConfig('Dialog B');
      dialog1.initializeFocusState('sure');
      dialog2.initializeFocusState('cancel');

      dialog1.handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);
      dialog2.handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);

      expect(dialog1.isConfirmCalled).assertEqual(true);
      expect(dialog2.isConfirmCalled).assertEqual(false);
      expect(dialog1.isDialogClosed).assertEqual(true);
      expect(dialog2.isDialogClosed).assertEqual(true);

      done();
    });

    it('should_handle_confirm_callback_with_side_effects', 0, () => {
      let searchStarted = false;
      lifecycle.config = {
        message: 'start search',
        title: 'auto search',
        confirmCallback: () => {
          searchStarted = true;
        }
      };
      lifecycle.initializeFocusState('sure');

      lifecycle.config?.confirmCallback();

      expect(searchStarted).assertEqual(true);
    });
  });
}

function runAutomatedSearchRecoveryTests(): void {
  describe('AutomatedSearch_recovery', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_reset_state_on_reset_call', 0, () => {
      lifecycle.initializeConfig('Search', 'Test message');
      lifecycle.initializeFocusState('sure');
      lifecycle.isConfirmCalled = true;
      lifecycle.isDialogClosed = true;

      lifecycle.reset();

      expect(lifecycle.config).assertEqual(null);
      expect(lifecycle.focusState).assertEqual(null);
      expect(lifecycle.isConfirmCalled).assertEqual(false);
      expect(lifecycle.isDialogClosed).assertEqual(false);
    });

    it('should_handle_sequential_dialog_open_close_cycles', 0, (done: () => void) => {
      for (let i = 0; i < 3; i++) {
        lifecycle.initializeConfig(`Search ${i}`, `Message ${i}`);
        lifecycle.initializeFocusState('sure');
        lifecycle.handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);

        expect(lifecycle.isConfirmCalled).assertEqual(true);
        expect(lifecycle.isDialogClosed).assertEqual(true);

        lifecycle.reset();
      }
      done();
    });

    it('should_maintain_independent_state_for_parallel_dialogs', 0, (done: () => void) => {
      const dialogs: AutomatedSearchLifecycle[] = [];

      for (let i = 0; i < 3; i++) {
        const dialog = new AutomatedSearchLifecycle();
        dialog.initializeConfig(`Search ${i}`, `Message ${i}`);
        dialog.initializeFocusState(i % 2 === 0 ? 'cancel' : 'sure');
        dialogs.push(dialog);
      }

      dialogs[0].handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);
      dialogs[1].handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);
      dialogs[2].handleKeyEvent(KeyCode.KEYCODE_ENTER, KeyType.Down);

      expect(dialogs[0].isConfirmCalled).assertEqual(false);
      expect(dialogs[0].isDialogClosed).assertEqual(true);
      expect(dialogs[1].isConfirmCalled).assertEqual(true);
      expect(dialogs[1].isDialogClosed).assertEqual(true);
      expect(dialogs[2].isConfirmCalled).assertEqual(false);
      expect(dialogs[2].isDialogClosed).assertEqual(true);

      done();
    });
  });
}

function runAutomatedSearchBoundaryTests(): void {
  describe('AutomatedSearch_boundary', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_handle_empty_title', 0, () => {
      lifecycle.initializeConfig('', 'message');

      expect(lifecycle.config?.title).assertEqual('');
    });

    it('should_handle_empty_message', 0, () => {
      lifecycle.initializeConfig('title', '');

      expect(lifecycle.config?.message).assertEqual('');
    });

    it('should_handle_very_long_title', 0, () => {
      const longTitle = 'A'.repeat(1000);

      lifecycle.initializeConfig(longTitle);

      expect(lifecycle.config?.title).assertEqual(longTitle);
    });

    it('should_handle_very_long_message', 0, () => {
      const longMessage = 'B'.repeat(5000);

      lifecycle.initializeConfig('title', longMessage);

      expect(lifecycle.config?.message).assertEqual(longMessage);
    });

    it('should_handle_unicode_in_title_and_message', 0, () => {
      lifecycle.initializeConfig('Auto Search', 'Please confirm the TV antenna connection.');

      expect(lifecycle.config?.title).assertEqual('Auto Search');
      expect(lifecycle.config?.message).assertEqual('Please confirm the TV antenna connection.');
    });

    it('should_handle_special_characters_in_title_and_message', 0, () => {
      lifecycle.initializeConfig(`title <>&"'`, 'message with "quotes" & ampersand');

      expect(lifecycle.config?.title).assertEqual(`title <>&"'`);
      expect(lifecycle.config?.message).assertEqual('message with "quotes" & ampersand');
    });
  });
}

export default function automatedSearchFlowTestSuite(): void {
  runAutomatedSearchInitializationTests();
  runAutomatedSearchFocusNavigationTests();
  runAutomatedSearchKeyEventHandlingTests();
  runAutomatedSearchButtonInteractionTests();
  runAutomatedSearchResultBranchingTests();
  runAutomatedSearchRecoveryTests();
  runAutomatedSearchBoundaryTests();
}


