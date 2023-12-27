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

import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { HapBuildService } from './hap-build.service';
import { CreateHapBuildDto } from './dto/create-hap-build.dto';
import { UpdateHapBuildDto } from './dto/update-hap-build.dto';
import { getModifyFilelist } from './utils/getModifyFileList';
import { ApiOperation, ApiTags } from '@nestjs/swagger';

@ApiTags('编译App hap')
@Controller('hap-build')
export class HapBuildController {
  constructor(private readonly hapBuildService: HapBuildService) { }

  @Get(':PRId')
  getFilelist(@Param('PRId') PRId: number) {
    return getModifyFilelist(PRId);
  }
}
