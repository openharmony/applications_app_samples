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

import { PhotoModel } from '../../../../main/ets/models/PhotoModel';
import { NasDevice } from '../../../../main/ets/workers/NasSessionWorker';
import { DirectoryEntry } from 'smbProtocol';
import { UiComponentLike, UiDriverLike } from './UiTestHarness';

export interface FocusEventRecord {
  focusId: string;
  timestamp: number;
}

export interface WorkerMessageRecord {
  type: string;
  data?: Object | string | number | boolean | DirectoryEntry | DirectoryEntry[];
}

export interface RdbRow {
  uri: string;
  remoteUri: string;
  displayName: string;
  photoType: number;
  dateAdded: number;
  dateTrashed: number;
  duration: number;
}

export interface DeviceRecord {
  deviceId: string;
  networkId: string;
  deviceName: string;
}

export class FocusHistoryRecord implements FocusEventRecord {
  focusId: string;
  timestamp: number;

  constructor(focusId: string, timestamp: number) {
    this.focusId = focusId;
    this.timestamp = timestamp;
  }
}

export class WorkerMessageEvent {
  data: WorkerMessageRecord;

  constructor(data: WorkerMessageRecord) {
    this.data = data;
  }
}

export class DiscoveryEventRecord {
  device: DeviceRecord;

  constructor(device: DeviceRecord) {
    this.device = device;
  }
}

export class BindTargetResultRecord {
  deviceId: string;

  constructor(deviceId: string) {
    this.deviceId = deviceId;
  }
}

export class MockFocusController {
  private focusHistory: FocusEventRecord[] = [];
  private allowedIds: Set<string> = new Set();

  allow(ids: string[]): void {
    ids.forEach((id) => this.allowedIds.add(id));
  }

  requestFocus(id: string): boolean {
    if (this.allowedIds.size > 0 && !this.allowedIds.has(id)) {
      return false;
    }
    this.focusHistory.push(new FocusHistoryRecord(id, Date.now()));
    return true;
  }

  getLastFocus(): string {
    if (this.focusHistory.length === 0) {
      return '';
    }
    return this.focusHistory[this.focusHistory.length - 1].focusId;
  }

  getFocusHistory(): FocusEventRecord[] {
    return [...this.focusHistory];
  }

  reset(): void {
    this.focusHistory = [];
    this.allowedIds.clear();
  }
}

export class MockInputConsumer {
  private subscriptions: Map<string, Array<(event: Object) => void>> = new Map();
  private emitHistory: string[] = [];

  on(eventName: string, options: Object, callback: (event: Object) => void): void {
    const callbacks = this.subscriptions.get(eventName) ?? [];
    callbacks.push(callback);
    this.subscriptions.set(eventName, callbacks);
  }

  off(eventName: string, options: Object, callback: (event: Object) => void): void {
    const callbacks = this.subscriptions.get(eventName) ?? [];
    this.subscriptions.set(eventName, callbacks.filter((item) => item !== callback));
  }

  emit(eventName: string, event: Object): void {
    this.emitHistory.push(eventName);
    const callbacks = this.subscriptions.get(eventName) ?? [];
    callbacks.forEach((callback) => {
      callback(event);
    });
  }

  getSubscriptionCount(eventName: string): number {
    return (this.subscriptions.get(eventName) ?? []).length;
  }

  getEmitHistory(): string[] {
    return [...this.emitHistory];
  }
}

export class MockPreferenceStore {
  private store: Map<string, string> = new Map();
  private writeHistory: string[] = [];

  putString(key: string, value: string): void {
    this.store.set(key, value);
    this.writeHistory.push(key);
  }

  getString(key: string, defaultValue?: string): string {
    return this.store.get(key) ?? defaultValue ?? '';
  }

  has(key: string): boolean {
    return this.store.has(key);
  }

  delete(key: string): void {
    this.store.delete(key);
  }

  keys(): string[] {
    return Array.from(this.store.keys());
  }

  getWriteHistory(): string[] {
    return [...this.writeHistory];
  }

  size(): number {
    return this.store.size;
  }
}

