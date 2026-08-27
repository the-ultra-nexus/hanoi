import { describe, it, expect } from '@ohos/hypium';
import { GameState } from '../main/ets/engine/gameState';

export default function localUnitTest() {
  describe('gameState', () => {
    it('开局后处于盘数选择界面', 0, () => {
      let gs = new GameState(3);
      expect(gs.selectingDiskCount).assertTrue();
    });

    it('开始游戏后退出选择界面', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      expect(gs.selectingDiskCount).assertFalse();
    });

    it('开始游戏后盘数正确', 0, () => {
      let gs = new GameState(5);
      gs.startGame(5);
      expect(gs.diskCount).assertEqual(5);
    });

    it('开始游戏后局面快照正确', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      let pegs = gs.pegs;
      expect(pegs.length).assertEqual(3);
      expect(pegs[0].map(disk => disk.size).join(',')).assertEqual('3,2,1');
      expect(pegs[1].length).assertEqual(0);
      expect(pegs[2].length).assertEqual(0);
    });

    it('开始游戏后步数为零', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      expect(gs.moveCount).assertEqual(0);
    });

    it('开始游戏后最少步数正确', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      expect(gs.minMoves).assertEqual(7);
    });

    it('开始游戏后未胜利', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      expect(gs.won).assertFalse();
    });

    it('合法移动后局面更新', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      let moved = gs.tryMove(0, 1);
      expect(moved).assertTrue();
      let pegs = gs.pegs;
      expect(pegs[0].map(disk => disk.size).join(',')).assertEqual('3,2');
      expect(pegs[1].map(disk => disk.size).join(',')).assertEqual('1');
    });

    it('合法移动后步数递增', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      gs.tryMove(0, 1);
      expect(gs.moveCount).assertEqual(1);
      gs.tryMove(0, 2);
      expect(gs.moveCount).assertEqual(2);
    });

    it('非法移动返回 false', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      // 大压小
      gs.tryMove(0, 1);
      let moved = gs.tryMove(0, 1);
      expect(moved).assertFalse();
    });

    it('非法移动不改变局面', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      gs.tryMove(0, 1);  // 合法
      gs.tryMove(0, 1);  // 非法
      expect(gs.moveCount).assertEqual(1);
      let pegs = gs.pegs;
      expect(pegs[0].map(disk => disk.size).join(',')).assertEqual('3,2');
      expect(pegs[1].map(disk => disk.size).join(',')).assertEqual('1');
    });

    it('重开后回到选择界面', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      gs.restart();
      expect(gs.selectingDiskCount).assertTrue();
    });

    it('重开后步数归零', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      gs.tryMove(0, 1);
      gs.tryMove(0, 2);
      gs.restart();
      expect(gs.moveCount).assertEqual(0);
    });

    it('重开后局面重置', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      gs.tryMove(0, 1);
      gs.restart();
      gs.startGame(3);
      let pegs = gs.pegs;
      expect(pegs[0].map(disk => disk.size).join(',')).assertEqual('3,2,1');
      expect(pegs[1].length).assertEqual(0);
      expect(pegs[2].length).assertEqual(0);
    });

    it('重开后未胜利', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      gs.tryMove(0, 1);
      gs.restart();
      expect(gs.won).assertFalse();
    });

    it('全部圆盘到齐目标柱时胜利', 0, () => {
      let gs = new GameState(3);
      gs.startGame(3);
      expect(gs.won).assertFalse();
      // 最优解:0→2, 0→1, 2→1, 0→2, 1→0, 1→2, 0→2
      let solution = [[0, 2], [0, 1], [2, 1], [0, 2], [1, 0], [1, 2], [0, 2]];
      for (let i = 0; i < solution.length - 1; i++) {
        expect(gs.tryMove(solution[i][0], solution[i][1])).assertTrue();
        expect(gs.won).assertFalse();
      }
      expect(gs.tryMove(0, 2)).assertTrue();
      expect(gs.won).assertTrue();
      expect(gs.moveCount).assertEqual(7);
    });

    it('不同盘数开局均正确', 0, () => {
      for (let n = 3; n <= 8; n++) {
        let gs = new GameState(n);
        gs.startGame(n);
        expect(gs.diskCount).assertEqual(n);
        expect(gs.pegs[0].length).assertEqual(n);
        expect(gs.minMoves).assertEqual(Math.pow(2, n) - 1);
      }
    });
  });
}
