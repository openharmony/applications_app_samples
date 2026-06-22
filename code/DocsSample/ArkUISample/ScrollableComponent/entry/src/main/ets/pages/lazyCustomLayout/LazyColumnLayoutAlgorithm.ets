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

import { LayoutConstraint, LazyLayoutHelper, LazyCustomLayoutAlgorithm, ExpandMode, LazyLayoutDirection, ChildrenCountMode, LengthMetrics, LengthUnit, UIContext} from '@kit.ArkUI'

/**
 * ItemPos - 元素位置信息
 * 存储每个元素的起始和结束位置（像素坐标）
 */
interface ItemPos {
  start: number;  // 元素的起始位置（距离总高度顶部的距离）
  end: number;    // 元素的结束位置
}

declare interface LazyLayoutInfo {
  viewStart: number;
  viewEnd: number;
}

// [Start lazy_custom_layout_algorithm_class]
/**
 * LazyColumnLayoutAlgorithm - 单列布局算法
 *
 * 功能：
 * - 单列垂直布局
 * - 懒加载：只测量和布局可视范围内的元素
 * - 锚点保持：间距变化时保持位置稳定
 *
 * 核心数据结构：
 * - itemArr: 存储已测量元素的位置信息（按元素索引排序）
 * - itemArrStartIndex: itemArr 中第一个元素对应的索引
 */
export class LazyColumnLayoutAlgorithm extends LazyCustomLayoutAlgorithm {
  // === 核心布局数据 ===
  private itemArr: ItemPos[] = [];          // 已测量元素的位置数组
  private itemArrStartIndex: number = -1;   // itemArr[0] 对应的实际元素索引
  private estimateItemHeight: number = -1;  // 估算的平均元素高度（用于未知区域的测量）
  private totalHeight: number = 0;          // 总高度（包含未测量区域的估算高度）

  // === 元素信息 ===
  private childCnt: number = 0;             // 子元素总数
  private startIndex: number = -1;          // 当前可视范围的第一个元素索引
  private endIndex: number = -1;            // 当前可视范围的最后一个元素索引

  // === 布局参数 ===
  private rowGap: number = 0;               // 元素间距
  private leftPadding: number = 0;          // 左内边距
  private rightPadding: number = 0;         // 右内边距
  private topPadding: number = 0;           // 上内边距
  private bottomPadding: number = 0;        // 下内边距

  // === 状态追踪 ===
  private prevRowGap: number = 0;           // 上一次的间距（用于检测变化）
  private selfNode?: FrameNode;             // 节点引用（用于触发重新布局）
  private prevStartIndex = -1;              // 上一次布局完成的起始索引号
  private prevEndIndex = -1;                // 上一次布局完成的末尾索引号

  // === 锚点信息（滚动时保持稳定） ===
  private anchorChildIndex: number = -1;              // 锚点元素的索引
  private anchorChildRelativePos: number = 0;        // 锚点距离可视区域边缘的距离
  // [End lazy_custom_layout_algorithm_class]

  // === UI上下文（用于单位转换） ===
  private uiContext?: UIContext;

  constructor(uiContext?: UIContext) {
    super();
    this.uiContext = uiContext;
  }

  // [Start lazy_custom_layout_algorithm_set_row_gap]
  setRowGap(value: number): void {
    if (this.rowGap === value) {
      return;
    }
    this.prevRowGap = this.rowGap;
    this.rowGap = value;
    this.selfNode?.setNeedsLayout();
  }
  // [End lazy_custom_layout_algorithm_set_row_gap]

  getRowGap(): number {
    return this.rowGap;
  }

  setUIContext(context: UIContext): void {
    this.uiContext = context;
  }

