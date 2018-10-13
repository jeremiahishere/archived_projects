package com.cloudspace.hellotuner;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.view.SurfaceView;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;

public class MainActivity
extends Activity
implements OnClickListener {

	private SoundListener listener = new SoundListener();
	private boolean running = false;
	Handler decibelUpdateHandler;
	Runnable decibelUpdateCallback;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		SurfaceView waveformView = (SurfaceView)findViewById(R.id.waveformView);
		
		Button start = (Button)findViewById(R.id.start);
		start.setOnClickListener(this);
		decibelUpdateHandler = new Handler(Looper.getMainLooper());
		decibelUpdateCallback = new Runnable() {
			public void run() {
				updateCurrentDecibel();
			}
		};
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.activity_main, menu);
		return true;
	}

	public void onClick(View v) {
		switch(v.getId())  {
		case R.id.start:
			toggleSoundListening(v);
			break;
		}		
	}   

	private void toggleSoundListening(View v)  {
		if(running)  {
			stopSoundListening(v);
		} else {
			startSoundListening(v);
		}
		running = !running;
	}
	private void stopSoundListening(View v)  {
		listener.stop();

		Button button = (Button) v;
		button.setText(getResources().getString(R.string.start));

		decibelUpdateHandler.removeCallbacks(decibelUpdateCallback);
	}

	private void updateCurrentDecibel() {		
		int currentDecibels = listener.getCurrentDecibels();
		Log.e("current decibels from frontend", currentDecibels + "");
		
		TextView dBCurrent = (TextView)findViewById(R.id.dBText);
		dBCurrent.setText(String.valueOf(currentDecibels));
		
		ProgressBar dBProgressBar = (ProgressBar)findViewById(R.id.dBProgressBarOutput);
		dBProgressBar.setProgress(currentDecibels);
		
		decibelUpdateHandler.post(decibelUpdateCallback);
	}

	private void startSoundListening(View v)  {
		listener.start();
		Button button = (Button) v;
		button.setText(getResources().getString(R.string.stop));
		
		decibelUpdateHandler.post(decibelUpdateCallback);
	}
}
