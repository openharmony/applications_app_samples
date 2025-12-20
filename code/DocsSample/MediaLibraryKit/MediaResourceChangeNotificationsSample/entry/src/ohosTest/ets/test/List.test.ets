/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
 
import registerListenerToPhotoAssetTest from './RegisterListenerToPhotoAsset.test';
import registerListenerToAlbumTest from './RegisterListenerToAlbum.test';
import registerForMonitoringAllAssetsTest from './RegisterForMonitoringAllAssets.test';
import cancelListeningURITest from './CancelListeningURI.test';

export default function testsuite(): void {
  registerListenerToPhotoAssetTest(); // Can not test this 'Media Inner Fail'
  registerListenerToAlbumTest();
  registerForMonitoringAllAssetsTest(); // Can not test this 'Media Inner Fail'
  cancelListeningURITest(); // Can not test this 'Media Inner Fail'
}