  private convertToPx(lengthMetrics: LengthMetrics | undefined, referenceSize?: number): number {
    if (!lengthMetrics) {
      return 0;
    }

    const value = lengthMetrics.value;
    const unit = lengthMetrics.unit ?? LengthUnit.VP;

    switch (unit) {
      case LengthUnit.PX:
        return value;
      case LengthUnit.VP:
        return this.uiContext ? this.uiContext.vp2px(value) : value;
      case LengthUnit.PERCENT:
        return referenceSize ? (value) * referenceSize : 0;
      case LengthUnit.FP:
        return this.uiContext ? this.uiContext.fp2px(value) : value;
      case LengthUnit.LPX:
        return this.uiContext ? this.uiContext.lpx2px(value) : value;
      default:
        return value;
    }
  }

  private updatePadding(self: FrameNode, constraint: LayoutConstraint): void {
    const padding = self.getUserConfigPadding();
    const containerWidth = constraint.percentReference.width;

    this.leftPadding = this.convertToPx(padding?.left, containerWidth);
    this.rightPadding = this.convertToPx(padding?.right, containerWidth);
    this.topPadding = this.convertToPx(padding?.top, containerWidth);
    this.bottomPadding = this.convertToPx(padding?.bottom, containerWidth);
  }

  flushLayoutParamChange(): void {
    // 处理间距变化：调整所有元素位置
    if (this.prevRowGap === this.rowGap || this.itemArr.length === 0) {
      return;
    }

    const gapDiff = this.rowGap - this.prevRowGap;

    for (let i = 0; i < this.itemArr.length; i++) {
      const index = this.itemArrStartIndex + i;
      const posDiff = index * gapDiff;
      this.itemArr[i].start += posDiff;
      this.itemArr[i].end += posDiff;
    }

    if (this.childCnt > 1) {
      this.totalHeight += gapDiff * (this.childCnt - 1);
    }

    this.prevRowGap = this.rowGap;
  }

  // [Start lazy_custom_layout_create_child_constraint]
  /**
   * 创建子元素的布局约束
   * 单列布局：元素宽度等于容器宽度减去左右内边距
   */
  private createChildConstraint(constraint: LayoutConstraint): LayoutConstraint {
    const horizontalPadding = this.leftPadding + this.rightPadding;
    const containerWidth = constraint.maxSize.width;
    const childWidth = containerWidth - horizontalPadding;

    const childConstraint: LayoutConstraint = {
      maxSize: {
        width: childWidth,
        height: constraint.maxSize.height,
      },
      minSize: {
        width: 0,
        height: constraint.minSize.height,
      },
      percentReference: {
        width: childWidth,
        height: constraint.percentReference.height,
      },
    };

    return childConstraint;
  }
  // [End lazy_custom_layout_create_child_constraint]

  // [Start lazy_custom_layout_algorithm_on_measure]
  /**
   * onMeasure - 测量布局的核心方法
   *
   * 流程：
   * 1. 计算并保存内边距
   * 2. 处理空子元素或非懒加载布局
   * 3. 保存锚点信息
   * 4. 测量可视范围内的元素
   * 5. 回收不再可见的元素
   * 6. 调整锚点位置保持滚动稳定
   * 7. 设置布局容器自身大小
   */
  onMeasure(self: FrameNode, constraint: LayoutConstraint, helper?: LazyLayoutHelper): void {
    // [Start lazy_custom_layout_not_expand]
    this.childCnt = self.getChildrenCount(ChildrenCountMode.ALL_NOT_EXPAND);
    // [End lazy_custom_layout_not_expand]
    this.selfNode = self;

    this.updatePadding(self, constraint);
    const verticalPadding = this.topPadding + this.bottomPadding;

    if (this.childCnt == 0) {
      this.clearMeasureState();
      self.setMeasuredSize({ width: constraint.maxSize.width, height: verticalPadding });
      return;
    }

    if (!helper) {
      this.measureAllChildren(self, constraint);
      self.setMeasuredSize({ width: constraint.maxSize.width, height: this.totalHeight + verticalPadding });
      this.prevRowGap = this.rowGap;
      return;
    }

    // 保存锚点信息
    this.saveAnchorInfo(helper, this.totalHeight);

    this.measureInViewRange(self, constraint, helper);

    // 回收不再可见的元素
    this.recycleChildren(helper);

    // 调整锚点位置保持滚动稳定
    this.adjustAnchorPosition(helper);

    self.setMeasuredSize({ width: constraint.maxSize.width, height: this.totalHeight + verticalPadding });
  }
  // [End lazy_custom_layout_algorithm_on_measure]

