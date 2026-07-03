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
import { FaceObject, finalboxModel } from '../Types/ParamsType';

interface Delta {
  x: number,
  y: number
}

export class CRect2f {
  public val: number[] = [];

  constructor(x1: number, y1: number, x2: number, y2: number) {
    this.val[0] = x1;
    this.val[1] = y1;
    this.val[2] = x2;
    this.val[3] = y2;
  }

  operator(i: number) {
    return this.val[i];
  }

  print() {
    return `rect ${this.val.join(',')} \n`;
  }
}
;

export function ratioEnum(anchor: number[], ratios: number[]) {
  let w = anchor[2] - anchor[0] + 1;
  let h = anchor[3] - anchor[1] + 1;
  let xCtr = anchor[0] + 0.5 * (w - 1);
  let yCtr = anchor[1] + 0.5 * (h - 1);

  let sz = w * h;

  let res: number[][] = [];
  for (let s = 0; s < ratios.length; s++) {
    let r = ratios[s];
    let sizeRatios = sz / r;
    let ws = Math.sqrt(sizeRatios);
    let hs = ws * r;
    let ratioAnchor =
      new CRect2f(xCtr - 0.5 * (ws - 1), yCtr - 0.5 * (hs - 1), xCtr + 0.5 * (ws - 1), yCtr + 0.5 * (hs - 1));
    res.push(ratioAnchor.val);
  }
  return res;
}

export function scaleEnum(ratioAnchor: number[][], scales: number[]) {
  let res: number[][] = [];
  for (let a = 0; a < ratioAnchor.length; a++) {
    let anchor = ratioAnchor[a];

    let w = anchor[2] - anchor[0] + 1;
    let h = anchor[3] - anchor[1] + 1;
    let xCtr = anchor[0] + 0.5 * (w - 1);
    let yCtr = anchor[1] + 0.5 * (h - 1);


    for (let s = 0; s < scales.length; s++) {
      let ws = w * scales[s];
      let hs = h * scales[s];

      let scaleAnchor =
        new CRect2f(xCtr - 0.5 * (ws - 1), yCtr - 0.5 * (hs - 1), xCtr + 0.5 * (ws - 1), yCtr + 0.5 * (hs - 1));
      res.push(scaleAnchor.val);
    }
  }
  return res;
}

export function landmarkPred(anchor: number[], delta: Delta[], ratiow = 1, ratioh = 1) {
  let w = anchor[2] - anchor[0] + 1;
  let h = anchor[3] - anchor[1] + 1;
  let xCtr = anchor[0] + 0.5 * (w - 1);
  let yCtr = anchor[1] + 0.5 * (h - 1);
  let ptsDelta: Delta[] = [];
  for (let i = 0; i < delta.length; i++) {
    ptsDelta[i] = {
      x: (delta[i].x * w + xCtr) * ratiow,
      y: (delta[i].y * h + yCtr) * ratioh
    };
  }
  return ptsDelta;
}

//得到最后的box
export function bboxPred(anchor: number[], delta: number[], ratiow = 1, ratioh = 1): finalboxModel {
  let w = anchor[2] - anchor[0] + 1;
  let h = anchor[3] - anchor[1] + 1;
  let xCtr = anchor[0] + 0.5 * (w - 1);
  let yCtr = anchor[1] + 0.5 * (h - 1);

  let dx = delta[0];
  let dy = delta[1];
  let dw = delta[2];
  let dh = delta[3];

  let predCtrX = dx * w + xCtr;
  let predCtrY = dy * h + yCtr;
  let predW = Math.exp(dw) * w;
  let predH = Math.exp(dh) * h;

  return {
    x: (predCtrX - 0.5 * (predW - 1.0)) * ratiow,
    y: (predCtrY - 0.5 * (predH - 1.0)) * ratioh,
    w: (predCtrX + 0.5 * (predW - 1.0)) * ratiow,
    h: (predCtrY + 0.5 * (predH - 1.0)) * ratioh,
    width: 0,
    height: 0,
    size: 0
  };
}

export function nmsCpu(boxes: FaceObject[], threshold: number) {
  let filterOutBoxes: FaceObject[] = [];
  let boxesLen = boxes.length;
  if (boxesLen == 0) {
    return filterOutBoxes;
  }

  let idx: number[] = [];
  for (let i = 0; i < boxesLen; i++) {
    idx.push(i);
  }
  boxes.sort((a: FaceObject, b: FaceObject) => {
    if (a.score !== undefined && b.score !== undefined) {
      return a.score - b!.score;
    }
    return 0;
  });

  while (idx.length > 0) {
    let goodIdx = idx[0];
    filterOutBoxes.push(boxes[goodIdx]);
    let tmp = [...idx];
    idx = [];

    for (let i = 1; i < tmp.length; i++) {
      let tmpI = tmp[i];

      let interX1 = Math.max(boxes[goodIdx].finalbox.x, boxes[tmpI].finalbox.x);
      let interY1 = Math.max(boxes[goodIdx].finalbox.y, boxes[tmpI].finalbox.y);
      let interX2 = Math.min(boxes[goodIdx].finalbox.w, boxes[tmpI].finalbox.w);
      let interY2 = Math.min(boxes[goodIdx].finalbox.h, boxes[tmpI].finalbox.h);

      let w = Math.max((interX2 - interX1 + 1), 0.0);
      let h = Math.max((interY2 - interY1 + 1), 0.0);
      let interArea = w * h;
      let area1 = (boxes[goodIdx].finalbox.w - boxes[goodIdx].finalbox.x + 1) *
        (boxes[goodIdx].finalbox.h - boxes[goodIdx].finalbox.y + 1);
      let area2 = (boxes[tmpI].finalbox.w - boxes[tmpI].finalbox.x + 1) *
        (boxes[tmpI].finalbox.h - boxes[tmpI].finalbox.y + 1);

      let o = interArea / (area1 + area2 - interArea);

      if (o <= threshold) {
        idx.push(tmpI);
      }

    }
  }
  return filterOutBoxes;
}

