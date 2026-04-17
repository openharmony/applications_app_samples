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

import fs from 'node:fs';
import path from 'node:path';
import url from 'node:url';

const scriptPath = url.fileURLToPath(import.meta.url);
const ohosTestRoot = path.resolve(path.dirname(scriptPath), '..');
const outDir = path.join(ohosTestRoot, 'ets', 'test', 'generated');

function ensureDir(p) {
  fs.mkdirSync(p, { recursive: true });
}

function xorshift32(seed) {
  let x = seed >>> 0;
  return () => {
    x ^= x << 13;
    x ^= x >>> 17;
    x ^= x << 5;
    return x >>> 0;
  };
}

function pick(rng, list) {
  return list[rng() % list.length];
}

function genCaseLines(fileIndex, count, maxOps) {
  const rng = xorshift32(0xC0FFEE ^ (fileIndex * 0x9E3779B1));
  const caps = [1, 2, 3, 4, 5, 6, 8];
  const keys = Array.from({ length: 24 }, (_v, i) => `k${i}`);
  const lines = [];
  for (let i = 0; i < count; i++) {
    const cap = pick(rng, caps);
    const opsLen = 8 + (rng() % (maxOps - 7));
    const ops = [];
    for (let j = 0; j < opsLen; j++) {
      const kind = rng() % 3 === 0 ? 'G' : 'P';
      const key = pick(rng, keys);
      if (kind === 'G') {
        ops.push(`G:${key}`);
      } else {
        const value = `v_${fileIndex}_${i}_${j}_${rng() % 1000}`;
        ops.push(`P:${key}:${value}`);
      }
    }
    lines.push(`cap=${cap}|ops=${ops.join(',')}`);
  }
  return lines;
}

function renderEtsTest(fileIndex, caseLines) {
  const header = `/*
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

import { describe, expect, it } from '@ohos/hypium';
import LruCache from '@ohos/common/src/main/ets/default/cache/LruCache';

const BUNDLE: string = 'TVLauncher_LruMatrix_${String(fileIndex).padStart(2, '0')}_';

type Op = { kind: 'P', key: string, value: string } | { kind: 'G', key: string };

function parseCase(line: string): { cap: number, ops: Op[] } {
  const parts: string[] = line.split('|');
  const capPart = parts.find(p => p.startsWith('cap=')) ?? 'cap=3';
  const opsPart = parts.find(p => p.startsWith('ops=')) ?? 'ops=';
  const cap = Number(capPart.substring('cap='.length));
  const rawOps: string = opsPart.substring('ops='.length);
  const ops: Op[] = [];
  rawOps.split(',').forEach((token: string) => {
    const t = token.trim();
    if (t.length === 0) {
      return;
    }
    const segs = t.split(':');
    if (segs[0] === 'G' && segs.length >= 2) {
      ops.push({ kind: 'G', key: segs[1] });
      return;
    }
    if (segs[0] === 'P' && segs.length >= 3) {
      ops.push({ kind: 'P', key: segs[1], value: segs.slice(2).join(':') });
    }
  });
  return { cap: cap, ops: ops };
}

function refGet(cache: Map<string, string>, key: string): string | null {
  if (!cache.has(key)) {
    return null;
  }
  const value = cache.get(key);
  if (value === undefined) {
    return null;
  }
  cache.delete(key);
  cache.set(key, value);
  return value;
}

function refPut(cache: Map<string, string>, key: string, value: string, cap: number): void {
  if (cache.has(key)) {
    cache.delete(key);
    cache.set(key, value);
    return;
  }
  if (cache.size >= cap) {
    const oldest = cache.keys().next().value as string | undefined;
    if (oldest !== undefined) {
      cache.delete(oldest);
    }
  }
  cache.set(key, value);
}

function snapshotKeys(cache: Map<string, string>): string[] {
  const keys: string[] = [];
  cache.forEach((_v: string, k: string) => {
    keys.push(k);
  });
  return keys;
}

function runOneCase(line: string): void {
  /**
   * 这里引入参考实现是为了把“用例生成”和“被测实现”解耦：
   * 用例只提供输入序列，期望行为完全由参考 LRU 语义推导，避免用例本身带入实现偏差。
   */
  const parsed = parseCase(line);
  const cap = parsed.cap;
  const ops = parsed.ops;
  const ref = new Map<string, string>();
  const sut = new LruCache(cap);
  const touchedKeys: Set<string> = new Set<string>();

  ops.forEach((op: Op) => {
    if (op.kind === 'P') {
      touchedKeys.add(op.key);
      refPut(ref, op.key, op.value, cap);
      sut.putCache(op.key, op.value);
      return;
    }
    touchedKeys.add(op.key);
    const refValue = refGet(ref, op.key);
    const sutValue = sut.getCache(op.key);
    expect(sutValue as string | null).assertEqual(refValue);
  });

  /**
   * 结束态校验通过“同样的读取顺序”来避免扰动问题：
   * 读取会改变 LRU 次序，但参考与被测都以一致顺序读取，因此最终对齐仍然成立。
   */
  const keysToVerify: string[] = Array.from(touchedKeys.values()).sort();
  keysToVerify.forEach((k: string) => {
    const refValue = refGet(ref, k);
    const sutValue = sut.getCache(k);
    expect(sutValue as string | null).assertEqual(refValue);
  });

  const remainingKeys: string[] = snapshotKeys(ref).sort();
  remainingKeys.forEach((k: string) => {
    const refValue = refGet(ref, k);
    const sutValue = sut.getCache(k);
    expect(sutValue as string | null).assertEqual(refValue);
  });
}

const CASE_LINES: string[] = [
`;

  const footer = `
];

export default function tvLauncherLruMatrix${String(fileIndex).padStart(2, '0')}Test() {
  describe('TVLauncherLruMatrix${String(fileIndex).padStart(2, '0')}', () => {
    it(BUNDLE + 'Matrix_001', 0, () => {
      /**
       * LRU 的核心风险在于“边界容量 + 高频 get/put 交织”会触发次序抖动，
       * 因此这里将大量随机化序列聚合到一个用例内，一次覆盖更多状态空间。
       */
      for (let i = 0; i < CASE_LINES.length; i++) {
        runOneCase(CASE_LINES[i]);
      }
    });
  });
}
`;

  const lines = caseLines.map((l) => `  '${l}',`);
  return header + lines.join('\n') + footer;
}

function main() {
  ensureDir(outDir);

  const fileCount = Number(process.env.TVLAUNCHER_GEN_FILES ?? '18');
  const casesPerFile = Number(process.env.TVLAUNCHER_GEN_CASES ?? '1500');
  const maxOps = Number(process.env.TVLAUNCHER_GEN_MAXOPS ?? '26');

  for (let i = 1; i <= fileCount; i++) {
    const cases = genCaseLines(i, casesPerFile, maxOps);
    const fileName = `GeneratedLruCacheMatrix${String(i).padStart(2, '0')}.test.ets`;
    const outPath = path.join(outDir, fileName);
    const content = renderEtsTest(i, cases);
    fs.writeFileSync(outPath, content, 'utf8');
  }

  process.stdout.write(
    `Generated ${fileCount} files into ${outDir}. Each file contains ~${casesPerFile} matrix lines.\\n`
  );
}

main();

