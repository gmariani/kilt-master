import scripts.Infantry;
import scripts.badGuy;
import scripts.Archer;
import scripts.badArcher;
import scripts.damageManager;
import scripts.Tower;
import scripts.cv_SoundManager;
import mx.transitions.Tween;
import mx.transitions.easing.*;
//TODO Enemy fights phantom units, fightflag error (not sure if this still exists)
///////////////
// Variables //
///////////////
var unitID:Number = 1;
var isGameOver:Boolean = false;
var unitListener:Object = new Object; 
var Unit_obj:Object = new Object();
	Unit_obj.Infantry_num = 0;
	Unit_obj.Archer_num = 0;
	Unit_obj.BadGuy_num = 0;
	Unit_obj.BadArcher_num = 0;
var towers:Array = new Array();
this.attachMovie("bg", "bg", 1, {_x:610, _y:140, _xscale:50, _yscale:50});
var waveTimer:Number;
var changeWaveCounter:Number = 0;
var MAXWAVECOUNTER:Number = 5;
var numGuysInWave:Number = 2;
var UIState:Number = -1;
var totalNum:Number = 0;
var totalEnemy:Number = 0;
var resources:Number = 200;
var resourceTimer:Number;
var maxMen:Number = 3;
var keyListener:Object = new Object();
var selectedUnit;
var towersOwned = 1;
selectedUnit.hitPoints = 0;
dm = new damageManager();
def_fmt = new TextFormat();
	def_fmt.align = "right";
	def_fmt.color = 0x0000CC;
	def_fmt.size = 20;
	def_fmt.bold = true;
	def_fmt.font = "_sans";
def2_fmt = new TextFormat();
	def2_fmt.align = "left";
	def2_fmt.color = 0x000000;
	def2_fmt.size = 20;
	def2_fmt.bold = true;
	def2_fmt.font = "_sans";
////////////
// Sounds //
////////////
sm = new cv_SoundManager(this);
BGM = sm.addSound("BGM");
ouch = sm.addSound("ouch");
enough = sm.addSound("enough");
flagRaise = sm.addSound("flagRaise");
BGflagLower = sm.addSound("BGflagLower");
BGflagRaise = sm.addSound("BGflagRaise");
BGflagUP = sm.addSound("BGflagUP");
build = sm.addSound("build");
UR2 = sm.addSound("UR2");
UR3 = sm.addSound("UR3");
needMore = sm.addSound("needMore");
//
sm.playSound(BGM);
///////////////
// InitWorld //
///////////////
initWorld();

