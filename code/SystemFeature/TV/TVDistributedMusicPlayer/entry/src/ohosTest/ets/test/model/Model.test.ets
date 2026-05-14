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

import buttonModel_concurrency_test from './ButtonModel.concurrency.test';
import buttonModel_detail_test from './ButtonModel.detail.test';
import buttonModel_edge_test from './ButtonModel.edge.test';
import buttonModel_test from './ButtonModel.test';
import imageModel_edge_test from './ImageModel.edge.test';
import kvStoreModel_concurrency_test from './KvStoreModel.concurrency.test';
import kvStoreModel_detail_test from './KvStoreModel.detail.test';
import kvStoreModel_edge_test from './KvStoreModel.edge.test';
import kvStoreModel_enhanced_test from './KvStoreModel.enhanced.test';
import kvStoreModel_test from './KvStoreModel.test';
import listModel_edge_test from './ListModel.edge.test';
import music_concurrency_test from './Music.concurrency.test';
import music_detail_test from './Music.detail.test';
import music_edge_test from './Music.edge.test';
import music_enhanced_test from './Music.enhanced.test';
import music_test from './Music.test';
import musicPlayer_concurrency_detail_test from './MusicPlayer.concurrency.detail.test';
import musicPlayer_concurrency_test from './MusicPlayer.concurrency.test';
import musicPlayer_edge_test from './MusicPlayer.edge.test';
import musicPlayer_enhanced_test from './MusicPlayer.enhanced.test';
import musicPlayer_test from './MusicPlayer.test';
import playState_concurrency_test from './PlayState.concurrency.test';
import playState_detail_test from './PlayState.detail.test';
import playState_edge_test from './PlayState.edge.test';
import playState_enhanced_test from './PlayState.enhanced.test';
import playState_test from './PlayState.test';
import remoteDeviceModel_concurrency_detail_test from './RemoteDeviceModel.concurrency.detail.test';
import remoteDeviceModel_concurrency_test from './RemoteDeviceModel.concurrency.test';
import remoteDeviceModel_edge_test from './RemoteDeviceModel.edge.test';
import remoteDeviceModel_test from './RemoteDeviceModel.test';
import sliderModel_edge_test from './SliderModel.edge.test';
import switchModel_edge_test from './SwitchModel.edge.test';
import textFieldModel_edge_test from './TextFieldModel.edge.test';
import textModel_edge_test from './TextModel.edge.test';

export default function modeltestTest(): void {
  buttonModel_concurrency_test();
  buttonModel_detail_test();
  buttonModel_edge_test();
  buttonModel_test();
  imageModel_edge_test();
  kvStoreModel_concurrency_test();
  kvStoreModel_detail_test();
  kvStoreModel_edge_test();
  kvStoreModel_enhanced_test();
  kvStoreModel_test();
  listModel_edge_test();
  music_concurrency_test();
  music_detail_test();
  music_edge_test();
  music_enhanced_test();
  music_test();
  musicPlayer_concurrency_detail_test();
  musicPlayer_concurrency_test();
  musicPlayer_edge_test();
  musicPlayer_enhanced_test();
  musicPlayer_test();
  playState_concurrency_test();
  playState_detail_test();
  playState_edge_test();
  playState_enhanced_test();
  playState_test();
  remoteDeviceModel_concurrency_detail_test();
  remoteDeviceModel_concurrency_test();
  remoteDeviceModel_edge_test();
  remoteDeviceModel_test();
  sliderModel_edge_test();
  switchModel_edge_test();
  textFieldModel_edge_test();
  textModel_edge_test();
}
