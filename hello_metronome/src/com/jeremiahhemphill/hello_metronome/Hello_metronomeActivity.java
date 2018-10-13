package com.jeremiahhemphill.hello_metronome;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;
import android.widget.ToggleButton;

public class Hello_metronomeActivity extends Activity implements OnClickListener, OnSeekBarChangeListener, OnCheckedChangeListener {
	Metronome metronome;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		Button startstop = (Button)findViewById(R.id.toggleStartStop);
		startstop.setOnClickListener(this);

		SeekBar beatsPerMinute = (SeekBar) findViewById(R.id.bpm);
		beatsPerMinute.setOnSeekBarChangeListener(this);
		
		ToggleButton eighthNoteSoundToggle = (ToggleButton) findViewById(R.id.eighthNoteSoundToggle);
		eighthNoteSoundToggle.setOnCheckedChangeListener(this);

		int initial_bpm = 60;
		metronome =  new Metronome((Activity)this, initial_bpm);
		beatsPerMinute.setProgress(initial_bpm);

	}

	public void onClick(View v) {
		if(metronome.isRunning())  {
			metronome.stop();
		} else {
			metronome.start();
		}
	}

	public void onProgressChanged(SeekBar beatsPerMinute, int position, boolean arg2) {
		TextView beatsPerMinuteDisplay = (TextView)findViewById(R.id.bpmDisplay);
		beatsPerMinuteDisplay.setText(position + "");
		metronome.changeBeatsPerMinute(position);
	}

	public void onStartTrackingTouch(SeekBar beatsPerMinute) {
		// TODO Auto-generated method stub
	}

	public void onStopTrackingTouch(SeekBar beatsPerMinute) {
		// TODO Auto-generated method stub
	}

	public void onCheckedChanged(CompoundButton button, boolean isChecked) {
		switch(button.getId())  {
		case R.id.eighthNoteSoundToggle:
			metronome.eighthNoteSoundToggle(isChecked);
			break;
		}
	}
}
