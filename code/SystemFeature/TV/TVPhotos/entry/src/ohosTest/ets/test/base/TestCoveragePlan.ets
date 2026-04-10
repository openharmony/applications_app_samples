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

import { AlbumType } from '../../../../main/ets/models/PhotoModel';

export interface TestBatchPlan {
  id: string;
  name: string;
  moduleCount: number;
  targetLines: number;
  coreDomains: string[];
}

export interface TestMatrixCase {
  id: string;
  domain: string;
  level: 'smoke' | 'normal' | 'deep' | 'stress';
  tags: string[];
}

class TestBatchPlanRecord implements TestBatchPlan {
  id: string;
  name: string;
  moduleCount: number;
  targetLines: number;
  coreDomains: string[];

  constructor(id: string, name: string, moduleCount: number, targetLines: number, coreDomains: string[]) {
    this.id = id;
    this.name = name;
    this.moduleCount = moduleCount;
    this.targetLines = targetLines;
    this.coreDomains = coreDomains;
  }
}

class TestMatrixCaseRecord implements TestMatrixCase {
  id: string;
  domain: string;
  level: 'smoke' | 'normal' | 'deep' | 'stress';
  tags: string[];

  constructor(id: string, domain: string, level: 'smoke' | 'normal' | 'deep' | 'stress', tags: string[]) {
    this.id = id;
    this.domain = domain;
    this.level = level;
    this.tags = tags;
  }
}

const FOUNDATION_MODULES: string[] = [
  'test/base/TestCoveragePlan',
  'test/base/TestDataFactory',
  'test/base/TestDoubles',
  'test/base/TestAsserts',
  'test/base/UiTestHarness'
];

const LOCAL_MEDIA_MODULES: string[] = [
  'manager/PhotoManager',
  'manager/loader/BasePhotoLoader',
  'manager/loader/AllPhotoLoader',
  'manager/loader/FavoritePhotoLoader',
  'manager/loader/ScreenShotPhotoLoader',
  'manager/loader/TrashPhotoLoader',
  'manager/loader/LoadUtil',
  'manager/loader/MediaTasks'
];

const UI_MEDIA_MODULES: string[] = [
  'pages/Index',
  'pages/PhotoList',
  'pages/PhotoDeleteList',
  'pages/PhotoWatch',
  'pages/ThirdSelectPhotoGridPage',
  'pages/components/ThirdSelectPhotoGridBase',
  'pages/components/VideoImage',
  'pages/components/PickImageVideo'
];

const DISTRIBUTED_MODULES: string[] = [
  'pages/DistributedDevicePage',
  'manager/DfsManager',
  'manager/RdbManager',
  'manager/ChangeRegister',
  'component/DistributedPhotoView'
];

const NAS_MODULES: string[] = [
  'pages/NasClientPage',
  'pages/NasSessionPage',
  'pages/components/NasImage',
  'pages/components/NasLoginDialog',
  'pages/components/NasLoginProgress',
  'pages/components/NasDisconnectDialog',
  'smaba/NasFinder',
  'smaba/NasLoaderUtil',
  'smaba/NasImageLoader',
  'smaba/NasSessionManager',
  'workers/NasSessionWorker'
];

const SMB_CLIENT_MODULES: string[] = [
  'smaba/client/Client',
  'smaba/client/Session',
  'smaba/client/Tree',
  'smaba/client/Directory',
  'smaba/client/File',
  'smaba/client/EventEmitter',
  'smaba/client/utils/FileFilterUtil',
  'smaba/client/utils/NetworkUtil',
  'smaba/client/utils/TimeoutPromise'
];

const SMB_PROTOCOL_MODULES: string[] = [
  'smbProtocol/Packet',
  'smbProtocol/Request',
  'smbProtocol/Response',
  'smbProtocol/Structure',
  'smbProtocol/StructureField',
  'smbProtocol/Value',
  'smbProtocol/util',
  'smbProtocol/structureUtil',
  'smbProtocol/ntlm/ntlm',
  'smbProtocol/ntlm/hash',
  'smbProtocol/smb2/Packet',
  'smbProtocol/smb2/Header',
  'smbProtocol/smb2/StatusCode',
  'smbProtocol/smb2/packets/Negotiate',
  'smbProtocol/smb2/packets/SessionSetup',
  'smbProtocol/smb2/packets/TreeConnect',
  'smbProtocol/smb2/packets/QueryDirectory',
  'smbProtocol/smb2/packets/Read',
  'smbProtocol/smb2/packets/Write',
  'smbProtocol/smb2/packets/NetShareEnumAll'
];

