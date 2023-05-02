// Author: Tae Young Moon, Ben Morgan

// file containing two possible methods of running the simulation in VR: one at constant speed and one where the speed
// is variable with the movement speed of the user.




//////////////////////////////////////////////////
//                                              //
//             VIDEO SPEED CONTROLLER           //
//        ADVANCED  [variable speed + idle]     //
//                                              //
//////////////////////////////////////////////////

//
//The following code monitors the speed at which the player walks and uses this to control the
//speed of the video. If the player is not moving it sets teh playback speed to a slow idle speed
//The video only plays forwards when the user walks forwards
//

// using System.Collections;
// using System.Collections.Generic;
// using UnityEngine;
// using UnityEngine.Video;
// using UnityEngine.XR;

// //defines a video controller class
// public class VideoController : MonoBehaviour;
// {
//     public VideoPlayer videoPlayer;
//     public float idleSpeedThreshold = 0.05f;//a threshold that if the player speed is below the player is considered to be  still
//     public float idleSpeed = 0.3f;//the minimum playback speed. (when the player speed is 0 the video still plays at this speed)

//     //a vector which stores the position of the headset and a float for time
//     private Vector3 lastHeadsetPosition;
//     private float lastHeadsetPositionTime;

//     //A method which is parsed a speed uses this to set the speed of the video
//     public void SetPlaybackSpeed(float speed)
//     {
//         //sets the playback speed
//         videoPlayer.playbackSpeed = speed;
//         //Debug.Log("Playback speed set to " + speed);
//     }

//     // Start is called before the first frame updates
//     void Start()
//     {
//         //sets the starting speed to the idle speed
//         SetPlaybackSpeed(idleSpeed);
//         //initilises the motion tracking
//         lastHeadsetPosition = InputTracking.GetLocalPosition(XRNode.Head);
//         lastHeadsetPositionTime = Time.time;
//     }

//     // Update is called once per frame
//     void Update()
//     {
//         // Gets the postion vector for the headset and calculates the time that has elapsed
//         Vector3 headsetPosition = InputTracking.GetLocalPosition(XRNode.Head);
//         float timeSinceLastHeadsetPosition = Time.time - lastHeadsetPositionTime;

//         //uses speed = distance/time to  calculate the speed of the headset
//         float speed = (headsetPosition - lastHeadsetPosition).magnitude / Mathf.Max(timeSinceLastHeadsetPosition, Time.deltaTime);
//         Debug.Log("speed: " + speed);

//         // Calculates the direction of the headset movement
//         Vector3 direction = headsetPosition - lastHeadsetPosition;
//         direction.y = 0;
//         direction.Normalize();

//         //Creates a variable which stores the speed which will be used to set the video player speed
//         //float calculated_speed = speed;
        
//         //sets the calculated speed to zero if the player is moving backwards
//         if (Vector3.Dot(direction, Vector3.forward) < 0)
//         {
//             //calculated_speed = 0;
//             speed = 0 ;
//         }
//         Debug.Log("calculated_speed: " + speed);


//         // Check if the headset is nearly still
//         if ((timeSinceLastHeadsetPosition > 0) && ((speed < idleSpeedThreshold)&&(speed>(idleSpeedThreshold*-1.0f)))) {
//             //if the headset is neary still the video speed is set to the idel speed
//             SetPlaybackSpeed(idleSpeed);
//         } 
        
//         else {
//             //multiplies the players speed by a factor to make it appropriate
//             SetPlaybackSpeed(speed*4.0f);
//             Debug.Log("Setting Playback Speed to : " + speed*4.0f);
//         }

//         // Update last headset position and time
//         lastHeadsetPosition = headsetPosition;
//         lastHeadsetPositionTime = Time.time;
//     }
// }



///////////////////////////////////////////////
//                                           //
//          VIDEO SPEED CONTROLLER           //
//           BASIC  [single speed]           //
//                                           //
///////////////////////////////////////////////

//uncomment for a video player which plays the video at onen set speed which you define

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class VideoController : MonoBehaviour
{
    
    public VideoPlayer videoPlayer;

    // Use this method to set the playback speed
    public void SetPlaybackSpeed(float speed)
    {
        videoPlayer.playbackSpeed = speed;
        Debug.Log("Playback speed set to " + speed);
        videoPlayer.playbackSpeed = speed;
    }
    
    
    
    // Start is called before the first frame update
    void Start()
    {
        SetPlaybackSpeed(1f);
    }

    // Update is called once per frame
    void Update()
    {

    }
}