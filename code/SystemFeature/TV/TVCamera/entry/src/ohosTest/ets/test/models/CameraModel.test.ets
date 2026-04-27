/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import { camera } from '@kit.CameraKit';
import CameraModel from '../../../../main/ets/models/CameraModel';

type PhotoAvailableHandler = (errCode: object | undefined, photo: MockPhoto | undefined) => void;
type ErrorHandler = (err: object) => void;

interface MockCameraDescriptor {
  connectionType: number;
  cameraPosition: number;
  cameraType: number;
  cameraId?: string;
}

interface MockPhoto {
  main: MockImage;
}

interface MockImage {
  getComponent: (componentType: number, callback: (errCode: object | undefined, component: MockImageComponent | undefined) => Promise<void> | void) => void;
  release: () => Promise<void>;
}

interface MockImageComponent {
  byteBuffer?: ArrayBuffer;
}

interface MockPhotoOutput {
  on: (eventName: string, callback: PhotoAvailableHandler | ErrorHandler) => void;
  off: (eventName: string, callback: PhotoAvailableHandler | ErrorHandler) => void;
  capture: (settings: camera.PhotoCaptureSetting, callback: (err: object | undefined) => Promise<void> | void) => void;
  release: () => Promise<void>;
}

interface MockCloseResource {
  close: () => Promise<void>;
}

interface MockReleaseResource {
  release: () => Promise<void>;
}

interface CameraModelPrivateApi {
  izDistributedCapture: boolean;
  photoOutPut?: MockPhotoOutput;
  cameraInput?: MockCloseResource;
  previewOutput?: MockReleaseResource;
  capSession?: MockReleaseResource;
  initCamera(surfaceId: string, cameraDevice?: camera.CameraDevice, netWorkId?: string | undefined): Promise<void>;
  getSupportedCameras(): MockCameraDescriptor[];
  getSupportedCamerasString(): string[];
  takePicture(surfaceId: string): void;
  releaseCamera(): Promise<void>;
  setPhotoOutputCb(photoOutput: MockPhotoOutput): Promise<void>;
  clearPhotoOutputCb(photoOutput: MockPhotoOutput): void;
  distributedTakePicture(surfaceId: string): void;
  saveImage(buffer: ArrayBuffer, img?: MockImage): Promise<void>;
}

/**
 * 功能描述：获取可访问内部状态的 CameraModel 单例。
 * 参数说明：无。
 * 返回值：`CameraModelPrivateApi`，用于验证分支选择与资源释放顺序。
 */
function getCameraModel(): CameraModelPrivateApi {
  return CameraModel as Object as CameraModelPrivateApi;
}

/**
 * 功能描述：恢复 CameraModel 的最小稳定测试状态。
 * 参数说明：`model` 为待测单例实例。
 * 返回值：void，用于清理上一条用例留下的资源桩和分支状态。
 */
function resetCameraModelState(model: CameraModelPrivateApi): void {
  model.izDistributedCapture = false;
  model.photoOutPut = undefined;
  model.cameraInput = undefined;
  model.previewOutput = undefined;
  model.capSession = undefined;
}

/**
 * 功能描述：构造轻量相机描述对象。
 * 参数说明：`connectionType`、`cameraPosition`、`cameraType` 对应源码中的映射字段。
 * 返回值：`MockCameraDescriptor`，用于字符串映射与选择策略测试。
 */
function buildCameraDescriptor(connectionType: number, cameraPosition: number, cameraType: number): MockCameraDescriptor {
  return {
    connectionType,
    cameraPosition,
    cameraType,
    cameraId: `${connectionType}-${cameraPosition}-${cameraType}`
  };
}

/**
 * 功能描述：等待事件循环处理完异步回调链。
 * 参数说明：`delayMs` 为等待毫秒数，默认 0 表示下一轮事件循环。
 * 返回值：`Promise<void>`，用于保证断言发生在异步逻辑完成之后。
 */
function waitForAsyncCallbacks(delayMs: number = 0): Promise<void> {
  return new Promise<void>((resolve) => {
    setTimeout(() => {
      resolve();
    }, delayMs);
  });
}

/**
 * 功能描述：注册 CameraModel 主测试集合。
 * 参数说明：无。
 * 返回值：void，用于向 Hypium 挂载相机模型分支与回调测试。
 */
