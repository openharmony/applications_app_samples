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
 

import Log from './Log';
import { audio } from '@kit.AudioKit';

const TAG = 'SingleInstanceHelper';
const AUDIO_MANAGER_KEY = 'MultiMediaAudioManager';
const instanceStore: Map<string, Object> = new Map();

export default function createOrGet<T extends Object>(creator: () => T, storageKey: string): T {
  if (!instanceStore.has(storageKey)) {
    instanceStore.set(storageKey, creator());
    Log.showInfo(TAG, `Create key of ${storageKey}`);
  }
  return instanceStore.get(storageKey) as T;
}

export function getAudioManager(): audio.AudioManager {
  if (!instanceStore.has(AUDIO_MANAGER_KEY)) {
    instanceStore.set(AUDIO_MANAGER_KEY, audio.getAudioManager());
    Log.showInfo(TAG, 'Create Audio Manager.');
  }
  return instanceStore.get(AUDIO_MANAGER_KEY) as audio.AudioManager;
}
