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
package org.springextensions.actionscript.test.context.support {
/**
 * <p>
 * Concrete implementation of <code>AbstractGenericContextLoader</code> which reads
 * object definitions from XML resources.
 * </p>
 *
 * @author Andrew Lewisohn
 */
public class GenericXMLContextLoader extends AbstractGenericContextLoader {

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function GenericXMLContextLoader() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns "<code>-context.xml</code>"
	 * 
	 * @see org.springextensions.actionscript.test.context.support.AbstractContextLoader#getResourceSuffix()
	 */
	override protected function getResourceSuffix() : String {
		return "-context.xml";
	}
}
}