export class MockWorkerPort {
  private records: WorkerMessageRecord[] = [];
  private terminated: boolean = false;

  postMessage(message: WorkerMessageRecord): void {
    if (this.terminated) {
      throw new Error('worker already terminated');
    }
    this.records.push({
      type: message.type,
      data: message.data
    });
  }

  terminate(): void {
    this.terminated = true;
  }

  getRecords(): WorkerMessageRecord[] {
    return [...this.records];
  }

  isTerminated(): boolean {
    return this.terminated;
  }
}

export class MockWorkerThread {
  private messageHistory: WorkerMessageRecord[] = [];
  private terminated: boolean = false;
  onmessage?: (event: WorkerMessageEvent) => void;

  postMessage(message: WorkerMessageRecord): void {
    if (this.terminated) {
      throw new Error('thread worker has terminated');
    }
    this.messageHistory.push(message);
  }

  emit(type: string, data?: Object | string | number | boolean | DirectoryEntry | DirectoryEntry[]): void {
    if (!this.onmessage) {
      return;
    }
    this.onmessage(new WorkerMessageEvent({
      type: type,
      data: data
    }));
  }

  terminate(): void {
    this.terminated = true;
  }

  getMessageHistory(): WorkerMessageRecord[] {
    return [...this.messageHistory];
  }

  isTerminated(): boolean {
    return this.terminated;
  }
}

export class MockWorkerFactory {
  private workers: MockWorkerThread[] = [];

  create(): MockWorkerThread {
    const worker = new MockWorkerThread();
    this.workers.push(worker);
    return worker;
  }

  count(): number {
    return this.workers.length;
  }

  getLatest(): MockWorkerThread | undefined {
    if (this.workers.length === 0) {
      return undefined;
    }
    return this.workers[this.workers.length - 1];
  }

  getAll(): MockWorkerThread[] {
    return [...this.workers];
  }
}

export class MockResourceManager {
  private resources: Map<string, string> = new Map();

  register(resourceId: string, value: string): void {
    this.resources.set(resourceId, value);
  }

  async getStringValue(resource: Resource): Promise<string> {
    const key = JSON.stringify(resource);
    return this.resources.get(key) ?? '';
  }

  size(): number {
    return this.resources.size;
  }
}

export class MockDistributedDeviceManager {
  private availableDevices: DeviceRecord[] = [];
  private boundDeviceIds: string[] = [];
  private discovering: boolean = false;
  private listener?: (data: DiscoveryEventRecord) => void;

  setAvailableDevices(devices: DeviceRecord[]): void {
    this.availableDevices = [...devices];
  }

  on(eventName: string, callback: (data: DiscoveryEventRecord) => void): void {
    if (eventName === 'discoverSuccess') {
      this.listener = callback;
    }
  }

  startDiscovering(params: Object, options: Object): void {
    this.discovering = true;
  }

  stopDiscovering(): void {
    this.discovering = false;
  }

  emitDiscovery(device: DeviceRecord): void {
    if (this.listener) {
      this.listener(new DiscoveryEventRecord(device));
    }
  }

  bindTarget(deviceId: string, params: Object, callback: (error: Object | undefined, data: Object) => void): void {
    this.boundDeviceIds.push(deviceId);
    callback(undefined, new BindTargetResultRecord(deviceId));
  }

  unbindTarget(deviceId: string): void {
    this.boundDeviceIds = this.boundDeviceIds.filter((id) => id !== deviceId);
  }

  getAvailableDeviceListSync(): DeviceRecord[] {
    return [...this.availableDevices];
  }

  isDiscovering(): boolean {
    return this.discovering;
  }

  getBoundDeviceIds(): string[] {
    return [...this.boundDeviceIds];
  }
}

export class MockRdbStore {
  private rows: Map<string, RdbRow> = new Map();
  private distributedTables: string[] = [];
  private syncHistory: string[] = [];

  insert(row: RdbRow): void {
    this.rows.set(row.uri, row);
  }

  deleteByUri(uri: string): void {
    this.rows.delete(uri);
  }

  queryByUri(uri: string): RdbRow | undefined {
    return this.rows.get(uri);
  }

