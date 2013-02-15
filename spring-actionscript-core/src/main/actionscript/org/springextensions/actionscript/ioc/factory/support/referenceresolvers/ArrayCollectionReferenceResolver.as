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
package org.springextensions.actionscript.ioc.factory.support.referenceresolvers {

  import mx.collections.ArrayCollection;
  import mx.collections.IViewCursor;

  import org.springextensions.actionscript.ioc.factory.IObjectFactory;
  import org.springextensions.actionscript.ioc.factory.support.AbstractReferenceResolver;

  /**
   * Resolves the references in an array-collection.
   *
   * <p>
   * <b>Authors:</b> Christophe Herreman, Erik Westra<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class ArrayCollectionReferenceResolver extends AbstractReferenceResolver {

    /**
     * Constructs <code>ArrayCollectionReferenceResolver</code>.
     *
     * @param factory    The factory that uses this reference resolver
     */
    public function ArrayCollectionReferenceResolver(factory:IObjectFactory) {
      super(factory);
    }

    /**
     * Checks if the object is an ArrayCollection
     * <p />
     * @inheritDoc
     */
    override public function canResolve(property:Object):Boolean {
      return (property is ArrayCollection);
    }

    /**
     * @inheritDoc
     */
    override public function resolve(property:Object):Object {
      for (var c:IViewCursor = ArrayCollection(property).createCursor(); !c.afterLast; c.moveNext()) {
        c.insert(factory.resolveReference(c.current));
        c.remove();
        c.movePrevious();
      }

      return property;
    }
  }
}
