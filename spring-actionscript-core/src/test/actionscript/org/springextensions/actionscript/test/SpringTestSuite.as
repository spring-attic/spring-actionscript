/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.springextensions.actionscript.test {
	import integration.context.DefaultApplicationIntegrationTest;
	import integration.eventbus.EventBusUserRegistryIntegrationTest;
	import integration.objectfactory.ObjectFactoryIntegrationTest;
	import integration.xmlapplicationcontext.XMLApplicationContextTest;

	import org.springextensions.actionscript.context.impl.ApplicationContextTest;
	import org.springextensions.actionscript.context.impl.DefaultApplicationContextInitializerTest;
	import org.springextensions.actionscript.context.impl.DefaultChildContextManagerTest;
	import org.springextensions.actionscript.eventbus.EventBusShareKindTest;
	import org.springextensions.actionscript.eventbus.EventBusShareSettingsTest;
	import org.springextensions.actionscript.eventbus.impl.DefaultEventBusUserRegistryTest;
	import org.springextensions.actionscript.ioc.autowire.AutowireModeTest;
	import org.springextensions.actionscript.ioc.autowire.impl.DefaultAutowireProcessorTest;
	import org.springextensions.actionscript.ioc.config.impl.TextFilesLoaderTest;
	import org.springextensions.actionscript.ioc.config.impl.metadata.ConfigurationClassScannerTest;
	import org.springextensions.actionscript.ioc.config.impl.metadata.MetadataObjectDefinitionsProviderTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.XMLObjectDefinitionsProviderTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.ParsingUtilsTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration.EventHandlerCustomConfiguratorTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration.EventInterceptorCustomConfiguratorTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration.EventListenerInterceptorCustomConfiguratorTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration.RouteEventsCustomConfiguratorTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.nodeparser.EventHandlerNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.nodeparser.EventInterceptorNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.nodeparser.EventListenerInterceptorNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.nodeparser.EventRouterNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.stageprocessing.nodeparser.AutowiringStageProcessorNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.stageprocessing.nodeparser.GenericStageProcessorNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.stageprocessing.nodeparser.StageProcessorNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.TaskElementsPreprocessorTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.TaskNamespaceHandlerTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.BlockNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.CompositeCommandNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.CountProviderNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.IfNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.LoadURLNodeParsertest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.LoadURLStreamNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.PauseCommandNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.TaskNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util.customconfiguration.FactoryObjectCustomConfiguratorTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util.nodeparser.ConstantNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util.nodeparser.FactoryNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.util.nodeparser.InvokeNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XmlObjectDefinitionsParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.ArrayCollectionNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.ArrayNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.DictionaryNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.KeyValueNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.NanNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.NullNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.ObjectNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.RefNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.UndefinedNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser.VectorNodeParserTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.impl.AttributeToElementPreprocessorTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.impl.IdAttributePreprocessorTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.impl.InnerObjectsPreprocessorTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.impl.PropertyElementsPreprocessorTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.impl.PropertyImportPreprocessorTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.impl.ScopeAttributePreprocessorTest;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.impl.SpringNamesPreprocessorTest;
	import org.springextensions.actionscript.ioc.config.property.impl.KeyValuePropertiesParserTest;
	import org.springextensions.actionscript.ioc.config.property.impl.PropertiesTest;
	import org.springextensions.actionscript.ioc.config.property.impl.PropertyPlaceholderResolverTest;
	import org.springextensions.actionscript.ioc.factory.impl.DefaultInstanceCacheTest;
	import org.springextensions.actionscript.ioc.factory.impl.DefaultObjectFactoryTest;
	import org.springextensions.actionscript.ioc.factory.impl.FieldRetrievingFactoryObjectTest;
	import org.springextensions.actionscript.ioc.factory.impl.GenericFactoryObjectTest;
	import org.springextensions.actionscript.ioc.factory.impl.referenceresolver.ArrayCollectionReferenceResolverTest;
	import org.springextensions.actionscript.ioc.factory.impl.referenceresolver.ArrayReferenceResolverTest;
	import org.springextensions.actionscript.ioc.factory.impl.referenceresolver.DictionaryReferenceResolverTest;
	import org.springextensions.actionscript.ioc.factory.impl.referenceresolver.ObjectReferenceResolverTest;
	import org.springextensions.actionscript.ioc.factory.impl.referenceresolver.ThisReferenceResolverTest;
	import org.springextensions.actionscript.ioc.factory.impl.referenceresolver.VectorReferenceResolverTest;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.ClassScannerObjectFactoryPostProcessorTest;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.FactoryObjectFactoryPostProcessorTest;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.ObjectDefinitonFactoryPostProcessorTest;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.RegisterObjectFactoryPostProcessorsFactoryPostProcessorTest;
	import org.springextensions.actionscript.ioc.factory.process.impl.factory.RegisterObjectPostProcessorsFactoryPostProcessorTest;
	import org.springextensions.actionscript.ioc.factory.process.impl.object.ApplicationContextAwareObjectPostProcessorTest;
	import org.springextensions.actionscript.ioc.factory.process.impl.object.ApplicationDomainAwarePostProcessorTest;
	import org.springextensions.actionscript.ioc.factory.process.impl.object.ObjectFactoryAwarePostProcessorTest;
	import org.springextensions.actionscript.ioc.impl.DefaultDependencyCheckerTest;
	import org.springextensions.actionscript.ioc.impl.DefaultDependencyInjectorTest;
	import org.springextensions.actionscript.ioc.impl.DefaultLazyDependencyManagerTest;
	import org.springextensions.actionscript.ioc.objectdefinition.ChildContextObjectDefinitionAccessTest;
	import org.springextensions.actionscript.ioc.objectdefinition.DependencyCheckModeTest;
	import org.springextensions.actionscript.ioc.objectdefinition.ObjectDefinitionScopeTest;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.DefaultObjectDefinitionRegistryTest;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocationTest;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinitionBuilderTest;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinitionTest;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinitionTest;
	import org.springextensions.actionscript.metadata.MetadataProcessorObjectFactoryPostProcessorTest;
	import org.springextensions.actionscript.metadata.MetadataProcessorObjectPostProcessorTest;
	import org.springextensions.actionscript.object.SimpleTypeConverterTest;
	import org.springextensions.actionscript.object.propertyeditor.BooleanPropertyEditorTest;
	import org.springextensions.actionscript.object.propertyeditor.ClassPropertyEditorTest;
	import org.springextensions.actionscript.object.propertyeditor.NumberPropertyEditorTest;
	import org.springextensions.actionscript.util.ContextUtilsTest;
	import org.springextensions.actionscript.util.MultilineStringTest;
	import org.springextensions.actionscript.util.TypeUtilsTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public final class SpringTestSuite {
		//Unit tests
		public var t1:DefaultInstanceCacheTest;
		public var t2:TypeUtilsTest;
		public var t3:SimpleTypeConverterTest;
		public var t4:BooleanPropertyEditorTest;
		public var t5:NumberPropertyEditorTest;
		public var t6:ClassPropertyEditorTest;
		public var t7:DefaultAutowireProcessorTest;
		public var t8:ArrayCollectionReferenceResolverTest;
		public var t9:ArrayReferenceResolverTest;
		public var t10:DictionaryReferenceResolverTest;
		public var t11:ThisReferenceResolverTest;
		public var t12:VectorReferenceResolverTest;
		public var t13:ObjectReferenceResolverTest;
		public var t14:DefaultDependencyInjectorTest;
		public var t15:PropertiesTest;
		public var t16:KeyValuePropertiesParserTest;
		public var t17:DefaultObjectFactoryTest;
		public var t18:ApplicationContextTest;
		public var t19:DefaultObjectDefinitionRegistryTest;
		public var t20:ContextUtilsTest;
		public var t21:MultilineStringTest;
		public var t22:RegisterObjectPostProcessorsFactoryPostProcessorTest;
		public var t23:IdAttributePreprocessorTest;
		public var t25:PropertyElementsPreprocessorTest;
		public var t26:ScopeAttributePreprocessorTest;
		public var t27:AttributeToElementPreprocessorTest;
		public var t28:InnerObjectsPreprocessorTest;
		public var t29:PropertyImportPreprocessorTest;
		public var t30:SpringNamesPreprocessorTest;
		public var t31:XMLObjectDefinitionsProviderTest;
		public var t32:TextFilesLoaderTest;
		public var t33:RegisterObjectFactoryPostProcessorsFactoryPostProcessorTest;
		public var t34:MetadataProcessorObjectFactoryPostProcessorTest;
		public var t35:MetadataProcessorObjectPostProcessorTest;
		public var t36:EventRouterNodeParserTest;
		public var t37:EventHandlerNodeParserTest;
		public var t38:BlockNodeParserTest;
		public var t39:CompositeCommandNodeParserTest;
		public var t40:CountProviderNodeParserTest;
		public var t41:IfNodeParserTest;
		public var t42:LoadURLNodeParsertest;
		public var t43:LoadURLStreamNodeParserTest;
		public var t44:PauseCommandNodeParserTest;
		public var t45:TaskNodeParserTest;
		public var t46:TaskElementsPreprocessorTest;
		public var t47:TaskNamespaceHandlerTest;
		public var t48:XmlObjectDefinitionsParserTest;
		public var t49:MetadataObjectDefinitionsProviderTest;
		public var t50:DefaultEventBusUserRegistryTest;
		public var t51:EventInterceptorNodeParserTest;
		public var t52:EventListenerInterceptorNodeParserTest;
		public var t53:EventHandlerCustomConfiguratorTest;
		public var t54:EventInterceptorCustomConfiguratorTest;
		public var t55:EventListenerInterceptorCustomConfiguratorTest;
		public var t56:RouteEventsCustomConfiguratorTest;
		public var t57:AutowiringStageProcessorNodeParserTest;
		public var t58:GenericStageProcessorNodeParserTest;
		public var t59:StageProcessorNodeParserTest;
		public var t60:ObjectDefinitionTest;
		public var t61:GenericFactoryObjectTest;
		public var t62:ParsingUtilsTest;
		public var t63:ArrayNodeParserTest;
		public var t64:DictionaryNodeParserTest;
		public var t65:KeyValueNodeParserTest;
		public var t66:ObjectNodeParserTest;
		public var t67:FieldRetrievingFactoryObjectTest;
		public var t68:NanNodeParserTest;
		public var t69:RefNodeParserTest;
		public var t70:NullNodeParserTest;
		public var t71:UndefinedNodeParserTest;
		public var t72:VectorNodeParserTest;
		public var t73:ArrayCollectionNodeParserTest;
		public var t74:ApplicationContextAwareObjectPostProcessorTest;
		public var t75:ApplicationDomainAwarePostProcessorTest;
		public var t76:ObjectFactoryAwarePostProcessorTest;
		public var t77:ObjectDefinitonFactoryPostProcessorTest;
		public var t78:ClassScannerObjectFactoryPostProcessorTest;
		public var t79:FactoryObjectFactoryPostProcessorTest;
		public var t80:PropertyPlaceholderResolverTest;
		public var t81:FactoryObjectCustomConfiguratorTest;
		public var t82:FactoryNodeParserTest;
		public var t83:ConstantNodeParserTest;
		public var t84:InvokeNodeParserTest;
		public var t85:ConfigurationClassScannerTest;
		public var t86:DefaultApplicationContextInitializerTest;
		public var t87:DefaultChildContextManagerTest;
		public var t88:EventBusShareSettingsTest;
		public var t89:EventBusShareKindTest;
		public var t90:DependencyCheckModeTest;
		public var t91:ObjectDefinitionScopeTest;
		public var t92:ChildContextObjectDefinitionAccessTest;
		public var t93:MethodInvocationTest;
		public var t94:PropertyDefinitionTest;
		public var t95:ObjectDefinitionBuilderTest;
		public var t96:AutowireModeTest;
		public var t97:DefaultLazyDependencyManagerTest;
		public var t98:DefaultDependencyCheckerTest;
		//Integrations:
		public var i1:ObjectFactoryIntegrationTest;
		public var i2:EventBusUserRegistryIntegrationTest;
		public var i3:DefaultApplicationIntegrationTest;
		public var i4:XMLApplicationContextTest;
	}
}
