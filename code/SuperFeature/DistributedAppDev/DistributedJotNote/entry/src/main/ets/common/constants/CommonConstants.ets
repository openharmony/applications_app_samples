/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

export default class CommonConstants {
  static readonly HOME_TITLE: Resource = $r('app.string.HOME_TITLE');
  static readonly IMG_WALL_TITLE: Resource = $r('app.string.IMG_WALL_TITLE');
  static readonly HELLO: Resource = $r('app.string.HELLO');
  static readonly WELCOME_USE_JOT: Resource = $r('app.string.WELCOME_USE_JOT');
  static readonly ENTER_IN: Resource = $r('app.string.ENTER_IN');
  static readonly NOTES_TITLE: Resource = $r('app.string.NOTES_TITLE');
  static readonly PLEASE_INPUT_NOTE_TITLE: Resource = $r('app.string.PLEASE_INPUT_NOTE_TITLE');
  static readonly NOTES_TIME: Resource = $r('app.string.NOTES_TIME');
  static readonly PLEASE_INPUT_NOTE_CONTENT: Resource = $r('app.string.PLEASE_INPUT_NOTE_CONTENT');
  static readonly MIGRATION_SETTINGS: Resource = $r('app.string.MIGRATION_SETTINGS');
  static readonly MIGRATION_ABILITY: Resource = $r('app.string.MIGRATION_ABILITY');
  static readonly MIGRATION_PAGE_STACK: Resource = $r('app.string.MIGRATION_PAGE_STACK');
  static readonly MIGRATION_SOURCE_END: Resource = $r('app.string.MIGRATION_SOURCE_END');
  static readonly TO_DO_LIST: Resource = $r('app.string.TO_DO_LIST');
  static readonly LIST_ARRAY: Array<Resource> = [$r('app.string.LIST_ITEM_ONE'), $r('app.string.LIST_ITEM_TWO'), $r('app.string.LIST_ITEM_THREE'), $r('app.string.LIST_ITEM_FOUR'), $r('app.string.LIST_ITEM_FIVE'), $r('app.string.LIST_ITEM_SIX'), $r('app.string.LIST_ITEM_SEVEN'), $r('app.string.LIST_ITEM_EIGHT'), $r('app.string.LIST_ITEM_ONE'), $r('app.string.LIST_ITEM_TWO'), $r('app.string.LIST_ITEM_THREE')];
  static readonly PLEASE_INPUT_ASYNC_TEXT: Resource = $r('app.string.PLEASE_INPUT_ASYNC_TEXT');

  // Distributed asset use
  static readonly BUNDLE_NAME = 'com.samples.distributedjotnote';
  static readonly DISTRIBUTED_ASSET_NAME: string = 'test.jpg';
  static readonly DISTRIBUTED_ASSET_URI: string = 'file://' + CommonConstants.BUNDLE_NAME + '/data/storage/el2/distributedfiles/dir/test.jpg';
  static readonly DISTRIBUTED_ASSET_PATH: string = '/dir/test.jpg';
  static readonly DISTRIBUTED_ASSET_CREATE_TIME: string = '2023/11/30 19:48:00';
  static readonly DISTRIBUTED_ASSET_MODIFY_TIME: string = '2023/11/30 19:48:00';
  static readonly DISTRIBUTED_ASSET_SIZE: string = '1';

  static readonly DISTRIBUTED_ASSET_SAVE_PATH: string = '/mnt/hmdfs/100/account/device_view/local/data/' + CommonConstants.BUNDLE_NAME + '/dir/test.jpg';
  static readonly DISTRIBUTED_ASSET_DIR: string = '/mnt/hmdfs/100/account/device_view/local/data/' + CommonConstants.BUNDLE_NAME + '/dir';

  // event need
  static readonly EVENT_COMMON_BASE: number = 1000;
  static readonly EVENT_DATA_RESTORE: number = CommonConstants.EVENT_COMMON_BASE + 1;
}