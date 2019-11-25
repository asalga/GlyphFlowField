
char ch = ' ';
PGraphics gfx = null;
Particle[] particles;

float[] x;
float[] y;
float[] c;
float aniC = 0;
float [][] noiseLUT;
CreateClass createObj;
boolean createKey = false;
boolean created = false;
int currWord = -1;
String[] words = {
  "love", 
  "fear", 
  "hate",
  "pain",
};

void initNoiseLUT(int w, int h) {

  noiseSeed(millis());

  if (currWord== 0) {
    noiseDetail(4, 0.5);
  } else if (currWord == 1) {
    noiseDetail(1, 4);
  } else if (currWord == 2) {
    noiseDetail(2, 2);
  } else {
    noiseDetail(1, 1);
  }

  int _w = w;
  int _h = h;

  noiseLUT = new float[_w][_h];

  for (int i = 0; i < _w; i++) {
    //noiseLUT[i] = new float[_we];
    for (int j = 0; j < _h; j++) {
      noiseLUT[i][j] = noise(i/100.0, j/100.0);
    }
  }
}

void setup() {
  size(1080, 608, P3D);
  gfx = createGraphics(800, 600);
  createObj = new CreateByArray();
  createObj.setMask(color(0, 255, 0));

  initNoiseLUT(width, height);

  //for (int i = 0; i < Count; i++) {
  //  x[i] = random(0, w);
  //  y[i] = random(0, h);
  //}

  //particles = new Particle[10000];
  //for(int i = 0; i < 10000; i++){
  //  particles[i] = new Particle();
  //}
}

void createParticlesFromImage(PGraphics pg, CreateClass obj) {
  initNoiseLUT(width, height);

  obj.setImage(pg);

  int cnt = 0;
  for (int i = 0; i < pg.width * pg.height; i++) {
    if (int(obj.mask) != int(pg.pixels[i]) ) {
      cnt++;
    }
  }
  println(cnt);

  x = new float[cnt];
  y = new float[cnt];
  c = new float[cnt];
  int _idx = 0;

  for (int i = 0; i < pg.width * pg.height; i++) {
    int _x = i % pg.width;
    int _y = int(i / pg.width); 

    // TODO: improve check mask with threshold
    if (int(obj.mask) != int(pg.pixels[i]) ) {
      obj.createGrid(_x, _y);
      x[_idx] += width/2 -gfx.width/2;
      y[_idx] += height/2 - gfx.height/2;
      c[_idx] = 255.0;
      _idx++;
    }
    // PVector pvec = obj.create(x,y);
    // obj.createSpiral(x,y);
  }
}  

void drawFPS() {
  noStroke();
  fill(255);
  text(frameRate, 30, 30);
  text(aniC, 30, 50);
}

void draw() {
  noStroke();
  
  background(0);
  //fill(0, 20);
  //rect(0, 0, width, height);
  
  if(currWord == 2){
    background(0);
  }
  drawFPS();

  // translate(width/2, height/2);

  if (createKey && !created) {
    println("created!");

    gfx.beginDraw();
    gfx.fill(255);
    gfx.noStroke();
    gfx.textAlign(CENTER, CENTER);
    ///////////////////////////////////////////////////////// textSize
    gfx.textSize(170);
    gfx.background(0, 255, 0);

    String str = "00:" + int((millis()/1000.0));

    gfx.text(words[currWord], gfx.width/2, gfx.height/2 - gfx.textDescent()+ 10);
    gfx.endDraw();

    // image(gfx, 0, 0);
    stroke(255);

    created = true;
    gfx.loadPixels();
    //int cnt = gfx.width * gfx.height;
    createObj.reset();
    createParticlesFromImage(gfx, createObj);
  }

  if (created) {
    stroke(255);
    createKey = false;

    float scl = 0.001;
    
    for (int i = 0; i < x.length; i++) {
      int _ix = int(x[i]);
      int _iy = int(y[i]);

      // prevent a very horizontal feel of particles spreading out

      if (_ix > -1 && _ix < width && _iy > -1 && _iy < height) {
        float n = noiseLUT[_ix][_iy] * 2.0;
        float _rx= 0, _ry = 0, _c = 0;

        // flow
        if (currWord == 0) {
          _rx = (cos(n * TAU))  * aniC/1000.0 + random(-0.15, 0.15);
          _ry = (sin(n * TAU))  * aniC/1000.0 + random(-0.15, 0.15);
          _c = aniC/400.0 * n + random(0, 3);
        }
        // spread
        else if (currWord == 1) {
          //float _rx = (cos(n * TAU) * aniC/1500.0);//+ aniC/15.0 * random(-.5, 0.5);
          _rx = (cos(n * TAU) * aniC/350.0 ) + aniC/100.0 * random(-0.5, 0.5);
          _ry = (sin(n * TAU) * aniC/350.0 ) + aniC/100.0 * random(-0.5, 0.5);
          //float _ry = (sin(n * TAU) * aniC/200.0 * (y[i]-400.0)*0.01); 
          _c = aniC/450.0 * n * 3.0 + random(0, 2.51);
        }
        // creep
        else if (currWord == 2) {
          
          float aniOffset = 2000.0;
          
          float nx = (noise(_ix/400.0) * 2 -1.0) * 120.0;
          if (_iy + nx < (aniC+aniOffset)/10.0) {
            _rx = cos(n * TAU) * (aniC+aniOffset)/2000.0;
            _ry = sin(n * TAU) * (aniC+aniOffset)/2000.0; 
            _c = n * 8.0;
          }
        } else {
          float aniOffset = -300;
          
          aniC = min(2000.0, aniC);
          
          _rx = cos(n * 4.0 * TAU) * (aniC+aniOffset)/140.0;
          _ry = sin(n * 4.0 * TAU) * (aniC+aniOffset)/140.0;// * (y[i]-400.0)*0.01; 
          _c = aniC/500.0;// + random(3,5);
        }

        stroke(c[i]);
        x[i] += _rx;
        y[i] += _ry;
        c[i] -= _c;
      }
      point(x[i], y[i]);
    }
  }

  aniC += 25.0;
}

void keyPressed() {
  ch = key;
  aniC = 250;
  createKey = true;
  created = false;
  currWord++;

  if (currWord == words.length) {
    currWord = 0;
  }
  //println(ch);
}


//translate(w/2, h/2);
//for(int i = 0; i < 25000; i++){
//int x = int(random(0, w));
//int y = int(random(0,h));
//int x = int(random(0, w));
//int y = int(random(0,h));
//stroke(255, 255, 0);
//point(x,y);
//ellipse(x,y,10,10);
//}