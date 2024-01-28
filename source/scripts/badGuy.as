class scripts.badGuy extends scripts.Character {

	public var enemy;
	public var attackedFlag;
	public var isRaisingFlag = false;
	public var unitType:String = "BadGuy";
	
	function badGuy(bg, unitID, scope) {
		parent_mc = scope;
		hitPoints = 100;
		charType = 3;
		movementSpeed = -1;
		moveLeftflag = true;
		graphic = bg.attachMovie("BadGuy", "badGuy" + unitID, 100 + unitID, {_xscale:40, _yscale:40});
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
	
	public function checkCastle() {
		if (graphic.hitTest(parent_mc.bg.castle)) {
			stopAllSounds();
			parent_mc.displayHitPoints.text = "";
			parent_mc.displayUnitInfo.text = "";
			parent_mc.displayResource.text = "";
			parent_mc.winLose.gotoAndPlay(42);
			parent_mc.isGameOver = true;
		}
	}
	
	public function isEnemyDead() {
		if(enemy.dead == true) {
			enemy = null;
			fightflag = false;
			moveflag = true;
		}
	}
	
	public function checkCollision(curEnemy) {
		//
	}
}