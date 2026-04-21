/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export const setSurfaceId: (id: BigInt) => void;
export const setSurfaceId1: (id: BigInt,vdp: BigInt) => void;
export const changeSurface: (id: BigInt, w: number, h: number) => void;
export const drawTransparentBuffer: (id: BigInt) => void;
export const destroySurface: (id: BigInt) => void;
