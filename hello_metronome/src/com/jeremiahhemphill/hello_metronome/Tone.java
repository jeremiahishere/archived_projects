package com.jeremiahhemphill.hello_metronome;

import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.os.Handler;

public class Tone {
	private final float duration = (float) 0.25; // seconds
    private final int sampleRate = 8000;
    private final int numSamples = Math.round(duration * sampleRate);
    private final double sample[] = new double[numSamples];
    private double freqOfTone = 440; // hz

    private final byte generatedSnd[] = new byte[2 * numSamples];
    
    Handler handler = new Handler();
    
    public Tone(double frequency){
    	freqOfTone = frequency;
    	genTone();

    }
    void genTone(){
        // fill out the array
        for (int i = 0; i < numSamples; ++i) {
            sample[i] = Math.sin(2 * Math.PI * i / (sampleRate/freqOfTone));
        }

        // convert to 16 bit pcm sound array
        // assumes the sample buffer is normalised.
        int idx = 0;
        for (final double dVal : sample) {
            // scale to maximum amplitude
            final short val = (short) ((dVal * 32767));
            // in 16 bit wav PCM, first byte is the low order byte
            generatedSnd[idx++] = (byte) (val & 0x00ff);
            generatedSnd[idx++] = (byte) ((val & 0xff00) >>> 8);

        }
    }

    void playSound(){
    	handler.post(new Runnable() {
    		public void run() {
		        final AudioTrack audioTrack = new AudioTrack(AudioManager.STREAM_MUSIC,
		                sampleRate, AudioFormat.CHANNEL_CONFIGURATION_MONO,
		                AudioFormat.ENCODING_PCM_16BIT, numSamples,
		                AudioTrack.MODE_STATIC);
		        audioTrack.write(generatedSnd, 0, generatedSnd.length);
		        audioTrack.play();
    		}
    	});
    }

}
