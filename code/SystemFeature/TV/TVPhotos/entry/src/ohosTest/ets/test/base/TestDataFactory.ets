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

import { AlbumType, PhotoModel } from '../../../../main/ets/models/PhotoModel';
import { SessionModel } from '../../../../main/ets/smaba/NasSessionManager';
import { NasDevice } from '../../../../main/ets/workers/NasSessionWorker';
import { DirectoryEntry } from 'smbProtocol';

export interface PhotoFactoryOptions {
  namePrefix?: string;
  uriPrefix?: string;
  remotePrefix?: string;
  baseDate?: number;
  width?: number;
  height?: number;
  duration?: number;
  type?: number;
}

export interface DirectoryFactoryOptions {
  host?: string;
  directory?: string;
  filenamePrefix?: string;
  baseSize?: number;
}

export interface FactoryScenario {
  id: string;
  label: string;
  prefix: string;
  count: number;
  albumType?: AlbumType;
  host?: string;
}

class PhotoModelOverrides {
  uri?: string;
  displayName?: string;
  dateAdded?: number;
  duration?: number;
  dateTrashed?: number;
  photoType?: number;
  remoteUri?: string;
  width?: number;
  height?: number;
  imageUri?: string;
  size?: number;
  photoTag?: string;
  pickVideoPreview?: string;
}

class DirectoryEntryOverrides {
  index?: number;
  type?: 'File' | 'Directory';
  creationTime?: Date;
  lastAccessTime?: Date;
  lastWriteTime?: Date;
  changeTime?: Date;
  fileSize?: BigInt;
  allocationSize?: BigInt;
  eaSize?: number;
  fileId?: string;
  filename?: string;
  fileAttributes?: string[];
  shareEnum?: string;
  absoluteDir?: string;
}

export class TestDataFactory {
  static createPhoto(index: number, overrides?: PhotoModelOverrides, options?: PhotoFactoryOptions): PhotoModel {
    const photo: PhotoModel = new PhotoModel();
    const namePrefix = options?.namePrefix ?? 'PHOTO';
    const uriPrefix = options?.uriPrefix ?? 'file://media';
    const remotePrefix = options?.remotePrefix ?? 'distributed://media';
    const baseDate = options?.baseDate ?? 1735689600000;
    const width = options?.width ?? 1920;
    const height = options?.height ?? 1080;
    const duration = options?.duration ?? 0;
    const type = options?.type ?? 1;

    // 这里统一生成稳定的主键字段。
    // 后续深度单测需要可重复数据，避免时间戳随机化导致断言抖动。
    photo.uri = `${uriPrefix}/${index}`;
    photo.displayName = `${namePrefix}_${index}.jpg`;
    photo.dateAdded = baseDate + index * 1000;
    photo.duration = duration;
    photo.dateTrashed = 0;
    photo.photoType = type;
    photo.remoteUri = `${remotePrefix}/${index}`;
    photo.width = width + index;
    photo.height = height + index;
    photo.imageUri = `image://${namePrefix.toLowerCase()}/${index}`;
    photo.size = 1024 + index * 16;
    photo.photoTag = `photo_${index}`;
    photo.pickVideoPreview = `preview_${index}`;

    // 覆盖项在工厂最后应用。
    // 这样基础数据仍然具备业务语义，同时允许特定场景注入边界值。
    TestDataFactory.applyPhotoOverrides(photo, overrides);
    return photo;
  }

  static createPhotoList(count: number, options?: PhotoFactoryOptions): PhotoModel[] {
    const photos: PhotoModel[] = [];
    for (let index = 0; index < count; index++) {
      photos.push(TestDataFactory.createPhoto(index, undefined, options));
    }
    return photos;
  }

  static createAlbumBuckets(): Map<AlbumType, PhotoModel[]> {
    const buckets: Map<AlbumType, PhotoModel[]> = new Map();

    // 相册矩阵直接对齐业务枚举。
    // 这样后续测试不需要反复编排分桶逻辑，减少样板代码。
    buckets.set(AlbumType.ALL, TestDataFactory.createPhotoList(6, { namePrefix: 'ALL' }));
    buckets.set(AlbumType.FAVORITE, TestDataFactory.createPhotoList(3, { namePrefix: 'FAVORITE' }));
    buckets.set(AlbumType.SCREENSHOT, TestDataFactory.createPhotoList(4, { namePrefix: 'SCREENSHOT' }));
    buckets.set(AlbumType.TRASH, TestDataFactory.createPhotoList(2, { namePrefix: 'TRASH' }));
    buckets.set(AlbumType.NAS_SESSION, TestDataFactory.createPhotoList(5, { namePrefix: 'NAS' }));
    buckets.set(AlbumType.NAS_CLIENT, []);
    return buckets;
  }

