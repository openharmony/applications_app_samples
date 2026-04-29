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

export class ActionScenario {
  name: string;
  operation: number;
  extra: string;

  constructor(name: string, operation: number, extra: string) {
    this.name = name;
    this.operation = operation;
    this.extra = extra;
  }
}

export class DisplayScenario {
  name: string;
  width: number;
  height: number;

  constructor(name: string, width: number, height: number) {
    this.name = name;
    this.width = width;
    this.height = height;
  }
}

export class PinScenario {
  name: string;
  pin: string;

  constructor(name: string, pin: string) {
    this.name = name;
    this.pin = pin;
  }
}

export class ReplyScenario {
  name: string;
  verifyFailed: boolean;

  constructor(name: string, verifyFailed: boolean) {
    this.name = name;
    this.verifyFailed = verifyFailed;
  }
}

export class DeviceTypeScenario {
  name: string;
  deviceType: string;
  expectedWidth: number;
  expectedHeight: number;

  constructor(name: string, deviceType: string, expectedWidth: number, expectedHeight: number) {
    this.name = name;
    this.deviceType = deviceType;
    this.expectedWidth = expectedWidth;
    this.expectedHeight = expectedHeight;
  }
}

export class FocusScenario {
  name: string;
  sequence: string[];

  constructor(name: string, sequence: string[]) {
    this.name = name;
    this.sequence = sequence;
  }
}

export class PermissionScenario {
  name: string;
  permissions: string[];

  constructor(name: string, permissions: string[]) {
    this.name = name;
    this.permissions = permissions;
  }
}

export class CoverageBatchScenario {
  id: string;
  area: string;
  level: string;
  expectedCases: number;

  constructor(id: string, area: string, level: string, expectedCases: number) {
    this.id = id;
    this.area = area;
    this.level = level;
    this.expectedCases = expectedCases;
  }
}

export class MatrixSeedScenario {
  name: string;
  dimensions: number[];

  constructor(name: string, dimensions: number[]) {
    this.name = name;
    this.dimensions = dimensions;
  }
}

export class TestDataFactory {
  static createConfirmActionScenarios(): ActionScenario[] {
    return [
      new ActionScenario('confirm_allow_once', 0, 'extra'),
      new ActionScenario('confirm_cancel', 1, 'extra'),
      new ActionScenario('confirm_timeout', 2, 'extra'),
      new ActionScenario('confirm_allow_always', 6, 'extra')
    ];
  }

  static createInputActionScenarios(pin: string): ActionScenario[] {
    return [
      new ActionScenario('input_cancel', 4, 'extra'),
      new ActionScenario('input_done', 5, pin)
    ];
  }

  static createPinDialogActionScenarios(): ActionScenario[] {
    return [
      new ActionScenario('pincode_cancel_display', 3, 'extra')
    ];
  }

  static createDisplayScenarios(): DisplayScenario[] {
    return [
      new DisplayScenario('display_720p', 1280, 720),
      new DisplayScenario('display_1080p', 1920, 1080),
      new DisplayScenario('display_4k', 3840, 2160),
      new DisplayScenario('display_ultrawide', 2560, 1080)
    ];
  }

  static createPinScenarios(): PinScenario[] {
    return [
      new PinScenario('empty_pin', ''),
      new PinScenario('short_pin', '12'),
      new PinScenario('normal_pin', '123456'),
      new PinScenario('leading_zero_pin', '012345'),
      new PinScenario('single_zero', '0')
    ];
  }

  static createReplyScenarios(): ReplyScenario[] {
    return [
      new ReplyScenario('reply_success', false),
      new ReplyScenario('reply_failed', true)
    ];
  }

  static createDeviceTypeScenarios(): DeviceTypeScenario[] {
    return [
      new DeviceTypeScenario('phone_share_style', 'phone', 520, 365),
      new DeviceTypeScenario('default_share_style', 'default', 520, 365),
      new DeviceTypeScenario('tablet_share_style', 'tablet', 519, 256),
      new DeviceTypeScenario('tv_share_style', 'tv', 519, 256)
    ];
  }

  static createRotationNames(): string[] {
    return ['ROTATION_0', 'ROTATION_90', 'ROTATION_180', 'ROTATION_270'];
  }

  static createLifecycleEvents(): string[] {
    return ['create', 'foreground', 'background', 'destroy'];
  }

  static createConfirmButtonKeys(): string[] {
    return ['cancel', 'confirm', 'always'];
  }

  static createFocusScenarios(): FocusScenario[] {
    return [
      new FocusScenario('confirm_button_loop', ['focus-confirm', 'focus-always', 'focus-cancel']),
      new FocusScenario('input_button_loop', ['focus-pinInput', 'focus-confirm', 'focus-cancel']),
      new FocusScenario('pin_cancel_focus', ['focus-cancel'])
    ];
  }

  static createPermissionScenario(): PermissionScenario {
    return new PermissionScenario('module_permission_contract', [
      'ohos.permission.GET_BUNDLE_INFO',
      'ohos.permission.GET_BUNDLE_INFO_PRIVILEGED',
      'ohos.permission.DISTRIBUTED_DATASYNC',
      'ohos.permission.SYSTEM_FLOAT_WINDOW',
      'ohos.permission.ACCESS_SERVICE_DM'
    ]);
  }

  static createCoveragePlan(): CoverageBatchScenario[] {
    return [
      new CoverageBatchScenario('batch-1', 'foundation', 'smoke', 48),
      new CoverageBatchScenario('batch-2', 'confirm', 'deep', 92),
      new CoverageBatchScenario('batch-3', 'inputpin', 'deep', 128),
      new CoverageBatchScenario('batch-4', 'pincode', 'deep', 76),
      new CoverageBatchScenario('batch-5', 'scenarios', 'deep', 144),
      new CoverageBatchScenario('batch-6', 'regression', 'smoke', 66)
    ];
  }

  static createWindowOperationNames(): string[] {
    return ['move', 'resize', 'loadContent', 'show', 'radius', 'shadow'];
  }

  static createRetryCounts(): number[] {
    return [3, 2, 1, 0];
  }

  static createLongStressPinWave(): string[] {
    return [
      '000000', '111111', '123456', '654321', '222222', '333333', '444444', '555555', '666666', '777777'
    ];
  }

  static createReadableLabels(): string[] {
    return [
      '是否允许对端连接本机',
      '本次允许',
      '始终允许',
      'PIN码连接',
      '请输入另一个设备显示的PIN码进行验证',
      '请在设备端输入连接码进行验证'
    ];
  }

  static createMatrixSeedScenarios(): MatrixSeedScenario[] {
    return [
      new MatrixSeedScenario('confirm_full_matrix', [4, 4, 3, 2]),
      new MatrixSeedScenario('input_retry_matrix', [4, 4, 4, 2]),
      new MatrixSeedScenario('pincode_display_matrix', [4, 6, 2, 2]),
      new MatrixSeedScenario('regression_gate_matrix', [6, 2, 3, 2])
    ];
  }
}
