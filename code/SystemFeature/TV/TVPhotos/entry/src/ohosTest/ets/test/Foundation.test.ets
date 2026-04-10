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

import { beforeAll, describe, expect, it } from '@ohos/hypium';
import { AlbumType } from '../../../main/ets/models/PhotoModel';
import { TestAsserts } from './base/TestAsserts';
import { TestCoveragePlan } from './base/TestCoveragePlan';
import { DirectoryFactoryOptions, PhotoFactoryOptions, TestDataFactory } from './base/TestDataFactory';
import {
  DeviceRecord,
  FakeUiComponent,
  FakeUiDriver,
  MockClock,
  MockDistributedDeviceManager,
  MockFocusController,
  MockInputConsumer,
  MockNasRepository,
  MockPhotoRepository,
  MockPreferenceStore,
  RdbRow,
  MockRdbStore,
  WorkerMessageRecord,
  MockWorkerFactory,
  MockWorkerPort
} from './base/TestDoubles';
import { PhotosUiHarness, SelectorCandidate } from './base/UiTestHarness';

class InputOptions {
}

class InputEventRecord {
  keyCode: number;

  constructor(keyCode: number) {
    this.keyCode = keyCode;
  }
}

class WorkerMessageInput implements WorkerMessageRecord {
  type: string;
  data?: Object | string | number | boolean;

  constructor(type: string, data?: Object | string | number | boolean) {
    this.type = type;
    this.data = data;
  }
}

class DeviceRecordInput implements DeviceRecord {
  deviceId: string;
  networkId: string;
  deviceName: string;

  constructor(deviceId: string, networkId: string, deviceName: string) {
    this.deviceId = deviceId;
    this.networkId = networkId;
    this.deviceName = deviceName;
  }
}

class DiscoveryOptions {
}

class RdbRowInput implements RdbRow {
  uri: string;
  remoteUri: string;
  displayName: string;
  photoType: number;
  dateAdded: number;
  dateTrashed: number;
  duration: number;

  constructor(uri: string, remoteUri: string, displayName: string, photoType: number,
    dateAdded: number, dateTrashed: number, duration: number) {
    this.uri = uri;
    this.remoteUri = remoteUri;
    this.displayName = displayName;
    this.photoType = photoType;
    this.dateAdded = dateAdded;
    this.dateTrashed = dateTrashed;
    this.duration = duration;
  }
}

class SelectorCandidateInput extends SelectorCandidate {
  constructor(text?: string, id?: string) {
    super(text, id);
  }
}

class PhotoOptionsInput implements PhotoFactoryOptions {
  namePrefix?: string;
  uriPrefix?: string;
  remotePrefix?: string;
  baseDate?: number;
  width?: number;
  height?: number;
  duration?: number;
  type?: number;

  constructor(namePrefix?: string, uriPrefix?: string, remotePrefix?: string, type?: number,
    duration?: number, width?: number, height?: number) {
    this.namePrefix = namePrefix;
    this.uriPrefix = uriPrefix;
    this.remotePrefix = remotePrefix;
    this.type = type;
    this.duration = duration;
    this.width = width;
    this.height = height;
  }
}

class DirectoryOptionsInput implements DirectoryFactoryOptions {
  host?: string;
  directory?: string;
  filenamePrefix?: string;
  baseSize?: number;

  constructor(host?: string, directory?: string, filenamePrefix?: string, baseSize?: number) {
    this.host = host;
    this.directory = directory;
    this.filenamePrefix = filenamePrefix;
    this.baseSize = baseSize;
  }
}

class PhotoContractScenario {
  name: string;
  index: number;
  options?: PhotoFactoryOptions;
  expectedUri: string;
  expectedRemote: string;
  expectedName: string;
  expectedType: number;

  constructor(name: string, index: number, options: PhotoFactoryOptions | undefined, expectedUri: string,
    expectedRemote: string, expectedName: string, expectedType: number) {
    this.name = name;
    this.index = index;
    this.options = options;
    this.expectedUri = expectedUri;
    this.expectedRemote = expectedRemote;
    this.expectedName = expectedName;
    this.expectedType = expectedType;
  }
}

class DirectoryContractScenario {
  name: string;
  index: number;
  options?: DirectoryFactoryOptions;
  expectedHost: string;
  expectedDir: string;

