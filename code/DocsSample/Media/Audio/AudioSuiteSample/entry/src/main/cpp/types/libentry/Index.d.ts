/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

export const CreateAudioRender: (type: number) => string;

export const DestroyAudioRender: (type: number) => string;

export const BaseEditor: (callback: (result: string) => void) => void;

export const AudioSourceSeparationNapi: (callback: (result: string) => void) => void;

export const MixingAndCascadingNapi: (callback: (result: string) => void) => void;

export const EqualizerEffectNapi: () => string;

export const AudioFormatConverterNapi: (callback: (result: string) => void) => void;

export const SpaceRenderRotationNapi: () => string;