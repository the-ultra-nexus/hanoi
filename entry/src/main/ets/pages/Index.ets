import { Disk } from '../engine/hanoi';
import { GameState } from '../engine/gameState';
import { PegView } from '../view/PegView';
import { VictoryOverlay } from '../view/VictoryOverlay';

/**
 * 主页面:编排 GameState 与视图组件,托管 UI 层状态。
 *
 * 职责:
 * - 渲染选盘界面 / 游戏界面
 * - 两步点击交互(selectedPeg, feedback)
 * - 胜利动画触发(cheerScale, cheerAnimating)
 *
 * 设计决策:
 * - GameState 托管所有游戏状态与操作
 * - UI 层只保留交互状态(selectedPeg, feedback)与动画状态(cheerScale, cheerAnimating)
 * - 整体重新赋值模式:每次操作后通过 getter 获取快照并手动刷新 @State
 */
@Entry
@Component
struct Index {
  // ── 游戏状态(GameState 托管) ────────────────────────
  @State private gs: GameState = new GameState(3);
  // 渲染快照:每次状态变化后整体重新赋值
  @State private pegsView: Disk[][] = [[], [], []];
  @State private moveCountView: number = 0;
  @State private minMovesView: number = 0;
  @State private diskCount: number = 3;
  @State private selectingDiskCount: boolean = true;
  // 胜利判定(UI 层观察 GameState.won 后同步)
  @State private won: boolean = false;

  // ── UI 层状态(交互与动画) ─────────────────────────
  @State private selectedPeg: number = -1;
  @State private feedback: string = '';
  @State private cheerScale: number = 1;
  @State private cheerAnimating: boolean = false;

  aboutToAppear(): void {
    this.startNewGame(3);
  }

  // ── 操作 ─────────────────────────────────────────────

  /** 开局:设定盘数,刷新快照 */
  private startNewGame(n: number): void {
    this.gs = new GameState(n);
    this.gs.startGame(n);
    this.diskCount = n;
    this.selectingDiskCount = false;
    this.pegsView = this.gs.pegs;
    this.moveCountView = this.gs.moveCount;
    this.minMovesView = this.gs.minMoves;
    this.selectedPeg = -1;
    this.feedback = '';
    this.won = false;
    this.cheerAnimating = false;
    this.cheerScale = 1;
  }

  /** 重开:回到盘数选择,复位所有状态 */
  private restart(): void {
    this.gs.restart();
    this.selectingDiskCount = true;
    this.won = false;
    this.cheerAnimating = false;
    this.cheerScale = 1;
  }

  /** 两步点击:未选中→选中;点同柱→取消;点他柱→尝试移动 */
  private onPegTap(pegIndex: number): void {
    if (this.selectedPeg === -1) {
      this.selectedPeg = pegIndex;
      return;
    }
    if (this.selectedPeg === pegIndex) {
      this.selectedPeg = -1;
      return;
    }
    let moved: boolean = this.gs.tryMove(this.selectedPeg, pegIndex);
    if (moved) {
      // 合法:局面更新,选择转移到新柱,可连续移动
      this.pegsView = this.gs.pegs;
      this.moveCountView = this.gs.moveCount;
      this.selectedPeg = pegIndex;
      this.feedback = '';
      // 同步胜利判定
      this.won = this.gs.won;
      if (this.won) {
        this.triggerVictory();
      }
    } else {
      // 非法:局面与选择都不变,给出可见反馈
      this.feedback = '不合法的移动:只能移顶盘,且大盘不能压小盘';
      setTimeout(() => {
        this.feedback = '';
      }, 1500);
    }
  }

  /** 胜利触发:面板经属性动画弹入,🎉 用显式 animateTo 无限往复缩放 */
  private triggerVictory(): void {
    this.won = true;
    if (!this.cheerAnimating) {
      this.cheerAnimating = true;
      animateTo({
        duration: 500,
        curve: Curve.EaseInOut,
        iterations: -1,
        playMode: PlayMode.Alternate
      }, () => {
        this.cheerScale = 1.4;
      });
    }
  }

  // ── 渲染 ─────────────────────────────────────────────

  build() {
    Column() {
      if (this.selectingDiskCount) {
        this.SelectionScreen()
      } else {
        Stack() {
          this.GameScreen()
          VictoryOverlay({
            won: this.won,
            moveCount: this.moveCountView,
            minMoves: this.minMovesView,
            cheerScale: this.cheerScale,
            onRestart: () => this.restart()
          })
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F1E8')
  }

  /** 盘数选择界面:3–8 六个按钮 */
  @Builder SelectionScreen() {
    Column({ space: 20 }) {
      Text('汉诺塔')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40 })

      Text('选择圆盘数量')
        .fontSize(16)
        .fontColor('#666666')

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        ForEach([3, 4, 5, 6, 7, 8], (n: number) => {
          Button(`${n}`)
            .type(ButtonType.Normal)
            .width(64)
            .height(64)
            .borderRadius(32)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .backgroundColor('#5D4037')
            .fontColor('#FFFFFF')
            .margin(8)
            .onClick(() => this.startNewGame(n))
        }, (n: number) => `btn-${n}`)
      }
      .width('80%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  /** 游戏界面:棋面 + 重开按钮 + 反馈 */
  @Builder GameScreen() {
    Column({ space: 12 }) {
      // 顶部栏:标题 + 重开按钮
      Row() {
        Text('汉诺塔')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Blank()

        Button('重新开始')
          .type(ButtonType.Normal)
          .fontSize(14)
          .height(36)
          .backgroundColor('#8D6E63')
          .fontColor('#FFFFFF')
          .borderRadius(18)
          .onClick(() => this.restart())
      }
      .width('92%')
      .padding({ top: 12 })

      Text(`盘数: ${this.diskCount}`)
        .fontSize(14)
        .fontColor('#666666')

      // 棋面:三根柱
      Row({ space: 10 }) {
        PegView({ disks: this.pegsView[0], selected: this.selectedPeg === 0 })
          .onClick(() => this.onPegTap(0))
        PegView({ disks: this.pegsView[1], selected: this.selectedPeg === 1 })
          .onClick(() => this.onPegTap(1))
        PegView({ disks: this.pegsView[2], selected: this.selectedPeg === 2 })
          .onClick(() => this.onPegTap(2))
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Bottom)

      // 步数行
      Row({ space: 16 }) {
        Text(`步数 ${this.moveCountView}`)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
        Text(`最少步数 ${this.minMovesView}`)
          .fontSize(16)
          .fontColor('#8D6E63')
      }

      // 反馈行:固定高度避免布局跳动
      Text(this.feedback)
        .fontSize(14)
        .fontColor('#C62828')
        .height(24)
        .margin({ bottom: 12 })
    }
    .width('100%')
    .height('100%')
  }
}
