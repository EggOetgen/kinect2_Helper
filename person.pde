class person { 

  int id;
  PVector[] joints = new PVector[17];
  person (int userId) {  
   for (int i = 0; i < joints.length; i++) {
    joints[i] = new PVector();
}
  } 
  void update() { 
   
  } 

  void draw(int userId){
   for(int i = 0; i < joints.length; i++){
      PVector joint = new PVector();

      float confidence = kinect.getJointPositionSkeleton(userId, i, joint);
      if(confidence < 0.5) return;
      
      PVector convertedJoint = new PVector();
      kinect.convertRealWorldToProjective(joint, joints[i]);

       ellipse(joints[i].x, joints[i].y, 50, 50);
       
       String mesName = str(userId) + "/"+str(i);
       OscMessage msgOsc = new OscMessage(mesName);
       msgOsc.add(joints[i].x/width); 
       msgOsc.add(joints[i].y/height);
        osc.send(msgOsc, dest);
  }
    rect(100,100,35,60);
  }
} 