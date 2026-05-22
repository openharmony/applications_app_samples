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
export enum OperationActionID {
  Del = 'Del',
  Move = 'Move',
  MoveConfirm = 'MoveConfirm',
  MoveCancel = 'MoveCancel',
  Copy = 'Copy',
  CopyConfirm = 'CopyConfirm',
  CopyCancel = 'CopyCancel',
  SelectAll = 'SelectAll',
  Select = 'Select',
  SelectCancel = 'SelectCancel',
  Share = 'Share',
  Rename = 'Rename',
}

export interface Operation {
  action: OperationActionID,
  image: Resource,
  imageFocus: Resource,
  text: Resource,
}

export class OperationAction {
  public static del: Operation = {
    action: OperationActionID.Del,
    image: $r('app.media.ic_public_delete'),
    imageFocus: $r('app.media.ic_public_delete_selected'),
    text: $r('app.string.operation_type_delete'),
  }
  public static move: Operation = {
    action: OperationActionID.Move,
    image: $r('app.media.ic_public_move'),
    imageFocus: $r('app.media.ic_public_move_selected'),
    text: $r('app.string.operation_type_move'),
  }
  public static moveCancel: Operation = {
    action: OperationActionID.MoveCancel,
    image: $r('app.media.ic_public_move'),
    imageFocus: $r('app.media.ic_public_move_selected'),
    text: $r('app.string.operation_type_move_cancel'),
  }
  public static moveConfirm: Operation = {
    action: OperationActionID.MoveConfirm,
    image: $r('app.media.ic_public_move'),
    imageFocus: $r('app.media.ic_public_move_selected'),
    text: $r('app.string.operation_type_move_confirm'),
  }
  public static copy: Operation = {
    action: OperationActionID.Copy,
    image: $r('app.media.ic_public_copy'),
    imageFocus: $r('app.media.ic_public_copy_selected'),
    text: $r('app.string.operation_type_copy'),
  }
  public static copyCancel: Operation = {
    action: OperationActionID.CopyCancel,
    image: $r('app.media.ic_public_copy'),
    imageFocus: $r('app.media.ic_public_copy_selected'),
    text: $r('app.string.operation_type_copy_cancel'),
  }
  public static copyConfirm: Operation = {
    action: OperationActionID.CopyConfirm,
    image: $r('app.media.ic_public_copy'),
    imageFocus: $r('app.media.ic_public_copy_selected'),
    text: $r('app.string.operation_type_copy_confirm'),
  }
  public static selectAll: Operation = {
    action: OperationActionID.SelectAll,
    image: $r('app.media.ic_public_all_choice'),
    imageFocus: $r('app.media.ic_public_all_choice_selected'),
    text: $r('app.string.operation_type_all_choice'),
  }
  public static share: Operation = {
    action: OperationActionID.Share,
    image: $r('app.media.ic_public_share'),
    imageFocus: $r('app.media.ic_public_share_selected'),
    text: $r('app.string.operation_type_share'),
  }
  public static rename: Operation = {
    action: OperationActionID.Rename,
    image: $r('app.media.ic_public_rename'),
    imageFocus: $r('app.media.ic_public_rename_selected'),
    text: $r('app.string.operation_type_rename')
  }
}