class scripts.Tower {

	//public var takeTimer = 0;
	public var owned = false;
	public var goodFlagHeight = 800;
	public var badFlagHeight = -40;
	public var flagRaiser = 0;
	public var graphic;
	public var goodFlag;
	public var badFlag;
	
	function Tower(bg, towerNum, xpos) {
		graphic = bg.attachMovie("tower", "tower"+towerNum, 11+towerNum, {_x:xpos, _y:(Stage.height/2 + 50)});
		goodFlag = graphic.attachMovie("flag", "goodFlag"+towerNum, 14+towerNum, {_x:40, _y:800, _xscale:40, _yscale:40});
		badFlag = graphic.attachMovie("flag", "badFlag"+towerNum, 17+towerNum, {_x:40, _y:-40, _xscale:40, _yscale:40});
		goodFlag.cacheAsBitmap = true;
		badFlag.cacheAsBitmap = true;
		badFlag.gotoAndStop(2);
		graphic.cacheAsBitmap = true;
	}
	
	public function RaiseFlag(Raiser) {
		flagRaiser = Raiser;
	}
}