  // [Start lazy_custom_layout_save_anchor]
  /**
   * saveAnchorInfo - 保存锚点信息
   *
   * 作用：在测量前保存锚点，确保滚动时保持稳定
   *
   * 锚点选择：
   * - FORWARD（正向）：startIndex（可视区域第一个元素）
   * - BACKWARD（反向）：endIndex（可视区域最后一个元素）
   *
   * anchorChildRelativePos：
   * - FORWARD：锚点元素的绝对位置（距离总高度顶部）
   * - BACKWARD：锚点距离总高度底部的距离
   */
  private saveAnchorInfo(helper: LazyLayoutHelper, prevTotalHeight: number): void {
    this.anchorChildIndex = -1;
    this.anchorChildRelativePos = 0;

    if (helper.getLazyLayoutDirection() === LazyLayoutDirection.FORWARD) {
      if (this.startIndex > 0 && this.startIndex < this.childCnt) {
        this.anchorChildIndex = this.startIndex;
        const arrayIndex = this.anchorChildIndex - this.itemArrStartIndex;
        if (arrayIndex >= 0 && arrayIndex < this.itemArr.length) {
          this.anchorChildRelativePos = this.itemArr[arrayIndex].start;
        }
      }
    } else {
      if (this.endIndex >= 0 && this.endIndex < this.childCnt - 1) {
        this.anchorChildIndex = this.endIndex;
        const arrayIndex = this.anchorChildIndex - this.itemArrStartIndex;
        if (arrayIndex >= 0 && arrayIndex < this.itemArr.length) {
          this.anchorChildRelativePos = prevTotalHeight - this.itemArr[arrayIndex].end;
        }
      }
    }
  }
  // [End lazy_custom_layout_save_anchor]

  // [Start lazy_custom_layout_recycle]
  /**
   * recycleChildren - 回收不再可见的元素
   *
   * 作用：释放滚动后离开可视区域的元素，节省内存
   *
   * 回收范围：
   * - 向前滚动：回收 this.prevStartIndex -> this.startIndex 之间的元素
   * - 向后滚动：回收 this.endIndex -> this.prevEndIndex 之间的元素
   */
  private recycleChildren(helper: LazyLayoutHelper): void {
    let recycleList: number[] = [];
    if (this.prevStartIndex >= 0 && this.prevStartIndex < this.startIndex) {
      for (let i = this.prevStartIndex; i < this.startIndex; i++) {
        recycleList.push(i);
      }
    }
    if (this.prevEndIndex >= 0 && this.prevEndIndex > this.endIndex) {
      for (let i = this.endIndex + 1; i <= this.prevEndIndex; i++) {
        recycleList.push(i);
      }
    }
    if (recycleList.length > 0) {
      helper.setChildrenInactive(recycleList);
    }
  }
  // [End lazy_custom_layout_recycle]

  // [Start lazy_custom_layout_algorithm_adjust_anchor]
  /**
   * adjustAnchorPosition - 调整锚点位置保持滚动稳定
   *
   * 作用：测量完成后调整滚动偏移，确保锚点保持在相对可视区域的相同位置
   */
  private adjustAnchorPosition(helper: LazyLayoutHelper): void {
    if (this.anchorChildIndex >= 0) {
      if (helper.getLazyLayoutDirection() === LazyLayoutDirection.FORWARD) {
        const arrayIndex = this.anchorChildIndex - this.itemArrStartIndex;
        if (arrayIndex >= 0 && arrayIndex < this.itemArr.length) {
          let newPos = this.itemArr[arrayIndex].start;
          if (newPos !== this.anchorChildRelativePos) {
            helper.setAdjustedOffset(this.anchorChildRelativePos - newPos);
          }
        }
      } else {
        const arrayIndex = this.anchorChildIndex - this.itemArrStartIndex;
        if (arrayIndex >= 0 && arrayIndex < this.itemArr.length) {
          let newPos = this.totalHeight - this.itemArr[arrayIndex].end;
          if (newPos !== this.anchorChildRelativePos) {
            helper.setAdjustedOffset(newPos - this.anchorChildRelativePos);
          }
        }
      }
    }
  }
  // [End lazy_custom_layout_algorithm_adjust_anchor]

