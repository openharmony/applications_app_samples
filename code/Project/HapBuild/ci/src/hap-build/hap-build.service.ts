/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { Injectable } from '@nestjs/common';
import { CreateHapBuildDto } from './dto/create-hap-build.dto';
import { UpdateHapBuildDto } from './dto/update-hap-build.dto';

@Injectable()
export class HapBuildService {
  create(createHapBuildDto: CreateHapBuildDto) {
    return 'This action adds a new hapBuild';
  }

  findAll() {
    return `This action returns all hapBuild`;
  }

  findOne(id: number) {
    return `This action returns a #${id} hapBuild`;
  }

  update(id: number, updateHapBuildDto: UpdateHapBuildDto) {
    return `This action updates a #${id} hapBuild`;
  }

  remove(id: number) {
    return `This action removes a #${id} hapBuild`;
  }
}
