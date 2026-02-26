import { FaceObject } from "../Types/ParamsType";

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
type Point = { x: number; y: number };

export class CRect2f {
  val: number[] = [];

  constructor(x1: number, y1: number, x2: number, y2: number) {
    this.val[0] = x1;
    this.val[1] = y1;
    this.val[2] = x2;
    this.val[3] = y2;
  }

  operator(i) {
    return this.val[i];
  }

  print() {
    return `rect ${this.val.join(',')} \n`;
  }
}
;

export function _ratio_enum(anchor: number[], ratios: number[]) {
  let w: number = anchor[2] - anchor[0] + 1;
  let h: number = anchor[3] - anchor[1] + 1;
  let x_ctr: number = anchor[0] + 0.5 * (w - 1);
  let y_ctr: number = anchor[1] + 0.5 * (h - 1);

  let sz: number = w * h;

  let res: number[][] = [];
  for (let s = 0; s < ratios.length; s++) {
    let r: number = ratios[s];
    let size_ratios: number = sz / r;
    let ws: number = Math.sqrt(size_ratios);
    let hs: number = ws * r;
    let ratio_anchor: CRect2f =
      new CRect2f(x_ctr - 0.5 * (ws - 1), y_ctr - 0.5 * (hs - 1), x_ctr + 0.5 * (ws - 1), y_ctr + 0.5 * (hs - 1));
    res.push(ratio_anchor.val);
  }
  return res;
}

export function _scale_enum(ratio_anchor: number[][], scales: number[]) {
  let res: number[][] = [];
  for (let a = 0; a < ratio_anchor.length; a++) {
    let anchor: number[] = ratio_anchor[a];

    let w: number = anchor[2] - anchor[0] + 1;
    let h: number = anchor[3] - anchor[1] + 1;
    let x_ctr: number = anchor[0] + 0.5 * (w - 1);
    let y_ctr: number = anchor[1] + 0.5 * (h - 1);


    for (let s = 0; s < scales.length; s++) {
      let ws: number = w * scales[s];
      let hs: number = h * scales[s];

      let scale_anchor: CRect2f =
        new CRect2f(x_ctr - 0.5 * (ws - 1), y_ctr - 0.5 * (hs - 1), x_ctr + 0.5 * (ws - 1), y_ctr + 0.5 * (hs - 1));
      res.push(scale_anchor.val);
    }
  }
  return res;
}

export function landmark_pred(anchor, delta, ratiow = 1, ratioh = 1) {
  let w: number = anchor[2] - anchor[0] + 1;
  let h: number = anchor[3] - anchor[1] + 1;
  let x_ctr: number = anchor[0] + 0.5 * (w - 1);
  let y_ctr: number = anchor[1] + 0.5 * (h - 1);
  let pts_delta: Point[] = [];
  for (let i = 0; i < delta.length; i++) {
    pts_delta[i] = {
      x: (delta[i].x * w + x_ctr) * ratiow,
      y: (delta[i].y * h + y_ctr) * ratioh
    };
  }
  return pts_delta;
}

//得到最后的box
export function bbox_pred(anchor, delta, ratiow = 1, ratioh = 1) {
  let w: number = anchor[2] - anchor[0] + 1;
  let h: number = anchor[3] - anchor[1] + 1;
  let x_ctr: number = anchor[0] + 0.5 * (w - 1);
  let y_ctr: number = anchor[1] + 0.5 * (h - 1);

  let dx: number = delta[0];
  let dy: number = delta[1];
  let dw: number = delta[2];
  let dh: number = delta[3];

  let pred_ctr_x: number = dx * w + x_ctr;
  let pred_ctr_y: number = dy * h + y_ctr;
  let pred_w: number = Math.exp(dw) * w;
  let pred_h: number = Math.exp(dh) * h;

  return {
    x: (pred_ctr_x - 0.5 * (pred_w - 1.0)) * ratiow,
    y: (pred_ctr_y - 0.5 * (pred_h - 1.0)) * ratioh,
    w: (pred_ctr_x + 0.5 * (pred_w - 1.0)) * ratiow,
    h: (pred_ctr_y + 0.5 * (pred_h - 1.0)) * ratioh
  };
}

export function nms_cpu(boxes: FaceObject[], threshold: number): FaceObject[] {
  let filterOutBoxes: FaceObject[] = [];
  let boxes_len: number = boxes.length;
  if (boxes_len === 0) {
    return filterOutBoxes;
  }

  let idx: number[] = [];
  for (let i = 0; i < boxes_len; i++) {
    idx.push(i);
  }
  boxes.sort((a, b) => a.score - b.score);

  while (idx.length > 0) {
    let good_idx: number = idx[0];
    filterOutBoxes.push(boxes[good_idx]);
    let tmp: number[] = [...idx];
    idx = [];

    for (let i = 1; i < tmp.length; i++) {
      let tmp_i: number = tmp[i];

      let inter_x1: number = Math.max(boxes[good_idx].finalbox.x, boxes[tmp_i].finalbox.x);
      let inter_y1: number = Math.max(boxes[good_idx].finalbox.y, boxes[tmp_i].finalbox.y);
      let inter_x2: number = Math.min(boxes[good_idx].finalbox.w, boxes[tmp_i].finalbox.w);
      let inter_y2: number = Math.min(boxes[good_idx].finalbox.h, boxes[tmp_i].finalbox.h);

      let w: number = Math.max(inter_x2 - inter_x1 + 1, 0.0);
      let h: number = Math.max(inter_y2 - inter_y1 + 1, 0.0);
      let inter_area: number = w * h;
      let area_1: number = (boxes[good_idx].finalbox.w - boxes[good_idx].finalbox.x + 1) *
        (boxes[good_idx].finalbox.h - boxes[good_idx].finalbox.y + 1);
      let area_2: number = (boxes[tmp_i].finalbox.w - boxes[tmp_i].finalbox.x + 1) *
        (boxes[tmp_i].finalbox.h - boxes[tmp_i].finalbox.y + 1);

      let o: number = inter_area / (area_1 + area_2 - inter_area);

      if (o <= threshold) {
        idx.push(tmp_i);
      }
    }
  }
  return filterOutBoxes;
}