function initWorld() {
	// Generate UI
	this.attachMovie("UIBG", "UIBG", 2, {_y:325, _alpha:50});
	this.attachMovie("UICastle", "UICastle", 24, {_x:250, _y:370, _xscale:20, _yscale:20});
	this.attachMovie("UIRaiseFlag", "UIFlag", 6, {_x:150.3, _y:430, _width:55.5, _height:49.5});
		UIFlag.cacheAsBitmap = true;
	this.attachMovie("UIShoot", "UIShoot", 7, {_x:150.3, _y:430, _rotation:125});
		UIShoot._width = 39.8;
		UIShoot._height = 51;
	this.attachMovie("UIStop", "UIStop", 3, {_x:50, _y:430, _width:41.5, _height:48.7});
	this.attachMovie("UICreateInf", "UICreateInf", 4, {_x:50, _y:430, _width:33, _height:42});
		UICreateInf.cacheAsBitmap = true;
	this.attachMovie("UICreateArch", "UICreateArch", 5, {_x:150, _y:430, _width:38, _height:42});
		UICreateArch.cacheAsBitmap = true;
	// Text Format //
	this.createTextField("uiDisplay_1_data", 90, 435, 330, 80, 20);
	this.createTextField("uiDisplay_2_data", 91, 435, 350, 80, 20);
	this.createTextField("uiDisplay_3_data", 92, 435, 370, 80, 20);
	//
	this.createTextField("uiDisplay_1", 93, 355,330, 80, 20).text = "Units:";
	this.createTextField("uiDisplay_2", 94, 355,350, 80, 20).text = "Resources:";
	this.createTextField("uiDisplay_3", 95, 355,370, 80, 20).text = "HP:";
	//
	for(var i = 1; i <= 3; i++) {
		this["uiDisplay_" + i].autoSize = "right";
		this["uiDisplay_" + i].selectable = false;
		this["uiDisplay_" + i].setTextFormat(def_fmt);
		//
		this["uiDisplay_" + i + "_data"].autoSize = "left";
		this["uiDisplay_" + i + "_data"].selectable = false;
		this["uiDisplay_" + i + "_data"].setTextFormat(def2_fmt);
	}
	//
	bg.attachMovie("bridge", "bridge", 3000, {_xscale:110, _x:1330, _y:Stage.height/2 + 168});
	bg.attachMovie("castle", "castle", 8, {_x:-778 , _y:203});
	bg.attachMovie("castle", "enemyCastle", 20, {_x:3875, _y:203});
	bg.enemyCastle.gotoAndStop(2);
	bg.enemyCastle._xscale *= -1;
	bg.castle.cacheAsBitmap = true;
	bg.enemyCastle.cacheAsBitmap = true;
	leftWall = bg.attachMovie("Wall", "wall", 10, {_x:-919, _y:220});
	this.attachMovie("winOrLose", "winLose", 25, {_x:275, _y:200});
	//
	UICreateArch.onRelease = function() {
		createUnit("archer");
	};
	UICreateInf.onRelease = function() {
		createUnit("infantry");
	};
	UIShoot.onRelease = function() {
		selectedUnit.attack();
	};
	UIStop.onRelease = function() {
		selectedUnit.stopMove();
		trace(maxMen);
	};
	UIFlag.onRelease = function() {
		for (i=0; i<=2; i++) {
			if (selectedUnit.graphic.hitTest(towers[i].graphic)) {
				if (towers[i].owned == false) {
					trace("Taking Tower");
					selectedUnit.stopMove();
					sm.playSound(flagRaise);
					towersOwned++;
					trace("The number of towers = "+towersOwned);
					maxMen = towersOwned+2;
					towers[i].owned = true;
					towers[i].RaiseFlag(selectedUnit);
					selectedUnit.isRaisingFlag = true;
				} else {
					trace("You already own this tower");
				}
			} else {
				trace("You are not in range of a tower");
			}
		}
	};
	bg.castle.onRelease = UICastle.onRelease = function () {
		if (UIState != 0) {
			UIState = changeUIState(0, UIState);
		}
	};
	// Create towers
	towers[0] = new Tower(bg, 0, 340);
	towers[1] = new Tower(bg, 1, 1250);
	towers[2] = new Tower(bg, 2, 2800);
	//To create bad guys (set X vaule)
	//phase 1
	//createBadGuy(1000);
	// 280
	//phase 2
	//createBadGuy(700);
	//createBadGuy(200);
	//phase 3
	//createBadGuy(1700);
	//createBadGuy(1775);
	createBadGuy(1400);
	//phase 4
	//createBadGuy(2800);
	//createBadGuy(2875);
	//phase 5
	//createBadGuy(3800);
	//createBadGuy(3875);
	//createBadGuy(3950);
	//phase 6
	//createBadGuy(5000);
	//createBadGuy(5075);
	//Archers
	createBadArcher(50);
	//createBadArcher(800);
	createBadArcher(1000);
	createBadArcher(1450);
	//createBadArcher(2875);
	createBadArcher(2950);
	//createBadArcher(2850);
	//createBadArcher(3800);
	createBadArcher(3850);
	createBadArcher(3950);
}
// Change UI State
function changeUIState(newState, oldState):Number {
	// Down
	switch (oldState) {
	case 0 :
		new Tween(UICreateInf, "_y", Elastic.easeOut, UICreateInf._y, 430, 1, true);
		new Tween(UICreateArch, "_y", Elastic.easeOut, UICreateArch._y, 430, 1, true);
		break;
	case 1 :
		new Tween(UIFlag, "_y", Elastic.easeOut, UIFlag._y, 430, 1, true);
		new Tween(UIStop, "_y", Elastic.easeOut, UIStop._y, 430, 1, true);
		break;
	case 2 :
		new Tween(UIShoot, "_y", Elastic.easeOut, UIShoot._y, 430, 1, true);
		new Tween(UIStop, "_y", Elastic.easeOut, UIStop._y, 430, 1, true);
		break;
	}
	// Up
	switch (newState) {
	case 0 :
		//Tween(obj, prop, func, begin, finish, duration, useSeconds)
		new Tween(UICreateInf, "_y", Elastic.easeOut, UICreateInf._y, 360, 1, true);
		new Tween(UICreateArch, "_y", Elastic.easeOut, UICreateArch._y, 360, 1, true);
		break;
	case 1 :
		new Tween(UIFlag, "_y", Elastic.easeOut, UIFlag._y, 360, 1, true);
		new Tween(UIStop, "_y", Elastic.easeOut, UIStop._y, 360, 1, true);
		break;
	case 2 :
		new Tween(UIShoot, "_y", Elastic.easeOut, UIShoot._y, 360, 1, true);
		new Tween(UIStop, "_y", Elastic.easeOut, UIStop._y, 360, 1, true);
		break;
	}
	return newState;
}
// Increment Resources
resourceInterval = function() {
	resources += 1*towersOwned;
}
resourceTimer = setInterval(this, "resourceInterval", 2200);
// Send Waves
waveInterval = function() {
	for (var i=0; i<numGuysInWave; i++) {
		createBadGuy(3800+75*i);
	}
	changeWaveCounter++;
	if (changeWaveCounter == MAXWAVECOUNTER) {
		changeWaveCounter = 0;
		numGuysInWave++;
	}
}
waveTimer = setInterval(this, "waveInterval", 35000);

