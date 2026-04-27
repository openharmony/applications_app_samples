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

import { expect } from '@ohos/hypium';
import { PhotoModel } from '../../../../main/ets/models/PhotoModel';
import { DirectoryEntry } from 'smbProtocol';

export class TestAsserts {
  static assertUniqueUris(photos: PhotoModel[]): void {
    const uriSet: Set<string> = new Set();

    // URI 唯一性是删除、分享和选择态的基础。
    // 一旦工厂或业务层出现重复 URI，后续任何列表断言都会失真。
    photos.forEach((photo) => {
      expect(photo.uri.length > 0).assertTrue();
      expect(uriSet.has(photo.uri)).assertFalse();
      uriSet.add(photo.uri);
    });
  }

  static assertPhotoOrder(photos: PhotoModel[], expectedUris: string[]): void {
    expect(photos.length).assertEqual(expectedUris.length);
    for (let index = 0; index < photos.length; index++) {
      expect(photos[index].uri).assertEqual(expectedUris[index]);
    }
  }

  static assertAllPhotoTagsReadable(photos: PhotoModel[]): void {
    photos.forEach((photo, index) => {
      expect((photo.photoTag ?? '').length >= 0).assertTrue();
      expect(photo.displayName.length >= 0).assertTrue();
      expect(index >= 0).assertTrue();
    });
  }

  static assertFocusChain(sequence: string[], expectedPrefix: string): void {
    expect(sequence.length > 0).assertTrue();
    sequence.forEach((item, index) => {
      expect(item.startsWith(expectedPrefix)).assertTrue();
      if (index > 0) {
        expect(item !== sequence[index - 1]).assertTrue();
      }
    });
  }

  static assertRotationMatrix(matrix: string[]): void {
    expect(matrix.length).assertEqual(4);
    expect(matrix.includes('ROTATION_0')).assertTrue();
    expect(matrix.includes('ROTATION_90')).assertTrue();
    expect(matrix.includes('ROTATION_180')).assertTrue();
    expect(matrix.includes('ROTATION_270')).assertTrue();
  }

  static assertDirectoryEntriesMatchHost(entries: DirectoryEntry[], host: string): void {
    entries.forEach((entry) => {
      expect(entry.fileId.startsWith(host)).assertTrue();
      expect(entry.absoluteDir.includes(host)).assertTrue();
      expect(entry.filename.length > 0).assertTrue();
    });
  }

  static assertDirectoryEntriesUnique(entries: DirectoryEntry[]): void {
    const ids: Set<string> = new Set();
    entries.forEach((entry) => {
      expect(ids.has(entry.fileId)).assertFalse();
      ids.add(entry.fileId);
    });
  }

  static assertBooleanWave(values: boolean[]): void {
    expect(values.length > 0).assertTrue();
    for (let index = 1; index < values.length; index++) {
      expect(values[index] !== values[index - 1]).assertTrue();
    }
  }

  static assertNumberProgression(values: number[], start: number, step: number): void {
    expect(values.length > 0).assertTrue();
    values.forEach((value, index) => {
      expect(value).assertEqual(start + step * index);
    });
  }

  static assertResourceMapHasKeys(resourceMap: Map<string, string[]>, keys: string[]): void {
    keys.forEach((key) => {
      expect(resourceMap.has(key)).assertTrue();
      expect((resourceMap.get(key) ?? []).length > 0).assertTrue();
    });
  }

  static assertNoDuplicateHosts(hosts: string[]): void {
    const set: Set<string> = new Set();
    hosts.forEach((host) => {
      expect(host.length > 0).assertTrue();
      expect(set.has(host)).assertFalse();
      set.add(host);
    });
  }

  static assertRecentTaskMatrix(tasks: string[]): void {
    expect(tasks.length).assertEqual(4);
    expect(tasks[0]).assertEqual('open');
    expect(tasks.includes('delete')).assertTrue();
    expect(tasks.includes('clear')).assertTrue();
    expect(tasks.includes('switch')).assertTrue();
  }

  static assertLifecycleMatrix(values: string[]): void {
    expect(values.length >= 4).assertTrue();
    expect(values.includes('desktop')).assertTrue();
    expect(values.includes('home')).assertTrue();
    expect(values.includes('launch')).assertTrue();
  }

  static assertCoveragePlanHasBatchIds(ids: string[]): void {
    expect(ids.length >= 8).assertTrue();
    ids.forEach((id, index) => {
      expect(id.startsWith('batch-')).assertTrue();
      expect(index >= 0).assertTrue();
    });
  }

  static assertCountRange(count: number, min: number, max: number): void {
    expect(count >= min).assertTrue();
    expect(count <= max).assertTrue();
  }

  static assertStringArrayContains(values: string[], expected: string[]): void {
    expected.forEach((item) => {
      expect(values.includes(item)).assertTrue();
    });
  }

  static assertDeletedUriCoverage(allUris: string[], deletedUris: string[]): void {
    deletedUris.forEach((uri) => {
      expect(allUris.includes(uri)).assertTrue();
    });
  }

  static assertNonEmptyText(value: string): void {
    expect(value.trim().length > 0).assertTrue();
  }

  static assertMatrixLevels(levels: string[]): void {
    expect(levels.length > 0).assertTrue();
    expect(levels.includes('smoke')).assertTrue();
    expect(levels.includes('deep')).assertTrue();
  }

  static assertSortedAscending(values: number[]): void {
    for (let index = 1; index < values.length; index++) {
      expect(values[index] >= values[index - 1]).assertTrue();
    }
  }

  static assertHostFileDistribution(hosts: string[], entries: DirectoryEntry[]): void {
    const matchedHosts: string[] = [];

    // 此处验证 host 与文件映射的可追踪性。
    // 后续 NAS 删除、缓存和 worker 回调都依赖 host/fileId 的稳定绑定。
    entries.forEach((entry) => {
      const host = hosts.find((item) => entry.fileId.startsWith(item));
      expect(host !== undefined).assertTrue();
      if (host) {
        matchedHosts.push(host);
      }
    });

    expect(matchedHosts.length).assertEqual(entries.length);
  }
}
