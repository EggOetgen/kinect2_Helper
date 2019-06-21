import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress dest;

class person { 
  int destPort = 6448;
  int id;

  PVector[] joints    = new PVector[numJoints];
  boolean[] sendJoint = new boolean[numJoints];
 
                         
  person (int userId) {  

    id = userId;
    
    osc  = new OscP5(this, 8000);
    dest = new NetAddress("127.0.0.1", destPort);

    for (int i = 0; i < numJoints; i++) {
      joints[i] = new PVector();
      sendJoint[i] = true;
    }

    OscMessage msgOsc = new OscMessage("ConnectionMade");
   
 //   msgOsc.add(destPort);

    //OscP5.flush(msgOsc, dest);
     osc.send(msgOsc, dest);
  } 

  void update() {
  } 

  void draw(int userId) {
    for (int i = 0; i < numJoints; i++) {
      PVector joint = new PVector();

      float confidence = kinect.getJointPositionSkeleton(userId, i, joint);
      if (confidence < 0.5) return;

      //PVector convertedJoint = new PVector();
      kinect.convertRealWorldToProjective(joint, joints[i]);
      if (sendJoint[i]) {      
        fill(0, 255, 0);
        ellipse(joints[i].x, joints[i].y, 40, 40);
      } else {      
        fill(255, 0, 0);
        ellipse(joints[i].x, joints[i].y, 30, 30);
      }
    }
  }


  PVector returnJoint(int jointId) {
    return joints[jointId];
  }

  void updateJoint(int jointId, boolean shouldSend) {
    sendJoint[jointId] = shouldSend;
  }

  void sendSkeletonData() {
    for (int i = 0; i < numJoints; i++) {

      if (!sendJoint[i]) {
        
        String mesName = "/"+str(id) + "/"+jointNames[i];
println(mesName);
        OscMessage msgOsc = new OscMessage(mesName);
        msgOsc.add(joints[i].x/width); 
        msgOsc.add(joints[i].y/height);
        //msgOsc.add("tet");

        //OscP5.flush(msgOsc, dest);
        //// osc.send(msgOsc, dest);
        

         //   msgOsc.add(destPort);

         //  OscP5.flush(msgOsc, dest);
         osc.send(msgOsc, dest);
      }
    }
  }
} 
