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

import { LayoutConstraint, LazyLayoutHelper, LazyCustomLayoutAlgorithm, ExpandMode, LazyLayoutDirection, ChildrenCountMode} from '@kit.ArkUI'

/**
 * ItemPos - 元素位置信息
 * 存储每个元素的起始位置、结束位置和所在列号
 */
interface ItemPos {
  start: number;    // 元素的起始位置（距离总高度顶部的距离）
  end: number;      // 元素的结束位置
  column: number;   // 元素所在的列号（0 ~ columns-1）
  height: number;   // 元素的高度（end - start）
}

/**
 * LazyWaterFlowLayoutAlgorithm - 瀑布流布局算法
 *
 * 功能：
 * - 多列瀑布流布局（元素高度可不同）
 * - 懒加载：只测量和布局可视范围内的元素
 * - 锚点保持：滚动时保持位置稳定
 * - 动态列分配：新元素自动分配到最短的列
 *
 * 核心数据结构：
 * - itemArr: 存储已测量元素的位置信息（按元素索引排序）
 * - columnHeights: 存储每列的当前高度
 * - columns: 当前列数
 */
export class LazyWaterFlowLayoutAlgorithm extends LazyCustomLayoutAlgorithm {
  // === 核心布局数据 ===
  private itemArr: ItemPos[] = [];          // 已测量元素的位置数组（按索引相对存储）
  private itemArrStartIndex: number = 0;   // itemArr[0] 对应的实际元素索引
  private totalHeight: number = 0;          // 总高度（所有列的最大高度）

  // === 性能优化：增量更新 ===
  private totalMeasuredHeight: number = 0;  // 已测量元素的累计高度（用于增量计算平均值）

  // === 元素信息 ===
  private childCnt: number = 0;             // 子元素总数
  private startIndex: number = -1;          // 当前可视范围的第一个元素索引
  private endIndex: number = -1;            // 当前可视范围的最后一个元素索引

  // === 布局参数 ===
  private columnWidth: number = 0;          // 列宽（根据总宽度和列数计算）
  private columns: number = 2;              // 列数
  private columnGap: number = 0;            // 列间距
  private rowGap: number = 0;               // 行间距
  private columnHeights: number[] = [];     // 每列的当前高度数组
  private columnTops: number[] = [];        // 每列的当前顶部位置数组

  // === 状态追踪 ===
  private prevColumns: number = 2;          // 上一次的列数（用于检测变化）
  private prevRowGap: number = 0;           // 上一次的行间距（用于检测变化）
  private selfNode?: FrameNode;             // 节点引用（用于触发重新布局）

  // === 锚点信息（列数切换时保持滚动稳定） ===
  private anchorChildIndex: number = -1;              // 锚点元素的索引
  private anchorChildRelativePos: number = 0;        // 锚点距离可视区域顶部的距离

  setColumns(value: number): void {
    if (this.columns === value) {
      return;
    }
    this.prevColumns = this.columns;
    this.columns = value;
    this.selfNode?.setNeedsLayout();
  }

  getColumns(): number {
    return this.columns;
  }

  setColumnGap(value: number): void {
    if (this.columnGap === value) {
      return;
    }
    this.columnGap = value;
    this.selfNode?.setNeedsLayout();
  }

  getColumnGap(): number {
    return this.columnGap;
  }

  setRowGap(value: number): void {
    if (this.rowGap === value) {
      return;
    }
    this.prevRowGap = this.rowGap;
    this.rowGap = value;
    this.selfNode?.setNeedsLayout();
  }

  getRowGap(): number {
    return this.rowGap;
  }