  static createDirectoryEntry(index: number,
    overrides?: DirectoryEntryOverrides,
    options?: DirectoryFactoryOptions): DirectoryEntry {
    const host = options?.host ?? '192.168.0.10';
    const directory = options?.directory ?? `/Pictures/${host}`;
    const filenamePrefix = options?.filenamePrefix ?? 'nas_photo';
    const baseSize = options?.baseSize ?? 2048;
    const time = new Date(1735689600000 + index * 1000);

    // NAS 侧文件结构必须包含 fileId、路径和 share 信息。
    // 这些字段会直接影响缓存命中、缩略图加载和删除链路。
    const entry: DirectoryEntry = {
      index: index,
      type: 'File',
      creationTime: time,
      lastAccessTime: time,
      lastWriteTime: time,
      changeTime: time,
      fileSize: BigInt(baseSize + index * 64),
      allocationSize: BigInt(baseSize + index * 128),
      eaSize: 0,
      fileId: `${host}_file_${index}`,
      filename: `${filenamePrefix}_${index}.jpg`,
      fileAttributes: ['FILE_ATTRIBUTE_ARCHIVE'],
      shareEnum: 'disk',
      absoluteDir: directory
    };

    TestDataFactory.applyDirectoryOverrides(entry, overrides);
    return entry;
  }

  static createDirectoryEntries(count: number, options?: DirectoryFactoryOptions): DirectoryEntry[] {
    const entries: DirectoryEntry[] = [];
    for (let index = 0; index < count; index++) {
      entries.push(TestDataFactory.createDirectoryEntry(index, undefined, options));
    }
    return entries;
  }

  static createNasDevice(host: string, userName?: string, password?: string): NasDevice {
    const device: NasDevice = {
      host: host,
      userName: userName ?? 'tester',
      password: password ?? '123456'
    };
    return device;
  }

  static createNasDeviceList(hosts: string[]): NasDevice[] {
    return hosts.map((host, index) => {
      return TestDataFactory.createNasDevice(host, `tester_${index}`, `password_${index}`);
    });
  }

  static createSessionModel(index: number, host?: string): SessionModel {
    const sessionModel: SessionModel = new SessionModel();
    sessionModel.host = host ?? `192.168.0.${10 + index}`;
    sessionModel.fileSize = 10 + index;
    sessionModel.isPlaceHolder = false;
    sessionModel.thumbFile = TestDataFactory.createDirectoryEntry(index, undefined, {
      host: sessionModel.host,
      directory: `/Pictures/${sessionModel.host}`
    });
    return sessionModel;
  }

  static createSessionModels(count: number): SessionModel[] {
    const models: SessionModel[] = [];
    for (let index = 0; index < count; index++) {
      models.push(TestDataFactory.createSessionModel(index));
    }
    return models;
  }

  static createPlaceholderSession(): SessionModel {
    const model: SessionModel = new SessionModel();
    model.host = '';
    model.fileSize = 0;
    model.isPlaceHolder = true;
    model.thumbFile = undefined;
    return model;
  }

  static createFocusSequence(prefix: string, count: number, startIndex?: number): string[] {
    const focusIds: string[] = [];
    const begin = startIndex ?? 0;
    for (let index = 0; index < count; index++) {
      focusIds.push(`${prefix}${begin + index}`);
    }
    return focusIds;
  }

  static createRotationMatrix(): string[] {
    return ['ROTATION_0', 'ROTATION_90', 'ROTATION_180', 'ROTATION_270'];
  }

  static createResolutionMatrix(): string[] {
    return ['1280x720', '1920x1080', '2560x1440', '3840x2160'];
  }

  static createRecentTaskMatrix(): string[] {
    return ['open', 'delete', 'clear', 'switch'];
  }

  static createLifecycleMatrix(): string[] {
    return ['desktop', 'home', 'launch', 'foreground', 'background', 'destroy'];
  }

  static createMenuIdMatrix(): string[] {
    return ['menu0', 'menu1', 'menu2'];
  }

