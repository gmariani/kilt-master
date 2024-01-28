import scripts.damageManager;
import mx.events.EventDispatcher 

class scripts.Character {

	public var graphic:MovieClip;
	public var dead:Boolean = false;
	public var hitPoints:Number;
	public var movementSpeed:Number = 1;
	public var fightflag:Boolean = false;
	public var moveflag:Boolean = true;
	public var moveLeftflag:Boolean = false;
	public var moveRightflag:Boolean = false;
	public var charType:Number;
	public var hitPointBarOver:MovieClip;
	public var hitPointBarUnder:MovieClip;
	public var attackTimer:Number = 0;
	public var id:Number;
	public var unitType:String;
	private var dm:damageManager;
	private var parent_mc:MovieClip;
	
	function dispatchEvent() {};
 	function addEventListener() {};
 	function removeEventListener() {};	
	
	function init(unitID) {
		mx.events.EventDispatcher.initialize(this);
		
		dm = new damageManager();
		id = unitID;
		
		hitPointBarUnder = graphic.attachMovie("underBar", "underBar" + unitID, 900 + unitID, {_x:-50, _y:-160, _width:100});
		hitPointBarOver = hitPointBarUnder.attachMovie("overBar", "overBar" + unitID, 1500 + unitID, {_width:100});
		graphic.SelectedBox._visible = false;
		graphic.owner = this;	
	}	
	
	public function die() {
		dead = true;
		hitPoints = 0;
		hitPointBarOver._width = 0;
		graphic.gotoAndPlay("die");
		clearInterval(attackTimer);	
		parent_mc.Unit_obj[unitType + "_num"]--;		
		
		var eventObject:Object = {target:this, type:'death'};  
		eventObject.unitID = id;
		dispatchEvent(eventObject);
		
		delete parent_mc.Unit_obj["unit" + id];
	}

	public function walk(dir:String) {
		if (dead == false && fightflag == false && moveflag == true) {
			// If no direction is given, continue in current direction
			if(dir == undefined && moveLeftflag == true) {
				dir = "left";
			} else if(dir == undefined && moveRightflag == true) {
				dir = "right";
			}
			//
			if(dir == "left") {
				movementSpeed = -1;
				moveLeftflag = true;
				moveRightflag = false;
				if(graphic._name.substr(0, 3) == "bad") {
					graphic._xscale = 40;
				} else {
					graphic._xscale = -40;
				}
			} else if(dir == "right") {
				movementSpeed = 1;
				moveLeftflag = false;
				moveRightflag = true;
				
				if(graphic._name.substr(0, 3) == "bad") {
					graphic._xscale = -40;
				} else {
					graphic._xscale = 40;
				}
			}
			moveflag = true;
			if(graphic._currentframe < 40 || graphic._currentframe > 60) {
				graphic.gotoAndPlay("run");
			}
			graphic._x += movementSpeed;
			ceaseFire();
		}
	}
	
	private function attackInterval() {
		//
	}
	
	public function attack() {
		if (dead != true && attackTimer == 0) {			
			stopMove();
			if(unitType == "Infantry") {
				attackInterval();
			}
			attackTimer = setInterval(this, "attackInterval", 3000);
		}
	}
	
	public function stopMove() {
		if (dead != true) {
			//moveRightflag = false;
			//moveLeftflag = false;		
			movementSpeed = 0;
			moveflag = false;
			graphic.gotoAndStop(1);
		}
	}
	
	public function ceaseFire() {
		clearInterval(attackTimer);
		attackTimer = 0;
		fightflag = false;
	}
	
	public function checkHealth() {
		if (hitPoints <= 0 && dead == false) {
			die();
		}
	}
	
	public function checkWall() {
		if (graphic.hitTest(parent_mc.leftWall)) {
			moveLeftflag = false;
			moveRightflag = true;
			movementSpeed = 1;
			graphic._xscale = 40;
		}
	}
}