  constructor(name: string, index: number, options: DirectoryFactoryOptions | undefined, expectedHost: string,
    expectedDir: string) {
    this.name = name;
    this.index = index;
    this.options = options;
    this.expectedHost = expectedHost;
    this.expectedDir = expectedDir;
  }
}

class FocusSequenceScenario {
  name: string;
  prefix: string;
  count: number;
  startIndex: number;
  expectedFirst: string;
  expectedLast: string;

  constructor(name: string, prefix: string, count: number, startIndex: number, expectedFirst: string,
    expectedLast: string) {
    this.name = name;
    this.prefix = prefix;
    this.count = count;
    this.startIndex = startIndex;
    this.expectedFirst = expectedFirst;
    this.expectedLast = expectedLast;
  }
}

class ProgressionScenario {
  name: string;
  count: number;
  base: number;
  step: number;
  expectedFirst: number;
  expectedLast: number;

  constructor(name: string, count: number, base: number, step: number, expectedFirst: number, expectedLast: number) {
    this.name = name;
    this.count = count;
    this.base = base;
    this.step = step;
    this.expectedFirst = expectedFirst;
    this.expectedLast = expectedLast;
  }
}

class BooleanWaveScenario {
  name: string;
  count: number;
  expected: boolean[];

  constructor(name: string, count: number, expected: boolean[]) {
    this.name = name;
    this.count = count;
    this.expected = expected;
  }
}

class HostMatrixScenario {
  name: string;
  count: number;
  expectedFirst: string;
  expectedLast: string;

  constructor(name: string, count: number, expectedFirst: string, expectedLast: string) {
    this.name = name;
    this.count = count;
    this.expectedFirst = expectedFirst;
    this.expectedLast = expectedLast;
  }
}

class UriMatrixScenario {
  name: string;
  count: number;
  prefix?: string;
  expectedFirst: string;
  expectedLast: string;

  constructor(name: string, count: number, prefix: string | undefined, expectedFirst: string, expectedLast: string) {
    this.name = name;
    this.count = count;
    this.prefix = prefix;
    this.expectedFirst = expectedFirst;
    this.expectedLast = expectedLast;
  }
}

class ResourceMatrixScenario {
  name: string;
  actual: string[];
  expectedLength: number;
  expectedFirst: string;
  expectedLast: string;

  constructor(name: string, actual: string[], expectedLength: number, expectedFirst: string, expectedLast: string) {
    this.name = name;
    this.actual = actual;
    this.expectedLength = expectedLength;
    this.expectedFirst = expectedFirst;
    this.expectedLast = expectedLast;
  }
}

class LocalizedScenario {
  key: string;
  expectedPrimary: string;
  expectedFallback: string;

  constructor(key: string, expectedPrimary: string, expectedFallback: string) {
    this.key = key;
    this.expectedPrimary = expectedPrimary;
    this.expectedFallback = expectedFallback;
  }
}

class ModuleListScenario {
  name: string;
  modules: string[];
  expectedFirst: string;

  constructor(name: string, modules: string[], expectedFirst: string) {
    this.name = name;
    this.modules = modules;
    this.expectedFirst = expectedFirst;
  }
}

class BatchPlanScenario {
  id: string;
  targetLines: number;
  moduleCount: number;

  constructor(id: string, targetLines: number, moduleCount: number) {
    this.id = id;
    this.targetLines = targetLines;
    this.moduleCount = moduleCount;
  }
}

class UiCandidateScenario {
  key: string;
  expectedId: string;

  constructor(key: string, expectedId: string) {
    this.key = key;
    this.expectedId = expectedId;
  }
}

class ExpansionScenario {
  id: string;
  domain: string;
  level: string;
  firstTag: string;

  constructor(id: string, domain: string, level: string, firstTag: string) {
    this.id = id;
    this.domain = domain;
    this.level = level;
    this.firstTag = firstTag;
  }
}

const TAP_CANDIDATES: SelectorCandidate[] = [
  new SelectorCandidateInput('不存在'),
  new SelectorCandidateInput(undefined, 'menu1')
];