  /**
   * flushRowGapChange - 处理行间距变化
   *
   * 作用：当行间距变化时，调整所有已测量元素的位置
   *
   * 原理：
   * - 计算间距差值：gapDiff = rowGap - prevRowGap
   * - 对于每个元素，根据其索引位置调整位置差
   * - 更新总高度以反映间距变化
   */
  flushRowGapChange(): void {
    if (this.prevRowGap === this.rowGap) {
      return;
    }
    if (this.itemArr.length === 0) {
      this.prevRowGap = this.rowGap;
      return;
    }

    const gapDiff = this.rowGap - this.prevRowGap;

    // 统计每一列的元素数量和累计偏移
    const columnElementCount = new Array<number>(this.columns).fill(0);

    // 首先遍历 itemArr，统计每列的元素数量
    for (const item of this.itemArr) {
      columnElementCount[item.column]++;
    }

    // 为每列构建偏移映射（元素在该列中的位置索引）
    const columnCurrentIndex = new Array<number>(this.columns).fill(0);

    // 调整每个元素的位置
    for (let i = 0; i < this.itemArr.length; i++) {
      const item = this.itemArr[i];
      const col = item.column;

      // 该元素在列中的索引（第几个元素）
      const indexInColumn = columnCurrentIndex[col];

      // 累计偏移：第n个元素的偏移量 = n * gapDiff（前面有n个间距）
      if (indexInColumn > 0) {
        const offset = indexInColumn * gapDiff;
        item.start += offset;
        item.end += offset;
      }

      columnCurrentIndex[col]++;
    }

    // 更新列高度数组（每列的最后一个元素end位置需要根据元素数量调整）
    for (let col = 0; col < this.columns; col++) {
      // 每列有 columnElementCount[col] 个元素
      // 如果元素数量 > 1，则每个元素间有间距，总共增加 (count - 1) * gapDiff
      if (columnElementCount[col] > 1) {
        this.columnHeights[col] += gapDiff * (columnElementCount[col] - 1);
      }
    }

    // 更新总高度
    this.totalHeight = Math.max(...this.columnHeights);

    this.prevRowGap = this.rowGap;
  }

  /**
   * 创建子元素的布局约束
   * 根据列宽设置子元素的最大宽度约束
   */
  private createChildConstraint(constraint: LayoutConstraint): LayoutConstraint {
    const childConstraint: LayoutConstraint = {
      maxSize: {
        width: this.columnWidth,
        height: constraint.maxSize.height,
      },
      minSize: {
        width: 0,
        height: constraint.minSize.height,
      },
      percentReference: {
        width: this.columnWidth,
        height: constraint.percentReference.height,
      },
    };

    return childConstraint;
  }

  /**
   * findShortestColumn - 找到当前最短的列
   *
   * 作用：新元素将分配到最短的列，实现瀑布流的动态布局
   *
   * 返回：最短列的索引（0 ~ columns-1）
   */
  private findShortestColumn(): number {
    let minHeight = this.columnHeights[0];
    let minColumn = 0;

    for (let i = 1; i < this.columns; i++) {
      if (this.columnHeights[i] < minHeight) {
        minHeight = this.columnHeights[i];
        minColumn = i;
      }
    }

    return minColumn;
  }

  /**
   * findHighestColumn - 找到当前最高的列（反向布局用）
   *
   * 作用：反向布局时，新元素分配到最高的列，从后往前布局
   *
   * 返回：最高列的索引（0 ~ columns-1）
   */
  private findHighestColumn(): number {
    let maxHeight = this.columnTops[0];
    let maxColumn = 0;

    for (let i = 1; i < this.columns; i++) {
      if (this.columnTops[i] > maxHeight) {
        maxHeight = this.columnTops[i];
        maxColumn = i;
      }
    }

    return maxColumn;
  }

  /**
   * onMeasure - 测量布局的核心方法
   *
   * 流程：
   * 1. 计算列宽
   * 2. 处理空子元素或非Lazy布局
   * 3. 保存锚点信息
   * 4. 列数切换时清空旧数据
   * 5. 测量可视范围内的元素
   * 6. 回收不再可见的元素
   * 7. 调整锚点位置保持滚动稳定
   */
  onMeasure(self: FrameNode, constraint: LayoutConstraint, helper?: LazyLayoutHelper): void {
    this.childCnt = self.getChildrenCount(ChildrenCountMode.ALL_NOT_EXPAND);
    this.selfNode = self;

    // 计算列宽
    this.columnWidth = (constraint.maxSize.width - (this.columns - 1) * this.columnGap) / this.columns;

    if (this.childCnt === 0) {
      this.clearMeasureState();
      self.setMeasuredSize({ width: constraint.maxSize.width, height: 0 });
      return;
    }

    if (!helper || this.childCnt < this.columns) {
      this.measureAllChildren(self, constraint);
      self.setMeasuredSize({ width: constraint.maxSize.width, height: this.totalHeight });
      this.prevColumns = this.columns;
      return;
    }

    // 保存锚点信息
    this.saveAnchorInfo(helper);

    // 列数切换时清空数据
    if (this.prevColumns !== this.columns) {
      this.itemArr = [];
      this.itemArrStartIndex = 0;
      this.columnHeights = new Array<number>(this.columns).fill(0);
      this.prevColumns = this.columns;
    }

    // 处理行间距变化（在测量之前）
    this.flushRowGapChange();

    let startIndex = this.startIndex;
    let endIndex = this.endIndex;

    this.measureInViewRange(self, constraint, helper);

    // 回收不再可见的元素
    this.recycleChildren(helper, startIndex, endIndex);

    // 调整锚点位置保持滚动稳定
    this.adjustAnchorPosition(helper);

    self.setMeasuredSize({ width: constraint.maxSize.width, height: this.totalHeight });
  }