  private clearMeasureState(): void {
    this.itemArr.length = 0;
    this.totalHeight = 0;
    this.startIndex = -1;
    this.endIndex = -1;
  }

  private measureAllChildren(self: FrameNode, constraint: LayoutConstraint): void {
    this.itemArr = [];
    this.itemArrStartIndex = 0;
    let currPos = 0;
    let childConstraint = this.createChildConstraint(constraint);
    for (let i = 0; i < this.childCnt; i++) {
      let child = self.getChild(i, ExpandMode.LAZY_NOT_EXPAND);
      let itemHeight = 0;
      if (child) {
        child.measure(childConstraint);
        itemHeight = child.getMeasuredSize().height;
      }
      this.itemArr[i] = {
        start: currPos,
        end: currPos + itemHeight,
      };
      currPos += itemHeight;
      if (i < this.childCnt - 1) {
        currPos += this.rowGap;
      }
    }

    this.startIndex = 0;
    this.endIndex = this.childCnt - 1;

    if (this.itemArr.length > 0) {
      this.totalHeight = this.itemArr[this.itemArr.length - 1].end;
      this.calculateEstimateItemHeight();
    } else {
      this.totalHeight = 0;
      this.estimateItemHeight = -1;
    }
  }

  /**
   * measureInViewRange - 测量可视范围内的元素
   *
   * 核心流程：
   * 1. 确定测量起点
   * 2. 向前测量直到超出可视范围
   * 3. 如果需要，向后测量补充缺失元素
   * 4. 合并测量结果到 itemArr
   * 5. 更新总高度（包含未测量区域的估算）
   */
  private measureInViewRange(
    self: FrameNode,
    constraint: LayoutConstraint,
    helper: LazyLayoutHelper
  ): void {
    let currIndex = 0;
    let currPos = 0;

    let tmpItemArr: ItemPos[] = [];
    let tmpItemArrStartIndex: number = Number.MAX_SAFE_INTEGER;

    // 完整的初始化逻辑
    if (helper.getLazyLayoutDirection() === LazyLayoutDirection.FORWARD) {
      if (this.itemArrStartIndex >= 0 && this.itemArr.length > 0) {
        currIndex = this.findStartIndex(helper.getViewStart());
        if (currIndex >= this.itemArrStartIndex + this.itemArr.length) {
          const lastItem = this.itemArr[this.itemArr.length - 1];
          currPos = lastItem.end + this.rowGap;
        } else {
          currPos = this.itemArr[currIndex - this.itemArrStartIndex].start;
        }
      } else if (this.anchorChildIndex >= 0) {
        currIndex = this.anchorChildIndex;
        currPos = this.anchorChildRelativePos;
      } else {
        // 初始状态：从头开始测量
        currIndex = 0;
        currPos = 0;
      }

      let startIndex = currIndex;
      let startPos = currPos;
      tmpItemArrStartIndex = this.measureForward(
        self, constraint, helper, currIndex, currPos, tmpItemArr, tmpItemArrStartIndex
      );

      if (startPos - this.rowGap > helper.getViewStart()) {
        tmpItemArrStartIndex = this.measureBackward(
          self, constraint, helper, startIndex - 1, startPos, tmpItemArr, tmpItemArrStartIndex
        );
      }
    } else {
      if (this.itemArrStartIndex >= 0 && this.itemArr.length > 0) {
        currIndex = this.findEndIndex(helper.getViewEnd());
        if (currIndex < this.itemArrStartIndex) {
          const lastItem = this.itemArr[0];
          currPos = lastItem.start;
        } else {
          currPos = this.itemArr[currIndex - this.itemArrStartIndex].end + this.rowGap;
        }
      } else if (this.anchorChildIndex >= 0) {
        currIndex = this.anchorChildIndex;
        currPos = this.totalHeight - this.anchorChildRelativePos + this.rowGap;
      } else {
        // 反向滚动：从最后开始测量
        currIndex = this.childCnt;
        currPos = this.totalHeight + this.rowGap;
      }
      let startIndex = currIndex;
      let startPos = currPos;
      tmpItemArrStartIndex = this.measureBackward(
        self, constraint, helper, startIndex, startPos, tmpItemArr, tmpItemArrStartIndex
      );

      if (startPos < helper.getViewEnd()) {
        tmpItemArrStartIndex = this.measureForward(
          self, constraint, helper, currIndex + 1, currPos, tmpItemArr, tmpItemArrStartIndex
        );
      }
    }

    if (tmpItemArr.length <= 0) {
      this.startIndex = -1;
      this.endIndex = -1;
      return;
    }

    this.startIndex = tmpItemArrStartIndex;
    this.endIndex = tmpItemArrStartIndex + tmpItemArr.length - 1;

    // 处理布局参数变化
    this.flushLayoutParamChange();

    this.merge(tmpItemArrStartIndex, tmpItemArr);
    this.updateTotalHeight();
  }

