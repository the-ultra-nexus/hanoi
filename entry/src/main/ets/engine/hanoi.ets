/**
 * 规则引擎 —— 汉诺塔游戏逻辑的纯 ArkTS 承载处(无任何 UI 依赖)。
 *
 * 状态模型:pegs 为三根柱,每根柱是从柱底到柱顶的圆盘数组;
 * 移动 = 源柱 pop、目标柱 push,合法移动只需比较两柱顶盘大小。
 */
export class Disk {
  public readonly size: number;

  constructor(size: number) {
    this.size = size;
  }
}

export class TowerOfHanoi {
  private readonly pegsAll: Disk[][];
  private moveCountValue: number = 0;

  constructor(diskCount: number) {
    this.pegsAll = [[], [], []];
    // 圆盘按大小堆叠:柱底最大(size = diskCount),柱顶最小(size = 1)
    for (let size = diskCount; size >= 1; size--) {
      this.pegsAll[0].push(new Disk(size));
    }
  }

  get pegs(): Disk[][] {
    return this.pegsAll.map(peg => peg.slice());
  }

  /** 尝试一次移动;合法则生效并返回 true,非法则不动局面并返回 false */
  tryMove(fromPeg: number, toPeg: number): boolean {
    if (fromPeg === toPeg) {
      return false;
    }
    let source = this.pegsAll[fromPeg];
    let target = this.pegsAll[toPeg];
    if (source.length === 0) {
      return false; // 空柱取盘
    }
    let disk = source[source.length - 1];
    if (target.length > 0 && target[target.length - 1].size < disk.size) {
      return false; // 大压小
    }
    source.pop();
    target.push(disk);
    this.moveCountValue++;
    return true;
  }

  get moveCount(): number {
    return this.moveCountValue;
  }

  /** 开局时的盘数(3–8) */
  get diskCount(): number {
    return this.pegsAll[0].length + this.pegsAll[1].length + this.pegsAll[2].length;
  }

  /** 胜利:全部圆盘按序到齐目标柱(柱 2) */
  get isWon(): boolean {
    return this.pegsAll[2].length === this.diskCount;
  }

  /** 当前盘数下的理论最少步数(2^n - 1) */
  get minMoves(): number {
    let count = 1;
    for (let i = 1; i < this.diskCount; i++) {
      count = count * 2 + 1;
    }
    return count;
  }
}
