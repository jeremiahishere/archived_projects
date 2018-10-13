package com.jeremiahhemphill.hello_metronome;

import android.app.Application;

public class HelloMetronomeApplication extends Application {
	
	//defining our own application stops the activity from reinitializing when the device is rotated
	public void onCreate()  {
		super.onCreate();
	}

}