  // [Start lazy_custom_layout_measure_forward]
  private measureForward(
    self: FrameNode,
    constraint: LayoutConstraint,
    helper: LazyLayoutHelper,
    startIndex: number,
    startPos: number,
    tmpItemArr: ItemPos[],
    tmpItemArrStartIndex: number
  ): number {
    let currIndex = startIndex;
    let currPos = startPos;
    let childConstraint = this.createChildConstraint(constraint);

    for (; currIndex < this.childCnt; currIndex++) {
      let itemHeight = 0;
      let child = self.getChild(currIndex, ExpandMode.LAZY_NOT_EXPAND);
      if (child) {
        child.measure(childConstraint);
        itemHeight = child.getMeasuredSize().height;
      }
      tmpItemArrStartIndex = Math.min(currIndex, tmpItemArrStartIndex);
      tmpItemArr[currIndex - tmpItemArrStartIndex] = {
        start: currPos,
        end: currPos + itemHeight,
      };
      currPos += itemHeight;
      if (currIndex < this.childCnt - 1) {
        currPos += this.rowGap;
      }

      if (currPos > helper.getViewEnd()) {
        break;
      }
    }

    return tmpItemArrStartIndex;
  }
  // [End lazy_custom_layout_measure_forward]

  private measureBackward(
    self: FrameNode,
    constraint: LayoutConstraint,
    helper: LazyLayoutHelper,
    startIndex: number,
    startPos: number,
    tmpItemArr: ItemPos[],
    tmpItemArrStartIndex: number
  ): number {
    let currPos = startPos;
    let currIndex = startIndex;
    let childConstraint = this.createChildConstraint(constraint);

    for (; currIndex >= 0; currIndex--) {
      let itemHeight = 0;
      let child = self.getChild(currIndex, ExpandMode.LAZY_NOT_EXPAND);
      if (child) {
        child.measure(childConstraint);
        itemHeight = child.getMeasuredSize().height;
      }
      tmpItemArrStartIndex = Math.min(currIndex, tmpItemArrStartIndex);
      currPos -= this.rowGap;
      tmpItemArr.unshift({
        start: currPos - itemHeight,
        end: currPos,
      });
      currPos -= itemHeight;

      if (currPos < helper.getViewStart()) {
        break;
      }
    }

    return tmpItemArrStartIndex;
  }

  // [Start lazy_custom_layout_estimate]
  private calculateEstimateItemHeight(): void {
    let totalSize = 0;
    for (const item of this.itemArr) {
      totalSize += (item.end - item.start);
    }
    this.estimateItemHeight = totalSize / this.itemArr.length;
  }

