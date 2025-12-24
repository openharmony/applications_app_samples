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
import getUserAlbumTest from './GetUserAlbum.test';
import getMediaFromUserAlbumTest from './GetMediaFromUserAlbum.test';
import addMediaToUserAlbumTest from './AddMediaToUserAlbum.test';
import renameUserAlbumTest from './RenameUserAlbum.test';
import removeMediaFromUserAlbumTest from './RemoveMediaFromUserAlbum.test';

export default function testsuite(): void {
  getUserAlbumTest(); // Need to create user album 'test'
  getMediaFromUserAlbumTest(); // Need to create user album 'test' and add image to it
  addMediaToUserAlbumTest(); // Need to create user album 'test'
  renameUserAlbumTest(); // Need to create user album 'test'
  removeMediaFromUserAlbumTest(); // Need to create user album 'test' and add image to it
}