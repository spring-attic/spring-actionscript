package org.springextensions.actionscript.context.config {
	import org.as3commons.lang.ClassUtils;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.config.EventHandlerMetadataProcessor;
	import org.springextensions.actionscript.ioc.factory.config.RequiredMetadataProcessor;
	import org.springextensions.actionscript.ioc.factory.config.RouteEventsMetaDataProcessor;
	import org.springextensions.actionscript.ioc.factory.metadata.InitDestroyMetadataProcessor;
	import org.springextensions.actionscript.ioc.factory.xml.IObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.stage.DefaultAutowiringStageProcessor;

	/**
	 * Parser for the context:metadata-config node.
	 *
	 * @author Christophe Herreman
	 */
	public class MetadataConfigObjectDefinitionParser implements IObjectDefinitionParser {

		// -------------------------------------------------------------
		//
		// Constructor
		//
		// -------------------------------------------------------------

		public function MetadataConfigObjectDefinitionParser() {
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function parse(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			context.registerObjectDefinition("internalRequiredMetadataProcessor", createObjectDefinitionForClass(RequiredMetadataProcessor));
			context.registerObjectDefinition("internalInitDestroyMetadataProcessor", createObjectDefinitionForClass(InitDestroyMetadataProcessor));
			context.registerObjectDefinition("internalEventHandlerMetadataProcessor", createObjectDefinitionForClass(EventHandlerMetadataProcessor));
			context.registerObjectDefinition("internalRouteEventsMetadataProcessor", createObjectDefinitionForClass(RouteEventsMetaDataProcessor));
			context.registerObjectDefinition("internalAutowiringStageProcessor", createObjectDefinitionForClass(DefaultAutowiringStageProcessor));

			return null;
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function createObjectDefinitionForClass(clazz:Class):IObjectDefinition {
			return new ObjectDefinition(ClassUtils.getFullyQualifiedName(clazz, true));
		}
	}
}