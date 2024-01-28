class scripts.Infantry extends scripts.Character {

	public var enemy;
	public var isRaisingFlag = false;
	public var unitType:String = "Infantry";
	
	function Infantry(bg, unitID, scope) {
		parent_mc = scope;
		hitPoints = 100;
		charType = 1;
		moveRightflag = true;
		graphic = bg.attachMovie("guy", "man" + unitID, 26 + unitID, {_xscale:40, _yscale:40});
		super.init(unitID);
	}
	
	public function attackInterval() {
		dm.computeDamage(this, enemy);
		graphic.gotoAndPlay("fight");
	}
	
	public function checkAction() {
		if (isRaisingFlag == true) {
			// Stand
		} else if (isRaisingFlag == true && fightflag == true) {
			hitPoints = 0;
		} else if (fightflag == false) {
			walk();
		} else if (fightflag == true) {
			attack();
		}
	}
	
	public function isEnemyDead() {
		if(enemy.dead == true) {
			enemy = null;
			fightflag = false;
			moveflag = true;
		}
	}
	
	public function checkCastle() {
		if (graphic.hitTest(parent_mc.bg.enemyCastle)) {
			stopAllSounds();
			parent_mc.displayHitPoints.text = "";
			parent_mc.displayUnitInfo.text = "";
			parent_mc.displayResource.text = "";
			parent_mc.winLose.gotoAndPlay(2);
			parent_mc.isGameOver = true;
		}
	}
	
	public function checkCollision(curEnemy) {
		if ((curEnemy.unitType == "BadGuy" || curEnemy.unitType == "BadArcher") && graphic.hitTest(curEnemy.graphic) && curEnemy.dead != true) {
			fightflag = true;
			moveflag = false;
			curEnemy.fightflag = true;
			enemy = curEnemy;
			curEnemy.enemy = this;
		}
	}

}
