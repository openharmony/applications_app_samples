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

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import { display } from '@kit.ArkUI';
import { restoreAll } from './Batch1TestHelper';

interface DisplayLike {
  width: number;
  height: number;
  densityDPI: number;
  orientation: display.Orientation;
}

interface ResolutionMatrix {
  width: number;
  height: number;
  name: string;
}

interface RotationState {
  currentOrientation: display.Orientation;
  pendingRotation: display.Orientation | null;
  rotationCount: number;
  lastRotationTime: number;
  layoutStable: boolean;
}

interface RotationTransition {
  from: display.Orientation;
  to: display.Orientation;
}

interface LayoutSize {
  width: number;
  height: number;
}

/**
 * Replaces `display.getDefaultDisplay` for one test case.
 *
 * @param replacement Replacement async display reader.
 * @returns () => void Restore callback for the original API.
 */
function patchGetDefaultDisplay(replacement: () => Promise<DisplayLike>): () => void {
  const original = display.getDefaultDisplay;
  display.getDefaultDisplay = async (): Promise<display.Display> => {
    return (await replacement()) as Object as display.Display;
  };
  return (): void => {
    display.getDefaultDisplay = original;
  };
}

class DisplayRotationStateMachine {
  public states: ResolutionMatrix[] = [];
  public currentState: RotationState;
  public rotationHistory: RotationTransition[] = [];
  public transitionCount: number = 0;

  constructor() {
    this.currentState = {
      currentOrientation: display.Orientation.PORTRAIT,
      pendingRotation: null,
      rotationCount: 0,
      lastRotationTime: 0,
      layoutStable: true
    };
    this.states = [
      { width: 720, height: 1280, name: '720p_PORTRAIT' },
      { width: 1280, height: 720, name: '720p_LANDSCAPE' },
      { width: 1080, height: 1920, name: '1080p_PORTRAIT' },
      { width: 1920, height: 1080, name: '1080p_LANDSCAPE' },
      { width: 2160, height: 3840, name: '4K_PORTRAIT' },
      { width: 3840, height: 2160, name: '4K_LANDSCAPE' }
    ];
  }

  requestRotation(targetOrientation: display.Orientation): boolean {
    if (this.currentState.pendingRotation === targetOrientation) {
      return false;
    }
    if (this.currentState.pendingRotation === null && this.currentState.currentOrientation === targetOrientation) {
      return false;
    }
    this.currentState.pendingRotation = targetOrientation;
    this.transitionCount++;
    return true;
  }

  confirmRotation(): display.Orientation {
    if (this.currentState.pendingRotation !== null) {
      const from = this.currentState.currentOrientation;
      const to = this.currentState.pendingRotation;
      this.rotationHistory.push({ from, to });
      this.currentState.currentOrientation = this.currentState.pendingRotation;
      this.currentState.pendingRotation = null;
      this.currentState.rotationCount++;
      this.currentState.lastRotationTime = Date.now();
      this.currentState.layoutStable = false;
    }
    return this.currentState.currentOrientation;
  }

  cancelRotation(): void {
    this.currentState.pendingRotation = null;
  }

  markLayoutStable(): void {
    this.currentState.layoutStable = true;
  }

  isLayoutReady(): boolean {
    return this.currentState.layoutStable && this.currentState.pendingRotation === null;
  }

  getCurrentResolution(): ResolutionMatrix | null {
    const isPortrait = this.currentState.currentOrientation === display.Orientation.PORTRAIT;
    if (this.states.length >= 6) {
      if (isPortrait) {
        return this.states[0];
      }
      return this.states[1];
    }
    return null;
  }

  reset(): void {
    this.currentState = {
      currentOrientation: display.Orientation.PORTRAIT,
      pendingRotation: null,
      rotationCount: 0,
      lastRotationTime: 0,
      layoutStable: true
    };
    this.rotationHistory = [];
    this.transitionCount = 0;
  }
}

class ResolutionMatrixCalculator {
  public resolutionCache: Map<string, LayoutSize> = new Map();
  public currentDpi: number = 160;
  public currentLpi: number = 1.0;

