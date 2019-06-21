import controlP5.*;

class GUI {
  ControlP5 cp5;
  Toggle[] toggles = new Toggle[numJoints];
  boolean[] toggleVals = new boolean[numJoints];


  GUI(PApplet thePApplet) {

    cp5 = new ControlP5(thePApplet);

    addSkelGroup(100,  10);
  

    //Group person1 = cp5.addGroup("g1")
    //            .setPosition(0,10)
    //            .setBackgroundHeight(togHeight*6)
    //            .setWidth((togWidth * 6) )
    //            .setBackgroundColor(color(127,200))
    //            ;
    //for (int i = 0; i < numJoints/5; ++i){
    //  for (int j = 0; j < 5; ++j){

    //    int element = (i*5+j);
    //    toggles[element] = cp5.addToggle(jointNames[element])
    //                          .setPosition( (j * (togWidth+2)) + 20  ,i *togWidth)
    //                          .setSize( togWidth, togHeight)
    //                          .setValue(false)
    //                          .setGroup(person1)
    //                          ;
    //     //cp5.addToggle("test");
    //     println(i + "  " + " " + j +" " + (i*5+j));
    //  }
    //  }
  }

  void update() {
  }

  boolean returnToggleValue( int toggleID) {
    println(toggles[toggleID].getBooleanValue());
    return toggles[toggleID].getBooleanValue();
  }

//  void add

  void addSkelGroup(int x, int y) {
    int togWidth = 40;
    int togHeight = 25;
    
    Group jointTogs = cp5.addGroup("Toggle Joints")
      .setPosition(x, y)
      .setBackgroundHeight(togHeight*6)
      .setWidth((togWidth * 6) )
      .setBackgroundColor(color(127, 200))
      ;
    for (int i = 0; i < numJoints/5; ++i) {
      for (int j = 0; j < 5; ++j) {

        int element = (i *5+j) ;
        toggles[element] = cp5.addToggle(jointNames[element])
          .setPosition( (j * (togWidth+2)) + 20, i *togWidth)
          .setSize( togWidth, togHeight)
          .setValue(false)
          .setGroup(jointTogs)
          ;
      }
    }
  }

}
