class BannerDrawable implements Drawable {

	boolean[] state;
	float[] alpha;
	float w, noteHeight, x, y;
	int positiveColor, negativeColor;
	float negWeight, posWeight;

	BannerDrawable(float w, float noteHeight, int[] snapshot, int[] sorted, int negativeColor, int positiveColor, float negWeight, float posWeight) {
		this.w = w;
		this.noteHeight = noteHeight;
		this.positiveColor = positiveColor;
		this.negativeColor = negativeColor;
		state = new boolean[snapshot.length];
		alpha = new float[snapshot.length];
		int max = sorted[sorted.length-1];
		for(int i = 0; i < snapshot.length; i++) {
			state[i] = snapshot[i] == sorted[i];
			alpha[i] = (float)snapshot[i]/(float)max;
		}
		this.negWeight = negWeight;
		this.posWeight = posWeight;
	}

	public void setup() { }

	public void tick() {
	}

	public void draw() {
		pushMatrix();
		translate(x, y);
		pushStyle();
		noFill();
		strokeCap(SQUARE);
		for(int i = 0; i < state.length; i++) {
			float noteY = i * noteHeight + 0.5;
			float sw = state[i] ? posWeight : negWeight;
			int sc = state[i] ? positiveColor : negativeColor;
			if(false) {
				strokeWeight(sw);
				stroke(sc);
				line(0, noteY, w, noteY);
			}
			else if(true) {
				noStroke();
				fill(red(sc), green(sc), blue(sc), alpha(sc) * alpha[i]);
				rect(0, noteY, w, noteHeight);
			}
			else {
				noStroke();
				fill(red(sc), green(sc), blue(sc), alpha(sc) * alpha[i]);
				ellipse(0, noteY, w*alpha[i]*1.1f, noteHeight*alpha[i]*1.1f);
			}
		}
		popStyle();
		popMatrix();
	}

	public void place(Point p) {
		this.x = p.x;
		this.y = p.y;
	}

	public float getWidth() {
		return w;
	}

	public float getHeight() {
		return state.length * noteHeight;
	}
}