  private updateTotalHeight(): void {
    const endPos = this.itemArr[this.itemArr.length - 1].end;
    const measuredCount = this.itemArrStartIndex + this.itemArr.length;
    const remainingCount = this.childCnt - measuredCount;

    if (remainingCount > 0 && this.estimateItemHeight > 0) {
      // 当还有未测量的元素时，需要考虑间距
      this.totalHeight = endPos + remainingCount * (this.estimateItemHeight + this.rowGap);
    } else {
      this.totalHeight = endPos;
    }
  }
  // [End lazy_custom_layout_estimate]

  // [Start lazy_custom_layout_algorithm_on_layout]
  onLayout(self: FrameNode): void {
    this.prevStartIndex = this.startIndex;
    this.prevEndIndex = this.endIndex;
    if (this.childCnt == 0) {
      return;
    }
    for (let i = this.startIndex; i <= this.endIndex; i++) {
      let child = self.getChild(i, ExpandMode.LAZY_NOT_EXPAND);

      if (child) {
        const arrayIndex = i - this.itemArrStartIndex;

        if (arrayIndex >= 0 && arrayIndex < this.itemArr.length) {
          const x = this.leftPadding;
          const y = this.itemArr[arrayIndex].start + this.topPadding;
          child.layout({x: x, y: y});
        }
      }
    }
  }
  // [End lazy_custom_layout_algorithm_on_layout]

  /**
   * merge - 双指针归并算法
   *
   * 功能：将新测量数据合并到现有布局数据中
   *
   * 性能：O(n+m) 单次遍历完成合并
   *
   * 特性：
   * - 自动处理重叠：实时调整位置避免元素重叠
   * - 智能空隙填充：仅在空隙大于估算高度+间距时填充
   * - 增量数据覆盖：新数据自动覆盖旧数据
   * - 约束保证：确保位置符合理论计算
   */
  merge(deltaStartIndex: number, deltaItemArr: ItemPos[]): void {
    if (!deltaItemArr || deltaItemArr.length === 0) {
      return;
    }

    // 特殊场景：当前无数据，直接使用增量数据
    if (this.itemArr.length === 0) {
      this.itemArrStartIndex = deltaStartIndex;
      this.itemArr = [...deltaItemArr];

      if (deltaItemArr.length > 0) {
        let totalSize = 0;
        for (const item of deltaItemArr) {
          totalSize += (item.end - item.start);
        }
        this.estimateItemHeight = totalSize / deltaItemArr.length;
      }

      this.enforceConstraint();
      return;
    }

    // 预计算关键参数
    const deltaEndIndex = deltaStartIndex + deltaItemArr.length - 1;
    const currentEndIndex = this.itemArrStartIndex + this.itemArr.length - 1;

    // 判断合并场景类型
    const completelyAfter = deltaStartIndex >= currentEndIndex + 1;
    const completelyBefore = deltaEndIndex < this.itemArrStartIndex;
    const hasOverlap = !(completelyAfter || completelyBefore);

    // 判断是否应该填充空隙
    let shouldFillGap = completelyAfter || completelyBefore;

    // 前置场景下，如果间距太小，不填充
    if (completelyBefore && this.itemArr.length > 0 && deltaItemArr.length > 0) {
      const lastDeltaEnd = deltaItemArr[deltaItemArr.length - 1].end;
      const firstCurrentStart = this.itemArr[0].start;
      const actualGap = firstCurrentStart - lastDeltaEnd;
      if (actualGap <= this.rowGap + this.estimateItemHeight) {
        shouldFillGap = false;
      }
    }

    // 后置场景的类似判断
    if (completelyAfter && this.itemArr.length > 0 && deltaItemArr.length > 0) {
      const lastCurrentEnd = this.itemArr[this.itemArr.length - 1].end;
      const firstDeltaStart = deltaItemArr[0].start;
      const actualGap = firstDeltaStart - lastCurrentEnd;
      if (actualGap <= this.rowGap + this.estimateItemHeight) {
        shouldFillGap = false;
      }
    }

    // 计算最终数组的覆盖范围
    const finalStartIndex = Math.min(this.itemArrStartIndex, deltaStartIndex);
    const maxValidEndIndex = this.childCnt - 1;
    const finalEndIndex = Math.min(Math.max(currentEndIndex, deltaEndIndex), maxValidEndIndex);

    // 构建结果数组
    const result: ItemPos[] = [];
    let prevEnd = -Infinity;

    for (let actualIndex = finalStartIndex; actualIndex <= finalEndIndex; actualIndex++) {
      const inCurrentRange = actualIndex >= this.itemArrStartIndex && actualIndex <= currentEndIndex;
      const inDeltaRange = actualIndex >= deltaStartIndex && actualIndex <= deltaEndIndex;

      let newItem: ItemPos | null = null;

      if (inDeltaRange) {
        const deltaIdx = actualIndex - deltaStartIndex;
        newItem = { start: deltaItemArr[deltaIdx].start, end: deltaItemArr[deltaIdx].end };
      } else if (inCurrentRange) {
        const currentIdx = actualIndex - this.itemArrStartIndex;
        newItem = { start: this.itemArr[currentIdx].start, end: this.itemArr[currentIdx].end };
      } else if (shouldFillGap && this.estimateItemHeight > 0) {
        const start = prevEnd + this.rowGap;
        newItem = { start: start, end: start + this.estimateItemHeight };
      }

      if (newItem !== null) {
        if (result.length > 0) {
          const prevItem = result[result.length - 1];
          const requiredStart = prevItem.end + this.rowGap;

          if (newItem.start < requiredStart) {
            const shiftAmount = requiredStart - newItem.start;
            newItem.start += shiftAmount;
            newItem.end += shiftAmount;
          }
        }

        result.push(newItem);
        prevEnd = newItem.end;
      }
    }

    this.itemArr = result;
    this.itemArrStartIndex = finalStartIndex;

    this.enforceConstraint();
  }

