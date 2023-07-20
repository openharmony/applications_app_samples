/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

export class BroadcastConstants {
  static readonly DELETE_FROM_BROWSER: number = 0;
  static readonly DELETE_FROM_GRID: number = 1;
  static readonly SELECT = 'select';
  static readonly GROUP_SELECT = 'groupSelect';
  static readonly JUMP_PHOTO_BROWSER = 'JumpPhotoPage';
  static readonly SHOW_DELETE_DIALOG = 'showDeleteDialog';
  static readonly UPDATE_PROGRESS = 'updateProgress';
  static readonly CANCEL_DELETE = 'cancelDelete';
  static readonly JUMP_THIRD_PHOTO_BROWSER = 'jumpThirdPhotoPage';
  static readonly BACK_PRESS_EVENT = 'back';
  static readonly RESET_STATE_EVENT = 'resetState';
  static readonly ON_TAB_CHANGED = 'onTabChanged';
  static readonly RESET_ZERO = 'resetZero';
  static readonly SHOW_DETAIL_DIALOG = 'showDetailDialog';
  static readonly SHOW_THIRD_DELETE_DIALOG = 'showThirdDeleteDialog';
  static readonly SHOW_MULTI_SELECT_DIALOG = 'showMultiSelectDialog';
  static readonly UPDATE_DATA_SOURCE = 'updateDataSource';
  static readonly SHOW_PROGRESS_DIALOG = 'showProgressDialog';
  static readonly DELETE_PROGRESS_DIALOG = 'deleteProgressDialog';
  static readonly CANCEL_OPERATE = 'cancelOperate';
  static readonly MEDIA_OPERATION = 'mediaOperation';
  static readonly OPERATE_CONTINUE = 'operateContinue';
  static readonly OPERATE_PAUSE = 'operatePause';
  static readonly SHOW_RENAME_PHOTO_DIALOG = 'showRenamePhotoDialog';
  static readonly SHOW_SAVE_PHOTO_DIALOG = 'showSavePhotoDialog';
  static readonly SHOW_EDIT_EXIT_PHOTO_DIALOG = 'showEditExitPhotoDialog';
  static readonly SHOW_ADD_NOTES_PHOTO_DIALOG = 'showAddNotesPhotoDialog';
  static readonly SHOW_NEW_ALBUM_PHOTO_DIALOG = 'showNewAlbumPhotoDialog';
  static readonly SHOW_COPY_OR_MOVE_DIALOG = 'showCopyOrMoveDialog';
  static readonly FIND_SAME_FILE_DIALOG = 'findSameFileDialog';
  static readonly ON_REMOTE_CHANGED = 'on_remote_changed';
  static readonly EXIT_SAVE_PROGRESS_CLOSE = 'save_progress_close';
  static readonly SHOW_EDIT_SAVE_PROGRESS_DIALOG = 'show_exit_save_progress_dialog';
  static readonly DOWNLOAD_CANCEL_OPERATE = 'download_cancel_operate';
  static readonly ON_DATA_RELOADED = 'on_data_reloaded';
  static readonly SAVE_FORM_EDITOR_DATA = 'save_form_editor_data';
  static readonly INIT_DATE_TEXT = 'init_date_text';
  static readonly THIRD_ROUTE_PAGE = 'third_route_page';
  static readonly ON_DATA_RELOADED_WITH_EDIT = 'on_data_reloaded_with_edit';
  static readonly PHOTO_EDIT_SAVE_COMPLETE: string = 'photo_edit_save_complete';
  static readonly CHANGE_SWIPER_DURATION = 'change_swiper_duration';
  // USED for AppStorage
  static readonly LEFT_BLANK: string = 'leftBlank';
  static readonly RESET_TAB_SELECTED_STATUE: string = 'reset_tab_selected_statue';
  static readonly RESET_TAB_SELECTED_TEXT: string = 'reset_tab_selected_text';
}