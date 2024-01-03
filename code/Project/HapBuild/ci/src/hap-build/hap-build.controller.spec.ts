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

import { Test, TestingModule } from '@nestjs/testing';
import { HapBuildController } from './hap-build.controller';
import { HapBuildService } from './hap-build.service';

describe('HapBuildController', () => {
  let controller: HapBuildController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [HapBuildController],
      providers: [HapBuildService],
    }).compile();

    controller = module.get<HapBuildController>(HapBuildController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
