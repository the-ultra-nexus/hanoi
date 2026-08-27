import { Disk, TowerOfHanoi } from './hanoi';

/**
 * 游戏状态管理模块 —— 托管汉诺塔游戏的所有状态与操作。
 *
 * 职责:盘数选择、局面快照、步数统计、胜利判定、重开逻辑。
 * 无任何 UI 依赖(不导入 @kit.ArkUI),可通过 getter 供 UI 层观察。
 *
 * 设计决策:
 * - 整体重新赋值模式:UI 层调用操作后,通过 getter 获取快照并手动刷新 @State
 * - 胜利判定在引擎层完成,动画触发留给 UI 层
 */
export class GameState {
  private readonly engine: TowerOfHanoi;
  private readonly diskCountValue: number;
  private isSelectingDiskCountValue: boolean = true;

  constructor(diskCount: number) {
    this.diskCountValue = diskCount;
    this.engine = new TowerOfHanoi(diskCount);
  }

  // ── 只读快照 ──────────────────────────────────────────

  /** 三根柱的圆盘布局(柱底→柱顶顺序) */
  get pegs(): Disk[][] {
    return this.engine.pegs;
  }

  /** 当前步数 */
  get moveCount(): number {
    return this.engine.moveCount;
  }

  /** 当前盘数下的理论最少步数(2^n - 1) */
  get minMoves(): number {
    return this.engine.minMoves;
  }

  /** 本局盘数 */
  get diskCount(): number {
    return this.diskCountValue;
  }

  /** 是否处于盘数选择界面 */
  get selectingDiskCount(): boolean {
    return this.isSelectingDiskCountValue;
  }

  /** 全部圆盘按序到齐目标柱 */
  get won(): boolean {
    return this.engine.isWon;
  }

  // ── 操作 ─────────────────────────────────────────────

  /** 开局:设定盘数,进入游戏界面 */
  public startGame(n: number): void {
    this.isSelectingDiskCountValue = false;
  }

  /** 尝试一次移动;合法则生效并返回 true,非法则不动局面并返回 false */
  public tryMove(fromPeg: number, toPeg: number): boolean {
    return this.engine.tryMove(fromPeg, toPeg);
  }

  /** 重开:回到盘数选择界面,重建引擎 */
  public restart(): void {
    this.isSelectingDiskCountValue = true;
  }
}
