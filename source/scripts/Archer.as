class scripts.Archer extends scripts.Character {

	public var Arrow:MovieClip;
	public var unitType:String = "Archer";
		
	function Archer(bg, unitID, scope)	{
		parent_mc = scope;
		hitPoints = 100;
		charType = 2;
		moveRightflag = true;
		graphic = bg.attachMovie("archer", "man" + unitID, 26 + unitID, {_xscale:40, _yscale:40});
		super.init(unitID);
		//
		Arrow = bg.attachMovie("arrow", "arrow" + unitID, 400 + unitID);
		Arrow._y = 800;
		Arrow._xscale = 100;		
	}
	
	private function attackInterval() {		
		Arrow._x = graphic._x;
		Arrow._y = graphic._y;
		Arrow._xscale = -100;
		//
		stopMove();
		graphic.gotoAndPlay("fight");
		//
		if (graphic._xscale > 0){
			Arrow.gotoAndPlay(33);
		} else{
			Arrow.gotoAndPlay(1);
		}
	}
	
	public function checkAction() {
		walk();
	}
	
	public function checkArrow(curEnemy) {
		if((curEnemy.unitType == "BadArcher" || curEnemy.unitType == "BadGuy") && Arrow.hitTest(curEnemy.graphic)) {
			Arrow._y = 800;
			parent_mc.dm.ArrowDamage(curEnemy);
			parent_mc.sm.playSound(parent_mc.ouch);
		}
	}
	
	public function checkCollision(curEnemy) {
		if (curEnemy.unitType == "BadGuy" && graphic.hitTest(curEnemy.graphic) && dead == false) {
			trace("Archer instant killed");
			hitPoints = 0;
		}
	}
}	