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

import { ErrorCallback, AsyncCallback, Callback } from './@ohos.base';

/**
 * @name mslite
 * @since 9
 * @import import mslite from '@ohos.mslite'
 */
declare namespace mslite {
  /**
   * Creates an MSLiteModel instance.
   * @since 9
   * @syscap SystemCapability.Mslite.MSLiteModel
   * @import import mslite from '@ohos.mslite'
   * @param model The path to the model (string), or the model content in memory(ArrayBuffer), or memory fd.
   * @param options Options related to model inference.
   * @throws { BusinessError } 5400101 - No memory. Return by callback.
   * @return A Promise instance used to return MSLiteModel instance if the operation is successful; returns null otherwise.
   */
  function loadModel(
    model: string | ArrayBuffer,
    options?: ContextOptions): Promise<MSLiteModel>;


  /**
   * Manages model. Before calling an MSLiteModel method, you must use loadMSLiteModel()
   * to create an MSLiteModel instance.
   * @since 9
   * @syscap SystemCapability.Mslite.MSLiteModel
   */
  interface MSLiteModel {
    /**
     * Get model input tensors.
     * @since 9
     * @syscap SystemCapability.Mslite.MSLiteModel
     * @return MSTensor Array
     */
    getInputs(): MSTensor[];

    /**
     * Infer model.
     * @since 9
     * @syscap SystemCapability.Mslite.MSLiteModel
     * @inputs inputs tensor
     * @return outputs tensor
     */
    predict(inputs: MSTensor[]): Promise<MSTensor[]>;
  }

  /**
   * Provides the device configurations.
   * @since 9
   * @syscap SystemCapability.Mslite.MSLiteModel
   */
  interface ContextOptions {
    target?: string[];
    cpu?: CpuDevice;
    nnrt?: NnrtDevice;
  }

  /**
   * Provides the CPU device info.
   * @since 9
   * @syscap SystemCapability.Mslite.MSLiteModel
   */
  interface CpuDevice {
    runtime_num_threads?: number
    thread_affinity_mode?: ThreadAffinityMode;
    thread_affinity_core_list?: number[];
    precision_mode?: string;
  }

  /**
   * Provides the NNRT device info.
   * @since 9
   * @syscap SystemCapability.Mslite.MSLiteModel
   */
  interface NnrtDevice {}

  /**
   * Provides CPU thread affinity mode.
   * @since 9
   * @syscap SystemCapability.Mslite.ContextOptions
   */
  enum ThreadAffinityMode {
    /**
     * NO_BIND.
     * @since 9
     * @syscap SystemCapability.Mslite.ContextOptions
     */
    NO_AFFINITIES = 0,

    /**
     * HIGHER_CPU.
     * @since 9
     * @syscap SystemCapability.Mslite.ContextOptions
     */
    BIG_CORES_FIRST = 1,

    /**
     * MID_CPU.
     * @since 9
     * @syscap SystemCapability.Mslite.ContextOptions
     */
    LITTLE_CORES_FIRST = 2,
  }

  /**
   * Provides MSTensor defination.
   * @since 9
   * @syscap SystemCapability.Mslite.MSTensor
   */
  interface MSTensor {
    /** The name of the tensor. */
    readonly name: string;

    /** The shape of the tensor. */
    readonly shape: number[];

    /** Number of elements in the tensor. */
    //    readonly elementNum: number;
    readonly size: number;

    /** Number of elements in the tensor. */
    readonly dataSize: number;

    /** The data type for the array. */
    readonly dataType: number;

    /** The format type of the tensor. */
    readonly format: number;
    readonly data_buffer: ArrayBuffer;

    /**
     * Get MSTensor data.
     * @since 9
     * @syscap SystemCapability.Mslite.MSTensor
     * @return ArrayBuffer.
     */
    data(): ArrayBuffer;

    /**
     * Set MSTensor data.
     * @since 9
     * @syscap SystemCapability.Mslite.MSTensor
     * @param inputArray, Uint8Array|Uint16Array|Uint32Array|Int8Array|Int16Array|Int32Array|Float32Array|Float64Array
     * @param type, string eg.: uint8,uint16,uint32,int8,int16,int32,float32,float64
     */
    setData(inputArray: ArrayBuffer): void;
  }

  enum DataType {
    kTypeUnknown = 0,
    kNumberTypeInt8 = 32,
    kNumberTypeInt16 = 33,
    kNumberTypeInt32 = 34,
    kNumberTypeInt64 = 35,
    kNumberTypeUInt8 = 37,
    kNumberTypeUInt16 = 38,
    kNumberTypeUInt32 = 39,
    kNumberTypeUInt64 = 40,
    kNumberTypeFloat16 = 42,
    kNumberTypeFloat32 = 43,
    kNumberTypeFloat64 = 44,
    kNumberTypeEnd = 46,
  }

  enum Format {
    DEFAULT_FORMAT = -1,
    NCHW = 0,
    NHWC = 1,
    NHWC4 = 2,
    HWKC = 3,
    HWCK = 4,
    KCHW = 5,
  }
}

export default mslite;