  static createHomeTabNames(): string[] {
    return ['照片', '相册', '分布式图库'];
  }

  static createLocalizedNames(): Map<string, string[]> {
    const names: Map<string, string[]> = new Map();
    names.set('picture', ['照片', 'Pictures']);
    names.set('album', ['相册', 'Albums']);
    names.set('distributed', ['分布式图库', 'Distributed Gallery']);
    names.set('choose', ['选择', 'Choose']);
    names.set('delete', ['删除', 'Delete']);
    return names;
  }

  static createBooleanWave(count: number): boolean[] {
    const values: boolean[] = [];
    for (let index = 0; index < count; index++) {
      values.push(index % 2 === 0);
    }
    return values;
  }

  static createProgression(count: number, base?: number, step?: number): number[] {
    const values: number[] = [];
    const start = base ?? 0;
    const delta = step ?? 1;
    for (let index = 0; index < count; index++) {
      values.push(start + index * delta);
    }
    return values;
  }

  static createHostMatrix(count: number): string[] {
    const hosts: string[] = [];
    for (let index = 0; index < count; index++) {
      hosts.push(`192.168.1.${index + 10}`);
    }
    return hosts;
  }

  static createUriMatrix(count: number, prefix?: string): string[] {
    const uris: string[] = [];
    const uriPrefix = prefix ?? 'file://media';
    for (let index = 0; index < count; index++) {
      uris.push(`${uriPrefix}/${index}`);
    }
    return uris;
  }

  static createMixedPhotoSet(): PhotoModel[] {
    const photos: PhotoModel[] = [];

    // 混合集用于后续性能和选择态测试。
    // 同一批数据内包含图片、视频、远端 URI，可覆盖多条业务分支。
    const imageOverrides: PhotoModelOverrides = new PhotoModelOverrides();
    imageOverrides.photoType = 1;
    imageOverrides.duration = 0;
    photos.push(TestDataFactory.createPhoto(0, imageOverrides, { namePrefix: 'MIXED_IMAGE' }));
    const videoOverrides: PhotoModelOverrides = new PhotoModelOverrides();
    videoOverrides.photoType = 2;
    videoOverrides.duration = 30000;
    photos.push(TestDataFactory.createPhoto(1, videoOverrides, { namePrefix: 'MIXED_VIDEO' }));
    const remoteOverrides: PhotoModelOverrides = new PhotoModelOverrides();
    remoteOverrides.remoteUri = 'distributed://remote/2';
    photos.push(TestDataFactory.createPhoto(2, remoteOverrides, { namePrefix: 'MIXED_REMOTE' }));
    const trashOverrides: PhotoModelOverrides = new PhotoModelOverrides();
    trashOverrides.dateTrashed = 1735689700000;
    photos.push(TestDataFactory.createPhoto(3, trashOverrides, { namePrefix: 'MIXED_TRASH' }));
    return photos;
  }

  static createBoundaryPhotos(): PhotoModel[] {
    return [
      TestDataFactory.createPhoto(0, TestDataFactory.createPhotoOverrides('', undefined, undefined, undefined, undefined, undefined, undefined, undefined, 0)),
      TestDataFactory.createPhoto(1, TestDataFactory.createPhotoOverrides(undefined, undefined, undefined, undefined, undefined, 1, 1)),
      TestDataFactory.createPhoto(2, TestDataFactory.createPhotoOverrides(undefined, undefined, undefined, undefined, undefined, 7680, 4320)),
      TestDataFactory.createPhoto(3, TestDataFactory.createPhotoOverrides(undefined, 0, undefined, 2)),
      TestDataFactory.createPhoto(4, TestDataFactory.createPhotoOverrides(undefined, undefined, '', undefined))
    ];
  }

  private static createPhotoOverrides(displayName?: string, duration?: number, remoteUri?: string,
    photoType?: number, dateTrashed?: number, width?: number, height?: number, imageUri?: string,
    size?: number): PhotoModelOverrides {
    const overrides = new PhotoModelOverrides();
    overrides.displayName = displayName;
    overrides.duration = duration;
    overrides.remoteUri = remoteUri;
    overrides.photoType = photoType;
    overrides.dateTrashed = dateTrashed;
    overrides.width = width;
    overrides.height = height;
    overrides.imageUri = imageUri;
    overrides.size = size;
    return overrides;
  }