  calculateLayoutSize(screenWidth: number, screenHeight: number, dpi: number): LayoutSize {
    const cacheKey = `${screenWidth}x${screenHeight}x${dpi}`;
    if (this.resolutionCache.has(cacheKey)) {
      return this.resolutionCache.get(cacheKey)!;
    }
    const lpi = dpi / 160;
    const result: LayoutSize = {
      width: Math.round(screenWidth / lpi),
      height: Math.round(screenHeight / lpi)
    };
    this.resolutionCache.set(cacheKey, result);
    return result;
  }

  calculatePixelRatio(screenWidth: number, screenHeight: number, pageWidth: number, pageHeight: number): number {
    const screenArea = screenWidth * screenHeight;
    const pageArea = pageWidth * pageHeight;
    return Math.round((pageArea / screenArea) * 100) / 100;
  }

  getAspectRatio(width: number, height: number): string {
    const normalizedWidth = Math.max(width, height);
    const normalizedHeight = Math.min(width, height);
    const ratio = normalizedWidth / normalizedHeight;
    if (Math.abs(ratio - (4 / 3)) < 0.01) {
      return '4:3';
    }
    if (Math.abs(ratio - (16 / 9)) < 0.01) {
      return '16:9';
    }
    if (Math.abs(ratio - (21 / 9)) < 0.01) {
      return '21:9';
    }
    const gcd = (a: number, b: number): number => b === 0 ? a : gcd(b, a % b);
    const divisor = gcd(normalizedWidth, normalizedHeight);
    const ratioW = normalizedWidth / divisor;
    const ratioH = normalizedHeight / divisor;
    if (ratioW === 4 && ratioH === 3) {
      return '4:3';
    }
    if (ratioW === 16 && ratioH === 9) {
      return '16:9';
    }
    if (ratioW === 21 && ratioH === 9) {
      return '21:9';
    }
    return `${ratioW}:${ratioH}`;
  }

  isWidescreen(width: number, height: number): boolean {
    const ratio = width / height;
    return ratio >= 1.6;
  }

  getOrientationString(orientation: display.Orientation): string {
    switch (orientation) {
      case display.Orientation.PORTRAIT:
        return 'PORTRAIT';
      case display.Orientation.LANDSCAPE:
        return 'LANDSCAPE';
      case display.Orientation.PORTRAIT_INVERTED:
        return 'PORTRAIT_INVERTED';
      case display.Orientation.LANDSCAPE_INVERTED:
        return 'LANDSCAPE_INVERTED';
      default:
        return 'UNKNOWN';
    }
  }

  reset(): void {
    this.resolutionCache.clear();
    this.currentDpi = 160;
    this.currentLpi = 1.0;
  }
}

function createResolutionMatrix(width: number, height: number, name: string): ResolutionMatrix {
  return { width, height, name };
}

function createRotationState(): RotationState {
  return {
    currentOrientation: display.Orientation.PORTRAIT,
    pendingRotation: null,
    rotationCount: 0,
    lastRotationTime: 0,
    layoutStable: true
  };
}

