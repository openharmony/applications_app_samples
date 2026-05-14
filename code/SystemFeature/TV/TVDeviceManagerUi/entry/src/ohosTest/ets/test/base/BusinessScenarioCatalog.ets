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

export class BusinessScenario {
  id: string;
  domain: string;
  title: string;
  level: string;
  expectedSignals: string[];

  constructor(id: string, domain: string, title: string, level: string, expectedSignals: string[]) {
    this.id = id;
    this.domain = domain;
    this.title = title;
    this.level = level;
    this.expectedSignals = expectedSignals;
  }
}

export class BusinessScenarioCatalog {
  static createFoundationScenarios(): BusinessScenario[] {
    return [
      new BusinessScenario(
        'foundation-main-ability-boot',
        'foundation',
        '主入口能力启动后完成默认页面加载链路',
        'smoke',
        ['create', 'load-confirm-dialog', 'foreground']
      ),
      new BusinessScenario(
        'foundation-test-runner-boot',
        'foundation',
        '测试 runner 启动 TestAbility 并加载测试页',
        'smoke',
        ['test-runner', 'test-ability', 'test-page']
      )
    ];
  }

  static createConfirmScenarios(): BusinessScenario[] {
    return [
      new BusinessScenario(
        'confirm-allow-once',
        'confirm',
        '用户确认当前连接并返回本次允许动作',
        'deep',
        ['focus-confirm', 'reply-0', 'destroy-window']
      ),
      new BusinessScenario(
        'confirm-cancel',
        'confirm',
        '用户拒绝当前连接请求并关闭授权框',
        'deep',
        ['focus-cancel', 'reply-1', 'terminate-extension']
      ),
      new BusinessScenario(
        'confirm-always-allow',
        'confirm',
        '用户选择始终允许并建立持久授权决策',
        'deep',
        ['focus-always', 'reply-6', 'release-device-manager']
      ),
      new BusinessScenario(
        'confirm-timeout',
        'confirm',
        '授权框倒计时结束后走超时拒绝流程',
        'deep',
        ['countdown-zero', 'reply-2', 'destroy-window']
      )
    ];
  }

  static createInputScenarios(): BusinessScenario[] {
    return [
      new BusinessScenario(
        'input-submit-valid-pin',
        'inputpin',
        '用户输入合法 PIN 并完成提交',
        'deep',
        ['focus-pinInput', 'reply-5', 'destroy-window']
      ),
      new BusinessScenario(
        'input-empty-submit-blocked',
        'inputpin',
        '空输入不允许触发提交，避免向设备侧发送脏数据',
        'deep',
        ['focus-pinInput', 'skip-submit', 'window-still-open']
      ),
      new BusinessScenario(
        'input-failed-retry',
        'inputpin',
        'PIN 校验失败后展示剩余次数并清空旧输入',
        'deep',
        ['verify-failed', 'retry-decrease', 'error-visible']
      ),
      new BusinessScenario(
        'input-failed-three-times',
        'inputpin',
        '三次失败后自动取消，防止无限重试拖垮交互体验',
        'deep',
        ['verify-failed', 'retry-zero', 'reply-4']
      )
    ];
  }

  static createPinDisplayScenarios(): BusinessScenario[] {
    return [
      new BusinessScenario(
        'pincode-display-from-want',
        'pincode',
        '展示侧从 want 中读取 pinCode 并正确渲染',
        'deep',
        ['read-want-pin', 'render-pin', 'focus-cancel']
      ),
      new BusinessScenario(
        'pincode-cancel-display',
        'pincode',
        '用户取消 PIN 展示并向设备管理服务回执',
        'deep',
        ['reply-3', 'destroy-window', 'terminate-extension']
      )
    ];
  }

  static createScenarioSuites(): BusinessScenario[] {
    return [
      new BusinessScenario(
        'scenario-concurrent-window',
        'scenario',
        '多窗口并发创建时 windowNum 与销毁顺序保持一致',
        'deep',
        ['create-window', 'windowNum++', 'windowNum--']
      ),
      new BusinessScenario(
        'scenario-rotation-resolution',
        'scenario',
        '不同旋转角度与分辨率下对话框仍保持可读与居中',
        'deep',
        ['rotation-matrix', 'resize', 'centered-dialog']
      ),
      new BusinessScenario(
        'scenario-fault-injection',
        'scenario',
        '窗口操作异常时保持容错，不传播致命崩溃',
        'deep',
        ['window-error', 'log-failure', 'continue-lifecycle']
      ),
      new BusinessScenario(
        'scenario-accessibility',
        'scenario',
        '所有主文案均可读，避免遥控器与读屏环境出现无意义文本',
        'smoke',
        ['readable-label', 'no-undefined', 'focusable-entry']
      )
    ];
  }

  static createRegressionScenarios(): BusinessScenario[] {
    return [
      new BusinessScenario(
        'regression-gate-foundation',
        'regression',
        '基础能力回归门禁保持 smoke 级别稳定',
        'smoke',
        ['gate-foundation', 'smoke-only', 'baseline-pass']
      ),
      new BusinessScenario(
        'regression-gate-confirm',
        'regression',
        '确认弹窗回归门禁保持 deep 级别执行',
        'deep',
        ['gate-confirm', 'deep-required', 'reply-contract']
      ),
      new BusinessScenario(
        'regression-gate-inputpin',
        'regression',
        '输入弹窗回归门禁覆盖键盘与重试主链路',
        'deep',
        ['gate-inputpin', 'retry-matrix', 'keyboard-contract']
      )
    ];
  }

  static createAllScenarios(): BusinessScenario[] {
    return [
      ...BusinessScenarioCatalog.createFoundationScenarios(),
      ...BusinessScenarioCatalog.createConfirmScenarios(),
      ...BusinessScenarioCatalog.createInputScenarios(),
      ...BusinessScenarioCatalog.createPinDisplayScenarios(),
      ...BusinessScenarioCatalog.createScenarioSuites(),
      ...BusinessScenarioCatalog.createRegressionScenarios()
    ];
  }
}