const COVERAGE_DOMAINS: string[] = [
  '桌面渲染与布局',
  '主菜单切换',
  '编辑模式与边界操作',
  '快捷方式删除与持久化',
  '全方向键/Home/Back/Edit 按键事件',
  'Recent 任务链路',
  '状态栏图标与时间网络容错',
  '本地持久化与冷启动',
  'NAS 会话与缓存',
  '分布式设备发现与 DFS',
  'RDB 同步与数据一致性',
  '无障碍树与文本可读性',
  '旋转与分辨率矩阵',
  '启动/焦点/编辑性能',
  '长时/高频/混合压力',
  '生命周期切换',
  '契约测试与故障注入',
  '安全边界与异常流'
];

const BATCH_PLAN: TestBatchPlan[] = [
  {
    id: 'batch-1',
    name: '测试基建与公共 Mock',
    moduleCount: FOUNDATION_MODULES.length,
    targetLines: 1800,
    coreDomains: ['测试数据工厂', 'Mock 桩', 'UI 驱动封装', '断言库']
  },
  {
    id: 'batch-2',
    name: '本地媒体数据层',
    moduleCount: LOCAL_MEDIA_MODULES.length,
    targetLines: 2600,
    coreDomains: ['媒体加载', '删除恢复', '参数组合', '并发刷新']
  },
  {
    id: 'batch-3',
    name: '首页与主流程 UI',
    moduleCount: 1,
    targetLines: 3200,
    coreDomains: ['首页菜单', '焦点流', '分享删除', '异常返回']
  },
  {
    id: 'batch-4',
    name: '相册列表与查看器',
    moduleCount: 4,
    targetLines: 3000,
    coreDomains: ['列表浏览', '回收站', '4K 查看', '按键矩阵']
  },
  {
    id: 'batch-5',
    name: '分布式图库',
    moduleCount: DISTRIBUTED_MODULES.length,
    targetLines: 2400,
    coreDomains: ['设备发现', 'DFS 挂载', 'RDB 同步', '一致性校验']
  },
  {
    id: 'batch-6',
    name: 'NAS 应用层',
    moduleCount: NAS_MODULES.length,
    targetLines: 3200,
    coreDomains: ['NAS 搜索', '登录鉴权', '缩略图缓存', '断线恢复']
  },
  {
    id: 'batch-7',
    name: 'SMB 协议栈',
    moduleCount: SMB_CLIENT_MODULES.length + SMB_PROTOCOL_MODULES.length,
    targetLines: 3500,
    coreDomains: ['NTLM', 'SMB2 编解码', '状态码', '契约校验']
  },
  {
    id: 'batch-8',
    name: '回归增强包',
    moduleCount: 6,
    targetLines: 1800,
    coreDomains: ['压力', '混沌注入', '兼容矩阵', '灰度验证']
  }
];

