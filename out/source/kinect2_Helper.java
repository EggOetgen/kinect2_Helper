import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import SimpleOpenNI.*; 
import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class kinect2_Helper extends PApplet {





OscP5 osc;
NetAddress dest;
SimpleOpenNI kinect;

person percy = new person(0);
PVector[] joints = new PVector[17];

public void setup() {
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 kinect.enableUser();// this changed
 
 fill(255, 0, 0);
  for (int i = 0; i < joints.length; i++) {
  joints[i] = new PVector();
}
  osc = new OscP5(this,8000);

  dest = new NetAddress("127.0.0.1",6448);
}

public void draw() {
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
      //drawLimbs(userId);
      //updateUserJoints(userId);
      println(userId);
      percy.draw(userId);
      // PVector joint = new PVector();

      // float confidence = kinect.getJointPositionSkeleton(userId, i, joint);
      // if(confidence < 0.5){
      //    return;
      // }
      
      // PVector convertedJoint = new PVector();
      // kinect.convertRealWorldToProjective(joint, joints[0]);
      // for(int i = 0; i < joints.length; i++)
      // {
      //   ellipse(joints[i].x, joints[i].y, 50, 50);
      // }
    }
  }

  message(msg);
  
}


public void drawLimbs(int userId) 
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

public void drawJoints(int userId, int jointID)
{
 PVector joint = new PVector();

 float confidence = kinect.getJointPositionSkeleton(userId, jointID,joint);
 if(confidence < 0.5f){
   return;
 }
 PVector convertedJoint = new PVector();
 kinect.convertRealWorldToProjective(joint, convertedJoint);
 ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
}

//Calibration not required

public void updateUserJoints(int userId)
{

  for(int i = 0; i < joints.length; i++){
      PVector joint = new PVector();

      float confidence = kinect.getJointPositionSkeleton(userId, i, joint);
      if(confidence < 0.5f) return;
      
      PVector convertedJoint = new PVector();
      kinect.convertRealWorldToProjective(joint, joints[i]);

       ellipse(joints[i].x, joints[i].y, 50, 50);
       
       String mesName = str(userId) + "/"+str(i);
       OscMessage msgOsc = new OscMessage(mesName);
      msgOsc.add(joints[i].x/width); 
       msgOsc.add(joints[i].y/height);
      osc.send(msgOsc, dest);
  }
}

public void calculateJointPoint()
{


}

public void onNewUser(SimpleOpenNI kinect, int userID)
{
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}

public void message(String msgTxt)
{

  textSize(32);
  fill(255,0,0);
  text(msgTxt, 10, 30);

}
class person { 

  int id;
  PVector[] joints = new PVector[17];
  person (int userId) {  
   for (int i = 0; i < joints.length; i++) {
    joints[i] = new PVector();
}
  } 
  public void update() { 
   
  } 

  public void draw(int userId){
   for(int i = 0; i < joints.length; i++){
      PVector joint = new PVector();

      float confidence = kinect.getJointPositionSkeleton(userId, i, joint);
      if(confidence < 0.5f) return;
      
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
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "kinect2_Helper" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
