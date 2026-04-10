/**
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
import Response from './Response';
import buffer from '@ohos.buffer';

class EmptyPayload {
}

export default abstract class Request {
  response?: Response;
  header: Object;
  body: Object;

  constructor(header?: Object, body?: Object) {
    this.header = header === undefined ? new EmptyPayload() : header;
    this.body = body === undefined ? new EmptyPayload() : body;
  }

  abstract serialize(): buffer.Buffer;
}
