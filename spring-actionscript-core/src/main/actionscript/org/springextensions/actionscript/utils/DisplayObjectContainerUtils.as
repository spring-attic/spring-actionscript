/*
 * Copyright 2007-2010 the original author or authors.
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
package org.springextensions.actionscript.utils {
	
	import flash.display.DisplayObjectContainer;
	
	import org.as3commons.lang.Assert;
	
	/**
	 * Contains utilities for working with DisplayObjectContainer objects.
	 *
	 * <p>
	 * <b>Authors:</b> Bert Vandamme, Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public final class DisplayObjectContainerUtils {
		
		/**
		 * Adds all display objects in the children array to the container.
		 * @param container the container to which the children will be added
		 * @param children the array of DisplayObject instances that will be added as a child of the container
		 */
		public static function addChildren(container:DisplayObjectContainer, children:Array):void {
			Assert.notNull(container, "The container must not be null");
			Assert.notNull(children, "The children must not be null");
			var numChildren:int = children.length;
			
			for (var i:int = 0; i < numChildren; i++) {
				container.addChild(children[i]);
			}
		}
	}
}