  /**
   * saveAnchorInfo - 保存锚点信息
   *
   * 锚点选择：
   * - FORWARD（正向）：startIndex（可视区域第一个元素）
   * - BACKWARD（反向）：endIndex（可视区域最后一个元素）
   */
  private saveAnchorInfo(helper: LazyLayoutHelper): void {
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
          this.anchorChildRelativePos = this.totalHeight - this.itemArr[arrayIndex].end;
        }
      }
    }
  }

  /**
   * recycleChildren - 回收不再可见的元素
   */
  private recycleChildren(helper: LazyLayoutHelper, startIndex: number, endIndex: number): void {
    let recycleList: number[] = [];
    if (startIndex >= 0 && startIndex < this.startIndex) {
      for (let i = startIndex; i < this.startIndex; i++) {
        recycleList.push(i);
      }
    }
    if (endIndex >= 0 && endIndex > this.endIndex) {
      for (let i = this.endIndex + 1; i <= endIndex; i++) {
        recycleList.push(i);
      }
    }
    if (recycleList.length > 0) {
      helper.setChildrenInactive(recycleList);
    }
  }

  /**
   * adjustAnchorPosition - 调整锚点位置保持滚动稳定
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

  private clearMeasureState(): void {
    this.resetMeasureData();
    this.totalHeight = 0;
    this.startIndex = -1;
    this.endIndex = -1;
  }

  /**
   * areAllColumnsFilled - 检查所有列是否都已填充满可视范围
   *
   * 参数：
   * - columnHeights: 当前各列的高度
   * - viewEnd: 可视区域的底部位置
   *
   * 返回：true 表示所有列都已填充，false 表示还需要继续测量
   */
  private areAllColumnsFilled(viewEnd: number): boolean {
    for (let i = 0; i < this.columns; i++) {
      if (this.columnHeights[i] < viewEnd) {

        return false;
      }
    }
    return true;
  }

  private areAllColumnsTopFilled(viewStart: number): boolean {
    for (let i = 0; i < this.columns; i++) {
      if (this.columnTops[i] > viewStart) {
        return false;
      }
    }
    return true;
  }

  /**
   * measureAllChildren - 测量所有元素（非Lazy场景）
   *
   * 流程：
   * 1. 初始化列高度数组为0
   * 2. 逐个测量元素
   * 3. 将元素分配到最短的列
   * 4. 更新列高度和元素位置
   * 5. 累加totalMeasuredHeight（性能优化）
   */
  private measureAllChildren(self: FrameNode, constraint: LayoutConstraint): void {
    this.resetMeasureData();
    this.itemArrStartIndex = 0;

    let childConstraint = this.createChildConstraint(constraint);

    for (let i = 0; i < this.childCnt; i++) {
      let child = self.getChild(i, ExpandMode.LAZY_NOT_EXPAND);
      if (child) {
        child.measure(childConstraint);
        const itemHeight = child.getMeasuredSize().height;

        // 分配到最短的列
        const column = this.findShortestColumn();

        // 如果该列已经有元素（columnHeights[column] > 0），需要添加行间距
        const startPos = this.columnHeights[column] > 0
          ? this.columnHeights[column] + this.rowGap
          : this.columnHeights[column];
        const endPos = startPos + itemHeight;

        this.itemArr[i] = {
          start: startPos,
          end: endPos,
          column: column,
          height: itemHeight,
        };

        // 更新列高度（下一个元素的起始位置）
        this.columnHeights[column] = endPos;

        // 性能优化：累加totalMeasuredHeight
        this.totalMeasuredHeight += itemHeight;
      }
    }

    this.startIndex = 0;
    this.endIndex = this.childCnt - 1;

    // 计算总高度（所有列的最大高度，已经包含行间距）
    this.totalHeight = Math.max(...this.columnHeights);
  }

  /**
   * measureInViewRange - 测量可视范围内的元素
   *
   * 核心流程：
   * 1. 检查是否有已测量的数据
   * 2. 查找第一个可见元素作为测量起点
   * 3. 向前测量填充视口底部
   * 4. 向后测量填充视口顶部
   * 5. 更新可视范围和总高度估算
   */
  private measureInViewRange(
    self: FrameNode,
    constraint: LayoutConstraint,
    helper: LazyLayoutHelper
  ): void {
    const viewStart = helper.getViewStart();
    const viewEnd = helper.getViewEnd();

    let firstIndex = 0;
    let lastIndex = this.childCnt - 1;
    if (this.itemArr.length > 0) {
      firstIndex = this.findFirstVisibleItemIndex(viewStart, viewEnd);
      lastIndex = this.findLastVisibleItemIndex(viewStart, viewEnd);
    }


    let childConstraint = this.createChildConstraint(constraint);
    if (helper.getLazyLayoutDirection() === LazyLayoutDirection.FORWARD) {
      let measureStartIndex = Math.max(this.startIndex, firstIndex);

      this.measureForwardInViewRange(self, childConstraint, measureStartIndex, lastIndex, viewEnd);
      this.measureBackwardInViewRange(self, childConstraint, measureStartIndex - 1, firstIndex, viewStart);
    } else {
      let measureStartIndex = this.endIndex > 0 ? Math.min(this.endIndex, lastIndex) :  lastIndex;

      this.measureBackwardInViewRange(self, childConstraint, measureStartIndex, firstIndex, viewStart);
      this.measureForwardInViewRange(self, childConstraint, measureStartIndex + 1, lastIndex, viewEnd);
    }


    let adjustedOffset = 0;
    let reMeasured = false;
    if (this.itemArrStartIndex < this.columns && !this.isReachTop()) {
      this.itemArr.length = 0;
      this.itemArrStartIndex = 0;
      this.anchorChildIndex = -1;

      this.measureForwardInViewRange(self, childConstraint, 0, 0, viewEnd);
      reMeasured = true;
    } else if (this.itemArrStartIndex > 0) {

      adjustedOffset = this.updateBackwardHeightEstimate();
    }

    let prevHeight = this.totalHeight;
    this.updateTotalHeightEstimate();
    if (reMeasured && helper.getLazyLayoutDirection() === LazyLayoutDirection.BACKWARD) {

      helper.setAdjustedOffset(this.totalHeight - prevHeight)
    }
    this.calculateVisibleRange(helper, adjustedOffset);
  }

  /**
   * findFirstVisibleItemIndex - 查找第一个可见元素索引
   *
   * 返回：第一个与视口有交集的元素索引，如果无可见元素则返回itemArr末尾索引+1
   */
  private findFirstVisibleItemIndex(viewStart: number, viewEnd: number): number {
    let currIndex = this.itemArr.length + this.itemArrStartIndex;
    for (let i = 0; i < this.itemArr.length; i++) {
      const item = this.itemArr[i];
      if (item.end > viewStart && item.start < viewEnd) {
        currIndex = this.itemArrStartIndex + i;
        break;
      }
      if (item.start > viewEnd) {
        currIndex = this.itemArrStartIndex + i -1;
        break;
      }
    }
    return currIndex;
  }

  /**
   * findLastVisibleItemIndex - 查找最后一个可见元素索引
   *
   * 返回：最后一个与视口有交集的元素索引，如果无可见元素则返回itemArr起始索引-1
   */
  private findLastVisibleItemIndex(viewStart: number, viewEnd: number): number {
    let currIndex = this.itemArrStartIndex - 1;
    for (let i = this.itemArr.length - 1; i >= 0; i--) {
      const item = this.itemArr[i];
      if (item.end > viewStart && item.start < viewEnd) {
        currIndex = this.itemArrStartIndex + i;
        break;
      }
      if (item.end < viewStart) {
        currIndex = this.itemArrStartIndex + i + 1;
        break;
      }
    }
    return currIndex;
  }

  /**
   * measureForwardInViewRange - 向前测量填充视口底部
   *
   * 从measureStartIndex往后测量，直到所有列填充满viewEnd
   * 处理高度变化时清空后续数据并重新测量
   */
  private measureForwardInViewRange(
    self: FrameNode,
    childConstraint: LayoutConstraint,
    measureStartIndex: number,
    lastIndex: number,
    viewEnd: number
  ): void {
    this.FlushColumnHeights();

    for (let i = measureStartIndex; i < this.childCnt; i++) {
      let oldHeight: number | undefined = undefined;
      let arrIndex = i - this.itemArrStartIndex;
      if (arrIndex >= 0 && arrIndex < this.itemArr.length) {
        if (i > lastIndex) {

          break;
        }
        oldHeight = this.itemArr[arrIndex].height;
      }

      const child = self.getChild(i, ExpandMode.LAZY_NOT_EXPAND);
      let itemHeight = 0;
      if (child) {
        child.measure(childConstraint);
        itemHeight = child.getMeasuredSize().height;
      }

      if (oldHeight != undefined) {
        if (itemHeight === oldHeight) {
          continue;
        }
        this.itemArr = this.itemArr.slice(0, arrIndex);
        this.FlushColumnHeights();
      }

      const column = this.findShortestColumn();

      // 如果该列已经有元素，需要添加行间距
      const startPos = this.columnHeights[column] > 0
        ? this.columnHeights[column] + this.rowGap
        : this.columnHeights[column];
      const endPos = startPos + itemHeight;


      this.itemArr.push({
        start: startPos,
        end: endPos,
        column: column,
        height: itemHeight,
      });

      this.columnHeights[column] = endPos;

      if (this.areAllColumnsFilled(viewEnd)) {
        break;
      }
    }
  }

  /**
   * measureBackwardInViewRange - 向后测量填充视口顶部
   *
   * 从startIndex往前测量，直到所有列填充满viewStart
   * 处理高度变化时清空前置数据并重新测量
   */
  private measureBackwardInViewRange(
    self: FrameNode,
    childConstraint: LayoutConstraint,
    startIndex: number,
    firstIndex: number,
    viewStart: number
  ): void {
    this.FlushColumnTops();
    for (let i = startIndex; i >= 0; i--) {
      let oldHeight: number | undefined = undefined;
      let arrIndex = i - this.itemArrStartIndex;

      if (arrIndex >= 0 && arrIndex < this.itemArr.length) {
        if (i < firstIndex) {
          break;
        }
        oldHeight = this.itemArr[arrIndex].height;
      }

      const child = self.getChild(i, ExpandMode.LAZY_NOT_EXPAND);
      let itemHeight = 0;
      if (child) {
        child.measure(childConstraint);
        itemHeight = child.getMeasuredSize().height;
      }

      if (oldHeight != undefined) {
        if (itemHeight === oldHeight) {
          continue;
        }
        this.itemArrStartIndex = i + 1;
        this.itemArr.splice(0, arrIndex + 1);
        this.FlushColumnTops();
      }

      const column = this.findHighestColumn();

      // 如果该列已经有元素（columnTops[column] < totalHeight），需要添加行间距
      const endPos = this.columnTops[column] < this.totalHeight
        ? this.columnTops[column] - this.rowGap
        : this.columnTops[column];
      const startPos = endPos - itemHeight;


      this.itemArr.unshift({
        start: startPos,
        end: endPos,
        column: column,
        height: itemHeight,
      });
      if (this.itemArr.length === 1) {
        this.itemArrStartIndex = i;
      } else {
        this.itemArrStartIndex -= 1;
      }
      this.columnTops[column] = startPos;
      if (this.areAllColumnsTopFilled(viewStart)) {
        break;
      }
    }
  }

  private isReachTop(): boolean {
    for (let i = 0; i < this.columnTops.length; i++) {
      if (this.columnTops[i] !== 0 && this.columnTops[i] !== Number.MAX_SAFE_INTEGER) {
        return false;
      }
    }
    return true;
  }

  /**
   * updateBackwardHeightEstimate - 更新可视区域前未布局的总高度
   *
   * 根据已测量元素计算可视区域前未布局的总高度:
   */
  private updateBackwardHeightEstimate(): number {
    if (this.itemArr.length === 0) {
      return 0;
    }
    let minHeight = Number.MAX_SAFE_INTEGER
    for (let i = 0; i < this.columnTops.length; i++) {
      if (this.columnTops[i] < minHeight) {
        minHeight = this.columnTops[i];
      }
    }
    let layoutHeight = this.calculateLayoutHeight();
    let average = layoutHeight / this.itemArr.length;
    let estimateHeight = average * Math.floor(this.itemArrStartIndex / this.columns);
    if (minHeight < 0 || minHeight < (estimateHeight / 2 - 100) || minHeight > (estimateHeight * 2 + 100)) {
      let delta = estimateHeight - minHeight;
      for (let i = 0; i < this.itemArr.length; i++) {
        this.itemArr[i].start += delta;
        this.itemArr[i].end += delta;
      }
      for (let i = 0; i < this.columns && i < this.childCnt; i++) {
        this.columnTops[i] += delta;
        this.columnHeights[i] += delta;
      }

      return delta;
    }
    return 0;
  }

  /**
   * updateTotalHeightEstimate - 更新总高度估算
   *
   * 根据已测量元素计算总高度：
   * - 如果所有元素都已测量：使用实际测量高度
   * - 如果有未测量元素：基于平均值估算总高度
   */
  private updateTotalHeightEstimate(): void {
    const measuredHeight = Math.max(...this.columnHeights);
    const measuredCount = this.itemArr.length + this.itemArrStartIndex;
    const remainingCount = this.childCnt - measuredCount;

    if (remainingCount === 0) {
      this.totalHeight = measuredHeight;
    } else if (measuredCount > 0) {
      let estimateItemHeight = measuredHeight / measuredCount;
      const estimatedTotalHeight = estimateItemHeight * this.childCnt;
      this.totalHeight = Math.max(measuredHeight, estimatedTotalHeight);
    }
  }

  /**
   * calculateLayoutHeight - 计算已经布局的高度总和
   *
   * 只计算已经测量/布局的子组件高度总和，不包括未布局的子组件
   * - 每一列的高度 = columnHeights[i] - columnTops[i]
   * - 如果 columnTops[i] 为 Number.MAX_SAFE_INTEGER，表示该列没有子组件，高度为 0
   *
   * 返回：所有列已经布局的高度总和
   */
  private calculateLayoutHeight(): number {
    if (this.itemArr.length === 0) {
      return 0;
    }

    let totalHeight = 0;
    for (let i = 0; i < this.columns; i++) {
      // 如果 columnTops[i] 为 Number.MAX_SAFE_INTEGER，表示该列没有子组件
      if (this.columnTops[i] !== Number.MAX_SAFE_INTEGER) {
        const columnHeight = this.columnHeights[i] - this.columnTops[i];
        totalHeight += columnHeight;
      }
    }

    return totalHeight;
  }

  private FlushColumnTops(): void {
    let columns = 0;
    let index = 0;
    this.columnTops = new Array<number>(this.columns).fill(this.totalHeight);
    while (columns < this.columns && index < this.itemArr.length) {
      let itemPos = this.itemArr[index];
      if (itemPos.start < this.columnTops[itemPos.column]) {
        this.columnTops[itemPos.column] = itemPos.start;
        columns++;
      }
      index++;
    }
  }

  private FlushColumnHeights(): void {
    let columns = 0;
    let index = this.itemArr.length - 1;
    this.columnHeights = new Array<number>(this.columns).fill(0);
    while (columns < this.columns && index >= 0) {
      let itemPos = this.itemArr[index];
      if (itemPos.end > this.columnHeights[itemPos.column]) {
        this.columnHeights[itemPos.column] = itemPos.end;
        columns++;
      }
      index--;
    }
  }

  /**
   * resetMeasureData - 重置测量数据（用于重新测量场景）
   *
   * 清空itemArr和相关的累计值
   */
  private resetMeasureData(): void {
    this.itemArr = [];
    this.itemArrStartIndex = -1;
    this.totalMeasuredHeight = 0;
    this.columnHeights = new Array<number>(this.columns).fill(0);
  }

  /**
   * findFirstVisibleIndex - 线性查找第一个在可视范围内的元素索引
   *
   * 修复：恢复线性查找，保证正确性
   * - 瀑布流不同列的元素位置无序，无法使用二分查找
   * - 线性查找虽然O(N)，但能保证找到真正的第一个可见元素
   *
   * 查找条件：第一个满足完整可见性条件的元素
   * 完整条件：(item.end > viewStart) && (item.start < viewEnd)
   */
  private findFirstVisibleIndex(viewStart: number, viewEnd: number): number {
    if (this.itemArr.length === 0) {
      return -1;
    }

    // 线性查找，保证找到第一个满足完整可见性条件的元素
    for (let i = 0; i < this.itemArr.length; i++) {
      const item = this.itemArr[i];
      // 完整的可见性判断：元素与视口有交集
      if (item.end > viewStart && item.start < viewEnd) {
        return this.itemArrStartIndex + i;
      }
    }

    return -1;
  }

  /**
   * findLastVisibleIndex - 线性查找最后一个在可视范围内的元素索引
   *
   * 修复：恢复线性查找，保证正确性
   * - 瀑布流不同列的元素位置无序，无法使用二分查找
   * - 线性查找虽然O(N)，但能保证找到真正的最后一个可见元素
   *
   * 查找条件：最后一个满足完整可见性条件的元素
   * 完整条件：(item.end > viewStart) && (item.start < viewEnd)
   */
  private findLastVisibleIndex(viewStart: number, viewEnd: number): number {
    if (this.itemArr.length === 0) {
      return -1;
    }

    // 线性查找（从后向前），保证找到最后一个满足完整可见性条件的元素
    for (let i = this.itemArr.length - 1; i >= 0; i--) {
      const item = this.itemArr[i];
      // 完整的可见性判断：元素与视口有交集
      if (item.end > viewStart && item.start < viewEnd) {
        return this.itemArrStartIndex + i;
      }
    }

    return -1;
  }

  /**
   * calculateVisibleRange - 根据可视范围计算startIndex/endIndex
   *
   * 修复：恢复线性查找，保证正确性
   * - 瀑布流不同列的元素位置无序，必须使用线性查找
   * - 复杂度从O(logN)恢复到O(N)，但保证正确性
   *
   * startIndex: 第一个在可视范围内的元素索引（完整可见性判断）
   * endIndex: 最后一个在可视范围内的元素索引（完整可见性判断）
   *
   * 完整可见性条件：(item.end > viewStart) && (item.start < viewEnd)
   */
  private calculateVisibleRange(helper: LazyLayoutHelper, adjustedOffset: number): void {
    if (this.itemArr.length === 0) {
      this.startIndex = -1;
      this.endIndex = -1;
      return;
    }

    const viewStart = helper.getViewStart() + adjustedOffset;
    const viewEnd = helper.getViewEnd() + adjustedOffset;

    // 使用线性查找（传入完整的视口范围）
    this.startIndex = this.findFirstVisibleIndex(viewStart, viewEnd);
    this.endIndex = this.findLastVisibleIndex(viewStart, viewEnd);

    // 如果找不到可见元素，说明itemArr都在可视范围外
    if (this.startIndex === -1 || this.endIndex === -1) {
      // 使用测量范围作为默认值
      this.startIndex = this.itemArrStartIndex;
      this.endIndex = this.itemArrStartIndex + this.itemArr.length - 1;
    }
  }

  /**
   * onLayout - 布局可视范围内的元素
   */
  onLayout(self: FrameNode): void {
    if (this.childCnt == 0) {
      return;
    }

    for (let i = this.startIndex; i <= this.endIndex; i++) {
      let child = self.getChild(i, ExpandMode.LAZY_NOT_EXPAND);

      if (child) {
        const arrayIndex = i - this.itemArrStartIndex;

        if (arrayIndex >= 0 && arrayIndex < this.itemArr.length) {
          const item = this.itemArr[arrayIndex];

          // 根据列号计算 x 坐标
          const x = item.column * (this.columnWidth + this.columnGap);
          const y = item.start;

          child.layout({x: x, y: y});
        }
      }
    }
  }
}