const PHOTO_CONTRACT_SCENARIOS: PhotoContractScenario[] = [
  new PhotoContractScenario('default_photo_0', 0, undefined, 'file://media/0', 'distributed://media/0', 'PHOTO_0.jpg', 1),
  new PhotoContractScenario('default_photo_4', 4, undefined, 'file://media/4', 'distributed://media/4', 'PHOTO_4.jpg', 1),
  new PhotoContractScenario('favorite_prefix', 1,
    new PhotoOptionsInput('FAVORITE', 'file://favorite', 'distributed://favorite', 1),
    'file://favorite/1', 'distributed://favorite/1', 'FAVORITE_1.jpg', 1),
  new PhotoContractScenario('screenshot_prefix', 2,
    new PhotoOptionsInput('SCREEN', 'file://screen', 'distributed://screen', 1),
    'file://screen/2', 'distributed://screen/2', 'SCREEN_2.jpg', 1),
  new PhotoContractScenario('video_type', 3,
    new PhotoOptionsInput('VIDEO', 'file://video', 'distributed://video', 2, 60000),
    'file://video/3', 'distributed://video/3', 'VIDEO_3.jpg', 2),
  new PhotoContractScenario('trash_prefix', 5,
    new PhotoOptionsInput('TRASH', 'file://trash', 'distributed://trash', 1),
    'file://trash/5', 'distributed://trash/5', 'TRASH_5.jpg', 1),
  new PhotoContractScenario('nas_prefix', 6,
    new PhotoOptionsInput('NAS', 'file://nas', 'distributed://nas', 1),
    'file://nas/6', 'distributed://nas/6', 'NAS_6.jpg', 1),
  new PhotoContractScenario('wide_image', 7,
    new PhotoOptionsInput('WIDE', undefined, undefined, 1, undefined, 3840, 2160),
    'file://media/7', 'distributed://media/7', 'WIDE_7.jpg', 1)
];

const DIRECTORY_CONTRACT_SCENARIOS: DirectoryContractScenario[] = [
  new DirectoryContractScenario('default_host_0', 0, undefined, '192.168.0.10', '/Pictures/192.168.0.10'),
  new DirectoryContractScenario('default_host_2', 2, undefined, '192.168.0.10', '/Pictures/192.168.0.10'),
  new DirectoryContractScenario('custom_host_a', 1,
    new DirectoryOptionsInput('192.168.10.2', '/Pictures/192.168.10.2', 'custom'),
    '192.168.10.2', '/Pictures/192.168.10.2'),
  new DirectoryContractScenario('custom_host_b', 3,
    new DirectoryOptionsInput('192.168.10.3', '/Album/192.168.10.3', 'album'),
    '192.168.10.3', '/Album/192.168.10.3'),
  new DirectoryContractScenario('custom_host_c', 4,
    new DirectoryOptionsInput('192.168.10.4', '/Media/192.168.10.4', 'media'),
    '192.168.10.4', '/Media/192.168.10.4'),
  new DirectoryContractScenario('custom_host_d', 5,
    new DirectoryOptionsInput('192.168.10.5', '/Share/192.168.10.5', 'share'),
    '192.168.10.5', '/Share/192.168.10.5')
];

const FOCUS_SEQUENCE_SCENARIOS: FocusSequenceScenario[] = [
  new FocusSequenceScenario('focus_sequence_zero', 'menu', 3, 0, 'menu0', 'menu2'),
  new FocusSequenceScenario('focus_sequence_offset', 'dialog', 3, 2, 'dialog2', 'dialog4'),
  new FocusSequenceScenario('focus_sequence_long', 'album', 5, 1, 'album1', 'album5')
];

const PROGRESSION_SCENARIOS: ProgressionScenario[] = [
  new ProgressionScenario('progression_default', 4, 0, 1, 0, 3),
  new ProgressionScenario('progression_custom', 4, 10, 5, 10, 25),
  new ProgressionScenario('progression_negative', 3, -2, 2, -2, 2)
];

const BOOLEAN_WAVE_SCENARIOS: BooleanWaveScenario[] = [
  new BooleanWaveScenario('boolean_wave_even', 4, [true, false, true, false]),
  new BooleanWaveScenario('boolean_wave_odd', 5, [true, false, true, false, true]),
  new BooleanWaveScenario('boolean_wave_single', 1, [true])
];

const HOST_MATRIX_SCENARIOS: HostMatrixScenario[] = [
  new HostMatrixScenario('host_matrix_small', 3, '192.168.1.10', '192.168.1.12'),
  new HostMatrixScenario('host_matrix_medium', 5, '192.168.1.10', '192.168.1.14')
];

const URI_MATRIX_SCENARIOS: UriMatrixScenario[] = [
  new UriMatrixScenario('uri_matrix_default', 3, undefined, 'file://media/0', 'file://media/2'),
  new UriMatrixScenario('uri_matrix_custom', 4, 'distributed://custom', 'distributed://custom/0', 'distributed://custom/3')
];

