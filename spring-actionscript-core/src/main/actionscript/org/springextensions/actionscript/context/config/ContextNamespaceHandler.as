package org.springextensions.actionscript.context.config {

	import org.springextensions.actionscript.ioc.factory.xml.NamespaceHandlerSupport;

	/**
	 * Namespace handler for the "context" namespace.
	 *
	 * @author Christophe Herreman
	 */
	public class ContextNamespaceHandler extends NamespaceHandlerSupport {

		// -------------------------------------------------------------
		//
		// Constructor
		//
		// -------------------------------------------------------------

		public function ContextNamespaceHandler() {
			super(spring_actionscript_context);

			registerObjectDefinitionParser("metadata-config", new MetadataConfigObjectDefinitionParser());
			registerObjectDefinitionParser("component-scan", new ComponentScanObjectDefinitionParser());
		}
	}
}