  // 确保满足约束：itemArr[0].start 应等于 itemArrStartIndex 个元素的累积高度（包含间距）
  private enforceConstraint(): void {
    if (this.itemArr.length > 0 && this.estimateItemHeight > 0) {
      const expectedStart = this.itemArrStartIndex > 0
        ? this.itemArrStartIndex * this.estimateItemHeight + (this.itemArrStartIndex - 1) * this.rowGap
        : 0;
      const actualStart = this.itemArr[0].start;
      if (Math.abs(expectedStart - actualStart) > 0.1) {
        const shiftAmount = expectedStart - actualStart;
        for (let i = 0; i < this.itemArr.length; i++) {
          this.itemArr[i].start += shiftAmount;
          this.itemArr[i].end += shiftAmount;
        }
      }
    }
  }

  // 使用二分查找找到第一个end > viewStart的索引
  private findStartIndex(viewStart: number): number {
    if (this.itemArr.length === 0) {
      return this.itemArrStartIndex;
    }

    let left = 0;
    let right = this.itemArr.length - 1;
    let result = this.itemArr.length;

    while (left <= right) {
      const mid = Math.floor((left + right) / 2);
      if (this.itemArr[mid].end > viewStart) {
        result = mid;
        right = mid - 1;
      } else {
        left = mid + 1;
      }
    }

    return this.itemArrStartIndex + result;
  }

  // 使用二分查找找到最后一个start < viewEnd的索引
  private findEndIndex(viewEnd: number): number {
    if (this.itemArr.length === 0) {
      return this.itemArrStartIndex - 1;
    }

    let left = 0;
    let right = this.itemArr.length - 1;
    let result = -1;

    while (left <= right) {
      const mid = Math.floor((left + right) / 2);
      if (this.itemArr[mid].start < viewEnd) {
        result = mid;
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    return this.itemArrStartIndex + result;
  }
}