  queryAll(): RdbRow[] {
    return Array.from(this.rows.values());
  }

  setDistributedTables(tables: string[]): void {
    this.distributedTables = [...tables];
  }

  sync(mode: string): void {
    this.syncHistory.push(mode);
  }

  getDistributedTables(): string[] {
    return [...this.distributedTables];
  }

  getSyncHistory(): string[] {
    return [...this.syncHistory];
  }

  size(): number {
    return this.rows.size;
  }
}

export class MockNasRepository {
  private devices: NasDevice[] = [];
  private fileMap: Map<string, DirectoryEntry[]> = new Map();
  private deletedFiles: Map<string, DirectoryEntry[]> = new Map();

  registerDevice(device: NasDevice, files: DirectoryEntry[]): void {
    this.devices = this.devices.filter((item) => item.host !== device.host);
    this.devices.push(device);
    this.fileMap.set(device.host, [...files]);
  }

  getDevices(): NasDevice[] {
    return [...this.devices];
  }

  getFiles(host: string): DirectoryEntry[] {
    return [...(this.fileMap.get(host) ?? [])];
  }

  deleteFiles(host: string, files: DirectoryEntry[]): void {
    const currentFiles = this.fileMap.get(host) ?? [];
    const remaining = currentFiles.filter((item) => !files.some((target) => target.fileId === item.fileId));
    this.fileMap.set(host, remaining);
    this.deletedFiles.set(host, [...files]);
  }

  getDeletedFiles(host: string): DirectoryEntry[] {
    return [...(this.deletedFiles.get(host) ?? [])];
  }
}

export class MockPhotoRepository {
  private photos: PhotoModel[] = [];
  private deletedUris: string[] = [];
  private restoredUris: string[] = [];

  setPhotos(photos: PhotoModel[]): void {
    this.photos = [...photos];
  }

  getPhotos(): PhotoModel[] {
    return [...this.photos];
  }

  deletePhotos(photos: PhotoModel[]): void {
    const deleteUris = photos.map((photo) => photo.uri);
    this.deletedUris.push(...deleteUris);
    this.photos = this.photos.filter((photo) => !deleteUris.includes(photo.uri));
  }

  restorePhotos(photos: PhotoModel[]): void {
    this.restoredUris.push(...photos.map((photo) => photo.uri));
    this.photos.push(...photos);
  }

  getDeletedUris(): string[] {
    return [...this.deletedUris];
  }

  getRestoredUris(): string[] {
    return [...this.restoredUris];
  }
}

export class MockClock {
  private current: number;

  constructor(initial?: number) {
    this.current = initial ?? 1735689600000;
  }

  now(): number {
    return this.current;
  }

  advance(ms: number): number {
    this.current += ms;
    return this.current;
  }
}

export class FakeUiComponent implements UiComponentLike {
  id: string;
  text: string;
  private clicked: boolean = false;

  constructor(id: string, text: string) {
    this.id = id;
    this.text = text;
  }

  async click(): Promise<void> {
    this.clicked = true;
  }

  wasClicked(): boolean {
    return this.clicked;
  }
}

export interface DriverProbe {
  type: 'text' | 'id';
  value: string;
}

export class FakeUiDriver implements UiDriverLike {
  private components: FakeUiComponent[] = [];
  private delays: number[] = [];
  private rotations: string[] = [];

  registerComponent(component: FakeUiComponent): void {
    this.components.push(component);
  }

  async delayMs(delay: number): Promise<void> {
    this.delays.push(delay);
  }

  async setDisplayRotation(rotation: Object): Promise<void> {
    this.rotations.push(`${rotation}`);
  }

  async findComponent(probe: Object): Promise<UiComponentLike | undefined> {
    const driverProbe = probe as DriverProbe;
    if (driverProbe.type === 'text') {
      return this.components.find((component) => component.text === driverProbe.value);
    }
    return this.components.find((component) => component.id === driverProbe.value);
  }

  getDelayHistory(): number[] {
    return [...this.delays];
  }

  getRotationHistory(): string[] {
    return [...this.rotations];
  }
}
