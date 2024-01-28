class scripts.badArcher extends scripts.Character {

	public var Arrow:MovieClip;
	public var unitType:String = "BadArcher";
	
	function badArcher(bg, unitID, scope)	{
		parent_mc = scope;
		hitPoints = 100;
		charType = 4;
		fightflag = true;
		movementSpeed = 0;	
		graphic = bg.attachMovie("badArcher", "badArch" + unitID, 100 + unitID, {_xscale:40, _yscale:40});
		super.init(unitID);
		//
		Arrow = bg.attachMovie("arrow", "Badarrow" + unitID, 600 + unitID, {_y:800, _xscale:100});
	}
	
	private function attackInterval() {

		Arrow._x = graphic._x;
		Arrow._y = graphic._y;
		//
		stopMove();
		graphic.gotoAndPlay("fight");
		//
		Arrow.gotoAndPlay(33);
	}
		
	public function checkArrow(curEnemy) {
		if((curEnemy.unitType == "Archer" || curEnemy.unitType == "Infantry") && Arrow.hitTest(curEnemy.graphic)) {
			Arrow._y = 800;
			parent_mc.dm.ArrowDamage(curEnemy);
			parent_mc.sm.playSound(parent_mc.ouch);
		}
	}
	
	public function checkCollision(curEnemy) {
		if (curEnemy.unitType == "Infantry" && graphic.hitTest(curEnemy.graphic) && dead == false) {
			trace("BadArcher instant killed");
			hitPoints = 0;
		}
	}
	
}	
