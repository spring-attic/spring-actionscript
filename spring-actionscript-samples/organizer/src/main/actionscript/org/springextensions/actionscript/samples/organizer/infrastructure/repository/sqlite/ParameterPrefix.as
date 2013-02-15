package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite
{
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	public class ParameterPrefix
	{
		public static const AT_SIGN:ParameterPrefix = new ParameterPrefix(AT_SIGN_NAME);
		
		public static const COLON:ParameterPrefix = new ParameterPrefix(COLON_NAME);
		
		public static const QUESTION_MARK:ParameterPrefix = new ParameterPrefix(QUESTION_MARK_NAME);
		
		private static const AT_SIGN_NAME:String = "@";
		
		private static const COLON_NAME:String = ":";
		
		private static const QUESTION_MARK_NAME:String = "?";
		
		
		private static var _enumCreated:Boolean = false;
		
		private var _name:String;
		{
			_enumCreated = true;
		}
		
		public function ParameterPrefix(name:String) {
			Assert.state(!_enumCreated, "The ParameterPrefix enum has already been created.");
			_name = name;
		}
		
		/**
		 * Retunrs a <code>AccessStrategy</code> if an instance with the specified name exists.
		 */
		public static function fromName(name:String):ParameterPrefix {
			var result:ParameterPrefix;
			
			// check if the name is a valid value in the enum
			switch (StringUtils.trim(name)) {
				case AT_SIGN_NAME:
					result = AT_SIGN;
					break;
				case COLON_NAME:
					result = COLON;
					break;
				case QUESTION_MARK_NAME:
					result = QUESTION_MARK;
					break;
				default:
					result = QUESTION_MARK;
			}
			return result;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function toString():String {
			return _name;
		}
	}
}