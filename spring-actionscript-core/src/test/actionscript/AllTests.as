/*
 * Copyright 2007-2008 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package {

	import flexunit.framework.Test;
	import flexunit.framework.TestSuite;

	import org.springextensions.actionscript.collections.MapTest;
	import org.springextensions.actionscript.collections.PropertiesTest;
	import org.springextensions.actionscript.collections.TypedCollectionTest;
	import org.springextensions.actionscript.collections.TypedCollectionViewCursorTest;
	import org.springextensions.actionscript.context.metadata.ClassScannerObjectFactoryPostProcessorTest;
	import org.springextensions.actionscript.context.metadata.ComponentClassScannerTest;
	import org.springextensions.actionscript.context.support.FlexXMLApplicationContextTest;
	import org.springextensions.actionscript.context.support.XMLApplicationContextTest;
	import org.springextensions.actionscript.context.support.mxml.MXMLApplicationContextTest;
	import org.springextensions.actionscript.core.command.CompositeCommandTest;
	import org.springextensions.actionscript.core.command.GenericOperationCommandTest;
	import org.springextensions.actionscript.core.event.EventBusTests;
	import org.springextensions.actionscript.core.event.ListenerCollectionTest;
	import org.springextensions.actionscript.core.mvc.MVCControllerObjectFactoryPostProcessorTest;
	import org.springextensions.actionscript.core.mvc.MVCRouteEventsMetaDataPostProcessorTest;
	import org.springextensions.actionscript.core.mvc.support.CommandProxyTest;
	import org.springextensions.actionscript.core.operation.OperationHandlerTest;
	import org.springextensions.actionscript.core.task.TaskTest;
	import org.springextensions.actionscript.core.task.xml.TaskElementsPreprocessorTest;
	import org.springextensions.actionscript.core.task.xml.TaskNamespaceHandlerTest;
	import org.springextensions.actionscript.core.task.xml.parser.BlockNodeParserTest;
	import org.springextensions.actionscript.core.task.xml.parser.CompositeCommandNodeParserTest;
	import org.springextensions.actionscript.core.task.xml.parser.CountProviderNodeParserTest;
	import org.springextensions.actionscript.core.task.xml.parser.IfNodeParserTest;
	import org.springextensions.actionscript.core.task.xml.parser.LoadModuleNodeParserTest;
	import org.springextensions.actionscript.core.task.xml.parser.LoadPropertiesBatchNodeParserTest;
	import org.springextensions.actionscript.core.task.xml.parser.LoadPropertiesNodeParserTest;
	import org.springextensions.actionscript.core.task.xml.parser.LoadResourceModuleNodeParserTest;
	import org.springextensions.actionscript.core.task.xml.parser.LoadStyleModuleNodeParserTest;
	import org.springextensions.actionscript.core.task.xml.parser.LoadURLNodeParsertest;
	import org.springextensions.actionscript.core.task.xml.parser.LoadURLStreamNodeParserTest;
	import org.springextensions.actionscript.core.task.xml.parser.PauseCommandNodeParserTest;
	import org.springextensions.actionscript.core.task.xml.parser.TaskNodeParserTest;
	import org.springextensions.actionscript.ioc.ObjectDefinitionScopeTest;
	import org.springextensions.actionscript.ioc.ObjectDefinitionTest;
	import org.springextensions.actionscript.ioc.factory.NoSuchObjectDefinitionErrorTest;
	import org.springextensions.actionscript.ioc.factory.config.EventHandlerMetadataProcessor;
	import org.springextensions.actionscript.ioc.factory.config.EventHandlerMetaDataProcessorTest;
	import org.springextensions.actionscript.ioc.factory.config.FieldRetrievingFactoryObjectTest;
	import org.springextensions.actionscript.ioc.factory.config.ObjectFactoryAwarePostProcessorTest;
	import org.springextensions.actionscript.ioc.factory.config.RandomNumberFactoryObjectTest;
	import org.springextensions.actionscript.ioc.factory.config.RequiredMetadataObjectPostProcessorTest;
	import org.springextensions.actionscript.ioc.factory.config.flex.ApplicationPropertiesResolverTest;
	import org.springextensions.actionscript.ioc.factory.support.DefaultListableObjectFactoryTest;
	import org.springextensions.actionscript.ioc.factory.xml.parser.XmlObjectDefinitionsParserTest;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.ArrayNodeParserTest;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.DictionaryNodeParserTest;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.KeyValueNodeParserTest;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.ObjectNodeParserTest;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.util.ConstantNodeParserTest;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.util.InvokeNodeParserTest;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.IdAttributePreprocessorTest;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.InterfacePreprocessorTest;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.MethodInvocationPreprocessorTest;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.ParentAttributePreprocessorTest;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.PropertyElementsPreprocessorTest;
	import org.springextensions.actionscript.ioc.factory.xml.preprocessors.ScopeAttributePreprocessorTest;
	import org.springextensions.actionscript.objects.ClassPropertyEditorTest;
	import org.springextensions.actionscript.objects.SimpleTypeConverterTest;
	import org.springextensions.actionscript.stage.DefaultAutowiringStageProcessorTest;
	import org.springextensions.actionscript.stage.FlexStageProcessorRegistryTest;
	import org.springextensions.actionscript.stage.StageProcessorRegistrationTest;
	import org.springextensions.actionscript.utils.ArrayCollectionUtilsTest;
	import org.springextensions.actionscript.utils.FitFrameworkTest;
	import org.springextensions.actionscript.utils.HtmlUtilsTest;
	import org.springextensions.actionscript.utils.OrderedUtilsTest;
	import org.springextensions.actionscript.utils.ParseTest;
	import org.springextensions.actionscript.utils.PropertiesUtilsTest;
	import org.springextensions.actionscript.utils.TypeConverterTest;
	import org.springextensions.actionscript.utils.TypetUtilsTest;
	import org.springextensions.actionscript.wire.ClassBasedObjectSelectorTest;
	import org.springextensions.actionscript.wire.ComposedObjectSelectorTest;
	import org.springextensions.actionscript.wire.FlexDefaultObjectSelectorTest;
	import org.springextensions.actionscript.wire.NameBasedObjectSelectorTest;
	import org.springextensions.actionscript.wire.TypeBasedObjectSelectorTest;

	/**
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 17 $, $Date: 2008-11-01 20:07:07 +0100 (Sat, 01 Nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class AllTests {

		public static function suite():Test {

			var testSuite:TestSuite = new TestSuite();

			testSuite.addTest(new TestSuite(FieldRetrievingFactoryObjectTest));
			/*
						//eventbus
						testSuite.addTest(new TestSuite(EventBusTests));
						testSuite.addTest(new TestSuite(ListenerCollectionTest));

						//MXML support
						testSuite.addTest(new TestSuite(MXMLApplicationContextTest));

						//ordered
						testSuite.addTest(new TestSuite(OrderedUtilsTest));

						//class scanners
						testSuite.addTest(new TestSuite(ClassScannerObjectFactoryPostProcessorTest));
						testSuite.addTest(new TestSuite(ComponentClassScannerTest));

						//task
						testSuite.addTest(new TestSuite(TaskTest));

						//mvc
						testSuite.addTest(new TestSuite(MVCControllerObjectFactoryPostProcessorTest));
						testSuite.addTest(new TestSuite(MVCRouteEventsMetaDataPostProcessorTest));
						testSuite.addTest(new TestSuite(CommandProxyTest));

						testSuite.addTest(new TestSuite(EventHandlerMetaDataProcessorTest));

						//constant node parser
						testSuite.addTest(new TestSuite(ConstantNodeParserTest));
						testSuite.addTest(new TestSuite(InvokeNodeParserTest));

						//task
						testSuite.addTest(new TestSuite(TaskNamespaceHandlerTest));
						testSuite.addTest(new TestSuite(BlockNodeParserTest));
						testSuite.addTest(new TestSuite(IfNodeParserTest));
						testSuite.addTest(new TestSuite(CountProviderNodeParserTest));
						testSuite.addTest(new TestSuite(TaskNodeParserTest));
						testSuite.addTest(new TestSuite(PauseCommandNodeParserTest));
						testSuite.addTest(new TestSuite(TaskElementsPreprocessorTest));
						testSuite.addTest(new TestSuite(LoadModuleNodeParserTest));
						testSuite.addTest(new TestSuite(LoadPropertiesBatchNodeParserTest));
						testSuite.addTest(new TestSuite(LoadPropertiesNodeParserTest));
						testSuite.addTest(new TestSuite(LoadResourceModuleNodeParserTest));
						testSuite.addTest(new TestSuite(LoadStyleModuleNodeParserTest));
						testSuite.addTest(new TestSuite(LoadURLNodeParsertest));
						testSuite.addTest(new TestSuite(LoadURLStreamNodeParserTest));
						testSuite.addTest(new TestSuite(CompositeCommandNodeParserTest));

						// collections
						testSuite.addTest(new TestSuite(MapTest));
						testSuite.addTest(new TestSuite(PropertiesTest));
						testSuite.addTest(new TestSuite(TypedCollectionTest));
						testSuite.addTest(new TestSuite(TypedCollectionViewCursorTest));

						// context.support
						testSuite.addTest(new TestSuite(XMLApplicationContextTest));
						testSuite.addTest(new TestSuite(FlexXMLApplicationContextTest));

						// ioc
						testSuite.addTest(new TestSuite(ObjectDefinitionScopeTest));
						testSuite.addTest(new TestSuite(ObjectDefinitionTest));

						// ioc.factory
						testSuite.addTest(new TestSuite(NoSuchObjectDefinitionErrorTest));

						// ioc.factory.config
						testSuite.addTest(new TestSuite(FieldRetrievingFactoryObjectTest));
						testSuite.addTest(new TestSuite(ObjectFactoryAwarePostProcessorTest));
						testSuite.addTest(new TestSuite(RandomNumberFactoryObjectTest));
						testSuite.addTest(new TestSuite(RequiredMetadataObjectPostProcessorTest));
						testSuite.addTest(new TestSuite(ApplicationPropertiesResolverTest));

						// ioc.factory.support
						testSuite.addTest(new TestSuite(DefaultListableObjectFactoryTest));

						// ioc.factory.xml.parser.support
						testSuite.addTest(new TestSuite(XmlObjectDefinitionsParserTest));

						// ioc.factory.xml.parser.support.nodeparsers
						testSuite.addTest(new TestSuite(ArrayNodeParserTest));
						testSuite.addTest(new TestSuite(DictionaryNodeParserTest));
						testSuite.addTest(new TestSuite(KeyValueNodeParserTest));
						testSuite.addTest(new TestSuite(ObjectNodeParserTest));

						// ioc.factory.xml.preprocessors
						testSuite.addTest(new TestSuite(ScopeAttributePreprocessorTest));
						testSuite.addTest(new TestSuite(IdAttributePreprocessorTest));
						testSuite.addTest(new TestSuite(MethodInvocationPreprocessorTest));
						//testSuite.addTest(new TestSuite(PropertiesPreprocessorTest));
						testSuite.addTest(new TestSuite(ParentAttributePreprocessorTest));
						testSuite.addTest(new TestSuite(InterfacePreprocessorTest));
						testSuite.addTest(new TestSuite(PropertyElementsPreprocessorTest));

						// objects
						testSuite.addTest(new TestSuite(SimpleTypeConverterTest));

						// objects.propertyeditors
						testSuite.addTest(new TestSuite(ClassPropertyEditorTest));

						// utils
						testSuite.addTest(new TestSuite(ArrayCollectionUtilsTest));
						testSuite.addTest(new TestSuite(TypetUtilsTest));
						testSuite.addTest(new TestSuite(PropertiesUtilsTest));
						testSuite.addTest(new TestSuite(TypeConverterTest));
						testSuite.addTest(new TestSuite(HtmlUtilsTest));
						testSuite.addTest(new TestSuite(ParseTest));
						testSuite.addTest(new TestSuite(FitFrameworkTest));

						//object selector
						testSuite.addTest(new TestSuite(ClassBasedObjectSelectorTest));
						testSuite.addTest(new TestSuite(ComposedObjectSelectorTest));
						testSuite.addTest(new TestSuite(FlexDefaultObjectSelectorTest));
						testSuite.addTest(new TestSuite(NameBasedObjectSelectorTest));
						testSuite.addTest(new TestSuite(TypeBasedObjectSelectorTest));

						//stage processing
						testSuite.addTest(new TestSuite(StageProcessorRegistrationTest));
						testSuite.addTest(new TestSuite(DefaultAutowiringStageProcessorTest));
						testSuite.addTest(new TestSuite(FlexStageProcessorRegistryTest));

						//Commands
						testSuite.addTest(new TestSuite(CompositeCommandTest));
						testSuite.addTest(new TestSuite(GenericOperationCommandTest));

						//Operation
						testSuite.addTest(new TestSuite(OperationHandlerTest));
			*/
			return testSuite;
		}

	}
}