const ROTATION_MATRIX: string[] = ['ROTATION_0', 'ROTATION_90', 'ROTATION_180', 'ROTATION_270'];
const PERFORMANCE_PHASES: string[] = ['startup', 'focus', 'edit', 'share', 'delete', 'watch'];
const PRESSURE_MODES: string[] = ['longevity', 'high-frequency', 'mixed'];
const ACCESSIBILITY_AREAS: string[] = ['focus-order', 'tree-integrity', 'text-readable', 'high-contrast'];
const DETAILED_EXPANSION_MATRIX: TestMatrixCase[] = [
  {
    id: 'foundation_001',
    domain: '测试数据工厂',
    level: 'deep',
    tags: ['photo', 'uri', 'display-name', 'boundary']
  },
  {
    id: 'foundation_002',
    domain: '测试数据工厂',
    level: 'deep',
    tags: ['photo', 'duration', 'type', 'video']
  },
  {
    id: 'foundation_003',
    domain: '测试数据工厂',
    level: 'normal',
    tags: ['directory', 'host', 'filename', 'size']
  },
  {
    id: 'foundation_004',
    domain: '测试数据工厂',
    level: 'normal',
    tags: ['session', 'placeholder', 'focus', 'navigation']
  },
  {
    id: 'foundation_005',
    domain: '测试数据工厂',
    level: 'normal',
    tags: ['rotation', 'resolution', 'recent', 'lifecycle']
  },
  {
    id: 'foundation_006',
    domain: 'Mock 桩',
    level: 'deep',
    tags: ['focus-controller', 'request', 'history', 'fallback']
  },
  {
    id: 'foundation_007',
    domain: 'Mock 桩',
    level: 'deep',
    tags: ['rdb-store', 'insert', 'query', 'sync']
  },
  {
    id: 'foundation_008',
    domain: 'Mock 桩',
    level: 'deep',
    tags: ['preferences', 'set', 'get', 'remove']
  },
  {
    id: 'foundation_009',
    domain: 'Mock 桩',
    level: 'normal',
    tags: ['worker-port', 'post-message', 'error', 'close']
  },
  {
    id: 'foundation_010',
    domain: '断言能力',
    level: 'normal',
    tags: ['tags', 'focus', 'matrix', 'coverage']
  },
  {
    id: 'foundation_011',
    domain: '断言能力',
    level: 'smoke',
    tags: ['rotation', 'string-array', 'priority-map', 'batch-id']
  },
  {
    id: 'foundation_012',
    domain: 'UI 驱动封装',
    level: 'normal',
    tags: ['selector', 'fallback', 'visible-text', 'readable']
  },
  {
    id: 'local_001',
    domain: '媒体加载',
    level: 'deep',
    tags: ['all-loader', 'initial-load', 'paging', 'refresh']
  },
  {
    id: 'local_002',
    domain: '媒体加载',
    level: 'deep',
    tags: ['favorite-loader', 'filter', 'count', 'fallback']
  },
  {
    id: 'local_003',
    domain: '媒体加载',
    level: 'deep',
    tags: ['screenshot-loader', 'uri', 'album', 'retry']
  },
  {
    id: 'local_004',
    domain: '媒体加载',
    level: 'deep',
    tags: ['trash-loader', 'restore', 'empty', 'state']
  },
  {
    id: 'local_005',
    domain: '媒体加载',
    level: 'normal',
    tags: ['load-util', 'cursor', 'boundary', 'decode']
  },
  {
    id: 'local_006',
    domain: '删除恢复',
    level: 'deep',
    tags: ['delete-local', 'multi-select', 'toast', 'result']
  },
  {
    id: 'local_007',
    domain: '删除恢复',
    level: 'deep',
    tags: ['delete-trash', 'confirm', 'cancel', 'focus']
  },
  {
    id: 'local_008',
    domain: '删除恢复',
    level: 'normal',
    tags: ['recover', 'dialog', 'menu', 'icon']
  },
  {
    id: 'local_009',
    domain: '参数组合',
    level: 'normal',
    tags: ['album-type', 'album-name', 'photo-uri', 'want']
  },
  {
    id: 'local_010',
    domain: '参数组合',
    level: 'deep',
    tags: ['delete-assets', 'local-list', 'nas-list', 'mixed']
  },
  {
    id: 'local_011',
    domain: '并发刷新',
    level: 'stress',
    tags: ['callback', 'register', 'unregister', 'timer']
  },
  {
    id: 'local_012',
    domain: '并发刷新',
    level: 'stress',
    tags: ['thumbnail', 'batch', 'parallel', 'cleanup']
  },
  {
    id: 'ui_001',
    domain: '首页菜单',
    level: 'deep',
    tags: ['home-tab', 'focus', 'deferred', 'retry']
  },
  {
    id: 'ui_002',
    domain: '首页菜单',
    level: 'normal',
    tags: ['menu-left', 'menu-right', 'boundary', 'scroll']
  },
  {
    id: 'ui_003',
    domain: '首页菜单',
    level: 'normal',
    tags: ['picture-tab', 'album-tab', 'distributed-tab', 'back']
  },
  {
    id: 'ui_004',
    domain: '焦点流',
    level: 'deep',
    tags: ['grid', 'dialog', 'overlay', 'restore']
  },
  {
    id: 'ui_005',
    domain: '焦点流',
    level: 'deep',
    tags: ['grouped-photo', 'duplicate-scroll', 'anchor', 'current']
  },
  {
    id: 'ui_006',
    domain: '焦点流',
    level: 'normal',
    tags: ['edit-dialog', 'focus-order', 'confirm', 'cancel']
  },
  {
    id: 'ui_007',
    domain: '分享删除',
    level: 'deep',
    tags: ['delete-shortcut', 'select-all', 'toast', 'disable']
  },
  {
    id: 'ui_008',
    domain: '分享删除',
    level: 'deep',
    tags: ['share-shortcut', 'mixed-photo', 'availability', 'guard']
  },
  {
    id: 'ui_009',
    domain: '分享删除',
    level: 'normal',
    tags: ['menu-open', 'menu-close', 'dialog-index', 'icons']
  },
  {
    id: 'ui_010',
    domain: '异常返回',
    level: 'normal',
    tags: ['back', 'overlay-priority', 'device-panel', 'receive-panel']
  },
  {
    id: 'ui_011',
    domain: '异常返回',
    level: 'deep',
    tags: ['back', 'edit-exit', 'check-all-reset', 'restore']
  },
  {
    id: 'ui_012',
    domain: '异常返回',
    level: 'smoke',
    tags: ['route', 'watch-page', 'payload', 'index']
  },
  {
    id: 'distributed_001',
    domain: '设备发现',
    level: 'deep',
    tags: ['scan', 'empty', 'error', 'retry']
  },
  {
    id: 'distributed_002',
    domain: '设备发现',
    level: 'normal',
    tags: ['device-card', 'focus', 'selection', 'dialog']
  },
  {
    id: 'distributed_003',
    domain: '设备发现',
    level: 'normal',
    tags: ['album-matrix', 'neighbor', 'dense', 'sparse']
  },
  {
    id: 'distributed_004',
    domain: 'DFS 挂载',
    level: 'deep',
    tags: ['mount', 'success', 'toast', 'focus']
  },
  {
    id: 'distributed_005',
    domain: 'DFS 挂载',
    level: 'deep',
    tags: ['mount', 'error', 'close', 'recovery']
  },
  {
    id: 'distributed_006',
    domain: 'DFS 挂载',
    level: 'normal',
    tags: ['dialog', 'confirm', 'cancel', 'state']
  },
  {
    id: 'distributed_007',
    domain: 'RDB 同步',
    level: 'deep',
    tags: ['sync', 'query', 'rows', 'consistency']
  },
  {
    id: 'distributed_008',
    domain: 'RDB 同步',
    level: 'deep',
    tags: ['delete-dfs', 'worker', 'thread', 'cleanup']
  },
  {
    id: 'distributed_009',
    domain: 'RDB 同步',
    level: 'normal',
    tags: ['grouping', 'create-time', 'album-type', 'subtype']
  },
  {
    id: 'distributed_010',
    domain: '一致性校验',
    level: 'deep',
    tags: ['received-state', 'wifi-close', 'overlay', 'idle']
  },
  {
    id: 'distributed_011',
    domain: '一致性校验',
    level: 'normal',
    tags: ['size-label', 'kb', 'mb', 'fraction']
  },
  {
    id: 'distributed_012',
    domain: '一致性校验',
    level: 'smoke',
    tags: ['key-callback', 'shortcut', 'trash', 'empty']
  },
  {
    id: 'nas_001',
    domain: 'NAS 搜索',
    level: 'deep',
    tags: ['find', 'page-show', 'loading', 'focus']
  },
  {
    id: 'nas_002',
    domain: 'NAS 搜索',
    level: 'deep',
    tags: ['find', 'reject', 'failure', 'empty']
  },
  {
    id: 'nas_003',
    domain: 'NAS 搜索',
    level: 'normal',
    tags: ['client-grid', 'left', 'right', 'down']
  },
  {
    id: 'nas_004',
    domain: '登录鉴权',
    level: 'deep',
    tags: ['dialog-open', 'confirm', 'cancel', 'selected']
  },
  {
    id: 'nas_005',
    domain: '登录鉴权',
    level: 'deep',
    tags: ['auth-success', 'toast', 'route-back', 'remove']
  },
  {
    id: 'nas_006',
    domain: '登录鉴权',
    level: 'deep',
    tags: ['auth-failure', 'throw', 'progress', 'retain']
  },
  {
    id: 'nas_007',
    domain: '缩略图缓存',
    level: 'normal',
    tags: ['image-loader', 'cache-hit', 'cache-miss', 'refresh']
  },
  {
    id: 'nas_008',
    domain: '缩略图缓存',
    level: 'normal',
    tags: ['remote-uri', 'thumb', 'uri', 'fallback']
  },
  {
    id: 'nas_009',
    domain: '断线恢复',
    level: 'deep',
    tags: ['disconnect', 'dialog', 'confirm', 'focus']
  },
  {
    id: 'nas_010',
    domain: '断线恢复',
    level: 'deep',
    tags: ['session-observer', 'placeholder', 'retry', 'budget']
  },
  {
    id: 'nas_011',
    domain: '断线恢复',
    level: 'normal',
    tags: ['page-hide', 'unregister', 'input', 'callback']
  },
  {
    id: 'nas_012',
    domain: '断线恢复',
    level: 'smoke',
    tags: ['route', 'photo-list', 'watch', 'payload']
  },
  {
    id: 'smb_001',
    domain: 'NTLM',
    level: 'deep',
    tags: ['hash', 'challenge', 'response', 'unicode']
  },
  {
    id: 'smb_002',
    domain: 'NTLM',
    level: 'deep',
    tags: ['message', 'flags', 'signing', 'session-key']
  },
  {
    id: 'smb_003',
    domain: 'SMB2 编解码',
    level: 'deep',
    tags: ['packet', 'header', 'decode', 'encode']
  },
  {
    id: 'smb_004',
    domain: 'SMB2 编解码',
    level: 'deep',
    tags: ['negotiate', 'dialect', 'capability', 'security']
  },
  {
    id: 'smb_005',
    domain: 'SMB2 编解码',
    level: 'deep',
    tags: ['session-setup', 'tree-connect', 'share', 'context']
  },
  {
    id: 'smb_006',
    domain: 'SMB2 编解码',
    level: 'deep',
    tags: ['query-directory', 'read', 'write', 'payload']
  },
  {
    id: 'smb_007',
    domain: '状态码',
    level: 'normal',
    tags: ['success', 'not-found', 'access-denied', 'timeout']
  },
  {
    id: 'smb_008',
    domain: '状态码',
    level: 'normal',
    tags: ['retryable', 'fatal', 'mapping', 'translation']
  },
  {
    id: 'smb_009',
    domain: '契约校验',
    level: 'deep',
    tags: ['structure-field', 'value', 'alignment', 'length']
  },
  {
    id: 'smb_010',
    domain: '契约校验',
    level: 'deep',
    tags: ['client', 'session', 'tree', 'directory']
  },
  {
    id: 'smb_011',
    domain: '契约校验',
    level: 'normal',
    tags: ['file', 'network', 'timeout', 'filter']
  },
  {
    id: 'smb_012',
    domain: '契约校验',
    level: 'stress',
    tags: ['pressure', 'mixed', 'gray', 'chaos']
  },
  {
    id: 'regression_001',
    domain: '桌面渲染与布局',
    level: 'smoke',
    tags: ['desktop', 'render', 'layout', 'text']
  },
  {
    id: 'regression_002',
    domain: '主菜单切换',
    level: 'normal',
    tags: ['menu', 'switch', 'picture', 'album']
  },
  {
    id: 'regression_003',
    domain: '编辑模式与边界操作',
    level: 'deep',
    tags: ['edit', 'choose', 'boundary', 'shortcut']
  },
  {
    id: 'regression_004',
    domain: '快捷方式删除与持久化',
    level: 'deep',
    tags: ['delete', 'persist', 'state', 'menu']
  },
  {
    id: 'regression_005',
    domain: '全方向键/Home/Back/Edit 按键事件',
    level: 'deep',
    tags: ['key', 'home', 'back', 'edit']
  },
  {
    id: 'regression_006',
    domain: 'Recent 任务链路',
    level: 'normal',
    tags: ['recent', 'task', 'resume', 'destroy']
  },
  {
    id: 'regression_007',
    domain: '状态栏图标与时间网络容错',
    level: 'normal',
    tags: ['status-bar', 'time', 'network', 'fallback']
  },
  {
    id: 'regression_008',
    domain: '本地持久化与冷启动',
    level: 'deep',
    tags: ['cold-start', 'preferences', 'snapshot', 'restore']
  },
  {
    id: 'regression_009',
    domain: '无障碍树与文本可读性',
    level: 'normal',
    tags: ['a11y', 'tree', 'text', 'contrast']
  },
  {
    id: 'regression_010',
    domain: '旋转与分辨率矩阵',
    level: 'normal',
    tags: ['rotation', 'resolution', 'matrix', 'adaptive']
  },
  {
    id: 'regression_011',
    domain: '启动/焦点/编辑性能',
    level: 'stress',
    tags: ['startup', 'focus', 'edit', 'performance']
  },
  {
    id: 'regression_012',
    domain: '长时/高频/混合压力',
    level: 'stress',
    tags: ['longevity', 'high-frequency', 'mixed', 'pressure']
  }
];

