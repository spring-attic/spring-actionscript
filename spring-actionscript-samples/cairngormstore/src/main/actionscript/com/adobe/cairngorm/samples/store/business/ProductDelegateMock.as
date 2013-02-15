/*

Copyright (c) 2006. Adobe Systems Incorporated.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
  * Neither the name of Adobe Systems Incorporated nor the names of its
    contributors may be used to endorse or promote products derived from this
    software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

@ignore
*/
package com.adobe.cairngorm.samples.store.business
{
  import com.adobe.cairngorm.samples.store.vo.ProductVO;

  import mx.collections.ArrayCollection;
  import mx.collections.ICollectionView;

  /**
   * @version  $Revision: $
   */
  public class ProductDelegateMock extends BaseBusinessDelegateMock implements IProductDelegate
  {
    public function ProductDelegateMock(){
      super();
      this.Latency=2000;
    }

    public function getProducts() : void
    {
      //create the mockup list of items (copied from the java code)
      var products:ICollectionView = createProducts();
      //call async responder
      setResults(products);
    }

    private function createProducts():ICollectionView
    {
      var products:ArrayCollection = new ArrayCollection();

      var product1:ProductVO = new ProductVO();
      product1.id= 1;
      product1.name= "USB Watch";
      product1.description= "So, you need to tell the time of course, but you also need a way to carry your valuable data with you at all times (you know - your MP3 files, favorite images, your ThinkGeek shopping list). This watch can handle the mission for you and do it in style. It can store up to 256 Megs of data." ;
      product1.price= 129.99;
      product1.image =  "assets/products/usbwatch.jpg" ;
      product1.thumbnail =  "assets/products/usbwatch_sm.jpg" ;
      products.addItem( product1 );

      var product2 :ProductVO = new ProductVO();
      product2.id= 2 ;
      product2.name= "007 Digital Camera" ;
      product2.description= "There is finally a hi-tech gadget from Q''s laboratory that can be had by the measly (albeit smart) masses who are not fortunate enough to carry a license to kill. This inconspicuous Zippo look-alike actually contains a digital camera capable of holding over 300 images." ;
      product2.price= 99.99;
      product2.image= "assets/products/007camera.jpg" ;
      product2.thumbnail =  "assets/products/007camera_sm.jpg" ;
      products.addItem( product2 );

      var product3 :ProductVO = new ProductVO();
      product3.id =  3 ;
      product3.name = "2-Way Radio Watch" ;
      product3.description= "The only wristwatch with a 2-way radio available to date. It features a built-in 22-channel FRS walkie talkie with a 1.5-mile range. The voice-activated feature allows you to speak into the microphone and your words will be beamed directly to the speaker of any other FRS walkie talkie user." ;
      product3.price= 49.99;
      product3.image= "assets/products/radiowatch.jpg";
      product3.thumbnail= "assets/products/radiowatch_sm.jpg" ;
      products.addItem( product3 );

      var product4 :ProductVO = new ProductVO();
      product4.id= 4 ;
      product4.name="USB Desk Fan" ;
      product4.description="Some people are addicted to fans. They have one running when they sleep (the background noise can be soothing) and they have one on their desk at all times. Other people just like to have a little moving air. Whether you are a fan addict or just a casual user, we have just the device for you." ;
      product4.price= 19.99 ;
      product4.image="assets/products/usbfan.jpg" ;
      product4.thumbnail="assets/products/usbfan_sm.jpg" ;
      products.addItem( product4) ;

      var product5 :ProductVO = new ProductVO();
      product5.id= 5 ;
      product5.name="Caffeinated Soap" ;
      product5.description="Tired of waking up and having to wait for your morning java to brew? Are you one of those groggy early morning types that just needs that extra kick? Introducing Shower Shock, the original and world''s first caffeinated soap. When you think about it, ShowerShock is the ultimate clean buzz ;)" ;
      product5.price= 19.99;
      product5.image="assets/products/soap.jpg" ;
      product5.thumbnail="assets/products/soap_sm.jpg" ;
      products.addItem( product5 );

      var product6 :ProductVO = new ProductVO();
      product6.id= 6 ;
      product6.name="Desktop Rovers" ;
      product6.description="Inspired by NASA''s planetary exploration program, this miniature ''caterpillar drive'' rover belongs officially in the ''way too cool'' category. These mini remote controlled desktop rovers with tank treads are only 4 inches long and ready to explore the 'Alien Landscapes' around your home or office." ;
      product6.price= 49.99;
      product6.image="assets/products/rover.jpg" ;
      product6.thumbnail="assets/products/rover_sm.jpg" ;
      products.addItem( product6 );

      var product7 :ProductVO = new ProductVO();
      product7.id= 7 ;
      product7.name="PC Volume Knob" ;
      product7.description="The coolest volume knob your computer has ever seen and so much more. Use it to edit home movies or scroll through long documents and web pages. Program it to do anything you want in any application. Customize it to your own needs and get wild." ;
      product7.price= 34.99;
      product7.image="assets/products/volume.jpg" ;
      product7.thumbnail="assets/products/volume_sm.jpg" ;
      products.addItem( product7 );

      var product8 :ProductVO = new ProductVO();
      product8.id= 8 ;
      product8.name="Wireless Antenna" ;
      product8.description="A Cantenna is simply an inexpensive version of the long-range antennas used by wireless internet providers and mobile phone companies. Now, with your own Cantenna you can extend the range of your wireless network or connect to other wireless networks in your neighborhood." ;
      product8.price= 49.99;
      product8.image="assets/products/cantena.jpg" ;
      product8.thumbnail="assets/products/cantena_sm.jpg" ;
      products.addItem( product8 );

      var product9 :ProductVO = new ProductVO();
      product9.id= 9 ;
      product9.name="TrackerPod" ;
      product9.description="TrackerPod is a small robotic tripod on which you mount a webcam, and TrackerCam is Artificial Intelligence software to control camera movement from your computer. Together they perform the function of a robotic camera-man for your webcam." ;
      product9.price= 129.99;
      product9.image="assets/products/trackerpod.jpg" ;
      product9.thumbnail="assets/products/trackerpod_sm.jpg" ;
      products.addItem( product9 );

      var product10 :ProductVO = new ProductVO();
      product10.id= 10 ;
      product10.name="Caffeinated Sauce" ;
      product10.description="After months of sleepless nights, we finally came up with something we could bottle up and sell to the masses. A hot sauce (extremely hot btw) that tastes great and has caffeine in it!" ;
      product10.price= 6.99;
      product10.image="assets/products/hotsauce.jpg" ;
      product10.thumbnail="assets/products/hotsauce_sm.jpg" ;
      products.addItem( product10 );

      var product11 :ProductVO = new ProductVO();
      product11.id= 11 ;
      product11.name="Thinking Putty" ;
      product11.description="The Ultimate Stress Reduction office toy is here. Of course you remember playing with putty as a kid. Welp, this aint your kids putty. Adult sized, and as feature-rich as your favorite Operating System, the Smart Mass putty from ThinkGeek makes living life fun all over again." ;
      product11.price= 11.99;
      product11.image="assets/products/putty.jpg" ;
      product11.thumbnail="assets/products/putty_sm.jpg" ;
      products.addItem( product11 );

      var product12: ProductVO = new ProductVO();
      product12.id= 12 ;
      product12.name="Ambient Orb" ;
      product12.description="The Ambient Orb is a device that slowly transitions between thousands of colors to show changes in the weather, the health of your stock portfolio, or if your boss or friend is on instant messenger. It is a simple wireless object that unobtrusively presents information." ;
      product12.price= 149.99;
      product12.image="assets/products/orb.jpg" ;
      product12.thumbnail="assets/products/orb_sm.jpg" ;
      products.addItem( product12 );

      var product13 :ProductVO = new ProductVO();
      product13.id= 13 ;
      product13.name="USB Microscope" ;
      product13.description="The USB connected Computer Microscope allows you to turn the ordinary into the extraordinary for hours of fun and learning. View specimens collected around the house, backyard, your desk, or the fridge. Look at the micro-printing on a dollar bill or examine the traces on your motherboard." ;
      product13.price= 54.99;
      product13.image="assets/products/microscope.jpg" ;
      product13.thumbnail="assets/products/microscope_sm.jpg" ;
      products.addItem( product13 );

      var product14 :ProductVO = new ProductVO();
      product14.id= 14 ;
      product14.name="Flying Saucer" ;
      product14.description="The flying saucer his surpisingly quiet during operation and so sneaking up on your fellow co-workers is quite easy. The multi-controller Transmitter modulates the thrust from each propeller independently allowing you to take off and land vertically, spin in place, and fly in all directions!" ;
      product14.price= 69.99;
      product14.image="assets/products/ufo.jpg" ;
      product14.thumbnail="assets/products/ufo_sm.jpg" ;
      products.addItem( product14 );

      var product15 :ProductVO = new ProductVO();
      product15.id= 15 ;
      product15.name="Levitating Globe" ;
      product15.description="These electromagnetic suspended globes are actually high-tech instruments. A magnetic field sensor permanently measures the height at which the globes are suspended. This sensor feeds that data into a micro computer in the base of the unit." ;
      product15.price= 89.99;
      product15.image="assets/products/globe.jpg" ;
      product15.thumbnail="assets/products/globe_sm.jpg" ;
      products.addItem( product15 );

      var product16 :ProductVO = new ProductVO();
      product16.id= 16 ;
      product16.name="Personal Robot" ;
      product16.description="The ER1 is the first robot with professional-level robotics software technologies and industrial-grade hardware designed for enthusiasts, like you, who are interested in technology that takes advantage of your technical skills and your imagination." ;
      product16.price= 139.99;
      product16.image="assets/products/robot.jpg" ;
      product16.thumbnail="assets/products/robot_sm.jpg" ;
      products.addItem( product16 );

      return products;
    }
  }
}
