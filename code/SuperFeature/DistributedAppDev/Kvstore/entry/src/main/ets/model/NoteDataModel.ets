/*
 * Copyright (c) 2020-2023 Huawei Device Co., Ltd.
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

export class NoteModel {
  title: string
  content: string

  constructor(title: string, content: string) {
    this.title = title
    this.content = content
  }
}

export function transStrToNoteModel(str: string): Array<NoteModel> {
  let noteList: Array<NoteModel> = []
  let notes: Array<NoteModel> = [];
  notes = JSON.parse(str);
  for (let note = 0; note < notes.length; ++note ) {
    noteList.push(new NoteModel(notes[note].title, notes[note].content));
  }
  return noteList
}