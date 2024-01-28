class scripts.damageManager {

	private var guy2Damage:Number;
	private var guy3Damage:Number;
	
	function damageManager() {
	}
	
	public function computeDamage(guy1, guy2) {
		guy2Damage = Math.round((Math.random()*5) + 15);		
		guy2.hitPointBarOver._width = guy2.hitPoints -= guy2Damage;
		trace( guy2.graphic + " got hit for "+guy2Damage + ". HP: " + guy2.hitPoints);
	}
	
	public function ArrowDamage(guy3){
		guy3.hitPointBarOver._width = guy3.hitPoints -= Math.round((Math.random()*10) + 30);
	}
}