const RESOURCE_MATRIX_SCENARIOS: ResourceMatrixScenario[] = [
  new ResourceMatrixScenario('resource_rotation_matrix', TestDataFactory.createRotationMatrix(), 4, 'ROTATION_0', 'ROTATION_270'),
  new ResourceMatrixScenario('resource_resolution_matrix', TestDataFactory.createResolutionMatrix(), 4, '1280x720', '3840x2160'),
  new ResourceMatrixScenario('resource_recent_matrix', TestDataFactory.createRecentTaskMatrix(), 4, 'open', 'switch'),
  new ResourceMatrixScenario('resource_lifecycle_matrix', TestDataFactory.createLifecycleMatrix(), 6, 'desktop', 'destroy'),
  new ResourceMatrixScenario('resource_menu_matrix', TestDataFactory.createMenuIdMatrix(), 3, 'menu0', 'menu2'),
  new ResourceMatrixScenario('resource_home_tabs', TestDataFactory.createHomeTabNames(), 3, '照片', '分布式图库')
];

const LOCALIZED_SCENARIOS: LocalizedScenario[] = [
  new LocalizedScenario('picture', '照片', 'Pictures'),
  new LocalizedScenario('album', '相册', 'Albums'),
  new LocalizedScenario('distributed', '分布式图库', 'Distributed Gallery'),
  new LocalizedScenario('choose', '选择', 'Choose'),
  new LocalizedScenario('delete', '删除', 'Delete')
];

const MODULE_LIST_SCENARIOS: ModuleListScenario[] = [
  new ModuleListScenario('foundation_modules', TestCoveragePlan.getFoundationModules(), 'test/base/TestCoveragePlan'),
  new ModuleListScenario('local_media_modules', TestCoveragePlan.getLocalMediaModules(), 'manager/PhotoManager'),
  new ModuleListScenario('ui_media_modules', TestCoveragePlan.getUiMediaModules(), 'pages/Index'),
  new ModuleListScenario('distributed_modules', TestCoveragePlan.getDistributedModules(), 'pages/DistributedDevicePage'),
  new ModuleListScenario('nas_modules', TestCoveragePlan.getNasModules(), 'pages/NasClientPage'),
  new ModuleListScenario('smb_client_modules', TestCoveragePlan.getSmbClientModules(), 'smaba/client/Client'),
  new ModuleListScenario('smb_protocol_modules', TestCoveragePlan.getSmbProtocolModules(), 'smbProtocol/Packet')
];

const BATCH_PLAN_SCENARIOS: BatchPlanScenario[] = [
  new BatchPlanScenario('batch-1', 1800, 5),
  new BatchPlanScenario('batch-2', 2600, 8),
  new BatchPlanScenario('batch-3', 3200, 1),
  new BatchPlanScenario('batch-4', 3000, 4),
  new BatchPlanScenario('batch-5', 2400, 5),
  new BatchPlanScenario('batch-6', 3200, 11),
  new BatchPlanScenario('batch-7', 3500, 29),
  new BatchPlanScenario('batch-8', 1800, 6)
];

const UI_CANDIDATE_SCENARIOS: UiCandidateScenario[] = [
  new UiCandidateScenario('picture', 'menu0'),
  new UiCandidateScenario('album', 'menu1'),
  new UiCandidateScenario('distributed', 'menu2')
];

const EXPANSION_SCENARIOS: ExpansionScenario[] = [
  new ExpansionScenario('foundation_001', '测试数据工厂', 'deep', 'photo'),
  new ExpansionScenario('distributed_010', '一致性校验', 'deep', 'received-state'),
  new ExpansionScenario('nas_006', '登录鉴权', 'deep', 'auth-failure'),
  new ExpansionScenario('smb_012', '契约校验', 'stress', 'pressure')
];