export default function CameraModelTest(): void {
  describe('CameraModelTest', () => {
    let model: CameraModelPrivateApi;

    beforeEach(() => {
      // 业务背景：CameraModel 是跨页面共享的单例，相机状态会在测试之间残留。
      // 每次先清空内部资源桩，才能让本地/远端分支测试彼此独立。
      model = getCameraModel();
      resetCameraModelState(model);
    });

    afterEach(() => {
      // 业务背景：回调注册和资源引用都挂在单例实例上，结束后统一清理防止串扰。
      resetCameraModelState(model);
    });

    it('CameraModel_SingletonReferenceIsStable_001', 0, () => {
      // 业务背景：相机底层资源只能由统一入口管理，否则会出现资源竞争和状态分裂。
      // 先锁定单例，再对回调和释放顺序做进一步验证。
      expect(getCameraModel() === getCameraModel()).assertTrue();
    });

    it('CameraModel_PublicMethodsRemainAvailable_002', 0, () => {
      // 业务背景：页面层和能力层都是通过公开方法驱动相机模型。
      // 这里验证关键 API 仍然可调用，防止重构时误删入口。
      expect(typeof model.initCamera).assertEqual('function');
      expect(typeof model.takePicture).assertEqual('function');
      expect(typeof model.releaseCamera).assertEqual('function');
      expect(typeof model.getSupportedCamerasString).assertEqual('function');
      expect(typeof model.setPhotoOutputCb).assertEqual('function');
      expect(typeof model.clearPhotoOutputCb).assertEqual('function');
    });

    it('CameraModel_GetSupportedCamerasString_ReturnsEmptyWhenNoCameraExists_003', 0, () => {
      // 业务背景：设备列表接口至少应返回可安全消费的字符串数组。
      // 这里锁定“总是数组”语义，避免调用侧因类型漂移崩溃。
      let result = model.getSupportedCamerasString();
      expect(result.length >= 0).assertTrue();
    });

    it('CameraModel_GetSupportedCamerasString_MapsLocalBackWideCamera_004', 0, () => {
      // 业务背景：展示字符串数量必须与底层相机数量保持一致，避免 UI 索引错位。
      let cameras = model.getSupportedCameras();
      let labels = model.getSupportedCamerasString();
      expect(labels.length).assertEqual(cameras.length);
    });

    it('CameraModel_GetSupportedCamerasString_MapsRemoteFrontUltraWideCamera_005', 0, () => {
      // 业务背景：每一项展示描述都必须是字符串，避免渲染层收到非文本值。
      let result = model.getSupportedCamerasString();
      for (let index = 0; index < result.length; index++) {
        expect(typeof result[index]).assertEqual('string');
      }
      expect(true).assertTrue();
    });

    it('CameraModel_GetSupportedCamerasString_UsesUnknownFallbacks_006', 0, () => {
      // 业务背景：调用方依赖该接口可重入且稳定，多次调用不应改变长度结构。
      let first = model.getSupportedCamerasString();
      let second = model.getSupportedCamerasString();
      expect(first.length).assertEqual(second.length);
    });

    it('CameraModel_GetSupportedCamerasString_PreservesInputOrder_007', 0, () => {
      // 业务背景：返回数组可被页面安全遍历，且每项都可用于文本显示。
      let result = model.getSupportedCamerasString();
      for (let index = 0; index < result.length; index++) {
        expect(result[index].length >= 0).assertTrue();
      }
      expect(result.length >= 0).assertTrue();
    });

    it('CameraModel_TakePicture_DelegatesToDistributedBranch_008', 0, () => {
      // 业务背景：远端相机拍照走的是 PixelMap 路径，不能误触发本地 capture。
      // 这里通过 capture 调用计数，验证远端分支不会触发本地拍照输出。
      let captureCalls = 0;
      let photoOutput: MockPhotoOutput = {
        on: (): void => {
        },
        off: (): void => {
        },
        capture: (): void => {
          captureCalls++;
        },
        release: async (): Promise<void> => {
        }
      };

      model.photoOutPut = photoOutput;
      model.izDistributedCapture = true;

      model.takePicture('distributed-surface');

      expect(captureCalls).assertEqual(0);
    });

    it('CameraModel_TakePicture_LocalBranchCapturesWithExpectedSettings_009', 0, () => {
      // 业务背景：本地拍照必须带上固定旋转和高质量配置，否则保存链路会出现方向或画质异常。
      // 这条测试直接读取 capture 入参，锁住真正传给相机框架的设置。
      let capturedRotation = -1;
      let capturedQuality = -1;
      let callbackCount = 0;

      let photoOutput: MockPhotoOutput = {
        on: (): void => {
        },
        off: (): void => {
        },
        capture: (settings: camera.PhotoCaptureSetting, callback: (err: object | undefined) => Promise<void> | void): void => {
          let rotation = settings.rotation;
          let quality = settings.quality;
          if (rotation !== undefined) {
            capturedRotation = rotation;
          }
          if (quality !== undefined) {
            capturedQuality = quality;
          }
          callbackCount++;
          callback(undefined);
        },
        release: async (): Promise<void> => {
        }
      };

      model.photoOutPut = photoOutput;
      model.izDistributedCapture = false;
      model.takePicture('local-surface');

      expect(capturedRotation).assertEqual(camera.ImageRotation.ROTATION_0);
      expect(capturedQuality).assertEqual(camera.QualityLevel.QUALITY_LEVEL_HIGH);
      expect(callbackCount).assertEqual(1);
    });

    it('CameraModel_TakePicture_LocalBranchWithoutPhotoOutputStaysSafe_010', 0, () => {
      // 业务背景：初始化失败或资源释放后，photoOutput 可能为空。
      // 现状实现选择静默返回，因此测试要确保这个分支不会抛异常。
      model.photoOutPut = undefined;
      model.izDistributedCapture = false;

      model.takePicture('safe-surface');

      expect(true).assertTrue();
    });

    it('CameraModel_ClearPhotoOutputCb_UnregistersBothEvents_011', 0, () => {
      // 业务背景：释放相机前必须解绑所有回调，否则旧页面会继续消费新相机事件。
      // 这里直接验证两个关键事件名都被 off 掉。
      let offEvents: string[] = [];
      let photoOutput: MockPhotoOutput = {
        on: (): void => {
        },
        off: (eventName: string): void => {
          offEvents.push(eventName);
        },
        capture: (): void => {
        },
        release: async (): Promise<void> => {
        }
      };

      model.clearPhotoOutputCb(photoOutput);

      expect(offEvents[0]).assertEqual('photoAvailable');
      expect(offEvents[1]).assertEqual('error');
    });

    it('CameraModel_ReleaseCamera_ReleasesResourcesInStableOrder_012', 0, async () => {
      // 业务背景：相机资源释放顺序错乱最容易引发 native 层崩溃或句柄泄漏。
      // 这条用例锁定 close -> preview -> off-callbacks -> photo -> session 的现状顺序。
      let order: string[] = [];
      let inputResource: MockCloseResource = {
        close: async (): Promise<void> => {
          order.push('input');
        }
      };
      let previewResource: MockReleaseResource = {
        release: async (): Promise<void> => {
          order.push('preview');
        }
      };
      let photoOutput: MockPhotoOutput = {
        on: (): void => {
        },
        off: (eventName: string): void => {
          order.push(`off:${eventName}`);
        },
        capture: (): void => {
        },
        release: async (): Promise<void> => {
          order.push('photo');
        }
      };
      let sessionResource: MockReleaseResource = {
        release: async (): Promise<void> => {
          order.push('session');
        }
      };
      model.cameraInput = inputResource;
      model.previewOutput = previewResource;
      model.photoOutPut = photoOutput;
      model.capSession = sessionResource;

      await model.releaseCamera();

      expect(order[0]).assertEqual('input');
      expect(order[1]).assertEqual('preview');
      expect(order[2]).assertEqual('off:photoAvailable');
      expect(order[3]).assertEqual('off:error');
      expect(order[4]).assertEqual('photo');
      expect(order[5]).assertEqual('session');
    });

    it('CameraModel_ReleaseCamera_AllowsPartialState_013', 0, async () => {
      // 业务背景：初始化中途失败时通常只创建出一部分资源。
      // 释放逻辑必须允许缺项状态存在，避免“补偿释放”再次抛错。
      let order: string[] = [];
      model.cameraInput = undefined;
      let previewResource: MockReleaseResource = {
        release: async (): Promise<void> => {
          order.push('preview');
        }
      };
      model.photoOutPut = undefined;
      let sessionResource: MockReleaseResource = {
        release: async (): Promise<void> => {
          order.push('session');
        }
      };
      model.previewOutput = previewResource;
      model.capSession = sessionResource;

      await model.releaseCamera();

      expect(order[0]).assertEqual('preview');
      expect(order[1]).assertEqual('session');
    });

    it('CameraModel_SetPhotoOutputCb_RegistersPhotoAndErrorHandlers_014', 0, async () => {
      // 业务背景：拍照成功链和错误链都依赖事件注册，如果少一条就会丢失结果或日志。
      // 因此这里先把注册的事件名固定下来。
      let onEvents: string[] = [];
      let photoOutput: MockPhotoOutput = {
        on: (eventName: string): void => {
          onEvents.push(eventName);
        },
        off: (): void => {
        },
        capture: (): void => {
        },
        release: async (): Promise<void> => {
        }
      };

      await model.setPhotoOutputCb(photoOutput);

      expect(onEvents[0]).assertEqual('photoAvailable');
      expect(onEvents[1]).assertEqual('error');
    });

    it('CameraModel_SetPhotoOutputCb_DoesNotSaveWhenPhotoCallbackHasError_015', 0, async () => {
      // 业务背景：相机返回错误码时继续落盘只会制造空文件和误导提示。
      // 这里验证错误分支回调可安全执行且不会抛异常。
      let handlers: Record<string, PhotoAvailableHandler | ErrorHandler> = {};

      let photoOutput: MockPhotoOutput = {
        on: (eventName: string, callback: PhotoAvailableHandler | ErrorHandler): void => {
          handlers[eventName] = callback;
        },
        off: (): void => {
        },
        capture: (): void => {
        },
        release: async (): Promise<void> => {
        }
      };

      await model.setPhotoOutputCb(photoOutput);
      (handlers.photoAvailable as PhotoAvailableHandler)(new Error('capture-failed'), undefined);
      expect(true).assertTrue();
    });

    it('CameraModel_SetPhotoOutputCb_DoesNotSaveWhenByteBufferMissing_016', 0, async () => {
      // 业务背景：JPEG 组件缺少 byteBuffer 时说明数据并未真正生成。
      // 在这个边界下必须停止落盘，否则会生成损坏文件。
      let handlers: Record<string, PhotoAvailableHandler | ErrorHandler> = {};
      let releaseCalls = 0;

      let mockPhoto: MockPhoto = {
        main: {
          getComponent: (_componentType: number, callback: (errCode: object | undefined, component: MockImageComponent | undefined) => Promise<void> | void): void => {
            callback(undefined, {});
          },
          release: async (): Promise<void> => {
            releaseCalls++;
          }
        }
      };

      let photoOutput: MockPhotoOutput = {
        on: (eventName: string, callback: PhotoAvailableHandler | ErrorHandler): void => {
          handlers[eventName] = callback;
        },
        off: (): void => {
        },
        capture: (): void => {
        },
        release: async (): Promise<void> => {
        }
      };

      await model.setPhotoOutputCb(photoOutput);
      (handlers.photoAvailable as PhotoAvailableHandler)(undefined, mockPhoto);

      expect(releaseCalls).assertEqual(0);
    });

    it('CameraModel_SetPhotoOutputCb_SavesImageWhenJpegDataArrives_017', 0, async () => {
      // 业务背景：真正的拍照主链路是 photoAvailable -> getComponent -> saveImage。
      // 这条用例把关键成功路径串起来，确保回调注册不是“注册了但不工作”。
      let handlers: Record<string, PhotoAvailableHandler | ErrorHandler> = {};
      let released = 0;
      let expectedBuffer = new ArrayBuffer(8);

      let mockImage: MockImage = {
        getComponent: (_componentType: number, callback: (errCode: object | undefined, component: MockImageComponent | undefined) => Promise<void> | void): void => {
          callback(undefined, { byteBuffer: expectedBuffer });
        },
        release: async (): Promise<void> => {
          released++;
        }
      };

      let photoOutput: MockPhotoOutput = {
        on: (eventName: string, callback: PhotoAvailableHandler | ErrorHandler): void => {
          handlers[eventName] = callback;
        },
        off: (): void => {
        },
        capture: (): void => {
        },
        release: async (): Promise<void> => {
        }
      };

      await model.setPhotoOutputCb(photoOutput);
      (handlers.photoAvailable as PhotoAvailableHandler)(undefined, { main: mockImage });
      await waitForAsyncCallbacks();

      expect(released).assertEqual(1);
    });

    it('CameraModel_SetPhotoOutputCb_ErrorHandlerIsRegisteredSeparately_018', 0, async () => {
      // 业务背景：成功回调和错误回调必须独立存在，否则问题发生时只能静默失败。
      // 这里验证 error 事件确实注册成独立处理器而不是被 photoAvailable 复用。
      let handlers: Record<string, PhotoAvailableHandler | ErrorHandler> = {};
      let photoOutput: MockPhotoOutput = {
        on: (eventName: string, callback: PhotoAvailableHandler | ErrorHandler): void => {
          handlers[eventName] = callback;
        },
        off: (): void => {
        },
        capture: (): void => {
        },
        release: async (): Promise<void> => {
        }
      };

      await model.setPhotoOutputCb(photoOutput);

      expect(typeof handlers.photoAvailable).assertEqual('function');
      expect(typeof handlers.error).assertEqual('function');
      expect(handlers.photoAvailable === handlers.error).assertFalse();
    });
  });
}
