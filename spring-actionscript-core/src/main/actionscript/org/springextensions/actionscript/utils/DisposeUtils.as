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
	import org.springextensions.actionscript.ioc.IDisposable;

	public final class DisposeUtils {

		public static function disposeCollection(collection:Array):void {
			if (collection != null) {
				for each (var item:Object in collection) {
					if (item is IDisposable) {
						IDisposable(item).dispose();
					}
				}
				collection.length = 0;
			}
		}

	}
}