export class TestCoveragePlan {
  static getFoundationModules(): string[] {
    return [...FOUNDATION_MODULES];
  }

  static getLocalMediaModules(): string[] {
    return [...LOCAL_MEDIA_MODULES];
  }

  static getUiMediaModules(): string[] {
    return [...UI_MEDIA_MODULES];
  }

  static getDistributedModules(): string[] {
    return [...DISTRIBUTED_MODULES];
  }

  static getNasModules(): string[] {
    return [...NAS_MODULES];
  }

  static getSmbClientModules(): string[] {
    return [...SMB_CLIENT_MODULES];
  }

  static getSmbProtocolModules(): string[] {
    return [...SMB_PROTOCOL_MODULES];
  }

  static getCoverageDomains(): string[] {
    return [...COVERAGE_DOMAINS];
  }

  static getBatchPlan(): TestBatchPlan[] {
    return BATCH_PLAN.map((item) => {
      return new TestBatchPlanRecord(
        item.id,
        item.name,
        item.moduleCount,
        item.targetLines,
        [...item.coreDomains]
      );
    });
  }

  static getRotationMatrix(): string[] {
    return [...ROTATION_MATRIX];
  }

  static getPerformancePhases(): string[] {
    return [...PERFORMANCE_PHASES];
  }

  static getPressureModes(): string[] {
    return [...PRESSURE_MODES];
  }

