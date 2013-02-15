/*
 * Copyright 2007-2011 the original author or authors.
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
package org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers {

  import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
  import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;

  /**
   * Parses an reference node.
   *
   * <p>
   * <b>Authors:</b> Christophe Herreman, Erik Westra<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class RefNodeParser extends AbstractNodeParser {

    /**
     * Constructs the RefNodeParser.
     *
     * @param xmlObjectDefinitionsParser  The definitions parser using this NodeParser
     *
     * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#REF_ELEMENT
     */
    public function RefNodeParser(xmlObjectDefinitionsParser:XMLObjectDefinitionsParser) {
      super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.REF_ELEMENT);
    }

    /**
     * @inheritDoc
     */
    override public function parse(node:XML):Object {
      return new RuntimeObjectReference(node.toString());
    }
  }
}