  private static applyPhotoOverrides(photo: PhotoModel, overrides?: PhotoModelOverrides): void {
    if (overrides === undefined) {
      return;
    }
    if (overrides.uri !== undefined) {
      photo.uri = overrides.uri;
    }
    if (overrides.displayName !== undefined) {
      photo.displayName = overrides.displayName;
    }
    if (overrides.dateAdded !== undefined) {
      photo.dateAdded = overrides.dateAdded;
    }
    if (overrides.duration !== undefined) {
      photo.duration = overrides.duration;
    }
    if (overrides.dateTrashed !== undefined) {
      photo.dateTrashed = overrides.dateTrashed;
    }
    if (overrides.photoType !== undefined) {
      photo.photoType = overrides.photoType;
    }
    if (overrides.remoteUri !== undefined) {
      photo.remoteUri = overrides.remoteUri;
    }
    if (overrides.width !== undefined) {
      photo.width = overrides.width;
    }
    if (overrides.height !== undefined) {
      photo.height = overrides.height;
    }
    if (overrides.imageUri !== undefined) {
      photo.imageUri = overrides.imageUri;
    }
    if (overrides.size !== undefined) {
      photo.size = overrides.size;
    }
    if (overrides.photoTag !== undefined) {
      photo.photoTag = overrides.photoTag;
    }
    if (overrides.pickVideoPreview !== undefined) {
      photo.pickVideoPreview = overrides.pickVideoPreview;
    }
  }

  private static applyDirectoryOverrides(entry: DirectoryEntry, overrides?: DirectoryEntryOverrides): void {
    if (overrides === undefined) {
      return;
    }
    if (overrides.index !== undefined) {
      entry.index = overrides.index;
    }
    if (overrides.type !== undefined) {
      entry.type = overrides.type;
    }
    if (overrides.creationTime !== undefined) {
      entry.creationTime = overrides.creationTime;
    }
    if (overrides.lastAccessTime !== undefined) {
      entry.lastAccessTime = overrides.lastAccessTime;
    }
    if (overrides.lastWriteTime !== undefined) {
      entry.lastWriteTime = overrides.lastWriteTime;
    }
    if (overrides.changeTime !== undefined) {
      entry.changeTime = overrides.changeTime;
    }
    if (overrides.fileSize !== undefined) {
      entry.fileSize = overrides.fileSize;
    }
    if (overrides.allocationSize !== undefined) {
      entry.allocationSize = overrides.allocationSize;
    }
    if (overrides.eaSize !== undefined) {
      entry.eaSize = overrides.eaSize;
    }
    if (overrides.fileId !== undefined) {
      entry.fileId = overrides.fileId;
    }
    if (overrides.filename !== undefined) {
      entry.filename = overrides.filename;
    }
    if (overrides.fileAttributes !== undefined) {
      entry.fileAttributes = overrides.fileAttributes;
    }
    if (overrides.shareEnum !== undefined) {
      entry.shareEnum = overrides.shareEnum;
    }
    if (overrides.absoluteDir !== undefined) {
      entry.absoluteDir = overrides.absoluteDir;
    }
  }

  static createPhotoFactoryScenarioMatrix(): FactoryScenario[] {
    return [
      { id: 'photo_001', label: '默认全部相册', prefix: 'ALL', count: 6, albumType: AlbumType.ALL },
      { id: 'photo_002', label: '收藏相册', prefix: 'FAVORITE', count: 3, albumType: AlbumType.FAVORITE },
      { id: 'photo_003', label: '截图相册', prefix: 'SCREENSHOT', count: 4, albumType: AlbumType.SCREENSHOT },
      { id: 'photo_004', label: '回收站相册', prefix: 'TRASH', count: 2, albumType: AlbumType.TRASH },
      { id: 'photo_005', label: 'NAS 会话相册', prefix: 'NAS', count: 5, albumType: AlbumType.NAS_SESSION },
      { id: 'photo_006', label: '4K 图片矩阵', prefix: 'ULTRA', count: 4, albumType: AlbumType.ALL },
      { id: 'photo_007', label: '视频矩阵', prefix: 'VIDEO', count: 4, albumType: AlbumType.ALL },
      { id: 'photo_008', label: '远端 URI 矩阵', prefix: 'REMOTE', count: 4, albumType: AlbumType.ALL },
      { id: 'photo_009', label: '删除态图片矩阵', prefix: 'DELETED', count: 4, albumType: AlbumType.TRASH },
      { id: 'photo_010', label: '选择态图片矩阵', prefix: 'SELECT', count: 8, albumType: AlbumType.ALL },
      { id: 'photo_011', label: '分组图片矩阵', prefix: 'GROUP', count: 10, albumType: AlbumType.ALL },
      { id: 'photo_012', label: '边界值图片矩阵', prefix: 'BOUNDARY', count: 5, albumType: AlbumType.ALL }
    ];
  }

