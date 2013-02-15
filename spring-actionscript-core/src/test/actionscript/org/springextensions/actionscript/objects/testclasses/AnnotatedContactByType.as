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
package org.springextensions.actionscript.objects.testclasses {

  /**
   * <p>
   * <b>Author:</b> Martino Piccinato<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.9
   * </p>
   */
  public class AnnotatedContactByType {

    private var _phoneNumber:PhoneNumber;
    
    private var _phoneNumber2:PhoneNumber;
        
    public var note:String;

    public function AnnotatedContactByType() {
    }

    [Autowired(mode="byType")]
    public function get phoneNumber():PhoneNumber {
        return _phoneNumber;
    }

    public function set phoneNumber(value:PhoneNumber):void {
        _phoneNumber = value;
    }

    public function get phoneNumber2():PhoneNumber {
        return _phoneNumber2;
    }

    public function set phoneNumber2(value:PhoneNumber):void {
        _phoneNumber2 = value;
    }

  }
}
