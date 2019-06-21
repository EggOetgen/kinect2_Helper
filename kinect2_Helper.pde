import SimpleOpenNI.*;
import oscP5.*;
import netP5.*;
//import controlP5.*;

SimpleOpenNI kinect;
//OscP5 osc;
//NetAddress dest;
//ControlP5 cp5;
GUI gui;

final int numJoints = 17;

person percy = new person(0);
PVector[] joints = new PVector[17];

void setup() {
 size(640, 480);
 fill(255, 0, 0);
  
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 kinect.enableUser();// this changed
 
 gui = new GUI(this);

  for (int i = 0; i < joints.length; i++) {
  joints[i] = new PVector();
}
  osc  = new OscP5(this,8000);
  dest = new NetAddress("127.0.0.1",6448);
}

void draw() {
  String msg = "I can't see anyone";
  
  kinect.update();
  image(kinect.depthImage(), 0, 0);
  
  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  if (userList.size() > 0) {

    msg = "I see something";
    int userId = userList.get(0);

    if ( kinect.isTrackingSkeleton(userId)) {
      msg = "I see you";
     
       for (int i = 0; i < numJoints; i++) {
          percy.updateJoint(i, gui.returnToggleValue(i));
       }
       
      
      percy.draw(userId);
      percy.sendSkeletonData();
  
    }
    
  }

  message(msg);
  
       //OscMessage msgOsc = new OscMessage("oeoeoe");
       //msgOsc.add("tet");
       
       //OscP5.flush(msgOsc, dest);
}


void drawLimbs(int userId) 
{
 stroke(0);
 strokeWeight(5);

 kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
}

void drawJoints(int userId, int jointID)
{
 PVector joint = new PVector();

 float confidence = kinect.getJointPositionSkeleton(userId, jointID,joint);
 if(confidence < 0.5){
   return;
 }
 PVector convertedJoint = new PVector();
 kinect.convertRealWorldToProjective(joint, convertedJoint);
 ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
}

//Calibration not required

void updateUserJoints(int userId)
{

  
  for(int i = 0; i < joints.length; i++){
      PVector joint = new PVector();

      float confidence = kinect.getJointPositionSkeleton(userId, i, joint);
      if(confidence < 0.5) return;
      
      PVector convertedJoint = new PVector();
      kinect.convertRealWorldToProjective(joint, joints[i]);
    //if(gui.sendThisJoint(i)){
    //   ellipse(joints[i].x, joints[i].y, 50, 50);
       
    //   String mesName = str(userId) + " / "+str(i);
    //   OscMessage msgOsc = new OscMessage(mesName);
    //   msgOsc.add(joints[i].x/width); 
    //   msgOsc.add(joints[i].y/height);
    //  osc.send(msgOsc, dest);
    //   }
  }
}

void calculateJointPoint()
{


}

void onNewUser(SimpleOpenNI kinect, int userID)
{
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}

void message(String msgTxt)
{

  textSize(32);
  fill(255,0,0);
  text(msgTxt, 10, 30);

}