export default function foundationTest() {
  describe('PhotosFoundationTest', () => {
    beforeAll(() => {
      expect(TestCoveragePlan.getPlannedTotalLines() > 15200).assertTrue();
    });

    {
      it('should build stable photo factories', 0, () => {
        const photo = TestDataFactory.createPhoto(2);
        expect(photo.uri).assertEqual('file://media/2');
        expect(photo.displayName).assertContain('PHOTO_2');
        expect(photo.remoteUri).assertEqual('distributed://media/2');
      });

      it('should build unique photo collections', 0, () => {
        const photos = TestDataFactory.createPhotoList(10);
        TestAsserts.assertUniqueUris(photos);
        expect(photos.length).assertEqual(10);
      });

      it('should build album buckets aligned with business enums', 0, () => {
        const buckets = TestDataFactory.createAlbumBuckets();
        expect(buckets.has(AlbumType.ALL)).assertTrue();
        expect(buckets.has(AlbumType.TRASH)).assertTrue();
        expect((buckets.get(AlbumType.ALL) ?? []).length).assertLarger(0);
      });

      it('should build NAS directory entries with host identity', 0, () => {
        const host = '192.168.0.30';
        const entries = TestDataFactory.createDirectoryEntries(5, new DirectoryOptionsInput(host, `/Pictures/${host}`));
        TestAsserts.assertDirectoryEntriesMatchHost(entries, host);
        TestAsserts.assertDirectoryEntriesUnique(entries);
      });

      it('should build reusable session models', 0, () => {
        const sessions = TestDataFactory.createSessionModels(3);
        expect(sessions.length).assertEqual(3);
        expect(sessions[0].isPlaceHolder).assertFalse();
        expect((sessions[0].thumbFile?.filename ?? '').length > 0).assertTrue();
      });

      it('should build placeholder session for add card scene', 0, () => {
        const placeholder = TestDataFactory.createPlaceholderSession();
        expect(placeholder.isPlaceHolder).assertTrue();
        expect(placeholder.host).assertEqual('');
      });

      it('should build focus sequences for TV navigation tests', 0, () => {
        const sequence = TestDataFactory.createFocusSequence('menu', 3);
        TestAsserts.assertFocusChain(sequence, 'menu');
      });

      it('should build deterministic numeric progressions', 0, () => {
        const values = TestDataFactory.createProgression(5, 10, 3);
        TestAsserts.assertNumberProgression(values, 10, 3);
      });

      it('should build alternating boolean waves for toggle scenarios', 0, () => {
        const values = TestDataFactory.createBooleanWave(6);
        TestAsserts.assertBooleanWave(values);
      });

      it('should build mixed photo sets for scenario expansion', 0, () => {
        const photos = TestDataFactory.createMixedPhotoSet();
        expect(photos.length).assertEqual(4);
        TestAsserts.assertUniqueUris(photos);
      });

      it('should build boundary photo sets for edge tests', 0, () => {
        const photos = TestDataFactory.createBoundaryPhotos();
        expect(photos.length).assertEqual(5);
        expect(photos[0].size).assertEqual(0);
        expect(photos[2].width).assertEqual(7680);
      });
    }

    {
      it('should maintain focus history in focus controller', 0, () => {
        const focusController = new MockFocusController();
        focusController.allow(['menu0', 'menu1']);
        expect(focusController.requestFocus('menu0')).assertTrue();
        expect(focusController.requestFocus('menu1')).assertTrue();
        expect(focusController.getLastFocus()).assertEqual('menu1');
      });

      it('should reject focus ids outside allowed scope', 0, () => {
        const focusController = new MockFocusController();
        focusController.allow(['menu0']);
        expect(focusController.requestFocus('menu2')).assertFalse();
      });

      it('should record input subscription and emit history', 0, () => {
        const inputConsumer = new MockInputConsumer();
        let emitCount = 0;
        const callback = (event: Object) => {
          emitCount++;
        };
        inputConsumer.on('key', new InputOptions(), callback);
        inputConsumer.emit('key', new InputEventRecord(1));
        expect(inputConsumer.getSubscriptionCount('key')).assertEqual(1);
        expect(emitCount).assertEqual(1);
      });

      it('should store preference writes deterministically', 0, () => {
        const store = new MockPreferenceStore();
        store.putString('host_1', '192.168.0.10');
        store.putString('host_2', '192.168.0.11');
        expect(store.size()).assertEqual(2);
        expect(store.getString('host_1')).assertEqual('192.168.0.10');
      });

      it('should record worker port messages before termination', 0, () => {
        const workerPort = new MockWorkerPort();
        workerPort.postMessage(new WorkerMessageInput('auth', 'host'));
        workerPort.postMessage(new WorkerMessageInput('readThumb'));
        expect(workerPort.getRecords().length).assertEqual(2);
        workerPort.terminate();
        expect(workerPort.isTerminated()).assertTrue();
      });

      it('should create worker threads through factory', 0, () => {
        const factory = new MockWorkerFactory();
        const worker = factory.create();
        worker.postMessage(new WorkerMessageInput('connect'));
        expect(factory.count()).assertEqual(1);
        expect(worker.getMessageHistory().length).assertEqual(1);
      });

      it('should track distributed device discovery state', 0, () => {
        const manager = new MockDistributedDeviceManager();
        manager.setAvailableDevices([new DeviceRecordInput('device-1', 'network-1', 'LivingRoom')]);
        manager.startDiscovering(new DiscoveryOptions(), new DiscoveryOptions());
        expect(manager.isDiscovering()).assertTrue();
        expect(manager.getAvailableDeviceListSync().length).assertEqual(1);
      });

      it('should persist RDB rows for distributed sync tests', 0, () => {
        const rdbStore = new MockRdbStore();
        rdbStore.insert(new RdbRowInput('file://media/1', 'distributed://media/1', 'photo_1.jpg', 1, 1, 0, 0));
        expect(rdbStore.size()).assertEqual(1);
        rdbStore.setDistributedTables(['photo']);
        expect(rdbStore.getDistributedTables()[0]).assertEqual('photo');
      });

      it('should simulate NAS repository file deletion', 0, () => {
        const repository = new MockNasRepository();
        const device = TestDataFactory.createNasDevice('192.168.0.60');
        const files = TestDataFactory.createDirectoryEntries(3, new DirectoryOptionsInput(device.host, `/Pictures/${device.host}`));
        repository.registerDevice(device, files);
        repository.deleteFiles(device.host, [files[0]]);
        expect(repository.getFiles(device.host).length).assertEqual(2);
        expect(repository.getDeletedFiles(device.host).length).assertEqual(1);
      });

      it('should simulate photo repository delete and restore', 0, () => {
        const repository = new MockPhotoRepository();
        const photos = TestDataFactory.createPhotoList(4);
        repository.setPhotos(photos);
        repository.deletePhotos([photos[0], photos[1]]);
        expect(repository.getPhotos().length).assertEqual(2);
        repository.restorePhotos([photos[0]]);
        expect(repository.getRestoredUris().length).assertEqual(1);
      });

      it('should support controllable clock for timeout tests', 0, () => {
        const clock = new MockClock(1000);
        expect(clock.now()).assertEqual(1000);
        expect(clock.advance(500)).assertEqual(1500);
      });
    }

    {
      it('should build home tab candidates with text and id fallbacks', 0, () => {
        const tabs = PhotosUiHarness.buildHomeTabCandidates();
        expect((tabs.get('picture') ?? []).length).assertEqual(3);
        expect((tabs.get('album') ?? [])[2].id).assertEqual('menu1');
      });

      it('should build edit dialog candidates for multi-language UI', 0, () => {
        const actions = PhotosUiHarness.buildEditDialogCandidates();
        expect((actions.get('delete') ?? []).length).assertLarger(1);
        expect((actions.get('choose') ?? [])[0].text).assertEqual('选择');
      });

      it('should normalize visible text for resilient selector matching', 0, () => {
        const value = PhotosUiHarness.normalizeVisibleText('  分布式   图库 ');
        expect(value).assertEqual('分布式 图库');
      });

      it('should validate readable labels', 0, () => {
        expect(PhotosUiHarness.isReadableLabel('相册')).assertTrue();
        expect(PhotosUiHarness.isReadableLabel(' undefined ')).assertFalse();
      });

      it('should expose rotation names for UI matrix tests', 0, () => {
        const rotationNames = PhotosUiHarness.getRotationNames();
        TestAsserts.assertRotationMatrix(rotationNames);
      });

      it('should open fallback candidate through fake driver', 0, async () => {
        const driver = new FakeUiDriver();
        const component = new FakeUiComponent('menu1', 'Albums');
        driver.registerComponent(component);
        const result = await PhotosUiHarness.tapFirstAvailable(driver, TAP_CANDIDATES);
        expect(result).assertTrue();
        expect(component.wasClicked()).assertTrue();
      });
    }

    {
      it('should expose all planned coverage domains', 0, () => {
        const domains = TestCoveragePlan.getCoverageDomains();
        expect(domains.length >= 10).assertTrue();
        TestAsserts.assertStringArrayContains(domains, [
          'NAS 会话与缓存',
          'RDB 同步与数据一致性',
          '契约测试与故障注入'
        ]);
      });

      it('should keep batch ids stable for future expansion', 0, () => {
        const ids = TestCoveragePlan.getBatchPlan().map((item) => item.id);
        TestAsserts.assertCoveragePlanHasBatchIds(ids);
      });

      it('should exceed line target through batch planning', 0, () => {
        expect(TestCoveragePlan.getPlannedTotalLines() > 15200).assertTrue();
      });

      it('should expose local media modules for batch two', 0, () => {
        const modules = TestCoveragePlan.getLocalMediaModules();
        expect(modules.includes('manager/PhotoManager')).assertTrue();
        expect(modules.includes('manager/loader/BasePhotoLoader')).assertTrue();
      });

      it('should expose NAS modules for batch six', 0, () => {
        const modules = TestCoveragePlan.getNasModules();
        expect(modules.includes('smaba/NasSessionManager')).assertTrue();
        expect(modules.includes('workers/NasSessionWorker')).assertTrue();
      });

      it('should expose protocol modules for batch seven', 0, () => {
        const modules = TestCoveragePlan.getSmbProtocolModules();
        expect(modules.includes('smbProtocol/smb2/packets/Read')).assertTrue();
        expect(modules.includes('smbProtocol/ntlm/ntlm')).assertTrue();
      });

      it('should expose performance and pressure matrices', 0, () => {
        expect(TestCoveragePlan.getPerformancePhases().length).assertEqual(6);
        expect(TestCoveragePlan.getPressureModes().length).assertEqual(3);
      });

      it('should expose accessibility areas for future a11y tests', 0, () => {
        const areas = TestCoveragePlan.getAccessibilityAreas();
        expect(areas.includes('focus-order')).assertTrue();
        expect(areas.includes('tree-integrity')).assertTrue();
      });

      it('should expose album coverage matrix matching business enums', 0, () => {
        const matrix = TestCoveragePlan.getAlbumCoverageMatrix();
        expect(matrix.length).assertEqual(6);
        expect(matrix.includes(AlbumType.NAS_SESSION)).assertTrue();
      });

      it('should build regression priority map for scheduling', 0, () => {
        const priorityMap = TestCoveragePlan.buildRegressionPriorityMap();
        expect((priorityMap.get('桌面渲染与布局') ?? 0) > 0).assertTrue();
        expect((priorityMap.get('安全边界与异常流') ?? 0) > 0).assertTrue();
      });

      PHOTO_CONTRACT_SCENARIOS.forEach((scenario) => {
        it(`should build deterministic photo contract for ${scenario.name}`, 0, () => {
          const photo = TestDataFactory.createPhoto(scenario.index, undefined, scenario.options);

          expect(photo.uri).assertEqual(scenario.expectedUri);
          expect(photo.remoteUri).assertEqual(scenario.expectedRemote);
          expect(photo.displayName).assertEqual(scenario.expectedName);
          expect(photo.photoType).assertEqual(scenario.expectedType);
          expect(photo.photoTag).assertEqual(`photo_${scenario.index}`);
          expect((photo.imageUri ?? '').length > 0).assertTrue();
        });
      });

      DIRECTORY_CONTRACT_SCENARIOS.forEach((scenario) => {
        it(`should build directory entry contract for ${scenario.name}`, 0, () => {
          const entry = TestDataFactory.createDirectoryEntry(scenario.index, undefined, scenario.options);

          expect(entry.fileId).assertContain(scenario.expectedHost);
          expect(entry.absoluteDir).assertEqual(scenario.expectedDir);
          expect(entry.filename.length > 0).assertTrue();
          expect(`${entry.fileSize}`.length > 0).assertTrue();
          expect(entry.type).assertEqual('File');
        });
      });

      FOCUS_SEQUENCE_SCENARIOS.forEach((scenario) => {
        it(`should build focus sequence for ${scenario.name}`, 0, () => {
          const focusIds = TestDataFactory.createFocusSequence(scenario.prefix, scenario.count, scenario.startIndex);

          expect(focusIds.length).assertEqual(scenario.count);
          expect(focusIds[0]).assertEqual(scenario.expectedFirst);
          expect(focusIds[focusIds.length - 1]).assertEqual(scenario.expectedLast);
        });
      });

      PROGRESSION_SCENARIOS.forEach((scenario) => {
        it(`should build numeric progression for ${scenario.name}`, 0, () => {
          const values = TestDataFactory.createProgression(scenario.count, scenario.base, scenario.step);

          expect(values.length).assertEqual(scenario.count);
          expect(values[0]).assertEqual(scenario.expectedFirst);
          expect(values[values.length - 1]).assertEqual(scenario.expectedLast);
        });
      });

      BOOLEAN_WAVE_SCENARIOS.forEach((scenario) => {
        it(`should build boolean wave for ${scenario.name}`, 0, () => {
          const values = TestDataFactory.createBooleanWave(scenario.count);

          expect(values.length).assertEqual(scenario.expected.length);
          scenario.expected.forEach((value, index) => {
            expect(values[index]).assertEqual(value);
          });
        });
      });

      HOST_MATRIX_SCENARIOS.forEach((scenario) => {
        it(`should build host matrix for ${scenario.name}`, 0, () => {
          const hosts = TestDataFactory.createHostMatrix(scenario.count);

          expect(hosts[0]).assertEqual(scenario.expectedFirst);
          expect(hosts[hosts.length - 1]).assertEqual(scenario.expectedLast);
          expect(hosts.length).assertEqual(scenario.count);
        });
      });

      URI_MATRIX_SCENARIOS.forEach((scenario) => {
        it(`should build uri matrix for ${scenario.name}`, 0, () => {
          const uris = TestDataFactory.createUriMatrix(scenario.count, scenario.prefix);

          expect(uris[0]).assertEqual(scenario.expectedFirst);
          expect(uris[uris.length - 1]).assertEqual(scenario.expectedLast);
          expect(uris.length).assertEqual(scenario.count);
        });
      });

      RESOURCE_MATRIX_SCENARIOS.forEach((scenario) => {
        it(`should expose resource matrix for ${scenario.name}`, 0, () => {
          expect(scenario.actual.length).assertEqual(scenario.expectedLength);
          expect(scenario.actual[0]).assertEqual(scenario.expectedFirst);
          expect(scenario.actual[scenario.actual.length - 1]).assertEqual(scenario.expectedLast);
        });
      });

      LOCALIZED_SCENARIOS.forEach((scenario) => {
        it(`should expose localized names for ${scenario.key}`, 0, () => {
          const names = TestDataFactory.createLocalizedNames();
          const values = names.get(scenario.key) ?? [];

          expect(values[0]).assertEqual(scenario.expectedPrimary);
          expect(values[1]).assertEqual(scenario.expectedFallback);
        });
      });

      MODULE_LIST_SCENARIOS.forEach((scenario) => {
        it(`should expose module list for ${scenario.name}`, 0, () => {
          expect(scenario.modules.length > 0).assertTrue();
          expect(scenario.modules[0]).assertEqual(scenario.expectedFirst);
        });
      });

      BATCH_PLAN_SCENARIOS.forEach((scenario) => {
        it(`should keep batch plan contract for ${scenario.id}`, 0, () => {
          const batch = TestCoveragePlan.getBatchPlan().find((item) => item.id === scenario.id);

          expect(batch !== undefined).assertTrue();
          expect(batch?.targetLines).assertEqual(scenario.targetLines);
          expect(batch?.moduleCount).assertEqual(scenario.moduleCount);
        });
      });

      UI_CANDIDATE_SCENARIOS.forEach((scenario) => {
        it(`should expose ui candidate ids for ${scenario.key}`, 0, () => {
          const tabs = PhotosUiHarness.buildHomeTabCandidates();
          const candidates = tabs.get(scenario.key) ?? [];

          expect(candidates[candidates.length - 1].id).assertEqual(scenario.expectedId);
        });
      });

      EXPANSION_SCENARIOS.forEach((scenario) => {
        it(`should expose detailed expansion entry ${scenario.id}`, 0, () => {
          const item = TestCoveragePlan.getDetailedExpansionMatrix().find((entry) => entry.id === scenario.id);

          expect(item !== undefined).assertTrue();
          expect(item?.domain).assertEqual(scenario.domain);
          expect(item?.level).assertEqual(scenario.level);
          expect(item?.tags[0]).assertEqual(scenario.firstTag);
        });
      });

      it('should expose a large detailed expansion matrix for future suite growth', 0, () => {
        const matrix = TestCoveragePlan.getDetailedExpansionMatrix();

        expect(matrix.length >= 80).assertTrue();
        expect(matrix.every((item) => item.tags.length >= 4)).assertTrue();
      });
    }
  });
}
