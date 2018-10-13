package com.jeremiahhemphill.hello_metronome;

import java.util.HashMap;
import java.util.Timer;
import java.util.TimerTask;

import android.app.Activity;
import android.content.Context;
import android.media.AudioManager;
import android.media.SoundPool;
import android.os.SystemClock;
import android.util.Log;

public class Metronome {
	private SoundPool soundPool;
	private AudioManager audioManager;
	private HashMap<Integer, Integer> soundPoolMap;
	private final int HIGH_CLICK = 1;
	private final int LOW_CLICK = 2;
	private final int AWESOME_CLICK = 3;

	private boolean quarterNoteSound = false;
	private boolean eighthNoteSound = true;
	private boolean tripletNoteSound = false;
	private boolean sixteenthNoteSound = false;

	private boolean running;
	private int beatsPerMinute;
	private int delayPerBeat;

	private Timer timer;
	private TimerTask timerTask;

	public Metronome(Activity activity, int bpm)  {

		running = false;
		setBeatsPerMinute(bpm);
		setupTimer();

		audioManager = (AudioManager) activity.getSystemService(Context.AUDIO_SERVICE);
		soundPool = new SoundPool(8, AudioManager.STREAM_MUSIC, 0);
		soundPoolMap = new HashMap<Integer, Integer>();
		soundPoolMap.put(HIGH_CLICK, soundPool.load(activity, R.raw.high_click, 1));
		soundPoolMap.put(LOW_CLICK, soundPool.load(activity, R.raw.low_click, 1));
		soundPoolMap.put(AWESOME_CLICK, soundPool.load(activity, R.raw.click, 1));

		//sets volume based on device volume
		//float streamVolumeCurrent = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC);
		//float streamVolumeMax = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
		//float volume = streamVolumeCurrent / streamVolumeMax; 
	}

	private void setBeatsPerMinute(int bpm)  {
		beatsPerMinute = bpm;
		//divide the beat delay by 12 to handle sub beats (eighth notes)
		delayPerBeat = (int)((60.0 / bpm) * 1000 / 12);
		Log.e("beats per minute", "" + delayPerBeat);
	}
	
	private boolean shouldPlayQuarterNote(int subBeat)  {
		if(quarterNoteSound)  {
			if(subBeat == 1)  {
				return true;
			}
		}
		return false;
	}
	
	private boolean shouldPlayEighthNote(int subBeat)  {
		if(eighthNoteSound)  {
			if(subBeat == 1 && !quarterNoteSound)  {
				return true;
			}
			if(subBeat == 6)  {
				return true;
			}
		}
		return false;
	}
	
	private boolean shouldPlayTripletNote(int subBeat)  {
		if(tripletNoteSound)  {
			if(subBeat == 1 && !quarterNoteSound && !eighthNoteSound && !sixteenthNoteSound)  {
				return true;
			}
			if(subBeat == 4 || subBeat == 8)  {
				return true;
			}
		}
		return false;
	}
	
	private boolean shouldPlaySixteenthNote(int subBeat)  {
		if(sixteenthNoteSound)  {
			if(subBeat == 1 && !quarterNoteSound && !eighthNoteSound)  {
				return true;
			}
			if(subBeat == 6 && !eighthNoteSound)  {
				return true;
			}
			if(subBeat == 3 || subBeat == 9)  {
				return true;
			}
		}
		return false;
	}
	
	private void setupTimer()  {
		timer = new Timer("MetronomeTimer", true);
		timerTask = new TimerTask(){
			private int subBeat = 0;
			private final int subBeatsPerBeat = 12;
		     @Override
		     public void run(){
		    	 if(running)  {
		    		 subBeat++;
		    		 
		    		 //Log.e("delay", delayPerBeat + "");

		    		 Log.e("subBeat number", subBeat + "");
		    		 if(shouldPlayQuarterNote(subBeat))  {
		    			 //Log.e("quarter note", subBeat + "");
		    			 soundPool.play(soundPoolMap.get(HIGH_CLICK), 1, 1, 1, 0, 1f);
		    		 } else if(shouldPlayEighthNote(subBeat))  {
		    			 //Log.e("eighth note", subBeat + "");
		    			 soundPool.play(soundPoolMap.get(LOW_CLICK), 1, 1, 1, 0, 1f);
		    		 } else if(shouldPlayTripletNote(subBeat))  {
		    			 //Log.e("triplet note", subBeat + "");
		    			 soundPool.play(soundPoolMap.get(HIGH_CLICK), 1, 1, 1, 0, 1f);
		    		 } else if(shouldPlaySixteenthNote(subBeat))  {
		    			 //Log.e("sixteenth note", subBeat + "");
		    			 soundPool.play(soundPoolMap.get(LOW_CLICK), 1, 1, 1, 0, 1f);
		    		 }
		    		 
		    		 if(subBeat >= subBeatsPerBeat)  {
		    			 //Log.e("resetting","");
		    			 subBeat = 0;
		    		 }
		    	 }
		     }
		};
		timer.scheduleAtFixedRate(timerTask, 0, delayPerBeat); 
	}

	public boolean isRunning()  {
		return running;
	}

	public void start()  {
		running = true;
		setupTimer();
	}

	public void stop()  {
		running = false;
		timer.cancel();
	}

	public void changeBeatsPerMinute(int bpm)  {
		setBeatsPerMinute(bpm);
		timer.cancel();
		if(running)  {
			setupTimer();
		}
	}

	public void eighthNoteSoundToggle(boolean on)  {
		eighthNoteSound = on;
	}
}
