package com.lyon2.controls.utils
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	[ResourceBundle("HumanDate")]
	
	public final class TimeUtils
	{
		
		
		private static const ressourceManager:IResourceManager = ResourceManager.getInstance();
		
		private static var time_table:Array = [
			new TimeUnit(3155760000, /* Siècle */
				ressourceManager.getString('HumanDate', 'short_century'),
				ressourceManager.getString('HumanDate', 'century')),
			new TimeUnit(31557600, /* Année */
				ressourceManager.getString('HumanDate', 'short_year'),
				ressourceManager.getString('HumanDate', 'year')),
			new TimeUnit(2592000, /* Mois */
				ressourceManager.getString('HumanDate', 'short_month'),
				ressourceManager.getString('HumanDate', 'month')),
			new TimeUnit(604800, /* Semaine */
				ressourceManager.getString('HumanDate', 'short_week'),
				ressourceManager.getString('HumanDate', 'week')),
			new TimeUnit(86400, /* Jour */
				ressourceManager.getString('HumanDate', 'short_day'),
				ressourceManager.getString('HumanDate', 'day')),
			new TimeUnit(3600, /* Heure */
				ressourceManager.getString('HumanDate', 'short_hour'),
				ressourceManager.getString('HumanDate', 'hour')),
			new TimeUnit(60, /* minute */
				ressourceManager.getString('HumanDate', 'short_minute'),
				ressourceManager.getString('HumanDate', 'minute')),
			new TimeUnit(1, /* seconde */
				ressourceManager.getString('HumanDate', 'short_second'),
				ressourceManager.getString('HumanDate', 'second'))
			]; 
		
		
		public static function relativeTime (to:Date, ref:Date=null, short:Boolean=false):String
		{
			ref ||= new Date();
			var diff_abs:Number = Math.abs(to.time - ref.time);
			var futur:Boolean = to.time > ref.time;
		 
			
			for each (var t:TimeUnit in time_table)
			{
				var rest:Number = int(diff_abs/(t.value*1000));
				var unit:String;
				var message:String;
				if (futur)
					message = ressourceManager.getString('HumanDate', 'futur');
				else
					message = ressourceManager.getString('HumanDate', 'past');
				if (rest >= 1)
				{
					if (rest == 1) unit = short? t.short_unit : t.long_unit.replace(/(\(([^\|)]*)\|?([^\|)]*)\))/,"$2");
					if (rest > 1) unit = short? t.short_unit : t.long_unit.replace(/(\(([^\|)]*)\|?([^\|)]*)\))/,"$3");
					return message.split("%d").join(rest+" "+unit).concat(".");
				}
			}
			return "";
		}
	}
}


