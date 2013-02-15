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
package org.springextensions.actionscript.ioc.factory.support {

  import flash.errors.IllegalOperationError;

  import org.springextensions.actionscript.ioc.factory.IObjectFactory;
  import org.springextensions.actionscript.ioc.factory.IReferenceResolver;

  /**
   * Abstract base class for reference resolvers. This class should not be instantiated directly,
   * instead a subclass should be created.
   *
   * <p>
   * <b>Authors:</b> Christophe Herreman, Erik Westra<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class AbstractReferenceResolver implements IReferenceResolver {

    /**
     * Contains a reference to the implementation of IObjectFactory given to the constructor
     */
    protected var factory:IObjectFactory;

    /**
     * Constructs <code>AbstractReferenceResolver</code>.
     *
     * @param factory    The factory that uses this reference resolver
     */
    public function AbstractReferenceResolver(factory:IObjectFactory) {
      this.factory = factory;
    }

    /**
     * @inheritDoc
     *
     * @throws flash.errors.IllegalOperationError  This method should be implemented by a subclass
     */
    public function canResolve(property:Object):Boolean {
      throw new IllegalOperationError("canResolve() is abstract");
    }

    /**
     * @inheritDoc
     *
     * @throws flash.errors.IllegalOperationError  This method should be implemented by a subclass
     */
    public function resolve(property:Object):Object {
      throw new IllegalOperationError("resolve() is abstract");
    }
  }
}
