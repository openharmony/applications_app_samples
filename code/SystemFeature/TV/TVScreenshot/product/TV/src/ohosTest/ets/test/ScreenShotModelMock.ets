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

function createMockFunction<T>(initialImplementation?: () => T): () => T {
  let implementation = initialImplementation
  return () => implementation ? implementation() : (undefined as T)
}

function createAsyncMockFunction<T>(initialImplementation?: () => Promise<T>): () => Promise<T> {
  let implementation = initialImplementation
  return () => implementation ? implementation() : Promise.resolve(undefined as T)
}

interface PixelMapMock {
  readPixelsToBuffer: () => Promise<ArrayBuffer>
}

interface ScreenCapturerMock {
  start: () => Promise<PixelMapMock>
  stop: () => Promise<void>
}

interface MediaMock {
  createAvPlayer: () => void
  getScreenCapturer: () => Promise<ScreenCapturerMock>
}

interface FileAssetMock {
  id: string
  uri: string
  close: () => Promise<void>
}

interface MediaLibraryMock {
  createAsset: () => Promise<FileAssetMock>
  close: () => Promise<void>
}

interface MediaLibraryModuleMock {
  getMediaLibrary: () => MediaLibraryMock
}

interface FileMock {
  write: () => Promise<number>
  close: () => Promise<void>
}

interface FsMock {
  openSync: () => FileMock
  closeSync: () => void
  writeSync: () => void
  readSync: () => void
}

/**
 * 这是一个Mock工厂，专门为ScreenShotModel的单元测试提供所有必要的模拟对象。
 * 将Mock逻辑集中管理有两大好处：
 * 1. 复用性：多个测试文件如果需要相同的Mock对象，可以直接从这里获取，避免重复编写。
 * 2. 清晰度：测试用例文件可以专注于“测试什么”和“如何断言”，而不是“如何构建复杂的Mock环境”，
 *    这极大地提高了测试代码的可读性和可维护性。
 */
export class MockScreenShotModel {

  /**
   * 提供一个完整的@ohos.multimedia.media模块的模拟对象。
   * 业务背景：截屏功能的核心依赖是系统的多媒体能力，特别是ScreenCapturer。
   * 为什么这么做：通过模拟这个模块，我们可以完全控制截屏的输出（成功时返回一个模拟的PixelMap，失败时抛出指定的异常），
   * 而无需真正地与硬件或操作系统交互。这使得测试可以在任何环境下快速、稳定地运行。
   */
  static getMediaMock() {
    const mockPixelMap: PixelMapMock = {
      readPixelsToBuffer: createAsyncMockFunction<ArrayBuffer>(() => Promise.resolve(new ArrayBuffer(8)))
    }
    const mockScreenCapturer: ScreenCapturerMock = {
      start: createAsyncMockFunction<PixelMapMock>(() => Promise.resolve(mockPixelMap)),
      stop: createAsyncMockFunction<void>(() => Promise.resolve())
    }
    const mediaMock: MediaMock = {
      createAvPlayer: createMockFunction<void>(),
      getScreenCapturer: createAsyncMockFunction<ScreenCapturerMock>(() => Promise.resolve(mockScreenCapturer))
    }
    return mediaMock
  }

  /**
   * 提供一个完整的@ohos.multimedia.mediaLibrary模块的模拟对象。
   * 业务背景：截屏图片需要被保存到系统的公共图库目录，以便用户可以在“图库”应用中找到它。
   * 为什么这么做：模拟媒体库允许我们测试“保存”流程，而无需实际写入任何文件到磁盘。
   * 我们可以验证`createAsset`和`close`等方法是否被以正确的参数和顺序调用，
   * 同时可以模拟创建失败（如返回null或抛出异常）的场景，以测试错误处理逻辑。
   */
  static getMediaLibraryMock() {
    const mockFileAsset: FileAssetMock = {
      id: 'mock_id',
      uri: 'mock_uri',
      close: createAsyncMockFunction<void>(() => Promise.resolve())
    }
    const mockMediaLibrary: MediaLibraryMock = {
      createAsset: createAsyncMockFunction<FileAssetMock>(() => Promise.resolve(mockFileAsset)),
      close: createAsyncMockFunction<void>(() => Promise.resolve())
    }
    const mediaLibraryModuleMock: MediaLibraryModuleMock = {
      getMediaLibrary: createMockFunction<MediaLibraryMock>(() => mockMediaLibrary)
    }
    return mediaLibraryModuleMock
  }

  /**
   * 提供一个完整的@ohos.file.fs模块的模拟对象。
   * 业务背景：在将图片注册到媒体库之前，需要先将其作为一个临时文件写入到应用的私有目录中。
   * 为什么这么做：文件系统操作是典型的I/O密集型任务，速度慢且不稳定。通过模拟fs模块，
   * 我们可以将测试与真实的磁盘读写解耦，从而极大地提升测试速度。
   * 此外，我们可以轻易地模拟各种文件操作失败的情况，如“磁盘已满”、“权限不足”或“文件不存在”。
   */
  static getFsMock() {
    const mockFile: FileMock = {
      write: createAsyncMockFunction<number>(() => Promise.resolve(8)),
      close: createAsyncMockFunction<void>(() => Promise.resolve())
    }
    const fsMock: FsMock = {
      openSync: createMockFunction<FileMock>(() => mockFile),
      closeSync: createMockFunction<void>(),
      writeSync: createMockFunction<void>(),
      readSync: createMockFunction<void>()
    }
    return fsMock
  }
}
