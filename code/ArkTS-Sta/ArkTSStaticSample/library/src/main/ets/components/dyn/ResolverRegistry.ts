/**
 *
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { DataModel } from './DataModel';
import { CardData } from './CardData';
import { ResolverRegistrySta } from '../sta_dummy/ResolverRegistry';

export interface ICardResolver {
  createData(data: DataModel): CardData;
}

const TAG = 'ResolverRegistry';

class ResolverRegistryImpl {
  private mCardRegistry: Map<string, ICardResolver> = new Map<string, ICardResolver>();

  registerCard(type: string, resolver: ICardResolver): void {
    console.info('---', TAG, 'registerCard name: ' + type + '.');
    this.mCardRegistry.set(type, resolver);

    ResolverRegistrySta.registerCard(type, undefined);
  }

  getCardResolver(type: string): ICardResolver | undefined {
    return this.mCardRegistry.get(type);
  }
}

export const RESOLVER_REGISTRY = new ResolverRegistryImpl();