  static createDirectoryScenarioMatrix(): FactoryScenario[] {
    return [
      { id: 'directory_001', label: '默认共享目录', prefix: 'nas_photo', count: 3, host: '192.168.0.10' },
      { id: 'directory_002', label: '家庭相册目录', prefix: 'family', count: 4, host: '192.168.0.11' },
      { id: 'directory_003', label: '工作共享目录', prefix: 'work', count: 4, host: '192.168.0.12' },
      { id: 'directory_004', label: '媒体目录', prefix: 'media', count: 5, host: '192.168.0.13' },
      { id: 'directory_005', label: '视频目录', prefix: 'video', count: 5, host: '192.168.0.14' },
      { id: 'directory_006', label: '截图目录', prefix: 'shot', count: 4, host: '192.168.0.15' },
      { id: 'directory_007', label: '回收站目录', prefix: 'trash', count: 2, host: '192.168.0.16' },
      { id: 'directory_008', label: '超大目录', prefix: 'large', count: 8, host: '192.168.0.17' },
      { id: 'directory_009', label: '只读目录', prefix: 'readonly', count: 3, host: '192.168.0.18' },
      { id: 'directory_010', label: '临时目录', prefix: 'temp', count: 3, host: '192.168.0.19' }
    ];
  }

  static createNasSessionScenarioMatrix(): FactoryScenario[] {
    return [
      { id: 'session_001', label: '单设备会话', prefix: 'SESSION', count: 1, host: '192.168.1.10' },
      { id: 'session_002', label: '双设备会话', prefix: 'SESSION', count: 2, host: '192.168.1.11' },
      { id: 'session_003', label: '三设备会话', prefix: 'SESSION', count: 3, host: '192.168.1.12' },
      { id: 'session_004', label: '焦点瀑布会话', prefix: 'FOCUS', count: 5, host: '192.168.1.13' },
      { id: 'session_005', label: '占位符补位会话', prefix: 'PLACEHOLDER', count: 6, host: '192.168.1.14' },
      { id: 'session_006', label: '缩略图缓存会话', prefix: 'CACHE', count: 4, host: '192.168.1.15' },
      { id: 'session_007', label: '断线恢复会话', prefix: 'RECOVER', count: 4, host: '192.168.1.16' },
      { id: 'session_008', label: '登录失败会话', prefix: 'AUTH_FAIL', count: 2, host: '192.168.1.17' },
      { id: 'session_009', label: '登录成功会话', prefix: 'AUTH_OK', count: 2, host: '192.168.1.18' },
      { id: 'session_010', label: '大网格会话', prefix: 'GRID', count: 7, host: '192.168.1.19' }
    ];
  }

  static createInteractionShortcutMatrix(): FactoryScenario[] {
    return [
      { id: 'shortcut_001', label: '首页菜单快捷', prefix: 'menu', count: 3 },
      { id: 'shortcut_002', label: '首页相册快捷', prefix: 'album', count: 6 },
      { id: 'shortcut_003', label: '首页分布式快捷', prefix: 'distributed', count: 4 },
      { id: 'shortcut_004', label: '列表删除快捷', prefix: 'delete', count: 3 },
      { id: 'shortcut_005', label: '列表选择快捷', prefix: 'choose', count: 3 },
      { id: 'shortcut_006', label: '查看器旋转快捷', prefix: 'watch', count: 4 },
      { id: 'shortcut_007', label: 'NAS 登录快捷', prefix: 'nas_auth', count: 2 },
      { id: 'shortcut_008', label: 'NAS 断开快捷', prefix: 'nas_disconnect', count: 2 },
      { id: 'shortcut_009', label: '分布式接收快捷', prefix: 'receive', count: 3 },
      { id: 'shortcut_010', label: 'Recent 恢复快捷', prefix: 'recent', count: 4 }
    ];
  }
}
