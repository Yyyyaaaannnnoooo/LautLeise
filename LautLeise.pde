
import ddf.minim.analysis.*; 
import ddf.minim.*;
FFT fft;
Minim minim;
AudioInput in;
AudioRecorder recorder;
AudioPlayer player;
float amp = 15, ampWave = 10*amp, avgAudio;
void setup() {
  size(512, 200, P3D);
  minim = new Minim(this);
  in = minim.getLineIn();  
  fft = new FFT(in.bufferSize(), in.sampleRate());  
  fft.logAverages(22, 3);
  recorder = minim.createRecorder(in, "myrecording.wav");
  textFont(createFont("Arial", 12));
}

void draw() {
  background(0); 
  stroke(255);
  for (int i = 0; i < in.bufferSize() - 1; i++) {
    line(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
    line(i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
  }

  if (recorder.isRecording()) {
    text("Currently recording...", 5, 15);
    fft.forward(in.mix);
    for (int i = 0; i < fft.avgSize(); i++) {  
      avgAudio+= abs(fft.getAvg(i)*amp);
    }    
    avgAudio /= fft.avgSize();
  } else {
    text("Not recording.", 5, 15);
  }
}

void keyReleased()
{
  if ( key == 'r' ) { 
    if ( recorder.isRecording() ) {
      recorder.endRecord();
    } else {
      recorder = minim.createRecorder(in, "myrecording.wav");
      recorder.beginRecord();
    }
  }
  if ( key == 's' ) {
    recorder.save();    
    player = minim.loadFile(sketchPath("") + "myrecording.wav");
    player.shiftGain(player.getGain(), -20.0, 50);
    player.play();
    println("Done saving.");
  }
}