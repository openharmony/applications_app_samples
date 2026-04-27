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

import { FoundationStorageEntity } from '../foundation/FoundationAdvancedFixtures';

export interface ContractRecord {
  type: string
  key: string
  value: string
  code: number
}

export class SchemaContractHarness {
  private records: ContractRecord[] = []
  private status: Map<string, string> = new Map()

  setState(key: string, value: string): number {
    if (key.length === 0 || value.length === 0) {
      this.records.push({ type: 'state', key, value, code: -1 });
      return -1;
    }
    this.status.set(key, value);
    this.records.push({ type: 'state', key, value, code: 0 });
    return 0;
  }

  requireKeys(keys: string[]): number {
    for (let index = 0; index < keys.length; index++) {
      if (!this.status.has(keys[index])) {
        this.records.push({ type: 'require', key: keys[index], value: '', code: -2 });
        return -2;
      }
    }
    this.records.push({ type: 'require', key: keys.join(','), value: 'ok', code: 0 });
    return 0;
  }

  getValue(key: string): string {
    return this.status.get(key) ?? '';
  }

  getRecords(): ContractRecord[] {
    return this.records.slice();
  }

  snapshot(): Map<string, string> {
    const copy = new Map<string, string>();
    this.status.forEach((value: string, key: string) => {
      copy.set(key, value);
    });
    return copy;
  }
}

export class InputSanitizerHarness {
  private records: ContractRecord[] = []

  sanitize(value: string): string {
    let sanitized = value
      .replace(/[\r\n\t]/g, '')
      .replace(/<|>/g, '')
      .replace(/"/g, '\'')
      .trim()
    if (sanitized.length > 64) {
      sanitized = sanitized.slice(0, 64)
    }
    const code = sanitized === value ? 0 : 1;
    this.records.push({ type: 'sanitize', key: 'input', value: sanitized, code });
    return sanitized;
  }

  rejectDangerous(value: string): number {
    const lower = value.toLowerCase();
    const dangerous = lower.indexOf('..') >= 0 || lower.indexOf('rm ') >= 0 || lower.indexOf('drop table') >= 0;
    const code = dangerous ? -1 : 0;
    this.records.push({ type: 'danger', key: 'input', value, code });
    return code;
  }

  getRecords(): ContractRecord[] {
    return this.records.slice();
  }
}

export class PersistentIsolationHarness {
  private storage: FoundationStorageEntity = new FoundationStorageEntity()
  private namespaces: Map<string, string[]> = new Map()
  private records: ContractRecord[] = []

  write(namespace: string, key: string, value: string): void {
    const fullKey = `${namespace}.${key}`;
    this.storage.set(fullKey, value);
    const keys = this.namespaces.get(namespace) ?? [];
    keys.push(fullKey);
    this.namespaces.set(namespace, keys);
    this.records.push({ type: 'write', key: fullKey, value, code: this.storage.getSize() });
  }

  clearNamespace(namespace: string): void {
    const keys = this.namespaces.get(namespace) ?? [];
    const nextStorage = new FoundationStorageEntity();
    const allKeys = this.storage.getKeys();
    for (let index = 0; index < allKeys.length; index++) {
      if (keys.indexOf(allKeys[index]) < 0) {
        nextStorage.set(allKeys[index], this.storage.get<string>(allKeys[index]) ?? '');
      }
    }
    this.storage = nextStorage;
    this.namespaces.set(namespace, []);
    this.records.push({ type: 'clear', key: namespace, value: '', code: this.storage.getSize() });
  }

  coldStart(namespace: string): string[] {
    const keys = this.storage.getKeys().filter((key: string) => key.indexOf(`${namespace}.`) === 0);
    this.records.push({ type: 'coldStart', key: namespace, value: keys.join(','), code: keys.length });
    return keys;
  }

  getValue(key: string): string {
    return this.storage.get<string>(key) ?? '';
  }

  getStorage(): FoundationStorageEntity {
    return this.storage;
  }

  getRecords(): ContractRecord[] {
    return this.records.slice();
  }
}

export class GrayReleaseHarness {
  private buckets: Map<string, string> = new Map()
  private records: ContractRecord[] = []

  assign(userId: string, bucket: string): void {
    this.buckets.set(userId, bucket);
    this.records.push({ type: 'assign', key: userId, value: bucket, code: 0 });
  }

  publish(feature: string, bucket: string): void {
    this.records.push({ type: 'publish', key: feature, value: bucket, code: 0 });
  }

  getBucket(userId: string): string {
    return this.buckets.get(userId) ?? 'unknown';
  }

  snapshot(): string {
    const pairs: string[] = [];
    this.buckets.forEach((value: string, key: string) => {
      pairs.push(`${key}:${value}`);
    });
    pairs.sort();
    return pairs.join('|');
  }

  getRecords(): ContractRecord[] {
    return this.records.slice();
  }
}