// Unit Listener
unitListener.death = function(evtObj) {
	trace(evtObj.unitID + " died");
}
// onEnterFrame
function onEnterFrame(Void):Void {
	if (!isGameOver) {
		if (selectedUnit.hitPoints == undefined) {
			uiDisplay_3_data.text = "0";
		} else {
			uiDisplay_3_data.text = selectedUnit.hitPoints;
		}
		//
		totalNum = Unit_obj.Infantry_num + Unit_obj.Archer_num;
		uiDisplay_1_data.text = totalNum + " / "+maxMen;
		uiDisplay_2_data.text = resources;
		//
		uiDisplay_1_data.setTextFormat(def2_fmt);
		uiDisplay_2_data.setTextFormat(def2_fmt);
		uiDisplay_3_data.setTextFormat(def2_fmt);
		// Check Units
		for(var i in Unit_obj) {
			var curUnit = Unit_obj[i];
			if(typeof(curUnit) != "number") {
				curUnit.checkHealth();				
				curUnit.checkWall();
				curUnit.checkAction();
				
				if(curUnit.unitType == "Infantry" || curUnit.unitType == "BadGuy") {
					curUnit.checkCastle();
					curUnit.isEnemyDead();
				}
				
				for(var j in Unit_obj) {
					var curEnemy = Unit_obj[j];
					if(typeof(curEnemy) != "number") {
						// If good guys, skip checking against good guys
						if((curUnit.unitType == "Infantry" || curUnit.unitType == "Archer") && (curEnemy.unitType == "BadGuy" || curEnemy.unitType == "BadArcher")) {
							curUnit.checkCollision(curEnemy);
							if(curUnit.unitType == "Archer") {
								curUnit.checkArrow(curEnemy);
							}
						}
						// If bad guys, skip checking against bad guys
						if((curUnit.unitType == "BadGuy" || curUnit.unitType == "BadArcher") && (curEnemy.unitType == "Infantry" || curEnemy.unitType == "Archer")) {
							curUnit.checkCollision(curEnemy);
							if(curUnit.unitType == "BadArcher") {
								curUnit.checkArrow(curEnemy);
							}
						}						
					}
				}
			}
		}
		// Check Towers
		for (var k in towers) {
			var curTower = towers[k];
			curTower.badFlag._y = curTower.badFlagHeight;
			curTower.goodFlag._y = curTower.goodFlagHeight;
			if (curTower.owned == true) {
				// If tower is already owned
				if (curTower.goodFlagHeight == -40) {
					curTower.flagRaiser.isRaisingFlag = false;
					curTower.flagRaiser = 0;
				}
				if (curTower.badFlagHeight<40) {
					curTower.badFlagHeight++;
				} else if (curTower.badFlagHeight == 40) {
					curTower.badFlagHeight = curTower.goodFlagHeight;
					curTower.goodFlagHeight = 40;
				} else if (curTower.goodFlagHeight>-40) {
					curTower.goodFlagHeight--;
				}
			} else {
				// If tower if open game
				if (curTower.badFlagHeight == -40) {
					curTower.flagRaiser.isRaisingFlag = false;
					curTower.flagRaiser = 0;
				}
				if (curTower.goodFlagHeight<40) {
					curTower.goodFlagHeight++;
				} else if (curTower.goodFlagHeight == 40) {
					curTower.goodFlagHeight = curTower.badFlagHeight;
					curTower.badFlagHeight = 40;
				} else if (curTower.badFlagHeight>-40) {
					curTower.badFlagHeight--;
				}
			}
			// If tower's flagraiser is dead
			if (curTower.flagRaiser.hitPoints == 0) {
				curTower.flagRaiser = 0;
				sm.playSound(BGflagLower);
			}
			//Check for Computer FlagRaisers
			for (var i in Unit_obj) {
				var curUnit = Unit_obj[i];
				if(typeof(curUnit) != "number" && curUnit.unitType == "BadGuy" && curInf.graphic.hitTest(curTower.graphic) && curTower.flagRaiser == 0 && curTower.owned == true) {
					// Badguys will either take the tower or kill unit then take tower
					trace("BadGuy taking tower");
					curTower.owned = false;
					towersOwned--;
					trace("The number of towers = "+towersOwned);
					maxMen = towersOwned+2;
					curTower.flagRaiser = curUnit;
					curUnit.isRaisingFlag = true;
					sm.playSound(BGflagRaise);
				}
			}
		}
		// Scroll L/R
		if (_xmouse<20 && bg._x<610) {
			bg._x += 5;
		}
		if (_xmouse>520 && bg._x>-1500) {
			bg._x -= 5;
		}
		updateAfterEvent();
	}
}
//////////////////
// Key Listener //
//////////////////
keyListener.onKeyDown = function() {
	if (Key.isDown(Key.LEFT)) {
		selectedUnit.moveflag = true;
		if (selectedUnit.charType == 2) {
			selectedUnit.ceaseFire();
		}
		if (!selectedUnit.moveLeftflag) {
			selectedUnit.walk("left");
		}
	} else if (Key.isDown(Key.RIGHT)) {
		selectedUnit.moveflag = true;
		if (selectedUnit.charType == 2) {
			selectedUnit.ceaseFire();
		}
		if (!selectedUnit.moveRightflag) {
			selectedUnit.walk("right");
		}
	} else if (Key.isDown(Key.DOWN)) {
		selectedUnit.stopMove();
	}
};
Key.addListener(keyListener);
//
/////////////////////////////////////////////////////////////////////////////////////// createUnits
//
/////////////////
// Create Unit //
/////////////////
function createUnit(type:String) {
	if (totalNum<maxMen) {
		var newUnit;
		if (resources>=50) {
			resources -= 50;
			sm.playSound(build);
			if (type == "archer") {
				newUnit = Unit_obj["unit" + unitID] = new Archer(bg, unitID, this);
				Unit_obj.Archer_num++;
				sm.playSound(UR3);
			} else if (type == "infantry") {
				newUnit = Unit_obj["unit" + unitID] = new Infantry(bg, unitID, this);
				Unit_obj.Infantry_num++;
				sm.playSound(UR2);
			}
			newUnit.graphic.onPress = function() {
				selectedUnit.graphic.SelectedBox._visible = false;
				selectedUnit = this.owner;
				selectedUnit.graphic.SelectedBox._visible = true;
				switch(selectedUnit.charType) {
				case 1:
					if (UIState != 1) {
						UIState = changeUIState(1, UIState);
					}
					break;
				case 2:
					if (UIState != 2) {
						UIState = changeUIState(2, UIState);
					}
					break;
				}
			};
			newUnit.graphic._x = 129-934;
			newUnit.graphic._y = 315;
			newUnit.walk("right");
			newUnit.addEventListener("death",unitListener);
			unitID++;
			totalNum = Unit_obj.Infantry_num + Unit_obj.Archer_num;
		} else {
			sm.playSound(needMore);
		}
	} else {
		sm.playSound(enough);
		trace("Your units are maxed out");
	}
}
/////////////////////////
// Create Bad Infantry //
/////////////////////////
function createBadGuy(xCoord) {
	createBadUnit("infantry", xCoord);
}
///////////////////////
// Create Bad Archer //
///////////////////////
function createBadArcher(xCoord) {
	createBadUnit("archer", xCoord);
}
function createBadUnit(type:String, xCoord) {
	var newUnit;
	if (type == "archer") {
		newUnit = Unit_obj["unit" + unitID] = new badArcher(bg, unitID, this);
		// Init _y early since attack() requires it
		newUnit.graphic._y = 317;
		newUnit.attack();
		Unit_obj.BadArcher_num++;
	} else if (type == "infantry") {
		newUnit = Unit_obj["unit" + unitID] = new badGuy(bg, unitID, this);
		newUnit.walk();
		Unit_obj.BadGuy_num++;
	}
	newUnit.graphic._x = xCoord;
	newUnit.graphic._y = 317;
	newUnit.addEventListener("death",unitListener);
	unitID++;
	totalEnemy = Unit_obj.BadGuy_num + Unit_obj.BadArcher_num;
}