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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.messaging {

	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.AbstractNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.messaging.nodeparser.AMFChannelNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.messaging.nodeparser.ChannelSetNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.messaging.nodeparser.ConsumerNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.messaging.nodeparser.MultiTopicConsumerNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.messaging.nodeparser.MultiTopicProducerNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.messaging.nodeparser.ProducerNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.messaging.nodeparser.SecureAMFChannelNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.messaging.nodeparser.SecureStreamingAMFChannelNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.messaging.nodeparser.StreamingAMFChannelNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_messaging;

	/**
	 *
	 * @docref xml-schema-based-configuration.html#the_messaging_schema
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class MessagingNamespaceHandler extends AbstractNamespaceHandler {

		/** Messaging namespace element names */

		public static const ABSTRACT_CONSUMER_ELEMENT:String = "abstract-consumer";

		public static const CHANNEL_SET_ELEMENT:String = "channel-set";

		public static const CHANNEL_ELEMENT:String = "channel";

		public static const AMF_CHANNEL_ELEMENT:String = "amf-channel";

		public static const MESSAGE_AGENT_ELEMENT:String = "message-agent";

		public static const STREAMING_AMF_CHANNEL_ELEMENT:String = "streaming-amf-channel";

		public static const SECURE_STREAMING_AMF_CHANNEL_ELEMENT:String = "secure-streaming-amf-channel";

		public static const SECURE_AMF_CHANNEL_ELEMENT:String = "secure-amf-channel";

		public static const CONSUMER_ELEMENT:String = "consumer";

		public static const MULTI_TOPIC_CONSUMER_NODE_PARSER:String = "multi-topic-consumer";

		public static const MULTI_TOPIC_PRODUCER_NODE_PARSER:String = "multi-topic-producer";

		public static const PRODUCER_ELEMENT:String = "producer";

		public static const SUBSCRIPTION_INFO_ELEMENT:String = "subscription-info";

		/** Messaging namespace attribute names */

		public static const URL_ATTR:String = "url";

		public static const CLUSTERED_ATTR:String = "clustered";

		public static const INITIAL_DESTINATION_ID_ATTR:String = "initial-destination-id";

		/**
		 * Creates a new <code>MessagingNamespaceHandler</code>
		 */
		public function MessagingNamespaceHandler() {
			super(spring_actionscript_messaging);

			registerObjectDefinitionParser(CHANNEL_SET_ELEMENT, new ChannelSetNodeParser());
			registerObjectDefinitionParser(CONSUMER_ELEMENT, new ConsumerNodeParser());
			registerObjectDefinitionParser(MULTI_TOPIC_CONSUMER_NODE_PARSER, new MultiTopicConsumerNodeParser());
			registerObjectDefinitionParser(MULTI_TOPIC_PRODUCER_NODE_PARSER, new MultiTopicProducerNodeParser());
			registerObjectDefinitionParser(PRODUCER_ELEMENT, new ProducerNodeParser());
			registerObjectDefinitionParser(STREAMING_AMF_CHANNEL_ELEMENT, new StreamingAMFChannelNodeParser());
			registerObjectDefinitionParser(SECURE_STREAMING_AMF_CHANNEL_ELEMENT, new SecureStreamingAMFChannelNodeParser());
			registerObjectDefinitionParser(AMF_CHANNEL_ELEMENT, new AMFChannelNodeParser());
			registerObjectDefinitionParser(SECURE_AMF_CHANNEL_ELEMENT, new SecureAMFChannelNodeParser());
		}

	}
}