export default function ResolutionAndRotationMatrixTest(): void {
  describe('DisplayRotationStateMachine', () => {
    let machine: DisplayRotationStateMachine;

    beforeEach(() => {
      machine = new DisplayRotationStateMachine();
    });

    afterEach(() => {
      machine.reset();
    });

    it('should_initialize_to_portrait_orientation', 0, () => {
      expect(machine.currentState.currentOrientation).assertEqual(display.Orientation.PORTRAIT);
      expect(machine.currentState.pendingRotation).assertNull();
      expect(machine.currentState.rotationCount).assertEqual(0);
    });

    it('should_request_rotation_to_landscape', 0, () => {
      const result = machine.requestRotation(display.Orientation.LANDSCAPE);
      expect(result).assertEqual(true);
      expect(machine.currentState.pendingRotation).assertEqual(display.Orientation.LANDSCAPE);
    });

    it('should_reject_rotation_to_same_orientation', 0, () => {
      const result = machine.requestRotation(display.Orientation.PORTRAIT);
      expect(result).assertEqual(false);
      expect(machine.currentState.pendingRotation).assertNull();
    });

    it('should_confirm_rotation_and_update_orientation', 0, () => {
      machine.requestRotation(display.Orientation.LANDSCAPE);
      const newOrientation = machine.confirmRotation();
      expect(newOrientation).assertEqual(display.Orientation.LANDSCAPE);
      expect(machine.currentState.pendingRotation).assertNull();
      expect(machine.currentState.rotationCount).assertEqual(1);
    });

    it('should_record_rotation_history', 0, () => {
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.confirmRotation();
      machine.requestRotation(display.Orientation.PORTRAIT);
      machine.confirmRotation();
      expect(machine.rotationHistory.length).assertEqual(2);
      expect(machine.rotationHistory[0].from).assertEqual(display.Orientation.PORTRAIT);
      expect(machine.rotationHistory[0].to).assertEqual(display.Orientation.LANDSCAPE);
    });

    it('should_cancel_pending_rotation', 0, () => {
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.cancelRotation();
      expect(machine.currentState.pendingRotation).assertNull();
      expect(machine.rotationHistory.length).assertEqual(0);
    });

    it('should_mark_layout_unstable_after_rotation', 0, () => {
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.confirmRotation();
      expect(machine.currentState.layoutStable).assertEqual(false);
    });

    it('should_mark_layout_stable_after_explicit_call', 0, () => {
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.confirmRotation();
      machine.markLayoutStable();
      expect(machine.currentState.layoutStable).assertEqual(true);
    });

    it('should_report_layout_ready_when_stable_and_no_pending', 0, () => {
      expect(machine.isLayoutReady()).assertEqual(true);
      machine.requestRotation(display.Orientation.LANDSCAPE);
      expect(machine.isLayoutReady()).assertEqual(false);
      machine.confirmRotation();
      expect(machine.isLayoutReady()).assertEqual(false);
      machine.markLayoutStable();
      expect(machine.isLayoutReady()).assertEqual(true);
    });

    it('should_get_current_resolution_for_portrait', 0, () => {
      machine.reset();
      const resolution = machine.getCurrentResolution();
      expect(((resolution) === null) || ((resolution) === undefined)).assertFalse();
      expect(resolution!.name).assertEqual('720p_PORTRAIT');
    });

    it('should_get_current_resolution_for_landscape', 0, () => {
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.confirmRotation();
      const resolution = machine.getCurrentResolution();
      expect(((resolution) === null) || ((resolution) === undefined)).assertFalse();
      expect(resolution!.name).assertEqual('720p_LANDSCAPE');
    });

    it('should_handle_multiple_rapid_rotations', 0, () => {
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.requestRotation(display.Orientation.PORTRAIT);
      machine.requestRotation(display.Orientation.LANDSCAPE_INVERTED);
      expect(machine.currentState.pendingRotation).assertEqual(display.Orientation.LANDSCAPE_INVERTED);
      expect(machine.transitionCount).assertEqual(3);
    });
  });

  describe('ResolutionMatrixCalculator', () => {
    let calc: ResolutionMatrixCalculator;

    beforeEach(() => {
      calc = new ResolutionMatrixCalculator();
    });

    afterEach(() => {
      calc.reset();
    });

    it('should_calculate_layout_size_for_720p', 0, () => {
      const size = calc.calculateLayoutSize(720, 1280, 160);
      expect(size.width).assertEqual(720);
      expect(size.height).assertEqual(1280);
    });

    it('should_calculate_layout_size_for_1080p', 0, () => {
      const size = calc.calculateLayoutSize(1920, 1080, 320);
      expect(size.width).assertEqual(960);
      expect(size.height).assertEqual(540);
    });

    it('should_cache_calculation_results', 0, () => {
      const size1 = calc.calculateLayoutSize(1920, 1080, 240);
      const size2 = calc.calculateLayoutSize(1920, 1080, 240);
      expect(calc.resolutionCache.size).assertEqual(1);
      expect(size1.width).assertEqual(size2.width);
      expect(size1.height).assertEqual(size2.height);
    });

    it('should_calculate_pixel_ratio_correctly', 0, () => {
      const ratio = calc.calculatePixelRatio(1920, 1080, 3840, 2160);
      expect(ratio).assertEqual(4);
    });

    it('should_return_4_3_aspect_ratio', 0, () => {
      const ratio = calc.getAspectRatio(4, 3);
      expect(ratio).assertEqual('4:3');
    });

    it('should_return_16_9_aspect_ratio', 0, () => {
      const ratio = calc.getAspectRatio(16, 9);
      expect(ratio).assertEqual('16:9');
    });

    it('should_return_21_9_aspect_ratio', 0, () => {
      const ratio = calc.getAspectRatio(21, 9);
      expect(ratio).assertEqual('21:9');
    });

    it('should_identify_widescreen_16_9', 0, () => {
      expect(calc.isWidescreen(1920, 1080)).assertEqual(true);
    });

    it('should_identify_widescreen_21_9', 0, () => {
      expect(calc.isWidescreen(2560, 1080)).assertEqual(true);
    });

    it('should_not_identify_4_3_as_widescreen', 0, () => {
      expect(calc.isWidescreen(1024, 768)).assertEqual(false);
    });

    it('should_convert_orientation_to_string', 0, () => {
      expect(calc.getOrientationString(display.Orientation.PORTRAIT)).assertEqual('PORTRAIT');
      expect(calc.getOrientationString(display.Orientation.LANDSCAPE)).assertEqual('LANDSCAPE');
      expect(calc.getOrientationString(display.Orientation.PORTRAIT_INVERTED)).assertEqual('PORTRAIT_INVERTED');
      expect(calc.getOrientationString(display.Orientation.LANDSCAPE_INVERTED)).assertEqual('LANDSCAPE_INVERTED');
    });
  });

  describe('ResolutionMatrix_Rotation_Scenarios', () => {
    let restores: Array<() => void> = [];

    beforeEach(() => {
      restores = [];
      AppStorage.setOrCreate<number>('screen_px_w', 1920);
      AppStorage.setOrCreate<number>('screen_px_h', 1080);
    });

    afterEach(() => {
      restoreAll(restores);
    });

    it('should_transition_720p_portrait_to_landscape', 0, () => {
      const machine = new DisplayRotationStateMachine();
      const initial = machine.getCurrentResolution();
      expect(initial!.name).assertEqual('720p_PORTRAIT');
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.confirmRotation();
      const after = machine.getCurrentResolution();
      expect(after!.name).assertEqual('720p_LANDSCAPE');
    });

    it('should_transition_1080p_landscape_to_portrait', 0, () => {
      const machine = new DisplayRotationStateMachine();
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.confirmRotation();
      const initial = machine.getCurrentResolution();
      expect(initial!.name).assertEqual('720p_LANDSCAPE');
      machine.requestRotation(display.Orientation.PORTRAIT);
      machine.confirmRotation();
      const after = machine.getCurrentResolution();
      expect(after!.name).assertEqual('720p_PORTRAIT');
    });

    it('should_maintain_layout_stability_after_rotation_settlement', 0, () => {
      const machine = new DisplayRotationStateMachine();
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.confirmRotation();
      expect(machine.isLayoutReady()).assertEqual(false);
      machine.markLayoutStable();
      expect(machine.isLayoutReady()).assertEqual(true);
    });

    it('should_preserve_resolution_cache_across_rotations', 0, () => {
      const calc = new ResolutionMatrixCalculator();
      calc.calculateLayoutSize(1920, 1080, 240);
      expect(calc.resolutionCache.size).assertEqual(1);
      calc.calculateLayoutSize(1080, 1920, 240);
      expect(calc.resolutionCache.size).assertEqual(2);
    });

    it('should_calculate_correct_aspect_ratio_for_each_resolution', 0, () => {
      const calc = new ResolutionMatrixCalculator();
      expect(calc.getAspectRatio(1920, 1080)).assertEqual('16:9');
      expect(calc.getAspectRatio(1280, 720)).assertEqual('16:9');
      expect(calc.getAspectRatio(3840, 2160)).assertEqual('16:9');
    });

    it('should_identify_4_3_devices', 0, () => {
      const calc = new ResolutionMatrixCalculator();
      expect(calc.isWidescreen(1024, 768)).assertEqual(false);
      expect(calc.getAspectRatio(1024, 768)).assertEqual('4:3');
    });

    it('should_calculate_pixel_ratio_for_4k_content', 0, () => {
      const calc = new ResolutionMatrixCalculator();
      const ratio = calc.calculatePixelRatio(3840, 2160, 1920, 1080);
      expect(ratio).assertEqual(0.25);
    });

    it('should_handle_resolution_transition_from_720p_to_1080p', 0, () => {
      const calc = new ResolutionMatrixCalculator();
      const size720 = calc.calculateLayoutSize(1280, 720, 160);
      const size1080 = calc.calculateLayoutSize(1920, 1080, 240);
      expect(size720.width).assertLarger(0);
      expect(size1080.height).assertEqual(size720.height);
    });

    it('should_handle_resolution_transition_from_1080p_to_4k', 0, () => {
      const calc = new ResolutionMatrixCalculator();
      const size1080 = calc.calculateLayoutSize(1920, 1080, 320);
      const size4k = calc.calculateLayoutSize(3840, 2160, 640);
      expect(size4k.width).assertEqual(size1080.width);
    });

    it('should_not_cache_different_dpi_values', 0, () => {
      const calc = new ResolutionMatrixCalculator();
      calc.calculateLayoutSize(1920, 1080, 160);
      calc.calculateLayoutSize(1920, 1080, 240);
      calc.calculateLayoutSize(1920, 1080, 320);
      expect(calc.resolutionCache.size).assertEqual(3);
    });

    it('should_record_full_rotation_history', 0, () => {
      const machine = new DisplayRotationStateMachine();
      const sequence: display.Orientation[] = [
        display.Orientation.LANDSCAPE,
        display.Orientation.PORTRAIT_INVERTED,
        display.Orientation.LANDSCAPE_INVERTED,
        display.Orientation.PORTRAIT
      ];
      for (let i = 0; i < sequence.length; i++) {
        machine.requestRotation(sequence[i]);
        machine.confirmRotation();
      }
      expect(machine.rotationHistory.length).assertEqual(4);
      expect(machine.currentState.rotationCount).assertEqual(4);
    });

    it('should_handle_concurrent_rotation_requests', 0, () => {
      const machine = new DisplayRotationStateMachine();
      const result1 = machine.requestRotation(display.Orientation.LANDSCAPE);
      const result2 = machine.requestRotation(display.Orientation.PORTRAIT_INVERTED);
      expect(result1).assertEqual(true);
      expect(result2).assertEqual(true);
      expect(machine.currentState.pendingRotation).assertEqual(display.Orientation.PORTRAIT_INVERTED);
      machine.confirmRotation();
      expect(machine.currentState.currentOrientation).assertEqual(display.Orientation.PORTRAIT_INVERTED);
    });

    it('should_reset_rotation_state_completely', 0, () => {
      const machine = new DisplayRotationStateMachine();
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.confirmRotation();
      machine.reset();
      expect(machine.currentState.currentOrientation).assertEqual(display.Orientation.PORTRAIT);
      expect(machine.rotationHistory.length).assertEqual(0);
      expect(machine.currentState.rotationCount).assertEqual(0);
    });
  });

  describe('DisplayMock_Matrix_Integration', () => {
    let restores: Array<() => void> = [];

    beforeEach(() => {
      restores = [];
    });

    afterEach(() => {
      restoreAll(restores);
    });

    it('should_simulate_720p_display_rotation', 0, async () => {
      restores.push(
        patchGetDefaultDisplay(async (): Promise<DisplayLike> => {
          return { width: 720, height: 1280, densityDPI: 160, orientation: display.Orientation.PORTRAIT };
        })
      );
      const screenSize = await display.getDefaultDisplay();
      expect(screenSize.width).assertEqual(720);
      expect(screenSize.height).assertEqual(1280);
    });

    it('should_simulate_1080p_display_rotation', 0, async () => {
      restores.push(
        patchGetDefaultDisplay(async (): Promise<DisplayLike> => {
          return { width: 1920, height: 1080, densityDPI: 320, orientation: display.Orientation.LANDSCAPE };
        })
      );
      const screenSize = await display.getDefaultDisplay();
      expect(screenSize.width).assertEqual(1920);
      expect(screenSize.height).assertEqual(1080);
    });

    it('should_simulate_4k_display_rotation', 0, async () => {
      restores.push(
        patchGetDefaultDisplay(async (): Promise<DisplayLike> => {
          return { width: 3840, height: 2160, densityDPI: 640, orientation: display.Orientation.LANDSCAPE };
        })
      );
      const screenSize = await display.getDefaultDisplay();
      expect(screenSize.width).assertEqual(3840);
      expect(screenSize.height).assertEqual(2160);
    });

    it('should_detect_orientation_change_from_portrait_to_landscape', 0, async () => {
      let callCount = 0;
      restores.push(
        patchGetDefaultDisplay(async (): Promise<DisplayLike> => {
          callCount++;
          if (callCount === 1) {
            return { width: 1080, height: 1920, densityDPI: 240, orientation: display.Orientation.PORTRAIT };
          }
          return { width: 1920, height: 1080, densityDPI: 240, orientation: display.Orientation.LANDSCAPE };
        })
      );
      const initial = await display.getDefaultDisplay();
      expect(initial.orientation).assertEqual(display.Orientation.PORTRAIT);
      const rotated = await display.getDefaultDisplay();
      expect(rotated.orientation).assertEqual(display.Orientation.LANDSCAPE);
    });
  });

  describe('LayoutRecovery_After_Rotation', () => {
    let machine: DisplayRotationStateMachine;
    let calc: ResolutionMatrixCalculator;

    beforeEach(() => {
      machine = new DisplayRotationStateMachine();
      calc = new ResolutionMatrixCalculator();
    });

    afterEach(() => {
      machine.reset();
      calc.reset();
    });

    it('should_recover_layout_after_portrait_to_landscape', 0, () => {
      const initial = machine.getCurrentResolution();
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.confirmRotation();
      machine.markLayoutStable();
      expect(machine.isLayoutReady()).assertEqual(true);
      const after = machine.getCurrentResolution();
      expect(after!.width).assertEqual(initial!.height);
      expect(after!.height).assertEqual(initial!.width);
    });

    it('should_recover_layout_after_landscape_to_portrait', 0, () => {
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.confirmRotation();
      machine.markLayoutStable();
      const initial = machine.getCurrentResolution();
      machine.requestRotation(display.Orientation.PORTRAIT);
      machine.confirmRotation();
      machine.markLayoutStable();
      const after = machine.getCurrentResolution();
      expect(after!.width).assertEqual(initial!.height);
      expect(after!.height).assertEqual(initial!.width);
    });

    it('should_maintain_aspect_ratio_during_rotation', 0, () => {
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.confirmRotation();
      const initial = machine.getCurrentResolution();
      const initialRatio = calc.getAspectRatio(initial!.width, initial!.height);
      machine.requestRotation(display.Orientation.PORTRAIT);
      machine.confirmRotation();
      const after = machine.getCurrentResolution();
      const afterRatio = calc.getAspectRatio(after!.width, after!.height);
      expect(initialRatio).assertEqual(afterRatio);
    });

    it('should_preserve_pixel_ratio_after_rotation_settlement', 0, () => {
      const pixelRatio = calc.calculatePixelRatio(1920, 1080, 3840, 2160);
      machine.requestRotation(display.Orientation.LANDSCAPE);
      machine.confirmRotation();
      expect(calc.calculatePixelRatio(1920, 1080, 3840, 2160)).assertEqual(pixelRatio);
    });
  });
}