  static getAccessibilityAreas(): string[] {
    return [...ACCESSIBILITY_AREAS];
  }

  static getDetailedExpansionMatrix(): TestMatrixCase[] {
    return DETAILED_EXPANSION_MATRIX.map((item) => {
      return new TestMatrixCaseRecord(
        item.id,
        item.domain,
        item.level,
        [...item.tags]
      );
    });
  }

  static getAlbumCoverageMatrix(): AlbumType[] {
    return [
      AlbumType.ALL,
      AlbumType.FAVORITE,
      AlbumType.SCREENSHOT,
      AlbumType.TRASH,
      AlbumType.NAS_SESSION,
      AlbumType.NAS_CLIENT
    ];
  }

  static getPlannedTotalLines(): number {
    return BATCH_PLAN.reduce((sum, item) => {
      return sum + item.targetLines;
    }, 0);
  }

  static getModuleCount(): number {
    return FOUNDATION_MODULES.length
      + LOCAL_MEDIA_MODULES.length
      + UI_MEDIA_MODULES.length
      + DISTRIBUTED_MODULES.length
      + NAS_MODULES.length
      + SMB_CLIENT_MODULES.length
      + SMB_PROTOCOL_MODULES.length;
  }

  static buildFoundationMatrix(): TestMatrixCase[] {
    return [
      new TestMatrixCaseRecord('foundation_factory', '测试数据工厂', 'deep', ['factory', 'photo', 'nas', 'dfs']),
      new TestMatrixCaseRecord('foundation_double', 'Mock 桩', 'deep', ['double', 'worker', 'preferences', 'rdb']),
      new TestMatrixCaseRecord('foundation_assert', '断言能力', 'normal', ['assert', 'focus', 'matrix']),
      new TestMatrixCaseRecord('foundation_ui_harness', 'UI 驱动封装', 'smoke', ['ui', 'driver', 'selector'])
    ];
  }

  static buildRegressionPriorityMap(): Map<string, number> {
    const priorityMap: Map<string, number> = new Map();
    TestCoveragePlan.getCoverageDomains().forEach((domain, index) => {
      priorityMap.set(domain, index + 1);
    });
    return priorityMap;
  }
}
