package org.springextensions.actionscript.ioc.factory.config {
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.reflect.Metadata;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;
	import org.springextensions.actionscript.metadata.AbstractMetadataProcessor;

	public class AbstractEventBusMetadataProcessor extends AbstractMetadataProcessor implements IObjectFactoryAware {

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var logger:ILogger = getLogger(AbstractEventBusMetadataProcessor);

		/** The "name" property of the EventHandler metadata */
		protected static const NAME_KEY:String = "name";
		/** The "clazz" property of the EventHandler metadata */
		protected static const CLASS_KEY:String = "clazz";
		/** The "topic" property of the EventHandler metadata */
		protected static const TOPICS_KEY:String = "topics";
		/** The "topicProperties" property of the EventHandler metadata */
		protected static const TOPIC_PROPERTIES_KEY:String = "topicProperties";
		protected static const COMMA:String = ",";

		protected var objFactory:IObjectFactory;

		public function AbstractEventBusMetadataProcessor(processBefore:Boolean, metadataNames:Array = null) {
			super(processBefore, metadataNames);
		}

		public function set objectFactory(objectFactory:IObjectFactory):void {
			objFactory = objectFactory;
		}

		protected function getTopics(metaData:Metadata, object:Object):Array {
			var result:Array = [];
			var topicsValue:String;
			if (metaData.hasArgumentWithKey(TOPICS_KEY)) {
				topicsValue = metaData.getArgument(TOPICS_KEY).value;
				result = result.concat(topicsValue.split(COMMA));
				result.forEach(trim);
			}
			if (metaData.hasArgumentWithKey(TOPIC_PROPERTIES_KEY)) {
				topicsValue = metaData.getArgument(TOPIC_PROPERTIES_KEY).value;
				var props:Array = topicsValue.split(COMMA);
				for each (var name:String in props) {
					if (object.hasOwnProperty(name)) {
						result[result.length] = object[name];
					} else {
						logger.debug("Topic property {0} not found on object {1}", [name, object]);
					}
				}
			}
			return result;
		}

		protected function trim(element:*, index:int, arr:Array):void {
			arr[index] = StringUtils.trim(element);
		}

	}
}
